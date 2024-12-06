--import sheet luyke c?a ch? Ph??ng vào, có ?ánh d?u bundle = 'x'. Ki?m tra xem có n?m trong file phát tri?n m?i hay không r?i bê nguyên si vào làm tháng 4
insert into manpn.BUNDLE_XUATKHO_PDH(THANG, MA_TB, SERI, LOAI_SIM, BUNDLE, PHONG, NGAY_CN, THANG_KH, ACCOUNT_DK)
with cte as(
select to_date(thang, 'dd.mm.yyyy') as thang2, a.* from BUNDLE_XUATKHO_PDH_temp a where lower(BUNDLE) = 'x'
)
select a.THANG, a.TB, a.SERI, a.GOI_CUOC, a.BUNDLE, a.PHONG, SYSDATE, 202408, ma_tiepthi from cte a left join KPI_tonghop202408_cl b on a.TB = b.ma_tb and loai_tb = 'ptm'
where b.ma_tb is not null;

select * from manpn.BUNDLE_XUATKHO_PDH where thang_kh = 202408;

delete from BUNDLE_XUATKHO_PDH_temp;

rollback;
select * from BUNDLE_XUATKHO_PDH_temp;



---- Import các thuê bao phát tri?n m?i. LOAI_TB = 'ptm'. MA_TIEPTHI -> user_name, MANV_PTM-> HRM
--import ptm n?a tháng cu?i trên h? th?ng SMRS: https://smrs.vnpt.vn/Dashboard/Table/Simple?report_code=analyze%2Ftb_ptm_tinh_dangky
update manpn.bscc_import_ptm_smrs@ttkdddb
set thang = MANPN_GET_YEARMONTH_FROM_M(1)
where thang is null;
update bscc_import_ptm_bris
set thang = MANPN_GET_YEARMONTH_FROM_M(1)
where thang is null;

create table  KPI_tonghop202408_10 as
select * from KPI_tonghop202406_9 where 1=0;
delete from KPI_tonghop202408_10;

insert into KPI_tonghop202408_10(MA_TB, KENH_BAN, MA_TIEPTHI, THANG_KH, MANV_DKTT, LOAI_TB, LOAI_KENH, ngay_kh)
with cte as(
    SELECT TO_CHAR(SO_ELOAD) AS ELOAD, A.*
    FROM(
        SELECT case when INSTR(a.ma_nhan_vien, '_') > 0 then UPPER(SUBSTR(a.ma_nhan_vien, 1, INSTR(a.ma_nhan_vien, '_')-1))
               else a.ma_nhan_vien end ma_nv
            , A.*, ROW_NUMBER() OVER(PARTITION BY SO_ELOAD ORDER BY LOAI_DIEM_BAN DESC) RA
        FROM manpn.kpi_kenhban_ngoai_noibo@ttkddbbk2 A
        WHERE KENH_NGOAI = 'kenh_ngoai'
            AND THANG = MANPN_GET_YEARMONTH_FROM_M(1)
        ) A
    WHERE RA = 1
    ),
    NVVV AS(
    SELECT UPPER(SUBSTR(MAIL_VNPT, 1, INSTR(MAIL_VNPT, '@')-1)) AS MAIL, C.* FROM (select * from ttkd_bsc.nhanvien where thang = 202408) C
    WHERE THANG = MANPN_GET_YEARMONTH_FROM_M(1)
)
select A.SO_TB, 'bris', c.ma_nv , A.THANG, A.MA_USER_TIEPTHI, 'ptm', A.LOAI_KENH, NGAY_KICH_HOAT
from bscc_import_ptm_bris_pl01 a left join cte b on a.MA_USER_TIEPTHI = b.MA_DIEM_BAN
    left join NVVV C ON b.MA_Nv = C.MAIL AND C.THANG = MANPN_GET_YEARMONTH_FROM_M(1)
