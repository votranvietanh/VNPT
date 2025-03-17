--trash in khkt_bc_hoahong_2
        update khkt_bc_hoahong_2 a
        set dichvuvt_id = (select  DICHVUVT_ID from css_hcm.loaihinh_tb b where a.dichvu_vt = b.loaihinh_tb)
        ,loaitb_id = ((select  loaitb_id from css_hcm.loaihinh_tb b where a.dichvu_vt = b.loaihinh_tb))
        where dichvuvt_id is null
        ;
--chú Khanh chưa up lun 2 cột cuối dichvuvt_id và loaitb_id
        update khkt_bc_hoahong_2
        set (dichvuvt_id,loaitb_id) = (Select 4,61 from dual)
        where dichvu_vt ='MYTV' and dichvuvt_id is null
        ;
        update khkt_bc_hoahong_2
        set (dichvuvt_id,loaitb_id) = (Select 2,21 from dual)
        where dichvu_vt ='Di động'  and dichvuvt_id is null
        ;
        update khkt_bc_hoahong_2
        set (dichvuvt_id,loaitb_id) = (Select 4,210 from dual)
        where nguon ='KHANH WIFI MESH'  and loaitb_id is null
        ;


--CA-BHXH
        update khkt_bc_hoahong_2 a
        set dichvuvt_id = (select dichvuvt_id from ttkd_bsc.ct_bsc_ptm b where a.ma_tb = b.ma_tb and b.thang_ptm = 202406)
        ,loaitb_id = (select loaitb_id from ttkd_bsc.ct_bsc_ptm b where a.ma_tb = b.ma_tb and b.thang_ptm = 202406)
        where dichvuvt_id is null and loaitb_id is null and nguon = 'ketoan'
;
select *from ttkd_bsc.ct_bsc_ptm where ma_tb ='hcm_hddt_00006019';
select * from hoahong_imp_cntt;


select * from ocdm_sys.dwb_accs_mthd_hist@coevnpt where GEO_STATE_KEY=35 and PROD_LN_CD=2 and exists( select 1 from x_P_ts where ACCS_MTHD_KEY = SOMAY)
     and day_key >= 20240401 and ACCS_MTHD_KEY =84812253650

--
select * from khkt_bc_hoahong_2 where ma_tb in ('hcm_bldt_00000205',
'hcm_ca_00109213',
'hcm_ca_00105549',
'hcm_ivan_00038662',
'hcm_ca_00102484',
'hcm_ca_00108062',
'hcm_hddt_00023203',
'hcm_ca_00108446',
'hcm_ivan_00039248',
'hcm_ca_00104509',
'hcm_ca_00103197',
'hcm_ca_00103192',
'hcm_ca_00103194',
'hcm_ca_00103196',
'hcm_ca_00108902',
'hcm_hddt_00023244',
'hcm_ca_00108954',
'hcm_ca_00105745',
'hcm_bldt00000012',
'hcm_ca_00096773',
'hcm_ca_00078918',
'hcm_ca_00110230',
'hcm_ca_00108687',
'hcm_hddt_00001531',
'hcm_ca_00079122',
'hcm_ca_00106109',
'hcm_ivan_00039512',
'hcm_ivan_00010510',
'hcm_ca_00098028',
'hcm_bldt_00000210',
'hcm_ca_00110464')
;
select *
from HOAHONG_IMP_CNTT where MA_TB='hcm_hddt_00006019';

select *
from TTKD_BSC.ct_bsc_ptm where MA_TB='hcm_hddt_00006019';

select *
from manpn.bscc_import_ptm_shopctv where thang = 202411;

select *
from OCDM_STAGE.dwb_digi_shop_pac
order by day_Key;

select * from manpn.BSCC_DIGI_DONLE where thang = 202411;

select *
from manpn.bscc_ptm_bris_P01_moi;
-- bổ sung T11
select *
from bosung_T11;

select *
from manpn.BSCC_DIGI
where  thang = 202410
and stb ='84812058465';
update bosung_T11 a
set heso_hhbg = 0.25
where ten_goi is not null
;

update bosung_T11
set  DTHU_KPI = round(DTHU_DONGIA_GOI/1.1,2)
where dthu_kpi =0
;
select * from t11_bs_384;
select *from BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW@coevnpt where mo_key = 202411 and accs_mthd_key in( 84914718764,84918086858);
create table t11_bs_384 as
 select * from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D@coevnpt where  GEO_STATE_CD='HCM' and LOAIHINH_TB='TT' and mo_key = 202411
       and accs_mthd_key in ('84832541112',
'84914718764',
'84911522469',
'84813447423',
'84914266681',
'84945331102',
'84915345111',
'84918086858',
'84918773999'
)
;

select * from DONGIA_DTHH  where thang = 202411 and  ma_tb in ('84919080372','84914511604')
;
select * from
vietanhvh.one_line_202411
where ma_tb in ('84814037546','84814056952',
'84829153337' ,
'84829111535',
'84814010825',
'84814011363'
)
;
select *
from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY;
select* from  manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where goi_cuoc like'12TK50G';
select *
from manpn.BSCC_INSERT_DM_KIT_BUNDLE where ten_goi ='VIP199';
                select * from ttkd_bct.va_dm_loaikenh_bh where thang = 202501 and ma_nd ='84886773419';
                   select * from one_line_202411; --Bổ sung tháng T11


select * from
vietanhvh.one_line_202411 --where ten_goi ='Sim D_VinaXtra';
where ma_tb in ('84914005861'
)
;;
    insert into bosung_t11(THANG_PTM, NGUON, PHAN_LOAI_KENH,ma_tb,TEN_GOI,CK_GOI_TLDG,MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI)
        select 202410,'Bổ sung tháng 11',PHAN_LOAI_KENH,ma_tb,goi_cuoc,P2_CHUKY,  MANV_PTM, MA_TO_PTM, MAPB_PTM ,GIA_GOI,DOANHTHU_KPI_NVPTM from manpn.manpn_goi_tonghop_202411
    where ma_tb in( '84813238173', '84813223775');

        select * from one_line_202411   where ma_tb in( '84813238173', '84813223775');
