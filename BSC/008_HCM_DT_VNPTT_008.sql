- HCM_DT_VNPTT_008 - Tổng doanh thu bán hàng trên tập thuê bao di động hiện hữu
- GIAO(6400 trieudong),KQTH: KTNV công bố
- Công thức: Tổng Doanh thu  bán hàng trên tập thuê bao  di động hiện hữu (gia hạn CKD, CKN, bán gói, nâng gói, nâng chu kỳ) (ALL) / doanh thu giao trong tháng
- Số giao: 6,400 triệu đồng
- Số thực hiện = TỔNG SỐ THỰC HIỆN CỦA CÁC NHÂN VIÊN TRONG TO?
- Điều kiện ghi nhận: áp dụng theo quy định hiện hành
drop table a_ct_dthu_hh;
select *
from a_ct_dthu_hh;
create table a_ct_dthu_hh_008 as
select *
from (
select THANG,
       MA_TB,
       TRANGTHAI,
       TEN_GOI,
       LOAI_GD,
       LOAIHINH_TB,
       USER_BAN_GOI,
       MA_NV,
       TEN_NV,
       MA_VTCV,
       MA_TO,
       TEN_TO,
       MA_PB,
       TEN_PB,
       CONG_CU_BAN_GOI,
       DTHU_TLDG
from vietanhvh.dongia_DTHH
where trangthai = 'Hiện Hữu'
    and ma_to ='VNP0703004')
 -- and MA_VTCV = 'VNP-HNHCM_KDOL_3.1' ) -- THANG12: SE THAY DOI VTCV HNHCM_KDOL_17.1
;

--thang 10: to = VNP0703004 thuchien = 7787380481, neu giao nhu thang 11 la 12%
drop table a_th_dthu_hh_008;
create table a_th_dthu_hh_008
as
select thang,'HCM_DT_VNPTT_008' ma_kpi,'CTV072956' ma_nv,'Võ Tài Phát' ten_nv,'VNP-HNHCM_KDOL_3.1' MA_VTCV, ma_to,'VNP0703000' ma_pb,6400 giao,round(sum(DTHU_TLDG)/1000000,0) KQTH
,round((round(sum(DTHU_TLDG)/1000000,0)/6400)*100,2) TLTH
from a_ct_dthu_hh_008
group by thang,ma_to;
select *
from a_th_dthu_hh_008;;


select *
from TTKD_BSC.bangluong_kpi
where thang = 202411
    and ma_kpi like '%_008';


----HCM_DT_VNPTT_010
Công thức: Tổng Doanh thu bán gói trên tập TB di động hiện hữu / doanh thu giao trong tháng
Số giao: 1,5 triệu đồng
Điều kiện ghi nhận: áp dụng theo quy định hiện hành
KTNV công bố: GIAO,KQTH (dvi trieu dong)
;
create table;
select THANG,
       MA_TB,
       TRANGTHAI,
       TEN_GOI,
       LOAI_GD,
       LOAIHINH_TB,
       USER_BAN_GOI,
       MA_NV,
       TEN_NV,
       MA_VTCV,
       MA_TO,
       TEN_TO,
       MA_PB,
       TEN_PB,
       CONG_CU_BAN_GOI,
       DTHU_TLDG
from vietanhvh.dongia_DTHH
where trangthai = 'Hiện Hữu' and MA_VTCV = 'VNP-HNHCM_KDOL_3'
    and loai_gd in ('GIAHAN','NANG_GOI','NANG_CHUKY')
;
select distinct LOAI_GD
from vietanhvh.dongia_DTHH;