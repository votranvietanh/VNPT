-- 7 nguồn báo cáo
select*from KPI_tonghop202408 where kenh_ban ='smrs';
select count(*) from SSS_dgia_202408 where thang = 202408;
select * from manpn.bscc_import_ptm_bris_pl01 where thang = 202408
and so_tb  in (select '84'||SUBSCRIBER_ID from bscc_import_ptm_smrs where thang = 202408);



select distinct loai_sim from manpn.bscc_import_ptm_bris_pl01;

select * from PL4_2024 where ma_tb = '84815584214';
select * from PL1_2024 where thang = 202408;
select * from SSS_dgia_202408;

delete from SSS_dgia_202408 where nguon ='digishop_sim'
;
select ma_tb from SSS_dgia_202408 where ma_tb in (select ma_tb from SSS_dgia_202408 group by ma_tb having count(ma_tb)>1)
;

drop table SSS_dgia_202408;
select *from ttkd_bct.va_dm_loaikenh_bh where thang = 202408;
select distinct LOAIKENH from ttkd_bct.va_dm_loaikenh_bh where thang = 202408;

select * from ttkd_bsc.ds_diemban_31import; --20256
desc SSS_dgia_202408;

----insert PTM:
       insert into SSS_dgia_202409(MA_TB, nguon, username_kh, thang_ptm, MANV_DKTT, tenkieu_ld, ngay_kh)
with cte as(
    SELECT TO_CHAR(SO_ELOAD) AS ELOAD, A.*
    FROM(
        SELECT case when INSTR(a.MA_NHANVIEN, '_') > 0 then UPPER(SUBSTR(a.MA_NHANVIEN, 1, INSTR(a.MA_NHANVIEN, '_')-1))
               else a.MA_NHANVIEN end ma_nv
            , A.*, ROW_NUMBER() OVER(PARTITION BY SO_ELOAD ORDER BY LOAI_DIEM_BAN DESC) RA
        FROM ttkd_bsc.ds_diemban_31import A
        WHERE THANG = 202409
        ) A
    WHERE RA = 1
    ),
    NVVV AS(
    SELECT UPPER(SUBSTR(MAIL_VNPT, 1, INSTR(MAIL_VNPT, '@')-1)) AS MAIL, C.* FROM (select * from ttkd_bsc.nhanvien where thang = 202409) C
    WHERE THANG = 202409
    )
select A.ma_tb, 'bris', c.ma_nv , A.THANG, A.MA_USER_TIEPTHI, 'ptm', NGAY_KICH_HOAT
from PL1_2024 a left join cte b on a.MA_USER_TIEPTHI = b.MA_DIEM_BAN
    left join NVVV C ON b.MA_Nv = C.MAIL AND C.THANG = 202409
    where a.thang = 202409
    and b.ma_diem_ban is not null
    and DIEM_CHAM_TIEPTHI in ('DIGISHOPAPP', 'App DigiShop TNTTTB KIT')
    and CONGCU_DKTT in ('SIMDONLE', 'App DigiShop TNTTTB KIT')
;
    -----------
    insert into SSS_dgia_202409(nguon,ma_tb,username_kh,tenkieu_ld,thang_ptm,ngay_kh)
    select 'smrs','84' || SUBSCRIBER_ID a, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
    from bscc_import_ptm_smrs
    where thang = 202409
        and  '84' || SUBSCRIBER_ID not in (select ma_tb from SSS_dgia_202409 where tenkieu_ld = 'ptm');
    -----------
    insert into SSS_dgia_202409(nguon,ma_tb,username_kh,manv_dktt,tenkieu_ld,thang_ptm,ngay_kh)
    select 'bris',ma_tb,USER_DKTT,MA_HRM_USER_DKTT,'ptm',thang, NGAY_KICH_HOAT
        from PL1_2024
            where thang = 202409
            and  ma_tb not in (select ma_tb from SSS_dgia_202409 where tenkieu_ld = 'ptm')
            ;
    ------------

    insert into SSS_dgia_202409(nguon,ma_tb,username_kh,manv_ptm,tenkieu_ld,thang_ptm,ngay_kh)
    select 'luongtinh',somay,nguoi_gt,manv_ptm,'ptm',TO_NUMBER(TO_CHAR((ngay_ld), 'YYYYMM')),ngay_ld
    from TTKD_BSC.DT_PTM_VNP_202409
    where goi_luongtinh is not null
    ;