create table dm_goi_ck_ngay as;
SELECT  goi_cuoc ten_goi,CHU_KY_THANG ck_thang,CHU_KY_NGAY ck_ngay,'TT' dich_vu,GIA_GOI FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' ;

with had as(
select ten_goi
from dm_goi_ck_ngay group by ten_goi having  count(ten_goi)>1)

select *
from dm_goi_ck_ngay where ten_goi in (select ten_goi from had);

DELETE FROM dm_goi_ck_ngay
WHERE ROWID IN (
    SELECT rid
    FROM (
        SELECT ROWID AS rid,
               ROW_NUMBER() OVER (PARTITION BY TEN_GOI ORDER BY ROWID) AS rn
        FROM dm_goi_ck_ngay

    )
    WHERE rn > 1
);


select * from dongia_dthh where thang = 202411
                            and  ma_tb  in ('84845416112','84849994262','84842224191');
update vietanhvh.one_line_202411
set TIEN_THULAO_GOI = DTHU_DONGIA_GOI*0.25
where nguon ='Đơn giá bổ sung T11';
select * from vietanhvh.one_line_202411 where nguon ='Đơn giá bổ sung T11';
;
select * from  dongia_PTTT_202411 where  CONG_CU_BAN_GOI ='DIGISHOPWEB' and loai_gd ='GIAHAN';

select * from ctv_pttt;
alter table nhanvien_ctv_pttt
add is_ipcc number;
select * from nhanvien_ctv_pttt;

 select * from vietanhvh.dongia_dthh  where thang = 202411 and LOAI_GD = 'DANGKY' and ma_nv in ('VNP019931',
'CTV080819',
'CTV085211');
create table a_loai_sim_202208 tablespace COE_VNPT_TBS as
    select '84913196667' ma_tb from dual ;

select * from a_loai_sim_202208;

select *
from ttkd_bct.hocnq_cp_nhancong_hoahong where thang_tldg = 202411 and ma_tb ='hcm_smartca_00404651'
;


        select * from hoahong_imp_cntt;

CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id)
);
SELECT *
FROM Enrollment
WHERE student_id = 101 ;


 select *
 from ttkd_bsc.ct_bsc_ptm  where ma_tb ='hcm_bldt_00000378';
select distinct  REGIS_TYPE_GRP from manpn.bscc_import_goi_bris_p04 where thang= 202411;
---
select a.ma_tb,b.KY_CUOC,no_goc
from dongia_dthh a
left join v_ct_no_202411 b on a.ma_tb = '84'||b.ma_tb
where LOAIHINH_TB ='TS' and LOAI_GD='DANGKY' and thang = 202411
;


select *
from TTKD_bsc.ct_bsc_ptm where ma_tb ='918782222';

 select * from qltn_hcm.ct_no where ma_Tb= '918782222'
 ;
select THUONGHIEU from css.v_db_cntt@dataguard  where thuebao_id =8688207
;
select * from css_hcm.phieutt_hd where ma_gd ='HCM-LD/01752759';
;
select *
from css.v_giaophieu@dataguard where hdtb_id =10948055;--HUONGGIAO_ID	3130	4130
select *
from CSS_hcm.huonggiao
where HUONGGIAO_ID=4130;

select *
from  css.loai_pt@dataguard;
---
select *
from admin.nhanvien@dataguard where nhanvien_id =418065;
select *
from admin.donvi@dataguard where donvi_id =418065;
select *
from css.v_hd_khachhang@dataguard where NGUOILAP_HD is not null ;
select *
from css.v_hd_thuebao@dataguard where ma_tb ='hcm_tmvn_00002397';
select *
from css.v_db_thuebao@dataguard
    ;
select *
from css.v_db_khachhang@dataguard
    ;
select *
from css_hcm.trangthai_hd
;
select*
from css_hcm.tocdo_adsl where TOCDO_ID =5063;

select*
from css_hcm.muccuoc where TOCDO_ID =5063;
;
select  * from css_hcm.loaihinh_tb;
select *
from css.v_chuquan@dataguard;
select LISTAGG(LOAI_FILE, ', ') WITHIN GROUP (ORDER BY LOAI_FILE) AS LOAI_FILE_LIST
from admin.v_file_hs@dataguard  hs
         left join admin.v_hs_thuebao@dataguard  hstb on hs.file_id =hstb.file_id
         left join admin.loai_file@dataguard lf on lf.LOAIFILE_ID = hs.LOAIFILE_ID
    where hstb.ma_tb ='hcm_ca_00056880';
 select * from admin.loai_hs@dataguard;
    select * from admin.loai_file@dataguard; --dm loai file
    select * from admin.loai_hs_icon@dataguard;
    select * from admin.v_hoso@dataguard;
    select * from admin.v_hs_thuebao@dataguard where ma_tb ='hcm_ca_00056880';

select *
from TTKD_BCT.db_thuebao_ttkd;
select *
from admin.v_hs_thuebao@dataguard ; --ma_tb
select *
from admin.v_file_hs@dataguard ; --file_id
select *
from admin.v_file_hs@dataguard;
select *
from admin.loai_file@dataguard ;
select *
from ds_loaitru_T10 where ma_tb ='84814033193';



