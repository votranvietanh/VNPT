- HCM_DT_VNPTT_008 - Tổng doanh thu bán hàng trên tập thuê bao di động hiện hữu
- GIAO(6400 trieudong),KQTH: KTNV công bố
- Công thức: Tổng Doanh thu  bán hàng trên tập thuê bao  di động hiện hữu (gia hạn CKD, CKN, bán gói, nâng gói, nâng chu kỳ) (ALL) / doanh thu giao trong tháng
- Số giao: 6,400 triệu đồng
- Số thực hiện = TỔNG SỐ THỰC HIỆN CỦA CÁC NHÂN VIÊN TRONG TO?
- Điều kiện ghi nhận: áp dụng theo quy định hiện hành
select *
from (
select THANG,  MA_TB,  TRANGTHAI,  TEN_GOI,  LOAI_GD,  LOAIHINH_TB,  USER_BAN_GOI,  MA_NV,  TEN_NV,  MA_VTCV,  MA_TO,  TEN_TO,  MA_PB,  TEN_PB,  CONG_CU_BAN_GOI,  DTHU_TLDG
from vietanhvh.dongia_DTHH
where trangthai = 'Hiện Hữu'
    and ma_to ='VNP0703004'
and thang = 202412)
 -- and MA_VTCV = 'VNP-HNHCM_KDOL_3.1' ) -- THANG12: SE THAY DOI VTCV HNHCM_KDOL_17.1
;

--thang 10: to = VNP0703004 thuchien = 7787380481, neu giao nhu thang 11 la 12%

select * from ttkd_bsc. bangluong_kpi where  thang = 202501 and ma_kpi ='HCM_DT_VNPTT_012';
  --012
            select * from S_DONGIA_DTHU_HIENHUU_202501_test where loai_gd ='GIAHAN'  and ma_to ='VNP0703004' and nguon ='BRIS_P04';
drop table BSC_012;
   create table BSC_012 as
    with dt as (
            select * from dongia_dthh where thang =202501 and
                nguon in ('CKN_CKD','HVC_moi')  and ma_to ='VNP0703004'
                    union all
         select * from dongia_dthh where thang =202501 and loai_gd ='GIAHAN'  and ma_to ='VNP0703004' and nguon ='BRIS_P04'
    )
        select THANG, MA_TB, TEN_GOI, DTHU_GOI,  LOAI_GD, USER_BAN_GOI, MA_nv, TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, NGUON
            from dt
            ;
            select sum(DTHU_TLDG) from (
           select * from (select THANG, MA_TB, TEN_GOI, DTHU_GOI,  LOAI_GD, USER_BAN_GOI, MA_nv, TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, NGUON,round(DTHU_GOI/1.1) dthu_tldg
                            from vietanhvh.BSC_012
                            where thang = 202501
                              and ma_to ='VNP0703004'))
                              ;
        update ttkd_bsc.bangluong_kpi
        set THUCHIEN = (select sum(round(DTHU_GOI/1.1))/1000000 from   vietanhvh.BSC_012
                            where thang = 202501
                              and ma_to ='VNP0703004')
        where thang = 202501 and ma_kpi ='HCM_DT_VNPTT_012';
        update ttkd_bsc.bangluong_kpi
                set TYLE_THUCHIEN = case when round(thuchien/giao)*100 > 120 then 120
                    else round(thuchien/giao)*100 end
                where thang = 202501 and ma_kpi ='HCM_DT_VNPTT_012';
                              select * from ttkd_bsc.bangluong_kpi where thang = 202501 and ma_kpi like '%012%';
delete
from bsc_tonghop
where ma_kpi ='HCM_DT_VNPTT_008' and thang = 202412;
insert into bsc_tonghop
select thang,'KPI_TO 'loai_kpi ,'HCM_DT_VNPTT_012' ma_kpi,'', 'CTV072956'ma_nv,'VNP-HNHCM_KDOL_17.1'MA_VTCV,ma_to ma_to,'VNP0703000' ma_pb,1,21,60,'' chitieu_giao,7500 giao,round(sum(DTHU_TLDG/1.1)/1000000,0) KQTH
,
    CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2)
    END as TLTH
,CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2)
    END as MDHT,'',''
