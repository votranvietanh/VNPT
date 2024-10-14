CREATE OR REPLACE PROCEDURE CREATE_APP_3B_TABLE (suffix1 number) 
	AUTHID CURRENT_USER IS
    table_name VARCHAR2(80);
    suffix2 number;
    suffix3 number;
    sql_stmt CLOB; 
BEGIN
    -- Calculate suffix2 and suffix3
    suffix2 := to_number(to_char(add_months(sysdate, -2), 'yyyymm'));
    suffix3 := to_number(to_char(add_months(sysdate, -3), 'yyyymm'));


    table_name := 'APP_3B_' || suffix1;


    sql_stmt := 'CREATE TABLE ' || table_name || ' AS
    WITH edit_tb AS
    (
        SELECT
            SUBSTR(ACCS_MTHD_KEY, 3) AS SUBSCRIBER_ID,
            LOAI_TB,
            TOTAL_TKC,
            HNDST_BRND_CD,
            HNDST_MDL_TYP_CD,
            ROW_NUMBER() OVER(PARTITION BY SUBSTR(ACCS_MTHD_KEY, 3) ORDER BY NULL) AS row_num
        FROM
            CUOCVINA.HCM_KPI_VINAPHONE_' || suffix1 || '
    ),
    avg_data AS
    (
        SELECT
            SUBSCRIBER_ID,
            ROUND((COALESCE(SUM(total_tkc), 0) / 3), 3) AS avg_total_tkc
        FROM (
            SELECT to_char(SUBSCRIBER_ID) as SUBSCRIBER_ID, to_number(total_tkc) as total_tkc
            FROM cuocvina.TIEUDUNG_BTS_' || suffix1 || '
            UNION ALL
            SELECT to_char(SUBSCRIBER_ID), to_number(total_tkc)
            FROM cuocvina.TIEUDUNG_BTS_' || suffix2 || '
            UNION ALL
            SELECT to_char(SUBSCRIBER_ID), to_number(total_tkc)
            FROM cuocvina.TIEUDUNG_BTS_' || suffix3 || '
        ) all_data
        GROUP BY SUBSCRIBER_ID
    )
    SELECT
        b.*,
        a.avg_total_tkc AS tkc_avg,
        ''84'' || a.SUBSCRIBER_ID AS SUBSCRIBER_ID_84
    FROM
        (
            SELECT
                a.SUBSCRIBER_ID,
                a.HNDST_BRND_CD,
                a.HNDST_MDL_TYP_CD,
                b.LOAI_SIM,
                b.GOI_KMCB_SU_DUNG AS goicuoc_chinh,
                b.service_id AS goicuoc_data,
                CASE
                    WHEN tkc_data = 0
                        AND DATA_USG = 0
                        AND DATA_BLLD_USG = 0
                        AND TOT_DATA_DISC_AMT = 0
                        AND TOT_DATA_PAYG_RVN_AMT = 0
                        AND b.service_id IS NULL
                    THEN 1
                    ELSE 0
                END AS nondata,
                b.TIME_END
            FROM
                cuocvina.TIEUDUNG_BTS_' || suffix1 || '  b
            LEFT JOIN
                edit_tb a ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID AND a.row_num = 1
        ) b
    LEFT JOIN
        avg_data a
    ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID';


    DBMS_OUTPUT.PUT_LINE('SQL Statement: ' || DBMS_LOB.SUBSTR(sql_stmt, 4000, 1));

    -- Execute the SQL statement
    EXECUTE IMMEDIATE sql_stmt;
END;
/

											----RUN:
										/
										BEGIN
										    CREATE_APP_3B_TABLE(202409);

                                        END;
