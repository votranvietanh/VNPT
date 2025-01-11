select * from ttkd_bsc.bangluong_kpi x where thang = 202411 and ma_kpi like '%_060' and ma_vtcv in ('VNP-HNHCM_BHKV_15','VNP-HNHCM_BHKV_17')
and exists (select 1 from ttkd_bsc.nhanvien a where thang = 202411 and tinh_bsc = 0 and x.ma_nv =a.ma_nv);
--update bang luogn hang thang, ko update pdg
update ttkd_bsc.bangluong_kpi x
set TYTRONG= 30, CHITIEU_GIAO = 50
where thang = 202412 and ma_kpi like '%_060' and ma_vtcv in ('VNP-HNHCM_BHKV_15','VNP-HNHCM_BHKV_17')
and exists (select 1 from ttkd_bsc.nhanvien a where thang = 202412 and tinh_bsc = 1 and x.ma_nv =a.ma_nv);

--update 008
update ttkd_bsc.bangluong_kpi x
set TYTRONG= 40, chitieu_giao = null ,GIAO = null
where thang = 202412 and ma_kpi like '%HCM_DT_VNPTT_008' and ma_vtcv ='VNP-HNHCM_KDOL_2'
and exists (select 1 from ttkd_bsc.nhanvien a where thang = 202412 and tinh_bsc = 1 and x.ma_nv =a.ma_nv);
--
    update ttkd_bsc.bangluong_kpi x
set TYTRONG= 50, chitieu_giao = null ,GIAO = 7500
where thang = 202412 and ma_kpi like '%HCM_DT_VNPTT_008' and ma_vtcv ='VNP-HNHCM_KDOL_17.1'
and exists (select 1 from ttkd_bsc.nhanvien a where thang = 202412 and tinh_bsc = 1 and x.ma_nv =a.ma_nv);

--update 009
update ttkd_bsc.bangluong_kpi x
set TYTRONG= 50,chitieu_giao = null ,GIAO = 270
where thang = 202412 and ma_kpi like '%HCM_DT_VNPTT_009'
and exists (select 1 from ttkd_bsc.nhanvien a where thang = 202412 and tinh_bsc = 1 and x.ma_nv =a.ma_nv);

--update 010 BHOL
update ttkd_bsc.bangluong_kpi x
set TYTRONG= 20, chitieu_giao = null ,GIAO = 1.5
where thang = 202412 and ma_kpi like '%HCM_DT_VNPTT_010'
and exists (select 1 from ttkd_bsc.nhanvien a where thang = 202412 and tinh_bsc = 1 and x.ma_nv =a.ma_nv);

--update tu bang tong hop KPI _060
    update ttkd_bsc.bangluong_kpi x
    set (giao,thuchien,TYLE_THUCHIEN) = (select a.GIAO, a.THUCHIEN,a.tyle from bsc_tonghop  a where a.ma_kpi ='HCM_DT_PTMOI_060' and a.MA_NV =x.ma_nv and a.ma_to=x.ma_to and a.thang = x.thang)
    where x.thang = 202412 and x.ma_kpi like '%_060' and x.ma_vtcv in ('VNP-HNHCM_BHKV_15','VNP-HNHCM_BHKV_17')
    and exists (select 1 from ttkd_bsc.nhanvien a where a.thang = 202412 and a.tinh_bsc = 1 and x.ma_nv =a.ma_nv);


select *  from ttkd_bsc.bangluong_kpi where thang = 202411 and ma_kpi like '%_060' and ma_vtcv = 'VNP-HNHCM_BHKV_2'
and ma_nv  in (
        (select MA_NV from ttkd_Bsc.blkpi_dm_to_pgd x
        where thang = 202411
            and x.ma_kpi =  'HCM_DT_PTMOI_060'
            and x.ma_to in (select distinct ma_to from ttkd_bsc.dm_to where ten_to ='Tổ Kinh Doanh Di Động Trả Trước' and hieuluc = 1)
            )
    )
;
select *
from TTKD_BSC.nhanvien
where ma_nv ='CTV075723';
select * from bosung_t11;
delete from BSC_TONGHOP where ma_kpi like '%_060';
insert into BSC_TONGHOP(THANG,  MA_NV,MA_KPI, MA_VTCV, MA_TO, MA_PB,GIAO, THUCHIEN,  TYLE,LOAI_KPI)
with rawdata as (
    select thang,manv_ptm,'HCM_DT_PTMOI_060' ma_kpi ,ma_vtcv, ma_to, ma_pb, count(ma_tb) as SL_giao,COUNT(CASE WHEN dthu_thuc_hien > 0 THEN ma_tb END) SL_TB,
    round((COUNT(CASE WHEN dthu_thuc_hien > 0 THEN ma_tb END)/count(ma_tb))*100,2) tyle
   from va_ct_BSC_DTHU_DTRI_NAM
    where thang = 202411
        and ma_tb not in (select ma_tb from ds_loaitru_T10)
          and ma_vtcv in ('VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_15','VNP-HNHCM_BHKV_2')
    group by manv_ptm, ma_vtcv, ma_to, ma_pb,thang
)

select a.*, 'KPI_NV' as loai_kpi 
from rawdata a
where ma_vtcv = 'VNP-HNHCM_BHKV_15'

union all

select thang,b.MA_NV,'HCM_DT_PTMOI_060' ma_kpi, 'VNP-HNHCM_BHKV_17' as ma_vtcv, a.MA_TO, b.MA_PB,a.sl_giao, a.SL_TB,round((a.SL_TB/a.sl_giao)*100,2) tyle, 'KPI_TO' as loai_kpi
from (
        select MA_TO,sum(SL_giao)SL_GIAO, sum(SL_TB) as SL_TB
        from rawdata
        group by MA_TO
     ) a
left join ttkd_bsc.nhanvien b 
on a.ma_to = b.ma_to 
and b.thang = 202411 and b.ma_vtcv ='VNP-HNHCM_BHKV_17'
union all
        select thang,b.MA_NV,'HCM_DT_PTMOI_060', 'VNP-HNHCM_BHKV_2' as ma_vtcv,null, b.MA_PB,a.sl_giao, a.SL_TB,round((a.SL_TB/a.sl_giao)*100,2) tyle, 'KPI_PB' as loai_kpi
    from (
            select MA_pb,sum(SL_giao)SL_GIAO, sum(SL_TB) as SL_TB
            from rawdata
            group by MA_pb
         ) a
    left join 
            (select * from ttkd_Bsc.blkpi_dm_to_pgd x where thang = 202411 and x.ma_kpi =  'HCM_DT_PTMOI_060'
            and x.ma_to in (select distinct ma_to from rawdata)
        )
    b 
    on a.MA_pb = b.MA_pb 
    and b.ma_vtcv ='VNP-HNHCM_BHKV_2'
;


-- xoa nhung manv nay -
select *  from ttkd_bsc.bangluong_kpi where thang = 202411 and ma_kpi like '%_060' and ma_vtcv = 'VNP-HNHCM_BHKV_2'
and ma_nv not in (
        (select MA_NV from ttkd_Bsc.blkpi_dm_to_pgd x
        where thang = 202410
            and x.dichvu  in  ('VNP tra truoc','VNP tra sau')
            and x.ma_to in (select distinct ma_to from ttkd_bsc.dm_to where ten_to ='Tổ Kinh Doanh Di Động Trả Trước' and hieuluc = 1)
            )
    )
;
select *  from ttkd_bsc.bangluong_kpi where thang = 202410 and ma_kpi like '%_060'