WITH CTE_FILE AS (
    SELECT
        hstb.ma_tb,
        LISTAGG(lf.LOAI_FILE, ', ') WITHIN GROUP (ORDER BY lf.LOAI_FILE) AS LOAI_FILE
    FROM
        admin.v_hs_thuebao@dataguard hstb
    LEFT JOIN admin.v_file_hs@dataguard hs ON hs.file_id = hstb.file_id
    LEFT JOIN admin.loai_file@dataguard lf ON lf.LOAIFILE_ID = hs.LOAIFILE_ID
    GROUP BY hstb.ma_tb
),
CTE_Main AS (
    SELECT
        a.*,
        x.ma_tb,
        y.ma_kh,
        y.ma_gd,
        z_lhd.TEN_LOAIHD AS loai_hd,
        y.NGAY_YC,
        y.NGAYLAP_HD,
        z_kld.TEN_KIEULD AS tenkieu_ld,
        y.DIACHI_KH,
        nv_giao.TEN_NV AS NV_GIAO,
        dv_giao.TEN_DV AS to_GIAO,
        pb_giao.ten_dv AS pb_GIAO,
        noi_nhan.TEN_DV AS noi_nhan,
        y.NGUOILAP_HD,
        y.GHICHU,
        ctv.TEN_NV AS CTV,
        to_ctv.TEN_DV AS to_CTV,
        pb_ctv.TEN_DV AS pb_CTV,
        tt_hd.TRANGTHAI_HD AS trang_thai_HD,
        x.ngay_ht AS ngay_hoanthanh,
        hd.HUONGGIAO_ID || ' - ' || hg.HUONGGIAO AS huongigao_ttkd,
        tocdo.TOCDO AS muccuoc_tb,
        tt_tb.TRANGTHAI_TB AS trangthai_tb,
        lh_tb.LOAIHINH_TB AS loaihinh_tb,
        dt.TEN_DT AS doi_tuong,
        dbtb.NGAY_SD,
        cq.TENCHUQUAN AS chu_quan,
        gc.THUONGHIEU AS GOI_CUOC,
        dbkh.mst AS mst_khachhang,
        b.NGAY_BD AS ngay_batdau,
        b.NGAY_KT AS ngay_ket_thuc,
        cf.LOAI_FILE AS LOAI_FILE,
        bct.MAPB_QL AS ma_pb_cskh,
        pb_cskh.ten_pb AS tenpb_cskh,
        to_cskh.TEN_DV AS to_cskh,
        nv_cskh.TEN_NV AS nv_cskh,
        ROW_NUMBER() OVER (PARTITION BY hd.hdtb_id ORDER BY hg.huonggiao_id DESC) AS rn
    FROM
        x_CDS_cDung a
    LEFT JOIN css.v_db_cntt@dataguard b ON a.DOMAIN = b.DOMAIN
    LEFT JOIN css.v_hd_Thuebao@dataguard x ON x.thuebao_id = b.thuebao_id
    LEFT JOIN css.v_hd_khachhang@dataguard y ON x.HDKH_ID = y.HDKH_ID
    LEFT JOIN css.v_db_khachhang@dataguard dbkh ON dbkh.KHACHHANG_ID = y.KHACHHANG_ID
    LEFT JOIN css.v_giaophieu@dataguard hd ON hd.hdtb_id = x.hdtb_id
    LEFT JOIN css.v_db_thuebao@dataguard dbtb ON x.thuebao_id = dbtb.thuebao_id
    LEFT JOIN CSS_HCM.huonggiao hg ON hg.HUONGGIAO_ID = hd.HUONGGIAO_ID
    LEFT JOIN css_hcm.loai_hd z_lhd ON z_lhd.LOAIHD_ID = y.LOAIHD_ID
    LEFT JOIN css_hcm.kieu_ld z_kld ON z_kld.KIEULD_ID = x.kieuld_id
    LEFT JOIN admin.nhanvien@dataguard nv_giao ON nv_giao.NHANVIEN_ID = hd.NHANVIEN_GIAO_ID
    LEFT JOIN admin.donvi@dataguard dv_giao ON dv_giao.DONVI_ID = hd.DONVI_GIAO_ID
    LEFT JOIN admin.donvi@dataguard pb_giao ON pb_giao.donvi_id = dv_giao.DONVI_CHA_ID
    LEFT JOIN admin.donvi@dataguard noi_nhan ON noi_nhan.DONVI_ID = y.donvi_id
    LEFT JOIN admin.nhanvien@dataguard ctv ON ctv.NHANVIEN_ID = y.CTV_ID
    LEFT JOIN admin.donvi@dataguard to_ctv ON to_ctv.donvi_id = ctv.donvi_id
    LEFT JOIN admin.donvi@dataguard pb_ctv ON pb_ctv.donvi_id = to_ctv.DONVI_CHA_ID
    LEFT JOIN css_hcm.trangthai_hd tt_hd ON x.TTHD_ID = tt_hd.TTHD_ID
    LEFT JOIN css_hcm.tocdo_adsl tocdo ON tocdo.TOCDO_ID = b.TOCDO_ID
    LEFT JOIN css_hcm.trangthai_tb tt_tb ON dbtb.TRANGTHAITB_ID = tt_tb.TRANGTHAITB_ID
    LEFT JOIN css_hcm.loaihinh_tb lh_tb ON dbtb.LOAITB_ID = lh_tb.LOAITB_ID
    LEFT JOIN css_hcm.doituong dt ON dbtb.DOITUONG_ID = dt.DOITUONG_ID
    LEFT JOIN css.v_chuquan@dataguard cq ON cq.CHUQUAN_ID = b.CHUQUAN_ID
    LEFT JOIN css_hcm.tocdo_adsl gc ON gc.TOCDO_ID = b.TOCDO_ID
    LEFT JOIN CTE_FILE cf ON cf.ma_tb = x.ma_tb
    LEFT JOIN TTKD_BCT.db_thuebao_ttkd bct ON bct.thuebao_id = b.thuebao_id
    LEFT JOIN dm_pbh pb_cskh ON bct.MAPB_QL = pb_cskh.ma_pb
    LEFT JOIN admin.donvi@dataguard to_cskh ON to_cskh.DONVI_ID = bct.TBH_QL_ID
    LEFT JOIN admin.nhanvien@dataguard nv_cskh ON nv_cskh.NHANVIEN_ID = bct.NHANVIEN_ID
)
SELECT *
FROM CTE_Main
WHERE rn = 1
FETCH FIRST 100 ROWS ONLY;
--
-- ins tmp xk
insert into SSS_dgia_202412(nguon,ma_tb,username_kh,TEN_GOI,tenkieu_ld,tien_goi,thang_ptm,manv_ptm,ma_pb,ngay_kh)
;
create table bundle_xuatkho as
with a1 as (select a.*,b.manv_dktt user_kh from bundle_xk a
join SSS_dgia_202412 b
on a.tb = b.ma_tb
)
, db as (select a.*, row_number () over (partition by tb order by tb asc) rn from a1 a )

    SELECT 'bundle_xuatkho' nguon, B.tb, USER_KH, LOAI_SIM,'ptm-goi' tenkieu_ld
        ,(select ngay_kh from SSS_dgia_202412 where tenkieu_Ld = 'ptm' and ma_tb=b.tb) ngay_kh
    FROM (
            select * from db where rn = 1
        ) B
       where
           B.tb IN (SELECT A.MA_TB FROM SSS_dgia_202412 A WHERE tenkieu_ld='ptm')
