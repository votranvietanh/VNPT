---ptm cua kenh chuoi = 6 thi thang_tldg = thang_ptm +1
da imp tgdd,fpt thang 10
        insert into ttkd_bct.hocnq_cp_nhancong_hoahong(THANG, THANG_TLDG, MA_TB, TEN_KIEULD, LOAIHINH_TB, TENNV_PTM, KENH_PTM, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, NGUON)
;
        select thang_ptm,thang_ptm+1,MA_TB,'phat trien moi','VNPTT',NGUON,'Kênh Chuỗi',  NOVAT,NOVAT,'va_kenh_chuoi'
                from
             (
                select to_char(thang) thang_ptm,MA_TB, LOAI_SIM, GIA_SIM_TRANG, GOI_CUOC, GIA_GOI, DTHU_HMM, DTHU_KIT, NGAY_KH, CHI_BCKH,(CHI_BCKH*1.08) as novat,'FPT' nguon
                from FPT_BCKH_PTM
                where thang = 202409
            union all
                SELECT thang,MA_TB, LOAI_SIM, GIA_SIM_TRANG, MA_KIT, GIA_GOI, DTHU_HMM, DTHU_KIT, NGAY_KH, CHI_BCKH,(CHI_BCKH*1.08) novat ,'TGDD' nguon
                from TGDD_BCKH_PTM
                where thang = 202409
            )
        ;

    insert into ttkd_bct.hocnq_cp_nhancong_hoahong(THANG, THANG_TLDG, MA_TB, TEN_TB, MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM, MANV_PTM, TENNV_PTM, KENH_PTM,
PHONG_QL, DATCOC_CSD, SOTHANG_DC, DTHU_GOI, DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON)

select THANG_NGHIEMTHU,THANG_NGHIEMTHU,ma_tb,ten_tb,ma_gd,'','C. CNTT,GTGT',dich_vu,(select x.ma_pb from dm_pbh x where a.phong_ql = x.ten_pb)
, ma_daily manv_ptm,'','Đại lý pháp nhân',
  (select x.ma_pb from dm_pbh x where a.phong_ql = x.ten_pb),'','',DTHU_NOVAT,DTHU_NOVAT,DTHU_NOVAT,0,0,'imp_ketoan'
from hoahong_imp_cntt_new a where THANG_NGHIEMTHU = 202410
;
insert into khkt_bc_hoahong_2(THANG_PTM, MA_GD,MA_TB, DICHVU_VT, TEN_TB, NGAY_BBBG,MA_PB, TEN_PB,MANV_PTM, TENNV_PTM,DTHU_GOI, THANG_TLDG_DT
        ,NHOM_TIEPTHI, LOAI_THULAO, LUONG_DONGIA_NVPTM, LUONG_DONGIA_NVHOTRO,nguon,DICHVUVT_ID, LOAITB_ID)
select THANG_NGHIEMTHU,ma_gd,ma_tb,dich_vu,ten_tb,ngay_nghiem_thu
     ,(select x.ma_pb from dm_pbh x where a.phong_ql = x.ten_pb) ma_pb
    ,PHONG_QL
,ma_daily,ten_daily,DTHU_NOVAT,THANG_NGHIEMTHU,5,'hoahong',hoa_hong,0,'ketoan'
,(select  x.DICHVUVT_ID from css_hcm.loaihinh_tb x where a.dich_vu = x.loaihinh_tb)
,(select  loaitb_id from css_hcm.loaihinh_tb x where a.dich_vu = x.loaihinh_tb)
from hoahong_imp_cntt a
;

-----PTTT. thang_ptm+2=thang_tldg
        insert into ttkd_bct.hocnq_cp_nhancong_hoahong(thang,thang_tldg,ma_tb,ten_kieuld,loaihinh_tb,phong_ptm,manv_ptm,tennv_ptm,kenh_ptm,tienluong_daily,tienluong_pbh_ptm,tienluong_pql,nguon)
--
        select THANG_PTM, THANG_TLDG,MA_TB,'phattrienmoi','VNPTS','VNP0700800',manv_ptm,manv_ptm,'Đại lý pháp nhân', LUONG,round(LUONG/6,2),round(LUONG/6*5,2),'ĐLCN-PTTT'
        from chi_hoahong
        where thang_tldg = 202410
        ;

