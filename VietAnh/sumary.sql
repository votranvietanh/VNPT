select ma_kpi,nguoi_xuly, nvl(GIAO,0)+nvl(THUCHIEN,0)+nvl(TYLE_TH,0)+nvl(MUCDO_HT,0)+nvl(DIEMCONG,0)+nvl(DIEMTRU,0) checkk from  ttkd_bsc.blkpi_danhmuc_kpi where thang = 202408 
order by nvl(GIAO,0)+nvl(THUCHIEN,0)+nvl(TYLE_TH,0)+nvl(MUCDO_HT,0)+nvl(DIEMCONG,0)+nvl(DIEMTRU,0);
