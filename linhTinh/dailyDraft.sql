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