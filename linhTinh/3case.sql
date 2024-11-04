--B?ng B có dòng m?i so v?i B?ng A —> l?y dòng m?i này ra
WITH DuplicateRows AS (
    SELECT 
        c.*, 
        COUNT(*) OVER (PARTITION BY NVL(CONCAT(c.ma_kpi, c.ma_nv), '0')) AS row_count,
        ROW_NUMBER() OVER (PARTITION BY NVL(CONCAT(c.ma_kpi, c.ma_nv), '0') ORDER BY c.ma_kpi,c.ma_nv) AS row_num
    FROM bangc c
)
SELECT          thang,   ma_kpi,   ten_kpi,   ma_nv,   ten_nv,   ma_vtcv,
                ten_vtcv,   ma_to,   ten_to,   ma_pb,   ten_pb,   ngaycong,
                tytrong,   donvi_tinh, chitieu_giao,   giao,   thuchien,
                tyle_thuchien,   mucdo_hoanthanh,   diem_cong,   diem_tru,
                ghichu,   ngay_public,   ngay_deadline,   manv_public,
                manv_apply,   ngay_apply
FROM DuplicateRows
WHERE row_count > 1 and row_num > 1 -- Ch? l?y các dòng trùng l?p
AND NVL(CONCAT(ma_kpi, ma_nv), '0') IN (
    SELECT NVL(CONCAT(a.ma_kpi, a.ma_nv), '0')
    FROM bangA a
)
OR NVL(CONCAT(ma_kpi, ma_nv), '0') NOT IN (
    SELECT NVL(CONCAT(a.ma_kpi, a.ma_nv), '0')
    FROM bangA a
);


-- B?ng B có 1 trong các c?t này có giá tr? thay dôi so v?i B?ng A
--(NGAYCONG, CHITIEU_GIAO, GIAO, THUCHIEN, TYLE_THUCHIEN, MUCDO_HOANTHANH, DIEM_CONG, DIEM_TRU) —> l?y ra dòng dó
select * from bangc c join bangA a on a.ma_kpi = c.ma_kpi and a.ma_nv = c.ma_nv
where nvl(c.ngaycong,0) <> nvl(a.ngaycong,0)
or nvl(c.chitieu_giao,0) <> nvl(a.chitieu_giao,0)
or nvl(c.giao,0) <> nvl(a.giao,0)
or nvl(c.thuchien,0) <> nvl(a.thuchien,0)
or nvl(c.tyle_thuchien,0) <> nvl(a.tyle_thuchien,0)
or nvl(c.mucdo_hoanthanh,0) <> nvl(a.mucdo_hoanthanh,0)
or nvl(c.diem_cong,0) <> nvl(a.diem_cong,0)
or nvl(c.diem_tru,0) <> nvl(a.diem_tru,0)


--B?ng B thi?u 1 dóng so v?i B?ng A —> l?y dòng m?t này ra
WITH DuplicateRows AS (
        SELECT  
        a.*, 
        COUNT(*) OVER (PARTITION BY NVL(CONCAT(a.ma_kpi, a.ma_nv), 0)) AS row_count,
        ROW_NUMBER() OVER (PARTITION BY NVL(CONCAT(a.ma_kpi, a.ma_nv), 0) ORDER BY a.ma_kpi,a.ma_nv) AS row_num
        FROM  bangA  a
        )
        SELECT  thang,   ma_kpi,   ten_kpi,   ma_nv,   ten_nv,   ma_vtcv,
                ten_vtcv,   ma_to,   ten_to,   ma_pb,   ten_pb,   ngaycong,
                tytrong,   donvi_tinh, chitieu_giao,   giao,   thuchien,
                tyle_thuchien,   mucdo_hoanthanh,   diem_cong,   diem_tru,
                ghichu,   ngay_public,   ngay_deadline,   manv_public,
                manv_apply,   ngay_apply
        FROM DuplicateRows
        WHERE row_count > 1 and row_num > 1 -- Ch? l?y các dòng trùng l?p
        AND NVL(CONCAT(ma_kpi, ma_nv), 0) IN (
            SELECT NVL(CONCAT(c.ma_kpi, c.ma_nv), 0)
            FROM bangc c
        )
        OR NVL(CONCAT(ma_kpi, ma_nv), 0) NOT IN (
            SELECT NVL(CONCAT(c.ma_kpi, c.ma_nv), 0)
            FROM  bangc c
        )






