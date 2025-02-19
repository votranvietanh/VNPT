merge into vietanhvh.one_line_202501 t1
using (
    SELECT a.ma_tb, b.DOANHTHU_KPI_NVPTM from vietanhvh.one_line_202501 a
        left join (select * from manpn.manpn_goi_tonghop_202501 where loai_tb = 'ptm' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
    ) t2
on (t1.ma_tb = t2.MA_TB)
when matched then update set T1.DTHU_DNHM_KPI = DOANHTHU_KPI_NVPTM;

merge into vietanhvh.one_line_202501 t1
using (
    SELECT a.ma_tb, b.DOANHTHU_KPI_NVPTM from vietanhvh.one_line_202501 a
        left join (select * from manpn.manpn_goi_tonghop_202501 where loai_tb = 'ptm_goi' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
    ) t2
on (t1.ma_tb = t2.ma_tb)
when matched then update set T1.DTHU_KPI = DOANHTHU_KPI_NVPTM;

merge into vietanhvh.one_line_202501 t1
using (
    select LISTAGG(LYDO_KHONGGHIBSC, ' - ptm; ') WITHIN GROUP (ORDER BY loai_tb)  AS LYDO_KHONGGHIBSC, ma_tb
    from manpn.manpn_goi_tonghop_202501 where LYDO_KHONGGHIBSC is not null
    group by ma_tb
    ) t2
on (t1.ma_tb = t2.ma_tb)
when matched then update set T1.LYDO_KHONGTINH_KPI = LYDO_KHONGGHIBSC;

--UPDATE bảng view doanh thu
merge into ttkd_bsc.va_ct_bsc_ptm_vnptt t1
using (
    SELECT a.ma_tb, b.DOANHTHU_KPI_NVPTM, B.MANV_PTM, B.MA_TO_PTM, B.MAPB_PTM from ttkd_bsc.va_ct_bsc_ptm_vnptt a
        left join (select * from manpn.manpn_goi_tonghop_202501 where loai_tb = 'ptm' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
        WHERE THANG_PTM = 202501 --AND B.ma_tb ='84814633080'
    ) t2
on (t1.ma_tb = t2.MA_TB AND THANG_PTM = 202501)
when matched then update set T1.DTHU_DNHM_KPI = t2.DOANHTHU_KPI_NVPTM, T1.MANV_DNHM_KPI = t2.MANV_PTM, T1.MATO_DNHM_KPI = t2.MA_TO_PTM , T1.MAPB_DNHM_KPI = t2.MAPB_PTM;

merge into ttkd_bsc.va_ct_bsc_ptm_vnptt t1
using (
    SELECT a.ma_tb, b.DOANHTHU_KPI_NVPTM, B.MANV_PTM, B.MA_TO_PTM, B.MAPB_PTM from ttkd_bsc.va_ct_bsc_ptm_vnptt a
        left join (select * from manpn.manpn_goi_tonghop_202501 where loai_tb = 'ptm_goi' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
        WHERE THANG_PTM = 202501
    ) t2
on (t1.ma_tb = t2.ma_tb and THANG_PTM = 202501)
when matched then update set T1.DTHU_GOI_KPI = t2.DOANHTHU_KPI_NVPTM, T1.MANV_GOI_KPI = t2.MANV_PTM, T1.MATO_GOI_KPI = t2.MA_TO_PTM, T1.MAPB_GOI_KPI = t2.MAPB_PTM ;

merge into ttkd_bsc.va_ct_bsc_ptm_vnptt t1
using (
    select LISTAGG(LYDO_KHONGGHIBSC, ' - ptm; ') WITHIN GROUP (ORDER BY loai_tb)  AS LYDO_KHONGGHIBSC, ma_tb
    from manpn.manpn_goi_tonghop_202501 where LYDO_KHONGGHIBSC is not null
    group by ma_tb
    ) t2
on (t1.ma_tb = t2.ma_tb AND THANG_PTM = 202501)
when matched then update set T1.LYDO_KHONGTINH_KPI = t2.LYDO_KHONGGHIBSC;

select *
from ttkd_bsc.va_ct_bsc_ptm_vnptt where ma_tb in('84849613789');
select *
from manpn.manpn_goi_tonghop_202501 where ma_tb ='84912153953';
and  thang_ptm  = 202501;;


--
select distinct manvgoi_goc
from one_line_202501 where thang_ptm = 202501 and HESO_KK = 0.05 and mapb_goi not in ('VNP0701600','VNP0701200')
and manvgoi_goc not in (   SELECT ma_nv
            FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
            WHERE thang = 202501
--               and dinhmuc_2 IN (32000000, 30000000)
              AND ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_15.1')
              AND KQTH >= dinhmuc_2
              AND KHDK >= dinhmuc_2 );

select *
from ttkd_bsc.va_ct_bsc_ptm_vnptt where thang_ptm =202501 and manv_goi ='VNP017693';
update  one_line_202501
set manvgoi_goc =manv_goi;
update
