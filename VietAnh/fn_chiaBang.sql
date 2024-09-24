
--===================================================FILE THỰC HIỆN =============================================================

---======================================================RUN====================================================================
                                            
        -- Gọi procedure cho tháng hiện tại
                BEGIN
                    create_kpi_summary_gom(TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM')));
                END;
                /
                drop table BL_202408_tonghop;
                select * from BL_202408_tonghop;

---====================================================== BUILD ====================================================================
                                    CREATE OR REPLACE PROCEDURE create_kpi_summary_gom (
                                        p_thang    IN NUMBER    -- Tháng 
                                    ) AUTHID CURRENT_USER AS
                                        v_sql VARCHAR2(32767);
                                        v_query VARCHAR2(1000);
                                        v_ma_kpi ttkd_bsc.blkpi_danhmuc_kpi.ma_kpi%TYPE;
                                        v_giao NUMBER;
                                        v_thuchien NUMBER;
                                        v_tyle_thuchien NUMBER;
                                        v_mucdo_hoanthanh NUMBER;
                                        v_diem_cong NUMBER;
                                        v_diem_tru NUMBER;
                                        cur_kpi SYS_REFCURSOR;  -- Khai báo con trỏ để xử lý truy vấn động
                                    BEGIN
                                        -- Tạo bảng mới với các cột KPI và các loại dữ liệu khác
                                        v_sql := 'CREATE TABLE BL_' || p_thang || '_TONGHOP AS ' ||
                                                 'SELECT ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, ';
                                    
                                        -- Truy vấn các KPI khác nhau theo thứ tự của các loại dữ liệu
                                        v_query := 'SELECT ma_kpi, giao, thuchien, tyle_thuchien, mucdo_hoanthanh, diem_cong, diem_tru ' ||
                                                   'FROM ttkd_bsc.blkpi_danhmuc_kpi WHERE thang = ' || p_thang || 
                                                   ' 
                                                   ORDER BY ma_kpi ASC';
                                    
                                        OPEN cur_kpi FOR v_query;
                                    
                                        -- Lặp qua từng hàng kết quả từ con trỏ
                                        LOOP
                                            FETCH cur_kpi INTO v_ma_kpi, v_giao, v_thuchien, v_tyle_thuchien, v_mucdo_hoanthanh, v_diem_cong, v_diem_tru;
                                            EXIT WHEN cur_kpi%NOTFOUND;
                                    
                                            -- Chỉ thêm cột vào bảng nếu giá trị tương ứng là 1
                                    --        IF v_giao = 1 THEN
                                    --            v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN GIAO END) AS "' || v_ma_kpi || '_GIAO", ';
                                    --        END IF;
                                    
                                            IF v_thuchien = 1 THEN
                                                v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN THUCHIEN END) AS "' || v_ma_kpi || '", ';
                                            END IF;
                                    
                                            IF v_tyle_thuchien = 1 THEN
                                                v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN TYLE_THUCHIEN END) AS "' || v_ma_kpi || '", ';
                                            END IF;
                                    
                                            IF v_mucdo_hoanthanh = 1 THEN
                                                v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN MUCDO_HOANTHANH END) AS "' || v_ma_kpi || '", ';
                                            END IF;
                                    
                                    --        IF v_diem_cong = 1 THEN
                                    --            v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN DIEM_CONG END) AS "' || v_ma_kpi || '_DIEM_CONG", ';
                                    --        END IF;
                                    
                                    --        IF v_diem_tru = 1 THEN
                                    --            v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN DIEM_TRU END) AS "' || v_ma_kpi || '_DIEM_TRU", ';
                                    --        END IF;
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
