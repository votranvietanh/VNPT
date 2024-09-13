                        BEGIN
                            create_kpi_summary('MDHT', TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')), 'MUCDO_HOANTHANH');
                            create_kpi_summary('giao', TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')), 'giao');
                            create_kpi_summary('THUCHIEN', TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')), 'THUCHIEN');
                            create_kpi_summary('TLTH', TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')), 'TYLE_THUCHIEN');
                            create_kpi_summary('DIEM_CONG', TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')), 'DIEM_CONG');
                            create_kpi_summary('DIEM_TRU', TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')), 'DIEM_TRU');
                        END;
                        /

--===================================================================================================================================================


CREATE OR REPLACE PROCEDURE create_kpi_summary (
    p_mdhd     IN VARCHAR2,  -- tên phân biệt (MDHD, giao, thuchien, cong, tru)
    p_thang    IN NUMBER,    -- Tháng 
    p_mucdo    IN VARCHAR2   -- tên cột trong ttkd_bsc.bangluong where thang = ?
) AUTHID CURRENT_USER AS
    v_sql VARCHAR2(32767);
BEGIN
    -- Tạo bảng mới với các cột KPI
    v_sql := 'CREATE TABLE kpi_summary__' || p_mdhd || '' || p_thang || ' AS ' || 
             'SELECT ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, ';

    -- Thêm các cột KPI vào câu lệnh SQL
    FOR rec IN (
        SELECT DISTINCT ma_kpi
        FROM ttkd_bsc.bangluong_kpi
        WHERE thang = p_thang  -- sử dụng biến tháng
    ) LOOP
        v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || rec.ma_kpi || ''' THEN ' || p_mucdo || ' END) AS "' || rec.ma_kpi || '", ';
    END LOOP;

    -- Xóa dấu ',' cuối cùng và thêm câu lệnh GROUP BY
    v_sql := RTRIM(v_sql, ', ') || ' FROM ttkd_bsc.bangluong_kpi ' ||
             'WHERE thang = ' || p_thang || ' ' || 
             'GROUP BY ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb';

    -- In câu SQL ra để kiểm tra
    DBMS_OUTPUT.PUT_LINE(v_sql);

    -- Thực thi câu lệnh SQL
    EXECUTE IMMEDIATE v_sql;
END;
/

