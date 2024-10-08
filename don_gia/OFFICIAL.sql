--Pending:  tối ưu lại hằng số --> biến
-- #vde: có 3 cột CK_goi_dm( cột này được update từ 2 bảng danh mục gói),CK_GOI(được imp chung khi imp thuê bao từ các report),CK_GOI_TLDG( sẽ chọn max từ 2 cột trước), ngx: gói VD90 chu kỳ 1 tháng nhưng KH mua 6 tháng ở report sẽ có CK = 6 còn CK_DM = 1 để tính đúng thì lấy 6 tháng mà sau này còn thu hồi)

----insert PTM:
          --Import BRIS_PL1 trước SMRS(nv BH ONLINE và đại lý PTTT ?)
     insert into SSS_dgia_202408(nguon,ma_tb,username_kh,tenkieu_ld,thang_ptm,ngay_kh)
    select 'bris',ma_tb,case when USER_DKTT not in (select USER_LD from nhuy.userld_202408_goc) --userld_202408_goc: bảng user CCBS có đủ username của tháng, chứ username nv bán hàng đặt tùm lum thêm số 1 số 2 vô chịu ko map được manv
                        and (CONGCU_DKTT = ' Web-App MyVNPT' or CONGCU_DKTT = 'App DigiShop TNTTTB KIT') --#vde: when case vì kênh ngoài những TH này user kh là ở PBH ONL hoặc PTTT sẽ tính cho nv tiếp thị (trươc đó khi nv tiếp thị đem KH về rồi gọi cho PBHONL gọi video call thì nó kích cho PBHOL? )
            then MA_USER_TIEPTHI else USER_DKTT end,'ptm',thang, NGAY_KICH_HOAT
        from PL1_2024
            where thang = 202408
            and  ma_tb not in (select ma_tb from SSS_dgia_202408 where tenkieu_ld = 'ptm')
            ;
    -----------
    insert into SSS_dgia_202408(nguon,ma_tb,username_kh,tenkieu_ld,thang_ptm,ngay_kh)
    select 'smrs','84' || SUBSCRIBER_ID a, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
    from bscc_import_ptm_smrs 
    where thang = 202408
        and  '84' || SUBSCRIBER_ID not in (select ma_tb from SSS_dgia_202408 where tenkieu_ld = 'ptm');
    -----------
   
    insert into SSS_dgia_202408(nguon,ma_tb,username_kh,manv_ptm,tenkieu_ld,thang_ptm,ngay_kh)
    select 'luongtinh',somay,nguoi_gt,manv_ptm,'ptm',TO_NUMBER(TO_CHAR((ngay_ld), 'YYYYMM')),ngay_ld
    from TTKD_BSC.DT_PTM_VNP_202408
    where goi_luongtinh is not null
    ;
