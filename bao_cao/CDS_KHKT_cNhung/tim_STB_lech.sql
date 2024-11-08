-- Tạo view chênh lệch giữa kênh nôi bộ và kênh ngoài



WITH raw_data AS (
    SELECT thang_ptm,
           thang_tldg_dt,
           ma_tb,
           manv_ptm,
           nhom_tiepthi,
           NVL(luong_dongia_nvptm, 0) AS luong_dongia_nvptm,
           NVL(luong_dongia_nvhotro, 0) AS luong_dongia_nvhotro
    FROM TTKD_BCT.khkt_bc_hoahong a
    WHERE  a.NGAY_BBBG BETWEEN TO_DATE('01/06/2024 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
                            AND TO_DATE('30/06/2024 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
                            AND a.nguon in ('man_VNPTT_HHBG',
                                            'va_tgdd',
                                            'va_DLPL_PTTT',
                                            'va_FPT',
                                            'va_ct_bsc_ptm',
                                            'KHANH CTVXHH',
                                            'imp_CNTT')
            OR  (a.NGAY_BBBG is null and a.thang_ptm = 202406)
)

-- Tìm các ma_tb có trong cả hai kênh
SELECT ma_tb
FROM (
    SELECT a.ma_tb, 'kenh_noi_bo' AS kenh
    FROM raw_data a
    WHERE a.nhom_tiepthi IN (1,2,3,11)

    INTERSECT

    SELECT a.ma_tb, 'kenh_ngoai' AS kenh
    FROM raw_data a
    WHERE a.nhom_tiepthi NOT IN (1,2,3,11)
);
