-- 7 nguồn báo cáo
--TUT: https://docs.google.com/spreadsheets/d/1TrjBsTbEde6fXFudJZ8kI3rM92wmmIZJ9eSuKAkAFEU/edit?usp=sharing
--=====================CHECK ĐÃ IMPORT CHƯA ?-======================
select count(*) from manpn.bscc_ptm_bris_P01_moi  where thang = 202502; --bscc_import_ptm_bris_pl01_moi
select * from manpn.bscc_import_ptm_smrs where thang = 202502;
select * from manpn.BUNDLE_XUATKHO_PDH where thang_KH = 202502;
select count(*) from manpn.BSCC_DIGI_DONLE where thang = 202502;
select * from manpn.BSCC_DIGI where thang = 202502;
select count(*) from MANPN.BSCC_IMPORT_BUNDLE_SMRS_CT where thang = 202502;
select count(*) from MANPN.BSCC_IMPORT_BUNDLE_SMRS where thang = 202502;
select count(*) from manpn.bscc_import_goi_bris_p04 where thang = 202502;
select * FROM manpn.bscc_import_kenh_noibo where thang = 202502 ;
select count(*) from manpn.BSCC_IMPORT_CHUOI_TOAN_QUOC where thang = 202502;
select count(*) from manpn.kpi_kenhban_ngoai_noibo@ttkddbbk2 where thang = 202502;

select * from manpn.bscc_ptm_bris_P01_moi;

update MANPN.BSCC_IMPORT_BUNDLE_SMRS
set thang = 202502
 where thang  is null;
update manpn.bscc_import_kenh_noibo
set thang = 202502
 where thang  is null;
update manpn.bscc_import_goi_bris_p04
set thang = 202502
where thang is null
;


----Phân rã đơn giá:
select THANG_PTM, MA_TB, NGAY_KH, USERNAME_KH , ''nv_thay_the from SSS_dgia_202502  where MANV_DKTT ='halv_hcm' and tenkieu_ld='ptm';



select * from ttkd_bsc.ds_diemban_31import where ma_diem_ban in ('HCM1652987KDDDTTGDDBPT') and thang = 202502; --20256
delete from SSS_DGIA_202502; where TENKIEU_LD ='ptm-goi';
----insert PTM:
--        insert into SSS_dgia_202502(MA_TB, nguon, username_kh, thang_ptm, MANV_DKTT, tenkieu_ld, ngay_kh)
-- with cte as(
--     SELECT TO_CHAR(SO_ELOAD) AS ELOAD, A.*
--     FROM(
--         SELECT case when INSTR(a.MA_NHAN_VIEN, '_') > 0 then UPPER(SUBSTR(a.MA_NHAN_VIEN, 1, INSTR(a.MA_NHAN_VIEN, '_')-1))
--                else a.MA_NHAN_VIEN end ma_nv
--             , A.*, ROW_NUMBER() OVER(PARTITION BY SO_ELOAD ORDER BY LOAI_DIEM_BAN DESC) RA
--         FROM manpn.kpi_kenhban_ngoai_noibo@ttkddbbk2 A
--         WHERE THANG = 202502
--         ) A
--     WHERE RA = 1
--     ),
--     NVVV AS(
--     SELECT UPPER(SUBSTR(MAIL_VNPT, 1, INSTR(MAIL_VNPT, '@')-1)) AS MAIL, C.* FROM (select * from ttkd_bsc.nhanvien where thang = 202502) C
--     WHERE THANG = 202502
--     )
-- select A.so_tb, 'bris', c.ma_nv , A.THANG, A.MA_HRM_CUA_NHAN_VIEN_QUAN_LY_US, 'ptm', NGAY_KICH_HOAT
-- from manpn.bscc_ptm_bris_P01_moi a
--     left join cte b on a.MA_CUA_USER_TIEP_THI_TB = b.MA_DIEM_BAN
--     left join NVVV C ON b.MA_Nv = C.MAIL AND C.THANG = 202502
--     where a.thang = 202502
--     and b.ma_diem_ban is not null
--     and DIEM_CHAM_TIEP_THI_TB in ('DIGISHOPAPP', 'App DigiShop TNTTTB KIT')
--     and CONG_CU_DKTTTB in ('One App', 'App DigiShop TNTTTB KIT')
;
delete
from SSS_dgia_202502;
create table SSS_dgia_202502 as
select * from SSS_dgia_202501 where 1=0
;
--thang2 p01 76030 recs
create table P01_202502 as
(SELECT MO_KEY, DAY_KEY, GEO_STATE_KEY_DTCP, TEN_PBH_DTCP, TEN_TO_DTCP, ACCS_MTHD_KEY, ACTV_TYPE, LOAI_SIM, ACC_NAME, ACTVTN_DT, ACCOUNT_DK, CONGCU_DK, CHANNEL_TYPE_ID_DTCP, LOAIKENH_DTCP, THANHVIEN_DTCP, SL_CHNL_REGISTER_KEY, REGISTER_CHANNEL_TYPE, REGISTER_CHANNEL_MEMBER, HRM_USER_DK, TEN_USER_DK, LOAI_KENH, NGAY_TAO_DH, NGAY_DH_THANH_CONG, DT_HOA_MANG, TOTAL_TKC_GOI_ALL, SERVICE_CODE, P2_CHUKY, HRM_STAFF_ASSIGN, MA_TINH_DK_GOI, TOTAL_COMMISSION, DT_TKC_AND_BUNDLE FROM OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt
                 where mo_key=202502
            and GEO_STATE_KEY_DTCP = 35)
;

 insert into SSS_dgia_202502(nguon,ma_tb,username_kh,manv_dktt,tenkieu_ld,thang_ptm,ngay_kh)
   select 'bris',ACCS_MTHD_KEY,nvl(MA_KENH_BAN,ACCOUNT_DK),nvl(MA_KENH_BAN,ACCOUNT_DK),'ptm',MO_KEY, ACTVTN_DT
        from (SELECT * FROM OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt
                 where mo_key=202502
            and GEO_STATE_KEY_DTCP = 35)
            ;
