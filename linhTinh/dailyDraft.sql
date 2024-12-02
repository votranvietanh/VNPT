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