----insert gói PTM:
    --bundle_xk
    insert into SSS_dgia_202408(nguon,ma_tb,username_kh,TEN_GOI,tenkieu_ld,tien_goi,thang_ptm,manv_ptm,ma_pb,ngay_kh,kenh_trong)    
    SELECT 'bundle_xuatkho', B.MA_TB, ACCOUNT_DK, LOAI_SIM,'ptm-goi', GIA_GOI, THANG_KH, MA_NV, MA_PB
        ,(select ngay_kh from SSS_dgia_202408 where tenkieu_Ld = 'ptm' and ma_tb=b.ma_tb), 1
    FROM (
            SELECT B.*, ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY seri DESC) AS row_num
            FROM manpn.BUNDLE_XUATKHO_PDH B
             WHERE B.THANG_KH = 202408
        ) B
       where
           B.row_num = 1
          and B.MA_TB IN (SELECT A.MA_TB FROM SSS_dgia_202408 A WHERE tenkieu_ld='ptm')
    ;
    ----IMPORT gói c?a kênh Digishop tr??c: https://digishop.vnpt.vn/digitalShop/stats/statsMobileDetail // ct sim so
    INSERT INTO SSS_dgia_202408 (thang_ptm,nguon, KENH_trong, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_sim', 1, 'ptm-goi', STB, GIA_GOI, TEN_GOI, MA_TIEPTHI
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO,thang
    FROM BSCC_DIGI
    WHERE THANG = 202408 
        and LOAI_TB like 'Tr_ tr__c' --tra truoc
        and TRANG_THAI = 'Thành công'
    AND STB IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm-goi');
    
    ----
    INSERT INTO SSS_dgia_202408 (THANG_ptm,nguon, KENH_TRONG, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_pac', 1, 'ptm-goi', STB, GIA_GOI, TEN_GOI, MA_GIOI_THIEU_DH
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO_DON,
        thang
    FROM BSCC_DIGI_DONLE
    WHERE THANG = 202408 and ngay_hoan_thanh is not null -- tại 1 tb có nhiều dòng gói giống nhau, nhưng chỉ có 1 dòng có ngay_ht là dky thành công
    AND STB  IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm_goi');
    
    -----
    INSERT INTO SSS_dgia_202408  (thang_ptm,tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi,  ngay_kh,thang_bd)
    SELECT thang,'ptm-goi',CASE WHEN MUC_CK = 0 THEN LOWER(KENH_XUAT_BAN) ELSE 'bundle' END,
                    B.MSISDN, ACCOUNT_DK, SERVICE_CODE, GIA_GOI, to_date(substr(NGAY_KH,1,instr(NGAY_KH, '2024')+3), 'mm/dd/yyyy'),thang                
    FROM BSCC_IMPORT_BUNDLE_SMRS_CT B
    WHERE B.THANG = 202408 
    AND B.MSISDN IN (SELECT A.MA_TB FROM SSS_dgia_202408  A WHERE tenkieu_ld='ptm')
        AND B.MSISDN NOT IN (SELECT MA_TB FROM SSS_dgia_202408 A WHERE tenkieu_ld='ptm-goi')
        ;
        --BRIS PL4:
    INSERT INTO SSS_dgia_202408 (tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi, THANG_ptm, ngay_kh,thang_bd) -- ko co chu -ky trong file
    SELECT 'ptm-goi',CASE WHEN KENH = 'Shop' then 'shop' ELSE 'bundle' END, '84'||B.SUBSCRIBER_ID, ACCOUNT_DK, TEN_GOI, GIA_GOI, THANG, NGAY_KH,thang
    FROM BSCC_IMPORT_BUNDLE_SMRS B
    WHERE THANG = 202408
    AND '84'||B.SUBSCRIBER_ID IN (SELECT A.MA_TB FROM SSS_dgia_202408 A WHERE tenkieu_ld='ptm')
    AND '84'||B.SUBSCRIBER_ID NOT IN (SELECT MA_TB FROM SSS_dgia_202408 A WHERE tenkieu_ld='ptm-goi');
    
    --bris
   INSERT INTO SSS_dgia_202408  ( thang_ptm,nguon, MA_TB, ten_goi, CK_GOI, tien_goi, -- bỏ cột loại _kênh
    username_kh, MANV_PTM, tenkieu_ld,  ngay_kh)
    
    SELECT  thang, LOWER(CONG_CU_BAN_GOI), SO_TB, MA_GOI, CHU_KY_GOI, DOANH_THU_BAN_GOI, USER_KENH_BAN, HRM_NV_BAN_GOI_NV_QLKENH_BAN,
     'ptm-goi', TO_DATE(NGAY_DK_GH_GOI,'YYYY-MM-DD HH24:MI:SS')
    FROM bscc_import_goi_bris
    WHERE HINH_THUC_TB = 'TT'
    AND THANG = 202408
    AND SO_TB IN (SELECT MA_TB FROM SSS_dgia_202408  WHERE tenkieu_ld='ptm')
    AND SO_TB NOT IN (SELECT MA_TB FROM SSS_dgia_202408  WHERE tenkieu_ld='ptm-goi'
                                            AND tien_goi > 0)
    AND SO_TB NOT IN (SELECT MA_TB FROM SSS_dgia_202408  WHERE tenkieu_ld='ptm-goi' and nguon = 'bundle_xuatkho');
    
    --=====
    INSERT INTO SSS_dgia_202408 (nguon, ma_tb, ten_goi, CK_GOI, tien_goi,
    username_kh, MANV_PTM,  tenkieu_ld,  ngay_kh)
    SELECT LOWER(CONG_CU_BAN_GOI), SO_TB, MA_GOI, CHU_KY_GOI, DOANH_THU_BAN_GOI,
    USER_KENH_BAN, HRM_NV_BAN_GOI_NV_QLKENH_BAN,  'ptm-goi',  TO_DATE(NGAY_DK_GH_GOI,'YYYY-MM-DD HH24:MI:SS')
    FROM bscc_import_goi_bris
    WHERE HINH_THUC_TB = 'TS' and thang = 202408
    AND SO_TB IN (SELECT SOMAY FROM TTKD_BSC.DT_PTM_VNP_202408 WHERE GOI_LUONGTINH IS NOT NULL) --??i tên b?ng
    ;
   
---UPDTAE manv_ptm:
     update SSS_dgia_202408 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202408 and b.USER_CCBS = a.username_kh)
        where manv_ptm is null
        ;
        update SSS_dgia_202408 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202408 and b.USER_CCOS = a.username_kh)
        where manv_ptm is null
        ;
        update SSS_dgia_202408 a
        set MANV_PTM = (select b.ma_nv from SSS_kenh_noi_bo b where b.thang = 202408 and b.SO_ELOAD = a.username_kh)
        where manv_ptm is null
        ;
        MERGE INTO SSS_dgia_202408 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = d.ma_diem_ban AND d.thang = 202408)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.manv_ptm IS NULL;
            
            MERGE INTO SSS_dgia_202408 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = to_char(d.so_eload) AND d.thang = 202408)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.manv_ptm IS NULL;
            
        UPDATE SSS_dgia_202408 a
        SET MANV_PTM = (
            SELECT b.ma_nv 
            FROM ttkd_bsc.nhanvien b
            WHERE username_kh = b.ma_nv and thang = 202408
        )
        WHERE a.manv_ptm IS NULL
        ;
        update SSS_dgia_202408  a
        set manv_ptm = (
                        select x.ma_nv from ttkd_bsc.nhanvien x
                        join nhuy.userld_202408_goc y
                            on x.mail_vnpt = y.email and x.thang = a.thang_ptm
                            where a.username_kh = y.user_ld
                )
        where manv_ptm is null
        ;