---insert xong can` check lai kenh_ptm xem ? neu co manv_ptm thi co kenh_ptm, update them phong_ql
        insert into ttkd_bct.hocnq_cp_nhancong_hoahong(THANG, THANG_TLDG, MA_TB, TEN_TB, MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM, MANV_PTM, TENNV_PTM, KENH_PTM, PHONG_QL, DATCOC_CSD, SOTHANG_DC, DTHU_GOI, DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON)

      select * from (select thang_ptm
                            , thang_tldg_dt
                            , ma_tb
                            , ten_tb
                            , ma_gd
                            , tenkieu_ld
                            , (select nhomdv from ttkd_bsc.dm_loaihinh_hsqd where loaitb_id = a.loaitb_id) nhom_dichvu
                            , dich_vu
                            , ma_pb
                            , nvl(MA_NGUOIGT,manv_ptm) as manv_ptm
                            , ''                                                                           tennv_ptm
                            , case
                                when nvl(MA_NGUOIGT,manv_ptm) in (select distinct ma_daily  from ttkd_bsc.dm_daily_khdn where thang=202410)
                                    and dichvuvt_id in (13,14,15,16)
                                then 'Đại Lý CNTT' else
                               (select y.TENNHOM_TAT
                               from ttkd_bsc.nhanvien x,
                                    ttkd_bsc.dm_nhomld y
                               where x.nhomld_id = y.nhomld_id
                                 and x.thang = a.thang_tldg_dt
                                 and ma_nv = a.manv_ptm)    end as                                                KENH_PTM
                            , case
                                  when loaitb_id not in (20, 149)
                                      then (select mapb_ql
                                            from ttkd_bct.db_thuebao_ttkd
                                            where loaitb_id <> 20
                                              and thuebao_id = a.thuebao_id)
                                  else (select mapb_ql
                                        from ttkd_bct.db_thuebao_ttkd
                                        where loaitb_id = 20
                                          and ma_tt = a.ma_kh
                                          and ma_tb = a.ma_tb)
                end                                                                                        phong_ql
                            , datcoc_csd
                            , sothang_dc
                            , dthu_goi
                            , case
                                  when manv_tt_dai is not null then doanhthu_dongia_nvptm * 2
                                  else doanhthu_dongia_nvptm end                                           doanhthu_dongia
                            , case
                                  when manv_tt_dai is not null then luong_dongia_nvptm * 2
                                  else luong_dongia_nvptm end                                              luong_dongia
                            , round(
                    case when manv_tt_dai is not null then luong_dongia_nvptm * 2 else luong_dongia_nvptm end / 6 *
                    1)                                                                                     luong_phong_ptm
                            , round(
                    case when manv_tt_dai is not null then luong_dongia_nvptm * 2 else luong_dongia_nvptm end / 6 *
                    5)                                                                                     luong_phong_ql
                            , 'va_ct_bsc_ptm'                                                              nguon
                       from ttkd_bsc.ct_bsc_ptm a
                       where thang_tldg_dt = 202410
--                          and (doanhthu_dongia_nvptm <> 0 and luong_dongia_nvptm <> 0)
                         and a.manv_ptm in (select distinct ma_nv
                                    from ttkd_bsc.nhanvien
                                    where nhomld_id <> 4
                                      and ma_nv = a.manv_ptm
                                      ) -- ko tinh DLCN
                         and (loaitb_id <> 21 or loaitb_id is null)
                         and (
                           ma_pb in ('VNP0701100', 'VNP0701200', 'VNP0701300', 'VNP0701400', 'VNP0701500', 'VNP0701600',
                                     'VNP0701800', 'VNP0702100', 'VNP0702200', 'VNP0702300', 'VNP0702400', 'VNP0702500')
                               or ma_pb like 'HCM%')
                       union all
                       select thang_ptm
                            , thang_tldg_dnhm
                            , ma_tb
                            , ten_tb
                            , ma_gd
                            , tenkieu_ld
                            , (select nhomdv from ttkd_bsc.dm_loaihinh_hsqd where loaitb_id = a.loaitb_id) nhom_dichvu
                            , dich_vu
                            , ma_pb
                            , nvl(MA_NGUOIGT,manv_ptm) as manv_ptm
                            , ''                                                                           tennv_ptm
                            , case
                                when nvl(MA_NGUOIGT,manv_ptm) in (select distinct ma_daily  from ttkd_bsc.dm_daily_khdn where thang=202410)
                                    and dichvuvt_id in (13,14,15,16)
                                then 'Đại Lý CNTT' else
                           (select y.TENNHOM_TAT
                               from ttkd_bsc.nhanvien x,
                                    ttkd_bsc.dm_nhomld y
                               where x.nhomld_id = y.nhomld_id
                                 and x.thang = a.thang_tldg_dt
                                 and ma_nv = a.manv_ptm)     end as                                               KENH_PTM

                            , case
                                  when loaitb_id not in (20, 149)
                                      then (select mapb_ql
                                            from ttkd_bct.db_thuebao_ttkd
                                            where loaitb_id <> 20
                                              and thuebao_id = a.thuebao_id)
                                  else (select mapb_ql
                                        from ttkd_bct.db_thuebao_ttkd
                                        where loaitb_id = 20
                                          and ma_tt = a.ma_kh
                                          and ma_tb = a.ma_tb)
                           end                                                                             phong_ql
                            , datcoc_csd
                            , sothang_dc
                            , dthu_goi
                            , doanhthu_dongia_dnhm
                            , luong_dongia_dnhm_nvptm
                            , luong_dongia_dnhm_nvptm
                            , null                                                                         luong_ql
                            , 'va_ct_bsc_ptm'                                                              nguon
                       from ttkd_bsc.ct_bsc_ptm a
                       where thang_tldg_dnhm = 202410
--                          and (doanhthu_dongia_dnhm <> 0 and luong_dongia_dnhm_nvptm <> 0)
                         and a.manv_ptm in (select distinct ma_nv
                                    from ttkd_bsc.nhanvien
                                    where nhomld_id <> 4 and ma_nv = a.manv_ptm)
                         and (loaitb_id <> 21 or loaitb_id is null)
                         and (
                           ma_pb in ('VNP0701100', 'VNP0701200', 'VNP0701300', 'VNP0701400', 'VNP0701500', 'VNP0701600',
                                     'VNP0701800', 'VNP0702100', 'VNP0702200', 'VNP0702300', 'VNP0702400', 'VNP0702500')
                               or ma_pb like 'HCM%')
                               )
        ;
        ; -- check xem kenh_ptm null ko null thì chạy dòng dưới
     update ttkd_bct.hocnq_cp_nhancong_hoahong a
        set kenh_ptm = (select y.TENNHOM_TAT
                               from ttkd_bsc.nhanvien x,
                                    ttkd_bsc.dm_nhomld y
                               where x.nhomld_id = y.nhomld_id
                                 and x.thang = a.thang_tldg
                                 and ma_nv = a.manv_ptm)
        where thang_tldg = 202408 and nguon = 'va_ct_bsc_ptm' and kenh_ptm is null;
-----PTM_VNPTT;
 insert into ttkd_bct.hocnq_cp_nhancong_hoahong(THANG, THANG_TLDG, MA_TB
    , TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM
    , MANV_PTM,  KENH_PTM
    ,  DATCOC_CSD, SOTHANG_DC
    , DTHU_GOI, DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON)

    select a.thang_ptm, a.thang_ptm, ma_tb,tenkieu_ld || '- mua gói' tenkieuld,'Di động' dv_vt
           , a.dich_vu, a.MAPB_HOTRO, a.MANV_HOTRO,
           (select x.TEN_NHOM from ttkd_bsc.dm_nhomld x where x.nhomld_id = b.nhomld_id) kenh_ptm
            ,  a.DATCOC_CSD,SOTHANG_DC, DOANHTHU_DONGIA_NVHOTRO,DOANHTHU_DONGIA_NVHOTRO,
           0, LUONG_DONGIA_NVHOTRO,
           0,'VNPTT'
    from ttkd_bsc.ct_bsc_ptm a
    left join TTKD_BSC.nhanvien b on b.thang = a.thang_Ptm and a.MANV_HOTRO = b.ma_nv
    where thang_ptm = 202410
      and loaitb_id = 21
      and LUONG_DONGIA_NVHOTRO >0
UNION ALL
      select a.thang_ptm, a.thang_ptm, ma_tb,tenkieu_ld,'Di động' dv_vt, a.dich_vu, a.ma_pb, manv_ptm,
           (select x.TEN_NHOM from ttkd_bsc.dm_nhomld x where x.nhomld_id = b.nhomld_id) kenh_ptm
            ,  CAST( '' AS number ),CAST( '' AS number ), CAST( '' AS number ),DOANHTHU_DONGIA_DNHM,
           0, LUONG_DONGIA_DNHM_NVPTM,
           0,'VNPTT'
    from ttkd_bsc.ct_bsc_ptm a
    left join TTKD_BSC.nhanvien b on b.thang = a.thang_Ptm and a.manv_ptm = b.ma_nv
    where thang_ptm = 202410
      and loaitb_id = 21
        and LUONG_DONGIA_DNHM_NVPTM > 0
    ;
--     insert into ttkd_bct.hocnq_cp_nhancong_hoahong(THANG, THANG_TLDG, MA_TB, TEN_TB
--     , MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM
--     , MANV_PTM, TENNV_PTM, KENH_PTM
--     , PHONG_QL, DATCOC_CSD, SOTHANG_DC
--     , DTHU_GOI, DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON)

-- select 202408, 202408, ma_tb,''
--     , '',case when TENKIEU_LD = 'ptm' then 'Phát triển mới - hòa mạng'
--                     when TENKIEU_LD = 'ptm_goi' then 'Phát triển mới - mua gói' else '' end, '','VNPTT', ma_pb
--     , manv_ptm, '', b.TENNHOM_TAT
--     ,'','',''
--     , DTHU_GOI_GOC, DTHU_GOI_GOC,  0,  case when  TENKIEU_LD = 'ptm_goi' and kenh_noibo is null then 0 else nvl(LUONG_DONGIA_NVPTM,0)+ nvl(LUONG_DONGIA_DNHM_NVPTM,0)  end dg,
--     case when TENKIEU_LD = 'ptm_goi' and kenh_noibo is null then round(NVL(DONGIA_KK,0) * NVL(DTHU_GOI_GOC,0),0) else 0 end dg_kenhngoai
--     ,'VNPTT__'||nguon
-- from ttkd_bsc.ct_bsc_ptm a left join ttkd_bsc.dm_nhomld b on a.NHOM_TIEPTHI = b.NHOMLD_ID
-- where thang_ptm=202408 and loaitb_id=21 and thoadk_dg=1 ;

---man--HHBG - hoahong
    insert into ttkd_bct.hocnq_cp_nhancong_hoahong(THANG, THANG_TLDG, MA_TB, TEN_TB
    , MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM
    , MANV_PTM, TENNV_PTM, KENH_PTM
    , PHONG_QL, DATCOC_CSD, SOTHANG_DC
    , DTHU_GOI, DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON)
;
select THANG, THANG, '', ''
    , '' , 'Điểm bán', '', 'VNPTT'
    ,      case when PHONG_BAN_HANG = 'Phòng Bán hàng KV Bình Chánh' then 'VNP0701100'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Chợ Lớn' then 'VNP0701200'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Củ Chi' then 'VNP0702200'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Gia định' then 'VNP0701300'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Nam Sài Gòn' then 'VNP0701400'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Sài Gòn' then 'VNP0701500'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Thủ Đức' then 'VNP0701800'
                when PHONG_BAN_HANG = 'Phòng Bán hàng KV Tân Bình' then 'VNP0701600' else '' end
    , MA_DIEM_BAN, TEN_DIEM_BAN ,  'Đại lý'
    , '', '', ''
    , 0,0, TIEN_KHUYEN_KHICH, TIEN_KHUYEN_KHICH, 0, 'VNPTT_228_2'
from manpn.thulao_ndth_dachi@ttkddbbk2
where thang = 202410;

 insert into ttkd_bct.hocnq_cp_nhancong_hoahong(thang,thang_tldg,ma_tb,TEN_KIEULD,NHOM_DICHVU,loaihinh_tb,phong_ptm,manv_ptm,
    kenh_ptm,DATCOC_CSD,DTHU_GOI,DTHU_TLDG,TIENLUONG_DAILY,TIENLUONG_PBH_PTM,TIENLUONG_PQL,nguon
)

   select thang,thang,SO_THUE_BAO,'Thuê bao PTM','Di động','VNPTT'
              ,case when PBHKV = 'Phòng Bán hàng KV Bình Chánh' then 'VNP0701100'
                    when PBHKV = 'Phòng Bán hàng KV Chợ Lớn' then 'VNP0701200'
                    when PBHKV = 'Phòng Bán hàng KV Củ Chi' then 'VNP0702200'
                    when PBHKV = 'Phòng Bán hàng KV Gia định' then 'VNP0701300'
                    when PBHKV = 'Phòng Bán hàng KV Nam Sài Gòn' then 'VNP0701400'
                    when PBHKV = 'Phòng Bán hàng KV Sài Gòn' then 'VNP0701500'
                    when PBHKV = 'Phòng Bán hàng KV Thủ Đức' then 'VNP0701800'
                    when PBHKV = 'Phòng Bán hàng KV Hóc Môn' then 'VNP0702100'
                    when PBHKV = 'Phòng Bán hàng KV Gia Định' then 'VNP0701300'
                    when PBHKV = 'Phòng Phát Triển Thị Trường' then 'VNP0700800'
                    when PBHKV = 'Phòng Bán hàng KV Tân Bình' then 'VNP0701600' else ''
       end as phong_ptm
            ,so_eload,'Đại lý',GIA_GOI_CUOC,GIA_GOI_CUOC,GIA_GOI_CUOC,TONG_THU_LAO_TRUOC_THUE,TONG_THU_LAO_TRUOC_THUE,0,'man_VNPTT_HHBG'
            from manpn.thulao_hhbg_dachi@ttkddbbk2
            where thang = 202410;
-----ins GHTT nhuY:
    insert into  vietanhvh.khkt_bc_hoahong
    ;
    with ttin as (
        select thang, thuebao_id, hdtb_id, ma_Gd,ngay_Tt, row_number() over (partition by a.thuebao_id, a.thang order by tien_thanhtoan desc ) rnk
        from ttkd_Bsc.nhuy_Ct_Bsc_ipcc_obghtt a --on a.thuebao_id = e.thuebao_id and A.THANG = E.THANG AND rownum = 1
    )
    select
        202407 , e.ma_gd, b.ma_kh,a.thuebao_id, a.ma_tb, 'B?ng r?ng c? ??nh', k.ten_kieuld, c.ten_tb, d.diachi_ld,e.ngay_tt, nv.ma_pb, nv.ten_pb, nv.ma_to, nv.ten_to, nv.ma_nv,
        nv.ten_nv, a.sothang_dc, a.DTHU, null, null, 202407,null, nv.nhomld_id, 'hoahong', tien_thuyetphuc*heso_Chuky*heso_dichvu, tien_xuathd*heso_Chuky*heso_dichvu,
        'ghtt_nhuy',4,c.loaitb_id
    from ttkd_Bsc.ct_dongia_tratruoc a
        left join css_hcm.db_thuebao c on a.thuebao_id = C.thuebao_id
        left join css_hcm.db_khachhang b on c.khachhang_id =b.khachhang_Id
        left join css_hcm.db_Thuebao_sub d on a.thuebao_id =d.thuebao_id
        left join ttin e on a.thuebao_id = e.thuebao_id and A.THANG = E.THANG AND rnk = 1
        left join css_hcm.hd_thuebao hd on e.hdtb_id = hd.hdtb_id
        left join css_hcm.kieu_ld k on hd.kieuld_id = k.kieuld_id
        join ttkd_Bsc.nhanvien nv on a.ma_Nv =nv.ma_nv and nv.thang = 202407 and nv.donvi = 'TTKD'
    where A.thang = 202405 and loai_tinh = 'DONGIATRA_OB'
    ;
--man_HHBG
    insert into vietanhvh.khkt_bc_hoahong(THANG_PTM, MA_GD, MA_KH, THUEBAO_ID, MA_TB, DICHVU_VT, TENKIEU_LD
    , TEN_TB, DIACHI_LD, NGAY_BBBG, MA_PB, TEN_PB, MA_TO, TEN_TO, MANV_PTM, SOTHANG_DC
    , TENNV_PTM, DATCOC_CSD, DTHU_DNHM, DTHU_GOI, THANG_TLDG_DT, SL_MAILING, NHOM_TIEPTHI
    , LOAI_THULAO, LUONG_DONGIA_NVPTM, LUONG_DONGIA_NVHOTRO, NGUON,DICHVUVT_ID,LOAITB_ID)
;
    select THANG, '', '', cast(null as number), SO_THUE_BAO, 'VNPTT','Đặt mới' , '', '', THOI_GIAN_GIAO_DICH
        --, PBHKV
        , case when PBHKV = 'Phòng Bán hàng KV Bình Chánh' then 'VNP0701100'
                    when PBHKV = 'Phòng Bán hàng KV Chợ Lớn' then 'VNP0701200'
                    when PBHKV = 'Phòng Bán hàng KV Củ Chi' then 'VNP0702200'
                    when PBHKV = 'Phòng Bán hàng KV Gia định' then 'VNP0701300'
                    when PBHKV = 'Phòng Bán hàng KV Nam Sài Gòn' then 'VNP0701400'
                    when PBHKV = 'Phòng Bán hàng KV Sài Gòn' then 'VNP0701500'
                    when PBHKV = 'Phòng Bán hàng KV Thủ Đức' then 'VNP0701800'
                    when PBHKV = 'Phòng Bán hàng KV Hóc Môn' then 'VNP0702100'
                    when PBHKV = 'Phòng Bán hàng KV Gia Định' then 'VNP0701300'
                    when PBHKV = 'Phòng Phát Triển Thị Trường' then 'VNP0700800'
                    when PBHKV = 'Phòng Bán hàng KV Tân Bình' then 'VNP0701600' else '' end
            , case when PBHKV = 'Phòng Bán hàng KV Bình Chánh' then 'Phòng Bán Hàng Khu Vực Bình Chánh'
                    when PBHKV = 'Phòng Bán hàng KV Chợ Lớn' then 'Phòng Bán Hàng Khu Vực Chợ Lớn'
                    when PBHKV = 'Phòng Bán hàng KV Củ Chi' then 'Phòng Bán Hàng Khu Vực Củ Chi'
                    when PBHKV = 'Phòng Bán hàng KV Gia định' then 'Phòng Bán Hàng Khu Vực Gia Định'
                    when PBHKV = 'Phòng Bán hàng KV Nam Sài Gòn' then 'Phòng Bán Hàng Khu Vực Nam Sài Gòn'
                    when PBHKV = 'Phòng Bán hàng KV Sài Gòn' then 'Phòng Bán Hàng Khu Vực Sài Gòn'
                    when PBHKV = 'Phòng Bán hàng KV Thủ Đức' then 'Phòng Bán Hàng Khu Vực Thủ Đức'
                    when PBHKV = 'Phòng Bán hàng KV Hóc Môn' then 'Phòng Bán Hàng Khu Vực Hóc Môn'
                    when PBHKV = 'Phòng Bán hàng KV Gia Định' then 'Phòng Bán Hàng Khu Vực Gia Định'
                    when PBHKV = 'Phòng Phát Triển Thị Trường' then 'Phòng Phát Triển Thị Trường'
                    when PBHKV = 'Phòng Bán hàng KV Tân Bình' then 'Phòng Bán Hàng Khu Vực Tân Bình' else '' end
        , '','', to_char(SO_ELOAD), '', ten_eload,  GIA_THUC_TRU, 0, GIA_GOI_CUOC, 202407, ''
         , case when LOAI_DIEM_BAN = 'DNUQ' or LOAI_DIEM_BAN= 'COKYVINA' then 7 else 5 end,  'HoaHong' as LOAI_THULAO, TONG_THU_LAO_TRUOC_THUE, 0, 'man_VNPTT_HHBG'
    ,2,21
    from manpn.thulao_hhbg_dachi@ttkddbbk2
    WHERE THANG >= 202407;

---chu Khanh insert thi dua KK
    Insert into ttkd_bct.hocnq_cp_nhancong_hoahong@ttkddb
(   THANG, THANG_TLDG, MA_TB, TEN_TB, MA_GD
    , TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM, MANV_PTM, TENNV_PTM, KENH_PTM, PHONG_QL, TIENLUONG_PBH_PTM, NGUON )
(
    Select a.THANG, a.THANG THANG_TLDG, a.MA_TB, a.TEN_TB, y.MA_GD
           , (Select TEN_KIEULD from css_hcm.kieu_ld where kieuld_id = x.kieuld_id)TEN_KIEULD
           , (Select TEN_DVVT From css_hcm.dichvu_vt Where DICHVUVT_ID = x.DICHVUVT_ID)NHOM_DICHVU
           , (select loaihinh_tb from css_hcm.loaihinh_tb Where loaitb_id = x.loaitb_id)LOAIHINH_TB
           , a.ma_pb PHONG_PTM, a.MA_NV_CTV MANV_PTM, a.TEN_NV_CTV TENNV_PTM, a.LOAI_NV_CTV KENH_PTM
           , (Select ma_pb_hrm From ttkd_bct.phongbanhang Where hieuluc = 1 and pbh_id = db.pbh_ql_id)PHONG_QL
           , a.SOTIEN_KK TIENLUONG_PBH_PTM, 'KHANH' NGUON
    From khanhtdt_ttkd.CT_TDBH_MESHCAM a
    Left join ttkd_bct.db_thuebao_ttkd db On a.MA_TB_FIBER = db.ma_tb
    Left join css_hcm.hd_thuebao x On a.hdtb_id = x.hdtb_id
    Left join css_hcm.hd_khachhang y On x.hdkh_id = y.hdkh_id
    Where a.thang = 202407 and a.SOTIEN_KK > 0
);

        Insert Into ttkd_bct.hocnq_cp_nhancong_hoahong
        (   THANG, THANG_TLDG, MA_TB, TEN_KIEULD, LOAIHINH_TB, PHONG_PTM, TENNV_PTM, KENH_PTM, DTHU_GOI, DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON   )
        (   Select THANG, thang_dh THANG_TLDG, SODT_KH MA_TB
                   , ('Thuê bao PTM')TEN_KIEULD
                   , (Case when loaidichvu = 'Di động' then 'VNPTT'
                           when loaidichvu like '%Truyền hình' then 'BRCD_MYTV'
                      end)LOAIHINH_TB
                   , ma_pb PHONG_PTM
                   , (Case when ten_diem_ban is not null then ten_diem_ban else ten_ctv end)TENNV_PTM
                   , (Case when ten_diem_ban is not null then 'Điểm bán' when ten_ctv is not null then 'CTV XHH' end)KENH_PTM
                   , dh_doanhthu DTHU_GOI
                   , dh_doanhthu DTHU_TLDG
                   , (hoahong) TIENLUONG_DAILY, (hoahong)TIENLUONG_PBH_PTM, (null)TIENLUONG_PQL, 'KHANH' NGUON
            From (
                    Select a.*
                           , (Select ma_pb_hrm From ttkd_bct.phongbanhang Where hieuluc = 1 and pbh_id = a.pbh_id)ma_pb
                           , dthu.dh_doanhthu
                           --, (Case when b.PBHKV is not null then b.PBHKV when c.PBHKV is not null then c.PBHKV when d.PBHKV is not null then d.PBHKV else e.PBHKV end)PBHKV
                    From (
                            Select thang, ma_donhang, loaidichvu, thang_dh, thang_kh, SODT_KH, ten_ctv, ten_diem_ban, sum(hoahong*0.9)hoahong, pbh_id
                            From khanhtdt_ttkd.CTVXHH_CHOTT_KHONGVI_2024 a
                            Where thang = 202407 and (ten_diem_ban is null or ten_diem_ban not like '%COKYVINA%')
                            Group by thang, ma_donhang, loaidichvu, thang_dh, thang_kh, SODT_KH, ten_ctv, ten_diem_ban, pbh_id
                         ) a
                    Left join (Select distinct ma_donhang, dh_doanhthu From khanhtdt_ttkd.IMP_CTVXHH_PHAICHI_2024) dthu On a.ma_donhang = dthu.ma_donhang
                 )
        );
        Insert Into ttkd_bct.hocnq_cp_nhancong_hoahong
        (   THANG, THANG_TLDG, MA_TB, TEN_KIEULD, LOAIHINH_TB, PHONG_PTM, TENNV_PTM, KENH_PTM, DTHU_GOI, DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON   )
        (   Select THANG, thang_xuly THANG_TLDG, SO_TB MA_TB
                   , ('Thuê bao PTM')TEN_KIEULD
                   , (Case when loaidichvu = 'Di động' then 'VNPTT'
                           when loaidichvu like '%Truyền hình' then 'BRCD_MYTV'
                      end)DICHVU
                   , ma_pb PHONG_PTM
                   , (Case when ten_diem_ban is not null then ten_diem_ban else ten_ctv end)NHANVIEN_PTM
                   , (Case when ten_diem_ban is not null then 'Điểm bán' when ten_ctv is not null then 'CTV XHH' end)KENH_PTM
                   , DTHU_GOI, DTHU_TLDG, (hoahong) TIENLUONG_DAILY, (hoahong)TIENLUONG_PBH_PTM, (null)TIENLUONG_PQL, 'KHANH' NGUON
            From (
                    Select a.*
                           , (Case when dt.dh_doanhthu is not null then dt.dh_doanhthu when dt1.dh_doanhthu is not null then dt1.dh_doanhthu end)DTHU_GOI
                           , (Case when dt.dh_doanhthu is not null then dt.dh_doanhthu when dt1.dh_doanhthu is not null then dt1.dh_doanhthu end)DTHU_TLDG
                           --, (Case when b.PBHKV is not null then b.PBHKV when c.PBHKV is not null then c.PBHKV when d.PBHKV is not null then d.PBHKV else e.PBHKV end)PBHKV
                    From (
                            Select thang, thang_xuly, ma_donhang, loaidichvu, SO_TB, ten_ctv, ten_diem_ban, sum(hoahong_1)hoahong, ma_pb
                            From khanhtdt_ttkd.SMCS_COVI_2024
                            Where thang = 202407 and (ten_diem_ban is null or ten_diem_ban not like '%COKYVINA%')
                            Group by thang, thang_xuly, ma_donhang, loaidichvu, SO_TB, ten_ctv, ten_diem_ban, ma_pb
                         ) a
                    Left join (Select distinct ma_donhang, dh_doanhthu From khanhtdt_ttkd.IMP_CTVXHH_PHAICHI_2024) dt On a.ma_donhang = dt.ma_donhang
                    Left join (Select distinct ma_donhang, dh_doanhthu From khanhtdt_ttkd.IMP_CTVXHH_PHAICHI_2023) dt1 On a.ma_donhang = dt1.ma_donhang
                 )
        );
----fiber
    Insert Into ttkd_bct.hocnq_cp_nhancong_hoahong
    (	THANG, THANG_TLDG, MA_TB, TEN_TB, MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB
        , PHONG_PTM, MANV_PTM, TENNV_PTM, KENH_PTM, PHONG_QL, TIENLUONG_PBH_PTM, NGUON
    )
    (
        Select THANG, THANG_TLDG, MA_TB, TEN_TB, MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM, MANV_PTM, TENNV_PTM, KENH_PTM, PHONG_QL, TIENLUONG_PBH_PTM, NGUON
        From (
                Select a.THANG, a.THANG THANG_TLDG, a.MA_TB_MYTV MA_TB, a.TEN_THUEBAO_MYTV TEN_TB
                       , y.MA_GD
                       , (Select TEN_KIEULD from css_hcm.kieu_ld where kieuld_id = x.kieuld_id)TEN_KIEULD
                       , (Select TEN_DVVT From css_hcm.dichvu_vt Where DICHVUVT_ID = x.DICHVUVT_ID)NHOM_DICHVU
                       , (select loaihinh_tb from css_hcm.loaihinh_tb Where loaitb_id = x.loaitb_id)LOAIHINH_TB
                       , a.ma_pb PHONG_PTM, a.MA_NV MANV_PTM, a.TEN_NV TENNV_PTM, a.loai_nv KENH_PTM
                       , (Select ma_pb_hrm From ttkd_bct.phongbanhang Where hieuluc = 1 and pbh_id = db.pbh_ql_id)PHONG_QL
                       , (30000) TIENLUONG_PBH_PTM
                       , 'KHANH' NGUON
                       , x.kieuld_id
                From khanhtdt_ttkd.KK_MYTV_FIBER_HH_2024 a
                Left join ttkd_bct.db_thuebao_ttkd db On a.MA_TB_MYTV = db.ma_tb
                Left join css_hcm.hd_thuebao x On db.thuebao_id = x.thuebao_id
                Left join css_hcm.hd_khachhang y On x.hdkh_id = y.hdkh_id
                Where a.thang = 202407
             )
        Where kieuld_id = 194
    );
Insert Into ttkd_bct.hocnq_cp_nhancong_hoahong
(	THANG, THANG_TLDG, MA_TB, TEN_TB, MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB
	, PHONG_PTM, MANV_PTM, TENNV_PTM, KENH_PTM, PHONG_QL, TIENLUONG_PBH_PTM, NGUON
)
(
	Select a.THANG, a.THANG THANG_TLDG, a.STB_DAT MA_TB
		   , x.TEN_TB
		   , a.MA_DHSX MA_GD
		   , (Select TEN_KIEULD from css_hcm.kieu_ld where kieuld_id = x.kieuld_id)TEN_KIEULD
		   , (Select TEN_DVVT From css_hcm.dichvu_vt Where DICHVUVT_ID = x.DICHVUVT_ID)NHOM_DICHVU
		   , (select loaihinh_tb from css_hcm.loaihinh_tb Where loaitb_id = x.loaitb_id)LOAIHINH_TB
		   , a.ma_pb PHONG_PTM, a.MA_GTDH MANV_PTM, a.TEN_NGGT TENNV_PTM
		   , (Case when a.MA_GTDH like 'CTV%' then 'CTV' else 'NV' end)KENH_PTM
		   , (Select ma_pb_hrm From ttkd_bct.phongbanhang Where hieuluc = 1 and pbh_id = db.pbh_ql_id)PHONG_QL
		   , a.KK_SIMTS TIENLUONG_PBH_PTM
		   , 'KHANH' NGUON
	From khanhtdt_ttkd.KK_KENH_ONLINE_TS a
	Left join css_hcm.hd_khachhang y On a.ma_dhsx = y.ma_gd
	Left join css_hcm.hd_thuebao x On x.hdkh_id = y.hdkh_id
	Left join ttkd_bct.db_thuebao_ttkd db On trim(a.STB_DAT) = db.ma_tb and db.trangthaitb_id = 1
	where a.thang = 202407 and a.KK_SIMTS > 0
);
insert into KHKT_BC_HOAHONG_2(THANG_PTM,MA_TB,TENKIEU_LD,NGAY_BBBG,TENNV_PTM,DTHU_GOI,THANG_TLDG_DT,NHOM_TIEPTHI,LOAI_THULAO,LUONG_DONGIA_NVPTM,NGUON,DICHVUVT_ID,LOAITB_ID)
   select 202409,MA_TB,'PTM',NGAY_KH,tennv_ptm,GIA_GOI,202410,6,'hoahong',CHI_BCKH
        ,nguon_,2,21
       from (select MA_TB,
            LOAI_SIM,
            GIA_SIM_TRANG,
            GOI_CUOC,
            GIA_GOI,
            DTHU_HMM,
            DTHU_KIT,
            NGAY_KH,
            nguon tennv_ptm,
            CHI_BCKH*1.08 CHI_BCKH,
            'va_FPT' nguon_
     from FPT_BCKH_PTM
     where thang = 202407
     union all
     select MA_TB,
            LOAI_SIM,
            GIA_SIM_TRANG,
            MA_KIT,
            GIA_GOI,
            DTHU_HMM,
            DTHU_KIT,
            NGAY_KH,
            nguon tennv_ptm,
            CHI_BCKH*1.08,
            'va_tgdd'
     from TGDD_BCKH_PTM
     where thang = 202409

     );
commit;

    INSERT INTO KHKT_BC_HOAHONG(THANG_PTM,MA_KH,MA_TB,DICHVU_VT,TENKIEU_LD,ma_pb,TEN_PB,TENNV_PTM,THANG_TLDG_DT,NHOM_TIEPTHI,LOAI_THULAO,LUONG_DONGIA_NVPTM
                                ,NGUON,DICHVUVT_ID,LOAITB_ID)

    SELECT thang_ptm,ma_kh,ma_tb,'VNPTS','Hoa mang moi','VNP0700800','Phòng Phát triển Thị trường',manv_ptm,thang_tldg,5,'hoahong',luong,'va_DLPL_PTTT',2,20
    From chi_hoahong
    where thang_ptm = 202406;


select THANG_PTM, MA_GD, MA_KH, THUEBAO_ID, MA_TB, dich_vu, TENKIEU_LD, TEN_TB, DIACHI_LD, NGAY_BBBG, MA_PB, TEN_PB, MA_TO, TEN_TO
, case when ma_nguoigt is not null and ma_nguoigt in ( select ma_daily from ttkd_bsc.dm_daily_khdn  b
                where b.thang = thang_ptm)
                and nvl(LUONG_DONGIA_DNHM_NVPTM,0) + nvl(LUONG_DONGIA_NVPTM,0) = 0
                then nvl(ma_nguoigt,MANV_PTM)
                else nvl(MANV_PTM,ma_nguoigt) end as MANV_PTM
, TENNV_PTM, SOTHANG_DC, DATCOC_CSD, TIEN_DNHM, DTHU_GOI, THANG_TLDG_DT, SL_MAILING
,  case when ma_nguoigt is not null
                 and ma_nguoigt in ( select ma_daily from ttkd_bsc.dm_daily_khdn  b where b.thang = thang_ptm) --ton tai trong dm_daily
                 and nvl(LUONG_DONGIA_DNHM_NVPTM,0) + nvl(LUONG_DONGIA_NVPTM,0) = 0
            then 5
        else NHOM_TIEPTHI
            end as NHOM_TIEPTHI
,'hoahong', nvl(LUONG_DONGIA_DNHM_NVPTM,0) + nvl(LUONG_DONGIA_NVPTM,0)  LUONG_DONGIA_NVPTM, LUONG_DONGIA_NVHOTRO,'va_ct_bsc_ptm',dichvuvt_id,loaitb_id
    from ttkd_bsc.ct_bsc_ptm where thang_ptm in(202409,202410)
 ;

----============================================
      INSERT INTO KHKT_BC_HOAHONG_2(THANG_PTM, MA_GD, MA_KH, THUEBAO_ID, MA_TB, DICHVU_VT, TENKIEU_LD, TEN_TB, DIACHI_LD, NGAY_BBBG, MA_PB, TEN_PB, MA_TO, TEN_TO, MANV_PTM, TENNV_PTM, SOTHANG_DC, DATCOC_CSD, DTHU_DNHM, DTHU_GOI, THANG_TLDG_DT, SL_MAILING, NHOM_TIEPTHI, LOAI_THULAO, LUONG_DONGIA_NVPTM, LUONG_DONGIA_NVHOTRO, NGUON, DICHVUVT_ID, LOAITB_ID, SL_HDDT, TRANGTHAI_TT_ID, NOPDU_HSGOC, TYLE_CK)
    select THANG_PTM, MA_GD, MA_KH, THUEBAO_ID, MA_TB, dich_vu, TENKIEU_LD, TEN_TB, DIACHI_LD, NGAY_BBBG, MA_PB, TEN_PB, MA_TO, TEN_TO
, case when ma_nguoigt is not null and ma_nguoigt in ( select ma_daily from ttkd_bsc.dm_daily_khdn  b
                where b.thang = thang_ptm)
                and nvl(LUONG_DONGIA_DNHM_NVPTM,0) + nvl(LUONG_DONGIA_NVPTM,0) = 0
                then nvl(ma_nguoigt,MANV_PTM)
                else nvl(MANV_PTM,ma_nguoigt) end as MANV_PTM
, TENNV_PTM, SOTHANG_DC, DATCOC_CSD, TIEN_DNHM, DTHU_GOI, THANG_TLDG_DT, SL_MAILING
,  case when ma_nguoigt is not null
                 and ma_nguoigt in ( select ma_daily from ttkd_bsc.dm_daily_khdn  b where b.thang = thang_ptm) --ton tai trong dm_daily
                 and nvl(LUONG_DONGIA_DNHM_NVPTM,0) + nvl(LUONG_DONGIA_NVPTM,0) = 0
            then 5
        else NHOM_TIEPTHI
            end as NHOM_TIEPTHI
,'hoahong', nvl(LUONG_DONGIA_DNHM_NVPTM,0) + nvl(LUONG_DONGIA_NVPTM,0)  LUONG_DONGIA_NVPTM, LUONG_DONGIA_NVHOTRO,'va_ct_bsc_ptm',dichvuvt_id,loaitb_id
    ,b.SOLUONG,a.trangthai_tt_id,a.NOP_DU,
    case when   round(((c.TIEN-b.tien)*100/c.tien),2) < 0 then 0
    else round(((c.TIEN-b.tien)*100/c.tien),2)
    end as tyle_ck

    from ttkd_bsc.ct_bsc_ptm a
    left join css.v_ct_mua_tbi@dataguard b on a.HDTB_ID =b.HDTB_ID
    left join css.v_loai_tbi@dataguard c on b.loaitbi_id = c.loaitbi_id
    where a.thang_ptm = 202411
 ;





---======================================INSER XONG,=>> UPDATE PHONG_QL ================================================================================================

        select distinct nguon from ttkd_bct.hocnq_cp_nhancong_hoahong where thang_tldg = 202409; AND TEN_KIEULD ='Lap dat moi MyTV OTT';


select thang_ptm,thang_tldg,ma_tb,ten_tb,ma_gd,tenkieu_ld,dichvu_vt,'loaihinh_tb',ma_pb, manv_ptm, tennv_ptm,  REPLACE(nguon, 'KHANH ', '') ,'null',DATCOC_CSD, SOTHANG_DC, DTHU_GOI,DTHU_GOI,
when case nguon ='KHANH CTVXHH' then LUONG_DONGIA_NVPTM
    else null
end as tl ,LUONG_DONGIA_NVPTM,null,nguon
from khkt_bc_hoahong where thang_ptm = 202407 and nguon <> 'ghtt_nhuy';

select * from css_hcm.dichvu_vt;
   select * from ttkd_bct.hocnq_cp_nhancong_hoahong where thang_tldg = 202407 and ma_tb = '84919695335';
select thang_luong,thang_ptm,ma_gd,dthu_goi,thang_tldg_dt from TTKD_BSC.ct_bsc_ptm where ma_tb ='hcm_ca_00045481';
select * from TTKD_BCT.phongbanhang; where ma_pb ='VNP0702500';
1595041+186777
;;;
        insert into ttkd_bct.hocnq_cp_nhancong_hoahong(THANG, THANG_TLDG, MA_TB, TEN_TB, MA_GD, TEN_KIEULD, NHOM_DICHVU, LOAIHINH_TB, PHONG_PTM, MANV_PTM, TENNV_PTM, KENH_PTM, PHONG_QL,  DTHU_TLDG, TIENLUONG_DAILY, TIENLUONG_PBH_PTM, TIENLUONG_PQL, NGUON)

select 202407,202407,ma_tb,ten_tb,ma_gd,null,'CNTT',loaihinh_tb
     ,
    case
        when phong_ptm ='Phòng Khách Hàng Doanh Nghiệp 1' then 'VNP0702300'
        when phong_ptm ='Phòng Khách Hàng Doanh Nghiệp 2' then 'VNP0702400'
        when phong_ptm ='Phòng Khách Hàng Doanh Nghiệp 3' then 'VNP0702500'
end as phong_ptm
,manv_ptm,tennv_ptm,'Đại Lý CNTT', case
        when phong_ptm ='Phòng Khách Hàng Doanh Nghiệp 1' then 'VNP0702300'
        when phong_ptm ='Phòng Khách Hàng Doanh Nghiệp 2' then 'VNP0702400'
        when phong_ptm ='Phòng Khách Hàng Doanh Nghiệp 3' then 'VNP0702500'
end as phong_ql ,dthu_novat,null,to_number(hoahong),null,'CNTT_cNhung'
    from bc_gtgt_t07
 ;
select* from  bc_gtgt_t06 where ma_tb in ('hcm_hddt_00009208'
,'hcm_hddt_00007584',
                                         'hcm_ca_00102005'
,'hcm_ca_00104358'

);

 update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Nhân viên chính thức TTKD'
    where kenh_ptm ='NVKD';

    update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Nhân viên chính thức TTKD'
    where kenh_ptm ='NVCT';
        update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Nhân viên Viễn thông'
    where kenh_ptm ='NVVT';

     update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Công tác viên TTKD'
    where kenh_ptm ='CTV';

    update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Công tác viên VTTP'
    where kenh_ptm ='CTV_KT';

    update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Đại lý cá nhân'
    where kenh_ptm ='DLCN';
    update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Nhân viên Viễn thông'
    where kenh_ptm ='NVKT';

        update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Cộng tác viên Xã hội hóa'
    where kenh_ptm ='CTV XHH';

    update ttkd_bct.hocnq_cp_nhancong_hoahong
    set kenh_ptm ='Đại lý pháp nhân'
    where kenh_ptm ='Đại lý' and nguon ='man_VNPTT_HHBG';
