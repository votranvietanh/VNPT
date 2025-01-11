84822691883


--P01 theo tháng: tỉnh xuất bán: HCM , theo tháng, hình thức HM: PTM
SELECT * FROM OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025
         where mo_key=202411
--             and GEO_STATE_KEY_STOCK is not null  --HCM đã test lấy data thang 9,10,11 --> Khớp
            and GEO_STATE_KEY_DTCP = 35
and ACCS_MTHD_KEY = 84942840696
--             and ACTV_TYPE = 'PTM'
;
--theo ngày
     select count(*) fROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt
 where GEO_STATE_KEY_STOCK = 35
    and GEO_STATE_KEY_DTCP = 35
       and ACTV_TYPE ='PTM'
    and day_key = 20241129;
--PL4 ngay - ptm trong thang phuc vu cho bao cao bris
     select * from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D where LOAI_TB_THANG ='PTM' and DAY_KEY=20241125 and GEO_STATE_CD='HCM' and LOAIHINH_TB='TT';

select a.*,b.HRM_CODE from manpn.bscc_import_goi_bris_p04 a
        left join (select ACCS_MTHD_KEY,SERVICE_CODE,HRM_CODE from BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW@coevnpt where mo_key = 202411 and LOAI_TB_THANG ='HH' and GEO_STATE_CD='HCM' ) b
        on a.ACCS_MTHD_KEY = to_char(b.ACCS_MTHD_KEY) and a.SERVICE_CODE= b.SERVICE_CODE and nvl(a.HRM_CODE,0)=nvl(b.HRM_CODE,0)
        where a.thang = 202411 and a.LOAI_TB_THANG = 'HH'
            and b.ACCS_MTHD_KEY is null;
--P04 thang:
select *from BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW where mo_key = 202411  and GEO_STATE_CD='HCM';
select count(*)from BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW where mo_key = 202411  and GEO_STATE_CD='HCM' and LOAI_TB_THANG='PTM' and LOAIHINH_TB='TT';
select *from BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW where mo_key = 202411  and GEO_STATE_CD='HCM' and LOAI_TB_THANG='PTM' and LOAIHINH_TB='TT' and accs_mthd_key =84812001681;
select *from BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW where mo_key = 202411 and ACCS_MTHD_KEY in (84834973536) ;
select * from  BRIS.STG_OCS_REGIS_PACKAGE_MO where accs_mthd_key =84834973536;
;
select count(*)from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D  where mo_key = 202410  and GEO_STATE_CD='HCM' and LOAI_TB_THANG='PTM' and LOAIHINH_TB='TT';
;
select * from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D  where ACCS_MTHD_KEY = 84886921381;
select *from BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW where  mo_key = 202412 and ACCS_MTHD_KEY = 84913581132;


    select * from  BRIS.V_DWB_REGIS_PACKAGE_SYNC_NEW where accs_mthd_key ='84845416112';
SELECT * FROM OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TS_2025 where mo_key=202411; and ma_tb =84845416112;

                                                ;















--lich su thuebao
select *
from subadmin.lich_su_tb;
    

------------84914145993 -STAT_CD = 2 	Ðã duyệt đăng ký,
select  *from ocdm_sys.dwb_acct_actvtn a
where  day_key = 20241009 and ACTV_TYPE ='NEW_ACTV'
--   and SIM_STATE_CD ='HCM'
--     and GEO_STATE_KEY_DK = 35;
--     or GEO_STATE_KEY_STOCK = 35;
--   and SIM_GEO_STATE_KEY = 35;
  and ACCS_MTHD_KEY='84813439700' ;
select  *from ocdm_sys.dwb_acct_actvtn@coevnpt a
where  day_key = 20241123 and ACTV_TYPE ='NEW_ACTV'
--   and SIM_STATE_CD ='HCM'
--     and GEO_STATE_KEY_DK = 35
--     or GEO_STATE_KEY_STOCK = 35;
--   and SIM_GEO_STATE_KEY = 35;
  and ACCS_MTHD_KEY='84945796163' ; SIM_GEO_STATE_KEY = province init
--GEO_STATE_KEY_DK = null ->> ko co thong tin
select * FROM ocdm_Stage.VNP_SLDT_NHANVIEN_P0501@coevnpt;
SELECT * fROM OCDM_STAGE.DWB_DATA_DIGISHOP_SIM_NEW@coevnpt;
--test digishop web
select STB from manpn.BSCC_DIGI where thang = 202410
   minus select to_char(sdt_mua) from OCDM_STAGE.DWB_DATA_DIGISHOP_WEB_SIM@coevnpt