where a.thang = 202408
    and b.ma_diem_ban is not null
    and DIEM_CHAM_TIEPTHI in ('DIGISHOPAPP', 'App DigiShop TNTTTB KIT')
    and CONGCU_DKTT in ('SIMDONLE', 'App DigiShop TNTTTB KIT')
;

insert into KPI_tonghop202408_10 (KENH_BAN,MA_TB, MA_TIEPTHI,LOAI_TB, THANG_KH, ngay_kh)
select 'smrs', '84' || SUBSCRIBER_ID, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
from bscc_import_ptm_smrs
where thang = MANPN_GET_YEARMONTH_FROM_M(1)
    and  '84' || SUBSCRIBER_ID not in (select ma_tb from KPI_tonghop202408_10 where loai_tb = 'ptm');

--Import ptm trên smrs không ??, c?n b? sung thêm t? Bris: http://bris.vnpt.vn/Report/Kri/Report/Analyze?report_type=hqkd_ct_ddtt
insert into KPI_tonghop202408_10(MA_TB, KENH_BAN, MA_TIEPTHI, THANG_KH, MANV_DKTT, LOAI_TB, LOAI_KENH, ngay_kh)
SELECT A.SO_TB, 'bris', A.USER_DKTT, A.THANG, A.MA_HRM_USER_DKTT, 'ptm', A.LOAI_KENH, NGAY_KICH_HOAT
FROM bscc_import_ptm_bris_pl01 A
WHERE A.THANG = MANPN_GET_YEARMONTH_FROM_M(1)
    and A.SO_TB not in (select ma_tb from KPI_tonghop202408_10 where loai_tb = 'ptm');

--Import ptm trên b?ng c?a anh Tuy?n
INSERT INTO KPI_tonghop202408_10 (KENH_BAN, MA_TB,
MA_TIEPTHI, MANV_PTM, LOAI_KENH, LOAI_TB, LUONG_TINH, ngay_kh)
SELECT 'luongtinh', SOMAY, NGUOI_GT, MANV_PTM, 'bris', 'ptm', 1 , NGAY_LD
FROM TTKD_BSC.DT_PTM_VNP_202408
WHERE GOI_LUONGTINH IS NOT NULL;
-------- Import thuê bao phát tri?n m?i mua gói: LOAI_TB = 'ptm_goi'.
UPDATE manpn.BSCC_DIGI
SET THANG = 202411
WHERE THANG IS NULL;
UPDATE manpn.BSCC_DIGI_DONLE
SET THANG = 202411
WHERE THANG IS NULL;
UPDATE manpn.BSCC_IMPORT_BUNDLE_SMRS
SET THANG = 202411
WHERE THANG IS NULL;
UPDATE manpn.bscc_import_ptm_smrs
SET THANG = 202411
WHERE THANG IS NULL;
UPDATE manpn.BSCC_IMPORT_GOI_BRIS
SET THANG = MANPN_GET_YEARMONTH_FROM_M(1)
WHERE THANG IS NULL;

delete from BSCC_IMPORT_GOI_BRIS where thang = 202408;
select * from bscc_import_ptm_bris_pl01 where thang = 202408 and so_tb  = 84914663464;
select * from manpn.manpn_GOI_TONGHOP_202408 where ma_tb = '84914663464';
84914733620
84914734220
84914734180

delete from KPI_tonghop202408_10
where ma_tb  in( '84812538842','84812627654') and goi_cuoc = 'U1500_';  --

--ki?m tra l?i xem bundle xu?t kho ch? Ph??ng ???c nh?p nh? th? nào. Liên h? ch? Ph??ng ?? có file
INSERT INTO KPI_tonghop202408_10  (LOAI_TB, KENH_BAN, MA_TB, MA_TIEPTHI, GOI_CUOC, GIA_GOI, THANG_KH, MANV_PTM, MAPB_PTM, KENH_NOIBO)
SELECT 'ptm_goi','bundle_xuatkho', B.MA_TB, ACCOUNT_DK, LOAI_SIM, GIA_GOI, THANG_KH, MA_NV, MA_PB, KENH_NOIBO
FROM manpn.BUNDLE_XUATKHO_PDH B
WHERE B.THANG_KH = 202408
AND B.MA_TB IN (SELECT A.MA_TB FROM KPI_tonghop202408_10  A WHERE LOAI_TB='ptm')
;

