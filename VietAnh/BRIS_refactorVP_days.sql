--va_begin

--PL1-days: do bị duplicate nên dùng rank lấy STB ngày sau cùng
     WITH
PL1 AS (
        select * from (SELECT a.*,row_number () over (partition by ACCS_MTHD_KEY order by ACTVTN_DT desc) rnk
                        FROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt a
                        WHERE GEO_STATE_KEY_STOCK = 35
                          AND GEO_STATE_KEY_DTCP = 35
                          AND ACTV_TYPE = 'PTM'
                          AND DAY_KEY >= 20250301
                    )
   where rnk = 1
),
PL4 as ( select count(*)
         from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D@coevnpt
         where LOAI_TB_THANG ='PTM'
            and DAY_KEY>=20241101 and day_key <=20241130
            and GEO_STATE_CD='HCM'
            and LOAIHINH_TB='TT'
            and ACCS_MTHD_KEY in (84941120066,
84942261537,
84816885272
))
,showOutput as (SELECT a.ACCS_MTHD_KEY ma_tb,
                       a.ACTVTN_DT ngay_kich_hoat,
                       a.LOAIKENH_DTCP loai_kenh,
                       a.HRM_USER_DK MA_HRM_USER_DKTT,
                       a.TEN_USER_DK HOTEN_USER_DKTT,
                       a.ACCOUNT_DK USER_DKTT,
                       a.CONGCU_DK || ';' || b.APP_NAME,
                       COALESCE(b.USER_CODE, a.ACCOUNT_DK),
                       COALESCE(b.CHANNEL_TYPE, a.LOAIKENH_DTCP),
                       COALESCE(b.HRM_CODE, A.HRM_USER_DK),
                       COALESCE(b.STAFF_NAME, A.TEN_USER_DK),
                       ROUND((A.DT_HOA_MANG / 1.1), 0),
                       a.DT_TKC_AND_BUNDLE,
                       a.MATINH_5917,
                       SYSDATE,
                       a.mo_key,
                       CASE
                           WHEN a.SERVICE_CODE IS NOT NULL AND b.SERVICE_CODE IS NOT NULL THEN
                               CASE
                                   WHEN COALESCE(a.TOTAL_TKC_GOI_ALL, 0) > COALESCE(b.TOT_RVN_PACKAGE, 0) THEN a.SERVICE_CODE
                                   ELSE b.SERVICE_CODE
                                   END
                           ELSE COALESCE(a.SERVICE_CODE, b.SERVICE_CODE)
                           END                                                   AS ten_goi,
                       COALESCE(a.P2_CHUKY, (b.P2_CHUKY))            AS chu_ky_goi,
                       COALESCE(a.TOTAL_TKC_GOI_ALL, b.TOT_RVN_PACKAGE)                 AS dthu_goi,
                       (SELECT b.ma_to
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202503) AS ma_to_TTTB,
                       (SELECT b.TEN_TO
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202503) AS ten_to_TTTB,
                       (SELECT b.MA_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202503) AS ma_pb_TTTB,
                       (SELECT b.TEN_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202503) AS ten_pb_TTTB,

                       a.ACCOUNT_DK,
                       CASE
                           WHEN a.LOAI_SIM = 'KIT_BUNDLE' THEN 'Bundle'
                           WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NULL THEN 'Chưa gói'
                           WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                           WHEN a.SERVICE_CODE IS NULL AND b.SERVICE_CODE IS NULL THEN 'Chưa gói'
                           WHEN a.SERVICE_CODE IS NOT NULL OR b.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                           ELSE NULL
                           END                                                   AS phanloai_nhom,
                       (SELECT b.ma_to
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                          AND b.thang = 202503)                                  AS ma_to_bangoi,
                       (SELECT b.TEN_TO
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                          AND b.thang = 202503)                                  AS ten_to_bangoi,
                       (SELECT b.MA_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                          AND b.thang = 202503)                                  AS ma_pb_bangoi,
                       (SELECT b.TEN_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                          AND b.thang = 202503)                                  AS ten_pb_bangoi

                FROM PL1 a
                         LEFT JOIN PL4 b ON a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY

                UNION ALL

                SELECT b.ACCS_MTHD_KEY,
                       TO_DATE(b.ACTVTN_DT, 'DD/MM/YYYY')                              AS ngay_init,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       a.CONGCU_DK || ';' || b.APP_NAME,
                       B.USER_CODE,
                       B.CHANNEL_TYPE,
                       B.HRM_CODE,
                       B.STAFF_NAME,
                       0,
                       0,
                       b.GEO_STATE_CD_PSC,
                       SYSDATE,
                       b.mo_key,
                       CASE
                           WHEN b.SERVICE_CODE IS NOT NULL AND a.SERVICE_CODE IS NOT NULL THEN
                               CASE
                                   WHEN COALESCE(b.TOT_RVN_PACKAGE, 0) > COALESCE(a.TOTAL_TKC_GOI_ALL, 0) THEN b.SERVICE_CODE
                                   ELSE a.SERVICE_CODE
                                   END
                           ELSE COALESCE(b.SERVICE_CODE, a.SERVICE_CODE)
                           END                                                               AS ten_goi,
                       (b.P2_chuky),
                       b.TOT_RVN_PACKAGE,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                      CASE
                           WHEN a.LOAI_SIM = 'KIT_BUNDLE' THEN 'Bundle'
                           WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NULL THEN 'Chưa gói'
                           WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                           WHEN a.SERVICE_CODE IS NULL AND b.SERVICE_CODE IS NULL THEN 'Chưa gói'
                           WHEN a.SERVICE_CODE IS NOT NULL OR b.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                           ELSE NULL
                           END                                                                  AS phanloai_nhom,
                       (SELECT c.ma_to
                        FROM ttkd_bsc.nhanvien c
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202503) AS ma_to_bangoi,
                       (SELECT c.TEN_TO
                        FROM ttkd_bsc.nhanvien c
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202503) AS ten_to_bangoi,
                       (SELECT c.MA_PB
                        FROM ttkd_bsc.nhanvien c
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202503) AS ma_pb_bangoi,
                       (SELECT c.TEN_PB
                        FROM ttkd_bsc.nhanvien c
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202503) AS ten_pb_bangoi

                FROM PL4 b
                         LEFT JOIN PL1 a ON a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY
                WHERE NOT EXISTS (SELECT 1
                                  FROM PL1 a
                                  WHERE a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY))
     select * from showOutput;
