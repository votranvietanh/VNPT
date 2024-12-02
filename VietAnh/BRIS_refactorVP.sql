--va_begin

--PL1-days: do bị duplicate nên dùng rank lấy STB ngày sau cùng
     WITH
PL1 AS (
        select * from (SELECT a.*,row_number () over (partition by ACCS_MTHD_KEY order by ACTVTN_DT desc) rnk
                        FROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt a
                        WHERE GEO_STATE_KEY_STOCK = 35
                          AND GEO_STATE_KEY_DTCP = 35
                          AND ACTV_TYPE = 'PTM'
                          AND DAY_KEY >= 20241101
                    )
   where rnk = 1
),
PL4 as ( select *
         from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D@coevnpt
         where LOAI_TB_THANG ='PTM'
            and DAY_KEY>=20241101
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
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202411) AS ma_to_TTTB,
                       (SELECT b.TEN_TO
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202411) AS ten_to_TTTB,
                       (SELECT b.MA_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202411) AS ma_pb_TTTB,
                       (SELECT b.TEN_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = a.HRM_USER_DK AND b.thang = 202411) AS ten_pb_TTTB,

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
                          AND b.thang = 202411)                                  AS ma_to_bangoi,
                       (SELECT b.TEN_TO
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                          AND b.thang = 202411)                                  AS ten_to_bangoi,
                       (SELECT b.MA_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                          AND b.thang = 202411)                                  AS ma_pb_bangoi,
                       (SELECT b.TEN_PB
                        FROM ttkd_bsc.nhanvien b
                        WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                          AND b.thang = 202411)                                  AS ten_pb_bangoi

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
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202411) AS ma_to_bangoi,
                       (SELECT c.TEN_TO
                        FROM ttkd_bsc.nhanvien c
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202411) AS ten_to_bangoi,
                       (SELECT c.MA_PB
                        FROM ttkd_bsc.nhanvien c
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202411) AS ma_pb_bangoi,
                       (SELECT c.TEN_PB
                        FROM ttkd_bsc.nhanvien c
                        WHERE c.ma_nv = b.HRM_CODE AND c.thang = 202411) AS ten_pb_bangoi

                FROM PL4 b
                         LEFT JOIN PL1 a ON a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY
                WHERE NOT EXISTS (SELECT 1
                                  FROM PL1 a
                                  WHERE a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY))
     select * from showOutput;
--va_end
-------------------------------------------BEGIN-------------------------------------------
select *
from TBL_VNP_BRIS;
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
                         AND b.thang = 202411)                         AS ma_to_TTTB,
                      (SELECT b.TEN_TO
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.HRM_USER_DK
                         AND b.thang = 202411)                         AS ten_to_TTTB,
                      (SELECT b.MA_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.HRM_USER_DK
                         AND b.thang = 202411)                         AS ma_pb_TTTB,
                      (SELECT b.TEN_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.HRM_USER_DK
                         AND b.thang = 202411)                         AS ten_pb_TTTB,
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
                         AND b.thang = 202411)                         AS ma_to_bangoi,
                      (SELECT b.TEN_TO
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                         AND b.thang = 202411)                         AS ten_to_bangoi,
                      (SELECT b.MA_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                         AND b.thang = 202411)                         AS ma_pb_bangoi,
                      (SELECT b.TEN_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, A.HRM_USER_DK)
                         AND b.thang = 202411)                         AS ten_pb_bangoi

               FROM (SELECT a.*, row_number() OVER (PARTITION BY ACCS_MTHD_KEY ORDER BY ACTVTN_DT DESC) rnk
                     FROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt a
                     WHERE GEO_STATE_KEY_STOCK = 35
                       AND GEO_STATE_KEY_DTCP = 35
                       AND ACTV_TYPE = 'PTM'
                       AND DAY_KEY >= 20241101) a
                        LEFT JOIN ( select * from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D@coevnpt  where LOAI_TB_THANG ='PTM'
                                                            and DAY_KEY>=20241101
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
                         AND c.thang = 202411)           AS ma_to_bangoi,
                      (SELECT c.TEN_TO
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202411)           AS ten_to_bangoi,
                      (SELECT c.MA_PB
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202411)           AS ma_pb_bangoi,
                      (SELECT c.TEN_PB
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202411)           AS ten_pb_bangoi

               FROM ( select * from BRIS.V_DWB_REGIS_PACKAGE_SYNC_D@coevnpt  where LOAI_TB_THANG ='PTM'
                                                            and DAY_KEY>=20241101
                                                            and GEO_STATE_CD='HCM'
                                                            and LOAIHINH_TB='TT') b
                        LEFT JOIN (SELECT a.*,
                                          row_number() OVER (PARTITION BY ACCS_MTHD_KEY ORDER BY ACTVTN_DT DESC) rnk
                                   FROM ocdm_stage.VNP_DOANHTHU_CHIPHI_TT_2025_D@coevnpt a
                                   WHERE GEO_STATE_KEY_STOCK = 35
                                     AND GEO_STATE_KEY_DTCP = 35
                                     AND ACTV_TYPE = 'PTM'
                                     AND DAY_KEY >= 20241101) a
                                  ON a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY
               WHERE a.ACCS_MTHD_KEY IS NULL)
      
     ;

