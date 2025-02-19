SELECT
   case when a.nhom_tiepthi in (2,11) then 'CNVT'
        when a.nhom_tiepthi = 1 then 'NVCT'
        when a.nhom_tiepthi = 3 then 'CTV KASACO'
        when a.nhom_tiepthi =4 then 'ĐLCN'
        when a.nhom_tiepthi =5 then 'ĐLPN'
        when a.nhom_tiepthi =6 then 'Chuỗi'
        when a.nhom_tiepthi =7 then 'ĐUQ'
        when a.nhom_tiepthi =8 then 'CTVXHH'
        end
   AS "Kênh PTTB",

    -- Dữ liệu cho loaitb_id = 20 (VNPTS)
    COUNT(CASE WHEN a.loaitb_id = 20 THEN a.ma_tb END) AS "Dịch vụ VNPTS - SL",
    nvl(SUM(CASE WHEN a.loaitb_id = 20 THEN a.DTHU_GOI END),0) AS "Dịch vụ VNPTS - DT gói",
    nvl(SUM(CASE WHEN a.loaitb_id = 20 THEN NVL(a.LUONG_DONGIA_NVPTM, 0) + NVL(a.LUONG_DONGIA_NVHOTRO, 0) END),0) AS "Dịch vụ VNPTS - Thu lao HH",

    -- Dữ liệu cho loaitb_id = 21 (VNPTT)
    COUNT(CASE WHEN a.loaitb_id = 21 THEN a.ma_tb END) AS "Dịch vụ VNPTT - SL",
    nvl(SUM(CASE WHEN a.loaitb_id = 21 THEN a.DTHU_GOI END),0) AS "Dịch vụ VNPTT - DT gói",
    nvl(SUM(CASE WHEN a.loaitb_id = 21 THEN NVL(a.LUONG_DONGIA_NVPTM, 0) + NVL(a.LUONG_DONGIA_NVHOTRO, 0) END),0) AS "Dịch vụ VNPTT - Thu lao HH",

    -- Dữ liệu cho loaitb_id = 116 (CA)
    COUNT(CASE WHEN a.loaitb_id = 116 THEN a.ma_tb END) AS "Dịch vụ CA - SL",
    nvl(SUM(CASE WHEN a.loaitb_id = 116 THEN a.DTHU_GOI END),0) AS "Dịch vụ CA - DT gói",
    nvl(SUM(CASE WHEN a.loaitb_id = 116 THEN NVL(a.LUONG_DONGIA_NVPTM, 0) + NVL(a.LUONG_DONGIA_NVHOTRO, 0) END),0) AS "Dịch vụ CA - Thu lao HH",

    -- Dữ liệu cho dichvuvt_id = 4 (CDBR)
    COUNT(CASE WHEN a.dichvuvt_id = 4 THEN a.ma_tb END) AS "Dịch vụ CDBR - SL",
    nvl(SUM(CASE WHEN a.dichvuvt_id = 4 THEN a.DTHU_GOI END),0) AS "Dịch vụ CDBR - DT gói",
    nvl(SUM(CASE WHEN a.dichvuvt_id = 4 THEN NVL(a.LUONG_DONGIA_NVPTM, 0) + NVL(a.LUONG_DONGIA_NVHOTRO, 0) END),0) AS "Dịch vụ CDBR - Thu lao HH",
    --econtract
        COUNT(CASE WHEN a.loaitb_id = 290 THEN a.ma_tb END) AS "Dịch vụ VNPT eContract  - SL",
    nvl(SUM(CASE WHEN a.loaitb_id = 290 THEN a.DTHU_GOI END),0) AS "Dịch vụ VNPT eContract  - DT gói",
    SUM(CASE WHEN a.loaitb_id = 290 THEN NVL(a.LUONG_DONGIA_NVPTM, 0) + NVL(a.LUONG_DONGIA_NVHOTRO, 0) END) AS "Dịch vụ VNPT eContract  - Thu lao HH",
        --CNTT khacs
        COUNT(CASE WHEN dichvuvt_id in (14,15,16) and loaitb_id not in (290, 116) THEN a.ma_tb END) AS "Dịch vụ CNTT Khác  - SL",
    nvl(SUM(CASE WHEN dichvuvt_id in (14,15,16) and loaitb_id not in (290, 116) THEN a.DTHU_GOI END),0) AS "Dịch vụ CNTT Khác  - DT gói",
    nvl(SUM(CASE WHEN dichvuvt_id in (14,15,16) and loaitb_id not in (290, 116) THEN NVL(a.LUONG_DONGIA_NVPTM, 0) + NVL(a.LUONG_DONGIA_NVHOTRO, 0) END),0) AS "Dịch vụ CNTT Khác  - Thu lao HH"

FROM

    khkt_bc_hoahong_2 a
WHERE
    a.nhom_tiepthi is not null
    and ( a.NGAY_BBBG BETWEEN TO_DATE('01/11/2024 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
                            AND TO_DATE('01/11/2024 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
                            AND a.nguon in ('man_VNPTT_HHBG',
                                            'va_tgdd',
                                            'va_DLPL_PTTT',
                                            'va_FPT',
                                            'va_ct_bsc_ptm',
                                            'KHANH CTVXHH',
                                            'imp_CNTT')
            OR  (a.NGAY_BBBG is null and a.thang_ptm = 202411)
        )
GROUP BY
    case when a.nhom_tiepthi in (2,11) then 'CNVT'
        when a.nhom_tiepthi = 1 then 'NVCT'
        when a.nhom_tiepthi = 3 then 'CTV KASACO'
        when a.nhom_tiepthi =4 then 'ĐLCN'
        when a.nhom_tiepthi =5 then 'ĐLPN'
        when a.nhom_tiepthi =6 then 'Chuỗi'
        when a.nhom_tiepthi =7 then 'ĐUQ'
        when a.nhom_tiepthi =8 then 'CTVXHH'
        end
ORDER BY
    "Kênh PTTB";