;
select * from ttkd_bsc.ct_bsc_ptm where ma_tb ='baochi_net2';
select * from manpn.bscc_import_goi_bris_p04 where accs_mthd_key ='84918906090';

select* from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY
where goi_cuoc in ('MI_YOLO35')
;
, case when LOAI_GD in('Gia hạn CKD','Gia hạn CKN') then 'GIAHAN'
                                                when LOAI_GD='Bán gói tập không gói' then 'DANGKY'end
;
select TENNV_PTM,count(ma_tb) from one_line_202412 where ma_tb in (select ma_tb from x_nv_hotro)
group by TENNV_PTM
;
update DONGIA_DTHH
set thang_tldg = null
where LYDO_KHONGTINH is not null and thang = 202502;


select count(ma_tb) from dongia_dthh where LYDO_KHONGTINH is not null and thang = 202502;
select * from dongia_dthh where ma_tb = '84912723806';

select * from dongia_dthh where thang = 202501 and LYDO_KHONGTINH like '%Chưa thanh toán đủ%' and ma_pb ='VNP0703000'
and ma_tb in (select '84'||ma_tb from v_ct_no_202502 where NO_GOC<=999)
;
select * from dongia_dthh
where thang = 202412 and LYDO_KHONGTINH ='G.TIEN' and ma_tb in (select ma_tb from x_update_loaigdt11 where TRANS_TYPE='DANGKY' );

update dongia_dthh
set TIEN_THULAO = round((DTHU_TLDG/1.1)*(heso/100),0)
where thang = 202412 and LYDO_KHONGTINH ='G.TIEN'
;
                select * from dongia_dthh where ma_tb in ('84849400608','84842475189'
,'84847044948');
select * from OB_BANGOI_CT where '84'||SO_THUE_BAO  in (select ma_tb
from x_bhol_12);
select *
from x_bhol_12;
select *
from DONGIA_DTHH where thang= 202412 and ma_tb ='84945269926';


select* from dongia_dthh a
where thang = 202412 and ma_tb in('84918143433',
'84855502736',
'84917520017',
'84916944107',
'84853104543',
'84915347142',
'84855448448') ;

select *
from x_bhol_12;
update dongia_dthh a
set (TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB) = (select x.TEN_NV, x.MA_VTCV, x.MA_TO, x.TEN_TO, x.MA_PB, x.TEN_PB from ttkd_bsc.nhanvien x  where x.thang = 202412 and a.ma_nv=x.ma_nv)
where thang = 202412 and thang_tldg is null;

select *
from SSS_DGIA_202502 where ma_tb ='84918906090';


 MERGE INTO dongia_dthh a
        USING (
            SELECT ACCS_MTHD_KEY
            FROM (select ACCS_MTHD_KEY from  bi_nctt.hvc_202412_chot@coevnpt where tinh_PSC = 'HCM')
            ) b
        ON (a.ma_tb = b.ACCS_MTHD_KEY)
        WHEN MATCHED THEN
            UPDATE SET a.loai_hvc = 'HVC'
 where thang = 202412 and thang_tldg is null;

UPDATE dongia_dthh a
  set TIEN_THULAO = round((DTHU_TLDG/1.1)*heso/100)
        WHERE  thang = 202412 and thang_tldg is null ;;

UPDATE dongia_dthh a
  set LOAIHINH_TB = (select distinct LOAIHINH_TB from manpn.bscc_import_goi_bris_p04 b
    where a.ma_tb = b.accs_mthd_key)
  ,DTHU_TLDG=DTHU_GOI
        WHERE  thang = 202412 and thang_tldg is null ;;

select count(*)
from dongia_dthh WHERE
    thang = 202412;
select *
from dongia_dthh WHERE
    thang = 202412 and thang_tldg is null and ma_tb ='84944007113'; set TIEN_THULAO = round((DTHU_TLDG/1.1)*heso/100*IS_TBHH)
select *
from one_line_202412 where ma_tb in('84814091076',
'84856791505',
'84814076812')
;
select *
from MANPN.manpn_goi_tonghop_202502
where ma_tb ='84918906090';
select *
from manpn.BUNDLE_XUATKHO_PDH where ma_tb ='84816252485' and thang_kh = 202502;

select *-- MA_TB,  MANV_PTM manv_goc, TENNV_PTM, TEN_GOI,'' manv_thaythe,TIEN_THULAO_DNHM,tien_goi,TIEN_THULAO_GOI
            from one_line_202502 where  mapb_ptm ='VNP0701600' and ten_goi in ('TR60D','TR80D')
        and ma_tb ='84886170070'
  ;
select * from vietanhvh.dongia_pttt_202412 where ma_tb in (
select a.ma_tb
from dongia_dthh a
join  x_heso_onl_12 b
on a.ma_tb =b.ma_tb and a.ma_nv =b.ma_nv and a.ten_goi =b.ten_goi
where thang = 202412 and ma_pb ='VNP0700800' and loai_gd ='DANGKY')
   ;
select a.rowid,a.*
from dongia_dthh a
join  x_heso_onl_12 b
on a.ma_tb =b.ma_tb and a.ma_nv =b.ma_nv and a.ten_goi =b.ten_goi
and  thang = 202412  and loai_gd ='DANGKY' and ma_pb ='VNP0703000'
;
select *
from ob_202412_ngayht
;

--


