-- 7 nguồn báo cáo
--TUT: https://docs.google.com/spreadsheets/d/1TrjBsTbEde6fXFudJZ8kI3rM92wmmIZJ9eSuKAkAFEU/edit?usp=sharing
--=====================CHECK ĐÃ IMPORT CHƯA ?-======================
select count(*) from manpn.bscc_ptm_bris_P01_moi  where thang = 202410; --bscc_import_ptm_bris_pl01_moi
select count(*) from manpn.bscc_import_ptm_smrs where thang = 202410;
select count(*) from manpn.BUNDLE_XUATKHO_PDH where thang_KH = 202410;
select count(*) from manpn.BSCC_DIGI_DONLE where thang = 202410;
select count(*) from manpn.BSCC_DIGI where thang = 202410;
select count(*) from MANPN.BSCC_IMPORT_BUNDLE_SMRS_CT where thang = 202410;
select count(*) from MANPN.BSCC_IMPORT_BUNDLE_SMRS where thang = 202410;
select count(*) from manpn.bscc_import_goi_bris_p04 where thang = 202410;
select count(*) FROM manpn.bscc_import_kenh_noibo where thang = 202410;
select count(*) from manpn.BSCC_IMPORT_CHUOI_TOAN_QUOC where thang = 202410;
select count(*) from manpn.kpi_kenhban_ngoai_noibo@ttkddbbk2 where thang = 202410;

select * from manpn.bscc_ptm_bris_P01_moi;


select * from ttkd_bsc.ds_diemban_31import where so_eload in ('84842694969') and thang = 202410; --20256
delete from SSS_DGIA_202410; where TENKIEU_LD ='ptm-goi';
----insert PTM:
--        insert into SSS_dgia_202410(MA_TB, nguon, username_kh, thang_ptm, MANV_DKTT, tenkieu_ld, ngay_kh)
-- with cte as(
--     SELECT TO_CHAR(SO_ELOAD) AS ELOAD, A.*
--     FROM(
--         SELECT case when INSTR(a.MA_NHAN_VIEN, '_') > 0 then UPPER(SUBSTR(a.MA_NHAN_VIEN, 1, INSTR(a.MA_NHAN_VIEN, '_')-1))
--                else a.MA_NHAN_VIEN end ma_nv
--             , A.*, ROW_NUMBER() OVER(PARTITION BY SO_ELOAD ORDER BY LOAI_DIEM_BAN DESC) RA
--         FROM manpn.kpi_kenhban_ngoai_noibo@ttkddbbk2 A
--         WHERE THANG = 202410
--         ) A
--     WHERE RA = 1
--     ),
--     NVVV AS(
--     SELECT UPPER(SUBSTR(MAIL_VNPT, 1, INSTR(MAIL_VNPT, '@')-1)) AS MAIL, C.* FROM (select * from ttkd_bsc.nhanvien where thang = 202410) C
--     WHERE THANG = 202410
--     )
-- select A.so_tb, 'bris', c.ma_nv , A.THANG, A.MA_HRM_CUA_NHAN_VIEN_QUAN_LY_US, 'ptm', NGAY_KICH_HOAT
-- from manpn.bscc_ptm_bris_P01_moi a
--     left join cte b on a.MA_CUA_USER_TIEP_THI_TB = b.MA_DIEM_BAN
--     left join NVVV C ON b.MA_Nv = C.MAIL AND C.THANG = 202410
--     where a.thang = 202410
--     and b.ma_diem_ban is not null
--     and DIEM_CHAM_TIEP_THI_TB in ('DIGISHOPAPP', 'App DigiShop TNTTTB KIT')
--     and CONG_CU_DKTTTB in ('One App', 'App DigiShop TNTTTB KIT')
;
-----------
    insert into SSS_dgia_202410(nguon,ma_tb,username_kh,manv_dktt,tenkieu_ld,thang_ptm,ngay_kh)
    select 'bris',so_tb,nvl(MA_CUA_USER_TIEP_THI_TB,USER_ELOAD_DK_TTTB),nvl(MA_CUA_USER_TIEP_THI_TB,USER_ELOAD_DK_TTTB),'ptm',thang, NGAY_KICH_HOAT
        from manpn.bscc_ptm_bris_P01_moi
            where thang = 202410
            and  so_tb not in (select ma_tb from SSS_dgia_202410 where tenkieu_ld = 'ptm')
            ;
    -----------
       MERGE INTO SSS_dgia_202410 a
