
--==========================================================RUN-=======================================

                BEGIN
                    create_kpi_summary('giao',  TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM')), 'giao');
                END;
                /   

                drop table kpi_summary__202408_giao;
                select * from vietanhvh.kpi_summary__202408_giao;
                select * from kpi_summary__202408_THUCHIEN ;
;



---==========================================================BUILD-----------------------------
                CREATE OR REPLACE PROCEDURE create_kpi_summary (
                    p_mdhd     IN VARCHAR2,  -- tên phân biệt (MDHD, giao, thuchien, cong, tru)
                    p_thang    IN NUMBER,    -- Tháng 
                    p_mucdo    IN VARCHAR2   -- tên cột trong ttkd_bsc.bangluong where thang = ?
                ) AUTHID CURRENT_USER AS
                    v_sql VARCHAR2(32767);
                    v_query VARCHAR2(1000);
                    v_ma_kpi ttkd_bsc.blkpi_danhmuc_kpi.ma_kpi%TYPE;
                    cur_kpi SYS_REFCURSOR;  -- Khai báo con trỏ để xử lý truy vấn động
                BEGIN
                    -- Tạo câu lệnh truy vấn SQL động, giới hạn trong các mã KPI mong muốn
                    v_query := 'SELECT ma_kpi FROM ttkd_bsc.blkpi_danhmuc_kpi WHERE thang = ' || p_thang ||
                            ' AND ' || p_mucdo || ' = 1 ' ||
                            '';

                    -- Mở con trỏ cho câu lệnh truy vấn
                    OPEN cur_kpi FOR v_query;

                    -- Tạo bảng mới với các cột KPI
                    v_sql := 'CREATE TABLE kpi_summary__' || p_thang || '_' || p_mdhd || ' AS ' || 
                            'SELECT ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, ';

                    -- Lặp qua từng hàng kết quả từ con trỏ
                    LOOP
                        FETCH cur_kpi INTO v_ma_kpi;
                        EXIT WHEN cur_kpi%NOTFOUND;

                        -- Thêm các cột KPI vào câu lệnh SQL
                        v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN ' || p_mucdo || ' END) AS "' || v_ma_kpi || '", ';
                    END LOOP;

                    CLOSE cur_kpi;

                    -- Xóa dấu ',' cuối cùng và thêm câu lệnh GROUP BY
                    v_sql := RTRIM(v_sql, ', ') || ' FROM ttkd_bsc.bangluong_kpi ' ||
                            'WHERE thang = ' || p_thang || ' ' || 
                            'GROUP BY ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb';

                    -- In câu lệnh SQL để kiểm tra
                    DBMS_OUTPUT.PUT_LINE(v_sql);

                    -- Thực thi câu lệnh SQL để tạo bảng
                    EXECUTE IMMEDIATE v_sql;

                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
                END;
                /