merge into manpn.KPI_tonghop202408_10 t1
using (
    SELECT a.ma_tb, b.NGAY_KH
    FROM manpn.KPI_tonghop202408_10 A LEFT JOIN (select * from KPI_tonghop202408_10 where loai_tb = 'ptm') B ON A.MA_TB = B.MA_TB
    WHERE A.kenh_ban  = 'bundle_xuatkho'
    ) t2
on (t1.ma_tb = t2.ma_tb)
when matched then update set T1.NGAY_KH = T2.NGAY_KH
when not matched /* never happens */ then insert (T1.TKC_THANG_N) values (null);

--IMPORT gói c?a kênh Digishop tr??c: https://digishop.vnpt.vn/digitalShop/stats/statsMobileDetail
INSERT INTO KPI_tonghop202408_10 (THANG_KH,KENH_BAN, KENH_NOIBO, LOAI_TB,  MA_TB, GIA_GOI, GOI_CUOC, MA_TIEPTHI, P2_CHUKY, ngay_kh)
SELECT 202408, 'digishop_sim', 1, 'ptm_goi', STB, GIA_GOI, TEN_GOI, MA_TIEPTHI
    , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO
FROM MANPN.BSCC_DIGI
WHERE THANG = 202408 and LOAI_TB = 'Tr? tr??c'
AND STB IN (SELECT MA_TB FROM KPI_tonghop202408_10 WHERE LOAI_TB = 'ptm')
AND STB  NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10 WHERE LOAI_TB = 'ptm_goi');

-- import gói kênh digishop ??n l?: https://digishop.vnpt.vn/digitalShop/stats/statsSimDetail
INSERT INTO KPI_tonghop202408_10 (THANG_KH,KENH_BAN, KENH_NOIBO, LOAI_TB,  MA_TB, GIA_GOI, GOI_CUOC, MA_TIEPTHI, P2_CHUKY, ngay_kh)
SELECT 202408, 'digishop_pac', 1, 'ptm_goi', STB, GIA_GOI, TEN_GOI, MA_GIOI_THIEU_DH
    , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO_DON
FROM MANPN.BSCC_DIGI_DONLE
WHERE THANG = 202408
AND STB  IN (SELECT MA_TB FROM KPI_tonghop202408_10 WHERE LOAI_TB = 'ptm')
AND STB  NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10 WHERE LOAI_TB = 'ptm_goi');

--import bundle chi ti?t: https://smrs.vnpt.vn/Dashboard/Table/Simple?report_code=analyze/dt_bundle_chitiet
INSERT INTO KPI_tonghop202408_10  (LOAI_TB, KENH_BAN, MA_TB, MA_TIEPTHI, GOI_CUOC, GIA_GOI, THANG_KH, ngay_kh)
SELECT 'ptm_goi',CASE WHEN MUC_CK = 0 THEN LOWER(KENH_XUAT_BAN) ELSE 'bundle' END,
                B.MSISDN, ACCOUNT_DK, SERVICE_CODE, GIA_GOI, THANG, to_date(substr(NGAY_KH,1,instr(NGAY_KH, '2024')+3), 'mm/dd/yyyy')
FROM MANPN.BSCC_IMPORT_BUNDLE_SMRS_CT B
WHERE B.THANG = 202408
    AND B.MSISDN IN (SELECT A.MA_TB FROM KPI_tonghop202408_10  A WHERE LOAI_TB='ptm')
    AND B.MSISDN NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10 A WHERE LOAI_TB='ptm_goi')
;

