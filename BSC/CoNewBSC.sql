-- sua 2 sheet vtcv
-- update 1/0  ttkd_bsc.blkpi_danhmuc_kpi

select *
from  ttkd_bsc.blkpi_danhmuc_kpi where thang = 202501 and manv_lead like '%CTV085863';

select *
from  ttkd_bsc.blkpi_danhmuc_kpi where thang = 202502 and MANV_LEAD like 'CTV085863';
--test
        select *
        from ttkd_bsc.bangluong_kpi where thang = 202501 and ma_kpi ='HCM_DT_VNPTT_012';

--xoa nv thua`
            delete from ttkd_bsc.bangluong_kpi
            where thang = 202502 and ma_kpi = 'HCM_DT_VNPTT_012' and ma_vtcv in ('VNP-HNHCM_KDOL_2') AND MA_NV NOT IN (
            select MA_NV from ttkd_bsc.blkpi_dm_to_pgd where thang = 202502 and ma_kpi = 'HCM_DT_VNPTT_012');

            delete from ttkd_bsc.bangluong_kpi
            where thang = 202502 and ma_kpi = 'HCM_DT_PTMOI_060' and ma_vtcv in ('VNP-HNHCM_BHKV_2','VNP-HNHCM_BHKV_1','VNP-HNHCM_BHKV_2.1') AND MA_NV NOT IN (
            select MA_NV from ttkd_bsc.blkpi_dm_to_pgd where thang = 202502 and ma_kpi = 'HCM_DT_PTMOI_060');

            select * from ttkd_bsc.bangluong_kpi
            where thang = 202502 and ma_kpi = 'HCM_DT_VNPTT_012' and ma_vtcv in ('VNP-HNHCM_KDOL_2') AND MA_NV NOT IN (
            select MA_NV from ttkd_bsc.blkpi_dm_to_pgd where thang = 202502 and ma_kpi = 'HCM_DT_VNPTT_012');