----insert gói PTM:
    --bundle_xk
    insert into SSS_dgia_202409(nguon,ma_tb,username_kh,TEN_GOI,tenkieu_ld,tien_goi,thang_ptm,manv_ptm,ma_pb,ngay_kh)
    SELECT 'bundle_xuatkho', B.MA_TB, ACCOUNT_DK, LOAI_SIM,'ptm-goi', GIA_GOI, THANG_KH, MA_NV, MA_PB
        ,(select ngay_kh from SSS_dgia_202409 where tenkieu_Ld = 'ptm' and ma_tb=b.ma_tb)
    FROM (
            SELECT B.*, ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY ngay_CN DESC) AS row_num
            FROM manpn.BUNDLE_XUATKHO_PDH B
             WHERE B.THANG_KH = 202409
        ) B
       where
           B.row_num = 1
          and B.MA_TB IN (SELECT A.MA_TB FROM SSS_dgia_202409 A WHERE tenkieu_ld='ptm')
    ;
    ----IMPORT gói c?a kênh Digishop tr??c: https://digishop.vnpt.vn/digitalShop/stats/statsMobileDetail // ct sim so
    INSERT INTO SSS_dgia_202409 (thang_ptm,nguon, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_sim','ptm-goi', STB, GIA_GOI, TEN_GOI, MA_TIEPTHI
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO,thang
    FROM BSCC_DIGI
    WHERE THANG = 202409
        and LOAI_TB like 'Tr_ tr__c' --tra truoc
        and TRANG_THAI = 'Thành công'
    AND STB IN (SELECT MA_TB FROM SSS_dgia_202409 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202409 WHERE tenkieu_ld = 'ptm-goi');

    ----
    INSERT INTO SSS_dgia_202409 (THANG_ptm,nguon, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_pac', 'ptm-goi', STB, GIA_GOI, TEN_GOI, MA_GIOI_THIEU_DH
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO_DON,
        thang
    FROM BSCC_DIGI_DONLE
    WHERE THANG = 202409 and ngay_hoan_thanh is not null -- tại 1 tb có nhiều dòng gói giống nhau, nhưng chỉ có 1 dòng có ngay_ht là dky thành công
    AND STB  IN (SELECT MA_TB FROM SSS_dgia_202409 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202409 WHERE tenkieu_ld = 'ptm_goi');

    -----
    INSERT INTO SSS_dgia_202409  (thang_ptm,tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi,  ngay_kh,thang_bd)
    SELECT thang,'ptm-goi',CASE WHEN MUC_CK = 0 THEN LOWER(KENH_XUAT_BAN) ELSE 'bundle' END,
                    B.MSISDN, ACCOUNT_DK, SERVICE_CODE, GIA_GOI, to_date(substr(NGAY_KH,1,instr(NGAY_KH, '2024')+3), 'mm/dd/yyyy'),thang
    FROM BSCC_IMPORT_BUNDLE_SMRS_CT B
    WHERE B.THANG = 202409
    AND B.MSISDN IN (SELECT A.MA_TB FROM SSS_dgia_202409  A WHERE tenkieu_ld='ptm')
        AND B.MSISDN NOT IN (SELECT MA_TB FROM SSS_dgia_202409 A WHERE tenkieu_ld='ptm-goi')
        ;
        --BRIS PL4:
    INSERT INTO SSS_dgia_202409 (tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi, THANG_ptm, ngay_kh,thang_bd) -- ko co chu -ky trong file
    SELECT 'ptm-goi',CASE WHEN KENH = 'Shop' then 'shop' ELSE 'bundle' END, '84'||B.SUBSCRIBER_ID, ACCOUNT_DK, TEN_GOI, GIA_GOI, THANG, NGAY_KH,thang
    FROM BSCC_IMPORT_BUNDLE_SMRS B
    WHERE THANG = 202409
    AND '84'||B.SUBSCRIBER_ID IN (SELECT A.MA_TB FROM SSS_dgia_202409 A WHERE tenkieu_ld='ptm')
    AND '84'||B.SUBSCRIBER_ID NOT IN (SELECT MA_TB FROM SSS_dgia_202409 A WHERE tenkieu_ld='ptm-goi');

    --bris
   INSERT INTO SSS_dgia_202409  ( thang_ptm,nguon, MA_TB, ten_goi, CK_GOI, tien_goi, -- bỏ cột loại _kênh
    username_kh, MANV_PTM, tenkieu_ld,  ngay_kh)

    SELECT  thang, LOWER(CONG_CU_BAN_GOI), SO_TB, MA_GOI, CHU_KY_GOI, DOANH_THU_BAN_GOI, USER_KENH_BAN, HRM_NV_BAN_GOI_NV_QLKENH_BAN,
     'ptm-goi', TO_DATE(NGAY_DK_GH_GOI,'YYYY-MM-DD HH24:MI:SS')
    FROM bscc_import_goi_bris
    WHERE HINH_THUC_TB = 'TT'
    AND THANG = 202409
    AND SO_TB IN (SELECT MA_TB FROM SSS_dgia_202409  WHERE tenkieu_ld='ptm')
    AND SO_TB NOT IN (SELECT MA_TB FROM SSS_dgia_202409  WHERE tenkieu_ld='ptm-goi'
                                            AND tien_goi > 0)
    AND SO_TB NOT IN (SELECT MA_TB FROM SSS_dgia_202409  WHERE tenkieu_ld='ptm-goi' and nguon = 'bundle_xuatkho');

    --=====
    INSERT INTO SSS_dgia_202409 (nguon, ma_tb, ten_goi, CK_GOI, tien_goi,
    username_kh, MANV_PTM,  tenkieu_ld,  ngay_kh)
    SELECT LOWER(CONG_CU_BAN_GOI), SO_TB, MA_GOI, CHU_KY_GOI, DOANH_THU_BAN_GOI,
    USER_KENH_BAN, HRM_NV_BAN_GOI_NV_QLKENH_BAN,  'ptm-goi',  TO_DATE(NGAY_DK_GH_GOI,'YYYY-MM-DD HH24:MI:SS')
    FROM bscc_import_goi_bris
    WHERE HINH_THUC_TB = 'TS' and thang = 202409
    AND SO_TB IN (SELECT SOMAY FROM TTKD_BSC.DT_PTM_VNP_202409 WHERE GOI_LUONGTINH IS NOT NULL) --??i tên b?ng
    ;

---UPDTAE manv_ptm:
    update SSS_dgia_202409
    set manv_dktt = username_kh
    where manv_dktt is null
    ;
     update SSS_dgia_202409 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202409 and b.USER_CCBS = a.manv_dktt)
        where manv_ptm is null
        ;
        update SSS_dgia_202409 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202409 and b.USER_CCOS = a.manv_dktt)
        where manv_ptm is null
        ;
        update SSS_dgia_202409 a
        set MANV_PTM = (select b.ma_nv from SSS_kenh_noi_bo b where b.thang = 202409 and b.SO_ELOAD = a.manv_dktt)
        where manv_ptm is null
        ;
        --nhan vien quan li diem ban khoi up
        MERGE INTO SSS_dgia_202409 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.manv_dktt = d.ma_diem_ban AND d.thang = 202409)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.manv_ptm IS NULL;

            MERGE INTO SSS_dgia_202409 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.manv_dktt = to_char(d.so_eload) AND d.thang = 202409)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.manv_ptm IS NULL;

        UPDATE SSS_dgia_202409 a
        SET MANV_PTM = (
            SELECT b.ma_nv
            FROM ttkd_bsc.nhanvien b
            WHERE manv_dktt = b.ma_nv and thang = 202409
        )
        WHERE a.manv_ptm IS NULL
        ;
        update SSS_dgia_202409  a
        set manv_ptm = (
                        select x.ma_nv from ttkd_bsc.nhanvien x
                        join nhuy.userld_202409_goc y
                            on x.mail_vnpt = y.email and x.thang = a.thang_ptm
                            where a.manv_dktt = y.user_ld
                )
        where manv_ptm is null
        ;
