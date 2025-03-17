select count(*)
from TBL_VNP_BRIS_mo
where thang = 202502;
rollback ;
delete
from TBL_VNP_BRIS_mo where thang = 202502;
select /*flashback*/* from TBL_VNP_BRIS;
--
INSERT INTO TBL_VNP_BRIS_mo  (
     ma_tb,  ngay_init,  loaikenh_dk_tttb,  MANV_DK_TTTB,  TENNV_DK_TTTB,
     ACC_INIT,  KENH_BANGOI,  ACC_BANGOI,  LOAIKENH_DK_BANGOI,
     MANV_DK_BANGOI,  TENNV_DK_BANGOI,  DTHU_HMM,  DTHU_TKC_ngay,  geo_state_key,
     ngay_ins,  thang,  goicuoc,  chuky_goi,  dthu_goi,
     MATO_DK_TTTB,  TENTO_DK_TTTB,  MAPB_DK_TTTB,  TENPB_DK_TTTB,  acc_ghinhan,
     phanloai_nhom,  MATO_DK_BANGOI,  TENTO_DK_BANGOI,  MAPB_DK_BANGOI,  TENPB_DK_BANGOI
)
;
SELECT MA_TB, NGAY_KICH_HOAT, LOAI_KENH, MA_HRM_USER_DKTT, HOTEN_USER_DKTT, USER_DKTT, KENH_BANGOI, ACC_BANGOI,
       LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, DTHU_HMM, DT_TKC, TINH_PSC_THEO_5917,
        ngay_ins, thang, TEN_GOI, CHU_KY_GOI, DTHU_GOI, MA_TO_TTTB, TEN_TO_TTTB
       , MA_PB_TTTB, TEN_PB_TTTB, USER_ELOAD_DK_TTTB, PHANLOAI_NHOM, MA_TO_BANGOI
       , TEN_TO_BANGOI, MA_PB_BANGOI, TEN_PB_BANGOI
      FROM (
               --
               SELECT a.so_tb                                     ma_tb,
                      a.NGAY_KICH_HOAT                                         ngay_kich_hoat,
                      a.LOAI_KENH_NGUOI_PHAT_TRIEN_TB_                                     loai_kenh,
                      a.MA_HRM_USER_QUAN_LYUSER_DANG_K                                       MA_HRM_USER_DKTT,
                      a.HO_TEN_USER_QUAN_LYUSER_DANG_K                                       HOTEN_USER_DKTT,
                      a.USER_ELOAD_DK_TTTB                                        USER_DKTT,
                      a.CONG_CU_DKTTTB || ';' || b.REGIS_SYSTEM_CD                    KENH_BANGOI,
                      CAST(COALESCE(b.USER_CODE, a.USER_ELOAD_DK_TTTB) AS VARCHAR2(30)) ACC_BANGOI,
                      COALESCE(b.CHANNEL_TYPE, a.LOAI_KENH_NGUOI_PHAT_TRIEN_TB_)           LOAIKENH_DK_BANGOI,
                      CAST(COALESCE(b.HRM_CODE, a.MA_HRM_USER_QUAN_LYUSER_DANG_K )   AS VARCHAR2(30))                MANV_DK_BANGOI,
                      CAST(COALESCE(b.STAFF_NAME, a.HO_TEN_USER_QUAN_LYUSER_DANG_K)     AS VARCHAR2(30))          TENNV_DK_BANGOI,
                      ROUND((a.DOANH_THU_HOA_MANG / 1.1), 0)                     DTHU_HMM,
                      a.DT_TKC,
                      a.TINH_PSC_THEO_5917,
                      (SYSDATE) ngay_ins,
                      a.thang,
                      CASE
                          WHEN a.TEN_GOI_CUOC IS NOT NULL AND b.SERVICE_CODE IS NOT NULL THEN
                              CASE
                                  WHEN COALESCE(a.DOANH_THU_GOI, 0) > COALESCE(b.TOT_RVN_PACKAGE, 0)
                                      THEN a.TEN_GOI_CUOC
                                  ELSE b.SERVICE_CODE
                                  END
                          ELSE COALESCE(a.TEN_GOI_CUOC, b.SERVICE_CODE)
                          END                                          AS ten_goi,
                      COALESCE(a.CHU_KY_GOI, (b.P2_CHUKY))               AS chu_ky_goi,
                      COALESCE(a.DOANH_THU_GOI, b.TOT_RVN_PACKAGE) AS dthu_goi,
                      (SELECT b.ma_to
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.MA_HRM_USER_QUAN_LYUSER_DANG_K
                         AND b.thang = 202502)                         AS ma_to_TTTB,
                      (SELECT b.TEN_TO
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.MA_HRM_USER_QUAN_LYUSER_DANG_K
                         AND b.thang = 202502)                         AS ten_to_TTTB,
                      (SELECT b.MA_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.MA_HRM_USER_QUAN_LYUSER_DANG_K
                         AND b.thang = 202502)                         AS ma_pb_TTTB,
                      (SELECT b.TEN_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = a.MA_HRM_USER_QUAN_LYUSER_DANG_K
                         AND b.thang = 202502)                         AS ten_pb_TTTB,
                      a.USER_ELOAD_DK_TTTB,
                      CASE
                          WHEN a.LOAI_SIM = 'KIT_BUNDLE' THEN 'Bundle'
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.TEN_GOI_CUOC IS NULL THEN 'Chưa gói'
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.TEN_GOI_CUOC IS NOT NULL THEN 'Mua gói'
                          WHEN a.TEN_GOI_CUOC IS NULL AND b.SERVICE_CODE IS NULL THEN 'Chưa gói'
                          WHEN a.TEN_GOI_CUOC IS NOT NULL OR b.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                          ELSE NULL
                          END                                          AS phanloai_nhom,
                      (SELECT b.ma_to
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, a.MA_HRM_USER_QUAN_LYUSER_DANG_K )
                         AND b.thang = 202502)                         AS ma_to_bangoi,
                      (SELECT b.TEN_TO
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, a.MA_HRM_USER_QUAN_LYUSER_DANG_K )
                         AND b.thang = 202502)                         AS ten_to_bangoi,
                      (SELECT b.MA_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, a.MA_HRM_USER_QUAN_LYUSER_DANG_K )
                         AND b.thang = 202502)                         AS ma_pb_bangoi,
                      (SELECT b.TEN_PB
                       FROM ttkd_bsc.nhanvien b
                       WHERE b.ma_nv = COALESCE(b.HRM_CODE, a.MA_HRM_USER_QUAN_LYUSER_DANG_K )
                         AND b.thang = 202502)                         AS ten_pb_bangoi

               FROM (SELECT a.*, row_number() OVER (PARTITION BY SO_TB ORDER BY NGAY_KICH_HOAT DESC) rnk  from manpn.bscc_ptm_bris_P01_moi a where thang = 202502) a
                        LEFT JOIN (select * from manpn.bscc_import_goi_bris_p04 where LOAI_TB_THANG ='PTM'
                                                            and LOAIHINH_TB='TT' and thang = 202502) b
                                  ON a.so_tb = b.ACCS_MTHD_KEY
               WHERE a.rnk = 1
               UNION ALL
               SELECT b.ACCS_MTHD_KEY,
                      TO_DATE(b.ACTVTN_DT, 'DD/MM/YYYY hh24:mi:ss') AS ngay_init,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      a.CONG_CU_DKTTTB|| ';' || b.REGIS_SYSTEM_CD,
                      B.USER_CODE,
                      B.CHANNEL_TYPE,
                      B.HRM_CODE,
                      B.STAFF_NAME,
                      0,
                      0,
                      b.GEO_STATE_CD_PSC,
                      (SYSDATE) ngay_ins,
                      b.thang,
                      CASE
                          WHEN b.SERVICE_CODE IS NOT NULL AND a.TEN_GOI_CUOC IS NOT NULL THEN
                              CASE
                                  WHEN COALESCE(b.TOT_RVN_PACKAGE, 0) > COALESCE(a.DOANH_THU_GOI, 0)
                                      THEN b.SERVICE_CODE
                                  ELSE a.TEN_GOI_CUOC
                                  END
                          ELSE COALESCE(b.SERVICE_CODE, a.TEN_GOI_CUOC)
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
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.TEN_GOI_CUOC IS NULL THEN 'Chưa gói'
                          WHEN a.loai_sim <> 'KIT_BUNDLE' AND a.TEN_GOI_CUOC IS NOT NULL THEN 'Mua gói'
                          WHEN a.TEN_GOI_CUOC IS NULL AND b.SERVICE_CODE IS NULL THEN 'Chưa gói'
                          WHEN a.TEN_GOI_CUOC IS NOT NULL OR b.SERVICE_CODE IS NOT NULL THEN 'Mua gói'
                          ELSE NULL
                          END                            AS phanloai_nhom,
                      (SELECT c.ma_to
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202502)           AS ma_to_bangoi,
                      (SELECT c.TEN_TO
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202502)           AS ten_to_bangoi,
                      (SELECT c.MA_PB
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202502)           AS ma_pb_bangoi,
                      (SELECT c.TEN_PB
                       FROM ttkd_bsc.nhanvien c
                       WHERE c.ma_nv = b.HRM_CODE
                         AND c.thang = 202502)           AS ten_pb_bangoi

               FROM ( ( select * from manpn.bscc_import_goi_bris_p04 where LOAI_TB_THANG ='PTM'
                                                            and LOAIHINH_TB='TT' and thang = 202502) ) b
                        LEFT JOIN (SELECT a.*,
                                          row_number() OVER (PARTITION BY ACCS_MTHD_KEY ORDER BY ACTVTN_DT DESC) rnk
                                   FROM (select x.* from vietanhvh.P01_202502 x where mo_key = 202502) a
                                ) a
                                  ON a.ACCS_MTHD_KEY = b.ACCS_MTHD_KEY
               WHERE a.ACCS_MTHD_KEY IS NULL)

     ;
            update TBL_VNP_BRIS_mo
            set dthu_goi_novat = (ROUND(nvl(dthu_goi,0)/1.1,0))
            where thang = 202502
            ;
            update TBL_VNP_BRIS_mo
            set dthu_tkc = (ROUND(nvl(dthu_goi,0)/1.1/chuky_goi,0))
            where thang = 202502
            ;
            update TBL_VNP_BRIS_mo
            set tong_dthu_ptm = (nvl(dthu_hmm,0) + nvl(dthu_goi_novat,0))
            where thang = 202502

            ;
            UPDATE TBL_VNP_BRIS_mo
            SET TONG_DTHU_PTM_NGAY = (DTHU_HMM + DTHU_TKC_NGAY)
            where thang = 202502
            ;
            UPDATE TBL_VNP_BRIS_mo
            SET DTHU_TKC = (DTHU_HMM + DTHU_GOI_NOVAT)
            where thang = 202502

            ;
              update TBL_VNP_BRIS_MO
            set PHANLOAI_NHOM = 'Mua gói'
            where PHANLOAI_NHOM ='Chưa gói' and GOICUOC is not null
            ;