USING (
    SELECT ma_tb, ma_hrm
    FROM (
        SELECT a.ma_tb,
               b.ma_diem_ban AS ma_hrm,
               ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY b.MA_HRM) AS rn
        FROM dgia_TNDN_SIMSO a
        LEFT JOIN manpn.kpi_kenhban_ngoai_noibo@ttkddbbk2 b
            ON a.ma_diem_ban = b.MA_DIEM_BAN
            AND b.thang = 202410
    )
    WHERE rn = 1
) x
ON (a.ma_tb = x.ma_tb)
WHEN MATCHED THEN
    UPDATE SET a.username_kh = x.ma_hrm;
---------
    insert into SSS_dgia_202410(nguon,ma_tb,username_kh,tenkieu_ld,thang_ptm,ngay_kh)
    select 'smrs','84' || SUBSCRIBER_ID a, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
    from manpn.bscc_import_ptm_smrs
    where thang = 202410
        and  '84' || SUBSCRIBER_ID not in (select ma_tb from SSS_dgia_202410 where tenkieu_ld = 'ptm');

    ------------
-- T10 ko tinh
--     insert into SSS_dgia_202410(nguon,ma_tb,username_kh,manv_ptm,tenkieu_ld,thang_ptm,ngay_kh)
--     select 'luongtinh',somay,nguoi_gt,manv_ptm,'ptm',TO_NUMBER(TO_CHAR((ngay_ld), 'YYYYMM')),ngay_ld
--     from TTKD_BSC.DT_PTM_VNP_202410
--     where goi_luongtinh is not null
    ;