WITH ct AS (
    SELECT
        khoanmuctt_id,
        hdtb_id,
        phieutt_id,

        SUM(tien) tien,
        SUM(vat) vat

    FROM css.v_ct_phieutt@dataguard
    GROUP BY hdtb_id, phieutt_id, khoanmuctt_id
)
,
dich_vu as (
     select thuebao_id,chuquan_id from css.v_db_adsl@dataguard
         union all
    select thuebao_id,chuquan_id from css.v_db_cntt@dataguard
        union all
     select thuebao_id,chuquan_id from css.v_db_mgwan@dataguard
        union all
     select thuebao_id,chuquan_id from css.v_db_IMS@dataguard
        union all
     select thuebao_id,chuquan_id from css.v_db_CD@dataguard
        union all
     select thuebao_id,chuquan_id from css.v_db_gp@dataguard
        union all
    select distinct thuebao_id, chuquan_id from css.v_db_tsl@dataguard
)
,
std_onebss AS (
    SELECT
       b.tthd_id,b.loaitb_id, a.ma_gd, b.hdtb_id, b.thuebao_id, b.ma_tb, a.loaihd_id, b.kieuld_id, b.donvi_id donvi_tt_id,
        a.ngay_yc, b.ngay_ht, a.ctv_id, a.nhanviengt_id, a.nhanvien_id -- xiu xoa a.nhanvien_id,
        , d.ngay_tt,d.ngay_hd, d.seri, d.soseri
        ,c.khoanmuctt_id
        , d.thungan_tt_id, d.ht_tra_id, d.kenhthu_id, d.trangthai, cq.tenchuquan,cq.chuquan_id

        , CASE WHEN c.khoanmuctt_id = 19 THEN c.tien ELSE 0 END km_lapdat
        , CASE WHEN c.khoanmuctt_id = 19 THEN c.vat ELSE 0 END vat_km
        , CASE WHEN c.khoanmuctt_id NOT IN (19) THEN c.tien ELSE 0 END tien_thu --5 token
        , CASE WHEN c.khoanmuctt_id NOT IN (19) THEN c.vat ELSE 0 END vat_thu
    FROM
        css.v_hd_khachhang@dataguard a
    LEFT JOIN
        css.v_hd_thuebao@dataguard b ON a.hdkh_id = b.hdkh_id
    LEFT JOIN
        ct c ON b.hdtb_id = c.hdtb_id
    JOIN
        css.v_phieutt_hd@dataguard d ON c.phieutt_id = d.phieutt_id AND (c.tien <> 0)
    LEFT JOIN
        dich_vu dvu on b.thuebao_id = dvu.thuebao_id
    LEFT JOIN
        css_hcm.chuquan cq ON cq.chuquan_id = dvu.chuquan_id

    WHERE

      ((TO_CHAR(b.ngay_ins, 'yyyymm')) = (TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM'))
            or (    d.ngay_tt < trunc(sysdate, 'month')
                    and nvl(ngay_ht, sysdate) >= trunc(sysdate, 'month')
                    and (TO_CHAR(b.ngay_ins, 'yyyymm')) = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM')
                )
        )
        AND b.donvi_id IS NOT NULL
        AND dvu.chuquan_id in (145,264,266)
        AND b.tthd_id in (2,3,4,5,6)

)
,
x_onebss AS (
    SELECT
        a.tthd_id,a.loaihd_id,a.kieuld_id,a.trangthai,a.khoanmuctt_id,dv.dichvuvt_id,a.loaitb_id, q.loaihinh_tb,a.ma_gd, a.hdtb_id, a.thuebao_id, a.ma_tb, b.MA_LOAIHD,
        b.TEN_LOAIHD, c.ten_kieuld, a.ngay_yc, a.ngay_ht
        , d.ten_nv, m.ten_dv,s.ten_dv pbh,
        a.donvi_tt_id,l.ten_dv ten_pb_ttvt,
         a.ngay_tt,a.ngay_hd,a.seri,a.soseri
        , round(sum(a.tien_thu)) tien, round(sum(a.vat_thu)) vat, round(sum(a.km_lapdat)) km_lapdat, round(sum(a.vat_km)) vat_km,
        h.ht_tra, i.KENHTHU,
        CASE
            WHEN a.trangthai = 1 THEN 'Da thu tien'
            ELSE  'Chua thu tien'
        END AS trangthai_tt,
        a.tenchuquan
    FROM
        std_onebss a
    JOIN
        css_hcm.loai_hd b ON a.loaihd_id = b.loaihd_id
    LEFT JOIN
        css_hcm.kieu_ld c ON a.kieuld_id = c.kieuld_id
    LEFT JOIN
        admin_hcm.nhanvien_onebss d ON d.nhanvien_id = a.ctv_id
    LEFT JOIN
        admin_hcm.donvi m ON d.DONVI_ID = m.DONVI_ID
    LEFT JOIN
        admin_hcm.donvi s ON m.DONVI_cha_ID = s.DONVI_ID
        --ttvt

    LEFT JOIN
        admin_hcm.donvi l ON l.DONVI_ID = a.donvi_tt_id
        --
    LEFT JOIN
        css_hcm.hinhthuc_tra h ON h.ht_tra_id = a.ht_tra_id
    LEFT JOIN
        css_hcm.kenhthu i ON a.kenhthu_id = i.kenhthu_id
    LEFT JOIN
        css_hcm.loaihinh_tb q ON q.loaitb_id = a.loaitb_id
     LEFT JOIN
         css_hcm.dichvu_vt dv on q.dichvuvt_id =dv.dichvuvt_id

     GROUP BY a.tthd_id,a.HDTB_ID,dv.dichvuvt_id,q.loaihinh_tb, a.loaitb_id, a.ma_gd, a.hdtb_id, a.thuebao_id, a.ma_tb, b.MA_LOAIHD,
        b.TEN_LOAIHD, c.ten_kieuld, a.ngay_yc, a.ngay_ht
        , d.ten_nv, m.ten_dv,s.ten_dv
      ,a.donvi_tt_id,l.ten_dv,
       a.ngay_tt,a.ngay_hd,a.seri,a.soseri, h.ht_tra, i.KENHTHU, a.khoanmuctt_id, a.trangthai,a.kieuld_id,a.loaihd_id
       ,
        CASE
            WHEN a.trangthai = 1 THEN 'Da thu tien'
            ELSE  'Chua thu tien'
        END ,
        a.tenchuquan
)
select * from x_onebss where ma_tb ='lthoa12'  ;

select *
from ob_202412_ngayht
order by ngay_ins
;

select a.*
--      ,b.*
from onebss_202405 a
-- left join ttkdhcm_ktnv.baocao_doanhthu_dongtien_pktkh b
-- on a.ma_tb =b.ma_tb and a.ma_gd=b.ma_gd
where a.NGAY_TT > TO_DATe('01/02/2025', 'DD/MM/YYYY');
update onebss_202405 a
set
(TRANGTHAI_TT,KENHTHU,HT_TRA) = (select b.TRANGTHAI_TT,b.KENHTHU,b.HT_TRA
                                    from ttkdhcm_ktnv.baocao_doanhthu_dongtien_pktkh b
                                    where a.ma_gd =b.ma_gd and a.ma_tb =b.ma_tb and a.HDTB_ID=b.HDTB_ID
                                    and a.KHOANMUCTT_ID =b.KHOANMUCTT_ID
                                    )
where a.NGAY_TT > TO_DATe('01/02/2025', 'DD/MM/YYYY');

update onebss_202405 a
set
(ngay_tt,ngay_hd) = (select b.ngay_tt,b.ngay_hd
                                    from ttkdhcm_ktnv.baocao_doanhthu_dongtien_pktkh b
                                    where a.ma_gd =b.ma_gd and a.ma_tb =b.ma_tb and a.HDTB_ID=b.HDTB_ID
                                    and a.KHOANMUCTT_ID =b.KHOANMUCTT_ID
                                    )
where a.NGAY_TT > TO_DATe('01/02/2025', 'DD/MM/YYYY');

select * from ttkdhcm_ktnv.TBL_VNP_BRIS where thang = 202501 and ma_tb in (84816297181

    )
;

  select * fROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt
 where GEO_STATE_KEY_STOCK = 35
    and GEO_STATE_KEY_DTCP = 35
       and ACTV_TYPE ='PTM' and accs_mthd_key =84914658204

;
select * from onebss_202405    where ma_tb ='nguyenhuy2260'
select * from ttkdhcm_ktnv.baocao_doanhthu_dongtien_pktkh  where ma_tb ='thunga1970';
select *
from css_hcm.khoanmuc_tt where khoanmuctt_id = 19;

select* from ttkdhcm_ktnv.TBL_VNP_BRIS
where  ma_tb in (84886917520,
84886917353,
84886915734
) and thang = 202501
;
update ttkdhcm_ktnv.TBL_VNP_BRIS
set dthu_HMM= 22727
where goicuoc ='D159V' and thang = 202501 and ma_tb in (84886917520,
84886917353,
84886915734
)
;
        select * from ttkd_bsc.blkpi_danhmuc_kpi where ma_kpi ='HCM_CL_TNGOI_003';
select * from onebss_202405 where ma_tb = 'gtqk176';
 select * from ttkd_bsc.bangluong_kpi x where thang = 202501 and ma_kpi like '%_060';


select * from ttkd_bct.hocnq_cp_nhancong_hoahong
WHERE thang_tldg = 202412
and kenh_ptm is null
and LOAIHINH_TB <> 'VNPTT'
;
update  ttkd_bsc.bangluong_kpi
set tytrong = null,chitieu_giao = null
where ma_kpi like '%060%' and thang = 202501 and ma_vtcv in ('VNP-HNHCM_BHKV_2','VNP-HNHCM_BHKV_1')
    and ma_nv not in (select ma_nv from ttkd_bsc.blkpi_dm_to_pgd where thang = 202501 and ma_kpi like '%HCM_DT_PTMOI_060%');


);