update TBL_VNP_BRIS
set dthu_tkc = (ROUND(dthu_goi/1.1/chuky_goi,0))


update TBL_VNP_BRIS
set tong_dthu_ptm = (nvl(dthu_hmm,0) + nvl(dthu_tkc,0))

UPDATE TBL_VNP_BRIS
SET TONG_DTHU_PTM_NGAY = (DTHU_HMM + DTHU_TKC_NGAY)


--
delete
from TTKDHCM_KTNV.TBL_VNP_BRIS
where thang = 202411;

insert into TTKDHCM_KTNV.tbl_vnp_bris
select *
from TBL_VNP_BRIS where thang = 202411;

insert into ttkdhcm_ktnv.TBL_VNP_BRIS(MA_TB, PHANLOAI_NHOM, NGAY_INIT, LOAIKENH_DK_TTTB, MANV_DK_TTTB, TENNV_DK_TTTB, MATO_DK_TTTB, TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, GOICUOC, CHUKY_GOI, DTHU_GOI, ACC_INIT, KENH_BANGOI, ACC_BANGOI, LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI, TENPB_DK_BANGOI, DTHU_HMM, DTHU_TKC, TONG_DTHU_PTM, ACC_GHINHAN, LOAIKENH_GHINHAN, NGUON, NGAY_INS,  DTHU_TKC_NGAY, TONG_DTHU_PTM_NGAY, GEO_STATE_KEY, THANG)
    select to_char(MA_TB), PHANLOAI_NHOM, NGAY_INIT, LOAIKENH_DK_TTTB, MANV_DK_TTTB, TENNV_DK_TTTB, MATO_DK_TTTB, TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, GOICUOC, CHUKY_GOI, DTHU_GOI, ACC_INIT, KENH_BANGOI, ACC_BANGOI, LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI, TENPB_DK_BANGOI, DTHU_HMM, DTHU_TKC, TONG_DTHU_PTM, ACC_GHINHAN, LOAIKENH_GHINHAN,  ploai, NGAY_INS, DTHU_TKC_NGAY, TONG_DTHU_PTM_NGAY, GEO_STATE_KEY, THANG
    from PL5--ttkd_bct.va_ct_vnp_bris
    where  to_number(TO_CHAR(ngay_init, 'yyyymm')) = 202411;

    -- check trung` ma_tb
    select*
    from ttkdhcm_ktnv.TBL_VNP_BRIS
    where thang = 202411
        and ma_tb in ( select ma_tb
        from ttkdhcm_ktnv.TBL_VNP_BRIS
        where thang = 202411 group by ma_tb having count(ma_tb)>1);

        -- del accghi nhan null --> ko map dc kenh ban
                delete from ttkdhcm_ktnv.TBL_VNP_BRIS
                where thang = 202411
                and acc_ghinhan is null;
        -- del case trung ma_tb vi` nhieu goi_cuoc ->> chose the greatest one
               DELETE FROM ttkdhcm_ktnv.TBL_VNP_BRIS
                WHERE
                    thang = 202411
                    AND ROWID IN (
                        SELECT ROWID FROM (
                            SELECT
                                ROWID,
                                ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY dthu_goi DESC) AS rn
                            FROM
                                ttkdhcm_ktnv.TBL_VNP_BRIS
                            WHERE
                                thang = 202411
                        )
                        WHERE rn > 1
                    );

