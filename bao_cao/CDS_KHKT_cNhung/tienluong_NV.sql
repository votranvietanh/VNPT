--tien_thulao NVCT_CTV_NVVT - theo tung` thue bao
select thang,manv_ptm ma_nv,
--							  (select ma_to from ttkd_bsc.nhanvien where manv_hrm=a.manv_ptm and thang =202406) ma_to,
--							  (select ma_pb from ttkd_bsc.nhanvien where manv_hrm=a.manv_ptm and thang =202406) ma_pb,
                              ma_tb,ma_kh,ma_gd,
							  (nvl(dthu_ptm_cdbr,0)) dthu_ptm_cdbr,
							  (nvl(dthu_ptm_vnpts,0)) dthu_ptm_vnpts,
							  dthu_ptm_vnptt AS dthu_ptm_vnptt,
							  (nvl(dthu_ptm_khac,0)) dthu_ptm_cntt,
							  round((nvl(Tong_dthu,0)),0) Tong_dthu,
							  round((nvl(luong_ptm_cdbr,0)) ,0)  luong_ptm_cdbr,
							  round((nvl(luong_ptm_vnpts,0)) ,0) luong_ptm_vnpts,
							  round((nvl(luong_ptm_vnptt,0)) ,0) luong_ptm_vnptt,
							  round((nvl(luong_ptm_khac,0)) ,0) luong_ptm_cntt
                              ,nguon
					from
					(
					    -- nvptm
					    select  manv_ptm,ma_tb,ma_kh,ma_gd,
							     case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_nvptm  end as dthu_ptm_cdbr,
							   case when loaitb_id=20 then doanhthu_dongia_nvptm  end as dthu_ptm_vnpts,
							   case when loaitb_id=21  then doanhthu_dongia_nvptm  end as dthu_ptm_vnptt,
							   case when dichvuvt_id in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_nvptm  end as dthu_ptm_khac,
							   doanhthu_dongia_nvptm Tong_dthu,
							   case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_nvptm  end luong_ptm_cdbr,
							   case when loaitb_id=20  then luong_dongia_nvptm  end luong_ptm_vnpts,
							  (case when loaitb_id=21  then (nvl(LUONG_DONGIA_DNHM_NVPTM,0)+nvl(LUONG_DONGIA_NVPTM,0))* heso_hotro_nvptm end) luong_ptm_vnptt,
							   case when dichvuvt_id in (13,14,15,16) or loaitb_id is null then luong_dongia_nvptm  end luong_ptm_khac
							  ,'nvptm' nguon, thang_tldg_dt thang
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dt = 202406
        union all
					    -- dnhm cua nvhotro (chua phan chia nvien hotro DIGISHOP)
					    select  manv_ptm,ma_tb,ma_kh,ma_gd,
									  case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dnhm * heso_hotro_nvptm end dthu_ptm_cdbr,
									  case when loaitb_id=20 then doanhthu_dongia_dnhm * heso_hotro_nvptm end dthu_ptm_vnpts,
									  null dthu_ptm_vnptt,
									  case when loaitb_id in (38,127) then doanhthu_dongia_dnhm * heso_hotro_nvptm end  dthu_ptm_khac,
									  doanhthu_dongia_dnhm * heso_hotro_nvptm Tong_dthu,
									  case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dnhm_nvptm * heso_hotro_nvptm end luong_ptm_cdbr,
									  case when loaitb_id=20 then luong_dongia_dnhm_nvptm * heso_hotro_nvptm end luong_ptm_vnpts,
							         (case when loaitb_id=21  then (nvl(LUONG_DONGIA_DNHM_NVPTM,0)+nvl(LUONG_DONGIA_NVPTM,0))* heso_hotro_nvptm end) luong_ptm_vnptt,
									  case when loaitb_id in (38,127) then luong_dongia_dnhm_nvptm * heso_hotro_nvptm end luong_ptm_khac
									 ,'dnhm' nguon, thang_tldg_dnhm
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dnhm = 202406
		union all
					    -- dnhm cua nvptm
					    select  manv_hotro,ma_tb,ma_kh,ma_gd,
							      case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dnhm * heso_hotro_nvhotro  end dthu_ptm_cdbr,
									   case when loaitb_id=20 then doanhthu_dongia_dnhm * heso_hotro_nvhotro  end dthu_ptm_vnpts,
									  null dthu_ptm_vnptt,
									   case when loaitb_id in (38,127) then doanhthu_dongia_dnhm * heso_hotro_nvhotro  end  dthu_ptm_khac,
									   doanhthu_dongia_dnhm * heso_hotro_nvhotro Tong_dthu,
									   case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dnhm_nvptm * heso_hotro_nvhotro  end luong_ptm_cdbr,
									   case when loaitb_id=20 then luong_dongia_dnhm_nvptm * heso_hotro_nvhotro  end luong_ptm_vnpts,
									  case when loaitb_id=21  then (nvl(LUONG_DONGIA_DNHM_NVPTM,0)+nvl(LUONG_DONGIA_NVPTM,0)) end luong_ptm_vnptt,
									   case when loaitb_id in (38,127) then luong_dongia_dnhm_nvptm * heso_hotro_nvhotro  end luong_ptm_khac
									 ,'dnhm_2' nguon, thang_tldg_dnhm
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dnhm = 202406 and tyle_hotro is null and tyle_am is null
		union all
					    -- nv dai
					    select  manv_tt_dai,ma_tb,ma_kh,ma_gd,
							     case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dai  end dthu_ptm_cdbr,
							   case when loaitb_id=20  then doanhthu_dongia_dai  end dthu_ptm_vnpts,
							   case when loaitb_id=21  then doanhthu_dongia_dai  end dthu_ptm_vnptt,
							   case when dichvuvt_id  in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_dai  end dthu_ptm_khac,
							   doanhthu_dongia_dai Tong_dthu,
							   case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dai  end luong_ptm_cdbr,
							   case when loaitb_id=20  then luong_dongia_dai  end luong_ptm_vnpts,
							 case when loaitb_id=21  then (nvl(LUONG_DONGIA_DNHM_NVPTM,0)+nvl(LUONG_DONGIA_NVPTM,0)) end luong_ptm_vnptt,
							   case when (dichvuvt_id  in (13,14,15,16)  or dichvuvt_id is null) then luong_dongia_dai  end luong_ptm_khac
							,'nvtt dai' nguon, thang_tldg_dt_dai
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dt_dai = 202406
		union all
					    -- nv ho tro cua PGP
					     select  manv_hotro,ma_tb,ma_kh,ma_gd,
							   case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_nvhotro  end dthu_ptm_cdbr,
							   case when loaitb_id=20  then doanhthu_dongia_nvhotro  end dthu_ptm_vnpts,
							   case when loaitb_id=21  then doanhthu_dongia_nvhotro  end dthu_ptm_vnptt,
							   case when dichvuvt_id  in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_nvhotro  end dthu_ptm_khac,
							   doanhthu_dongia_nvhotro Tong_dthu,
							   case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_nvhotro  end luong_ptm_cdbr,
							   case when loaitb_id=20  then luong_dongia_nvhotro  end luong_ptm_vnpts,
							 case when loaitb_id=21  then (nvl(LUONG_DONGIA_DNHM_NVPTM,0)+nvl(LUONG_DONGIA_NVPTM,0)) end luong_ptm_vnptt,
							   case when (dichvuvt_id  in (13,14,15,16)  or dichvuvt_id is null) then luong_dongia_nvhotro  end luong_ptm_khac
							,'nvtt gioithieu' nguon, thang_tldg_dt_nvhotro
					    from ttkd_bsc.ct_bsc_ptm a
					    where thang_tldg_dt_nvhotro = 202406
									and not exists (select 1 from ttkd_bsc.nhanvien where thang = 202406 and ma_pb='VNP0702600' and ma_nv = a.manv_hotro)
			        ) a
			where manv_ptm is not null and manv_ptm='VNP016999'
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
			where manv_ptm = 'VNP024921'

            ) ;

--code aHoc
select * from ttkd_bsc.tonghop_dtdongia_ptm_202406 where ma_nv ='VNP016999';

select *
from
					(
					    -- nvptm
					    select  manv_ptm,
							  sum(case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_nvptm end) dthu_ptm_cdbr,
							  sum(case when loaitb_id=20 then doanhthu_dongia_nvptm end) dthu_ptm_vnpts,
							  sum(case when loaitb_id=21  then doanhthu_dongia_nvptm end) dthu_ptm_vnptt,
							  sum(case when dichvuvt_id in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_nvptm end) dthu_ptm_khac,
							  sum(doanhthu_dongia_nvptm) Tong_dthu,
							  sum(case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_nvptm end) luong_ptm_cdbr,
							  sum(case when loaitb_id=20  then luong_dongia_nvptm end) luong_ptm_vnpts,
							  0 luong_ptm_vnptt,
							  sum(case when dichvuvt_id in (13,14,15,16) or loaitb_id is null then luong_dongia_nvptm end) luong_ptm_khac
							  ,'nvptm' nguon, thang_tldg_dt thang
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dt = 202406
					    group by manv_ptm, thang_tldg_dt

		union all
					    -- dnhm cua nvhotro (chua phan chia nvien hotro DIGISHOP)
					    select  manv_ptm,
									  sum(case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dnhm * heso_hotro_nvptm end) dthu_ptm_cdbr,
									  sum(case when loaitb_id=20 then doanhthu_dongia_dnhm * heso_hotro_nvptm end) dthu_ptm_vnpts,
									  null dthu_ptm_vnptt,
									  sum(case when loaitb_id in (38,127) then doanhthu_dongia_dnhm * heso_hotro_nvptm end)  dthu_ptm_khac,
									  sum(doanhthu_dongia_dnhm * heso_hotro_nvptm) Tong_dthu,
									  sum(case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dnhm_nvptm * heso_hotro_nvptm end) luong_ptm_cdbr,
									  sum(case when loaitb_id=20 then luong_dongia_dnhm_nvptm * heso_hotro_nvptm end) luong_ptm_vnpts,
									  null luong_ptm_vnptt,
									  sum(case when loaitb_id in (38,127) then luong_dongia_dnhm_nvptm * heso_hotro_nvptm end) luong_ptm_khac
									 ,'dnhm' nguon, thang_tldg_dnhm
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dnhm = 202406
					    group by manv_ptm, thang_tldg_dnhm
		union all
					     -- dnhm cua nvptm (chua phan chia nvien tiep thi DIGISHOP)
					    select  manv_hotro,
									  sum(case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dnhm * heso_hotro_nvhotro end) dthu_ptm_cdbr,
									  sum(case when loaitb_id=20 then doanhthu_dongia_dnhm * heso_hotro_nvhotro end) dthu_ptm_vnpts,
									  null dthu_ptm_vnptt,
									  sum(case when loaitb_id in (38,127) then doanhthu_dongia_dnhm * heso_hotro_nvhotro end)  dthu_ptm_khac,
									  sum(doanhthu_dongia_dnhm * heso_hotro_nvhotro) Tong_dthu,
									  sum(case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dnhm_nvptm * heso_hotro_nvhotro end) luong_ptm_cdbr,
									  sum(case when loaitb_id=20 then luong_dongia_dnhm_nvptm * heso_hotro_nvhotro end) luong_ptm_vnpts,
									  null luong_ptm_vnptt,
									  sum(case when loaitb_id in (38,127) then luong_dongia_dnhm_nvptm * heso_hotro_nvhotro end) luong_ptm_khac
									 ,'dnhm' nguon, thang_tldg_dnhm
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dnhm = 202406 and tyle_hotro is null and tyle_am is null
					    group by manv_hotro, thang_tldg_dnhm

		union all
					    -- nv dai
					    select  manv_tt_dai,
							  sum(case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_dai end) dthu_ptm_cdbr,
							  sum(case when loaitb_id=20  then doanhthu_dongia_dai end) dthu_ptm_vnpts,
							  sum(case when loaitb_id=21  then doanhthu_dongia_dai end) dthu_ptm_vnptt,
							  sum(case when dichvuvt_id  in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_dai end) dthu_ptm_khac,
							  sum(doanhthu_dongia_dai) Tong_dthu,
							  sum(case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_dai end) luong_ptm_cdbr,
							  sum(case when loaitb_id=20  then luong_dongia_dai end) luong_ptm_vnpts,
							 0 luong_ptm_vnptt,
							  sum(case when (dichvuvt_id  in (13,14,15,16)  or dichvuvt_id is null) then luong_dongia_dai end) luong_ptm_khac
							,'nvtt dai' nguon, thang_tldg_dt_dai
					    from ttkd_bsc.ct_bsc_ptm
					    where thang_tldg_dt_dai = 202406
					    group by manv_tt_dai, thang_tldg_dt_dai


		union all
					    -- nv gioi thieu DIGI, SHOP, ngoai tru  phong GP
					    select  manv_hotro,
							  sum(case when dichvuvt_id not in (2,13,14,15,16) then doanhthu_dongia_nvhotro end) dthu_ptm_cdbr,
							  sum(case when loaitb_id=20  then doanhthu_dongia_nvhotro end) dthu_ptm_vnpts,
							  sum(case when loaitb_id=21  then doanhthu_dongia_nvhotro end) dthu_ptm_vnptt,
							  sum(case when dichvuvt_id  in (13,14,15,16) or dichvuvt_id is null then doanhthu_dongia_nvhotro end) dthu_ptm_khac,
							  sum(doanhthu_dongia_nvhotro) Tong_dthu,
							  sum(case when dichvuvt_id not in (2,13,14,15,16) then luong_dongia_nvhotro end) luong_ptm_cdbr,
							  sum(case when loaitb_id=20  then luong_dongia_nvhotro end) luong_ptm_vnpts,
							 0 luong_ptm_vnptt,
							  sum(case when (dichvuvt_id  in (13,14,15,16)  or dichvuvt_id is null) then luong_dongia_nvhotro end) luong_ptm_khac
							,'nvtt gioithieu' nguon, thang_tldg_dt_nvhotro
					    from ttkd_bsc.ct_bsc_ptm a
					    where thang_tldg_dt_nvhotro = 202406
									and not exists (select 1 from ttkd_bsc.nhanvien where thang = 202406 and ma_pb='VNP0702600' and ma_nv = a.manv_hotro)
					    group by manv_hotro, thang_tldg_dt_nvhotro



			    ) a

			left join ttkd_bsc.nhanvien nv on nv.thang = a.thang and nv.ma_nv = a.manv_ptm
			where manv_ptm is not null and manv_ptm ='VNP016999';