select * from ttkd_bsc.bangluong_kpi where thang = 202412 and CHITIEU_GIAO = 100;
select * from ttkd_bsc.bangluong_kpi where thang = 202501 and ma_kpi like '%012%'; and CHITIEU_GIAO is null;

select * from ttkd_bsc.bangluong_kpi
where thang = 202501 and ma_kpi = 'HCM_DT_PTMOI_060' and ma_vtcv in ('VNP-HNHCM_BHKV_2','VNP-HNHCM_BHKV_1') AND MA_NV  IN (
select MA_NV from ttkd_bsc.blkpi_dm_to_pgd where thang = 202501 and ma_kpi = 'HCM_DT_PTMOI_060');

select * from ttkd_bsc.blkpi_dm_to_pgd where thang = 202501 and ma_kpi = 'HCM_DT_PTMOI_060'
;
select *
from TTKD_BSC.nhanvien where ma_nv ='CTV087579';


select * from  S_DONGIA_DTHU_HIENHUU_202501_test
--set loaihinh_tb ='TT'
where
 THANG_KH_SIM is null;
      select * from S_DONGIA_DTHU_HIENHUU_202501_test where LOAIHINH_TB is null;


--  insert into ttkd_bsc.va_ct_bsc_ptm_vnptt(THANG_PTM, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM, MANV_GOC, TENNV_PTM, MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM, TIEN_DNHM, DTHU_DONGIA_DNHM, GIAMTRU_NGHIEPVU, TIEN_THULAO_DNHM, MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, HESO_HHBG, HESO_KK, TIEN_THULAO_GOI, LYDO_KHONGTINH_DONGIA,  GHI_CHU, VANBAN, MANV_DNHM_KPI, MATO_DNHM_KPI, MAPB_DNHM_KPI, DTHU_DNHM_KPI, MANV_GOI_KPI, MATO_GOI_KPI, MAPB_GOI_KPI, DTHU_GOI_KPI, LYDO_KHONGTINH_KPI)
--             select THANG_PTM, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM, MANV_GOC, TENNV_PTM, MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM, TIEN_DNHM, DTHU_DONGIA_DNHM, GIAMTRU_NGHIEPVU, TIEN_THULAO_DNHM, MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, HESO_HHBG, HESO_KK, TIEN_THULAO_GOI,  LYDO_KHONGTINH, GHI_CHU, 'VB344', MANV_PTM, MATO_PTM, MAPB_PTM, DTHU_DNHM_KPI, MANV_GOI, MATO_GOI, MAPB_GOI, DTHU_KPI, LYDO_KHONGTINH_KPI from one_line_202501
--             ;

 insert into ttkd_bsc.va_ct_bsc_ptm_vnptt(THANG_PTM, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM, MANV_GOC, TENNV_PTM, MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM, TIEN_DNHM, DTHU_DONGIA_DNHM, GIAMTRU_NGHIEPVU, TIEN_THULAO_DNHM, MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, HESO_HHBG, HESO_KK, TIEN_THULAO_GOI, LYDO_KHONGTINH_DONGIA,  GHI_CHU, VANBAN )
            select THANG_PTM, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM, MANV_GOC, TENNV_PTM, MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM, TIEN_DNHM, DTHU_DONGIA_DNHM, GIAMTRU_NGHIEPVU, TIEN_THULAO_DNHM, MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, HESO_HHBG, HESO_KK, TIEN_THULAO_GOI,  LYDO_KHONGTINH, GHI_CHU, 'VB344' from one_line_202501
            ;