;

--test ttkdhcm_ktnv.TBL_VNP_BRIS
create table TBL_VNP_BRIS
as select * from ttkdhcm_ktnv.TBL_VNP_BRIS where 1=0 ;
select * from ttkdhcm_ktnv.TBL_VNP_BRIS where thang = 202411;
select * from TBL_VNP_BRIS;

----------------------------------END---------------------------------









CREATE TABLE ct_vnp_bris_202411
AS SELECT * FROM vietanhct_vnp_bris WHERE 1 = 0
;
select *
from vinhphat.pl4_2024_11;
DELETE FROM pl4_2024_11
WHERE ROWID IN (
    SELECT ROWID
    FROM (
        SELECT ROWID,
               ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY DOANH_THU_BAN_GOI DESC) AS rn
        FROM pl4_2024_11
    )
    WHERE rn > 1
);

DELETE FROM pl1_202411
WHERE ROWID IN (
    SELECT ROWID
    FROM (
        SELECT ROWID,
               ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY ngay_kich_hoat DESC) AS rn
        FROM pl1_202411
    )
    WHERE rn > 1
);




select * from ct_vnp_bris_202411


INSERT INTO ct_vnp_bris_202411 d (
     ma_tb,  ngay_init,  loaikenh_dk_tttb,  MANV_DK_TTTB,  TENNV_DK_TTTB,
     ACC_INIT,  KENH_BANGOI,  ACC_BANGOI,  LOAIKENH_DK_BANGOI,
     MANV_DK_BANGOI,  TENNV_DK_BANGOI,  DTHU_HMM,  DTHU_TKC_ngay,  geo_state_key,
     ngay_ins,  thang,  goicuoc,  chuky_goi,  dthu_goi,
     MATO_DK_TTTB,  TENTO_DK_TTTB,  MAPB_DK_TTTB,  TENPB_DK_TTTB,  acc_ghinhan,
     phanloai_nhom,  MATO_DK_BANGOI,  TENTO_DK_BANGOI,  MAPB_DK_BANGOI,  TENPB_DK_BANGOI
)
(
    SELECT 
        a.ma_tb, 
        a.ngay_kich_hoat,
        a.loai_kenh, 
        a.MA_HRM_USER_DKTT, 
        a.HOTEN_USER_DKTT,
        a.USER_DKTT, 
        a.DIEM_CHAM_TIEPTHI ||';'|| b.CONG_CU_BAN_GOI, 
        COALESCE(b.user_kenh_ban,a.USER_DKTT), 
        COALESCE(b.loai_kenh_ban,a.LOAI_KENH_CUA_USER),
        COALESCE(b.HRM_NV_BAN_GOI_NV_QLKENH_BAN,A."MA_HRM_USER_DKTT"),
        A."HOTEN_USER_DKTT", 
        ROUND((A.DTHU_HMM / 1.1), 0), 
        a.dt_tkc, 
        a.tinh_psc_5917, 
        SYSDATE, 
        202411, 
        CASE 
            WHEN a.GOI_CUOC IS NOT NULL AND b.ma_goi IS NOT NULL THEN
                CASE 
                    WHEN COALESCE(a.DTHU_GOI, 0) > COALESCE(b.DOANH_THU_BAN_GOI, 0) THEN a.GOI_CUOC
                    ELSE b.ma_goi
                END
            ELSE COALESCE(a.GOI_CUOC, b.ma_goi)
        END AS ten_goi, 
        COALESCE(a.chu_ky_goi, to_char(b.chu_ky_goi)) AS chu_ky_goi, 
        COALESCE(a.DTHU_GOI, b.DOANH_THU_BAN_GOI) AS dthu_goi,
        (SELECT b.ma_to FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = a.MA_HRM_USER_DKTT AND b.thang = 202411) AS ma_to_TTTB,
        (SELECT b.TEN_TO FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = a.MA_HRM_USER_DKTT AND b.thang = 202411) AS ten_to_TTTB,
        (SELECT b.MA_PB FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = a.MA_HRM_USER_DKTT AND b.thang = 202411) AS ma_pb_TTTB,
        (SELECT b.TEN_PB FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = a.MA_HRM_USER_DKTT AND b.thang = 202411) AS ten_pb_TTTB,
        
        a.USER_DKTT,
        CASE 
            WHEN a.loai_sim = 'BUNDLE' THEN 'BUNDLE'
            WHEN a.loai_sim = 'SIMDONLE' AND a.GOI_CUOC IS NULL THEN 'CHUA GÓI'
            WHEN a.loai_sim = 'SIMDONLE' AND a.GOI_CUOC IS NOT NULL THEN 'MUA GÓI'
            WHEN a.GOI_CUOC IS NULL AND b.ma_goi IS NULL THEN 'CHUA GÓI'
            WHEN a.GOI_CUOC IS NOT NULL OR b.ma_goi IS NOT NULL THEN 'MUA GÓI'
            ELSE NULL
        END AS phanloai_nhom,
        (SELECT b.ma_to FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = COALESCE(b.HRM_NV_BAN_GOI_NV_QLKENH_BAN,A."MA_HRM_USER_DKTT") AND b.thang = 202411) AS ma_to_bangoi,
        (SELECT b.TEN_TO FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = COALESCE(b.HRM_NV_BAN_GOI_NV_QLKENH_BAN,A."MA_HRM_USER_DKTT") AND b.thang = 202411) AS ten_to_bangoi,
        (SELECT b.MA_PB FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = COALESCE(b.HRM_NV_BAN_GOI_NV_QLKENH_BAN,A."MA_HRM_USER_DKTT") AND b.thang = 202411) AS ma_pb_bangoi,
        (SELECT b.TEN_PB FROM ttkd_bsc.nhanvien b WHERE b.ma_nv = COALESCE(b.HRM_NV_BAN_GOI_NV_QLKENH_BAN,A."MA_HRM_USER_DKTT") AND b.thang = 202411) AS ten_pb_bangoi
    
    FROM pl1_202411 a
    LEFT JOIN pl4_2024_11 b ON a.ma_tb = b.ma_tb
    
    UNION ALL
    
    SELECT 
        b.ma_tb, 
        TO_DATE(b.ngay_kich_hoat, 'DD/MON/YYYY') AS ngay_init, -- Ð?nh d?ng t? b?ng pl4
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        a.DIEM_CHAM_TIEPTHI ||';'|| b.CONG_CU_BAN_GOI, 
        B.user_kenh_ban, 
        B.loai_kenh_ban, 
        B.HRM_NV_BAN_GOI_NV_QLKENH_BAN,
        B.nv_ban_goi_nv_ql_kenh_ban,  
        0, 
        0, 
        b.DON_VI_PSC_5917, 
        SYSDATE, 
        202411, 
        CASE 
            WHEN b.ma_goi IS NOT NULL AND a.GOI_CUOC IS NOT NULL THEN
                CASE 
                    WHEN COALESCE(b.DOANH_THU_BAN_GOI, 0) > COALESCE(a.DTHU_GOI, 0) THEN b.ma_goi
                    ELSE a.GOI_CUOC
                END
            ELSE COALESCE(b.ma_goi, a.GOI_CUOC)
        END AS ten_goi, 
        to_char(b.chu_ky_goi), 
        b.DOANH_THU_BAN_GOI, 
        NULL, NULL, NULL, NULL, NULL, 
        CASE 
            WHEN a.loai_sim = 'BUNDLE' THEN 'BUNDLE'
            WHEN a.loai_sim = 'SIMDONLE' AND a.GOI_CUOC IS NULL THEN 'CHUA GÓI'
            WHEN a.loai_sim = 'SIMDONLE' AND a.GOI_CUOC IS NOT NULL THEN 'MUA GÓI'
            WHEN a.GOI_CUOC IS NULL AND b.ma_goi IS NULL THEN 'CHUA GÓI'
            WHEN a.GOI_CUOC IS NOT NULL OR b.ma_goi IS NOT NULL THEN 'MUA GÓI'
            ELSE NULL
        END AS phanloai_nhom,
        (SELECT c.ma_to FROM ttkd_bsc.nhanvien c WHERE c.ma_nv = b.HRM_NV_BAN_GOI_NV_QLKENH_BAN AND c.thang = 202411) AS ma_to_bangoi,
        (SELECT c.TEN_TO FROM ttkd_bsc.nhanvien c WHERE c.ma_nv = b.HRM_NV_BAN_GOI_NV_QLKENH_BAN AND c.thang = 202411) AS ten_to_bangoi,
        (SELECT c.MA_PB FROM ttkd_bsc.nhanvien c WHERE c.ma_nv = b.HRM_NV_BAN_GOI_NV_QLKENH_BAN AND c.thang = 202411) AS ma_pb_bangoi,
        (SELECT c.TEN_PB FROM ttkd_bsc.nhanvien c WHERE c.ma_nv = b.HRM_NV_BAN_GOI_NV_QLKENH_BAN AND c.thang = 202411) AS ten_pb_bangoi
    
    FROM pl4_2024_11 b
    LEFT JOIN pl1_202411 a ON a.ma_tb = b.ma_tb
    WHERE NOT EXISTS (
        SELECT 1 
        FROM pl1_202411 a
        WHERE a.ma_tb = b.ma_tb
    )
);