--va_end
-------------------------------------------BEGIN-------------------------------------------
select *
from TBL_VNP_BRIS
where thang = 202503
order by ngay_init;

delete
from TBL_VNP_BRIS where thang = 202503;
select /*flashback*/* from TBL_VNP_BRIS;
--
INSERT INTO TBL_VNP_BRIS  (
     ma_tb,  ngay_init,  loaikenh_dk_tttb,  MANV_DK_TTTB,  TENNV_DK_TTTB,
     ACC_INIT,  KENH_BANGOI,  ACC_BANGOI,  LOAIKENH_DK_BANGOI,
     MANV_DK_BANGOI,  TENNV_DK_BANGOI,  DTHU_HMM,  DTHU_TKC_ngay,  geo_state_key,
     ngay_ins,  thang,  goicuoc,  chuky_goi,  dthu_goi,
     MATO_DK_TTTB,  TENTO_DK_TTTB,  MAPB_DK_TTTB,  TENPB_DK_TTTB,  acc_ghinhan,
     phanloai_nhom,  MATO_DK_BANGOI,  TENTO_DK_BANGOI,  MAPB_DK_BANGOI,  TENPB_DK_BANGOI
)

SELECT MA_TB, NGAY_KICH_HOAT, LOAI_KENH, MA_HRM_USER_DKTT, HOTEN_USER_DKTT, USER_DKTT, KENH_BANGOI, ACC_BANGOI,
       LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, DTHU_HMM, DT_TKC_AND_BUNDLE, MATINH_5917,
       SYSDATE, MO_KEY, TEN_GOI, CHU_KY_GOI, DTHU_GOI, MA_TO_TTTB, TEN_TO_TTTB
       , MA_PB_TTTB, TEN_PB_TTTB, ACCOUNT_DK, PHANLOAI_NHOM, MA_TO_BANGOI
       , TEN_TO_BANGOI, MA_PB_BANGOI, TEN_PB_BANGOI
      FROM (
               --
               SELECT a.ACCS_MTHD_KEY                                     ma_tb,
                      a.ACTVTN_DT                                         ngay_kich_hoat,
                      a.LOAIKENH_DTCP                                     loai_kenh,
                      a.HRM_USER_DK                                       MA_HRM_USER_DKTT,
                      a.TEN_USER_DK                                       HOTEN_USER_DKTT,
                      a.ACCOUNT_DK                                        USER_DKTT,
                      a.CONGCU_DK || ';' || b.APP_NAME                    KENH_BANGOI,
                      CAST(COALESCE(b.USER_CODE, a.ACCOUNT_DK) AS VARCHAR2(30)) ACC_BANGOI,
                      COALESCE(b.CHANNEL_TYPE, a.LOAIKENH_DTCP)           LOAIKENH_DK_BANGOI,
                      CAST(COALESCE(b.HRM_CODE, A.HRM_USER_DK)   AS VARCHAR2(30))                MANV_DK_BANGOI,
                      CAST(COALESCE(b.STAFF_NAME, A.TEN_USER_DK)     AS VARCHAR2(30))          TENNV_DK_BANGOI,
                      ROUND((A.DT_HOA_MANG / 1.1), 0)                     DTHU_HMM,
                      a.DT_TKC_AND_BUNDLE,
                      a.MATINH_5917,
                      SYSDATE,
                      a.mo_key,
                      CASE
                          WHEN a.SERVICE_CODE IS NOT NULL AND b.SERVICE_CODE IS NOT NULL THEN
                              CASE
                                  WHEN COALESCE(a.TOTAL_TKC_GOI_ALL, 0) > COALESCE(b.TOT_RVN_PACKAGE, 0)
                                      THEN a.SERVICE_CODE
                                  ELSE b.SERVICE_CODE
                                  END
                          ELSE COALESCE(a.SERVICE_CODE, b.SERVICE_CODE)
                          END                                          AS ten_goi,
                      COALESCE(a.P2_CHUKY, (b.P2_CHUKY))               AS chu_ky_goi,
                      COALESCE(a.TOTAL_TKC_GOI_ALL, b.TOT_RVN_PACKAGE) AS dthu_goi,
                      (SELECT b.ma_to
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.HRM_USER_DK
                         AND b.thang = 202503)                         AS ma_to_TTTB,
                      (SELECT b.TEN_TO
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.HRM_USER_DK
                         AND b.thang = 202503)                         AS ten_to_TTTB,
                      (SELECT b.MA_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.HRM_USER_DK
                         AND b.thang = 202503)                         AS ma_pb_TTTB,
                      (SELECT b.TEN_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.HRM_USER_DK
                         AND b.thang = 202503)                         AS ten_pb_TTTB,
                      a.ACCOUNT_DK,
                      CASE
                          WHEN a.LOAI_SIM = 'KIT_BUNDLE' THEN 'Bundle'
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NULL THEN 'Chưa gói'
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                          WHEN a.SERVICE_CODE IS NULL AND b.SERVICE_CODE IS NULL THEN 'Chưa gói'
                          WHEN a.SERVICE_CODE IS NOT NULL OR b.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                          ELSE NULL
                          END                                          AS phanloai_nhom,
                      (SELECT b.ma_to
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                         AND b.thang = 202503)                         AS ma_to_bangoi,
                      (SELECT b.TEN_TO
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                         AND b.thang = 202503)                         AS ten_to_bangoi,
                      (SELECT b.MA_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                         AND b.thang = 202503)                         AS ma_pb_bangoi,
                      (SELECT b.TEN_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                         AND b.thang = 202503)                         AS ten_pb_bangoi

               FROM (SELECT a.*, row_number() OVER (PARTITION BY ACCS_MTHD_KEY ORDER BY ACTVTN_DT DESC) rnk
                     FROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt a
                     WHERE GEO_STATE_KEY_STOCK = 35
                       AND GEO_STATE_KEY_DTCP = 35
                       AND ACTV_TYPE = 'PTM'
                       AND DAY_KEY >= 20250301) a
                        LEFT JOIN ( select * from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D@coevnpt  where LOAI_TB_THANG ='PTM'
                                                            and DAY_KEY>=20250301
                                                            and GEO_STATE_CD='HCM'
                                                            and LOAIHINH_TB='TT') b
                                  ON a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY
               WHERE a.rnk = 1
               UNION ALL
               SELECT b.ACCS_MTHD_KEY,
                      TO_DATE(b.ACTVTN_DT, 'DD/MM/YYYY') AS ngay_init,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      a.CONGCU_DK || ';' || b.APP_NAME,
                      B.USER_CODE,
                      B.CHANNEL_TYPE,
                      B.HRM_CODE,
                      B.STAFF_NAME,
                      0,
                      0,
                      b.GEO_STATE_CD_PSC,
                      SYSDATE,
                      b.mo_key,
                      CASE
                          WHEN b.SERVICE_CODE IS NOT NULL AND a.SERVICE_CODE IS NOT NULL THEN
                              CASE
                                  WHEN COALESCE(b.TOT_RVN_PACKAGE, 0) > COALESCE(a.TOTAL_TKC_GOI_ALL, 0)
                                      THEN b.SERVICE_CODE
                                  ELSE a.SERVICE_CODE
                                  END
                          ELSE COALESCE(b.SERVICE_CODE, a.SERVICE_CODE)
                          END                            AS ten_goi,
                      (b.P2_chuky),
                      b.TOT_RVN_PACKAGE,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      CASE
                          WHEN a.LOAI_SIM = 'KIT_BUNDLE' THEN 'Bundle'
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NULL THEN 'Chưa gói'
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                          WHEN a.SERVICE_CODE IS NULL AND b.SERVICE_CODE IS NULL THEN 'Chưa gói'
                          WHEN a.SERVICE_CODE IS NOT NULL OR b.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                          ELSE NULL
                          END                            AS phanloai_nhom,
                      (SELECT c.ma_to
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202503)           AS ma_to_bangoi,
                      (SELECT c.TEN_TO
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202503)           AS ten_to_bangoi,
                      (SELECT c.MA_PB
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202503)           AS ma_pb_bangoi,
                      (SELECT c.TEN_PB
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202503)           AS ten_pb_bangoi

               FROM ( select * from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D@coevnpt  where LOAI_TB_THANG ='PTM'
                                                            and DAY_KEY>=20250301
                                                            and GEO_STATE_CD='HCM'
                                                            and LOAIHINH_TB='TT') b
                        LEFT JOIN (SELECT a.*,
                                          row_number() OVER (PARTITION BY ACCS_MTHD_KEY ORDER BY ACTVTN_DT DESC) rnk
                                   FROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt a
                                   WHERE GEO_STATE_KEY_STOCK = 35
                                     AND GEO_STATE_KEY_DTCP = 35
                                     AND ACTV_TYPE = 'PTM'
                                     AND DAY_KEY >= 20250301) a
                                  ON a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY
               WHERE a.ACCS_MTHD_KEY IS NULL)
      
     ;

            update TBL_VNP_BRIS
            set dthu_tkc = (ROUND(dthu_goi/1.1/chuky_goi,0))
            where thang = 202503
            ;
            update TBL_VNP_BRIS
            set dthu_goi_novat = (ROUND(nvl(dthu_goi,0)/1.1,0))
            where thang = 202503
            ;
            update TBL_VNP_BRIS
            set tong_dthu_ptm = (nvl(dthu_hmm,0) + nvl(dthu_tkc,0))
            where thang = 202503

            ;
            UPDATE TBL_VNP_BRIS
            SET TONG_DTHU_PTM_NGAY = (DTHU_HMM + DTHU_TKC_NGAY)
            where thang = 202503
            ;
            UPDATE TBL_VNP_BRIS
            SET DTHU_TKC = (DTHU_HMM + DTHU_GOI_NOVAT)
            where thang = 202503

            ;
            update TBL_VNP_BRIS
            set PHANLOAI_NHOM = 'Mua gói'
            where PHANLOAI_NHOM ='Chưa gói' and GOICUOC is not null
            ;