MERGE INTO ttkd_bsc.va_ct_bsc_ptm_vnptt a
USING one_line_202501 b
ON (a.ma_tb = b.ma_tb AND a.thang_ptm = 202501)
WHEN MATCHED THEN
UPDATE SET
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
delete from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm = 202501;

            select * from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm = 202501 and ma_tb ='84813044568';;
select * from S_DONGIA_DTHU_HIENHUU_202501_test where
 ma_tb in (
select ma_tb from (
SELECT THANG, MA_TB, TEN_GOI,  USER_BAN_GOI, COUNT(*) AS SO_LUONG
FROM S_DONGIA_DTHU_HIENHUU_202501_test
GROUP BY THANG, MA_TB, TEN_GOI,  USER_BAN_GOI
HAVING COUNT(*) > 1
ORDER BY SO_LUONG DESC
)

)
;
select *
from dongia_Dthh where thang = 202501 and ma_pb ='VNP0700800';
select *
from TTKD_BSC.nhanvien where user_ccbs ='dtd_thaohn_hcm';

select * from one_line_202501 where ma_tb ='84813044568';

select * from dongia_dthh where thang = 202501 and nguon ='HVC_moi' and ma_tb in (

select '84' ||ma_tb ma1_tb from ob_hvc2_ct a where thang = 202501 and DTHU_TRUOCOB =0 and loai_gd ='Bán gói tập không gói'
);


select *
from manpn.manpn_goi_tonghop_202502 where ma_tb in (
84889910338,
84942473280,
84944137515,
84945826158,
84945131827,
84835799104,
84845556373,
84942669905,
84846740486


) ;
select *
from ttkd_bsc.va_ct_bsc_ptm_vnptt where MANV_GOI  ='CTV089064';--CTV086242 CTV080458
MI_YT50G_3M
;
select *
from ttkd_bsc.nhanvien where ma_nv ='CTV073772';

select *
from P01_202501
where SERVICE_CODE in ('TR80D','TR60D','TR50C');
group by TEN_PBH_DTCP;

select * from ONE_LINE_202501 where nguon like'%smrs%';
select *
from P01_202501 where ACCS_MTHD_KEY=84812137262;

 select * from hoahong_imp_cntt;
----

SELECT 'TSL0A1VNTVNT007' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID=9
	AND c.LOAITB_ID NOT IN (134,107,123,306)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (7,8,17,18,19,20,21,22,23,24,25,11)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL
SELECT 'TSL0A1VNTVNT008' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID=9
	AND c.LOAITB_ID NOT IN (134,107,123)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (1,2,3,4,5,16)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL
SELECT 'TSL0A1VNTVNT009' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID=9
	AND c.LOAITB_ID NOT IN (134,107,123)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (9)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL
SELECT 'TSL0A1VNTVNT021' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID=8
	AND c.LOAITB_ID NOT IN (134,107,123,306,259)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (7,8,17,18,19,20,21,22,23,24,25,11)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL
SELECT 'TSL0A1VNTVNT022' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID=7
	AND c.LOAITB_ID NOT IN (134,107,123,306,259)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (1,2,3,4,5,16)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL
SELECT 'TSL0A1VNTVNT023' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID=7
	AND c.LOAITB_ID NOT IN (134,107,123)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (7,8,17,18,19,20,21,22,23,24,25,11)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL
SELECT 'TSL0A1VNTVNT024' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID=7
	AND c.LOAITB_ID NOT IN (134,107,123)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (1,2,3,4,5,16)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL
SELECT 'TSL0A1VNTVNT025' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
JOIN TINHCUOC.dbtb SUBPARTITION FOR (21, 20241201) c ON c.thuebao_id = b.thuebao_id
left join css.chuquan t on t.chuquan_id=c.chuquan_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.DICHVUVT_ID IN (7,8,9)
	AND c.LOAITB_ID NOT IN (134,107,123,306,259)
	AND b.loaitb_id = c.loaitb_id
	AND c.loaikenh_id in (10)
        AND (t.ten_tat='TTKD-HNI')
	AND to_char(b.ngay_ht,'yyyymm')='202412'

UNION ALL

SELECT 'TSL0A1VNTVNT026' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.dichvuvt_id IN (4) and b.loaitb_id =305
	AND to_char(b.ngay_ht,'yyyymm')='202412'
    and EXISTS (SELECT 1 FROM tinhcuoc.dbtb SUBPARTITION FOR (21, 20241201) c left join css.chuquan t on t.chuquan_id=c.chuquan_id
                    WHERE c.thuebao_id = b.thuebao_id and (t.ten_tat='TTKD-HNI'))
UNION ALL

SELECT 'TSL0A1VNTVNT027' kpi_name,sum(tien)
FROM css.ct_tienhd PARTITION FOR (21) a
JOIN css.hd_thuebao PARTITION FOR (21) b ON a.hdtb_id = b.hdtb_id
WHERE a.khoanmuctt_id IN (1,2,3,4,6,7,8,9,13,14,17,18,23,32,33,46,49,51, 56,57,59,142,167,8804,15,19,28,50,143,144,1000,8801,8802,8803)
	AND b.dichvuvt_id IN (8) and b.loaitb_id =306
	AND to_char(b.ngay_ht,'yyyymm')='202412'
    and EXISTS (SELECT 1 FROM tinhcuoc.dbtb SUBPARTITION FOR (21, 20241201) c left join css.chuquan t on t.chuquan_id=c.chuquan_id
                    WHERE c.thuebao_id = b.thuebao_id and (t.ten_tat='TTKD-HNI'))
