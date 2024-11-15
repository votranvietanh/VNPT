-- drop table dongia_DTHH;

create table dongia_DTHH as
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
           , MA_PB
           , TEN_PB
           , CONG_CU_BAN_GOI
           , LOAI_HVC
           , HESO
           , DTHU_TLDG
           , round(DTHU_TLDG / 0.8, 0)                DTHU_KPI
           , TIEN_THULAO
           , NGUON
           , lydo_khongtinh
      from (select *
            from vietanhvh.S_DONGIA_DTHU_HIENHUU_202410 --50.998
            where ma_pb = 'VNP0703000'
              and IS_TBHH = 1
              and loai_gd not in ('HA_CHUKY', 'HA_GOI')
              and lydo_khongtinh is null

            union all
            select *
            from vietanhvh.S_DONGIA_DTHU_HIENHUU_202410
            where ma_pb <> 'VNP0703000'
              and loai_gd not in ('GIAHAN', 'GIAHAN_TUDONG')
              and IS_TBHH = 1
              and loai_gd not in ('HA_CHUKY', 'HA_GOI')
              and lydo_khongtinh is null
            )
      )

