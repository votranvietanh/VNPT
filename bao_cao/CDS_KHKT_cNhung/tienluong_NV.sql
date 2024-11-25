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
                       group by a.ma_nv
                        ;

                        select MA_NV,DTPTM_DONGIA_CDBR, DTPTM_DONGIA_CNTT, DTPTM_DONGIA_CNTT_QD, DTPTM_DONGIA_VNPTS, DTPTM_DONGIA_VNPTS_TONG, TONG_DTPTM, DTPTM_QUYDINH, DTPTM_MUCTIEU, DTPTM_BQ3T, HESO_QD_TONG, LUONG_DONGIA_CDBR, LUONG_DONGIA_CNTT, LUONG_DONGIA_VNPTS, CTVXHH_QLY_PTR_CTV, LUONG_DONGIA_DNHM_VNPTT, LUONG_DONGIA_GOI_KPBDB, LUONG_DONGIA_GOI_HCM, LUONG_DONGIA_GOI_QLDB, LUONG_DONGIA_VNPTT, LUONG_DONGIA_GHTT, LUONG_DONGIA_NGHIEPVU, GHTT_VNPTS, LUONG_KHAC, TONG_LUONG_DONGIA, GHICHU, LUONG_DONGIA_PTM_THUHOI, THUHOI_DONGIA_GHTT, GIAMTRU_HOSOTAINHA, GIAMTRU_PHATHUY_QLDB, GIAMTRU_GHTT_CNTT, LUONG_DONGIA_KHAC_THUHOI, TONG_LUONG_THUHOI, DTPTM_QUYDINH_G, LUONG_DONGIA_CHUNGTU, LUONG_DONGIA_THUCUOC
                        from ttkd_bsc.bangluong_dongia_202406
                        where ma_nv ='CTV021868';

---
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
			where manv_ptm = 'VNP019959'

            ) ;

select * from ttkd_bsc.ct_bsc_ptm;
select  /*+ parallel(a,8) */  * from ocdm_sys.dwb_acct_actvtn@coevnpt a where ACCS_MTHD_KEY in
(84833073949
,84833061314
,84815953949
,84813183949
,84819223949)
and day_key >=20241101  and ACTV_TYPE ='NEW_ACTV' ;