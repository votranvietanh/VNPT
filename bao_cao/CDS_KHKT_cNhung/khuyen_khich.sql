--Gồm nhận dạng thương hiệu a Mẫn và Khuyến khích a Khanh
select thang THANG_ptm,thang thang_tldg  , 'Điểm bán' ten_Kieuld

    , ''ma_tb
    ,2 dichvuvt_id
    ,21 loaitb_id
    ,'VNPTT' loaihinh_tb
    ,      case when PHONG_BAN_HANG = 'Phòng Bán hàng KV Bình Chánh' then 'VNP0701100'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Chợ Lớn' then 'VNP0701200'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Củ Chi' then 'VNP0702200'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Gia định' then 'VNP0701300'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Nam Sài Gòn' then 'VNP0701400'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Sài Gòn' then 'VNP0701500'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Thủ Đức' then 'VNP0701800'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Tân Bình' then 'VNP0701600' else '' end ma_PB
                ,''ten_pb
    , MA_DIEM_BAN manv_ptm, TEN_DIEM_BAN tennv_ptm, case when DIEM_BAN in('Pháp nhân cấp TTKD','Pháp nhân TCT') then 'Điểm ủy quyền'
                else 'Đại lý pháp nhân' end as kenh
    , TIEN_KHUYEN_KHICH thu_lao,'khuyen_kich' loai_thulao , 'VNPTT_KK' nguon
from manpn.thulao_ndth_dachi@ttkddbbk2
where thang = 202406

    union all
select a.THANG_PTM, a.THANG_TLDG_dt, a.tenkieu_ld,ma_tb,DICHVUVT_ID, a.LOAITB_ID
, (select LOAIHINH_TB from css_hcm.loaihinh_tb where loaitb_id =a.loaitb_id) LOAIHINH_TB
, a.MA_PB,ten_pb, a.MANV_PTM, a.tennv_ptm
    ,(select TEN_NHOM from ttkd_bsc.dm_nhomld where nhomld_id= a.nhom_tiepthi ) KENH
    , nvl(a.LUONG_DONGIA_NVPTM,0)+nvl(a.luong_dongia_nvhotro,0) luong, a.LOAI_THULAO, a.NGUON
from ttkd_bct.khkt_bc_hoahong a
where THANG_TLDG_DT = 202406
    and loai_thulao = 'khuyen khich';

;