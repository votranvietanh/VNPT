-- danh sach PTM

select * from (select MA_TB ma_thue_bao
            ,(d.LOAIHINH_TB) loai_hinh_thue_bao
--            ,d.LOAIHINH_TB,a.dichvu_vt
            ,c.TEN_DVVT ten_dich_vu,MA_GD ma_giao_dich
            ,TEN_TB ten_khach_hang, MA_KH, THUEBAO_ID
            ,TENKIEU_LD, DIACHI_LD dia_chi_khach_hang
            ,NVL(NGAY_BBBG, TO_DATE('01/06/2024', 'DD/MM/YYYY'))  ngay_nghiem_thu
            ,SOTHANG_DC so_thang_tra_truoc
            ,DATCOC_CSD gia_tri_goicuoc_tra_truoc
            ,DTHU_GOI gtri_goicuoc_thang
            ,THANG_TLDG_DT, SL_MAILING SL_Hopdong_dientu
            ,MANV_PTM ma_tiep_thi
            ,tennv_ptm tennv_tiepthi,ten_pb phong_tiep_thi, nguon
            ,NVCT, DLCN, DLPN, KENH_CHUOI, DUQ, CTVXHH
        from (
--                        with line_hd_tb as ( select dichvuvt_id
--                                                    ,ma_tb,loaitb_id
--                                             from css_hcm.db_thuebao
--                                            group by dichvuvt_id,ma_tb,loaitb_id
--                                                )
--                        ,
                        with src as ( SELECT
                                                    a.*,
                                                    CASE
                                                        WHEN a.nguon IN ('va_ĐLCN-PTTT', 'va_FPT', 'va_tgdd') THEN 2
                                                        ELSE a.dichvuvt_id
                                                    END AS dichvuvt_id_s,
                                                    CASE
                                                        WHEN a.tennv_ptm IN ('TGDD', 'FPT') THEN 21
                                                        WHEN a.TENKIEU_LD = 'phattrienmoi' THEN 20
                                                        ELSE a.LOAITB_ID
                                                    END AS LOAITB_ID_s
                                                FROM
                                                    ttkd_bct.khkt_bc_hoahong a
                                                WHERE
                                                    a.thang_ptm = 202406

                                            )


                SELECT a.thang_ptm, a.dichvuvt_id_s dichvuvt_id, a.LOAITB_ID_s LOAITB_ID,a.MA_GD, a.MA_KH, a.THUEBAO_ID, a.MA_TB, a.dichvu_vt
                        , a.TENKIEU_LD, a.TEN_TB, a.DIACHI_LD, a.NGAY_BBBG
                        , a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO, a.MANV_PTM, a.TENNV_PTM
                        , a.SOTHANG_DC, a.DATCOC_CSD, a.DTHU_DNHM, a.DTHU_GOI, a.THANG_TLDG_DT, a.SL_MAILING
                        , a.NHOM_TIEPTHI, a.LOAI_THULAO, a.LUONG_DONGIA_NVPTM, a.LUONG_DONGIA_NVHOTRO
                        , case when a.nhom_tiepthi in (1,2) then (nvl(a.LUONG_DONGIA_NVPTM,0)+nvl(a.LUONG_DONGIA_NVHOTRO,0)) else 0 end as NVCT,
                            case when a.nhom_tiepthi = 4 then (nvl(a.LUONG_DONGIA_NVPTM,0)+nvl(a.LUONG_DONGIA_NVHOTRO,0)) else 0 end as DLCN,
                            case when a.nhom_tiepthi = 5 then (nvl(a.LUONG_DONGIA_NVPTM,0)+nvl(a.LUONG_DONGIA_NVHOTRO,0)) else 0 end as DLPN,
                            case when a.nhom_tiepthi = 6 then (nvl(a.LUONG_DONGIA_NVPTM,0)+nvl(a.LUONG_DONGIA_NVHOTRO,0)) else 0 end as kenh_chuoi,
                            case when a.nhom_tiepthi = 7 then (nvl(a.LUONG_DONGIA_NVPTM,0)+nvl(a.LUONG_DONGIA_NVHOTRO,0)) else 0 end as DUQ,
                            case when a.nhom_tiepthi = 8 then (nvl(LUONG_DONGIA_NVPTM,0)+nvl(LUONG_DONGIA_NVHOTRO,0)) else 0 end as CTVXHH
                                ,a.nguon
                FROM src a
                ) a
        left join ttkd_bsc.dm_nhomld b on a.NHOM_TIEPTHI = b.nhomld_id
        left join css_hcm.dichvu_vt c on a.DICHVUVT_ID = c.DICHVUVT_ID
        left join css_hcm.loaihinh_tb d on d.LOAITB_ID = a.LOAITB_ID
        WHERE a.NGAY_BBBG BETWEEN TO_DATE('01/06/2024 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
                            AND TO_DATE('30/06/2024 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
                            AND nguon in (
'man_VNPTT_HHBG'
'va_tgdd',
'va_DLPL_PTTT',
'va_FPT',
'va_ct_bsc_ptm',
'KHANH CTVXHH',
'imp_CNTT')
            OR  (a.NGAY_BBBG is null and a.thang_ptm = 202406)

            );