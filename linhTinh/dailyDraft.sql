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

