-----------
    insert into SSS_dgia_202502(nguon,ma_tb,username_kh,manv_dktt,tenkieu_ld,thang_ptm,ngay_kh)
    ;select 'bris',so_tb,nvl(MA_CUA_USER_TIEP_THI_TB,USER_ELOAD_DK_TTTB),nvl(MA_CUA_USER_TIEP_THI_TB,USER_ELOAD_DK_TTTB),'ptm',thang, NGAY_KICH_HOAT
        from manpn.bscc_ptm_bris_P01_moi
            where thang = 202502
            and  so_tb not in (select ma_tb from SSS_dgia_202502 where tenkieu_ld = 'ptm')
            ;
    -----------
   MERGE INTO SSS_dgia_202502 a
USING (
    SELECT ma_tb, ma_hrm
    FROM (
        SELECT a.SDT_MUA ma_tb,
               a.MA_CTV_DAILY AS ma_hrm
               ,ROW_NUMBER() OVER (PARTITION BY a.SDT_MUA ORDER BY b.MA_HRM) AS rn
        FROM (select * from manpn.bscc_import_ptm_shopctv a  where thang = 202502) a
        LEFT JOIN manpn.kpi_kenhban_ngoai_noibo@ttkddbbk2 b
            ON a.MA_CTV_DAILY = b.MA_DIEM_BAN
            AND b.thang = 202502
    )
    WHERE rn = 1
) x
ON (a.ma_tb = x.ma_tb)
WHEN MATCHED THEN
    UPDATE SET a.username_kh = x.ma_hrm
      ;
---------
    insert into SSS_dgia_202502(nguon,ma_tb,username_kh,tenkieu_ld,thang_ptm,ngay_kh)
    select 'smrs','84' || SUBSCRIBER_ID a, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
    from manpn.bscc_import_ptm_smrs
    where thang = 202502
        and  '84' || SUBSCRIBER_ID not in (select ma_tb from SSS_dgia_202502 where tenkieu_ld = 'ptm');

    ------------

-- T10 ko tinh
    insert into SSS_dgia_202502(nguon,ma_tb,username_kh,manv_ptm,tenkieu_ld,thang_ptm,ngay_kh)
    select 'luongtinh',somay,nguoi_gt,manv_ptm,'ptm',TO_NUMBER(TO_CHAR((ngay_ld), 'YYYYMM')),ngay_ld
    from TTKD_BSC.DT_PTM_VNP_202502
    where goi_luongtinh is not null
    ;