--DANGEROUS
delete

from TTKDHCM_KTNV.TBL_VNP_BRIS
where thang = 202502;

insert into TTKDHCM_KTNV.tbl_vnp_bris
select *
from TBL_VNP_BRIS_mo where thang = 202502;

            update TTKDHCM_KTNV.tbl_vnp_bris
            set dthu_goi_novat = (ROUND(nvl(dthu_goi,0)/1.1,0))
            where thang = 202502
            ;

    -- check trung` ma_tb
    select*
    from ttkdhcm_ktnv.TBL_VNP_BRIS
    where thang = 202502
        and ma_tb in ( select ma_tb
        from ttkdhcm_ktnv.TBL_VNP_BRIS
        where thang = 202502 group by ma_tb having count(ma_tb)>1);

        -- del accghi nhan null --> ko map dc kenh ban
                delete from ttkdhcm_ktnv.TBL_VNP_BRIS
                where thang = 202502
                and acc_ghinhan is null;
        -- del case trung ma_tb vi` nhieu goi_cuoc ->> chose the greatest one
               DELETE FROM ttkdhcm_ktnv.TBL_VNP_BRIS
                WHERE
                    thang = 202502
                    AND ROWID IN (
                        SELECT ROWID FROM (
                            SELECT
                                ROWID,
                                ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY dthu_goi DESC) AS rn
                            FROM
                                ttkdhcm_ktnv.TBL_VNP_BRIS
                            WHERE
                                thang = 202502
                        )
                        WHERE rn > 1
                    );

;

--test ttkdhcm_ktnv.TBL_VNP_BRIS
create table TBL_VNP_BRIS
as select * from ttkdhcm_ktnv.TBL_VNP_BRIS where 1=0 ;
select * from ttkdhcm_ktnv.TBL_VNP_BRIS where thang = 202502;
select * from TBL_VNP_BRIS;

----------------------------------END---------------------------------