--===UPDATE thông tin nhân viên:
     update SSS_dgia_202409 a
        set (tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.manv_ptm)
    where tennv_ptm is null
       ;
         update SSS_dgia_202409 a
         set loai_ld = (select x.TENNHOM_TAT from  ttkd_bsc.dm_nhomld x where x.NHOMLD_ID = a.nhom_tiepthi)
         where a.loai_ld is null
        ;

---===UPDATE PHAN_LOAI_KENH:
        merge into SSS_dgia_202409 a
        using ttkd_bct.va_dm_loaikenh_bh x
        on (a.username_kh = x.ma_nd and x.thang = 202409)
        when matched then
            update set a.phan_loai_kenh = x.phanloai_kenh
            where a.phan_loai_kenh is null
            ;
        --UPDATE kênh nội bộ/đại lý

                    MERGE INTO SSS_dgia_202409 a
USING manpn.BSCC_IMPORT_CHUOI_TOAN_QUOC m
ON (a.ma_tb = m.so_thue_bao AND a.THANG_PTM = m.thang)
WHEN MATCHED THEN
    UPDATE SET a.dai_ly = 1;
    UPDATE SSS_dgia_202409
SET dai_ly = 1
WHERE PHAN_LOAI_KENH = 'Chuỗi toàn quốc';





        UPDATE SSS_dgia_202409 a
                SET dai_ly = 1
                    ,kenh_trong = 0
                where a.username_kh in (select m.ma_diem_ban FROM ttkd_bsc.ds_diemban_31import m
                        WHERE m.thang = 202409)
                    OR a.username_kh in (select to_char(m.so_eload) FROM ttkd_bsc.ds_diemban_31import m
                        WHERE m.thang = 202409)
                        ;
          UPDATE SSS_dgia_202409
          set kenh_trong =  case when (kenh_trong is null and manv_ptm is not null) then 1
                     else 0 end
          ;
            UPDATE SSS_dgia_202409
          set dai_ly = 0
          where dai_ly is null
           ;