----insert gói PTM:
    --bundle_xk
    insert into SSS_dgia_202502(nguon,ma_tb,username_kh,TEN_GOI,tenkieu_ld,tien_goi,thang_ptm,manv_ptm,ma_pb,ngay_kh)
    SELECT 'bundle_xuatkho', B.MA_TB, ACCOUNT_DK, LOAI_SIM,'ptm-goi', GIA_GOI, THANG_KH, MA_NV, MA_PB
        ,(select ngay_kh from SSS_dgia_202502 where tenkieu_Ld = 'ptm' and ma_tb=b.ma_tb)
    FROM (
            SELECT B.*, ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY ngay_CN DESC) AS row_num
            FROM manpn.BUNDLE_XUATKHO_PDH B
             WHERE B.THANG_KH = 202502
        ) B
       where
           B.row_num = 1
          and B.MA_TB IN (SELECT A.MA_TB FROM SSS_dgia_202502 A WHERE tenkieu_ld='ptm')
    ;
    ----IMPORT gói c?a kênh Digishop tr??c: https://digishop.vnpt.vn/digitalShop/stats/statsMobileDetail // ct sim so
    INSERT INTO SSS_dgia_202502 (thang_ptm,nguon, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_sim','ptm-goi', STB, GIA_GOI, TEN_GOI, KHOI_TAO_SIM__HRM--MA_TIEPTHI: thang 10 bug thay bang khoi tao sim o thang 11
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO,thang
    FROM manpn.BSCC_DIGI
    WHERE THANG = 202502
        and LOAI_TB like 'Tr_ tr__c' --tra truoc
        and TRANG_THAI = 'Thành công'--bug
    AND STB IN (SELECT MA_TB FROM SSS_dgia_202502 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202502 WHERE tenkieu_ld = 'ptm-goi');

    ----
    INSERT INTO SSS_dgia_202502 (THANG_ptm,nguon, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd)
    SELECT thang, 'digishop_pac', 'ptm-goi', STB, GIA_GOI, TEN_GOI, MA_GIOI_THIEU_DH
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO_DON,
        thang
    FROM manpn.BSCC_DIGI_DONLE
    WHERE THANG = 202502 and ngay_hoan_thanh is not null -- tại 1 tb có nhiều dòng gói giống nhau, nhưng chỉ có 1 dòng có ngay_ht là dky thành công
    AND STB  IN (SELECT MA_TB FROM SSS_dgia_202502 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202502 WHERE tenkieu_ld = 'ptm_goi');

    -----
    INSERT INTO SSS_dgia_202502  (thang_ptm,tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi,  ngay_kh,thang_bd)
    SELECT thang,'ptm-goi',CASE WHEN MUC_CK = 0 THEN LOWER(KENH_XUAT_BAN) ELSE 'bundle' END,
                    B.MSISDN, ACCOUNT_DK, SERVICE_CODE, GIA_GOI, to_date(substr(NGAY_KH,1,instr(NGAY_KH, '2025')+3), 'mm/dd/yyyy'),thang
    FROM manpn.BSCC_IMPORT_BUNDLE_SMRS_CT B
    WHERE B.THANG = 202502
    AND B.MSISDN IN (SELECT A.MA_TB FROM SSS_dgia_202502  A WHERE tenkieu_ld='ptm')
        AND B.MSISDN NOT IN (SELECT MA_TB FROM SSS_dgia_202502 A WHERE tenkieu_ld='ptm-goi')
        ;
        --SMRS-bundle:
    INSERT INTO SSS_dgia_202502 (tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi, THANG_ptm, ngay_kh,thang_bd) -- ko co chu -ky trong file
    SELECT 'ptm-goi',CASE WHEN KENH = 'Shop' then 'shop' ELSE 'bundle' END, '84'||B.SUBSCRIBER_ID, ACCOUNT_DK, TEN_GOI, GIA_GOI, THANG, NGAY_KH,thang
    FROM manpn.BSCC_IMPORT_BUNDLE_SMRS B
    WHERE THANG = 202502
    AND '84'||B.SUBSCRIBER_ID IN (SELECT A.MA_TB FROM SSS_dgia_202502 A WHERE tenkieu_ld='ptm')
    AND '84'||B.SUBSCRIBER_ID NOT IN (SELECT MA_TB FROM SSS_dgia_202502 A WHERE tenkieu_ld='ptm-goi');

    --bris
   INSERT INTO SSS_dgia_202502  ( thang_ptm,nguon, MA_TB, ten_goi, CK_GOI, tien_goi, -- bỏ cột loại _kênh
    username_kh, MANV_PTM, tenkieu_ld,  ngay_kh)
WITH rnk_data AS (
    SELECT thang, LOWER(REGIS_SYSTEM_CD) AS CONG_CU_BAN_GOI, ACCS_MTHD_KEY, SERVICE_CODE, P2_CHUKY,
           TOT_RVN_PACKAGE, USER_CODE, HRM_CODE,
           'ptm-goi' AS TENKIEU_LD, REGIS_DT AS NGAY_DK_GH_GOI,
           ROW_NUMBER() OVER (PARTITION BY ACCS_MTHD_KEY, REGIS_DT, SERVICE_CODE
                              ORDER BY ACTVTN_DT DESC) AS rn
    FROM manpn.bscc_import_goi_bris_p04
    WHERE LOAIHINH_TB = 'TT'
        and LOAI_TB_THANG ='PTM'
    AND THANG = 202502
    AND ACCS_MTHD_KEY IN (SELECT MA_TB
                  FROM SSS_dgia_202502
                  WHERE tenkieu_ld = 'ptm')
    AND ACCS_MTHD_KEY NOT IN (SELECT MA_TB
                      FROM SSS_dgia_202502
                      WHERE tenkieu_ld = 'ptm-goi'
                      AND tien_goi > 0)
    AND ACCS_MTHD_KEY NOT IN (SELECT MA_TB
                      FROM SSS_dgia_202502
                      WHERE tenkieu_ld = 'ptm-goi'
                      AND nguon = 'bundle_xuatkho')
    AND lower(REGIS_SYSTEM_CD) not in ('selfcare')
    AND P2_CHUKY is not null
)
SELECT THANG, CONG_CU_BAN_GOI, ACCS_MTHD_KEY, SERVICE_CODE, P2_CHUKY,
           TOT_RVN_PACKAGE, USER_CODE, HRM_CODE, TENKIEU_LD, NGAY_DK_GH_GOI
FROM rnk_data
WHERE rn = 1;
--insert case PTM o tinh khac nhung HCM kich goi: bat dau su dung o thang luong 2
    INSERT INTO SSS_dgia_202502  ( thang_ptm,nguon, MA_TB, ten_goi, CK_GOI, tien_goi, -- bỏ cột loại _kênh
    username_kh, MANV_PTM, tenkieu_ld,  ngay_kh);
select thang,'goi-HCM',accs_mthd_key,SERVICE_CODE,P2_CHUKY,TOT_RVN_PACKAGE,USER_NAME,HRM_CODE,USER_CODE,'ptm-goi',REGIS_DT,STAFF_NAME
from  manpn.bscc_import_goi_bris_p04 b WHERE b.LOAIHINH_TB = 'TT'
                    AND b.LOAI_TB_THANG = 'PTM'
                    AND b.THANG = 202502 and b.USER_NAME is not null
and accs_mthd_key not in (select ma_tb from SSS_dgia_202502 );

--//thang 12 da test (KQ:    )-thang 12 chay code inss bris tren xem co bnhiu rec dc add, roi so sanh voi code nay
    INSERT INTO SSS_dgia_202502 (thang_ptm, nguon, MA_TB, ten_goi, CK_GOI, tien_goi,
                           username_kh, MANV_PTM, tenkieu_ld, ngay_kh)
;
with tmp_data as (SELECT thang,
                         LOWER(REGIS_SYSTEM_CD) AS CONG_CU_BAN_GOI,
                         ACCS_MTHD_KEY,
                         SERVICE_CODE,

                         P2_CHUKY,
                         TOT_RVN_PACKAGE,
                         USER_CODE,
                         HRM_CODE,
                         'ptm-goi'              AS TENKIEU_LD,
                         (REGIS_DT)             AS NGAY_DK_GH_GOI,
                         ROW_NUMBER() OVER (
                             PARTITION BY ACCS_MTHD_KEY, REGIS_DT, SERVICE_CODE
                             ORDER BY ACTVTN_DT DESC
                             )                  AS rn

                  FROM manpn.bscc_import_goi_bris_p04 b
                  LEFT JOIN SSS_dgia_202502 x1
                  ON b.ACCS_MTHD_KEY = x1.MA_TB
--
                  WHERE b.LOAIHINH_TB = 'TT'
                    AND b.LOAI_TB_THANG = 'PTM'
                    AND b.THANG = 202502
                    AND x1.MA_TB IS NOT NULL -- Chỉ lấy các bản ghi có trong bảng `x_code_202502` với `tenkieu_ld = 'ptm'`
--                     and SERVICE_CODE <> x1.TEN_GOI -- Loại bỏ các bản ghi đã tồn tại với `tenkieu_ld = 'ptm-goi'`
                    AND lower(b.REGIS_SYSTEM_CD) not in ('selfcare')
)
select THANG, CONG_CU_BAN_GOI, ACCS_MTHD_KEY, SERVICE_CODE, P2_CHUKY, TOT_RVN_PACKAGE, USER_CODE, HRM_CODE, TENKIEU_LD, NGAY_DK_GH_GOI
from tmp_data where rn = 1;
//--
    --=====

    ;
----- END IMPORT ------
--
     delete from SSS_dgia_202502 where( tenkieu_ld ='ptm-goi' and CK_GOI_TLDG = 0) or nguon in( 'selfcare','myvnpt')
        or ten_goi in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang ='N' or chu_ky_thang is null)
                    or ten_goi in (select ten_goi  from DM_GOI_LOAI_TRU);;
