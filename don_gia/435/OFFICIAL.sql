drop table dongia_PTTT;
CREATE TABLE dongia_PTTT AS
 select ACCS_MTHD_KEY ma_tb
             ,  CASE
                    WHEN (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -1) AND LOAIHINH_TB = 'TT') --1
                      OR (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -6) AND LOAIHINH_TB = 'TS') --6
                    THEN 1
                    ELSE 0
                END AS IS_TBHH

             ,TO_CHAR(TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS'),'YYYYMM') THANG_KH_SIM, SERVICE_CODE ten_goi, P2_CHUKY chu_ky, TOT_RVN_PACKAGE dthu_goi, REGIS_DT ngay_kh, REGIS_TYPE_GRP , TRANS_TYPE loai_gd, LOAIHINH_TB, USER_CODE user_ban_goi
                , USER_NAME,RESELLER_NAME pbh, CHANNEL_TYPE loai_kenh, CHANNEL_MEMBER thanhvien_kenh
                , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi
                  , LOAI_HVC,DECODE(LOAI_HVC,'HVC',25,'NOHVC',20) HESO,TOT_RVN_PACKAGE DTHU_TLDG, TOT_RVN_PACKAGE*DECODE(LOAI_HVC,'HVC',25,'NOHVC',20)/100 TIEN_THULAO
                ,  CAST('BRIS_P04' AS NVARCHAR2(30)) nguon, TRANS_TYPE LOAI_GD_tldg
 from MANPN.bscc_import_goi_bris_p04 a
 LEFT JOIN ttkd_bsc.a_vcc_ccbs b ON a.ACCS_MTHD_KEY = b.somay
where LOAI_TB_THANG ='HH' and thang = 202412
        AND b.somay IS NULL -- loai cac STB VCC
        and (REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT')) -- loai tru cac user_code bi null
        and TRANS_TYPE  in ('DANGKY','NANG_GOI','NANG_CHUKY','GIAHAN')--chi lay cac tieu chi tren o PL4,13/12 them dieu kien GIAHANde co record cho PTTT
--     and SERVICE_CODE not in (SELECT goi_cuoc FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' )
        and USER_CODE NOT IN ('SYSTEM','SMS','sms','ccbs_vnp','crosssell_vnp','4G-SPR','1543|TDL_CTNET','1543|TELESALE')
        and P2_CHUKY is not null --bỏ các gói ngày,se~ con` sót lại nhưững gói ngày như MI_YT10k nhưng ct để là ck tháng!
;

MERGE INTO dongia_PTTT tgt
USING (
    SELECT
        t1.ma_tb,
        t1.ngay_kh,
        t2.ngay_kh AS ngay_kh_muon
    FROM dongia_PTTT t1
    JOIN dongia_PTTT t2
        ON t1.ten_goi = t2.ten_goi
        AND t1.ma_tb=t2.ma_tb
        AND t1.DTHU_GOI = t2.DTHU_GOI
        AND t1.nguon = 'BRIS_P04'
        AND t2.nguon = 'BRIS_P04'
        AND t1.ngay_kh < t2.ngay_kh -- chỉ lấy các bản ghi có ngày_kh muộn hơn
) src
ON (tgt.ma_tb = src.ma_tb AND tgt.nguon = 'BRIS_P04' and src.ngay_kh_muon = tgt.ngay_kh)
WHEN MATCHED THEN
    UPDATE SET tgt.loai_gd = 'GIAHAN';

INSERT INTO dongia_PTTT
     select ACCS_MTHD_KEY ma_tb
             ,  CASE
                    WHEN (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -1) AND LOAIHINH_TB = 'TT') --1
                      OR (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -6) AND LOAIHINH_TB = 'TS') --6
                    THEN 1
                    ELSE 0
                END AS IS_TBHH

             ,TO_CHAR(TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS'),'YYYYMM') THANG_KH_SIM, SERVICE_CODE ten_goi, P2_CHUKY chu_ky, TOT_RVN_PACKAGE dthu_goi, REGIS_DT ngay_kh, REGIS_TYPE_GRP , 'NANG_CHUKY' loai_gd, LOAIHINH_TB, USER_CODE user_ban_goi
                , USER_NAME,RESELLER_NAME pbh, CHANNEL_TYPE loai_kenh, CHANNEL_MEMBER thanhvien_kenh
                , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi
                  , LOAI_HVC,DECODE(LOAI_HVC,'HVC',25,'NOHVC',20) HESO,TOT_RVN_PACKAGE DTHU_TLDG, TOT_RVN_PACKAGE*DECODE(LOAI_HVC,'HVC',25,'NOHVC',20)/100 TIEN_THULAO
                ,  'BRIS_P04_ts' nguon, 'NANG_CHUKY' LOAI_GD_tldg
 from MANPN.bscc_import_goi_bris_p04 a
 LEFT JOIN ttkd_bsc.a_vcc_ccbs b ON a.ACCS_MTHD_KEY = b.somay
where LOAI_TB_THANG ='HH' and thang = 202412
        and LOAIHINH_TB ='TS' --#
        AND TRANS_TYPE ='HA_GOI'
        AND b.somay IS NULL -- loai cac STB VCC
        and (REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT')) -- loai tru cac user_code bi null
        and USER_CODE NOT IN ('SYSTEM','SMS','sms','ccbs_vnp','crosssell_vnp','4G-SPR','1543|TDL_CTNET','1543|TELESALE')
        and P2_CHUKY is not null --bỏ các gói ngày,se~ con` sót lại nhưững gói ngày như MI_YT10k nhưng ct để là ck tháng!
;
select *
from dongia_PTTT where ma_tb ='84914005861';;
drop table  dongia_PTTT_chot;
 CREATE TABLE dongia_PTTT_chot AS
WITH src_data AS (
    SELECT 202412 AS thang,
           a.MA_TB, IS_TBHH, a.THANG_KH_SIM, a.TEN_GOI, a.CHU_KY, a.DTHU_GOI, a.NGAY_KH,
           a.REGIS_TYPE_GRP, a.LOAI_GD, a.LOAIHINH_TB, a.USER_BAN_GOI,a.USER_BAN_GOI user_temp,cast(null as nvarchar2(100)) USER_NAME,a.pbh, a.LOAI_KENH,
           a.THANHVIEN_KENH, a.MA_HRM, a.TEN_NV,
           x.ma_vtcv
           ,(select ma_to from ttkd_bsc.nhanvien where ma_nv=ma_hrm and thang = 202412) ma_to
           ,(select ten_to from ttkd_bsc.nhanvien where ma_nv=ma_hrm and thang = 202412) ten_to
           ,x.ma_pb, x.ten_pb, -- lấy dữ liệu từ bảng ttkd_bsc.nhanvien
           a.CONG_CU_BAN_GOI, a.LOAI_HVC, a.HESO, a.DTHU_TLDG,round(TIEN_THULAO / 0.8, 0) DTHU_KPI, a.TIEN_THULAO, a.NGUON, a.LOAI_GD_TLDG,
--            ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.USER_BAN_GOI, a.dthu_goi DESC) AS rnk
           ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.NGAY_KH DESC) AS rnk

    FROM dongia_PTTT a
    LEFT JOIN ttkd_bsc.nhanvien x
           ON a.ma_hrm = x.ma_nv AND x.thang = 202412
)
-- ds stb loai_tru
, prevent_data AS (
    SELECT somay
    FROM khanhtdt_ttkd.CCBS_ID1896@TTKDDB
    WHERE thang = 202412 AND kieu_ld = 'P -> C'
)
SELECT a.*,
       CASE
           WHEN IS_TBHH = 0
               then 'PTM ko tinh( 6 thang voi TS, 1 thang voi Tratruoc'
           WHEN  ma_pb ='VNP0700800'
                then 'PTTT ko tính'
           WHEN pd.SOMAY IS NOT NULL
                THEN 'DS loại trừ: P2C'
            WHEN  EXISTS (SELECT 1 FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' AND goi_cuoc = a.ten_goi)
                THEN 'Khong phải CK tháng'


        ELSE NULL
       END AS lydo_khongtinh
FROM src_data a
LEFT JOIN prevent_data pd ON a.ma_tb = pd.SOMAY;
select *
from vietanhvh.dongia_PTTT_chot where  ma_pb ='VNP0700800';
update dongia_PTTT_chot
set heso = 0
,DTHU_KPI = 0
,TIEN_THULAO = 0
,LYDO_KHONGTINH = null
;
select count(*)
from vietanhvh.dongia_PTTT where pbh= 'Phòng Phát triển thị trường'--ma_pb ='VNP0700800'
and ma_tb not in (
select '84'||SO_TB ma_tb from vietanhvh.OB_CKN_CT where thang = 202412 and GIA_HAN_TUDONG ='x'
union all
select '84'||SO_THUE_BAO from vietanhvh.OB_CKD_CT where thang = 202412 and  GIA_HAN_TU_DONG ='x'
union all
SELECT  '84'||substr(MA_TB,2,10)
FROM vietanhvh.ob_IPCC_CT
);

SELECT CHUONGTRINH_OB, '84'||substr(MA_TB,2,10) ma_tb, USERNAME, THOI_GIAN
FROM ob_IPCC_CT where  thang = 202412
;
select *
from MANPN.bscc_import_goi_bris_p04;

alter table dongia_PTTT
add lydo_khongtinh nvarchar2(100)
;

update dongia_PTTT
set lydo_khongtinh = 'Gia hạn tự động/IPCC'
,HESO=0, DTHU_TLDG=0, TIEN_THULAO =0
where ma_tb  in (
select '84'||SO_TB ma_tb from vietanhvh.OB_CKN_CT where thang = 202412 and GIA_HAN_TUDONG ='x'
union all
select '84'||SO_THUE_BAO from vietanhvh.OB_CKD_CT where thang = 202412 and  GIA_HAN_TU_DONG ='x'
union all
SELECT  '84'||substr(MA_TB,2,10)
FROM vietanhvh.ob_IPCC_CT where thang = 202412 )
;
drop table dongia_PTTT_202412;
 CREATE TABLE dongia_PTTT_202412 AS
WITH src_data AS (
    SELECT 202412 AS thang,
           a.MA_TB, IS_TBHH, a.THANG_KH_SIM, a.TEN_GOI, a.CHU_KY, a.DTHU_GOI, a.NGAY_KH,
           a.REGIS_TYPE_GRP, a.LOAI_GD, a.LOAIHINH_TB, a.USER_BAN_GOI,a.USER_BAN_GOI user_temp,cast(null as varchar2(100)) USER_NAME, a.LOAI_KENH,
           a.THANHVIEN_KENH, a.MA_HRM, a.TEN_NV,x.ma_to
--            ,(select ma_to from ttkd_bsc.nhanvien where ma_nv=ma_hrm and thang = 202412) ma_to
--            ,(select ten_to from ttkd_bsc.nhanvien where ma_nv=ma_hrm and thang = 202412) ten_to
           , 'VNP0700800' ma_pb,'Phòng Phát Triển Thị Trường'ten_pb, -- lấy dữ liệu từ bảng ttkd_bsc.nhanvien
           a.CONG_CU_BAN_GOI, a.DTHU_TLDG,x.giao dinhmuc_giao,cast(null as number) tyle, 0 HESO, a.TIEN_THULAO, a.NGUON, a.LOAI_GD_TLDG,
--            ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.USER_BAN_GOI, a.dthu_goi DESC) AS rnk
           ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.NGAY_KH DESC) AS rnk,cast (a.lydo_khongtinh as varchar2(100)) lydo_khongtinh

    FROM dongia_PTTT a
    LEFT JOIN ctv_pttt  x --nhanvien_ctv_pttt
           ON (a.ma_hrm = x.ma_nv or x.ten_nv = a.ten_nv) AND x.thang = 202412
)
-- ds stb loai_tru
, prevent_data AS (
    SELECT somay
    FROM khanhtdt_ttkd.CCBS_ID1896@TTKDDB
    WHERE thang = 202412 AND kieu_ld = 'P -> C'
)
SELECT THANG, MA_TB, IS_TBHH, THANG_KH_SIM, TEN_GOI, CHU_KY, DTHU_GOI, NGAY_KH, REGIS_TYPE_GRP, LOAI_GD, LOAIHINH_TB, USER_BAN_GOI, USER_TEMP, USER_NAME, LOAI_KENH, THANHVIEN_KENH, MA_HRM, TEN_NV,ma_to, MA_PB, TEN_PB, CONG_CU_BAN_GOI, DTHU_TLDG, dinhmuc_giao, TYLE, HESO, TIEN_THULAO, NGUON, LOAI_GD_TLDG, RNK,
       CASE
           WHEN IS_TBHH = 0
               then 'PTM ko tinh( 6 thang voi TS, 1 thang voi Tratruoc'
           WHEN pd.SOMAY IS NOT NULL
                THEN 'DS loại trừ: P2C'
            WHEN  EXISTS (SELECT 1 FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' AND goi_cuoc = a.ten_goi)
                THEN 'Khong phải CK tháng'
        ELSE a.lydo_khongtinh
       END AS lydo_khongtinh
FROM src_data a
LEFT JOIN prevent_data pd ON a.ma_tb = pd.SOMAY;
select *
from CTV_PTTT;
---
update dongia_PTTT_202412 a
    set dinhmuc_giao =(select x.giao
from ctv_pttt x where x.ma_nv = a.ma_nv)
;
merge into dongia_PTTT_202412 a
using (select round(sum(DTHU_TLDG/1000000/1.1),0) dthu_nv,ma_nv from dongia_PTTT_202412 group by ma_nv ) b
on (a.ma_nv = b.ma_nv)
when matched then
    update set tyle = round(b.dthu_nv/a.dinhmuc_giao*100,2)
    ;
    UPDATE dongia_PTTT_202412
SET heso = CASE
              -- Dịch vụ Gia hạn
              WHEN loai_gd = 'GIAHAN' AND tyle >= 100 THEN 0.2
              WHEN loai_gd = 'GIAHAN' AND tyle >= 90 AND tyle < 100 THEN 0.18
              WHEN loai_gd = 'GIAHAN' AND tyle >= 80 AND tyle < 90 THEN 0.16
              WHEN loai_gd = 'GIAHAN' AND tyle >= 50 AND tyle < 80 THEN 0.14

              -- Dịch vụ Bán gói (DANGKY)
              WHEN loai_gd = 'DANGKY' AND tyle >= 100 THEN 0.25
              WHEN loai_gd = 'DANGKY' AND tyle >= 90 AND tyle < 100 THEN 0.23
              WHEN loai_gd = 'DANGKY' AND tyle >= 80 AND tyle < 90 THEN 0.21
              WHEN loai_gd = 'DANGKY' AND tyle >= 50 AND tyle < 80 THEN 0.19

              -- Dịch vụ Nâng gói (NANG_GOI)
              WHEN loai_gd = 'NANG_GOI' AND tyle >= 100 THEN 0.25
              WHEN loai_gd = 'NANG_GOI' AND tyle >= 90 AND tyle < 100 THEN 0.23
              WHEN loai_gd = 'NANG_GOI' AND tyle >= 80 AND tyle < 90 THEN 0.21
              WHEN loai_gd = 'NANG_GOI' AND tyle >= 50 AND tyle < 80 THEN 0.19

              -- Dịch vụ Nâng chu kỳ (NANG_CHUKY)
              WHEN loai_gd = 'NANG_CHUKY' AND tyle >= 100 THEN 0.25
              WHEN loai_gd = 'NANG_CHUKY' AND tyle >= 90 AND tyle < 100 THEN 0.23
              WHEN loai_gd = 'NANG_CHUKY' AND tyle >= 80 AND tyle < 90 THEN 0.21
              WHEN loai_gd = 'NANG_CHUKY' AND tyle >= 50 AND tyle < 80 THEN 0.19
           ELSE 0  -- Giữ nguyên giá trị cũ nếu không khớp điều kiện
           END;

update dongia_PTTT_202412
set tien_thulao = 0
where  LYDO_KHONGTINH is not null
;
update dongia_PTTT_202412
set tien_thulao = 0
where  LOAI_GD ='GIAHAN' and ma_nv in (select ma_nv from CTV_PTTT where nhom ='nhom_1')
;

update dongia_PTTT_202412
set tien_thulao = round((dthu_tldg/1.1*(heso)),0)
where  LYDO_KHONGTINH is  null and  TRANGTHAI ='Hiện Hữu'
;
update dongia_PTTT_202412
set TIEN_THULAO = 0
,lydo_khongtinh ='Bán qua DIGISHOPWEB'
where loai_gd ='GIAHAN' and CONG_CU_BAN_GOI='DIGISHOPWEB' and lydo_khongtinh is null;
;

update dongia_PTTT_202412
set dthu_tldg = 0
,lydo_khongtinh = 'Gia hạn tự động'
where loai_gd ='GIAHAN' and
ma_tb in (select '84'||SO_TB ma_tb from vietanhvh.OB_CKN_CT where thang = 202412 and GIA_HAN_TUDONG ='x'
union all
select '84'||SO_THUE_BAO from vietanhvh.OB_CKD_CT where thang = 202412 and  GIA_HAN_TU_DONG ='x');
update dongia_PTTT_202412
set tien_thulao = 0
,lydo_khongtinh = 'Gia hạn OB không có trong ds IPCC'
where ma_nv in (select ma_nv  from ctv_pttt where is_ipcc = 1) and loai_gd ='GIAHAN' and ma_tb not  in (
SELECT  '84'||substr(MA_TB,2,10) ma_tb
FROM vietanhvh.ob_IPCC_CT where thang = 202412
) ; -- loai tru cac stb da update gia han tu dong


update dongia_PTTT_202412
set tien_thulao = 0
where  LOAI_GD ='GIAHAN' and ma_nv in (select ma_nv from CTV_PTTT where nhom ='nhom_1')
;
select * from dongia_PTTT_202412
where  LOAI_GD ='GIAHAN' and ma_nv in (select ma_nv from CTV_PTTT where nhom ='nhom_1')
;

select *
from dongia_PTTT_202412 where  LOAI_GD_TLDG is null;
update dongia_PTTT_202412
    set TIEN_THULAO = 0 where lydo_khongtinh is not null;
select * from dongia_PTTT_202412 where ma_nv in (select ma_Nv from ctv_pttt where nhom= 'nhom_1') and loai_gd ='GIAHAN';
;
select ma_nv,sum(tien_thulao) from dongia_PTTT_202412 group by ma_nv; --602.334.558
select THANG, MA_TB, TEN_GOI, LOAI_GD, LOAIHINH_TB, ma_nv, TEN_NV, MA_PB, TEN_PB, CONG_CU_BAN_GOI, DTHU_TLDG, DM_GIAO, TYLE, HESO, TIEN_THULAO, NGUON, LYDO_KHONGTINH from dongia_PTTT_202412;
select a.ma_nv, a.TEN_NV,x.giao,round(sum(DTHU_TLDG/1000000/1.1),0) dthu_nv,round(round(sum(DTHU_TLDG/1000000/1.1),0)/x.giao*100,0) tyle
from dongia_PTTT_202412 a
left join nhanvien_ctv_pttt  x on x.ma_nv =a.ma_nv
group by a.ma_nv, a.TEN_NV,x.giao;

----làm lại

;

select * from dongia_dthh
         where thang = 202412
           and ma_pb ='VNP0700800'
--            and TRANGTHAI='Hiện Hữu'
; and CONG_CU_BAN_GOI='DIGISHOPWEB' and LOAI_GD='GIAHAN';
select * from dongia_pttt_202412 ;

drop table dongia_pttt_202412;
create table dongia_pttt_202412 as
select THANG, MA_TB, TRANGTHAI, THANG_DKTT_TB, TEN_GOI, DTHU_GOI, NGAY_KH_GOI, LOAI_GD, LOAIHINH_TB, USER_BAN_GOI, USER_NAME, LOAI_KENH, MA_NV, TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, CONG_CU_BAN_GOI, DTHU_TLDG,0 DINHMUC_GIAO,0 tyle,0 heso,TIEN_THULAO, NGUON, cast(null as nvarchar2(300))LYDO_KHONGTINH from dongia_dthh
         where thang = 202412
           and ma_pb ='VNP0700800'
;
create table ctv_pttt_ipcc as
select 'diemnth.hcm' user_ipcc,	'Nguyễn Thị Hồng Diễm' ten_nv,	'CTV088561' ma_nv

from dual ;
delete
from ctv_pttt_ipcc
where 1=1;
select *
from ctv_pttt_ipcc;
create table ct_no_202411 as;
select  *
from qltn.v_ct_no@dataguard where ma_tb='915531788' and KY_CUOC = 20241101 ;and khoanmuctt_id in(212,208);

update
dongia_dthh
set thang_tldg = 202411
    where LYDO_KHONGTINH like'%G.TIEN%';

                      select * from dongia_dthh where ma_tb ='84914016078';
                      select sum(nogoc+thue),ma_tb from ct_no_202411 where ma_tb in (select  SUBSTR(MA_TB, 3) from dongia_dthh where thang_tldg = 202411 and loaihinh_tb ='TS' and tien_thulao >0
)   group by ma_tb
             ;
             update dongia_dthh
             set TIEN_THULAO = 0,LYDO_KHONGTINH = 'G.TIEN chua thu cuoc'
             where thang_tldg = 202411 and thang = 202412 and ma_tb in (select ma_tb from ct_no_202412 where ma_tb in (select  SUBSTR(MA_TB, 3) from dongia_dthh where thang_tldg = 202411 and loaihinh_tb ='TS' and tien_thulao >0
) where sum(nogoc+thue)>0 group by ma_tb)
             ;
             update dongia_dthh
             set thang_tldg = 202412
             where thang = 202412;

             UPDATE dongia_dthh
SET
    TIEN_THULAO = 0,
    LYDO_KHONGTINH = 'G.TIEN chua thu cuoc t12'
WHERE thang_tldg = 202412
  AND thang = 202412
  AND ma_tb IN (
    SELECT '84'||ma_tb
    FROM ct_no_202412
    WHERE ma_tb IN (
        SELECT SUBSTR(MA_TB, 3)
        FROM dongia_dthh
        WHERE thang_tldg = 202412 and thang = 202412
          AND loaihinh_tb = 'TS'
          AND tien_thulao > 0
    )
    GROUP BY ma_tb
    HAVING SUM(nogoc + thue) > 0
);
   UPDATE dongia_dthh
SET
    TIEN_THULAO = round(HESO*DTHU_TLDG/1.1,0)
    ,LYDO_KHONGTINH = null
WHERE thang_tldg = 202411
  AND thang = 202412
  AND ma_tb IN (
    SELECT '84'||ma_tb
    FROM ct_no_202412
    WHERE ma_tb IN (
        SELECT SUBSTR(MA_TB, 3)
        FROM dongia_dthh
        WHERE thang_tldg = 202411 and thang = 202412
          AND loaihinh_tb = 'TS'
          AND LYDO_KHONGTINH = 'G.TIEN chua thu cuoc'
    )
    GROUP BY ma_tb
    HAVING SUM(nogoc + thue) > 0)
;

