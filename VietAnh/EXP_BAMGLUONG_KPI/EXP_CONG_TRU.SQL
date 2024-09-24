                  -----==========RUN=====================
                  BEGIN
                        KPI_CONGTRU(202408);
                 END;

                 SELECT * FROM kpi_CONGTRU_202408;
                /
            --===============================BUILD===============================================================
                  
                    CREATE OR REPLACE PROCEDURE KPI_CONGTRU(p_thang IN NUMBER)
                    IS
                        v_sql VARCHAR2(4000);
                    BEGIN
                        --TẠO BẢNG 
                        v_sql := 'CREATE TABLE kpi_CONGTRU_' || p_thang || ' AS
                                SELECT THANG, MA_NV, TEN_NV, TEN_VTCV, TEN_TO, TEN_PB,
                                        CASE WHEN SUM(DIEM_CONG) = 0 THEN NULL
                                            ELSE SUM(DIEM_CONG) END AS DIEM_CONG,
                                        CASE WHEN SUM(DIEM_TRU) = 0 THEN NULL
                                            ELSE SUM(DIEM_TRU) END AS DIEM_TRU
                                FROM ttkd_bsc.bangluong_kpi
                                WHERE THANG = ' || p_thang || '
                                GROUP BY THANG, MA_NV, TEN_NV, TEN_VTCV, TEN_TO, TEN_PB';

                        -- RUN
                        EXECUTE IMMEDIATE v_sql;
                        --LOG
                        DBMS_OUTPUT.PUT_LINE('Bảng kpi_data_' || p_thang || ' đã được tạo thành công.');
                    END;
                    /