--===UPDATE thông tin nhân viên:
     update SSS_dgia_202408 a
        set (tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.manv_ptm)
    where tennv_ptm is null
       ;
         update SSS_dgia_202408 a
         set loai_ld = (select x.TENNHOM_TAT from  ttkd_bsc.dm_nhomld x where x.NHOMLD_ID = a.nhom_tiepthi)
         where a.loai_ld is null
        ;
        
---===UPDATE PHAN_LOAI_KENH:
        merge into SSS_dgia_202408 a
        using ttkd_bct.va_dm_loaikenh_bh x
        on (a.username_kh = x.ma_nd and x.thang = 202408)
        when matched then 
            update set a.phan_loai_kenh = x.phanloai_kenh
            where a.phan_loai_kenh is null
            ;
            
        UPDATE SSS_dgia_202408 a
        SET KENH_TRONG = 1
        WHERE EXISTS (
            SELECT 1
            FROM ttkd_bct.va_dm_loaikenh_bh b
            WHERE b.ma_nd = a.username_kh 
            AND b.thang = 202408 
            AND b.LOAIKENH = 'Nội bộ'
        );
        select  * from SSS_dgia_202408 where kenh_trong = 1 and tenkieu_ld = 'ptm-goi';
       --bundle xuat kho:

          update SSS_dgia_202408 a
                    set tien_goi = (select x.GIA_GOI_CO_VAT from va_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
                        ,DTHU_DONGIA_GOI = (select x.GIAGOI_SAUCK_COVAT from va_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
          where tien_goi is null
                    ;
       UPDATE SSS_dgia_202408 a
        SET bundle_xk = 1
        WHERE EXISTS (
            SELECT 1
            FROM manpn.BUNDLE_XUATKHO_PDH b
            WHERE b.ma_tb = a.ma_tb 
            AND b.THANG_KH  = 202408
        );
        update SSS_dgia_202408
        set heso_hhbg = 0.25
            ,heso_kk = 0.05
            ,TIEN_THULAO_DNHM = 20000
            ,TIEN_DNHM = 25000
            ,DTHU_DONGIA_DNHM = 20000
       where tenkieu_ld = 'ptm'
        ; 
        update SSS_dgia_202408
        set DTHU_DONGIA_GOI = tien_goi
            ,heso_kk = 0.05
            ,heso_hhbg = 0.25
       where tenkieu_ld = 'ptm-goi'
       ;
       
---=====UPDATE CHU KỲ GÓI
       UPDATE SSS_dgia_202408 a
        SET ck_goi = (
            SELECT x.CHU_KY 
            FROM vietanhvh.va_DM_KIT_BUNDLE x
            WHERE x.ten_goi = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.CK_goi IS NULL
        ;
        update SSS_dgia_202408 a
        set ck_goi = (select x.chu_ky_thang from vietanhvh.va_DM_GOICUOC_PHANKY x where  x.ten_goi= a.ten_goi )
        where CK_goi is null
        ;
        update SSS_dgia_202408 
        set ck_goi = 0
        where ten_goi in (select ten_goi from va_DM_GOICUOC_PHANKY where chu_ky_thang = 'N')
        ;


---====UPDATE CK_GOI_DM:
        UPDATE SSS_dgia_202408 a
        SET ck_goi_dm = (
            SELECT x.CHU_KY 
            FROM vietanhvh.va_DM_KIT_BUNDLE x
            WHERE x.ten_goi = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.ck_goi_dm IS NULL
        ;
        update SSS_dgia_202408 a
        set ck_goi_dm = (SELECT CASE 
                                WHEN x.chu_ky_thang = 'N' THEN 0 
                                ELSE TO_NUMBER(x.chu_ky_thang) 
                            END
                        FROM vietanhvh.va_DM_GOICUOC_PHANKY x
                        WHERE x.ten_goi = a.ten_goi )
        where ck_goi_dm is null
        ;
        update SSS_dgia_202408
        set ck_goi_dm = 0
        where ten_goi in (select ten_goi from va_DM_GOICUOC_PHANKY where chu_ky_thang = 'N')
        ;
        
---====UPDATE chu kỳ gói tính TLDG:
        UPDATE SSS_dgia_202408
        SET CK_GOI_TLDG = nvl(GREATEST(CK_GOI_DM, CK_GOI),0)
        WHERE CK_GOI_TLDG IS NULL;
    --==UPDTAE tháng kết thúc để tính lương thu hồi?
        update SSS_dgia_202408
        set thang_kt = to_number(to_char(add_months(ngay_kh, CK_GOI_TLDG),'yyyymm'))
        ;
        
  --==UPDATE tính tiền thù lao gói:      
        update SSS_dgia_202408
        set TIEN_THULAO_GOI = DTHU_DONGIA_GOI*HESO_HHBG 
        where CK_GOI_TLDG >= 1
        ;
--===== #vde LOẠI TRỪ các trường hợp
--PBH ONL: (các TB ptm có mua gói kích hoạt bởi nv PBHOL) OR (kích PTM GÓI) thì sẽ tính đơn giá. 
--          chỉ kích TB PTM --> 0 tính.

UPDATE SSS_dgia_202408_clone a
SET TIEN_THULAO_GOI = CASE
    -- Trường hợp 1: Cả hai dòng có cùng ma_pb = 'VNP0703000'
    WHEN EXISTS (
        SELECT 1 
        FROM SSS_dgia_202408 b
        WHERE a.ma_tb = b.ma_tb
          AND a.tenkieu_ld = 'ptm'
          AND b.tenkieu_ld = 'ptm-goi'
          AND a.ma_pb = 'VNP0703000'
          AND b.ma_pb = 'VNP0703000'
    ) THEN a.DTHU_DONGIA_GOI * a.HESO_HHBG

    -- Trường hợp 2: ptm-goi có ma_pb = 'VNP0703000' và ptm có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm-goi'
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1 
             FROM SSS_dgia_202408 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN a.DTHU_DONGIA_GOI * a.HESO_HHBG

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm'
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1 
             FROM SSS_dgia_202408 d
             WHERE a.ma_tb = d.ma_tb
               AND d.tenkieu_ld = 'ptm-goi'
               AND d.ma_pb <> 'VNP0703000'
         ) THEN 0

    -- Trường hợp còn lại không thay đổi
    ELSE a.TIEN_THULAO_GOI
END
, TIEN_THULAO_DNHM = CASE
    -- Trường hợp 1: Cả hai dòng có cùng ma_pb = 'VNP0703000'
    WHEN EXISTS (
        SELECT 1 
        FROM SSS_dgia_202408 b
        WHERE a.ma_tb = b.ma_tb
          AND a.tenkieu_ld = 'ptm'
          AND b.tenkieu_ld = 'ptm-goi'
          AND a.ma_pb = 'VNP0703000'
          AND b.ma_pb = 'VNP0703000'
    ) THEN TIEN_THULAO_DNHM

    -- Trường hợp 2: ptm-goi có ma_pb = 'VNP0703000' và ptm có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm-goi'
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1 
             FROM SSS_dgia_202408 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN TIEN_THULAO_DNHM

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm'
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1 
             FROM SSS_dgia_202408 d
             WHERE a.ma_tb = d.ma_tb
               AND d.tenkieu_ld = 'ptm-goi'
               AND d.ma_pb <> 'VNP0703000'
         ) THEN 0

    -- Trường hợp còn lại không thay đổi
    ELSE a.TIEN_THULAO_DNHM
END
;

--#vde: các trường hợp when case loại trừ ko tính  
   UPDATE SSS_dgia_202408
        SET TIEN_THULAO_GOI = 0,
            TIEN_THULAO_DNHM = 0,
            LYDO_KHONGTINH = CASE 
                                WHEN ma_pb = 'VNP0700800' THEN 'PTTT ko tinh'
                                WHEN BUNDLE_XK = 1 THEN 'Bundle_xk ko tinh don gia'
                                WHEN PHAN_LOAI_KENH = 'CTVXHH' THEN 'CTVXHH ko tinh don gia'
                                WHEN ten_goi in (select ten_goi from dm_goi_loai_tru ) then ten_goi ||' ko tinh'
                             END
        WHERE BUNDLE_XK = 1 
           OR ma_pb = 'VNP0700800' 
           OR PHAN_LOAI_KENH = 'CTVXHH'
           OR ten_goi in (select ten_goi from dm_goi_loai_tru);

select * from dual;