---UPDTAE manv_ptm:
--- Cho trường hợp các phòng bán hàng gán manv mới,
    update SSS_dgia_202502
    set manv_dktt = username_kh
    where manv_dktt is null;
     --tạo index cho lẹ xog xóa chứ udpate lâu quá :((
     drop index idx_tmp;
    create index idx_tmp on SSS_dgia_202502(ma_tb,username_kh);
    ;
       UPDATE SSS_dgia_202502 a
SET MANV_PTM = (
    SELECT ma_nv
    FROM (
        SELECT b.ma_nv,
               ROW_NUMBER() OVER (PARTITION BY b.USER_CCBS ORDER BY b.ma_nv DESC) AS row_num
        FROM ttkd_bsc.nhanvien b
        WHERE b.thang = 202502
        AND b.USER_CCBS = a.username_kh
    ) x
    WHERE x.row_num = 1
)
WHERE manv_ptm IS NULL;

        update SSS_dgia_202502 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202502 and b.USER_CCOS = a.username_kh)
        where manv_ptm is null
        ;
        update SSS_dgia_202502 a
        SET MANV_PTM = (SELECT c.ma_nv
                     FROM manpn.bscc_import_kenh_noibo b
                     JOIN ttkd_bsc.nhanvien c
                       ON c.thang = 202502
                      AND SUBSTR(C.MAIL_VNPT, 1, INSTR(C.MAIL_VNPT, '@') - 1) = LOWER(
                           CASE
                              WHEN INSTR(b.MA, '_') > 0 THEN SUBSTR(b.MA, 1, INSTR(b.MA, '_') - 1)
                              ELSE b.MA
                           END
                       )
                    WHERE b.thang = 202502
                      AND b.SO_ELOAD = a.username_kh
                  )
        WHERE MANV_PTM IS NULL;
        ;
        --TH appemployee bi loi~ ko ghi nhan goi cho nv thuc hien toan trinh
            update SSS_dgia_202502 a
            set (username_kh,MANV_DKTT,manv_ptm) = (select x.manv_ptm,x.manv_ptm,x.manv_ptm from  SSS_dgia_202502 x where x.ma_tb =a.ma_tb and x.TENKIEU_LD='ptm'  )
            where TENKIEU_LD = 'ptm-goi'
            and nguon ='appemployee' and MANV_PTM is null
            ;
select * from ttkd_bsc.ds_diemban_31import where thang = 202502;
        --nhan vien quan li diem ban khoi up
        MERGE INTO SSS_dgia_202502 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = d.ma_diem_ban AND d.thang = 202502)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.username_kh in (select (ma_diem_ban) from ttkd_bsc.ds_diemban_31import where thang = 202502);


            MERGE INTO SSS_dgia_202502 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = to_char(d.so_eload) AND d.thang = 202502)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.username_kh in (select to_char(so_eload) from ttkd_bsc.ds_diemban_31import where thang = 202502)
        and a.manv_ptm IS NULL
             ;
 ;
;
        UPDATE SSS_dgia_202502 a
        SET MANV_PTM = (
            SELECT b.ma_nv
            FROM ttkd_bsc.nhanvien b
            WHERE manv_dktt = b.ma_nv and thang = 202502
        )
        WHERE a.manv_ptm IS NULL
        ;
        update SSS_dgia_202502  a
        set manv_ptm = (
                        select x.ma_nv from ttkd_bsc.nhanvien x
                        join nhuy.userld_202502_goc y
                            on x.mail_vnpt = y.email and x.thang = a.thang_ptm
                            where a.manv_dktt = y.user_ld
                )
        where manv_ptm is null
        ;
update SSS_DGIA_202502 a
set MANV_PTM = (select x.MA_NVSC from bscc_import_ptm_shopctv x where a.ma_tb = x.SDT_MUA and x.trang_thai ='Thành công' and x.thang = 202502 )
where MANV_DKTT like '%LK%'  AND TENKIEU_LD ='ptm';
--===UPDATE thông tin nhân viên:
 UPDATE SSS_dgia_202502 a
SET (tennv_ptm, ma_to, ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) =
(
    SELECT t.ten_nv, t.ma_to, t.ten_to, t.ma_pb, t.ten_pb, t.ma_vtcv, t.NHOMLD_ID
    FROM (
        SELECT x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID,
               ROW_NUMBER() OVER (PARTITION BY x.ma_nv ORDER BY x.ma_nv DESC) AS row_num
        FROM ttkd_bsc.nhanvien x
        WHERE x.thang = a.thang_ptm
        AND x.ma_nv = a.manv_ptm
    ) t
    WHERE t.row_num = 1
)
WHERE a.tennv_ptm IS NULL;
;


       ;
         update SSS_dgia_202502 a
         set loai_ld = (select x.TENNHOM_TAT from  ttkd_bsc.dm_nhomld x where x.NHOMLD_ID = a.nhom_tiepthi)
         where a.loai_ld is null
        ;
update SSS_dgia_202502
    set MANV_GOC = MANV_PTM;

---===UPDATE PHAN_LOAI_KENH:
            merge into SSS_dgia_202502 a
            using ttkd_bct.va_dm_loaikenh_bh x
            on (a.username_kh = x.ma_nd and x.thang = 202501)
            when matched then
                update set a.phan_loai_kenh = x.phanloai_kenh
                where a.phan_loai_kenh is null
                ;
            --UPDATE kênh nội bộ/đại lý

                        MERGE INTO SSS_dgia_202502 a
                            USING manpn.BSCC_IMPORT_CHUOI_TOAN_QUOC m
                            ON (a.ma_tb = m.so_thue_bao AND a.THANG_PTM = m.thang)
                            WHEN MATCHED THEN
                            UPDATE SET a.dai_ly = 1 ,a.kenh_trong = 0;
                        UPDATE SSS_dgia_202502
                            SET dai_ly = 1
                            ,kenh_trong = 0
                            WHERE PHAN_LOAI_KENH = 'Chuỗi toàn quốc';


            --dai_ly = 1, kenh_trong =0 khi là đại lí <=> cột kênh trong = 0
            UPDATE SSS_dgia_202502 a
                    SET dai_ly = 1
                        ,kenh_trong = 0
                    where a.username_kh in (select m.ma_diem_ban FROM ttkd_bsc.ds_diemban_31import m
                            WHERE m.thang = 202502)
                        OR a.username_kh in (select to_char(m.so_eload) FROM ttkd_bsc.ds_diemban_31import m
                            WHERE m.thang = 202502)
                            ;

            UPDATE SSS_dgia_202502
              set kenh_trong =  case when ((kenh_trong is null or kenh_trong =0) and manv_ptm is not null) then 1
                    else 0 end;
            UPDATE SSS_dgia_202502
              set dai_ly = 0
              where dai_ly is null
               ;


            --xác định các bundle xuất kho khong tính đơn giá gói chỉ tính đơn giá HMM
            --note 14/11: edit thanh merge di chu update waste 7p,9p lun
                   MERGE INTO SSS_dgia_202502 a
                    USING (
                        SELECT ma_tb, 1 AS bundle_xk
                        FROM (
                            SELECT b.ma_tb, ROW_NUMBER() OVER (PARTITION BY b.ma_tb ORDER BY b.ngay_CN DESC) AS row_num
                            FROM manpn.BUNDLE_XUATKHO_PDH b
                            WHERE b.THANG_KH = 202502
                        ) b
                        WHERE b.row_num = 1  -- Chỉ lấy bản ghi mới nhất cho mỗi ma_tb
                    ) b
                    ON (a.ma_tb = b.ma_tb AND a.THANG_PTM = 202502)
                    WHEN MATCHED THEN
                        UPDATE SET a.bundle_xk = b.bundle_xk;