;
                select * from ttkd_bsc.ct_bsc_ptm where ma_tb ='dpquang_e91';
select /*+parallel(32)*/* from OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt where  ACCS_MTHD_KEY in (select ma_tb
                                                                         from one_line_202502
                                                                         where mapb_ptm = 'VNP0702100'
                                                                           and ten_goi in ('TR60D', 'TR80D'))
    and mo_key = 202502;

select *
from share_pbhhm where thang = 202502;


 select * from (
           select thang_ptm thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG,
             MANV_GOI ma_nv,b.ten_nv, MATO_GOI ma_to,b.ten_to, MAPB_GOI ma_pb,b.ten_pb,'mua_goi' tenkieu_ld,case when heso_kk =0.05 then 'Co' else null end as Khuyen_khich  ,TIEN_GOI,  TIEN_THULAO_GOI,
              LYDO_KHONGTINH_DONGIA,
              MANV_GOI_KPI manv_kpi, MATO_GOI_KPI mato_kpi, MAPB_GOI_KPI mapb_kpi, DTHU_GOI_KPI,DTHU_KPI_TO,DTHU_KPI_LDP, LYDO_KHONGTINH_KPI
         from ttkd_bsc.va_ct_bsc_ptm_vnptt  a
         join ttkd_bsc.nhanvien b on b.thang = a.thang_ptm and a.manv_goi = b.ma_nv
         where a.thang_ptm = 202502
            union all
         select 202502 thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM ma_nv, TENNV_PTM,
            MATO_PTM ma_to, TENTO_PTM, MAPB_PTM ma_pb, TENPB_PTM,'ptm' tenkieu_ld,''khuyen_khich, TIEN_DNHM, TIEN_THULAO_DNHM
            ,LYDO_KHONGTINH_DONGIA
--         MANV_GOI, MATO_GOI, MAPB_GOI, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
         , MANV_DNHM_KPI, MATO_DNHM_KPI, MAPB_DNHM_KPI, DTHU_DNHM_KPI,DTHU_KPI_TO,DTHU_KPI_LDP, LYDO_KHONGTINH_KPI
         from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm = 202502
         );

 -- #check bangluong_dongia HCM004899
select *
from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm = 202502 and ma_tb ='84911387475';

                   select 'bangluong' nguon,sum(luong_dongia_dnhm_vnptt+luong_dongia_goi_vnptt) luong_344--,sum(luong_dongia_nghiepvu_vnp) ho_tro_nghiep_vu,sum(luong_dongia_vnphh) luong_384
                        from ttkd_bsc.bangluong_dongia_202502
                   union select'vietanh',sum(TIEN_THULAO_DNHM+tien_thulao_goi) vnptt--,'',''
                               from  ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm=202502
                                                and (manv_ptm in
                                                     (select ma_nv from ttkd_bsc.bangluong_dongia_202502) or manv_goi in (select ma_nv from ttkd_bsc.bangluong_dongia_202502)
                           )
                   ;

  select ma_nv,sum(luong_dongia_dnhm_vnptt+luong_dongia_goi_vnptt) luong_344,sum(TIEN_THULAO_DNHM+tien_thulao_goi) vnptt--,sum(luong_dongia_nghiepvu_vnp) ho_tro_nghiep_vu,sum(luong_dongia_vnphh) luong_384
                        from ttkd_bsc.bangluong_dongia_202502 a

                        left join  ttkd_bsc.va_ct_bsc_ptm_vnptt  b on b.thang_ptm=202502 and b.manv_ptm = a.ma_nv
  group by ma_nv
                                                                          ;
                                                and (manv_ptm in
                                                     (select ma_nv from ttkd_bsc.bangluong_dongia_202502) or manv_goi in (select ma_nv from ttkd_bsc.bangluong_dongia_202502)
                           )
                                                    ;
--VNP020745
select LUONG_DONGIA_VNPHH
from ttkd_bsc.bangluong_dongia_202502 where ma_nv='VNP017395';
select*
   from ttkd_bsc.bangluong_dongia_202502 a
   left join ttkd_bsc.tonghop_ct_dongia_ptm b on a.ma_nv =b.ma_nv
where a.ma_nv='VNP020745'
group by a.ma_nv;


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
select a.manv_ptm,sum(tien) vietanh,sum(tien_b),sum(tien) - sum(tien_b)
from ( select manv_ptm,sum(tien) tien from bang1 group by manv_ptm
            ) a
right join ( select ma_nv,sum(nvl(LUONG_DONGIA_GOI_VNPTT,0)+nvl(LUONG_DONGIA_DNHM_VNPTT,0)) tien_b
             from ttkd_bsc.tonghop_ct_dongia_ptm where thang = 202502 group by ma_nv) b
on a.manv_ptm=b.ma_nv
        group by a.manv_ptm
order by sum(tien) - sum(tien_b) desc;

--dongia 384
        with orgn as ( select ma_nv,ten_pb,sum(TIEN_THULAO) tien_thulao from ttkd_bsc.va_ct_bsc_vnphh where thang = 202502
                    group by ma_nv,ten_pb )

select a.ma_nv,a.tien_thulao,b.LUONG_DONGIA_VNPHH
        ,a.tien_thulao- b.LUONG_DONGIA_VNPHH CL
from orgn a
right join ttkd_bsc.bangluong_dongia_202502 b
    on a.ma_nv =b.ma_Nv
order by a.tien_thulao - b.LUONG_DONGIA_VNPHH asc;
select * from ttkd_bsc.tonghop_ct_dongia_ptm where thang = 202502 and ma_tb ='84911387475' and loaitb_id = 21;

select *
from  one_line_202502 where ma_tb in('84918906090');