----insert gói PTM:
    --bundle_xk
    insert into SSS_dgia_202410(nguon,ma_tb,username_kh,TEN_GOI,tenkieu_ld,tien_goi,thang_ptm,manv_ptm,ma_pb,ngay_kh)
    SELECT 'bundle_xuatkho', B.MA_TB, ACCOUNT_DK, LOAI_SIM,'ptm-goi', GIA_GOI, THANG_KH, MA_NV, MA_PB
        ,(select ngay_kh from SSS_dgia_202410 where tenkieu_Ld = 'ptm' and ma_tb=b.ma_tb)
    FROM (
            SELECT B.*, ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY ngay_CN DESC) AS row_num
            FROM manpn.BUNDLE_XUATKHO_PDH B
             WHERE B.THANG_KH = 202410
        ) B
       where
           B.row_num = 1
          and B.MA_TB IN (SELECT A.MA_TB FROM SSS_dgia_202410 A WHERE tenkieu_ld='ptm')
    ;
    ----IMPORT gói c?a kênh Digishop tr??c: https://digishop.vnpt.vn/digitalShop/stats/statsMobileDetail // ct sim so
    INSERT INTO SSS_dgia_202410 (thang_ptm,nguon, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_sim','ptm-goi', STB, GIA_GOI, TEN_GOI, MA_TIEPTHI
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO,thang
    FROM manpn.BSCC_DIGI
    WHERE THANG = 202410
        and LOAI_TB like 'Tr_ tr__c' --tra truoc
        and TRANG_THAI = 'Thành công'
    AND STB IN (SELECT MA_TB FROM SSS_dgia_202410 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202410 WHERE tenkieu_ld = 'ptm-goi');

    ----
    INSERT INTO SSS_dgia_202410 (THANG_ptm,nguon, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_pac', 'ptm-goi', STB, GIA_GOI, TEN_GOI, MA_GIOI_THIEU_DH
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO_DON,
        thang
    FROM manpn.BSCC_DIGI_DONLE
    WHERE THANG = 202410 and ngay_hoan_thanh is not null -- tại 1 tb có nhiều dòng gói giống nhau, nhưng chỉ có 1 dòng có ngay_ht là dky thành công
    AND STB  IN (SELECT MA_TB FROM SSS_dgia_202410 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202410 WHERE tenkieu_ld = 'ptm_goi');

    -----
    INSERT INTO SSS_dgia_202410  (thang_ptm,tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi,  ngay_kh,thang_bd)
    SELECT thang,'ptm-goi',CASE WHEN MUC_CK = 0 THEN LOWER(KENH_XUAT_BAN) ELSE 'bundle' END,
                    B.MSISDN, ACCOUNT_DK, SERVICE_CODE, GIA_GOI, to_date(substr(NGAY_KH,1,instr(NGAY_KH, '2024')+3), 'mm/dd/yyyy'),thang
    FROM manpn.BSCC_IMPORT_BUNDLE_SMRS_CT B
    WHERE B.THANG = 202410
    AND B.MSISDN IN (SELECT A.MA_TB FROM SSS_dgia_202410  A WHERE tenkieu_ld='ptm')
        AND B.MSISDN NOT IN (SELECT MA_TB FROM SSS_dgia_202410 A WHERE tenkieu_ld='ptm-goi')
        ;
        --SMRS-bundle:
    INSERT INTO SSS_dgia_202410 (tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi, THANG_ptm, ngay_kh,thang_bd) -- ko co chu -ky trong file
    SELECT 'ptm-goi',CASE WHEN KENH = 'Shop' then 'shop' ELSE 'bundle' END, '84'||B.SUBSCRIBER_ID, ACCOUNT_DK, TEN_GOI, GIA_GOI, THANG, NGAY_KH,thang
    FROM manpn.BSCC_IMPORT_BUNDLE_SMRS B
    WHERE THANG = 202410
    AND '84'||B.SUBSCRIBER_ID IN (SELECT A.MA_TB FROM SSS_dgia_202410 A WHERE tenkieu_ld='ptm')
    AND '84'||B.SUBSCRIBER_ID NOT IN (SELECT MA_TB FROM SSS_dgia_202410 A WHERE tenkieu_ld='ptm-goi');

    --bris
   INSERT INTO SSS_dgia_202410  ( thang_ptm,nguon, MA_TB, ten_goi, CK_GOI, tien_goi, -- bỏ cột loại _kênh
    username_kh, MANV_PTM, tenkieu_ld,  ngay_kh)
WITH rnk_data AS (
    SELECT thang, LOWER(REGIS_SYSTEM_CD) AS CONG_CU_BAN_GOI, ACCS_MTHD_KEY, SERVICE_CODE, P2_CHUKY,
           TOT_RVN_PACKAGE, USER_CODE, HRM_CODE,
           'ptm-goi' AS TENKIEU_LD, REGIS_DT AS NGAY_DK_GH_GOI,
           ROW_NUMBER() OVER (PARTITION BY ACCS_MTHD_KEY, REGIS_DT, SERVICE_CODE
                              ORDER BY ACTVTN_DT DESC) AS rn
    FROM manpn.bscc_import_goi_bris_p04
    WHERE LOAIHINH_TB = 'TT'
    AND THANG = 202410
    AND ACCS_MTHD_KEY IN (SELECT MA_TB
                  FROM SSS_dgia_202410
                  WHERE tenkieu_ld = 'ptm')
    AND ACCS_MTHD_KEY NOT IN (SELECT MA_TB
                      FROM SSS_dgia_202410
                      WHERE tenkieu_ld = 'ptm-goi'
                      AND tien_goi > 0)
    AND ACCS_MTHD_KEY NOT IN (SELECT MA_TB
                      FROM SSS_dgia_202410
                      WHERE tenkieu_ld = 'ptm-goi'
                      AND nguon = 'bundle_xuatkho')
    AND lower(REGIS_SYSTEM_CD) not in ('selfcare')
    AND P2_CHUKY is not null
)
SELECT THANG, CONG_CU_BAN_GOI, ACCS_MTHD_KEY, SERVICE_CODE, P2_CHUKY,
           TOT_RVN_PACKAGE, USER_CODE, HRM_CODE, TENKIEU_LD, NGAY_DK_GH_GOI
FROM rnk_data
WHERE rn = 1;
    --=====

    ;
----- END IMPORT ------
--
     delete from SSS_dgia_202410 where( tenkieu_ld ='ptm-goi' and CK_GOI_TLDG = 0) or nguon in( 'selfcare','myvnpt')
        or ten_goi in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang ='N')
                    or ten_goi in (select ten_goi  from DM_GOI_LOAI_TRU);;
---UPDTAE manv_ptm:
--- Cho trường hợp các phòng bán hàng gán manv mới,
    update SSS_dgia_202410
    set manv_dktt = username_kh
    where manv_dktt is null;
     --tạo index cho lẹ xog xóa chứ udpate lâu quá :((
     drop index idx_tmp;
    create index idx_tmp on SSS_dgia_202410(ma_tb,username_kh);
    ;
        update SSS_dgia_202410 a
        set MANV_PTM = (select (b.ma_nv) from ttkd_bsc.nhanvien b where b.thang = 202410 and b.USER_CCBS = a.username_kh) -- tháng 9 ttvt_ctv086203_hcm đag bị double nên dùng max
        where manv_ptm is null
        ;
        update SSS_dgia_202410 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202410 and b.USER_CCOS = a.username_kh)
        where manv_ptm is null
        ;
        update SSS_dgia_202410 a
        SET MANV_PTM = (SELECT c.ma_nv
                     FROM manpn.bscc_import_kenh_noibo b
                     JOIN ttkd_bsc.nhanvien c
                       ON c.thang = 202410
                      AND SUBSTR(C.MAIL_VNPT, 1, INSTR(C.MAIL_VNPT, '@') - 1) = LOWER(
                           CASE
                              WHEN INSTR(b.MA, '_') > 0 THEN SUBSTR(b.MA, 1, INSTR(b.MA, '_') - 1)
                              ELSE b.MA
                           END
                       )
                    WHERE b.thang = 202410
                      AND b.SO_ELOAD = a.username_kh
                  )
        WHERE MANV_PTM IS NULL;
        ;
        --TH appemployee bi loi~ ko ghi nhan goi cho nv thuc hien toan trinh
            update SSS_dgia_202410 a
            set (username_kh,MANV_DKTT,manv_ptm) = (select x.manv_ptm,x.manv_ptm,x.manv_ptm from  SSS_dgia_202410 x where x.ma_tb =a.ma_tb and x.TENKIEU_LD='ptm'  )
            where TENKIEU_LD = 'ptm-goi'
            and nguon ='appemployee' and MANV_PTM is null
            ;
select * from ttkd_bsc.ds_diemban_31import;
        --nhan vien quan li diem ban khoi up
        MERGE INTO SSS_dgia_202410 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = d.ma_diem_ban AND d.thang = 202410)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.username_kh in (select (ma_diem_ban) from ttkd_bsc.ds_diemban_31import where thang = 202410);


            MERGE INTO SSS_dgia_202410 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = to_char(d.so_eload) AND d.thang = 202410)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.username_kh in (select to_char(so_eload) from ttkd_bsc.ds_diemban_31import where thang = 202410)
        and a.manv_ptm IS NULL
             ;
 ;
