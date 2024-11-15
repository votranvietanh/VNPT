merge into vietanhvh.one_line_202410 t1
using (
    SELECT a.ma_tb, b.DOANHTHU_KPI_NVPTM from vietanhvh.one_line_202410 a
        left join (select * from manpn.manpn_goi_tonghop_202410 where loai_tb = 'ptm' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
    ) t2
on (t1.ma_tb = t2.MA_TB)
when matched then update set T1.DTHU_DNHM_KPI = DOANHTHU_KPI_NVPTM;

merge into vietanhvh.one_line_202410 t1
using (
    SELECT a.ma_tb, b.DOANHTHU_KPI_NVPTM from vietanhvh.one_line_202410 a
        left join (select * from manpn.manpn_goi_tonghop_202410 where loai_tb = 'ptm_goi' and thoadk_bsc = 1) b on a.ma_tb = b.ma_tb
    ) t2
on (t1.ma_tb = t2.ma_tb)
when matched then update set T1.DTHU_KPI = DOANHTHU_KPI_NVPTM;

merge into vietanhvh.one_line_202410 t1
using (
    select LISTAGG(LYDO_KHONGGHIBSC, ' - ptm; ') WITHIN GROUP (ORDER BY loai_tb)  AS LYDO_KHONGGHIBSC, ma_tb
    from manpn.manpn_goi_tonghop_202410 where LYDO_KHONGGHIBSC is not null
    group by ma_tb
    ) t2
on (t1.ma_tb = t2.ma_tb)
when matched then update set T1.LYDO_KHONGTINH_KPI = LYDO_KHONGGHIBSC;