SELECT * FROM BSCC_IMPORT_BUNDLE_SMRS_CT;
SELECT * FROM KPI_tonghop202408_10 where kenh_ban = 'bundle';

--bundle th??ng import vào: https://smrs.vnpt.vn/Dashboard/Table/Simple?report_code=analyze%2Ftb_ptm_tinh_dangky_bundle
INSERT INTO KPI_tonghop202408_10 (LOAI_TB, KENH_BAN, MA_TB, MA_TIEPTHI, GOI_CUOC, GIA_GOI, THANG_KH, ngay_kh)
SELECT 'ptm_goi',CASE WHEN KENH = 'Shop' then 'shop' ELSE 'bundle' END, '84'||B.SUBSCRIBER_ID, ACCOUNT_DK, TEN_GOI, GIA_GOI, THANG, NGAY_KH
FROM manpn.BSCC_IMPORT_BUNDLE_SMRS B
WHERE THANG = 202408
AND '84'||B.SUBSCRIBER_ID IN (SELECT A.MA_TB FROM KPI_tonghop202408_10 A WHERE LOAI_TB='ptm')
AND '84'||B.SUBSCRIBER_ID NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10 A WHERE LOAI_TB='ptm_goi');   --1554
--and goi cuoc not in 'Sim D_VinaXtra'

select * from KPI_tonghop202408_10;
-- http://bris.vnpt.vn/Report/Kri/Report/Analyze?report_type=hqkd_kenh_bangoi
INSERT INTO KPI_tonghop202408_10  (ID_KENH, KENH_BAN, MA_TB, GOI_CUOC, P2_CHUKY, GIA_GOI,
MA_TIEPTHI, MANV_PTM, LOAI_KENH, LOAI_TB, THANG_KH,GIA_GOI_PHAN_KY_THANG_N, ngay_kh)
SELECT STT, LOWER(CONG_CU_BAN_GOI), SO_TB, MA_GOI, CHU_KY_GOI, DOANH_THU_BAN_GOI, USER_KENH_BAN, HRM_NV_BAN_GOI_NV_QLKENH_BAN,
LOAI_KENH_BAN, 'ptm_goi', 202408,round(DOANH_THU_BAN_GOI_PHAN_KY/1.1,0), NGAY_DK_GH_GOI
FROM manpn.bscc_import_goi_bris
WHERE HINH_THUC_TB = 'TT'
AND THANG = 202408
AND SO_TB IN (SELECT MA_TB FROM KPI_tonghop202408_10  WHERE LOAI_TB='ptm')
AND SO_TB NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10  WHERE LOAI_TB='ptm_goi'
                                        AND GIA_GOI > 0)
AND SO_TB NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10  WHERE LOAI_TB='ptm_goi' and kenh_ban = 'bundle_xuatkho');
---AND SO_TB = 84911784071 ---AND LOWER(CONG_CU_BAN_GOI) LIKE 'smcs'
; --14962

-- Import gói c?a sim l??ng tính. Trong b?ng c?a anh Tuy?n.
INSERT INTO KPI_tonghop202408_10 (KENH_BAN, MA_TB, GOI_CUOC, CHU_KY_GOI_THANGN, GIA_GOI,
MA_TIEPTHI, MANV_PTM, LOAI_KENH, LOAI_TB, LUONG_TINH, ngay_kh)
SELECT LOWER(CONG_CU_BAN_GOI), SO_TB, MA_GOI, CHU_KY_GOI, DOANH_THU_BAN_GOI,
USER_KENH_BAN, HRM_NV_BAN_GOI_NV_QLKENH_BAN, LOAI_KENH_BAN, 'ptm_goi', 1 , NGAY_DK_GH_GOI
FROM manpn.bscc_import_goi_bris
WHERE HINH_THUC_TB = 'TS' and thang = 202408
AND SO_TB IN (SELECT SOMAY FROM TTKD_BSC.DT_PTM_VNP_202408 WHERE GOI_LUONGTINH IS NOT NULL) --??i tên b?ng
;

