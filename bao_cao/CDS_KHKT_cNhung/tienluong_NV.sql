--tien_thulao NVCT_CTV_NVVT
select a.ma_nv,sum(a.LUONG_PTM_CDBR*b.HESO_QD_TONG), sum(a.LUONG_PTM_VNPTS*b.HESO_QD_TONG), sum(a.LUONG_PTM_VNPTT), sum(a.LUONG_PTM_CNTT*b.HESO_QD_TONG)
from
            (select manv_ptm ma_nv,
--							  (select ma_to from ttkd_bsc.nhanvien where manv_hrm=a.manv_ptm and thang =202406) ma_to,
--							  (select ma_pb from ttkd_bsc.nhanvien where manv_hrm=a.manv_ptm and thang =202406) ma_pb,
                              ma_tb,ma_kh,ma_gd,
							  (nvl(dthu_ptm_cdbr,0)) dthu_ptm_cdbr,
							  (nvl(dthu_ptm_vnpts,0)) dthu_ptm_vnpts,
							  0 dthu_ptm_vnptt,
							  (nvl(dthu_ptm_khac,0)) dthu_ptm_cntt,
							  round((nvl(luong_ptm_cdbr,0)) ,0)  luong_ptm_cdbr,
							  round((nvl(luong_ptm_vnpts,0)) ,0) luong_ptm_vnpts,
							  round((nvl(luong_ptm_vnptt,0)) ,0) luong_ptm_vnptt,
							  round((nvl(luong_ptm_khac,0)) ,0) luong_ptm_cntt
                              ,nguon
					from
					(
					    -- nvptm
					    select  manv_ptm,ma_tb,ma_kh,ma_gd,
							   (case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_nvptm end) dthu_ptm_cdbr, -- not in di dong va cntt
							   (case when loaitb_id=20 then doanhthu_dongia_nvptm end) dthu_ptm_vnpts,
							   (case when loaitb_id=21  then doanhthu_dongia_nvptm end) dthu_ptm_vnptt,
							   (case when dichvuvt_id in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_nvptm end) dthu_ptm_khac,
							   (doanhthu_dongia_nvptm) Tong_dthu,
							   (case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_nvptm end) luong_ptm_cdbr,
							  (case when loaitb_id=20  then nvl(LUONG_DONGIA_NVPTM,0) end) luong_ptm_vnpts,
							  (case when loaitb_id=21  then nvl(LUONG_DONGIA_DNHM_NVPTM,0)+nvl(LUONG_DONGIA_NVPTM,0) end) luong_ptm_vnptt,
							  (case when dichvuvt_id in (13,14,15,16) or loaitb_id is null then luong_dongia_nvptm end) luong_ptm_khac
							  ,'nvptm' nguon
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dt = 202406


		union all
					    -- dnhm cua nvptm
					    select  manv_ptm,ma_tb,ma_kh,ma_gd,
							   (case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dnhm end) dthu_ptm_cdbr,
							   (case when loaitb_id=20 then doanhthu_dongia_dnhm end) dthu_ptm_vnpts,
							  null dthu_ptm_vnptt,
							   (case when loaitb_id in (38,127) then doanhthu_dongia_dnhm end)  dthu_ptm_khac,
							   (doanhthu_dongia_dnhm) Tong_dthu,
							   (case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dnhm_nvptm end) luong_ptm_cdbr,
							   (case when loaitb_id=20 then nvl(LUONG_DONGIA_DNHM_NVPTM,0) end) luong_ptm_vnpts,
							  (case when loaitb_id=21  then nvl(LUONG_DONGIA_DNHM_NVPTM,0)+nvl(LUONG_DONGIA_NVPTM,0) end) luong_ptm_vnptt,
							   (case when loaitb_id in (38,127) then luong_dongia_dnhm_nvptm end) luong_ptm_khac
							 ,'dnhm' nguon
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dnhm = 202406

		union all
					    -- nv dai
					    select  manv_tt_dai,ma_tb,ma_kh,ma_gd,
							   (case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dai end) dthu_ptm_cdbr,
							   (case when loaitb_id=20  then doanhthu_dongia_dai end) dthu_ptm_vnpts,
							   (case when loaitb_id=21  then doanhthu_dongia_dai end) dthu_ptm_vnptt,
							   (case when dichvuvt_id  in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_dai end) dthu_ptm_khac,
							   (doanhthu_dongia_dai) Tong_dthu,
							   (case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dai end) luong_ptm_cdbr,
							   (case when loaitb_id=20  then luong_dongia_dai end) luong_ptm_vnpts,
							 nvl(LUONG_DONGIA_DNHM_NVPTM,0)  luong_ptm_vnptt,
							   (case when (dichvuvt_id  in (13,14,15,16)  or dichvuvt_id is null) then luong_dongia_dai end) luong_ptm_khac
							,'nvtt dai' nguon
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dt_dai = 202406



		union all
					    -- nv ho tro cua PGP
					    select  manv_hotro,ma_tb,ma_kh,ma_gd,
							   (case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_nvhotro end) dthu_ptm_cdbr,
							   (case when loaitb_id=20  then doanhthu_dongia_nvhotro end) dthu_ptm_vnpts,
							   (case when loaitb_id=21  then doanhthu_dongia_nvhotro end) dthu_ptm_vnptt,
							   (case when dichvuvt_id  in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_nvhotro end) dthu_ptm_khac,
							   (doanhthu_dongia_nvhotro) Tong_dthu,
							   (case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_nvhotro end) luong_ptm_cdbr,
							   (case when loaitb_id=20  then luong_dongia_nvhotro end) luong_ptm_vnpts,
							 0 luong_ptm_vnptt,
							   (case when (dichvuvt_id  in (13,14,15,16)  or dichvuvt_id is null) then luong_dongia_nvhotro end) luong_ptm_khac
							,'manv_hotro' nguon
					    from ttkd_bsc.ct_bsc_ptm_pgp
					    where thang_tldg_dt_nvhotro = 202406

			    ) a
			where manv_ptm is not null

            ) a
            join ttkd_bsc.bangluong_dongia_202406 b on a.ma_nv =b.ma_nv
            			where a.ma_nv is not null