from (
select THANG, MA_TO, DTHU_TLDG
from vietanhvh.dongia_DTHH
where
    trangthai = 'Hiện Hữu'
    and ma_to ='VNP0703004'
and thang = 202412) -- and ma_vtcv in ('VNP-HNHCM_KDOL_17.1','VNP-HNHCM_KDOL_2')
group by thang,ma_to;
--chi Tuyet
insert into bsc_tonghop
select thang,'KPI_PB 'loai_kpi ,'HCM_DT_VNPTT_008' ma_kpi,'', 'VNP017740'ma_nv,'VNP-HNHCM_KDOL_2'MA_VTCV,'VNP0703050' ma_to,'VNP0703000' ma_pb,1,21,60,'' chitieu_giao,7500 giao,round(sum(DTHU_TLDG/1.1)/1000000,0) KQTH
,
    CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2)
    END as TLTH
,CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 7500) * 100, 2)
    END as MDHT,'',''
from (
select THANG,  DTHU_TLDG
from vietanhvh.dongia_DTHH
where
    trangthai = 'Hiện Hữu'
    and ma_to in ('VNP0703004','VNP0703020')
and thang = 202412) -- and ma_vtcv in ('VNP-HNHCM_KDOL_17.1','VNP-HNHCM_KDOL_2')
group by thang;



select *
from TTKD_BSC.bangluong_kpi
where thang = 202412
    and ma_kpi like '%HCM_DT_VNPTT_009';



----HCM_DT_VNPTT_009
Công thức: Tổng Doanh thu bán gói trên tập TB di động hiện hữu / doanh thu giao trong tháng
Số giao: 1,5 triệu đồng
Điều kiện ghi nhận: áp dụng theo quy định hiện hành
KTNV công bố: GIAO,KQTH (dvi trieu dong)
;
select sum(DTHU_TLDG) from (select THANG, MA_TB, TRANGTHAI, TEN_GOI, LOAI_GD, LOAIHINH_TB, USER_BAN_GOI, MA_NV, TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, CONG_CU_BAN_GOI, DTHU_TLDG
                            from vietanhvh.dongia_DTHH
                            where trangthai = 'Hiện Hữu'
                              and MA_VTCV in ('VNP-HNHCM_KDOL_3')
                              and loai_gd in ('GIAHAN', 'NANG_GOI', 'NANG_CHUKY')
                              and thang = 202501)
;
delete
from bsc_tonghop
where ma_kpi ='HCM_DT_VNPTT_009' and thang = 202501;
select * from bsc_tonghop
where ma_kpi ='HCM_DT_VNPTT_009';
insert into bsc_tonghop
select thang,'KPI_NV 'loai_kpi ,'HCM_DT_VNPTT_009' ma_kpi,'',ma_nv, MA_VTCV, ma_to,ma_pb,(select x.tinh_bsc from ttkd_bsc.nhanvien x where x.thang =a.thang and a.ma_nv = x.ma_nv ) tinh_bsc,21,50,'' chitieu_giao,270 giao,round(sum(DTHU_TLDG/1.1)/1000000,0) KQTH
,
    CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 270) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 270) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 270) * 100, 2)
    END as TLTH
,CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 270) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 270) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 0) / 270) * 100, 2)
    END as MDHT,'',''
from (
                       select THANG, MA_TB, TRANGTHAI, TEN_GOI, LOAI_GD, LOAIHINH_TB, USER_BAN_GOI, MA_NV, TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, CONG_CU_BAN_GOI, DTHU_TLDG
                            from vietanhvh.dongia_DTHH
                            where
                                 thang = 202501
                                and trangthai = 'Hiện Hữu'
                              and MA_VTCV in ('VNP-HNHCM_KDOL_3')
                              and loai_gd in ('GIAHAN', 'NANG_GOI', 'NANG_CHUKY')
                              and thang = 202501) a
group by thang,MA_NV, MA_VTCV, ma_to,ma_pb;
select distinct LOAI_GD
from vietanhvh.dongia_DTHH;
select * from (select THANG,MA_TB, TRANGTHAI, TEN_GOI, LOAI_GD, LOAIHINH_TB, USER_BAN_GOI, MA_NV, TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, CONG_CU_BAN_GOI, DTHU_TLDG
                            from vietanhvh.dongia_DTHH
                            where trangthai = 'Hiện Hữu' and thang = 202501
                              and MA_VTCV in ('VNP-HNHCM_KDOL_3', 'VNP-HNHCM_KDOL_3')
                              and loai_gd in ('GIAHAN', 'NANG_GOI', 'NANG_CHUKY')
                              )