----======
       --bundle xuat kho:
        update SSS_dgia_202409 a
                    set tien_goi = (select x.GIA_GOI from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x where a.goi_cuoc = x.ten_goi)
                        ,DTHU_DONGIA_GOI = (select x.GIA_GOI from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x where a.ten_goi = x.goi_cuoc)
          where tien_goi is null
        ;
        update SSS_dgia_202409 a
                    set tien_goi = (select x.GIA_GOI_CO_VAT from manpn.BSCC_INSERT_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
                        ,DTHU_DONGIA_GOI = (select x.GIAGOI_SAUCK_COVAT from manpn.BSCC_INSERT_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
          where tien_goi is null
                    ;
       UPDATE SSS_dgia_202409 a
        SET bundle_xk = 1
        WHERE EXISTS (
            SELECT 1
            FROM manpn.BUNDLE_XUATKHO_PDH b
            WHERE b.ma_tb = a.ma_tb
            AND b.THANG_KH  = 202409
        );
        update SSS_dgia_202409
        set heso_hhbg = 0.25
            ,heso_kk = 0.05
            ,TIEN_THULAO_DNHM = 20000
            ,TIEN_DNHM = 25000
            ,DTHU_DONGIA_DNHM = 20000
       where tenkieu_ld = 'ptm'
        ;
        update SSS_dgia_202409
        set DTHU_DONGIA_GOI = tien_goi
            ,heso_kk = 0.05
            ,heso_hhbg = 0.25
       where tenkieu_ld = 'ptm-goi'
       ;

---=====UPDATE CHU KỲ GÓI
       UPDATE SSS_dgia_202409 a
        SET ck_goi = (
            SELECT x.CHU_KY
            FROM manpn.BSCC_INSERT_DM_KIT_BUNDLE x
            WHERE x.goi_cuoc = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.CK_goi IS NULL
        ;
        update SSS_dgia_202409 a
        set ck_goi = (select x.chu_ky_thang from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x where  x.goi_cuoc= a.ten_goi )
        where CK_goi is null
        ;
        update SSS_dgia_202409
        set ck_goi = 0
        where ten_goi in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang = 'N')
        ;


---====UPDATE CK_GOI_DM:
        UPDATE SSS_dgia_202409 a
        SET ck_goi_dm = (
            SELECT x.CHU_KY
            FROM manpn.BSCC_INSERT_DM_KIT_BUNDLE x
            WHERE x.ten_goi = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.ck_goi_dm IS NULL
        ;
        update SSS_dgia_202409 a
        set ck_goi_dm = (SELECT CASE
                                WHEN x.chu_ky_thang = 'N' THEN 0
                                ELSE TO_NUMBER(x.chu_ky_thang)
                            END
                        FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x
                        WHERE x.goi_cuoc = a.ten_goi )
        where ck_goi_dm is null
        ;
        update SSS_dgia_202409
        set ck_goi_dm = 0
        where ten_goi in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang = 'N')
        ;

---====UPDATE chu kỳ gói tính TLDG:
        UPDATE SSS_dgia_202409
        SET CK_GOI_TLDG = GREATEST(nvl(CK_GOI_DM,0), NVL(CK_GOI, 0))
        WHERE CK_GOI_TLDG IS NULL;
    --==UPDTAE tháng kết thúc để tính lương thu hồi?
        update SSS_dgia_202409
        set thang_kt = to_number(to_char(add_months(ngay_kh, CK_GOI_TLDG),'yyyymm'))
        where thang_kt is null
        ;



  --==UPDATE tính tiền thù lao gói:
      UPDATE SSS_dgia_202409
        SET TIEN_THULAO_GOI = CASE
                        WHEN CK_GOI_TLDG >= 1 THEN DTHU_DONGIA_GOI * HESO_HHBG
                        WHEN CK_GOI_TLDG = 0 THEN 0
                    END
        ;

--===== #vde LOẠI TRỪ các trường hợp
--PBH ONL: (các TB ptm có mua gói kích hoạt bởi nv PBHOL) OR (kích PTM GÓI) thì sẽ tính đơn giá.
--          chỉ kích TB PTM --> 0 tính.

UPDATE SSS_dgia_202409 a
SET TIEN_THULAO_GOI = CASE
    -- Trường hợp 1: Cả hai dòng có cùng ma_pb = 'VNP0703000'
    WHEN EXISTS (
        SELECT 1
        FROM SSS_dgia_202409 b
        WHERE a.ma_tb = b.ma_tb
          AND a.tenkieu_ld = 'ptm'
          AND b.tenkieu_ld = 'ptm-goi'
          AND a.ma_pb = 'VNP0703000'
          AND b.ma_pb = 'VNP0703000'
          and a.CK_GOI_TLDG > 0
    ) THEN a.DTHU_DONGIA_GOI * a.HESO_HHBG

    -- Trường hợp 2: ptm-goi có ma_pb = 'VNP0703000' và ptm có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm-goi'
         AND a.ma_pb = 'VNP0703000' and a.CK_GOI_TLDG > 0
         AND EXISTS (
             SELECT 1
             FROM SSS_dgia_202409 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN a.DTHU_DONGIA_GOI * a.HESO_HHBG

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm' and a.CK_GOI_TLDG > 0
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1
             FROM SSS_dgia_202409 d
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
        FROM SSS_dgia_202409 b
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
             FROM SSS_dgia_202409 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN TIEN_THULAO_DNHM

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm'
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1
             FROM SSS_dgia_202409 d
             WHERE a.ma_tb = d.ma_tb
               AND d.tenkieu_ld = 'ptm-goi'
               AND d.ma_pb <> 'VNP0703000'
         ) THEN 0

    -- Trường hợp còn lại không thay đổi
    ELSE a.TIEN_THULAO_DNHM
END
,lydo_khongtinh = CASE
        WHEN (a.TIEN_THULAO_GOI = 0 and a.ma_pb = 'VNP0703000' and a.TENKIEU_LD ='ptm-goi') OR (a.TIEN_THULAO_DNHM = 0 and a.ma_pb = 'VNP0703000'and a.TENKIEU_LD ='ptm-goi') THEN 'PBH ONL_v2'
        ELSE a.lydo_khongtinh
    END
;


update SSS_dgia_202409
set LYDO_KHONGTINH ='CK gói = 0'
where manv_ptm is not null and CK_GOI_TLDG = 0 and LYDO_KHONGTINH is null
;

--#vde: các trường hợp when case loại trừ ko tính
   UPDATE SSS_dgia_202409
        SET TIEN_THULAO_GOI = 0,
            TIEN_THULAO_DNHM = 0,
            LYDO_KHONGTINH = CASE
                                WHEN ma_pb = 'VNP0700800' THEN 'PTTT ko tinh'
                                WHEN BUNDLE_XK = 1 and tenkieu_ld  ='ptm-goi' THEN 'Bundle_xk không tính đơn giá gói'
                                WHEN PHAN_LOAI_KENH = 'CTVXHH' or manv_dktt like 'P%' THEN 'CTVXHH ko tính đơn giá'
                                WHEN ten_goi in (select ten_goi from dm_goi_loai_tru ) then ten_goi ||' ko tinh'
                                WHEN dai_ly = 1 then 'Đại lý ko tinh'

                             END
        WHERE (BUNDLE_XK = 1 and tenkieu_ld  ='ptm-goi')
           OR ma_pb = 'VNP0700800'
           OR PHAN_LOAI_KENH = 'CTVXHH' OR manv_dktt like 'P%'
           OR ten_goi in (select ten_goi from dm_goi_loai_tru )
           or dai_ly = 1;
           UPDATE SSS_dgia_202409
        SET TIEN_THULAO_GOI = 0,
            TIEN_THULAO_DNHM = 0
        where dai_ly = 1;
--        delete from SSS_dgia_202409;
        select *  from SSS_dgia_202409 where ten_goi ='MI_U900';
---gom thành 1 dòng thêm các cột thông tin của nhân viên thứ 2



-----------------====== NHÁP:





        select distinct LYDO_KHONGTINH from SSS_dgia_202408
                                       where ( TIEN_THULAO_DNHM = 0 or TIEN_THULAO_GOI =0)
                                            and MANV_PTM is not null
                                            and TENKIEU_LD in ('ptm','ptm-goi')
        ;

;
--select * from va_DM_KIT_BUNDLE;
--select * from va_DM_GOICUOC_PHANKY;
select * from SSS_dgia_202408 where  MANV_PTM is not null and ma_tb in (select ma_tb from SSS_dgia_202408 where  MANV_PTM is not null group by ma_tb having count(ma_tb)>2)
order by ma_tb; --1837tb >2
select * from SSS_dgia_202408 where  MANV_PTM is not null and ma_tb in (select ma_tb from SSS_dgia_202408 where  MANV_PTM is not null group by ma_tb having count(ma_tb)>2)
order by ma_tb; --1837tb >2

create table SSS_dgia_2 as -- tạo bảng 2 dòng ( ptm và chỉ 1 gói)
SELECT *
FROM (
    -- Lấy những dòng có tenkieu_ld là 'ptm'
    SELECT a.*,1
    FROM SSS_DGIA_202408 a
    WHERE a.tenkieu_ld = 'ptm'

    UNION ALL

    -- Lấy dòng có tenkieu_ld là 'ptm-goi' với TIEN_GOI lớn nhất cho mỗi ma_tb
    SELECT *
    FROM (
        SELECT a.*, ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.TIEN_GOI DESC) as rnk
        FROM SSS_DGIA_202408 a
        WHERE a.tenkieu_ld = 'ptm-goi'
    )
    WHERE rnk = 1
);
select count(*) from SSS_DGIA_202408 where TENKIEU_LD ='ptm'
; -- 21540
select * from SSS_dgia_2 where ma_tb = '84812004570';
create table one_line as (SELECT thang_ptm,
                         LISTAGG(nguon, '; ') WITHIN GROUP (ORDER BY TENKIEU_LD)              AS nguon,
                         LISTAGG(phan_loai_kenh, '; ') WITHIN GROUP (ORDER BY TENKIEU_LD)     AS phan_loai_kenh,
                         ma_tb,
                         MAX(ten_goi)                                                         AS ten_goi,
                         MAX(ck_goi_tldg)                                                     AS ck_goi_tldg,
                         MAX(CASE WHEN tenkieu_ld = 'ptm' THEN manv_ptm END)                  AS manv_ptm,
                         MAX(CASE WHEN tenkieu_ld = 'ptm' THEN tennv_ptm END)                 AS tennv_ptm,
                         MAX(CASE WHEN tenkieu_ld = 'ptm' THEN ma_to END)                     AS mato_ptm,
                         MAX(CASE WHEN tenkieu_ld = 'ptm' THEN ten_to END)                    AS tento_ptm,
                         MAX(CASE WHEN tenkieu_ld = 'ptm' THEN ma_pb END)                     AS mapb_ptm,
                         MAX(CASE WHEN tenkieu_ld = 'ptm' THEN ten_pb END)                    AS tenpb_ptm,
                         MAX(tien_dnhm)                                                       AS tien_dnhm,
                         MAX(dthu_dongia_dnhm)                                                AS dthu_dongia_dnhm,
                         MAX(tien_thulao_dnhm)                                                AS tien_thulao_dnhm,
                         MAX(CASE WHEN tenkieu_ld = 'ptm-goi' THEN manv_ptm END)              AS manv_goi,
                         MAX(CASE WHEN tenkieu_ld = 'ptm-goi' THEN ma_to END)                 AS mato_goi,
                         MAX(CASE WHEN tenkieu_ld = 'ptm-goi' THEN ma_pb END)                 AS mapb_goi,
                         MAX(tien_goi)                                                        AS tien_goi,
                         MAX(dthu_dongia_goi)                                                 AS dthu_dongia_goi,
                         MAX(tien_thulao_goi)                                                 AS tien_thulao_goi,
                         dthu_KPI,
                         LISTAGG(lydo_khongtinh, '; ') WITHIN GROUP (ORDER BY TENKIEU_LD) AS lydo_khongtinh
                  FROM SSS_DGIA_2
                  GROUP BY ma_tb, thang_ptm, dthu_KPI);
select manv_ptm,sum(tldg_hmm),sum(tldg_mg) from manpn.manpn_goi_tonghop_202408 where manv_ptm in (select manv
                                                                                                           from (SELECT COALESCE(manv_ptm, manv_goi) AS              manv,
                                                                                                                        SUM(tien_thulao_goi)         AS              total_thulao_goi,
                                                                                                                        SUM(tien_thulao_dnhm)        AS              total_thulao_dnhm,
                                                                                                                        SUM(tien_thulao_goi) + SUM(tien_thulao_dnhm) tong_tien
                                                                                                                 FROM one_line
                                                                                                                 GROUP BY COALESCE(manv_ptm, manv_goi)
                                                                                                                 )
                                                                                                           )
                                                                                                           group by manv_ptm
;
select * from one_line where manv_goi ='CTV080920';

SELECT manv, SUM(tien_thulao) AS tong_tien_thulao
FROM (
    SELECT manv_ptm AS manv, tien_thulao_dnhm AS tien_thulao
    FROM one_line
    WHERE manv_ptm IS NOT NULL

    UNION ALL

    SELECT manv_goi AS manv, tien_thulao_goi AS tien_thulao
    FROM one_line
    WHERE manv_goi IS NOT NULL
)
GROUP BY manv;


SELECT COALESCE(manv_ptm, manv_goi) AS manv,
       SUM(tien_thulao_goi) AS total_thulao_goi,
       SUM(tien_thulao_dnhm) AS total_thulao_dnhm
FROM one_line
where  COALESCE(manv_ptm, manv_goi) = 'CTV080920'
GROUP BY COALESCE(manv_ptm, manv_goi);


select distinct manv_ptm from SSS_DGIA_202408 where manv_ptm is not null;
;
update SSS_DGIA_2
set thang_ptm = 202408
where thang_ptm is null;

select MA_TB,manv_ptm,TENNV_PTM ,ten_goi, TIEN_THULAO_GOI,TIEN_THULAO_DNHM,LYDO_KHONGTINH,a.*
from  SSS_DGIA_202408 a
where manv_ptm = 'CTV080920'
;

select *
from  manpn.manpn_goi_tonghop_202408
where manv_ptm = 'CTV086276' and loai_tb='ptm_goi'
;
select *
from  manpn.manpn_goi_tonghop_202408
where manv_ptm = 'CTV080920' ;and loai_tb='ptm'
;
select * from MANPN.BSCC_INSERT_DM_GOICUOC_PHANKY;
select * from MANPN.BSCC_INSERT_DM_KIT_BUNDLE;