--DANGEROUS
delete
from TTKDHCM_KTNV.TBL_VNP_BRIS
where thang = 202503;


insert into TTKDHCM_KTNV.tbl_vnp_bris
select *
from TBL_VNP_BRIS where thang = 202503;

insert into ttkdhcm_ktnv.TBL_VNP_BRIS(MA_TB, PHANLOAI_NHOM, NGAY_INIT, LOAIKENH_DK_TTTB, MANV_DK_TTTB, TENNV_DK_TTTB, MATO_DK_TTTB, TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, GOICUOC, CHUKY_GOI, DTHU_GOI, ACC_INIT, KENH_BANGOI, ACC_BANGOI, LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI, TENPB_DK_BANGOI, DTHU_HMM, DTHU_TKC, TONG_DTHU_PTM, ACC_GHINHAN, LOAIKENH_GHINHAN, NGUON, NGAY_INS,  DTHU_TKC_NGAY, TONG_DTHU_PTM_NGAY, GEO_STATE_KEY, THANG)
    select to_char(MA_TB), PHANLOAI_NHOM, NGAY_INIT, LOAIKENH_DK_TTTB, MANV_DK_TTTB, TENNV_DK_TTTB, MATO_DK_TTTB, TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, GOICUOC, CHUKY_GOI, DTHU_GOI, ACC_INIT, KENH_BANGOI, ACC_BANGOI, LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI, TENPB_DK_BANGOI, DTHU_HMM, DTHU_TKC, TONG_DTHU_PTM, ACC_GHINHAN, LOAIKENH_GHINHAN,  ploai, NGAY_INS, DTHU_TKC_NGAY, TONG_DTHU_PTM_NGAY, GEO_STATE_KEY, THANG
    from PL5--ttkd_bct.va_ct_vnp_bris
    where  to_number(TO_CHAR(ngay_init, 'yyyymm')) = 202503;

    -- check trung` ma_tb
    select*
    from ttkdhcm_ktnv.TBL_VNP_BRIS
    where thang = 202503
        and ma_tb in ( select ma_tb
        from ttkdhcm_ktnv.TBL_VNP_BRIS
        where thang = 202503 group by ma_tb having count(ma_tb)>1);

        -- del accghi nhan null --> ko map dc kenh ban
                delete from ttkdhcm_ktnv.TBL_VNP_BRIS
                where thang = 202503
                and acc_ghinhan is null;
        -- del case trung ma_tb vi` nhieu goi_cuoc ->> chose the greatest one
               DELETE FROM ttkdhcm_ktnv.TBL_VNP_BRIS
                WHERE
                    thang = 202503
                    AND ROWID IN (
                        SELECT ROWID FROM (
                            SELECT
                                ROWID,
                                ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY dthu_goi DESC) AS rn
                            FROM
                                ttkdhcm_ktnv.TBL_VNP_BRIS
                            WHERE
                                thang = 202503
                        )
                        WHERE rn > 1
                    );

