CREATE OR REPLACE PROCEDURE sosanh(bangA IN VARCHAR2, bangB IN VARCHAR2)
AS
BEGIN
    /*BEGIN 
        EXECUTE IMMEDIATE 'DROP TABLE bang_chenhlech';
        EXCEPTION
        WHEN OTHER THEN NULL;
    END;*/
    -- X�a d? li?u trong b?ng bang_chenhlech
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bang_chenhlech';

    -- C�c ph?n th�m d? li?u v?n gi? nguy�n nhu tru?c
    EXECUTE IMMEDIATE '
        INSERT INTO bang_chenhlech 
        WITH DuplicateRows AS (
        SELECT 
        b.*, 
        COUNT(*) OVER (PARTITION BY NVL(CONCAT(b.ma_kpi, b.ma_nv), 0)) AS row_count,
        ROW_NUMBER() OVER (PARTITION BY NVL(CONCAT(b.ma_kpi, b.ma_nv), 0) ORDER BY b.ma_kpi,b.ma_nv) AS row_num
        FROM ' || bangB || ' b
        )
        SELECT  thang,   ma_kpi,   ten_kpi,   ma_nv,   ten_nv,   ma_vtcv,
                ten_vtcv,   ma_to,   ten_to,   ma_pb,   ten_pb,   ngaycong,
                tytrong,   donvi_tinh, chitieu_giao,   giao,   thuchien,
                tyle_thuchien,   mucdo_hoanthanh,   diem_cong,   diem_tru,
                ghichu,   ngay_public,   ngay_deadline,   manv_public,
                manv_apply,   ngay_apply, ''case1'' as truonghop
        FROM DuplicateRows
        WHERE row_count > 1 and row_num > 1 -- Ch? l?y c�c d�ng tr�ng l?p
        AND NVL(CONCAT(ma_kpi, ma_nv), 0) IN (
        SELECT NVL(CONCAT(a.ma_kpi, a.ma_nv), 0)
        FROM ' || bangA || ' a
        )
        OR NVL(CONCAT(ma_kpi, ma_nv), 0) NOT IN (
            SELECT NVL(CONCAT(a.ma_kpi, a.ma_nv), 0)
            FROM ' || bangA || ' a)';

    -- Th�m c�c d�ng c� s? thay d?i trong c�c c?t c? th? (Case 2)
    EXECUTE IMMEDIATE '
        INSERT INTO bang_chenhlech 
        SELECT b.*, ''case2'' as truonghop FROM ' || bangB || ' b
        JOIN ' || bangA || ' a ON a.ma_kpi = b.ma_kpi AND a.ma_nv = b.ma_nv
        WHERE nvl(b.ngaycong,0) <> nvl(a.ngaycong,0)
        or nvl(b.chitieu_giao,0) <> nvl(a.chitieu_giao,0)
        or nvl(b.giao,0) <> nvl(a.giao,0)
        or nvl(b.thuchien,0) <> nvl(a.thuchien,0)
        or nvl(b.tyle_thuchien,0) <> nvl(a.tyle_thuchien,0)
        or nvl(b.mucdo_hoanthanh,0) <> nvl(a.mucdo_hoanthanh,0)
        or nvl(b.diem_cong,0) <> nvl(a.diem_cong,0)
        or nvl(b.diem_tru,0) <> nvl(a.diem_tru,0)';

    -- Th�m c�c d�ng c� trong b?ng A nhung kh�ng c� trong b?ng B (Case 3)
    EXECUTE IMMEDIATE '
        INSERT INTO bang_chenhlech 
        WITH DuplicateRows AS (
        SELECT  
        a.*, 
        COUNT(*) OVER (PARTITION BY NVL(CONCAT(a.ma_kpi, a.ma_nv), 0)) AS row_count,
        ROW_NUMBER() OVER (PARTITION BY NVL(CONCAT(a.ma_kpi, a.ma_nv), 0) ORDER BY a.ma_kpi,a.ma_nv) AS row_num
        FROM ' || bangA || ' a
        )
        SELECT  thang,   ma_kpi,   ten_kpi,   ma_nv,   ten_nv,   ma_vtcv,
                ten_vtcv,   ma_to,   ten_to,   ma_pb,   ten_pb,   ngaycong,
                tytrong,   donvi_tinh, chitieu_giao,   giao,   thuchien,
                tyle_thuchien,   mucdo_hoanthanh,   diem_cong,   diem_tru,
                ghichu,   ngay_public,   ngay_deadline,   manv_public,
                manv_apply,   ngay_apply, ''case3'' as truonghop
        FROM DuplicateRows
        WHERE row_count > 1 and row_num > 1 -- Ch? l?y c�c d�ng tr�ng l?p
        AND NVL(CONCAT(ma_kpi, ma_nv), 0) IN (
            SELECT NVL(CONCAT(b.ma_kpi, b.ma_nv), 0)
            FROM ' || bangB || ' b
        )
        OR NVL(CONCAT(ma_kpi, ma_nv), 0) NOT IN (
            SELECT NVL(CONCAT(b.ma_kpi, b.ma_nv), 0)
            FROM ' || bangB || ' b
        )';

    COMMIT;
END;
/

begin 
sosanh('bangA','bangC');
end;

select * from bang_chenhlech