create table MANPN.BSCC_INSERT_DM_KIT_BUNDLE AS
SELECT * FROM nganbh.DM_KIT_BUNDLE;

create table MANPN.BSCC_INSERT_DM_GOICUOC_PHANKY AS
SELECT * FROM nganbh.DM_GOICUOC_PHANKY;

update KPI_tonghop202408_10 a
set (CHU_KY_GOI_THANGN,GIA_GOI_PHAN_KY_THANG_N, GIA_GOI) =
                (select distinct CHU_KY, GIA_PHANKY_SAUCK_TRUOCVAT, GIAGOI_SAUCK_COVAT
                                from MANPN.BSCC_INSERT_DM_KIT_BUNDLE where TEN_GOI = goi_cuoc)
WHERE loai_tb='ptm_goi' and kenh_ban like 'bundle%';

update KPI_tonghop202408_10 a
set (CHU_KY_GOI_THANGN,GIA_GOI_PHAN_KY_THANG_N) = (select CHU_KY_THANG,GIAGOI_PHANKY_CHUA_VAT
                                        from MANPN.BSCC_INSERT_DM_GOICUOC_PHANKY B   -- t?m th?i xài b?ng t?m có thêm gói m?i M?n
                                        WHERE B.GOI_CUOC=A.GOI_CUOC)
WHERE loai_tb='ptm_goi'  --and GIA_GOI_PHAN_KY_THANG_N is null ---AND CHU_KY_GOI_THANGN IS NULL
and kenh_ban NOT like 'bundle%';

update KPI_tonghop202408_10 a
set (CHU_KY_GOI_THANGN,GIA_GOI_PHAN_KY_THANG_N, GIA_GOI) = (select CHU_KY_THANG,GIAGOI_PHANKY_CHUA_VAT,GIA_GOI
                                        from MANPN.BSCC_INSERT_DM_GOICUOC_PHANKY B   -- t?m th?i xài b?ng t?m có thêm gói m?i M?n
                                        WHERE B.GOI_CUOC=A.GOI_CUOC)
WHERE loai_tb='ptm_goi'  --and GIA_GOI_PHAN_KY_THANG_N is null ---AND CHU_KY_GOI_THANGN IS NULL
and kenh_ban  like 'bundle' and gia_goi is null;

update KPI_tonghop202408_10 a
set CHU_KY_GOI = CASE WHEN CHU_KY_GOI_THANGN = 'N' THEN '0'
                                                WHEN CHU_KY_GOI_THANGN <= P2_CHUKY THEN P2_CHUKY
                                                WHEN NVL(CHU_KY_GOI_THANGN,0) > NVL(P2_CHUKY,0) THEN CHU_KY_GOI_THANGN
                                                END
WHERE loai_tb='ptm_goi'
;

select * from KPI_tonghop202408_10;
create table KPI_tonghop202408_10 as
select rownum as rid, ID, ID_KENH, KENH_BAN, LOAI_KENH, MA_TB, GOI_CUOC, GIA_GOI, MA_TIEPTHI, CHU_KY_GOI_THANGN, P2_CHUKY, CHU_KY_GOI, GIA_GOI_PHAN_KY_THANG_N, TKC_THANG_N, THANG_KH, THOADK_TKC, THOADK_BSC, THOADK_DG, LOAI_TB, LUONG_TINH, KENH_NOIBO, TTVT, CHUOI_TDL, DTHU_HMM, DTHU_GOICUOC, DOANHTHU_KPI_NVPTM, DONGIA_BH, DONGIA_KK, TLDG_HMM, TLDG_MG, BANBUON, PHAN_LOAI_KENH, MANV_DKTT, MAPB_DKTT, MANV_PTM, TENNV_PTM, MA_TO_PTM, TEN_TO_PTM, MAPB_PTM, TENPB_PTM, MA_VTCV_PTM, TEN_VTCV_PTM, THANG_BD, THANG_KT, LUONG_DONGIA_GOI_KPBDB, LUONG_DONGIA_GOI_HCM, LUONG_DONGIA_GOI_QLDB
from KPI_tonghop202408_10;