----======
-- update tiền gói bình thường trừ bundle xuát kho, lí do báo cáo bị thiếu mới update
        update SSS_dgia_202502 a
                    set tien_goi = (select x.GIA_GOI from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x where a.TEN_GOI = x.goi_cuoc)
                        ,DTHU_DONGIA_GOI = (select x.GIA_GOI from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x where a.ten_goi = x.goi_cuoc)
          where tien_goi is null and  BUNDLE_XK =0
        ;
-- gói bundle xuất kho
        update SSS_dgia_202502 a
                    set tien_goi = (select distinct x.GIA_GOI_CO_VAT from manpn.BSCC_INSERT_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
                        ,DTHU_DONGIA_GOI = (select distinct x.GIA_GOI_CO_VAT from manpn.BSCC_INSERT_DM_KIT_BUNDLE x where a.ten_goi = x.ten_goi)
          where tien_goi is null and BUNDLE_XK = 1 --x.GIA_GOI_CO_VAT*(1-CHIET_KHAU)
                    ;
select * from  SSS_DGIA_202502 where MANV_DKTT like '%LK%'  AND TENKIEU_LD ='ptm';

        update SSS_dgia_202502
        set heso_hhbg = 0.25
            ,heso_kk = 0
            ,TIEN_THULAO_DNHM = 20000
            ,TIEN_DNHM = 25000
            ,DTHU_DONGIA_DNHM = 20000
       where tenkieu_ld = 'ptm'
        ;
        update SSS_dgia_202502
        set DTHU_DONGIA_GOI = tien_goi
            ,heso_kk = 0
            ,heso_hhbg = 0.25
       where tenkieu_ld = 'ptm-goi'
       ;

---=====UPDATE CHU KỲ GÓI

       UPDATE SSS_dgia_202502 a
        SET ck_goi = (
            SELECT x.CHU_KY
            FROM manpn.BSCC_INSERT_DM_KIT_BUNDLE x
            WHERE x.ten_goi = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.CK_goi IS NULL
        ;
        update SSS_dgia_202502 a
        set ck_goi = (select x.chu_ky_thang from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x  where  x.goi_cuoc= a.ten_goi )
        where CK_goi is null
        ;
        update SSS_dgia_202502
        set ck_goi = 0
        where ten_goi in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang = 'N')
        ;


---====UPDATE CK_GOI_DM:
        UPDATE SSS_dgia_202502 a
        SET ck_goi_dm = (
            SELECT x.CHU_KY
            FROM manpn.BSCC_INSERT_DM_KIT_BUNDLE x
            WHERE x.ten_goi = a.ten_goi
            ORDER BY x.ngay_CN DESC
            FETCH FIRST 1 ROWS ONLY
        )
        WHERE a.ck_goi_dm IS NULL
        ;
        update SSS_dgia_202502 a
        set ck_goi_dm = (SELECT CASE
                                WHEN x.chu_ky_thang = 'N' THEN 0
                                ELSE TO_NUMBER(x.chu_ky_thang)
                            END
                        FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY x
                        WHERE x.goi_cuoc = a.ten_goi )
        where ck_goi_dm is null
        ;


---====UPDATE chu kỳ gói tính TLDG:
        UPDATE SSS_dgia_202502
        SET CK_GOI_TLDG = GREATEST(nvl(CK_GOI_DM,0), NVL(CK_GOI, 0))
        WHERE CK_GOI_TLDG IS NULL;
    --==UPDTAE tháng kết thúc để tính lương thu hồi?
        update SSS_dgia_202502
        set thang_kt = to_number(to_char(add_months(ngay_kh, CK_GOI_TLDG),'yyyymm'))
        where thang_kt is null
        ;

  --==UPDATE tính tiền thù lao gói:
      UPDATE SSS_dgia_202502
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
   UPDATE SSS_dgia_202502 a
SET TIEN_THULAO_GOI = CASE
    -- Trường hợp 1: Cả hai dòng có cùng ma_pb = 'VNP0703000'
    WHEN EXISTS (
        SELECT 1
        FROM SSS_dgia_202502 b
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
             FROM SSS_dgia_202502 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN a.DTHU_DONGIA_GOI * a.HESO_HHBG

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm' and a.CK_GOI_TLDG > 0
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1
             FROM SSS_dgia_202502 d
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
        FROM SSS_dgia_202502 b
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
             FROM SSS_dgia_202502 c
             WHERE a.ma_tb = c.ma_tb
               AND c.tenkieu_ld = 'ptm'
               AND c.ma_pb <> 'VNP0703000'
         ) THEN TIEN_THULAO_DNHM

    -- Trường hợp 3: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm-goi có ma_pb khác
    WHEN a.tenkieu_ld = 'ptm'
         AND a.ma_pb = 'VNP0703000'
         AND EXISTS (
             SELECT 1
             FROM SSS_dgia_202502 d
             WHERE a.ma_tb = d.ma_tb
               AND d.tenkieu_ld = 'ptm-goi'
               AND d.ma_pb <> 'VNP0703000'
         ) THEN 0
    --Trường hợp 4: Không tính cho dòng có ma_pb = 'VNP0703000' nếu ptm đứng 1 mình
     WHEN a.tenkieu_ld = 'ptm'
            AND a.ma_pb = 'VNP0703000'
            AND (
                SELECT COUNT(*)
                FROM SSS_dgia_202502 d
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
-- update SSS_dgia_202502
-- set LYDO_KHONGTINH ='CK gói = 0'
-- where manv_ptm is not null and CK_GOI_TLDG = 0 and TENKIEU_LD ='ptm-goi' and LYDO_KHONGTINH is null
-- ;

--#vde: các trường hợp when case loại trừ ko tính
   UPDATE SSS_dgia_202502
SET TIEN_THULAO_GOI = 0,
    TIEN_THULAO_DNHM = 0,
    heso_hhbg =0 ,
    LYDO_KHONGTINH = CASE
                        WHEN ma_pb = 'VNP0700800' and TENKIEU_LD='ptm-goi' THEN 'PKG: PTTT ko tinh'
                        WHEN ma_pb = 'VNP0700800' and TENKIEU_LD='ptm' THEN 'HMM: PTTT ko tinh'
--                         WHEN BUNDLE_XK = 1 AND tenkieu_ld = 'ptm-goi' THEN 'PKG:Bundle_xk không tính đơn giá gói'
                        WHEN (PHAN_LOAI_KENH = 'CTVXHH' OR manv_dktt LIKE 'P%') AND TENKIEU_LD='ptm-goi'  THEN 'PKG: CTVXHH ko tính đơn giá'
                        WHEN (PHAN_LOAI_KENH = 'CTVXHH' OR manv_dktt LIKE 'P%') AND TENKIEU_LD='ptm' THEN 'HHM: CTVXHH ko tính đơn giá'
                        WHEN ten_goi IN (SELECT ten_goi FROM dm_goi_loai_tru) THEN ten_goi || ' ko tinh'
                        WHEN DAI_LY = 1 AND TENKIEU_LD = 'ptm' THEN 'HMM: PTM bởi đại lý không tính đơn giá BCKH'
                        WHEN DAI_LY = 1 AND TENKIEU_LD = 'ptm-goi' THEN 'PKG: PTM gói bởi đại lý không tính đơn giá gói'
                        ELSE LYDO_KHONGTINH -- Giữ nguyên lý do nếu không rơi vào trường hợp nào
                     END
WHERE
--     (BUNDLE_XK = 1 AND tenkieu_ld = 'ptm-goi') OR
    ma_pb = 'VNP0700800'
   OR PHAN_LOAI_KENH = 'CTVXHH'
   OR manv_dktt LIKE 'P%'
   OR ten_goi IN (SELECT ten_goi FROM dm_goi_loai_tru)
   OR DAI_LY = 1;

update SSS_dgia_202502
set HESO_HHBG = 0
where TENKIEU_LD ='ptm'
;


        update SSS_dgia_202502
        set TIEN_THULAO_GOI = 0
        where TIEN_THULAO_GOI is null
        ;
        update SSS_dgia_202502
        set TIEN_THULAO_DNHM = 0
        where TIEN_THULAO_DNHM is null
        ;
        update SSS_dgia_202502
        set THANG_BD = 202502
            ,DTHU_DONGIA_DNHM = 20000
            ,thang_kt = 202502
         where TENKIEU_LD ='ptm'

        ;



----===========================KÉO ĐẾN DAY LA XONG BANG FULL 1 PTM NHIEU PTM-GOI--------------------------================






select * from one_line_202502 where ma_tb  in ('84814005472','84816240746','84814387588');
select * from SSS_dgia_202502_2 where ma_tb ='84916374837';
select * from SSS_dgia_202502 where ma_tb ='84813461192';









----=== đơn giá THỦ ĐỨC
select * from one_line_202502 where ma_tb ='84886703462';
select * from SSS_dgia_202502 where ma_tb ='84886703462';
select * from khieunai_td_dgia;
update SSS_dgia_202502 a
set MANV_PTM = (select x.NGUOI_THAYTHE x from khieunai_td_dgia x
                                            where x.thang = 202502
                                               and x.MA_TB = a.ma_tb
                                               and x.ma_tiepthi = username_kh)
where  a.ma_tb in (select ma_tb from khieunai_td_dgia x where x.thang = 202502)
    and TENKIEU_LD ='ptm'
;
update SSS_dgia_202502 a
        set (manv_ptm,tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_PTM)
    where ma_tb in  (select ma_tb from khieunai_td_dgia where thang = 202502) and TENKIEU_LD ='ptm'
      ;


update SSS_dgia_202502_2 a
set MANV_PTM = (select x.NGUOI_THAYTHE x from khieunai_td_dgia x
                                            where x.thang = 202502
                                               and x.MA_TB = a.ma_tb
                                               and x.ma_tiepthi = username_kh)
where  a.ma_tb in (select ma_tb from khieunai_td_dgia x where x.thang = 202502)
    and TENKIEU_LD ='ptm';
      update SSS_dgia_202502_2 a
        set (manv_ptm,tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_PTM)
    where ma_tb in  (select ma_tb from khieunai_td_dgia where thang = 202502) and TENKIEU_LD ='ptm'
      ;

--1dong
update one_line_202502 a
set MANV_PTM = (select x.NGUOI_THAYTHE x from khieunai_td_dgia x
                                            where x.thang = 202502
                                               and x.MA_TB = a.ma_tb)
where  a.ma_tb in (select ma_tb from khieunai_td_dgia x where x.thang = 202502);
 update one_line_202502 a
        set (manv_ptm,tennv_ptm,MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_PTM)
    where ma_tb in  (select ma_tb from khieunai_td_dgia where thang = 202502)
      ;
select *
from one_line_202502 where ma_tb in (select ma_tb from khieunai_td_dgia where thang = 202502);
;      drop index idx_tmp;
---những manv_goi ở bên 1 dòng nếu null --> kiểm tra cột tiền gói coi = 0 ko ? gán 0
-----------------====== NHÁP:


;








-----------------------================= TAO BANG 2 DONG, MOI STB 1 GOI VKCK HPHUC ============================
select * from SSS_dgia_202502_2 ;
drop table SSS_dgia_202502_2;
create table SSS_dgia_202502_2 as -- tạo bảng 2 dòng ( ptm và chỉ 1 gói)

    WITH RankedRows AS (
            -- Lấy dòng có tenkieu_ld là 'ptm-goi' với TIEN_GOI lớn nhất cho mỗi ma_tb
            SELECT a.*,
                   ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.kenh_trong DESC,a.MANV_PTM asc, a.TIEN_GOI DESC, a.ngay_kh DESC) AS rnk,
                   COUNT(*) OVER (PARTITION BY a.ma_tb) AS cnt
            FROM SSS_dgia_202502 a
            WHERE a.tenkieu_ld = 'ptm-goi'
        )
SELECT *
FROM (
    -- Lấy những dòng có tenkieu_ld là 'ptm'
    SELECT a.*,999 flag_a,111 flag_b
    FROM SSS_dgia_202502 a
    WHERE a.tenkieu_ld = 'ptm'

    UNION ALL

    -- Lấy dòng có tenkieu_ld là 'ptm-goi' với điều kiện manv_ptm
    SELECT a.*
    FROM RankedRows a
    WHERE (cnt = 1 AND MANV_PTM IS not NULL)
       OR (rnk = 1 AND cnt > 1 AND manv_ptm IS NOT NULL)
)
;
delete from SSS_dgia_202502_2 where ten_goi = 'Sim D_VinaXtra' ;


-- drop table one_line_202502;
drop table one_line_202502;
CREATE TABLE one_line_202502 AS
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
        MAX(CASE WHEN tenkieu_ld = 'ptm-goi' THEN manv_ptm END)              AS manvgoi_goc,
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
 FROM SSS_DGIA_202502_2
 GROUP BY ma_tb, thang_ptm, dthu_KPI);
