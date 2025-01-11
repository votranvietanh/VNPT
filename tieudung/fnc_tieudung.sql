               --NOT YET --runnn:
                                    BEGIN
                                        CREATE_TIEUDUNG_BTS_PBH_TABLES('202407');
                                    END;
                                    /    
                                      --exp_FTP
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Hoc Mon'; --HMN
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Tan Binh'; --TBH
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Cho Lon';--CLN
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Sai Gon';--SGN
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Thu Duc';--TDC
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Binh Chanh';--BCH
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Gia Dinh';--GDH
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Nam Sai Gon';--NSG
select * from cuocvina.TIEUDUNG_BTS_202412_kieumoi_T where PBHKV ='Phong Ban Hang Khu Vuc Cu Chi';--CCI


                --script:
CREATE OR REPLACE PROCEDURE CREATE_TIEUDUNG_BTS_PBH_TABLES(p_month VARCHAR2) 
AUTHID CURRENT_USER IS
    table_name1 VARCHAR2(80);
    table_name2 VARCHAR2(80);
    table_name3 VARCHAR2(80);
BEGIN
    -- T?o tï¿½n b?ng d?a trï¿½n thï¿½ng
    table_name1 := ' tieudung_bts_pbh_' || p_month||'';
    table_name2 := ' tieudung_bts_' || p_month ||'';
    table_name3 := ' TIEUDUNG_BTS_' || p_month || '_kieumoi_T';

    -- 
 
    EXECUTE IMMEDIATE ' CREATE TABLE ' || table_name3 || ' AS 
    SELECT SUBSCRIBER_ID, 
           PROVINCE_CODE_INIT, 
           PROVINCE_NAME, 
           BTS_NAME, 
           TO_NUMBER(BTS_DURATION) AS BTS_DURATION, 
           TO_NUMBER(TOTAL_DURATION) AS TOTAL_DURATION, 
           TO_NUMBER(BTS_CALL) AS BTS_CALL, 
           TO_NUMBER(BTS_SMS) AS BTS_SMS, 
           TO_NUMBER(BTS_DATA) AS BTS_DATA, 
           TO_NUMBER(BTS_VAS) AS BTS_VAS, 
           TO_NUMBER(BTS_OTHER) AS BTS_OTHER, 
           TO_NUMBER(TOTAL_CALL) AS TOTAL_CALL, 
           TO_NUMBER(TOTAL_SMS) AS TOTAL_SMS, 
           TO_NUMBER(TOTAL_DATA) AS TOTAL_DATA, 
           TO_NUMBER(TOTAL_VAS) AS TOTAL_VAS, 
           TO_NUMBER(TOTAL_OTHER) AS TOTAL_OTHER, 
           TO_NUMBER(TOTAL_TKC) AS TOTAL_TKC, 
           TOTAL_CORE_BALANCE, 
           TO_NUMBER(TKC_CALL) AS TKC_CALL, 
           TO_NUMBER(TKC_SMS) AS TKC_SMS, 
           TO_NUMBER(TKC_DATA) AS TKC_DATA, 
           TO_NUMBER(TKC_VAS) AS TKC_VAS, 
           TO_NUMBER(TKC_OTHER) AS TKC_OTHER, 
           COS_NAME, 
           TO_DATE(DATE_ENTER_ACTIVE, ''DD/MM/YYYY HH24:MI:SS'') AS DATE_ENTER_ACTIVE, 
           TO_DATE(ACCT_EXPIRE_DATE, ''DD/MM/YYYY HH24:MI:SS'') AS ACCT_EXPIRE_DATE, 
           CURR_STATE, 
           SERVICE_CODE, 
           TO_DATE(TIME_START, ''DD/MM/YYYY HH24:MI:SS'') AS TIME_START, 
           TO_DATE(TIME_END, ''DD/MM/YYYY HH24:MI:SS'') AS TIME_END, 
           LIFE_CYCLE_STAT_CD, 
           TO_NUMBER(TOT_DISC_AMT) AS TOT_DISC_AMT, 
           TO_NUMBER(TOT_VOICE_DISC_AMT) AS TOT_VOICE_DISC_AMT, 
           TO_NUMBER(TOT_VOICE_ONNET_OG_RVN_AMT) AS TOT_VOICE_ONNET_OG_RVN_AMT, 
           TO_NUMBER(TOT_VOICE_OFFNET_OG_RVN_AMT) AS TOT_VOICE_OFFNET_OG_RVN_AMT, 
           TO_NUMBER(TOT_SMS_DISC_AMT) AS TOT_SMS_DISC_AMT, 
           TO_NUMBER(TOT_SMS_ONNET_OG_RVN_AMT) AS TOT_SMS_ONNET_OG_RVN_AMT, 
           TO_NUMBER(TOT_SMS_OFFNET_OG_RVN_AMT) AS TOT_SMS_OFFNET_OG_RVN_AMT, 
           TO_NUMBER(TOT_DATA_DISC_AMT) AS TOT_DATA_DISC_AMT, 
           TO_NUMBER(TOT_DATA_PAYG_RVN_AMT) AS TOT_DATA_PAYG_RVN_AMT, 
           TO_NUMBER(VOICE_ONNET_OG_USG) AS VOICE_ONNET_OG_USG, 
           TO_NUMBER(VOICE_OFFNET_OG_USG) AS VOICE_OFFNET_OG_USG, 
           TO_NUMBER(VOICE_ONNET_IC_USG) AS VOICE_ONNET_IC_USG, 
           TO_NUMBER(VOICE_OFFNET_IC_USG) AS VOICE_OFFNET_IC_USG, 
           TO_NUMBER(SMS_CNT) AS SMS_CNT, 
           TO_NUMBER(SMS_ONNET_CNT) AS SMS_ONNET_CNT, 
           TO_NUMBER(SMS_OFFNET_CNT) AS SMS_OFFNET_CNT, 
           TO_NUMBER(DATA_USG) AS DATA_USG, 
           TO_NUMBER(DATA_BLLD_USG) AS DATA_BLLD_USG, 
           TO_NUMBER(RCHRG_AMT) AS RCHRG_AMT, 
           HNDST_MDL_TYP_CD, 
           HNDST_MDL_CD, 
           LOAI_SIM, 
           SL_CHNL_RPRSTV_NAME, 
           SERVICE_ID, 
           TO_NUMBER(LOAI_GOI_DATA) AS LOAI_GOI_DATA, 
           TO_DATE(TIME_START_PACK, ''DD/MM/YYYY HH24:MI:SS'') AS TIME_START_PACK, 
           TO_DATE(TIME_END_PACK, ''DD/MM/YYYY HH24:MI:SS'') AS TIME_END_PACK, 
           GOI_KMCB_SU_DUNG, 
           TO_NUMBER(PAYMENT_FREE_CYCLE) AS PAYMENT_FREE_CYCLE, 
           TO_NUMBER(CHU_KY_KMCB_DANG_SU_DUNG) AS CHU_KY_KMCB_DANG_SU_DUNG, 
           TO_DATE(NGAY_KMCB_GH_TIEP_THEO, ''DD/MM/YYYY HH24:MI:SS'') AS NGAY_KMCB_GH_TIEP_THEO, 
           TO_NUMBER(MAIN_ACCT_BAL_AMT) AS MAIN_ACCT_BAL_AMT, 
           TO_NUMBER(VOICE_FREE_USG) AS VOICE_FREE_USG, 
           TO_DATE(DT_OF_BRTH, ''YYYY/MM/DD HH24:MI:SS'') AS DT_OF_BRTH, 
           SUBSTR(a.BTS_NAME, 4, 6) AS ma_bts,
           (select nvl(x.ma_pb,''_KXD'') from vietanhvt.dm_pbh x where x.ten_pbh_kodau = b.PBHKV)  AS ma_pb, 
          ''84'' || a.SUBSCRIBER_ID AS SUBSCRIBER_ID_84, 
               NVL(b.PBHKV, ''_KXD'') AS PBHKV 
        FROM vinatt.TIEUDUNG_LUYKENGAY_' || p_month || ' a 
        LEFT JOIN ttkdhcm_ktnv.db_bts b 
        ON UPPER(SUBSTR(a.BTS_NAME, 4, 6)) = b.MA_BTS';
        
        --pbh
         EXECUTE IMMEDIATE ' create table '||table_name1||' as
        (
          SELECT 
            SUBSCRIBER_ID,												
        SUM(TOTAL_CALL) AS TOTAL_CALL,												
        SUM(TOTAL_SMS) AS TOTAL_SMS,												
        SUM(TOTAL_DATA) AS TOTAL_DATA,												
        SUM(TOTAL_VAS) AS TOTAL_VAS,												
        SUM(TOTAL_OTHER) AS TOTAL_OTHER,												
        SUM(TOTAL_TKC) AS TOTAL_TKC,												
        MIN(TOTAL_CORE_BALANCE) AS TOTAL_CORE_BALANCE,												
        SUM(TKC_CALL) AS TKC_CALL,												
        SUM(TKC_SMS) AS TKC_SMS,												
        SUM(TKC_DATA) AS TKC_DATA,												
        SUM(TKC_VAS) AS TKC_VAS,												
        SUM(TKC_OTHER) AS TKC_OTHER,												
        MAX(DATE_ENTER_ACTIVE) AS DATE_ENTER_ACTIVE,										
        MAX(ACCT_EXPIRE_DATE) AS ACCT_EXPIRE_DATE,												
        MAX(CURR_STATE) AS CURR_STATE,												
        MAX(SERVICE_CODE) AS SERVICE_CODE,												
        MAX(TIME_START) AS TIME_START,												
        MAX(TIME_END) AS TIME_END,												
        MAX(LIFE_CYCLE_STAT_CD) AS LIFE_CYCLE_STAT_CD,												
        SUM(TOT_DISC_AMT) AS TOT_DISC_AMT,												
        SUM(TOT_VOICE_DISC_AMT) AS TOT_VOICE_DISC_AMT,												
        SUM(TOT_VOICE_ONNET_OG_RVN_AMT) AS TOT_VOICE_ONNET_OG_RVN_AMT,												
        SUM(TOT_VOICE_OFFNET_OG_RVN_AMT) AS TOT_VOICE_OFFNET_OG_RVN_AMT,												
        SUM(TOT_SMS_DISC_AMT) AS TOT_SMS_DISC_AMT,												
        SUM(TOT_SMS_ONNET_OG_RVN_AMT) AS TOT_SMS_ONNET_OG_RVN_AMT,												
        SUM(TOT_SMS_OFFNET_OG_RVN_AMT) AS TOT_SMS_OFFNET_OG_RVN_AMT,												
        SUM(TOT_DATA_DISC_AMT) AS TOT_DATA_DISC_AMT,												
        SUM(TOT_DATA_PAYG_RVN_AMT) AS TOT_DATA_PAYG_RVN_AMT,												
        SUM(VOICE_ONNET_OG_USG) AS VOICE_ONNET_OG_USG,												
        SUM(VOICE_OFFNET_OG_USG) AS VOICE_OFFNET_OG_USG,												
        SUM(VOICE_ONNET_IC_USG) AS VOICE_ONNET_IC_USG,												
        SUM(VOICE_OFFNET_IC_USG) AS VOICE_OFFNET_IC_USG,												
        SUM(SMS_CNT) AS SMS_CNT,												
        SUM(SMS_ONNET_CNT) AS SMS_ONNET_CNT,												
        SUM(SMS_OFFNET_CNT) AS SMS_OFFNET_CNT,												
        SUM(DATA_USG) AS DATA_USG,												
        SUM(DATA_BLLD_USG) AS DATA_BLLD_USG,												
        MAX(HNDST_MDL_TYP_CD) AS HNDST_MDL_TYP_CD,												
        MAX(HNDST_MDL_CD) AS HNDST_MDL_CD,												
        MAX(LOAI_SIM) AS LOAI_SIM,												
        MAX(SL_CHNL_RPRSTV_NAME) AS SL_CHNL_RPRSTV_NAME,												
        MAX(SERVICE_ID) AS SERVICE_ID,												
        MAX(LOAI_GOI_DATA) AS LOAI_GOI_DATA,												
        MAX(TIME_START_PACK) AS TIME_START_PACK,												
        MAX(TIME_END_PACK) AS TIME_END_PACK,												
        MAX(GOI_KMCB_SU_DUNG) AS GOI_KMCB_SU_DUNG,												
        MAX(PAYMENT_FREE_CYCLE) AS PAYMENT_FREE_CYCLE,												
        MAX(CHU_KY_KMCB_DANG_SU_DUNG) AS CHU_KY_KMCB_DANG_SU_DUNG,												
        MAX(NGAY_KMCB_GH_TIEP_THEO) AS NGAY_KMCB_GH_TIEP_THEO,	
        MAX(DT_OF_BRTH) as DT_OF_BRTH,
        
        SUBSCRIBER_ID_84,												
        nvl(pbhkv,''_KXD'') as pbhkv	,											
        ma_pb,
        MAX(BTS_NAME) KEEP (DENSE_RANK LAST ORDER BY TOTAL_TKC, TOTAL_DATA) AS BTS_NAME,
        MAX(ma_bts) KEEP (DENSE_RANK LAST ORDER BY TOTAL_TKC, TOTAL_DATA) AS ma_bts
        FROM 
            '||table_name3||' a --<<<========== edit it
        GROUP BY 
            SUBSCRIBER_ID,SUBSCRIBER_ID_84,ma_pb,nvl(pbhkv,''_KXD'') 
        )';
        
       execute immediate 'create table '||table_name2||' as 
            with mapSub as (select * from (
                select  SUBSCRIBER_ID,PBHKV,ma_pb,ma_bts,BTS_NAME,TOTAL_TKC,
                row_number () over (partition by SUBSCRIBER_ID order by TOTAL_TKC desc,DATA_USG desc ) rn
                from '||table_name3||' a --<<<========== edit it
            ) 
                where rn = 1)
                ,
              t4 as (
              SELECT 
            SUBSCRIBER_ID,
            SUM(TOTAL_CALL) AS TOTAL_CALL,												
            SUM(TOTAL_SMS) AS TOTAL_SMS,												
            SUM(TOTAL_DATA) AS TOTAL_DATA,												
            SUM(TOTAL_VAS) AS TOTAL_VAS,												
            SUM(TOTAL_OTHER) AS TOTAL_OTHER,												
            SUM(TOTAL_TKC) AS TOTAL_TKC,												
            MIN(TOTAL_CORE_BALANCE) AS TOTAL_CORE_BALANCE,												
            SUM(TKC_CALL) AS TKC_CALL,												
            SUM(TKC_SMS) AS TKC_SMS,												
            SUM(TKC_DATA) AS TKC_DATA,												
            SUM(TKC_VAS) AS TKC_VAS,												
            SUM(TKC_OTHER) AS TKC_OTHER,												
            MAX(DATE_ENTER_ACTIVE) AS DATE_ENTER_ACTIVE,										
            MAX(ACCT_EXPIRE_DATE) AS ACCT_EXPIRE_DATE,												
            MAX(CURR_STATE) AS CURR_STATE,												
            MAX(SERVICE_CODE) AS SERVICE_CODE,												
            MAX(TIME_START) AS TIME_START,												
            MAX(TIME_END) AS TIME_END,												
            MAX(LIFE_CYCLE_STAT_CD) AS LIFE_CYCLE_STAT_CD,												
            SUM(TOT_DISC_AMT) AS TOT_DISC_AMT,												
            SUM(TOT_VOICE_DISC_AMT) AS TOT_VOICE_DISC_AMT,												
            SUM(TOT_VOICE_ONNET_OG_RVN_AMT) AS TOT_VOICE_ONNET_OG_RVN_AMT,												
            SUM(TOT_VOICE_OFFNET_OG_RVN_AMT) AS TOT_VOICE_OFFNET_OG_RVN_AMT,												
            SUM(TOT_SMS_DISC_AMT) AS TOT_SMS_DISC_AMT,												
            SUM(TOT_SMS_ONNET_OG_RVN_AMT) AS TOT_SMS_ONNET_OG_RVN_AMT,												
            SUM(TOT_SMS_OFFNET_OG_RVN_AMT) AS TOT_SMS_OFFNET_OG_RVN_AMT,												
            SUM(TOT_DATA_DISC_AMT) AS TOT_DATA_DISC_AMT,												
            SUM(TOT_DATA_PAYG_RVN_AMT) AS TOT_DATA_PAYG_RVN_AMT,												
            SUM(VOICE_ONNET_OG_USG) AS VOICE_ONNET_OG_USG,												
            SUM(VOICE_OFFNET_OG_USG) AS VOICE_OFFNET_OG_USG,												
            SUM(VOICE_ONNET_IC_USG) AS VOICE_ONNET_IC_USG,												
            SUM(VOICE_OFFNET_IC_USG) AS VOICE_OFFNET_IC_USG,												
            SUM(SMS_CNT) AS SMS_CNT,												
            SUM(SMS_ONNET_CNT) AS SMS_ONNET_CNT,												
            SUM(SMS_OFFNET_CNT) AS SMS_OFFNET_CNT,												
            SUM(DATA_USG) AS DATA_USG,												
            SUM(DATA_BLLD_USG) AS DATA_BLLD_USG,												
            MAX(HNDST_MDL_TYP_CD) AS HNDST_MDL_TYP_CD,												
            MAX(HNDST_MDL_CD) AS HNDST_MDL_CD,												
            MAX(LOAI_SIM) AS LOAI_SIM,												
            MAX(SL_CHNL_RPRSTV_NAME) AS SL_CHNL_RPRSTV_NAME,												
            MAX(SERVICE_ID) AS SERVICE_ID,												
            MAX(LOAI_GOI_DATA) AS LOAI_GOI_DATA,												
            MAX(TIME_START_PACK) AS TIME_START_PACK,												
            MAX(TIME_END_PACK) AS TIME_END_PACK,												
            MAX(GOI_KMCB_SU_DUNG) AS GOI_KMCB_SU_DUNG,												
            MAX(PAYMENT_FREE_CYCLE) AS PAYMENT_FREE_CYCLE,												
            MAX(CHU_KY_KMCB_DANG_SU_DUNG) AS CHU_KY_KMCB_DANG_SU_DUNG,												
            MAX(NGAY_KMCB_GH_TIEP_THEO) AS NGAY_KMCB_GH_TIEP_THEO,
            MAX(DT_OF_BRTH) as DT_OF_BRTH,
                SUBSCRIBER_ID_84
            FROM 
                '||table_name3||' a --<<<========== edit it 
            GROUP BY 
                SUBSCRIBER_ID,SUBSCRIBER_ID_84)
                 select a.*,b.ma_pb, nvl(b.pbhkv,''_KXD'') as pbhkv , b.ma_bts, b.bts_name
                 from t4 a
                 join mapSub  b on a.SUBSCRIBER_ID=b.SUBSCRIBER_ID';
                       -- tao index o bang  4tr
EXECUTE IMMEDIATE 'CREATE INDEX idx_pbh_sub_id'||p_month||' ON '||table_name1||' (SUBSCRIBER_ID)';
EXECUTE IMMEDIATE 'CREATE INDEX idx_pbh_sub_id84'||p_month||' ON '||table_name1||' (SUBSCRIBER_ID_84)';
-- tao index o bang  2tr
EXECUTE IMMEDIATE 'CREATE INDEX idx_sub_id'||p_month||' ON '||table_name2||' (SUBSCRIBER_ID)';
EXECUTE IMMEDIATE 'CREATE INDEX idx_sub_id84'||p_month||' ON '||table_name2||' (SUBSCRIBER_ID_84)';
-- tao index o bang  FULL
EXECUTE IMMEDIATE 'CREATE INDEX idx_full_id'||p_month||' ON '||table_name3||' (SUBSCRIBER_ID)';
EXECUTE IMMEDIATE 'CREATE INDEX idx_full_id84'||p_month||' ON '||table_name3||' (SUBSCRIBER_ID_84)';
END;
/
