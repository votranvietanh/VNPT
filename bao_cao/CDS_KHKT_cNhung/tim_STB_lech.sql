--cac ma_tb trung nhau nhung khac manv_ptm la chi trung dv CNTT
    select distinct ma_tb,MANV_PTM
from khkt_bc_hoahong_2
where ma_tb  in
(select ma_tb
    from hoahong_imp_cntt_new
    where thang_nghiemthu = 202406
    )
;

-- Tạo view chênh lệch giữa kênh nôi bộ và kênh ngoài



WITH raw_data AS (
    SELECT thang_ptm,
           thang_tldg_dt,
           ma_tb,
           manv_ptm,
           nhom_tiepthi,
           NVL(luong_dongia_nvptm, 0) AS luong_dongia_nvptm,
           NVL(luong_dongia_nvhotro, 0) AS luong_dongia_nvhotro
    FROM khkt_bc_hoahong_2 a
    WHERE thang_ptm = 202412
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
    WHERE a.nhom_tiepthi NOT IN (1,2,3,11) or  a.nhom_tiepthi is null
);
