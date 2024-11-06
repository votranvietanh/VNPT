with rawdata as ( 
    select manv_ptm, ma_vtcv, ma_to, ma_pb, count(ma_tb) as SL_TB 
    from VA_ct_BSC_DTHU_DTRI_NAM 
    where thang = 202410
          and ma_vtcv in ('VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_15','VNP-HNHCM_BHKV_2')
    group by manv_ptm, ma_vtcv, ma_to, ma_pb
)

select a.*, 'KPI_NV' as loai_kpi 
from rawdata a
where ma_vtcv = 'VNP-HNHCM_BHKV_15'

union all

select b.MA_NV, 'VNP-HNHCM_BHKV_17' as ma_vtcv, a.MA_TO, b.MA_PB, a.SL_TB, 'KPI_TO' as loai_kpi 
from (
        select MA_TO, sum(SL_TB) as SL_TB
        from rawdata
        group by MA_TO
     ) a
left join ttkd_bsc.nhanvien b 
on a.ma_to = b.ma_to 
and b.thang = 202410 and b.ma_vtcv ='VNP-HNHCM_BHKV_17'
union all
        select b.MA_NV, 'VNP-HNHCM_BHKV_2' as ma_vtcv,null, b.MA_PB, a.SL_TB, 'KPI_PB' as loai_kpi 
    from (
            select MA_pb, sum(SL_TB) as SL_TB
            from rawdata
            group by MA_pb
         ) a
    left join 
            (select * from ttkd_Bsc.blkpi_dm_to_pgd x where thang = 202410 and x.dichvu  in  ('VNP tra truoc','VNP tra sau') 
            and x.ma_to in (select distinct ma_to from rawdata)
        )
    b 
    on a.MA_pb = b.MA_pb 
    and b.ma_vtcv ='VNP-HNHCM_BHKV_2'
;
