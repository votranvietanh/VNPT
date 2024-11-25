select thang_ptm,manv_ptm,a.* from khkt_bc_hoahong_2  a
       where thang_ptm in( 202406,202405,202407,202408) and dichvuvt_id in (14,15,16)
                and ma_tb in (select ma_tb from abc)
                and  EXISTS  (
                select 1
                from ttkd_bsc.dm_daily_khdn  b
                where b.thang in( 202406,202405,202407,202408)
                    and b.ma_daily = a.manv_ptm);
--DATCOC_CSD/ DTHU_GOI_GOC / DTHU_GOI /
;
bang test : khkt_bc_hoahong_2 22/11/2024
;
select *
from TTKD_BSC.dm_nhomld;
select count(*)
from khkt_bc_hoahong_2; CTY TNHH HG INNOVATIVE SOLUTIONS
                        ;
select *  from ttkd_bsc.dm_daily_khdn ;
select *
from css_hcm.dichvu_vt;