;
commit;
--test ttkdhcm_ktnv.TBL_VNP_BRIS
create table TBL_VNP_BRIS
as select * from ttkdhcm_ktnv.TBL_VNP_BRIS where 1=0 ;
select * from ttkdhcm_ktnv.TBL_VNP_BRIS where thang = 202503;
select * from TBL_VNP_BRIS;

----------------------------------END---------------------------------
--pbh gd sanbay
select * from BSCC_IMPORT_BUNDLE_SMRS
where '84'||subscriber_id = '84886360743'
;
select * from BSCC_IMPORT_BUNDLE_SMRS_CT;
select* from ttkdhcm_ktnv.TBL_VNP_BRIS where ma_tb ='84812643710';
select* from ttkdhcm_ktnv.TBL_VNP_BRIS
where ma_tb in (
select ma_tb from x_sb
) and thang = 202503;
select a.*,b.* from x_sb a
left join BSCC_IMPORT_BUNDLE_SMRS_CT b
on b.msisdn = a.ma_tb
;

select * from onebss_202405;
update ttkdhcm_ktnv.TBL_VNP_BRIS
set (GOICUOC,DTHU_GOI) = (select SERVICE_CODE, GIA_GOI from BSCC_IMPORT_BUNDLE_SMRS_CT where MSISDN =ma_tb and SERVICE_CODE is not null )
where thang = 202503 and ma_tb in (
select ma_tb from x_sb
)
;
update ttkdhcm_ktnv.TBL_VNP_BRIS
set (chuky_goi) = (select P2_CHUKY from BSCC_IMPORT_BUNDLE_SMRS_CT where MSISDN =ma_tb and SERVICE_CODE is not null )
where thang = 202503 and chuky_goi is null and ma_tb in (
select ma_tb from x_sb
);
update ttkdhcm_ktnv.TBL_VNP_BRIS
set DTHU_GOI_NOVAT = nvl(round(DTHU_GOI/1.1),0)
where DTHU_GOI_NOVAT =0 and thang = 202503 and DTHU_GOI_NOVAT = 0 and MANV_DK_TTTB in ('CTV087590',
'CTV074205',
'VNP017843'
)
;

