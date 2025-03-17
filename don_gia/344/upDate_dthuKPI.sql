merge into ttkd_bsc.va_ct_bsc_ptm_vnptt t1
using (
    SELECT a.ma_tb, round(b.DOANHTHU_KPI_NVPTM*HESO_KPI) DOANHTHU_KPI_NVPTM, B.MANV_PTM, B.MA_TO_PTM, B.MAPB_PTM from ttkd_bsc.va_ct_bsc_ptm_vnptt a
        left join (select * from manpn.manpn_goi_tonghop_202501 where loai_tb = 'ptm' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
        WHERE THANG_PTM = 202501 --AND B.ma_tb ='84814633080'
    ) t2
on (t1.ma_tb = t2.MA_TB AND THANG_PTM = 202501)
when matched then update set T1.DTHU_DNHM_KPI = t2.DOANHTHU_KPI_NVPTM, T1.MANV_DNHM_KPI = t2.MANV_PTM, T1.MATO_DNHM_KPI = t2.MA_TO_PTM , T1.MAPB_DNHM_KPI = t2.MAPB_PTM;

merge into ttkd_bsc.va_ct_bsc_ptm_vnptt t1
using (
    SELECT a.ma_tb, round(b.DOANHTHU_KPI_NVPTM*HESO_KPI) DOANHTHU_KPI_NVPTM, B.MANV_PTM, B.MA_TO_PTM, B.MAPB_PTM from ttkd_bsc.va_ct_bsc_ptm_vnptt a
        left join (select * from manpn.manpn_goi_tonghop_202501 where loai_tb = 'ptm_goi' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
        WHERE THANG_PTM = 202501
    ) t2
on (t1.ma_tb = t2.ma_tb and THANG_PTM = 202501)
when matched then update set T1.DTHU_GOI_KPI = t2.DOANHTHU_KPI_NVPTM, T1.MANV_GOI_KPI = t2.MANV_PTM, T1.MATO_GOI_KPI = t2.MA_TO_PTM, T1.MAPB_GOI_KPI = t2.MAPB_PTM ;

merge into ttkd_bsc.va_ct_bsc_ptm_vnptt t1
using (
    SELECT a.ma_tb, round(sum(b.DOANHTHU_KPI_NVPTM*HESO_KPI_TT)) KPI_TO, round(sum(b.DOANHTHU_KPI_NVPTM)) KPI_LDP from ttkd_bsc.va_ct_bsc_ptm_vnptt a
        left join (select * from manpn.manpn_goi_tonghop_202501 where thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
        WHERE THANG_PTM = 202501
        group by a.ma_tb
    ) t2
on (t1.ma_tb = t2.ma_tb and THANG_PTM = 202501)
when matched then update set T1.DTHU_KPI_TO = t2.KPI_TO, T1.DTHU_KPI_LDP = t2.KPI_LDP;

merge into ttkd_bsc.va_ct_bsc_ptm_vnptt t1
using (
    select LISTAGG(LYDO_KHONGGHIBSC, ' - ptm; ') WITHIN GROUP (ORDER BY loai_tb)  AS LYDO_KHONGGHIBSC, ma_tb
    from manpn.manpn_goi_tonghop_202501 where LYDO_KHONGGHIBSC is not null
    group by ma_tb
    ) t2
on (t1.ma_tb = t2.ma_tb AND THANG_PTM = 202501)
when matched then update set T1.LYDO_KHONGTINH_KPI = t2.LYDO_KHONGGHIBSC;


select sum(DOANHTHU_KPI_NVPTM) from manpn_goi_tonghop_202501 ;
select sum(DTHU_DNHM_KPI) + sum(DTHU_GOI_KPI) from ttkd_bsc.va_ct_bsc_ptm_vnptt
where thang_ptm = 202501;

