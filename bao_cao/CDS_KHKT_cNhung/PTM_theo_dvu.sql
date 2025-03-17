select *
from (select MA_TB                                               ma_thue_bao
--            , (d.LOAIHINH_TB)                                     loai_hinh_thue_bao
           , (select d.LOAIHINH_TB from css_hcm.loaihinh_tb d where d.LOAITB_ID = a.LOAITB_ID)  LOAIHINH_TB
           , (select d.TEN_DVVT from css_hcm.dichvu_vt d where d.DICHVUVT_ID = a.DICHVUVT_ID)  ten_dich_vu
           , MA_GD                                               ma_giao_dich
           , TEN_TB                                              ten_khach_hang
           , MA_KH
           , THUEBAO_ID
           , TENKIEU_LD
           , DIACHI_LD                                           dia_chi_khach_hang
           , NVL(NGAY_BBBG,trunc(to_date(thang_ptm,'yyyymm'))) ngay_nghiem_thu
           , SOTHANG_DC                                          so_thang_tra_truoc
           , DATCOC_CSD                                          gia_tri_goicuoc_tra_truoc
           , DTHU_GOI                                            gtri_goicuoc_thang
           , THANG_TLDG_DT
           , SL_MAILING                                          SL_Hopdong_dientu
           ,decode(TRANGTHAI_TT_ID,0,'Chưa TT',1,'Đã TT') TRANGTHAI_TT_ID
           ,decode(NOPDU_HSGOC,0,'Chưa đủ',1,'Đã đủ')   NOPDU_HSGOC
           ,tyle_CK
           , MANV_PTM                                            ma_tiep_thi
           , tennv_ptm                                           tennv_tiepthi
           , ten_pb                                              phong_tiep_thi
           , nguon
           , NVCT
           , DLCN
           , DLPN
           , KENH_CHUOI
           , DUQ
           , CTVXHH
      from (
            SELECT a.thang_ptm
                 , a.dichvuvt_id
                 , a.LOAITB_ID
                 , a.MA_GD
                 , a.MA_KH
                 , a.THUEBAO_ID
                 , a.MA_TB
                 , a.dichvu_vt
                 , a.TENKIEU_LD
                 , a.TEN_TB
                 , a.DIACHI_LD
                 , a.NGAY_BBBG
                 , a.MA_PB
                 , a.TEN_PB
                 , a.MA_TO
                 , a.TEN_TO
                 , a.MANV_PTM
                 , a.TENNV_PTM
                 , a.SOTHANG_DC
                 , a.DATCOC_CSD
                 , a.DTHU_DNHM
                 , a.DTHU_GOI
                 , a.THANG_TLDG_DT
                 , nvl(a.SL_HDDT,a.SL_MAILING) SL_MAILING
                 ,a.TRANGTHAI_TT_ID
                 ,a.NOPDU_HSGOC, a.TYLE_CK
                 , a.NHOM_TIEPTHI
                 , a.LOAI_THULAO
                 , a.LUONG_DONGIA_NVPTM
                 , a.LUONG_DONGIA_NVHOTRO
                 , case
                       when a.nhom_tiepthi in (1, 2)
                           then (nvl(a.LUONG_DONGIA_NVPTM, 0) + nvl(a.LUONG_DONGIA_NVHOTRO, 0))
                       else 0 end as NVCT
                 , case
                       when a.nhom_tiepthi = 4 then (nvl(a.LUONG_DONGIA_NVPTM, 0) + nvl(a.LUONG_DONGIA_NVHOTRO, 0))
                       else 0 end as DLCN
                 , case
                       when a.nhom_tiepthi = 5 or manv_ptm like 'BCKD%' then (nvl(a.LUONG_DONGIA_NVPTM, 0) + nvl(a.LUONG_DONGIA_NVHOTRO, 0))
                       else 0 end as DLPN
                 , case
                       when a.nhom_tiepthi = 6 then (nvl(a.LUONG_DONGIA_NVPTM, 0) + nvl(a.LUONG_DONGIA_NVHOTRO, 0))
                       else 0 end as kenh_chuoi
                 , case
                       when a.nhom_tiepthi = 7 then (nvl(a.LUONG_DONGIA_NVPTM, 0) + nvl(a.LUONG_DONGIA_NVHOTRO, 0))
                       else 0 end as DUQ
                 , case
                       when a.nhom_tiepthi = 8 then (nvl(LUONG_DONGIA_NVPTM, 0) + nvl(LUONG_DONGIA_NVHOTRO, 0))
                       else 0 end as CTVXHH
                 , a.nguon
            FROM KHKT_BC_HOAHONG_2 a) a

      WHERE thang_ptm = 202412
     )