;select * from bsc_tonghop;
--010
delete
from bsc_tonghop
where ma_kpi= 'HCM_DT_VNPTT_010' and thang = 202501;
insert into bsc_tonghop
select thang,'KPI_NV 'loai_kpi ,'HCM_DT_VNPTT_010' ma_kpi,'',ma_nv, MA_VTCV, ma_to,ma_pb,(select x.tinh_bsc from ttkd_bsc.nhanvien x where x.thang =a.thang and a.ma_nv = x.ma_nv ) tinh_bsc,21,20,'' chitieu_giao,1.5 giao,round(sum(DTHU_TLDG/1.1)/1000000,1) KQTH
,
    CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 2) / 1.5) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 2) / 1.5) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 2) / 1.5) * 100, 2)
    END as TLTH
,CASE
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 2) / 1.5) * 100, 2) >= 120 THEN 120
        WHEN ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 2) / 1.5) * 100, 2) < 30 THEN 30
        ELSE ROUND((ROUND(SUM(DTHU_TLDG)/1000000, 2) / 1.5) * 100, 2)
    END as MDHT,'',''
from (
                       select THANG, MA_TB, TRANGTHAI, TEN_GOI, LOAI_GD, LOAIHINH_TB, USER_BAN_GOI, MA_NV, TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, CONG_CU_BAN_GOI, DTHU_TLDG
                            from vietanhvh.dongia_DTHH
                            where
                                 thang = 202501
                                and trangthai = 'Hiện Hữu'
                              and MA_VTCV in ('VNP-HNHCM_KDOL_3')
                              and loai_gd in ('DANGKY')
                              and thang = 202501) a
group by thang,MA_NV, MA_VTCV, ma_to,ma_pb;

select * from ttkd_bsc.nhanvien where ma_nv ='VNP016923';
select * from ttkd_bsc.bangluong_kpi where thang = 202501 and ma_kpi like '%_008';
select * from ttkd_bsc.bangluong_kpi where thang = 202501 and ma_kpi like '%_010';

select * from ttkd_bsc.bangluong_kpi where thang = 202501 and ma_kpi like '%_009';

select * from bsc_tonghop where thang = 202501 and ma_kpi like '%_012';

--008
    update ttkd_bsc.bangluong_kpi x
    set (thuchien,TYLE_THUCHIEN) = (select  a.THUCHIEN,a.tyle from bsc_tonghop  a where a.ma_kpi ='HCM_DT_VNPTT_008' and a.MA_NV =x.ma_nv and a.ma_to=x.ma_to and a.thang = x.thang)

where x.thang = 202501 and x.ma_kpi = 'HCM_DT_VNPTT_008'
    and exists (select 1 from ttkd_bsc.nhanvien a where a.thang = 202501 and a.tinh_bsc = 1 and x.ma_nv =a.ma_nv);

--009
  update ttkd_bsc.bangluong_kpi x
    set (thuchien,TYLE_THUCHIEN) = (select  a.THUCHIEN,a.tyle from bsc_tonghop  a where a.ma_kpi ='HCM_DT_VNPTT_009' and a.MA_NV =x.ma_nv and a.ma_to=x.ma_to and a.thang = x.thang)

where x.thang = 202501 and x.ma_kpi = 'HCM_DT_VNPTT_009' and x.ma_vtcv in ('VNP-HNHCM_KDOL_3')
    and exists (select 1 from ttkd_bsc.nhanvien a where a.thang = 202501 and a.tinh_bsc = 1 and x.ma_nv =a.ma_nv);
--010
  update ttkd_bsc.bangluong_kpi x
    set (thuchien,TYLE_THUCHIEN) = (select  a.THUCHIEN,a.tyle from bsc_tonghop  a where a.ma_kpi ='HCM_DT_VNPTT_010' and a.MA_NV =x.ma_nv and a.ma_to=x.ma_to and a.thang = x.thang)

where x.thang = 202501 and x.ma_kpi = 'HCM_DT_VNPTT_010' and x.ma_vtcv in ('VNP-HNHCM_KDOL_3')
    and exists (select 1 from ttkd_bsc.nhanvien a where a.thang = 202501 and a.tinh_bsc = 1 and x.ma_nv =a.ma_nv);