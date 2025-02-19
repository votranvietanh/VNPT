---Schema COE_VNPT
----bang ptm, trang thai
                    select * from ocdm_sys.dwb_subscriber_kpi_mo_detail
                                    where mo_key=202205 and KPI_TYPE = 'PTM' and GEO_STATE_KEY = 35 and PROD_LN_CD = 1
                                                    and to_char(ACTVTN_DT, 'yyyymmdd') = '20220601' ;
                    GEO_STATE_KEY = 35 --HCM
                    PROD_LN_CD = 1 --(1: vnptt, 2 vnp ts)
                    mo_key  ----thang PTM
                    ACTVTN_DT ---ngay PTM;
                    ACCT_KEY  ---key acc KH;
                    KPI_TYPE ---trang thai; K1C_MO, K2C_MO, HUY

-----bang trang thai tbao online
----thoi gian khoa huy can cu theo Day_key
select * from ocdm_sys.DWB_OCS_SUBSCRIBER_KPI_DETAIL a where a.day_key between 20240101 and 20240129 and a.kpi_name  in ('HUY','XOA');
		--kpi_name in ('k1c')
		--kpi_name in ('k2c')
----   `
----bang ptm, trang thai, thong tin KH, thông nvien bán, nv kich hoat
SELECT * fROM QLKD3.DWB_ACCT_ACTVTN@COE_QLKD3
                        WHERE MO_KEY = 202203
                                            and ACTVTN_DT >= to_date(20220301, 'YYYYMMDD')
                                            and ACTVTN_DT < to_date(20220301, 'YYYYMMDD') + 1
;
SELECT * fROM QLKD3.DWD_DATA_DDTT_DETAIL@COE_QLKD3
                    where ACTVTN_DT >= to_date(20220301, 'YYYYMMDD')
                                                            and ACTVTN_DT < to_date(20220331, 'YYYYMMDD') + 1;

                      --  SRC_SYS_KEY: kenh dang ky (shop, SMCS, CCBS, app, ....);
                     -- PROVINCE_DK: tinh HCM 35

--—> doanh thu tkc; field tot_rvn_amt —> bang mo —> doanh thu tkc

                    select * from ocdm_sys.dwa_vnp_cust_dna_mo where mo_key = 202205; --(key mapping ACCS_MTHD_KEY)
                    and sub_partition_key = mod(84858011647, 50) + 1  ---same index table
                    ---key prod_ln_cd  = (2 : VNP tra sau, 1: VNP tra truoc)
                    ---and b.MVMO_OPRTR_CD = 'VINAPHONE'  ---tbao VNP, not ITEL doitac

-----> Bang ten tram key 'cell_site_key'
                    select * from ocdm_Sys.dwr_cell_site
;
---—> doanh thu mua goi --field gl_rvn —> bang price_evt —> doanh thu mua gói
                        select * from ocdm_sys.dwb_price_evt;
                       --replace field dthu goi FEE_RVN
                       select * from OCDM_SYS.DWB_PROD_SBRP_HIST;
                       ----> kenh dang ky mua goi, dthu goi cot TKC
                    select * from PPS_SUBS.CHITIET_SUB_KM_SMRS@bi_pima where to_number(to_char(logdate, 'yyyymm')) = 202203;

;
-----> don vi PTM, phong, BTS theo vb 5917, moi ngày snapshot/lan, vi vay lay 1 ngay cuoi thang
            ---thong tin SMP and FTP, GEO_state_key, thiet bi Phone, nonesmart
			---thong tin nhan vien ban, kích hoat
select * from ocdm_Sys.dwb_accs_mthd_hist where day_key = 20220430; and ACCS_MTHD_KEY = '84948017901';
                ----MVMO_OPRTR_CD = 'VINAPHONE' xac dinh tap TCTY VINAPHONE, loai tru doi tac thue;
                ----HNDST_MDL_TYP_CD 4g, 5g, 3g la smp;
                ---key prod_ln_cd  = (2 : VNP tra sau, 1: VNP tra truoc)

----> tbao dang su dung goi gi?
select * from ocdm_sys.dwb_prod_sbrp;
---> danh muc goi
select * from ocdm_sys.dwr_prod_spec --(prod_spec_key)
;
--—> danh muc Phong ban hang 5917
            SELECT * fROM QLKD3.RESELLER@COE_QLKD3 where RESELLER_CODE = 'VNP0700000'
;
-----> danhm code_hrm, ma_nv CTV, Phong ban hang
            SELECT * FROM HRM_NHANVIEN@LANDING2 WHERE EMPLOYEE_CODE = 'CTV062723';  ---bo bang nay
            SELECT * fROM QLKD3.staff@COE_QLKD3 where STAFF_CODE = 'CTV062723'; ---lay bang nay
;

----> loai sim
select * from ocdm_sys.dwr_prod_ofr; key prod_ofr_key --> PROD_OFR_DSCR
;
----> chi tra hoa hong tren shop
select * from ocdm_stage.data_sim_tt_202203
;

----> danh muc cac goi
            SELECT * FROM OCDM_STAGE.DWR_MAP_PACKAGE_SMCS where SERVICE_CODE like 'FCLUB%'; or TENGOI = 'FCLUB_6T';
            select distinct BUSINESS_KEY
                                , case when BUSINESS_KEY like 'MI_BIGH%' then 'BÁNH MÌ'
                                                when BUSINESS_KEY like 'MI_BUMDATA' then 'BDATA'
                                                when BUSINESS_KEY like 'MI_MAXKMCB256_3GB_6M' then 'BUMKID'
                                                when BUSINESS_KEY like 'SPS_PRODUCT_MI_MAX_6GB_3M' then 'BUMKM'
                                                when BUSINESS_KEY like 'MI_MAXKMCB_3GB' then 'B70'
                                                else tengoi
                                    end tengoi

                                , RATIO_VOICE, RATIO_SMS, RATIO_DATA, RATIO_OTHER, RATIO_VAS, SBRP_FEES, a.USG_TYP_CD
                                , VLDTY_PERIOD, VLDTY_PERIOD_UOM, P2_CHU_KY
               from ocdm_sys.dwr_prod_spec a
                                    left join ocdm_stage.data_sim_tt_202203 b on a.BUSINESS_KEY = b.SERVICE_CODE
                ;
                select BUSINESS_KEY, PROD_SPEC_DSCR, RATIO_VOICE, RATIO_SMS, RATIO_DATA, RATIO_OTHER, RATIO_VAS, SBRP_FEES, USG_TYP_CD
                                ,  case when SRC_SYS_KEY = 7 then 'hethong_data'
                                        when SRC_SYS_KEY = 8 then 'hethong_kmcb'
                                        else null
                                end SRC_SYS_KEY, VLDTY_PERIOD, VLDTY_PERIOD_UOM, AUTO_EXTEND_IND, CYCLE_MONTHS
                from ocdm_sys.dwr_prod_spec a ;where BUSINESS_KEY = 'MI_BUMDATA';

                select accs_mthd_key, PROD_SPEC_DSCR, PROD_SPEC_NAME, SHORT_NAME
                                , USG_TYP_CD, SBRP_FEES, BUSINESS_KEY, VLDTY_PERIOD, VLDTY_PERIOD_UOM
                from OCDM_SYS.DWB_PROD_SBRP_HIST a join ocdm_sys.dwr_prod_spec b on b.BUSINESS_KEY = a.SERVICE_CODE
                where day_key between 20220401 and 20220426 and accs_mthd_key= '84813968389';
;
----VNP tsau
ocdm_sys.dwr_geo_state —> tinh
ocdm_sys.dwr_geo_city where GEO_STATE_KEY = 35; —> quan huyen
ocdm_sys.dwr_geo_Cnty where GEO_CITY_KEY = 70143 —> phuong xa
OCDM_SYS.DWR_CUST —> thong tin KH tra truoc va tra sau

select * from ccs_common.loai_gts@bi_vnpccbs;
select * from ccs_common.doituongs@bi_vnpccbs;
select * from ccs_common.nganhnghes@bi_vnpccbs;
select * from ccs_hcm.DANHBA_DDS_PTTB@BI_VNPCCBS;  ---danh ba online
select * from ccs_hcm.DANHBA_DDS_052022@BI_VNPCCBS;  ---danh ba chot thang
ocdm_Sysfix.dwr_cust --> thong tin KH fiber, mega
select * From ocdm_Stage.STB_CCS_CTDD_MO where mo_key = 202203; ---> chi tiet di dong
select * From OCDM_sTAGE.STG_CCS_DANHBA_DDS_MO@LANDING2 WHERE MO_KEY = 202203 and PROVINCE_CD = 'HCM';; --- danh ba thue bao
select * From OCDM_sTAGE.STG_CCS_KHACHHANGS@LANDING2 WHERE DAY_KEY = 20220420 and STATE_CD = 'HCM';  --- thong tin KH, provin_code =  HCM
SELECT * FROM ttkd_bct.db_thuebao_ttkd@BI_SGN;
----goi VNP tra sau---
            SELECT * fROM OCDM_sTAGE.STG_CCBS_PACKAGE_DATA WHERE DAY_KEY = 20220131;
---***--Cuong----
    ---lay du leu voice----
            select accs_mthd_key, sum(voice_usg) voice_usg from ocdm_Sys.dwa_vnp_cust_dna_mo where mo_key = 202201 and prod_ln_cd = 2 and geo_State_key = 35 group by accs_mthd_key;
    ---lay du lieu data-----
            select mo_key, accs_mthd_key, prod_ln_Cd, data_usg from ocdm_Sys.dwa_vnp_cust_dna_mo where mo_key = 202203 and prod_ln_cd = 1 and geo_State_key = 35;
            ---lay du lieu sms-----
            select mo_key, accs_mthd_key, prod_ln_Cd, sms_cnt from ocdm_Sys.dwa_vnp_cust_dna_mo where mo_key = 202203 and prod_ln_cd = 1 and geo_State_key = 35;
 ;
 ------**Phuong---
    --lay du lieu site name BTS tinh
        select distinct a.ma_tb, b.tot_rvn_amt Dthu_TKC, b.cell_site_key, c.SITE_NAME Tram_BTS, PIMA_PROVINCE_CODE MA_TINH
                from a_matb a, ocdm_sys.dwa_vnp_cust_dna_mo b, ocdm_Sys.dwr_cell_site c
                where a.ma_tb = b.accs_mthd_key and b.mo_key = 202202 and b.prod_ln_Cd = 1
                                and b.cell_site_key = c.cell_site_key
;

------loai SIm 2G, 3G, 4G
        create table a_loai_sim_202208 tablespace COE_VNPT_TBS as
        select ACCS_MTHD_KEY ma_tb,(case when substr(imsi,1,5)='45202'
                       and substr(imsi,6,3) in('105','106','107','108','109','111','112','222','113','114','790','115') then '4G' else '2G,3G' end
                      ) loai_sim
 from ocdm_Sys.dwb_accs_mthd_hist@COEVNPT a where day_key <= 20211231 and GEO_STATE_KEY = 35 and PROD_LN_CD = 2
;
        create index a_loai_sim_202208_matb on a_loai_sim_202208 (ma_tb) ;
------

    ----lay du lieu luu luong thoai 3 nha mang
			--danh muc:
                   select * from OCDM_SYS.DWR_EXTRNL_OPRTR where CNTRY_NAME in ('Vietnam', 'VIETNAM') and EXTRNL_OPRTR_VNP_CD != 'VNPT';   ----ISP provider
            DECLARE
                        I NUMBER(10);
                        j NUMBER(10);
			BEGIN
			FOR I IN (select day_key from ocdm_Sys.dwr_day where day_key between 20220801 and 20220801)
                        LOOP
                                for j in 1..50
                                            loop
                                                            insert into VNPtsau_huong
                                                                    select DAY_KEY, SUB_PART_KEY, msisdn
                                                                            , SUM(CASE WHEN EXTRNAL_OPRTR_KEY= '106083' THEN CALL_DURATION ELSE 0 END) AS THOAI_VNP
                                                                            , SUM(CASE WHEN EXTRNAL_OPRTR_KEY= '106084' THEN CALL_DURATION ELSE 0 END) AS LOG_OCS_VMS
                                                                            , SUM(CASE WHEN EXTRNAL_OPRTR_KEY= '106085' THEN CALL_DURATION ELSE 0 END) AS LOG_OCS_VTL
                                                                            , SUM(CASE WHEN EXTRNAL_OPRTR_KEY NOT IN ('106083', '103084', '105085') AND EXTRNAL_OPRTR_KEY IS NULL
                                                                                        THEN CALL_DURATION ELSE 0 END
                                                                                ) AS LOG_OCS_OTHERS
                                                                    From ocdm_stage.stg_ericsson_nokia@LANDING1 a
                                                                    where day_key = I.DAY_KEY and sub_part_key = j
                                                                            and exists (select 1 from dwa_vnp_cust_dna_mo_2022 where mo_key = 202208 and a.msisdn = accs_mthd_key)
                                                                            and call_type = 'MOC'
                                                                                    /* sub_part_key --partition table
                                                                                        SMO la tin nhan OUT
                                                                                        SMT la tin nhan IN
                                                                                        MOC la call OUT
                                                                                        MTC la call IN
                                                                                    */
                                                                            and EXTRNAL_OPRTR_KEY in (106001,106009,106010,106014,106015,106016,106017,106083,106084,106085,106086,106088,106089,106096,106097,106098)
                                                                    GROUP BY MSISDN, DAY_KEY, SUB_PART_KEY
                                            ;
                                            commit;
                                            end loop;
                        END LOOP;
			END;

            delete from VNPtsau_huong;
			dwa_vnp_cust_dna_mo_2022 --> tao ds tbao VNPtsau from table ...mo
			;
             insert into dwa_vnp_cust_dna_mo_ts
			select accs_mthd_key from ocdm_sys.dwa_vnp_cust_dna_mo where mo_key = 202205 and prod_ln_cd = 2 and MVMO_OPRTR_CD = 'VINAPHONE' and b.geo_state_key = 35
;
            ---Ds VNP tra truoc goi ck dai het han, tbao dang su dung goi gi
            select /*+ parallel(32) */
                            a.accs_mthd_key, payment_type,a.eff_from_dt,
                            ADD_MONTHS( a.eff_to_dt,nvl(a.payment_free_cycle,0)-nvl(a.current_using_cycle,0)) AS eff_to_dt ,short_name as service_code,c1.state_short_cd as ma_tinh
			from ocdm_sys.dwb_prod_sbrp  a
                              left join  ocdm_sys.DWR_PROD_SPEC b
                                            on a.PROD_SPEC_KEY=b.PROD_SPEC_KEY
                              left join OCDM_SYS.DWB_ACCS_MTHD_HIST c
                                            on c.day_key= TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(P_DAY_KEY, 'YYYYMMDD'), -1)), 'YYYYMMDD') and
                                                    a.accs_mthd_key=c.accs_mthd_key and c.sub_partition_key =mod(a.accs_mthd_key,50)+1
                               left join  ocdm_sys.dwr_geo_state c1 on  c1.geo_state_key=c.geo_state_key
            where
                         a.day_key=to_char( LAST_DAY(ADD_MONTHS( to_date( P_DAY_KEY,'yyyymmdd'),-1)) ,'yyyymmdd')
                         and a.prod_ln_cd=2 -- tra sau
                        and  a.stat_cd=1
                        and a.payment_type in ('3T','6T','12T')
                        and ADD_MONTHS( a.eff_to_dt,nvl(a.payment_free_cycle,0)-nvl(a.current_using_cycle,0))>=TRUNC( TO_DATE(P_DAY_KEY,'yyyymmdd'),'month')
                        and ADD_MONTHS( a.eff_to_dt,nvl(a.payment_free_cycle,0)-nvl(a.current_using_cycle,0))< ADD_MONTHS( TRUNC( TO_DATE(P_DAY_KEY,'yyyymmdd'),'month'),1)
;


            -----He thong KMCB va he thong DATA
                    select a.accs_mthd_key, a.payment_type, a.eff_from_dt,  a.eff_to_dt ,b.short_name as service_code
                            , case when b. SRC_SYS_KEY = 7 then 'hethong_data'
                                        when b. SRC_SYS_KEY = 8 then 'hethong_kmcb'
                                        else null
                            end hethong
                            , decode(b. SRC_SYS_KEY, 7, b.short_name) hethong_data
                            , decode(b. SRC_SYS_KEY, 8, b.short_name) hethong_kmcb
                             , rank() over (PARTITION BY a.accs_mthd_key ORDER BY a.EFF_TO_DT desc, a.payment_type desc) rnk
        from ocdm_sys.dwb_prod_sbrp  a
                         left join  ocdm_sys.DWR_PROD_SPEC b
                                    on a.PROD_SPEC_KEY=b.PROD_SPEC_KEY
                         join a_matb tb on a.accs_mthd_key = tb.ma_tb
        where a.day_key = 20220228 and b. SRC_SYS_KEY in (7, 8)
                         and a.prod_ln_cd=1 -- tra truoc
                        and  a.stat_cd=1   ---goi con han su dung
                        and  a.PAYMENT_TYPE != '0'---goi CKD
                        --and a.accs_mthd_key = '84913807000'
         ;

		 -------Du lieu ban goi CCOS qua IPCC------
		 select *
		 from PPS_SUBS.SUB_CCOS_GOI@BI_PIMA A
				INNER JOIN OCDM_STAGE.MAP_HRM_STATE_MYTV B
					ON A.HRM_CODE = B.EMPLOYEE_CODE AND NVL(B.STATE_SHORT_CD, '') = 'HCM'
        WHERE A.NGAY_THUC_HIEN >= TO_DATe(20220601, 'YYYYMMDD') AND A.NGAY_THUC_HIEN < TO_DATE(20220701, 'YYYYMMDD')
		;
		----Du lieu Shop------
		select * from ocdm_Stage.DWB_PAC_SIM_ONLINE_MO  where mo_key = 202206 and TINHBAN = 'HCM';
        select * from ocdm_Stage.DWB_SIM_ONLINE_MO where mo_key = 202206 AND TINHBAN = 'HCM';
		select * from ocdm_stage.DWB_DATA_SIM_ONLINE;
		;
		----Du lieu CTV XHH----
		SELECT * FROM (
			SELECT
					MSISDN,
					SAN_PHAM,
					TOTAL_AMOUNT,
					A.CREATE_DATE,
					CASE WHEN E.STATE_SHORT_CD = 'HAU' THEN 'HGI' ELSE E.STATE_SHORT_CD END AS AGENT_CODE,
					CASE WHEN D.RESELLER_TYPE = '6' THEN D.RESELLER_ID
					WHEN D.RESELLER_TYPE = '7' THEN K.RESELLER_ID
					ELSE D.RESELLER_ID END AS AGENT_DEPT_ID,
			--        D.RESELLER_ID AS AGENT_DEPT_ID,
					CASE WHEN D.RESELLER_TYPE = '6' THEN D.RESELLER_CONTACT_NAME
					WHEN D.RESELLER_TYPE = '7' THEN K.RESELLER_CONTACT_NAME
					ELSE D.RESELLER_CONTACT_NAME END AS AGENT_DEPT_NAME,
					a.CTV_CODE,
					b.MANVKD_QL
					FROM OCDM_sTAGE.DWB_DATA_DON_HANG A
					LEFT OUTER JOIN OCDM_STAGE.DATA_MAP_CTV_NVQL B
					ON A.CTV_CODE = B.CTV
					AND B.MO_KEY = 202206
					AND B.DAY_KEY >= 20220622
					LEFT OUTER JOIN QLKD3.STAFF@BI_QLKD3 C
							ON B.MANVKD_QL = C.STAFF_CODE
							LEFT OUTER JOIN QLKD3.RESELLER@BI_QLKD3 D
							 ON TO_CHAR(C.RESELLER_ID) = TO_CHAR(D.RESELLER_ID)
							  left outer join QLKD3.RESELLER@BI_QLKD3 k
							 on D.PARENT_RESELLER_ID = k.RESELLER_ID
							 and k.RESELLER_TYPE = '6'
							 LEFT OUTER JOIN OCDM_sYS.DWR_GEO_sTATE E
							 ON D.ADDRESS2 = E.GEO_sTATe_KEY
			--                 LEFT OUTER JOIN OCDM_SYS.DWR_GEO_STATE E
			--                 ON UPPER(A.TTKD) = UPPER('TTKD VNPT-' || DECODE(UPPER(E.GEO_STATE_NAME), 'ÐAK NÔNG', 'Ð?K NÔNG', 'TH?A THIÊN HU?', 'Th?a Thiên - Hu?', 'B?C C?N', 'B?C K?N', E.GEO_STATE_NAME))
							 WHERE
							 A.THANG = 202206
							 and
							 A.CREATE_DATE IS NOT NULL
							AND TO_DATE(A.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS') >= TO_DATE(20220601, 'YYYYMMDD')
							AND TO_DATE(A.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS') < TO_DATE(20220630, 'YYYYMMDD') + 1
							 AND A.DAY_KEY >= 20220622)
                 WHERE AGENT_CODE = 'HCM'
		;
		--CTV XHH
			SELECT * fROM ocdm_stage.DWB_DATA_DON_HANG WHERE THANG = '202406' and TTKD = 'TTKD VNPT-TP H? Chí Minh'
			;
		 --SHOP
			SELECT * FROM pps_subs.chitiet_sub_km_smrs@BI_PIMA E
			WHERE LOGDATE >= to_date(20220601, 'YYYYMMDD') AND e.LOGDATE < to_date(20220601, 'YYYYMMDD') + 1
			AND PROVINCE_CODE = 'HCM'
			AND PHUONG_THUC = 'SHOP';

			--SMCS
			  SELECT * FROM pps_subs.chitiet_sub_km_smrs@BI_PIMA E
			WHERE LOGDATE >= to_date(20220601, 'YYYYMMDD') AND e.LOGDATE < to_date(20220601, 'YYYYMMDD') + 1
			AND PROVINCE_CODE = 'HCM'
			AND PHUONG_THUC IN ('SERVICE_SALE', 'SERVICE_SALE_AGENT');

			 --CCOS
			SELECT * FROM pps_subs.chitiet_sub_km_smrs@BI_PIMA E
			WHERE LOGDATE >= to_date(20220601, 'YYYYMMDD') AND e.LOGDATE < to_date(20220601, 'YYYYMMDD') + 1
			AND PROVINCE_CODE = 'HCM'
			AND PHUONG_THUC = 'CCOS'
			;
				SELECT DISTINCT PHUONG_THUC FROM pps_subs.chitiet_sub_km_smrs@BI_PIMA E
			WHERE LOGDATE >= to_date(20220601, 'YYYYMMDD') AND e.LOGDATE < to_date(20220601, 'YYYYMMDD') + 1
			AND PROVINCE_CODE = 'HCM'
			AND PHUONG_THUC IS NOT NULL;

			SELECT * FROM pps_subs.chitiet_sub_km_smrs@BI_PIMA E
			WHERE LOGDATE >= to_date(20220601, 'YYYYMMDD') AND e.LOGDATE < to_date(20220601, 'YYYYMMDD') + 1
			AND PROVINCE_CODE = 'HCM'
			AND PHUONG_THUC = 'SHOP';

			SELECT * FROM pps_subs.chitiet_sub_km_smrs@BI_PIMA E
				WHERE LOGDATE >= to_date(20220601, 'YYYYMMDD') AND e.LOGDATE < to_date(20220601, 'YYYYMMDD') + 1
				AND PROVINCE_CODE = 'HCM';



LIFE_CYCLE_STAT_CD
1 active


2 -> khóa 1 chieu


3 -> khóa 2 chieu


4 huy


10 -> phát trien moi


7 -> lock


0 -> trang thái cho wait kích hoat


-1 -> thuê bao MNP, huy chu dong


SMO là tin nhan di


SMT là tin nhan tói phát

MOC là cuoc goi di


MTC là nhan cuoc goi
;


		****MNP, thay DATALINK bi_qlkd3 = coe_qlkd or bi_qlkd3= coe_qlkd3
		 with acc                  AS (SELECT DISTINCT
MIN(src) KEEP (DENSE_RANK FIRST ORDER BY priority ) OVER (PARTITION BY account_dk ) src
,MIN(unit_id) KEEP (DENSE_RANK FIRST ORDER BY priority ) OVER (PARTITION BY account_dk ) unit_id
,MIN(unit_name) KEEP (DENSE_RANK FIRST ORDER BY priority ) OVER (PARTITION BY account_dk ) unit_name
,MIN(reseller_id) KEEP (DENSE_RANK FIRST ORDER BY priority ) OVER (PARTITION BY account_dk ) reseller_id
,account_dk                        FROM
qlkd2.mv_account_dk2@bi_qlkd3)                 ,v2
AS (SELECT DISTINCT                             reseller_id
,reseller_contact_name reseller_name
,CONNECT_BY_ROOT reseller_id root_reseller_id
,CONNECT_BY_ROOT reseller_contact_name root_reseller_name
FROM qlkd2.reseller@bi_qlkd3
START WITH reseller_id = 3
CONNECT BY PRIOR reseller_id = parent_reseller_id)              SELECT
(select area_name
from mran.pm_province@bi_qlkd3 where province_code = a.province_init) area_name
,nvl(a.account_dk,' ') account_dk
,CASE WHEN acc.src LIKE 'nv%' THEN acc.unit_name ELSE NULL END nv
,r.reseller_name
,CASE WHEN acc.src LIKE 'ctv%'
THEN acc.unit_name ELSE NULL END ctv
,CASE WHEN acc.src LIKE 'daily%' THEN acc.unit_name ELSE NULL END daily
,pdk.area_name tinh_xuathang
,REPLACE(nvl(r2.reseller_contact_name, ' '),',',' ')  reseller_contact_name
,REPLACE(NVL(dl.ten_dai_ly, s.hoten),',',' ')  dbl_ctv                   ,a.id_dai_ly
,(CASE                          WHEN a.id_dai_ly IS NOT NULL THEN 'DL_UQ'
WHEN a.id_ctv IS NOT NULL THEN 'CTV'                          ELSE 'TTKD'
END) unit_type                   ,to_char(a.ngay_kh,'yyyy-mm-dd') ngay_kh
,to_char(a.ngay_xuat_hang,'yyyy-mm-dd') ngay_xuat_hang                   ,nvl(a.cos_name, ' ') cos_name
,nvl(b.acc_name,' ') acc_name                   ,a.subscriber_id                   ,a.serial                     ,bun.gia_goi
,bun.kenh                    ,to_char(a.BIRTHDAY,'yyyy-mm-dd') BIRTHDAY                   ,a.thang_kh_nt_0
,a.thang_kh_tkc_0                   ,nvl(a.province_kh_tkc_0,' ') province_kh_tkc_0                   ,a.thang_kh_nt_1
,a.thang_kh_tkc_1                   ,nvl(a.province_kh_tkc_1,' ') province_kh_tkc_1                   ,a.thang_kh_nt_2
,a.thang_kh_tkc_2                   ,nvl(a.province_kh_tkc_2,' ') province_kh_tkc_2                   ,a.thang_kh_nt_3
,a.thang_kh_tkc_3                   ,nvl(a.province_kh_tkc_3,' ') province_kh_tkc_3                    ,a.thang_kh_nt_4
,a.thang_kh_tkc_4                   ,nvl(a.province_kh_tkc_4,' ') province_kh_tkc_4                    ,a.thang_kh_nt_5
,a.thang_kh_tkc_5                   ,nvl(a.province_kh_tkc_5,' ') province_kh_tkc_5                    ,a.thang_kh_nt_6
,a.thang_kh_tkc_6                   ,nvl(a.province_kh_tkc_6,' ') province_kh_tkc_6                    ,a.thang_kh_nt_7
,a.thang_kh_tkc_7                   ,nvl(a.province_kh_tkc_7,' ') province_kh_tkc_7                    ,a.thang_kh_nt_8
,a.thang_kh_tkc_8                   ,nvl(a.province_kh_tkc_8,' ') province_kh_tkc_8                    ,a.thang_kh_nt_9
,a.thang_kh_tkc_9                   ,nvl(a.province_kh_tkc_9,' ') province_kh_tkc_9                    ,a.thang_kh_nt_10
,a.thang_kh_tkc_10                   ,nvl(a.province_kh_tkc_10,' ') province_kh_tkc_10                    ,a.thang_kh_nt_11
,a.thang_kh_tkc_11                   ,nvl(a.province_kh_tkc_11,' ') province_kh_tkc_11
,case when trunc(a.ngay_xuat_hang) < trunc(a.ngay_kh) + 2 then 'H?p l?' else ' ' end isValid,idnumber, mnp_user_id
,HANGKENH,LOAIKENH,bun.TEN_GOI,
gia_goi*call as dt_goi_call,gia_goi*sms as dt_goi_sms,gia_goi*data as dt_goi_data,
gia_goi*vat as dt_goi_vat,gia_goi*mytv as dt_goi_mytv,gia_goi*other as dt_goi_goi
FROM qlkd2.new_subscriber@bi_qlkd3 a
left  JOIN v2 r ON a.reseller_id_dk = r.reseller_id
LEFT JOIN acc ON a.account_dk = acc.account_dk
left JOIN mran.pm_province@bi_qlkd3 p ON a.province_dk = p.vnp_code
LEFT JOIN qlkd2.d_acc@bi_qlkd3 b ON a.acc = b.acc
left JOIN qlkd2.reseller@bi_qlkd3 r2 ON a.id_don_vi = r2.reseller_id
left join mran.pm_province@bi_qlkd3 pdk on r2.province = pdk.smcs_area_id
LEFT JOIN qlkd2.hh_daily_diembanle@bi_qlkd3 dl ON a.id_dai_ly = dl.id_dai_ly
LEFT JOIN qlkd2.ctv_ctv@bi_qlkd3 s ON s.id = a.id_ctv
join qlkd2.conf_bundle@bi_qlkd3 bun on a.acc=bun.acc
WHERE ngay_kh >= TO_DATE ('2022-06-01', 'yyyy-mm-dd')
AND ngay_kh < TO_DATE ('2022-06-12', 'yyyy-mm-dd') + 1
AND decode('HCM','-1','-1', decode('DK','DK',a.province_dk,a.province_init)) = 'HCM'  and rownum < 101
ORDER BY unit_type,ngay_kh;

select * from qlkd2.new_subscriber@coe_qlkd3 a           where SUBSCRIBER_ID = 706111176--MNP_USER_ID is not null
;



-----BRIS
SELECT * FROM OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TS_2025 p3
WHERE rownum < 10 --MA_TB = '84911050372'
  AND p3.LOAI_HM = 'HMM'
  AND p3.MA_KENH_BAN LIKE 'LK%' AND MA_TB = '84835612969'
  ;
--P0502  COT 32
SELECT SUM(DT)FROM
(select /*+parallel(32)*/ MA_HRM_NVQL, SUM((A.TOT_RVN_PACKAGE) ) DT from ocdm_stage.VNP_DOANHTHU_CHIPHI_TS_2025 A
JOIN OCDM_STAGE.BI_MAP_STAFF_HRM_VNPT_NEW n  ON A.MA_HRM_NVQL = N.STAFF_CODE AND  a.mo_key = n.mo_key
LEFT JOIN bris.V_DWB_REGIS_PACKAGE_SYNC_NEW M ON A.NGAY_HT = M.REGIS_DT AND A.MA_KENH_BAN = M.USER_CODE AND  a.mo_key = m.mo_key
where  A.mo_key = '202408'and LOAI_HM = 'HMM' AND MA_KENH_BAN LIKE 'LK%' AND A.TOT_RVN_PACKAGE > 0
GROUP BY MA_HRM_NVQL
ORDER BY MA_HRM_NVQL DESC);--7120996.432

SELECT SUM(DT_TIEPTHI_CTVLK_TS) FROM VNP_SLDT_NHANVIEN_P0502 WHERE mo_key = '202408';--7120996.432
--
select /*+parallel(32)*/* from bris.v_dwb_regis_package_sync_new  where mo_key=202410 and  rownum <10;

----CCOS
check trên b?ng sub c?a OCS thì có : select * from pps_subs.sub_cos_grp_20241031  where subscriber_id in ('919090115') ;

check thuê bao này PTM tháng 10 thi?u t? b?ng g?c c?a OCS : select *   from ocdm_sys.dwb_acct_actvtn a where   MO_KEY = 202410 and ACCS_MTHD_KEY= 84919090115 ;

SELECT /*+parallel(32)*/* FROM  OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025 WHERE ACCS_MTHD_KEY IN (84823393707,
84945835869)

----HVC--
select * from bris.stg_data_vnp_hvc_mo@coevnpt where mo_key = 202410 and GEO_STATE_KEY = 35;
----DIGIWEB--
SELECT P.* FROM OCDM_STAGE.DWB_DATA_DIGISHOP_WEB_PACK P WHERE DAY_KEY >= '20241001' AND THUE_BAO_KH in ('0914677301',
'0912927190',
'0914599506');
----Theo dõi Bundle--
select  /*+ parallel(a,4)*/ TRANG_THAI,a.*  from   ocdm_stage.dt_tbl_THEO_DOI_BUNDLE a where TIME_UPDATE >= to_date('20241001','yyyymmdd')  -- and TIME_UPDATE <  to_date('20241001','yyyymmdd')
and so_tb in    ('84842230332','84812334454','84812115071','84835118786') ;

---Danh muc goi package_config khong có trong PREP

--Danh muc goi co trong prepay - 208 gói
select * from bris.v_service_code_prepay;
select * from bris.stg_billing_package_prepay ;

select * from admin_v2.package_config@dbl_2_main; --error

SELECT * FROM BRIS.STG_KMCB_EMPLOYEE_SUB_GOI_MO WHERE mo_key=202501 and isdn in ('943017436','822755645','886150647','833207335','813997978','812081308', '813308689') ;
SELECT * FROM BRIS.STG_DATA_EMPLOYEE_SUB_GOI_MO WHERE  mo_key=202501 and ACCS_MTHD_KEY in ('84943017436','84822755645','84886150647','84833207335','84813997978','84812081308','84813308689') ;