;
        UPDATE SSS_dgia_202410 a
        SET MANV_PTM = (
            SELECT b.ma_nv
            FROM ttkd_bsc.nhanvien b
            WHERE manv_dktt = b.ma_nv and thang = 202410
        )
        WHERE a.manv_ptm IS NULL
        ;
        update SSS_dgia_202410  a
        set manv_ptm = (
                        select x.ma_nv from ttkd_bsc.nhanvien x
                        join nhuy.userld_202410_goc y
                            on x.mail_vnpt = y.email and x.thang = a.thang_ptm
                            where a.manv_dktt = y.user_ld
                )
        where manv_ptm is null
        ;
--===UPDATE thông tin nhân viên:
     update SSS_dgia_202410 a
        set (tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.manv_ptm)
    where tennv_ptm is null
       ;
         update SSS_dgia_202410 a
         set loai_ld = (select x.TENNHOM_TAT from  ttkd_bsc.dm_nhomld x where x.NHOMLD_ID = a.nhom_tiepthi)
         where a.loai_ld is null
        ;
update SSS_dgia_202410
    set MANV_GOC = MANV_PTM;

---===UPDATE PHAN_LOAI_KENH:
        merge into SSS_dgia_202410 a
        using ttkd_bct.va_dm_loaikenh_bh x
        on (a.username_kh = x.ma_nd and x.thang = 202410)
        when matched then
            update set a.phan_loai_kenh = x.phanloai_kenh
            where a.phan_loai_kenh is null
            ;
        --UPDATE kênh nội bộ/đại lý

                    MERGE INTO SSS_dgia_202410 a
                        USING manpn.BSCC_IMPORT_CHUOI_TOAN_QUOC m
                        ON (a.ma_tb = m.so_thue_bao AND a.THANG_PTM = m.thang)
                        WHEN MATCHED THEN
                        UPDATE SET a.dai_ly = 1 ,a.kenh_trong = 0;
                    UPDATE SSS_dgia_202410
                        SET dai_ly = 1
                        ,kenh_trong = 0
                        WHERE PHAN_LOAI_KENH = 'Chuỗi toàn quốc';


        --dai_ly = 1, kenh_trong =0 khi là đại lí <=> cột kênh trong = 0
        UPDATE SSS_dgia_202410 a
                SET dai_ly = 1
                    ,kenh_trong = 0
                where a.username_kh in (select m.ma_diem_ban FROM ttkd_bsc.ds_diemban_31import m
                        WHERE m.thang = 202410)
                    OR a.username_kh in (select to_char(m.so_eload) FROM ttkd_bsc.ds_diemban_31import m
                        WHERE m.thang = 202410)
                        ;

        UPDATE SSS_dgia_202410
          set kenh_trong =  case when (kenh_trong is null and manv_ptm is not null) then 1
                else 0 end;
        UPDATE SSS_dgia_202410
          set dai_ly = 0
          where dai_ly is null
           ;


        --xác định các bundle xuất kho khong tính đơn giá gói chỉ tính đơn giá HMM
        --note 14/11: edit thanh merge di chu update waste 7p,9p lun
               MERGE INTO SSS_dgia_202410 a
                USING (
                    SELECT ma_tb, 1 AS bundle_xk
                    FROM (
                        SELECT b.ma_tb, ROW_NUMBER() OVER (PARTITION BY b.ma_tb ORDER BY b.ngay_CN DESC) AS row_num
                        FROM manpn.BUNDLE_XUATKHO_PDH b
                        WHERE b.THANG_KH = 202410
                    ) b
                    WHERE b.row_num = 1  -- Chỉ lấy bản ghi mới nhất cho mỗi ma_tb
                ) b
                ON (a.ma_tb = b.ma_tb AND a.THANG_PTM = 202410)
                WHEN MATCHED THEN
                    UPDATE SET a.bundle_xk = b.bundle_xk;