select KENH_BAN, GOI_CUOC, GIA_GOI from KPI_tonghop202408_10 where GOI_CUOC is not null and CHU_KY_GOI is null
group by KENH_BAN, GOI_CUOC, GIA_GOI;

--gói th??ng
select  GOI_CUOC, GIA_GOI from KPI_tonghop202408_10 where GOI_CUOC is not null and CHU_KY_GOI is null
and kenh_ban not like 'bundle%'
group by  GOI_CUOC, GIA_GOI;
--bundle
select  GOI_CUOC, GIA_GOI from KPI_tonghop202408_10 where GOI_CUOC is not null and CHU_KY_GOI is null
and kenh_ban LIKE 'bundle%'
group by  GOI_CUOC, GIA_GOI;


select * from  MANPN.BSCC_INSERT_DM_GOICUOC_PHANKY;
insert into MANPN.BSCC_INSERT_DM_GOICUOC_PHANKY(GOI_CUOC, CHU_KY_THANG, CHU_KY_NGAY, GIA_GOI, GIAGOI_PHANKY_CHUA_VAT, GIAGOI_PHANKY_CO_VAT, NGAY_CN)
values('SPOTV80', 1, 30, 80000, round(80000/1.1/1), 80000, sysdate);

insert into MANPN.BSCC_INSERT_DM_KIT_BUNDLE(TEN_GOI, GIA_GOI_CO_VAT, CHU_KY, CHIET_KHAU, GIA_PHANKY_SAUCK_TRUOCVAT, NGAY_CN, GIAGOI_SAUCK_TRUOCVAT, GIAGOI_SAUCK_COVAT)
values('Bùm 79', 79000, 1, 0.25, round(79000*(1-0.25)/1/1.1), sysdate, round(79000*(1-0.25)/1.1*1), round(79000*(1-0.25)/1.1));
select * from MANPN.BSCC_INSERT_DM_KIT_BUNDLE ;  YOLO 125V
update MANPN.BSCC_INSERT_DM_KIT_BUNDLE
set CHIET_KHAU = 0.25, GIA_PHANKY_SAUCK_TRUOCVAT = round(GIA_GOI_CO_VAT*(1-0.25)/CHU_KY);
select * from MANPN.BSCC_INSERT_DM_KIT_BUNDLE --where GIAGOI_SAUCK_TRUOCVAT is null;
where ten_goi = 'EZ U1500';   Kit TD49  bundle 12T

create table a_temp23 as
select case when USER_DKTT not in (select USER_LD from ttkd_bsc.userld_202408_goc)
                        and (CONGCU_DKTT = ' Web-App MyVNPT' or CONGCU_DKTT = 'App DigiShop TNTTTB KIT')
            then MA_USER_TIEPTHI else USER_DKTT end USER_DKTT2,  a.*
from bscc_import_ptm_bris_pl01 a where thang = 202408
and (CONGCU_DKTT = ' Web-App MyVNPT' or CONGCU_DKTT = 'App DigiShop TNTTTB KIT');

update KPI_tonghop202408_10_8 a
set MA_TIEPTHI = (select USER_DKTT2  from a_temp23 b where a.ma_tb = b.so_tb)
where ma_tb in (select so_tb from a_temp23) and loai_tb = 'ptm';

select MA_TIEPTHI, USER_DKTT2  from KPI_tonghop202408_10_8 a left join a_temp23 b on a.ma_tb = b.so_tb
where loai_tb = 'ptm' and ma_tb in (select so_tb from a_temp23);
select * from a_temp23;

select * from EMAIL_BSCC_PBHKVTD_202408;