MERGE INTO ttkdhcm_ktnv.TBL_VNP_BRIS a
USING (
    SELECT b.service_code, b.P2_CHUKY, b.GIA_GOI_THUC_TRU, a.ma_tb
    FROM ttkdhcm_ktnv.TBL_VNP_BRIS a
    LEFT JOIN x_sb_bd_ct b ON b.MSISDN = a.ma_tb
    WHERE a.thang = 202503
    AND a.MANV_DK_TTTB IN ('CTV087590', 'CTV074205', 'VNP017843')
    AND a.goicuoc IS NULL
) b
ON (a.ma_tb = b.ma_tb)
WHEN MATCHED THEN
UPDATE SET
    a.GOICUOC = b.service_code,
    a.CHUKY_GOI = b.P2_CHUKY,
    a.DTHU_GOI = b.GIA_GOI_THUC_TRU;


  update ttkdhcm_ktnv.TBL_VNP_BRIS
            set dthu_tkc = (ROUND(dthu_goi/1.1/chuky_goi,0))
            where thang = 202503
            ;
            update ttkdhcm_ktnv.TBL_VNP_BRIS
            set dthu_goi_novat = (ROUND(nvl(dthu_goi,0)/1.1,0))
            where thang = 202503
            ;
            update ttkdhcm_ktnv.TBL_VNP_BRIS
            set tong_dthu_ptm = (nvl(dthu_hmm,0) + nvl(dthu_tkc,0))
            where thang = 202503

            ;
            UPDATE ttkdhcm_ktnv.TBL_VNP_BRIS
            SET TONG_DTHU_PTM_NGAY = (DTHU_HMM + DTHU_TKC_NGAY)
            where thang = 202503
            ;
            UPDATE ttkdhcm_ktnv.TBL_VNP_BRIS
            SET DTHU_TKC = (DTHU_HMM + DTHU_GOI_NOVAT)
            where thang = 202503

            ;
            update ttkdhcm_ktnv.TBL_VNP_BRIS
            set PHANLOAI_NHOM = 'Mua gói'
            where PHANLOAI_NHOM ='Chưa gói' and GOICUOC is not null
            ;
--

select a.*
from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY a
 where goi_cuoc ='MI_BIGKM_6GBN';