;
84886035684

--DIGISHOPAPP =
select * from dgia_tndn_simso where thang = 202410 and ma_tb ='84945535143';
SELECT * fROM OCDM_STAGE.DWB_DATA_DIGISHOP_SIM_NEW@coevnpt where day_key  >= 20241000 and day_key <= 20241031 and ttkd ='TTKD VNPT-TP Hồ Chí Minh';
--DIGISHOPWEB
SELECT *fROM OCDM_STAGE.DWB_DATA_DIGISHOP_WEB_SIM@coevnpt where mo_key = 202410 and sdt_mua ='84828002911'; MA_DON_HANG ='202410312836550';and ghi_chu ='Success'; ='84822177511';
SELECT distinct SAN_PHAM,CHU_KY_GOI FROM OCDM_STAGE.DWB_DATA_DIGISHOP_WEB_PACK@coevnpt p where p.mo_key = 202410;
select * from manpn.BSCC_DIGI where thang = 202410; --2823
--TONG HOP 2 BANG TREN THANH BANG:
SELECT LOAI_KENH,count(1) FROM  V_VNP_KENH_MEDIA_XL WHERE mo_key=202408 group by LOAI_KENH order by LOAI_KENH;
--TONG HOP CAC NGUON
SELECT * FROM  OCDM_STAGE.T_DTCP_TT_MONTHLY_GOC_2025 ;
--BANG DICH P01: BANG LAY LEN BAO CAO
SELECT count(*) FROM  OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt where mo_key= 202410;
--1. Bang map nhan vien HRM toan bo VNPT (NVKD+NVKT)+ MA TINH DANG KY
     --tu staff_code se tim ra hrm, pbh,ttkd
     SELECT * FROM  OCDM_STAGE.BI_MAP_STAFF_HRM_VNPT_NEW@coevnpt WHERE mo_key=202410 and staff_code ='CTV085863'; --bang nv
--2--tra truoc :
     --2.1 Bang lay ma HRM_CODE va KENH HRM thong qua Account DK
     SELECT * FROM  OCDM_STAGE.BI_MAP_CCBS_CHANNEL_TYPE_NEW WHERE mo_key=202406;
     --2.2 Bang lay ma HRM_CODE va Kenh ELOAD
     SELECT * FROM   OCDM_STAGE.BI_MAP_ELOAD_CHANNEL_TYPE_NEW@coevnpt WHERE mo_key=202410;
select * from ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt;

SELECT A.ACCS_MTHD_KEY,A.HRM_USER_DK, A.TTKD, B.TENTTKD AS HRM
FROM OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt A
JOIN OCDM_STAGE.BI_MAP_STAFF_HRM_VNPT_NEW@coevnpt B
ON A.HRM_USER_DK = B.STAFF_CODE AND A.MO_KEY = B.MO_KEY
WHERE A.MO_KEY = '202408'
AND A.MA_KENH_BAN IS NULL AND MA_HRM_NVQL IS NULL
AND A.TTKD <> B.TENTTKD;

select count(*)  FROM  BRIS.V_DWB_REGIS_PACKAGE_EXPORT_NEW@coevnpt where GEO_STATE_CD ='HCM';
select count(*)FROM  bris.DWB_REGIS_PACKAGE_PUBLISH_NEW@coevnpt where GEO_STATE_CD = 'HCM'; --P04
select * FROM  bris.DWB_REGIS_PACKAGE_PUBLISH_NEW@coevnpt where ACCS_MTHD_KEY = 84812058465; --P04


SELECT * FROM  OCDM_STAGE.T_DTCP_TT_MONTHLY_GOC_2025@coevnpt where mo_key = 202411;
SELECT *FROM  OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt where  mo_key = 202411; --DAY_KEY = 20241118 ;
 select to_char(ACCS_MTHD_KEY) from ocdm_sys.dwb_acct_actvtn@coevnpt where mo_key = 202410 and PROVINCE_INIT ='HCM'
minus
select ma_tb from ONE_LINE_202410;
 select * from ocdm_sys.dwb_acct_actvtn@coevnpt; where mo_key = 202410 and PROVINCE_INIT ='HCM' ; --ACTV_TYPE='NEW_ACTV' GEO_STATE_KEY=20, ACCOUNT_DK

SELECT * FROM OCDM_STAGE.VNP_DOANHTHU_CHIPHI_TT_2025@coevnpt where mo_key=202410  and GEO_STATE_KEY_STOCK=35 and GEO_STATE_KEY_DTCP = 35 and ACTV_TYPE = 'PTM' ;