--tien Luong tinh aHoc tinh roi!
update one_line_202502
set tien_thulao_dnhm =0
where nguon like 'luongtinh%'
;
GRANT UPDATE ON vietanhvh.one_line_202502 TO MANPN;



----update xử mục 2 a mẫn
update one_line_202502
set manv_goi = manv_ptm
    ,MATO_GOI = MATO_PTM
    , MAPB_GOI = mapb_ptm
where manv_goi is null and ten_goi is null
;

--tìm nhan vien đat chỉ tieu KK:
            select manv_goi,ten_goi from one_line_202502 where manv_goi in;
              (SELECT *
            FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
            WHERE thang = 202502
--               and dinhmuc_2 IN (32000000, 30000000)
              AND ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_15.1')
              AND KQTH >= dinhmuc_2
              AND KHDK >= dinhmuc_2 and ma_pb not in ('VNP0701600','VNP0701200')	);



update SSS_DGIA_202502
set TIEN_THULAO_KK = 0;
update SSS_DGIA_202502
set HESO_KK = 0;


select distinct manv_goi,mapb_goi from one_line_202502 where heso_kk = 0.05 --check coi đủ SL NV ở query select trên
group by manv_goi,mapb_goi;
select * FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
                    WHERE thang = 202502;
update one_line_202502
set heso_kk = 0.05 where ma_tb in (select ma_tb
                                   from one_line_202502
                                   where ten_goi in ('TR60D', 'TR80D')
                                     and mapb_ptm = 'VNP0701600');
