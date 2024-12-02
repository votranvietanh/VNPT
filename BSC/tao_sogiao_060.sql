with rawdata as ( 
    select manv_ptm, ma_vtcv, ma_to, ma_pb, count(ma_tb) as SL_giao,COUNT(CASE WHEN dthu_thuc_hien > 0 THEN ma_tb END) SL_TB,
    round((COUNT(CASE WHEN dthu_thuc_hien > 0 THEN ma_tb END)/count(ma_tb))*100,2) tyle
   from T10_ct_BSC_DTHU_DTRI_NAM
    where thang = 202410
        and ma_tb not in (select ma_tb from ds_loaitru_T10)
          and ma_vtcv in ('VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_15','VNP-HNHCM_BHKV_2')
    group by manv_ptm, ma_vtcv, ma_to, ma_pb
)

select a.*, 'KPI_NV' as loai_kpi 
from rawdata a
where ma_vtcv = 'VNP-HNHCM_BHKV_15'

union all

select b.MA_NV, 'VNP-HNHCM_BHKV_17' as ma_vtcv, a.MA_TO, b.MA_PB,a.sl_giao, a.SL_TB,round((a.SL_TB/a.sl_giao)*100,2) tyle, 'KPI_TO' as loai_kpi 
from (
        select MA_TO,sum(SL_giao)SL_GIAO, sum(SL_TB) as SL_TB
        from rawdata
        group by MA_TO
     ) a
left join ttkd_bsc.nhanvien b 
on a.ma_to = b.ma_to 
and b.thang = 202410 and b.ma_vtcv ='VNP-HNHCM_BHKV_17'
union all
        select b.MA_NV, 'VNP-HNHCM_BHKV_2' as ma_vtcv,null, b.MA_PB,a.sl_giao, a.SL_TB,round((a.SL_TB/a.sl_giao)*100,2) tyle, 'KPI_PB' as loai_kpi 
    from (
            select MA_pb,sum(SL_giao)SL_GIAO, sum(SL_TB) as SL_TB
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


-- xoa nhung manv nay -
select *  from ttkd_bsc.bangluong_kpi where thang = 202411 and ma_kpi like '%_060' and ma_vtcv = 'VNP-HNHCM_BHKV_2'
and ma_nv not in (
        (select MA_NV from ttkd_Bsc.blkpi_dm_to_pgd x
        where thang = 202410
            and x.dichvu  in  ('VNP tra truoc','VNP tra sau')
            and x.ma_to in (select distinct ma_to from ttkd_bsc.dm_to where ten_to ='Tổ Kinh Doanh Di Động Trả Trước' and hieuluc = 1)
            )
    )