---CHECK XEM CÓ ĐIỀN THỪA HOẶC THIẾU TRONG DMKPI?
      select ma_kpi,sum(THUCHIEN+ TYLE_THUCHIEN+MUCDO_HOANTHANH) summ  from  ttkd_bsc.blkpi_danhmuc_kpi 
      where thang = 202408 
            AND 
                  ((THUCHIEN+ TYLE_THUCHIEN+MUCDO_HOANTHANH) > 1) -- THỪA               
      group by ma_kpi;

select *  from  ttkd_bsc.blkpi_danhmuc_kpi where thang = 202408 ;
select * from ttkd_bsc.bangluong_kpi where thang = 202408 and ma_kpi ='HCM_TB_MCUOC_001';

select * from ttkd_bsc.bangluong_kpi where thang = 202408 and ma_kpi ='HCM_DT_PTMOI_021' and ma_nv = 'VNP017014'