-----ALL update tien KK
update one_line_202502
set HESO_KK = 0
where ma_tb not in (select ma_tb from share_pbhtb where thang = 202502);
-- 5%
update one_line_202502
set heso_kk = 0.05
where manvgoi_goc in (select ma_nv FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
                    WHERE thang = 202502
--                         and dinhmuc_2 IN (32000000, 30000000)
                      AND ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_15.1')
                      AND KQTH >= dinhmuc_2
                      AND KHDK >= dinhmuc_2)
and CK_GOI_TLDG>0 and ma_tb not in ((select ma_tb
                                     from share_pbhtb
                                     where thang = 202502))
;
update one_line_202502
set heso_kk = 0.05
where manvgoi_goc in ('CTV079494',
'CTV087578',
'CTV087579',
'VNP016713'
)
;
select * from one_line_202502 where ma_tb ='84812040549';in (select ma_tb from share_pbhtb where thang = 202502);
-- DONG_KIT Các thuê bao này trước đó đã được chi trả các chính sách BCKH và hoa hồng bán gói (HHBG) ở kênh bán đầu tiên trước khi đóng kit.
--  Tránh tình trạng chi trả lần thứ hai cho cùng một thuê bao khi kích hoạt lại.
  update one_line_202502
                        set TIEN_THULAO_DNHM =0
                            ,TIEN_THULAO_GOI =0
                            ,heso_kk =0,HESO_HHBG =0
                            ,LYDO_KHONGTINH = 'HMM: PKG:thuê bao này trước đó đã được chi trả các chính sách BCKH và hoa hồng bán gói (HHBG) ở kênh bán đầu tiên trước khi đóng kit'
                        where ma_tb in (
         select accs_mthd_key from P01_202502 where loai_sim in ('KIT_DONG_KIT_KHS','KIT_DONG_KIT_TDL')
         );
    update one_line_202502
    set TIEN_THULAO_GOI = nvl(DTHU_DONGIA_GOI,0)*heso_hhbg+(nvl(DTHU_DONGIA_GOI,0)*HESO_KK)
    ;
;

---end update tien KK

--giam tru nghiem vu 3200
select count(*) from manpn.manpn_goi_tonghop_202502 a
where TLDG_HMM is not null;
select count(*)
from one_line_202502 where GIAMTRU_NGHIEPVU = 3200;
select *
from one_line_202502 where ma_tb in (SELECT ma_tb
    FROM manpn.manpn_goi_tonghop_202502
    WHERE loai_tb = 'ptm' and TLDG_HMM=3200);
--
UPDATE one_line_202502 b
SET b.GIAMTRU_NGHIEPVU = 0
    ,b.TIEN_THULAO_DNHM = case when  TIEN_THULAO_DNHM >0 then 20000 end;
;
MERGE INTO one_line_202502 b
USING (
    SELECT ma_tb, TLDG_HMM
    FROM manpn.manpn_goi_tonghop_202502
    WHERE loai_tb = 'ptm' and TLDG_HMM > 0
) a
ON (b.ma_tb = a.ma_tb )
WHEN MATCHED THEN
    UPDATE SET b.GIAMTRU_NGHIEPVU = nvl(a.TLDG_HMM,0);
