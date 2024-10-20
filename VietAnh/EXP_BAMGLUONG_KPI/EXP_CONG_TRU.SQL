                  -----==========RUN=====================
                  BEGIN
                        KPI_CONGTRU(202409);
                 END;

                 SELECT * FROM kpi_CONGTRU_202409_20241020_1535;
                /
            --===============================BUILD===============================================================
                  
                                 CREATE OR REPLACE PROCEDURE KPI_CONGTRU_v2(p_thang IN NUMBER) AUTHID CURRENT_USER IS
              v_sql VARCHAR2(4000);
          BEGIN
              -- Xóa bảng khi đã tồn tại
--              BEGIN
--                  EXECUTE IMMEDIATE 'DROP TABLE vietanhvh.kpi_CONGTRU_' || p_thang; 
--              EXCEPTION
--                  WHEN OTHERS THEN
--                      -- Bỏ qua lỗi nếu bảng không tồn tại
--                      IF SQLCODE != -942 THEN
--                          RAISE;
--                      END IF;
--              END;
          
              v_sql := 'CREATE TABLE vietanhvh.kpi_CONGTRU_' || p_thang ||'_'|| TO_CHAR(SYSDATE, 'yyyymmdd_hh24mi') || ' AS ' ||'
                        SELECT THANG, MA_NV, TEN_NV, TEN_VTCV, TEN_TO, TEN_PB,
                               CASE WHEN SUM(DIEM_CONG) = 0 THEN NULL ELSE SUM(DIEM_CONG) END AS DIEM_CONG,
                               CASE WHEN SUM(DIEM_TRU) = 0 THEN NULL ELSE SUM(DIEM_TRU) END AS DIEM_TRU
                        FROM ttkd_bsc.bangluong_kpi
                        WHERE THANG = ' || p_thang || '
                        GROUP BY THANG, MA_NV, TEN_NV, TEN_VTCV, TEN_TO, TEN_PB';
          
              -- RUN
              EXECUTE IMMEDIATE v_sql;
          
              -- Log 
              DBMS_OUTPUT.PUT_LINE('Bảng kpi_CONGTRU_' || p_thang || ' đã được tạo thành công.');
          END;
          /
