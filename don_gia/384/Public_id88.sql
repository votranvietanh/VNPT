drop table dongia_DTHH_202411;
delete from dongia_DTHH where thang = 202502;
insert into dongia_DTHH
select * from dongia_DTHH_202411 ;
select *
from manpn.bscc_import_goi_bris_p04 where accs_mthd_key in ('84914005861') and thang = 202411;


    );37.503.407
      ;
select *
from DONGIA_DTHU_HIENHUU_202411 where ma_tb ='84914005861';;
select *
from dongia_DTHH_202411 where ma_tb ='84914005861';
select ma_nv,sum(DTHU_KPI)
from dongia_DTHH_202411
where MA_VTCV ='VNP-HNHCM_KDOL_17'
group by ma_nv
;
select sum(DTHU_TLDG)
from dongia_DTHH_202411;

select ma_pb,sum(TIEN_THULAO) from dongia_DTHH
group by ma_pb;
select * from dongia_DTHH where  ;
select * from TTKD_BSC.nhanvien where ma_nv ='CTV087563';

delete from dongia_DTHH where thang = 202502;


insert into dongia_DTHH
-- create table dongia_DTHH_202412 as
select *
from (select THANG
           , MA_TB
           , decode(IS_TBHH, 1, 'Hiện Hữu', 0, 'PTM') trangthai
           , THANG_KH_SIM                             thang_dktt_tb
           , TEN_GOI
           , DTHU_GOI
           , to_char(NGAY_KH)                         ngay_kh_goi
           , LOAI_GD
           , LOAIHINH_TB
           , USER_BAN_GOI
           , USER_NAME
           , LOAI_KENH
           , MA_HRM                                   ma_nv
           , TEN_NV
           , MA_VTCV
           , ma_to
           , ten_to
           , MA_PB
           , TEN_PB
           , CONG_CU_BAN_GOI
           , LOAI_HVC
           , HESO
           , DTHU_TLDG
           , case when ma_vtcv in ('VNP-HNHCM_KDOL_17','VNP-HNHCM_BHKV_52','VNP-HNHCM_BHKV_53') then round(TIEN_THULAO / 0.8, 0)
               else 0 end as DTHU_KPI
           , TIEN_THULAO
           , NGUON
           , lydo_khongtinh
            ,202502 THANG_TLDG
      from (select *
            from vietanhvh.S_DONGIA_DTHU_HIENHUU_202502_TEST --50.998

           ))

;
select count(*)
from S_DONGIA_DTHU_HIENHUU_202411_test;
select *
from vietanhvh.dongia_DTHH where thang = 202411
;
select *
from TTKD_BSC.;

SELECT DISTINCT x.ma_tb, x.ten_goi AS ten_goi_b, a.ten_goi AS ten_goi_a
FROM vietanhvh.dongia_DTHH a
JOIN S_DONGIA_DTHU_HIENHUU_202411_test x
    ON x.ma_tb = a.ma_tb
WHERE x.ten_goi <> a.ten_goi
  AND x.ten_goi IS NOT NULL
  AND a.ten_goi IS NOT NULL
  AND x.ten_goi < a.ten_goi and
 a.thang = 202411;


select * from S_DONGIA_DTHU_HIENHUU_202411_test  where ma_tb ='84916256906';
;
select * from vietanhvh.dongia_DTHH_202411   where ma_tb ='84854607842';

;
select count(*) from vietanhvh.dongia_DTHH a where thang = 202411 --83412
;
select count(*) from DONGIA_DTHH_202411 --83492
;
select MA_TB, TEN_GOI, DTHU_GOI, LOAI_GD, USER_BAN_GOI from vietanhvh.dongia_DTHH a where thang = 202411
minus
select MA_TB, TEN_GOI, DTHU_GOI, LOAI_GD, USER_BAN_GOI from S_DONGIA_DTHU_HIENHUU_202411_test
    ;
select *
from TTKD_BSC.nhanvien where ma_nv ='CTV088567';

SELECT a.MA_TB, a.TEN_GOI, a.DTHU_GOI, a.LOAI_GD, a.USER_BAN_GOI
FROM vietanhvh.dongia_DTHH a
WHERE thang = 202411
  AND NOT EXISTS (
    SELECT 1
    FROM S_DONGIA_DTHU_HIENHUU_202411_test x
    WHERE x.MA_TB = a.MA_TB
      AND x.TEN_GOI = a.TEN_GOI
      AND x.DTHU_GOI = a.DTHU_GOI
      AND x.LOAI_GD = a.LOAI_GD
      AND x.USER_BAN_GOI = a.USER_BAN_GOI
  );

select * from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY;
select * from dongia_dthh where
                             ma_tb  in ('84845416112','84849994262','84842224191');
delete from dongia_dthh where thang is null;

select sum(TIEN_THULAO) from vietanhvh.dongia_DTHH where ma_nv ='CTV087434' and LOAI_GD='DANGKY';

select * from vietanhvh.dongia_DTHH where thang = 202412 and ma_tb in ('84842475189','84849400608',	'84847044948'	);
update dongia_dthh a
set (TEN_NV, MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB) = (select x.TEN_NV, x.MA_VTCV, x.MA_TO, x.TEN_TO, x.MA_PB, x.TEN_PB from ttkd_bsc.nhanvien x  where x.thang = 202412 and a.ma_nv=x.ma_nv)
where thang = 202412 and ma_tb in ('84842475189','84849400608',	'84847044948'	);