create table EMAIL_BSCC_GIAIQUYET_202408 AS
select MO_KEY, DAY_KEY, GEO_STATE_KEY_DTCP, TEN_TTKD_DTCP, TEN_PBH_DTCP, TEN_TO_DTCP, ACCS_MTHD_KEY, ACTV_TYPE, LOAI_SIM, ACC_NAME, ACTVTN_DT, ACCOUNT_DK, CONGCU_DK, CHANNEL_TYPE_ID_DTCP, LOAIKENH_DTCP, THANHVIEN_DTCP, REGISTER_CHANNEL_TYPE, REGISTER_CHANNEL_MEMBER, HRM_USER_DK, TEN_USER_DK, LOAI_KENH, NGAY_TAO_DH, NGAY_DH_THANH_CONG, DT_HOA_MANG, TOTAL_TKC_GOI_ALL, SERVICE_CODE, P2_CHUKY, HRM_STAFF_ASSIGN, MA_TINH_DK_GOI, TOTAL_COMMISSION, DT_TKC_AND_BUNDLE, MA_KENH_BAN, LOAIKENH_USER_TT, THANHVIEN_USER_TT, MA_HRM_NVQL, TOBH, PBH, TTKD, MATINH_5917, SL_CHNL_REGISTER_KEY, GEO_STATE_KEY_5917, TB_TRE, GEO_STATE_KEY_DK2, GEO_STATE_MA_KENH_BAN, MA_HRM_KENH_BAN, CHANNEL_TYPE_ID_TT, DOITUONG_KENHBAN_15B, MA_PBH_DK, MA_TTKD_DK, ID_DB, TK_BUNDLE
from ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_new@coevnpt
where mo_key = 202408 and ACCS_MTHD_KEY  in(select * from a_temp24);
;


create table a_temp24 as
with cte as(
select ma_tb from EMAIL_BSCC_PBHKVBC_202408
union all
select MA_TB from EMAIL_BSCC_PBHKVCL_202408
)
select * from cte where ma_tb not in (select ma_tb from KPI_tonghop202408_10_8 where loai_tb = 'ptm');

select * from KPI_tonghop202408_10_8;

insert into KPI_tonghop202408_10_8 (KENH_BAN,MA_TB, MA_TIEPTHI,LOAI_TB, THANG_KH, ngay_kh)
select 'coevnpt', ACCS_MTHD_KEY, MA_KENH_BAN, 'ptm', 202408, ACTVTN_DT
from EMAIL_BSCC_GIAIQUYET_202408;

select * from KPI_tonghop202408_10_9 where ma_tb in (select MA_TB from EMAIL_BSCC_PBHKVBC_202408) kenh_ban = 'coevnpt';

INSERT INTO KPI_tonghop202408_10_8  (ID, ID_KENH, KENH_BAN, MA_TB, GOI_CUOC, P2_CHUKY, GIA_GOI,
MA_TIEPTHI, MANV_PTM, LOAI_KENH, LOAI_TB, THANG_KH,GIA_GOI_PHAN_KY_THANG_N, ngay_kh)
SELECT -1, STT, LOWER(CONG_CU_BAN_GOI), SO_TB, MA_GOI, CHU_KY_GOI, DOANH_THU_BAN_GOI, USER_KENH_BAN, HRM_NV_BAN_GOI_NV_QLKENH_BAN,
LOAI_KENH_BAN, 'ptm_goi', 202408,round(DOANH_THU_BAN_GOI_PHAN_KY/1.1,0), NGAY_DK_GH_GOI
FROM manpn.bscc_import_goi_bris
WHERE HINH_THUC_TB = 'TT'
AND THANG = 202408
AND SO_TB IN (SELECT MA_TB FROM KPI_tonghop202408_10_8  WHERE LOAI_TB='ptm' and KENH_BAN = 'coevnpt')
AND SO_TB NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10_8  WHERE LOAI_TB='ptm_goi'
                                        AND GIA_GOI > 0)