----======
-- update tiền gói bình thường trừ bundle xuát kho, lí do báo cáo bị thiếu mới update
        update SSS_dgia_202410 a
                    set tien_goi = (select x.GIA_GOI from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x where a.TEN_GOI = x.goi_cuoc)
                        ,DTHU_DONGIA_GOI = (select x.GIA_GOI from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x where a.ten_goi = x.goi_cuoc)
          where tien_goi is null and  BUNDLE_XK =0
        ;
-- gói bundle xuất kho
        update SSS_dgia_202410 a
                    set tien_goi = (select x.GIA_GOI_CO_VAT from manpn.BSCC_INSERT_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
                        ,DTHU_DONGIA_GOI = (select x.GIA_GOI_CO_VAT*(1-CHIET_KHAU) from manpn.BSCC_INSERT_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
          where tien_goi is null and BUNDLE_XK = 1
                    ;

        update SSS_dgia_202410
        set heso_hhbg = 0.25
            ,heso_kk = 0
            ,TIEN_THULAO_DNHM = 20000
            ,TIEN_DNHM = 25000
            ,DTHU_DONGIA_DNHM = 20000
       where tenkieu_ld = 'ptm'
        ;
        update SSS_dgia_202410
        set DTHU_DONGIA_GOI = tien_goi
            ,heso_kk = 0
            ,heso_hhbg = 0.25
       where tenkieu_ld = 'ptm-goi'
       ;

---=====UPDATE CHU KỲ GÓI

       UPDATE SSS_dgia_202410 a
        SET ck_goi = (
            SELECT x.CHU_KY
            FROM manpn.BSCC_INSERT_DM_KIT_BUNDLE x
            WHERE x.ten_goi = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.CK_goi IS NULL
        ;
        update SSS_dgia_202410 a
        set ck_goi = (select x.chu_ky_thang from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x  where  x.goi_cuoc= a.ten_goi )
        where CK_goi is null
        ;
        update SSS_dgia_202410
        set ck_goi = 0
        where ten_goi in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang = 'N')
        ;


---====UPDATE CK_GOI_DM:
        UPDATE SSS_dgia_202410 a
        SET ck_goi_dm = (
            SELECT x.CHU_KY
            FROM manpn.BSCC_INSERT_DM_KIT_BUNDLE x
            WHERE x.ten_goi = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.ck_goi_dm IS NULL
        ;
        update SSS_dgia_202410 a
        set ck_goi_dm = (SELECT CASE
                                WHEN x.chu_ky_thang = 'N' THEN 0
                                ELSE TO_NUMBER(x.chu_ky_thang)
                            END
                        FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x
                        WHERE x.goi_cuoc = a.ten_goi )
        where ck_goi_dm is null
        ;


---====UPDATE chu kỳ gói tính TLDG:
        UPDATE SSS_dgia_202410
        SET CK_GOI_TLDG = GREATEST(nvl(CK_GOI_DM,0), NVL(CK_GOI, 0))
        WHERE CK_GOI_TLDG IS NULL;
    --==UPDTAE tháng kết thúc để tính lương thu hồi?
        update SSS_dgia_202410
        set thang_kt = to_number(to_char(add_months(ngay_kh, CK_GOI_TLDG),'yyyymm'))
        where thang_kt is null
        ;

  --==UPDATE tính tiền thù lao gói:
      UPDATE SSS_dgia_202410
        SET TIEN_THULAO_GOI = CASE
                        WHEN CK_GOI_TLDG >= 1 and TENKIEU_LD ='ptm-goi'
                                 and MANV_PTM is not null and KENH_TRONG = 1
                            THEN DTHU_DONGIA_GOI * HESO_HHBG
                        WHEN CK_GOI_TLDG = 0 THEN 0
                    END
      where TIEN_THULAO_GOI is null

        ;

--===== #vde LOẠI TRỪ các trường hợp
--PBH ONL: (các TB ptm có mua gói kích hoạt bởi nv PBHOL) OR (kích PTM GÓI) thì sẽ tính đơn giá.
--          chỉ kích TB PTM --> 0 tính.
--pending
   UPDATE SSS_dgia_202410 a
SET TIEN_THULAO_GOI = CASE
    -- Trường hợp 1: Cả hai dòng có cùng ma_pb = 'VNP0703000'
    WHEN EXISTS (
        SELECT 1
        FROM SSS_dgia_202410 b
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
             FROM SSS_dgia_202410 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN a.DTHU_DONGIA_GOI * a.HESO_HHBG

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm' and a.CK_GOI_TLDG > 0
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1
             FROM SSS_dgia_202410 d
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
        FROM SSS_dgia_202410 b
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
             FROM SSS_dgia_202410 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN TIEN_THULAO_DNHM

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm'
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1
             FROM SSS_dgia_202410 d
             WHERE a.ma_tb = d.ma_tb
               AND d.tenkieu_ld = 'ptm-goi'
               AND d.ma_pb <> 'VNP0703000'
         ) THEN 0
    --Trường hợp 4: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm đứng 1 mình
     WHEN a.tenkieu_ld = 'ptm'
            AND a.ma_pb = 'VNP0703000'
            AND (
                SELECT COUNT(*)
                FROM SSS_dgia_202410 d
                WHERE a.ma_tb = d.ma_tb
            ) = 1
            THEN 0

    -- Trường hợp còn lại không thay đổi
    ELSE a.TIEN_THULAO_DNHM
END
,lydo_khongtinh = CASE
        WHEN (a.TIEN_THULAO_GOI = 0 and a.ma_pb = 'VNP0703000' and a.TENKIEU_LD ='ptm-goi') OR (a.TIEN_THULAO_DNHM = 0 and a.ma_pb = 'VNP0703000'and a.TENKIEU_LD ='ptm') THEN 'PBH ONL'
        ELSE a.lydo_khongtinh
    END
;

--24/10 đã comment vì đang fix xóa luôn những gói chu kỳ ngắn này
-- update SSS_dgia_202410
-- set LYDO_KHONGTINH ='CK gói = 0'
-- where manv_ptm is not null and CK_GOI_TLDG = 0 and TENKIEU_LD ='ptm-goi' and LYDO_KHONGTINH is null
-- ;

--#vde: các trường hợp when case loại trừ ko tính
   UPDATE SSS_dgia_202410
SET TIEN_THULAO_GOI = 0,
    TIEN_THULAO_DNHM = 0,
    heso_hhbg =0 ,
    LYDO_KHONGTINH = CASE
                        WHEN ma_pb = 'VNP0700800' THEN 'PTTT ko tinh'
                        WHEN BUNDLE_XK = 1 AND tenkieu_ld = 'ptm-goi' THEN 'Bundle_xk không tính đơn giá gói'
                        WHEN PHAN_LOAI_KENH = 'CTVXHH' OR manv_dktt LIKE 'P%' THEN 'CTVXHH ko tính đơn giá'
                        WHEN ten_goi IN (SELECT ten_goi FROM dm_goi_loai_tru) THEN ten_goi || ' ko tinh'
                        WHEN DAI_LY = 1 AND TENKIEU_LD = 'ptm' THEN 'PTM bởi đại lý không tính'
                        WHEN DAI_LY = 1 AND TENKIEU_LD = 'ptm-goi' THEN 'PTM gói bởi đại lý không tính'
                        ELSE LYDO_KHONGTINH -- Giữ nguyên lý do nếu không rơi vào trường hợp nào
                     END
WHERE BUNDLE_XK = 1 AND tenkieu_ld = 'ptm-goi'
   OR ma_pb = 'VNP0700800'
   OR PHAN_LOAI_KENH = 'CTVXHH'
   OR manv_dktt LIKE 'P%'
   OR ten_goi IN (SELECT ten_goi FROM dm_goi_loai_tru)
   OR DAI_LY = 1;

update SSS_dgia_202410
set HESO_HHBG = 0
where TENKIEU_LD ='ptm'
;


        update SSS_dgia_202410
        set TIEN_THULAO_GOI = 0
        where TIEN_THULAO_GOI is null
        ;
        update SSS_dgia_202410
        set TIEN_THULAO_DNHM = 0
        where TIEN_THULAO_DNHM is null
        ;
        update SSS_dgia_202410
        set THANG_BD = 202410
            ,DTHU_DONGIA_DNHM = 20000
            ,thang_kt = 202410
         where TENKIEU_LD ='ptm'

        ;



----===========================KÉO ĐẾN DAY LA XONG BANG FULL 1 PTM NHIEU PTM-GOI--------------------------================






select * from one_line_202410 where ma_tb  in ('84814005472','84816240746','84814387588');
select * from SSS_dgia_202410_2 where ma_tb ='84916374837';
select * from SSS_dgia_202410 where ma_tb ='84813461192';









----=== đơn giá THỦ ĐỨC
select * from khieunai_td_dgia;
update SSS_dgia_202410 a
set USERNAME_KH = (select x.NGUOI_THAYTHE x from khieunai_td_dgia x
                                            where x.thang = 202410
                                               and x.MA_TB = a.ma_tb
                                               and x.ma_tiepthi = username_kh)
, manv_thaythe = (select x.NGUOI_THAYTHE x from khieunai_td_dgia x
                                            where x.thang = 202410
                                               and x.MA_TB = a.ma_tb
                                               and x.ma_tiepthi = username_kh)
where a.ma_tb in (select ma_tb from khieunai_td_dgia where thang = 202410)
    and a.TENKIEU_LD ='ptm'
;
      update SSS_dgia_202410 a
        set (manv_ptm,tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.USERNAME_KH)
    where ma_tb in  (select ma_tb from khieunai_td_dgia where thang = 202410) and TENKIEU_LD ='ptm'
      ;
      drop index idx_tmp;
---những manv_goi ở bên 1 dòng nếu null --> kiểm tra cột tiền gói coi = 0 ko ? gán 0
-----------------====== NHÁP:





        select distinct LYDO_KHONGTINH from SSS_dgia_202408
                                       where ( TIEN_THULAO_DNHM = 0 or TIEN_THULAO_GOI =0)
                                            and MANV_PTM is not null
                                            and TENKIEU_LD in ('ptm','ptm-goi')
        ;

;








-----------------------================= TAO BANG 2 DONG, MOI STB 1 GOI VKCK HPHUC ============================
select * from SSS_dgia_202410_2 ;
drop table SSS_dgia_202410_2;

create table SSS_dgia_202410_2 as -- tạo bảng 2 dòng ( ptm và chỉ 1 gói)

    WITH RankedRows AS (
            -- Lấy dòng có tenkieu_ld là 'ptm-goi' với TIEN_GOI lớn nhất cho mỗi ma_tb
            SELECT a.*,
                   ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.kenh_trong DESC, a.TIEN_GOI DESC, a.ngay_kh DESC) AS rnk,
                   COUNT(*) OVER (PARTITION BY a.ma_tb) AS cnt
            FROM SSS_dgia_202410 a
            WHERE a.tenkieu_ld = 'ptm-goi'
        )
SELECT *
FROM (
    -- Lấy những dòng có tenkieu_ld là 'ptm'
    SELECT a.*,999 flag_a,111 flag_b
    FROM SSS_dgia_202410 a
    WHERE a.tenkieu_ld = 'ptm'

    UNION ALL

    -- Lấy dòng có tenkieu_ld là 'ptm-goi' với điều kiện manv_ptm
    SELECT a.*
    FROM RankedRows a
    WHERE (cnt = 1 AND MANV_PTM IS not NULL)
       OR (rnk = 1 AND cnt > 1 AND manv_ptm IS NOT NULL)
)
;


-- drop table one_line_202410;
drop table one_line_202410;
CREATE TABLE one_line_202410 AS
  (SELECT thang_ptm,
        LISTAGG(nguon, '; ') WITHIN GROUP (ORDER BY TENKIEU_LD)              AS nguon,
        LISTAGG(phan_loai_kenh, '; ') WITHIN GROUP (ORDER BY TENKIEU_LD)     AS phan_loai_kenh,
        ma_tb,
        MAX(ten_goi)                                                         AS ten_goi,
        MAX(ck_goi_tldg)                                                     AS ck_goi_tldg,
        MAX(CASE WHEN tenkieu_ld = 'ptm' THEN manv_ptm END)                  AS manv_ptm,
        MAX(CASE WHEN tenkieu_ld = 'ptm' THEN manv_goc END)                  AS manv_goc,
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
        max(heso_hhbg)                                                       AS heso_hhbg,
        max(heso_kk)                                                         AS heso_kk,
        MAX(tien_thulao_goi + NVL(tien_thulao_kk, 0))                        AS tien_thulao_goi,
        dthu_KPI,
        0 dthu_dnhm_kpi,
        LISTAGG(lydo_khongtinh, '; ') WITHIN GROUP (ORDER BY TENKIEU_LD)     AS lydo_khongtinh,
         CAST(null AS VARCHAR2(100))                                         as LYDO_KHONGTINH_KPI
 FROM SSS_DGIA_202410_2
 GROUP BY ma_tb, thang_ptm, dthu_KPI);

----update xử mục 2 a mẫn
update one_line_202410
set manv_goi = manv_ptm
    ,MATO_GOI = MATO_PTM
    , MAPB_GOI = mapb_ptm
where manv_goi is null and ten_goi is null
;

--tìm nhan vien đat chỉ tieu KK:
            select manv_goi,ten_goi from one_line_202410 where manv_goi in
              (SELECT ma_nv
            FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
            WHERE thang = 202410 and dinhmuc_2 IN (32000000, 30000000)
              AND ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17')
              AND KQTH >= dinhmuc_2
              AND KHDK >= dinhmuc_2);



update SSS_DGIA_202410
set TIEN_THULAO_KK = 0;
update SSS_DGIA_202410
set HESO_KK = 0;

-- UPDATE SSS_dgia_202410
-- SET HESO_KK = CASE
--                 WHEN
--                    ma_pb = 'VNP0700800'
--                   OR PHAN_LOAI_KENH = 'CTVXHH'
--                   OR manv_dktt LIKE 'P%'
--                   OR ten_goi IN (SELECT ten_goi FROM dm_goi_loai_tru)
--                   OR DAI_LY = 1
--                 THEN 0
--                 ELSE 0.05
--               END;
--

select manv_goi from one_line_202410 where heso_kk = 0.05 --check coi đủ SL NV ở query select trên
group by manv_goi;

-----ALL update tien KK
update one_line_202410
set heso_kk = 0.05
where manv_goi in (select ma_nv FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
                    WHERE thang = 202410 and
                        dinhmuc_2 IN (32000000, 30000000)
                      AND ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17')
                      AND KQTH >= dinhmuc_2
                      AND KHDK >= dinhmuc_2)
and CK_GOI_TLDG>0
;
--note chạy lại lần 2 sẽbi de` tien`
update one_line_202410
set TIEN_THULAO_GOI = nvl(TIEN_THULAO_GOI+(DTHU_DONGIA_GOI*HESO_KK),0)
where heso_kk = 0.05
;
update one_line_202410
set TIEN_THULAO_GOI = nvl(DTHU_DONGIA_GOI,0)*heso_hhbg+(nvl(DTHU_DONGIA_GOI,0)*HESO_KK)
;

select *
from one_line_202410
where heso_kk = 0.05;
---end update tien KK

--bs thang 10:
select * from bosung_T10;
select manv_goi,ten_goi from bosung_T10 where manv_goi in
              (SELECT ma_nv
            FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
            WHERE thang = 202409 and dinhmuc_2 IN (32000000, 30000000)
              AND ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17')
              AND KQTH >= dinhmuc_2
              AND KHDK >= dinhmuc_2);
update bosung_T10
set TIEN_THULAO_GOI = nvl(DTHU_DONGIA_GOI,0)*heso_hhbg + (nvl(DTHU_DONGIA_GOI,0)*HESO_KK)
;
update bosung_T10
set DTHU_KPI = round(DTHU_DONGIA_GOI/1.1,0)
where HESO_KK = 0;

select * from vietanhvh.BOSUNG_T10
where ma_tb in (
    '84837981109',
'84822829006',
'84919794246',
'84917150409'
    )
;
 select * from (
           select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG,
             MANV_GOI ma_nv,b.ten_nv, MATO_GOI ma_to,b.ten_to, MAPB_GOI ma_pb,b.ten_pb,'mua_goi' tenkieu_ld, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
             DTHU_KPI, LYDO_KHONGTINH
         from vietanhvh.one_line_202410 a
         join ttkd_bsc.nhanvien b on b.thang = a.thang_ptm and a.manv_goi = b.ma_nv
            union all
         select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM ma_nv, TENNV_PTM,
            MATO_PTM ma_to, TENTO_PTM, MAPB_PTM ma_pb, TENPB_PTM,'ptm' tenkieu_ld, TIEN_DNHM, DTHU_DONGIA_DNHM, TIEN_THULAO_DNHM
--         MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
         , DTHU_DNHM_KPI, LYDO_KHONGTINH
         from vietanhvh.one_line_202410
union all
 select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG,
             MANV_GOI ma_nv,b.ten_nv, MATO_GOI ma_to,b.ten_to, MAPB_GOI ma_pb,b.ten_pb,'mua_goi' tenkieu_ld, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
             DTHU_KPI, LYDO_KHONGTINH
         from vietanhvh.bosung_T10 a
           join ttkd_bsc.nhanvien b on b.thang = a.thang_ptm and a.manv_goi = b.ma_nv



         ) where ma_tb ='84917150409';
