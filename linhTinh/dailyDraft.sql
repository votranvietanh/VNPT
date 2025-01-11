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
select *
from manpn.BSCC_INSERT_DM_KIT_BUNDLE;

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
select * from manpn.bscc_import_goi_bris_p04 where accs_mthd_key ='84913581132';

select* from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY
where goi_cuoc in ('VIP199',
'R3')
;
, case when LOAI_GD in('Gia hạn CKD','Gia hạn CKN') then 'GIAHAN'
                                                when LOAI_GD='Bán gói tập không gói' then 'DANGKY'end
;
select TENNV_PTM,count(ma_tb) from one_line_202412 where ma_tb in (select ma_tb from x_nv_hotro)
group by TENNV_PTM
;
select *
from DONGIA_DTHH where thang = 202412 and ma_tb in ('84914632325');

select * from dongia_dthh where thang = 202412 and TIEN_THULAO >0  and DTHU_KPI =0 and  ma_tb in (
select ma_tb
            from vietanhvh.S_DONGIA_DTHU_HIENHUU_202412_test where ma_vtcv in ('VNP-HNHCM_KDOL_17','VNP-HNHCM_BHKV_52','VNP-HNHCM_BHKV_53')
            )



