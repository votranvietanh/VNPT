-- 7 nguồn báo cáo
select*from KPI_tonghop202408 where kenh_ban ='smrs';
select count(*) from SSS_dgia_202408 where thang = 202408;
select * from manpn.bscc_import_ptm_bris_pl01 where thang = 202408
and so_tb  in (select '84'||SUBSCRIBER_ID from bscc_import_ptm_smrs where thang = 202408);

select distinct loai_sim from manpn.bscc_import_ptm_bris_pl01;

select * from PL4_2024 where ma_tb = '84815584214';

select * from SSS_dgia_202408;

delete from SSS_dgia_202408 where nguon ='digishop_sim'
;
select ma_tb from SSS_dgia_202408 where ma_tb in (select ma_tb from SSS_dgia_202408 group by ma_tb having count(ma_tb)>1)
;

drop table SSS_dgia_202408;
select * from ttkd_bct.va_dm_loaikenh_bh;
select count(*) from SSS_dgia_202408; --20256
desc SSS_dgia_202408;

----insert PTM:
    insert into SSS_dgia_202408(nguon,ma_tb,username_kh,tenkieu_ld,thang_ptm,ngay_kh)
    select 'smrs','84' || SUBSCRIBER_ID, ACCOUNT_DK, 'ptm', THANG, to_date(NGAY_KH, 'yyyy-mm-dd')
    from bscc_import_ptm_smrs 
    where thang = 202408
        and  '84' || SUBSCRIBER_ID not in (select ma_tb from SSS_dgia_202408 where tenkieu_ld = 'ptm');
    -----------
    insert into SSS_dgia_202408(nguon,ma_tb,username_kh,tenkieu_ld,thang_ptm,ngay_kh)
    select 'bris',ma_tb,user_dktt,'ptm',thang, NGAY_KICH_HOAT
        from PL1_2024
            where thang = 202408
            and  ma_tb not in (select ma_tb from SSS_dgia_202408 where tenkieu_ld = 'ptm')
            ;
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
    INSERT INTO SSS_dgia_202408 (thang_ptm,nguon, KENH_trong, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd,thang_kt)
    SELECT thang, 'digishop_sim', 1, 'ptm-goi', STB, GIA_GOI, TEN_GOI, MA_TIEPTHI
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO,thang,to_char(add_months(ngay_tao, CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END),'yyyymm')
    FROM BSCC_DIGI
    WHERE THANG = 202408 
        and LOAI_TB like 'Tr_ tr__c' --tra truoc
        and TRANG_THAI = 'Thành công'
    AND STB IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm-goi');
    
    ----
    INSERT INTO SSS_dgia_202408 (THANG_ptm,nguon, KENH_TRONG, tenkieu_ld,  MA_TB, tien_GOI, ten_goi, username_kh, CK_GOI, ngay_kh,thang_bd,thang_kt)
    SELECT thang, 'digishop_pac', 1, 'ptm-goi', STB, GIA_GOI, TEN_GOI, MA_GIOI_THIEU_DH
        , CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END, NGAY_TAO_DON,
        thang,to_char(add_months(NGAY_TAO_DON, CASE WHEN CHU_KY < 30 THEN 0 ELSE CHU_KY/30 END),'yyyymm')
    FROM BSCC_DIGI_DONLE
    WHERE THANG = 202408 and ngay_hoan_thanh is not null -- tại 1 tb có nhiều dòng gói giống nhau, nhưng chỉ có 1 dòng có ngay_ht là dky thành công
    AND STB  IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm')
    AND STB  NOT IN (SELECT MA_TB FROM SSS_dgia_202408 WHERE tenkieu_ld = 'ptm_goi');
    
    -----
    INSERT INTO SSS_dgia_202408  (thang_ptm,tenkieu_ld, nguon, MA_TB, username_kh, ten_goi, tien_goi,  ngay_kh,thang_bd,thang_kt)
    SELECT thang,'ptm-goi',CASE WHEN MUC_CK = 0 THEN LOWER(KENH_XUAT_BAN) ELSE 'bundle' END,
                    B.MSISDN, ACCOUNT_DK, SERVICE_CODE, GIA_GOI, to_date(substr(NGAY_KH,1,instr(NGAY_KH, '2024')+3), 'mm/dd/yyyy'),thang,
                     TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(NGAY_KH, 1, INSTR(NGAY_KH, '2024') + 3), 'mm/dd/yyyy'), CHU_KY_GOI), 'yyyymm') AS thang_kt
                     
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
    with J as (select ma_tb,count(ma_tb)dem_va from SSS_dgia_202408
    group by ma_tb)
    , K as (select ma_tb,count(ma_tb) dem_man from manpn.manpn_goi_tonghop_202408
    group by ma_tb)
    select j.ma_tb,j.dem_va,k.dem_man from K
    left join J on j.ma_tb =k.ma_tb
    where j.dem_va <> k.dem_man
;
select * from SSS_dgia_202408 where ma_tb ='84886759961';

update SSS_dgia_202408 b
set TIEN_GOI = ( select a.GIAGOI_SAUCK_COVAT from MANPN.BSCC_INSERT_DM_KIT_BUNDLE a where a.ten_goi = b.ten_goi)
where tien_goi is null and (nguon = 'bundle_xuatkho' or nguon = 'bundle')
;
update SSS_dgia_202408
set TIEN_THULAO_DNHM = 20000
where tenkieu_ld = 'ptm'
;
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
WHERE a.manv_ptm IS NULL;
update SSS_dgia_202408
set TENNV_PTM = (select b.ten_nv from ttkd_bsc.nhanvien b where b.thang = 202408 and manv_Ptm = b.ma_nv)
;


select * from ttkd_bsc.nhanvien where thang =202408;
select ma_tb,DOANHTHU_DONGIA_NVPTM,DOANHTHU_KPI_NVPTM,LUONG_DONGIA_DNHM_NVPTM, LUONG_DONGIA_NVPTM,DOANHTHU_DONGIA_NVPTM, DOANHTHU_KPI_TO, DOANHTHU_KPI_PHONG ,DOANHTHU_KPI_DNHM, DOANHTHU_DONGIA_DNHM,LUONG_DONGIA_DNHM_NVPTM
,DOANHTHU_KPI_DNHM_PHONG,KENH_NOIBO, THOADK_BSC, THOADK_DG from ttkd_bsc.ct_bsc_ptm a where thang_ptm = 202408 and loaitb_id = 21 and tenkieu_ld ='ptm';
    
    select * from SSS_dgia_202408 where manv_ptm is not null;
    
    select * from ttkd_bsc.ds_diemban_31import;
 
          
       

            