;

update one_line_202502
set TIEN_THULAO_DNHM = 20000-nvl(GIAMTRU_NGHIEPVU,0)
where GIAMTRU_NGHIEPVU>0 and TIEN_THULAO_DNHM >0
;
select sum(tien_thulao_dnhm),sum(GIAMTRU_NGHIEPVU)
from one_line_202502 ;
select *
from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm = 202502 and ma_tb ='84848699353';

--INSERT bang tong hop-- view
insert into ttkd_bsc.va_ct_bsc_ptm_vnptt(THANG_PTM, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM, MANV_GOC, TENNV_PTM, MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM, TIEN_DNHM, DTHU_DONGIA_DNHM, GIAMTRU_NGHIEPVU, TIEN_THULAO_DNHM, MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, HESO_HHBG, HESO_KK, TIEN_THULAO_GOI, LYDO_KHONGTINH_DONGIA,  VANBAN )
            select THANG_PTM, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM, MANV_GOC, TENNV_PTM, MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM, TIEN_DNHM, DTHU_DONGIA_DNHM, GIAMTRU_NGHIEPVU, TIEN_THULAO_DNHM, MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, HESO_HHBG, HESO_KK, TIEN_THULAO_GOI,  LYDO_KHONGTINH,  'VB344' from one_line_202502
            ;



MERGE INTO ttkd_bsc.va_ct_bsc_ptm_vnptt a
USING one_line_202502 b
ON (a.ma_tb = b.ma_tb AND a.thang_ptm = 202502)
WHEN MATCHED THEN
UPDATE SET
    a.TEN_GOI=b.TEN_GOI,
    a.CK_GOI_TLDG=b.CK_GOI_TLDG,
    a.MANV_PTM = b.MANV_PTM,
    a.MANV_GOC = b.MANV_GOC,
    a.TENNV_PTM = b.TENNV_PTM,
    a.MATO_PTM = b.MATO_PTM,
    a.TENTO_PTM = b.TENTO_PTM,
    a.MAPB_PTM = b.MAPB_PTM,
    a.TENPB_PTM = b.TENPB_PTM,
    a.TIEN_DNHM = b.TIEN_DNHM,
    a.DTHU_DONGIA_DNHM = b.DTHU_DONGIA_DNHM,
    a.GIAMTRU_NGHIEPVU = b.GIAMTRU_NGHIEPVU,
    a.TIEN_THULAO_DNHM = b.TIEN_THULAO_DNHM,
    a.MANV_GOI = b.MANV_GOI,
    a.MANVGOI_goc = b.MANVGOI_goc,
    a.MATO_GOI = b.MATO_GOI,
    a.MAPB_GOI = b.MAPB_GOI,
    a.TIEN_GOI = b.TIEN_GOI,
    a.DTHU_DONGIA_GOI = b.DTHU_DONGIA_GOI,
    a.HESO_HHBG = b.HESO_HHBG,
    a.HESO_KK = b.HESO_KK,
    a.TIEN_THULAO_GOI = b.TIEN_THULAO_GOI,
    a.LYDO_KHONGTINH_DONGIA = b.LYDO_KHONGTINH,
    a.GHI_CHU = b.GHI_CHU;

;
select * from ttkd_bsc.tonghop_ct_dongia_ptm where thang = 202502;

---
 select * from (
           select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG,
             MANV_GOI ma_nv,b.ten_nv, MATO_GOI ma_to,b.ten_to, MAPB_GOI ma_pb,b.ten_pb,'mua_goi' tenkieu_ld, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
             DTHU_KPI, LYDO_KHONGTINH
         from vietanhvh.one_line_202502 a
         join ttkd_bsc.nhanvien b on b.thang = a.thang_ptm and a.manv_goi = b.ma_nv
            union all
         select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM ma_nv, TENNV_PTM,
            MATO_PTM ma_to, TENTO_PTM, MAPB_PTM ma_pb, TENPB_PTM,'ptm' tenkieu_ld, TIEN_DNHM, DTHU_DONGIA_DNHM, TIEN_THULAO_DNHM
--         MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
         , DTHU_DNHM_KPI, LYDO_KHONGTINH
         from vietanhvh.one_line_202502
union all
 select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG,
             MANV_GOI ma_nv,b.ten_nv, MATO_GOI ma_to,b.ten_to, MAPB_GOI ma_pb,b.ten_pb,'mua_goi' tenkieu_ld, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
             DTHU_KPI, LYDO_KHONGTINH
         from vietanhvh.bosung_T10 a
           join ttkd_bsc.nhanvien b on b.thang = a.thang_ptm and a.manv_goi = b.ma_nv



         ) where ma_tb ='84917150409';

select *
from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm = 202502 and TIEN_THULAO_DNHM =16800;
--check bangluong_dongia 344

with bang1 as (select manv_ptm,sum(tien_thulao_dnhm) tien ,'bckh' nguon
            from ttkd_bsc.va_ct_bsc_ptm_vnptt
            where thang_ptm = 202502
              group by manv_ptm
            union all
            select manv_goi,sum(tien_thulao_goi) ,'goi'
            from ttkd_bsc.va_ct_bsc_ptm_vnptt
            where thang_ptm = 202502
              group by manv_goi)
, a2  as (select a.manv_ptm,round(sum(tien)) vietanh,sum(tien_b),round(sum(tien)) - sum(tien_b) cl
from ( select manv_ptm,sum(tien) tien from bang1 group by manv_ptm
            ) a
right join ( select ma_nv,sum(nvl(LUONG_DONGIA_GOI_VNPTT,0)+nvl(LUONG_DONGIA_DNHM_VNPTT,0)) tien_b
             from ttkd_bsc.tonghop_ct_dongia_ptm where thang = 202502 group by ma_nv) b
on a.manv_ptm=b.ma_nv
        group by a.manv_ptm
)
    select * from a2; where cl <> 0
        order by CL;
--2037929266.00

select * from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm =202502 and ma_tb = 84918906090	;
select *
from TTKD_BSC.nhanvien where ma_nv ='CTV087579';
