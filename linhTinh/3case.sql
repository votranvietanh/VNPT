--B?ng B c� d�ng m?i so v?i B?ng A �> l?y d�ng m?i n�y ra
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
WHERE row_count > 1 and row_num > 1 -- Ch? l?y c�c d�ng tr�ng l?p
AND NVL(CONCAT(ma_kpi, ma_nv), '0') IN (
    SELECT NVL(CONCAT(a.ma_kpi, a.ma_nv), '0')
    FROM bangA a
)
OR NVL(CONCAT(ma_kpi, ma_nv), '0') NOT IN (
    SELECT NVL(CONCAT(a.ma_kpi, a.ma_nv), '0')
    FROM bangA a
);


-- B?ng B c� 1 trong c�c c?t n�y c� gi� tr? thay d�i so v?i B?ng A
--(NGAYCONG, CHITIEU_GIAO, GIAO, THUCHIEN, TYLE_THUCHIEN, MUCDO_HOANTHANH, DIEM_CONG, DIEM_TRU) �> l?y ra d�ng d�
select * from bangc c join bangA a on a.ma_kpi = c.ma_kpi and a.ma_nv = c.ma_nv
where nvl(c.ngaycong,0) <> nvl(a.ngaycong,0)
or nvl(c.chitieu_giao,0) <> nvl(a.chitieu_giao,0)
or nvl(c.giao,0) <> nvl(a.giao,0)
or nvl(c.thuchien,0) <> nvl(a.thuchien,0)
or nvl(c.tyle_thuchien,0) <> nvl(a.tyle_thuchien,0)
or nvl(c.mucdo_hoanthanh,0) <> nvl(a.mucdo_hoanthanh,0)
or nvl(c.diem_cong,0) <> nvl(a.diem_cong,0)
or nvl(c.diem_tru,0) <> nvl(a.diem_tru,0)


--B?ng B thi?u 1 d�ng so v?i B?ng A �> l?y d�ng m?t n�y ra
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
        WHERE row_count > 1 and row_num > 1 -- Ch? l?y c�c d�ng tr�ng l?p
        AND NVL(CONCAT(ma_kpi, ma_nv), 0) IN (
            SELECT NVL(CONCAT(c.ma_kpi, c.ma_nv), 0)
            FROM bangc c
        )
        OR NVL(CONCAT(ma_kpi, ma_nv), 0) NOT IN (
            SELECT NVL(CONCAT(c.ma_kpi, c.ma_nv), 0)
            FROM  bangc c
        )