-- rollback
update TBL_VNP_BRIS
set dthu_tkc = (ROUND(dthu_goi/1.1/chuky_goi,0))


update TBL_VNP_BRIS
set tong_dthu_ptm = (nvl(dthu_hmm,0) + nvl(dthu_tkc,0))

UPDATE TBL_VNP_BRIS
SET TONG_DTHU_PTM_NGAY = (DTHU_HMM + DTHU_TKC_NGAY)


UPDATE ct_vnp_bris A
SET A.LOAIKENH_GHINHAN = (
    SELECT B.LOAIKENH
    FROM ttkd_bct.va_dm_loaikenh_bh B
    WHERE B.MA_ND = A.ACC_GHINHAN
    AND B.THANG = 202408
),  A.MANV_KENH = (
    SELECT B.MA_NV
    FROM ttkd_bct.va_dm_loaikenh_bh B
    WHERE B.MA_ND = A.ACC_GHINHAN
    AND B.THANG = 202408
),  A.TENNV_KENH = (
    SELECT B.TEN_NV
    FROM ttkd_bct.va_dm_loaikenh_bh B
    WHERE B.MA_ND = A.ACC_GHINHAN
    AND B.THANG = 202408
),  A.TENTO_KENH = (
    SELECT B.TEN_TO
    FROM ttkd_bct.va_dm_loaikenh_bh B
    WHERE B.MA_ND = A.ACC_GHINHAN
    AND B.THANG = 202408
),  A.THANHVIEN_KENH = (
    SELECT B.phanloai_kenh
    FROM ttkd_bct.va_dm_loaikenh_bh B
    WHERE B.MA_ND = A.ACC_GHINHAN
    AND B.THANG = 202408
)
WHERE EXISTS (
    SELECT 1
    FROM ttkd_bct.va_dm_loaikenh_bh B
    WHERE B.ma_nd = A.ACC_GHINHAN
    AND B.THANG = 202408
) 

UPDATE ct_vnp_bris A
SET 
    A.MATO_KENH = (
    SELECT c.MA_TO
    FROM ttkd_bsc.nhanvien c
    WHERE c.ma_nv = A.manv_kenh
    AND c.THANG = 202408
),  A.MAPB_KENH = (
    SELECT c.MA_PB
    FROM ttkd_bsc.nhanvien c
    WHERE c.ma_nv = A.manv_kenh
    AND c.THANG = 202408
),  A.TENPB_KENH = (
    SELECT c.TEN_PB
    FROM ttkd_bsc.nhanvien c
    WHERE c.ma_nv = A.manv_kenh
    AND c.THANG = 202408 )
where EXISTS (
    SELECT 1
    FROM ttkd_bsc.nhanvien c
    where c.ma_nv = a.manv_kenh
    and c.thang = 202408 )


    
    commit
    truncate table vietanhct_vnp_bris