AND SO_TB NOT IN (SELECT MA_TB FROM KPI_tonghop202408_10_8  WHERE LOAI_TB='ptm_goi' and kenh_ban = 'bundle_xuatkho');



-------------Th? ??c tháng 8------------------------------------------
insert into KPI_tonghop202408_10_4 (KENH_BAN,MA_TB, MA_TIEPTHI,LOAI_TB, THANG_KH, ngay_kh)
select 'smrs', '84' || SUBSCRIBER_ID, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
from bscc_import_ptm_smrs
where thang = MANPN_GET_YEARMONTH_FROM_M(1)
    and '84' || SUBSCRIBER_ID in (select ma_tb from Khieunai_ThuDuc_t8);

    select * from KPI_tonghop202408_10_4;

--Import ptm trên smrs không ??, c?n b? sung thêm t? Bris: http://bris.vnpt.vn/Report/Kri/Report/Analyze?report_type=hqkd_ct_ddtt
insert into KPI_tonghop202408_10_4(MA_TB, KENH_BAN, MA_TIEPTHI, THANG_KH, MANV_DKTT, LOAI_TB, LOAI_KENH, ngay_kh)
SELECT A.SO_TB, 'bris', A.USER_DKTT, A.THANG, A.MA_HRM_USER_DKTT, 'ptm', A.LOAI_KENH, NGAY_KICH_HOAT
FROM bscc_import_ptm_bris_pl01 A
WHERE A.THANG = MANPN_GET_YEARMONTH_FROM_M(1)
    and A.SO_TB not in (select '84'||SUBSCRIBER_ID from bscc_import_ptm_smrs where thang = MANPN_GET_YEARMONTH_FROM_M(1))
    and a.so_tb in (select ma_tb from Khieunai_ThuDuc_t8);


    select * from KPI_tonghop202408_10_4;

    -------------khi?u n?i ch? l?n-----------------
    insert into KPI_tonghop202408_10 (KENH_BAN,MA_TB, MA_TIEPTHI,LOAI_TB, THANG_KH, ngay_kh)
select 'smrs', '84' || SUBSCRIBER_ID, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
from bscc_import_ptm_smrs
where thang = MANPN_GET_YEARMONTH_FROM_M(1)
    --and  '84' || SUBSCRIBER_ID not in (select ma_tb from KPI_tonghop202408_10 where loai_tb = 'ptm')
    and '84' || SUBSCRIBER_ID in (select ma_tb from khieunai_hoocmon_t7);

    INSERT INTO KPI_tonghop202408_10  (LOAI_TB, KENH_BAN, MA_TB, MA_TIEPTHI, GOI_CUOC, GIA_GOI, THANG_KH, MANV_PTM, MAPB_PTM, KENH_NOIBO)
SELECT 'ptm_goi','bundle_xuatkho', B.MA_TB, ACCOUNT_DK, LOAI_SIM, GIA_GOI, THANG_KH, MA_NV, MA_PB, KENH_NOIBO
FROM manpn.BUNDLE_XUATKHO_PDH B
WHERE B.THANG_KH = 202408
AND B.MA_TB IN (SELECT A.MA_TB FROM KPI_tonghop202408_10  A WHERE LOAI_TB='ptm')
and B.MA_TB IN (select ma_tb from khieunai_hoocmon_t7)
;

merge into manpn.KPI_tonghop202408_10 t1
using (
    SELECT a.ma_tb, b.NGAY_KH
    FROM manpn.KPI_tonghop202408_10 A LEFT JOIN (select * from KPI_tonghop202408_10 where loai_tb = 'ptm') B ON A.MA_TB = B.MA_TB
    WHERE A.kenh_ban  = 'bundle_xuatkho'
    ) t2
on (t1.ma_tb = t2.ma_tb)
when matched then update set T1.NGAY_KH = T2.NGAY_KH
when not matched /* never happens */ then insert (T1.TKC_THANG_N) values (null);