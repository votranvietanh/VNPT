-- INSERT TRẢ TRƯỚC:
        insert into VA_ct_BSC_DTHU_DTRI_NAM(THANG,thang_ptm, DICH_VU, MA_TB, MANV_PTM, MA_VTCV, TEN_NV,  MA_PB, TEN_PB,MA_TO, TEN_TO, DTHU_THUC_HIEN)
;
               WITH DS_PTM AS (
                    SELECT
                        a.MA_TB, a.MANV_PTM, a.MA_VTCV, a.MA_PB,  a.TEN_PB,  a.MA_TO,  a.TEN_TO, a.THANG_PTM as thang_ptm,
                        ROW_NUMBER() OVER (PARTITION BY a.MA_TB ORDER BY a.THANG_PTM DESC) AS rn
                    FROM
                        TTKD_BSC.CT_BSC_PTM a
                    WHERE
                        a.dich_vu = 'VNPTT'
                        AND a.THANG_PTM in (202406, 202407, 202408)
                        AND a.TENKIEU_LD in ('ptm')
                     )
        SELECT
            202409 AS thang,a.thang_ptm,'VNPTT' AS dich_vu,a.MA_TB,a.MANV_PTM,a.MA_VTCV,c.ten_nv,a.MA_PB, a.TEN_PB, a.MA_TO, a.TEN_TO,
            NVL(b.total_tkc, 0) AS dthu_thuc_hien
        FROM
            DS_PTM a
        LEFT JOIN cuocvina.tieudung_bts_202409@ttkddbbk2 b ON '84' || b.subscriber_id = a.ma_tb
        LEFT JOIN ttkd_bsc.nhanvien c
        ON a.manv_ptm = c.ma_nv AND c.thang = 202409
        WHERE
            a.rn = 1
            AND a.manv_ptm IS NOT NULL
--            AND NVL(b.total_tkc, 0) >0
        GROUP BY
            a.thang_ptm,  a.MA_TB, a.MANV_PTM,a.MA_VTCV,c.ten_nv,a.MA_PB,a.TEN_PB,a.MA_TO,a.TEN_TO,b.total_tkc
            ;
--INSERT trả sauu:
        -- bsung VNPts :
        insert into VA_ct_BSC_DTHU_DTRI_NAM(THANG,thang_ptm, DICH_VU, MA_TB, MANV_PTM, MA_VTCV, TEN_NV,  MA_TO, TEN_TO,MA_PB, TEN_PB, DTHU_THUC_HIEN)

          WITH ranked_data AS (
            SELECT a.*,
                   ROW_NUMBER() OVER (PARTITION BY a.MA_TB ORDER BY a.thang_ptm DESC) AS rn
            FROM ttkd_bsc.ct_bsc_ptm a
            WHERE a.thang_ptm IN (202406, 202407, 202408)
              AND a.loaitb_id = 20
        )
        SELECT 202409 thang,
                ranked_data.thang_ptm,
               'VNPTS' dich_vu,
               ranked_data.MA_TB,
               ranked_data.MANV_PTM,
               ranked_data.MA_VTCV,
               c.ten_Nv,
               ranked_data.MA_TO,
               ranked_data.TEN_TO,
               ranked_data.MA_PB,
               ranked_data.TEN_PB,
               NVL(SUM(b.dthu), 0) dthu
        FROM ranked_data
        LEFT JOIN (
            SELECT MA_TB,
                   SUM(dthu) dthu
            FROM ttkd_bct.cuoc_thuebao_ttkd
            WHERE LOAITB_ID = 20
            GROUP BY MA_TB
        ) b ON ranked_data.MA_TB = b.MA_TB
        LEFT JOIN ttkd_bsc.nhanvien c
               ON ranked_data.MANV_PTM = c.ma_nv
               AND c.thang = 202409
        WHERE ranked_data.rn = 1 -- Select only the first row for each MA_TB
        GROUP BY ranked_data.MA_TB,  ranked_data.thang_ptm,
                 ranked_data.MANV_PTM,
                 ranked_data.MA_VTCV,
                 ranked_data.MA_TO,
                 ranked_data.TEN_TO,
                 ranked_data.MA_PB,
                 ranked_data.TEN_PB,
                 c.ten_Nv
                 ;

    ---Bảng Chi tiết:
            select * from VA_tl_BSC_DTHU_DTRI_NAM where thang = 202409;



            select* from  HCM_DT_PTMOI_060;
            with J as (select THANG, MANV_PTM , TEN_NV,ma_vtcv,ma_to,ma_pb,ten_to,ten_pb, count(*) SL_TB_DAT
            from VA_ct_BSC_DTHU_DTRI_NAM
            where thang = 202409 and DTHU_THUC_HIEN > 0
                group by THANG, MANV_PTM, TEN_NV,ma_vtcv,ma_to,ma_pb,ten_to,ten_pb
                )
                select * from J where manv_ptm in (select manv_ptm from J group by manv_ptm having count(manv_ptm)>1 );
            select * from VA_ct_BSC_DTHU_DTRI_NAM where thang = 202409 AND MANV_PTM = 'VNP029157';
                        create table HCM_DT_PTMOI_060 as
            with J as (select THANG, MANV_PTM , TEN_NV, count(*) SL_TB_DAT from VA_ct_BSC_DTHU_DTRI_NAM
            where thang = 202409 and DTHU_THUC_HIEN > 0
                group by THANG, MANV_PTM, TEN_NV
                )
                ,K as (select THANG, MANV_PTM , TEN_NV, count(*) SL_TB_DAT from VA_ct_BSC_DTHU_DTRI_NAM
            where thang = 202409
                group by THANG, MANV_PTM, TEN_NV
                )
              ,all1 as(  select J.*,nv.ma_vtcv,nv.ma_to,nv.ten_to,nv.ma_pb,nv.ten_pb,K.SL_TB_DAT sl_tong,round((J.SL_TB_DAT/K.SL_TB_DAT)*100,2) tyle,50 giao,round((J.SL_TB_DAT/K.SL_TB_DAT)*100,2)*100/50 tyle_final from J
                join K on K.manv_ptm = J.manv_ptm
                join ttkd_bsc.nhanvien nv on J.manv_ptm = nv.ma_nv and nv.thang = j.thang)
                select THANG,'KPI_NV'LOAI_TINH,'HCM_DT_PTMOI_060' MA_KPI, MANV_PTM ma_nv, TEN_NV,MA_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, SL_TB_DAT, SL_TONG, TYLE, GIAO, tyle_final from all1;
            select * from all1; where manv_ptm in (select manv_ptm from all1 group by manv_ptm having count(manv_ptm)>1)
            ;

                WHERE MANV_PTM IN ( SELECT MANV_PTM FROM j GROUP BY MANV_PTM HAVING COUNT(MANV_PTM)>1)
            ;
            SELECT * FROM TTKD_BSC.NHANVIEN A WHERE A.MA_NV= 'VNP017053' AND A.THANG = 202409;

            with J as (select * from VA_ct_BSC_DTHU_DTRI_NAM where thang = 202409)
            select * from J where ma_tb in (select ma_tb from J group by ma_tb,dich_vu having count(ma_tb)>1)
            ;
select * from TTKD_BSC.nhanvien where thang = 202409  and ma_nv = 'VNP017014'
            ;
            select * from va_TL_bsc_dthu_dtri_nam where thang = 202409
            ;

DELETE FROM va_TL_bsc_dthu_dtri_nam
WHERE ma_nv IN (
    SELECT ma_nv
    FROM ttkd_bsc.nhanvien
    WHERE thang = 202409
      AND (tinh_bsc = 0 OR THAYDOI_VTCV = 1)
      AND ma_nv IN (
          SELECT ma_nv
          FROM va_TL_bsc_dthu_dtri_nam
          WHERE dthu_thuc_hien = 0
            AND thang = 202409
            AND loai_tinh ='KPI_NV'
      )
)
AND thang = 202409;



 insert into va_TL_bsc_dthu_dtri_nam(THANG, LOAI_TINH, MA_KPI, MA_NV, MA_VTCV, MA_TO, MA_PB,SL_GIAO, DTHU_THUC_HIEN,TLTH)
           ;
           select THANG, LOAI_TINH, MA_KPI, MA_NV, MA_VTCV, MA_TO, MA_PB,SL_TONG,SL_TB_DAT,TYLE from HCM_DT_PTMOI_060 where thang = 202409 and ma_kpi = 'HCM_DT_PTMOI_060' and ma_vtcv in (  SELECT ma_vtcv
        FROM TTKD_BSC.blkpi_danhmuc_kpi_vtcv
        WHERE THANG_KT IS NULL
            AND ma_kpi = 'HCM_DT_PTMOI_060' );

              insert into va_TL_bsc_dthu_dtri_nam(THANG, LOAI_TINH, MA_KPI, MA_NV, MA_VTCV, MA_TO, MA_PB,SL_GIAO, DTHU_THUC_HIEN)

                WITH mnv_tt AS (
    SELECT ma_nv, MA_VTCV, ten_vtcv, ma_to
    FROM ttkd_bsc.nhanvien nv
    WHERE thang = 202409
    AND EXISTS (
        SELECT *
        FROM TTKD_BSC.blkpi_danhmuc_kpi_vtcv kpi
        WHERE THANG_KT IS NULL
        AND TO_TRUONG_PHO = 1
        AND ma_kpi = 'HCM_DT_PTMOI_060'
        AND ma_vtcv = nv.ma_vtcv
    )
)
SELECT
    thang,
    'KPI_TO' AS loai_tinh,
    MA_KPI,
    b.ma_nv,
    b.ma_vtcv,
    a.MA_TO,
    MA_PB,
    SUM(CASE
            WHEN a.ma_vtcv = 'VNP-HNHCM_BHKV_15' THEN SL_GIAO
            ELSE 0
        END) AS SL_giao,
    SUM(CASE
            WHEN a.ma_vtcv IN ('VNP-HNHCM_BHKV_15','HNHCM_BHKV_17') THEN DTHU_THUC_HIEN
            ELSE 0
        END) AS DTHU_THUC_HIEN
FROM
    va_TL_bsc_dthu_dtri_nam a
LEFT JOIN
    mnv_tt b ON a.ma_to = b.ma_to
WHERE
    a.thang = TO_CHAR(TRUNC(SYSDATE, 'month')-1, 'yyyymm')
    AND a.loai_tinh = 'KPI_NV'
    AND ma_kpi = 'HCM_DT_PTMOI_060'
    AND a.ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17')
    AND ma_pb IN (
        'VNP0701100', 'VNP0701200', 'VNP0701300', 'VNP0701400', 'VNP0701500',
        'VNP0701600', 'VNP0701800', 'VNP0702100', 'VNP0702200', 'VNP0702300',
        'VNP0702400', 'VNP0702500'
    )
GROUP BY
    thang,
    MA_KPI,
    a.MA_TO,
    MA_PB,
    b.ma_nv,
    b.ma_vtcv;
select  TO_CHAR(TRUNC(SYSDATE, 'month')-1, 'yyyymm') from dual;
            ;

            ----pgd


              insert into va_TL_bsc_dthu_dtri_nam(THANG, LOAI_TINH, MA_KPI, MA_NV, MA_VTCV, MA_TO, MA_PB,SL_GIAO, DTHU_THUC_HIEN)


                WITH mnv_pgd AS (
    SELECT ma_nv, MA_VTCV, ten_vtcv, ma_to,ma_pb
    FROM ttkd_bsc.nhanvien nv
    WHERE thang = 202409
    AND EXISTS (
        SELECT *
        FROM TTKD_BSC.blkpi_danhmuc_kpi_vtcv kpi
        WHERE THANG_KT IS NULL
        AND GIAMDOC_PHOGIAMDOC = 1
        AND ma_kpi = 'HCM_DT_PTMOI_060'
        AND ma_vtcv = nv.ma_vtcv
    )
)
SELECT
    thang,
    'KPI_PB' AS loai_tinh,
    MA_KPI,
    b.ma_nv,
    b.ma_vtcv,
    a.MA_TO,
    a.MA_PB,
    SUM(CASE
            WHEN a.ma_vtcv = 'VNP-HNHCM_BHKV_17' THEN SL_GIAO
            ELSE 0
        END) AS SL_giao,
    SUM(CASE
            WHEN a.ma_vtcv IN ('VNP-HNHCM_BHKV_2','VNP-HNHCM_BHKV_17') THEN DTHU_THUC_HIEN
            ELSE 0
        END) AS DTHU_THUC_HIEN
FROM
    va_TL_bsc_dthu_dtri_nam a
LEFT JOIN
    mnv_pgd b ON a.ma_pb = b.ma_pb
WHERE
    a.thang = TO_CHAR(TRUNC(SYSDATE, 'month')-1, 'yyyymm')
    AND a.loai_tinh = 'KPI_TO'
    AND ma_kpi = 'HCM_DT_PTMOI_060'
    AND a.ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_2')
    AND a.ma_pb IN (
        'VNP0701100', 'VNP0701200', 'VNP0701300', 'VNP0701400', 'VNP0701500',
        'VNP0701600', 'VNP0701800', 'VNP0702100', 'VNP0702200', 'VNP0702300',
        'VNP0702400', 'VNP0702500'
    )
    and b.ma_nv in (select x.ma_nv from ttkd_Bsc.blkpi_dm_to_pgd x where x.dichvu  in  ('VNP tra truoc','VNP tra sau')
                and x.thang = 202409
                and x.ma_to =a.ma_to)
GROUP BY
    thang,
    MA_KPI,
    a.MA_TO,
    a.MA_PB,
    b.ma_nv,
    b.ma_vtcv;
    update va_TL_bsc_dthu_dtri_nam
    set tlth = round((DTHU_THUC_HIEN/SL_GIAO),2)*100
    where loai_tinh <> 'KPI_NV' and thang = 202409;

--    delete from vietanhvh.va_TL_bsc_dthu_dtri_nam where thang = 202409  and loai_tinh = 'KPI_TO';
   select * from vietanhvh.va_ct_bsc_dthu_dtri_nam where thang = 202409 ;and ten_nv = 'Trần Huỳnh Ánh Nhiên'
   ;
   select * from ttkd_bsc.nhanvien where ma_nv = 'VNP019529' and thang =202409
   ;
   select * from  ttkd_Bsc.blkpi_dm_to_pgd where thang =202409;

UPDATE TTKD_BSC.bangluong_kpi a
SET TYLE_THUCHIEN = (
    SELECT x.TLTH
    FROM (
        SELECT x.TLTH, ROW_NUMBER() OVER (PARTITION BY x.MA_NV, x.ma_kpi ORDER BY CASE WHEN x.loai_tinh = 'KPI_TO' THEN 1 ELSE 2 END) as rn
        FROM vietanhvh.va_TL_bsc_dthu_dtri_nam x
        WHERE x.thang = 202409
          AND x.MA_NV = a.MA_NV
          AND a.ma_kpi = x.ma_kpi
    ) x
    WHERE x.rn = 1
)
WHERE a.thang = 202409
  AND a.ma_KPI = 'HCM_DT_PTMOI_060';

UPDATE TTKD_BSC.bangluong_kpi a
SET chitieu_giao = 50
where thang = 202409 and ma_kpi = 'HCM_DT_PTMOI_060' and TYLE_THUCHIEN is not null
;
UPDATE TTKD_BSC.bangluong_kpi a
SET THUCHIEN = null
    ,giao = null;
-- UPDATE TTKD_BSC.bangluong_kpi a
-- SET TYLE_THUCHIEN = round((thuchien/chitieu_giao)*100,2)
-- where thang = 202409 and ma_kpi = 'HCM_DT_PTMOI_060' and thuchien is not null
-- ;
UPDATE bangluong_kpi a
SET TYLE_THUCHIEN = 4561
where thang = 202409 and MA_NV ='VNP030414'
;

select * from ttkd_Bsc.blkpi_dm_to_pgd x where x.dichvu  in  ('VNP tra truoc','VNP tra sau') and x.ma_to in (
    select distinct ma_to from vietanhvh.va_TL_bsc_dthu_dtri_nam where thang = 202409
    )
;
select * from vietanhvh.va_TL_bsc_dthu_dtri_nam where thang = 202409 and ma_to ='VNP0701330';
select * from ttkd_Bsc.nhanvien  where thang = 202409 and ma_vtcv ='VNP-HNHCM_BHKV_1';

select * from TTKD_BSC.bangluong_kpi
where thang = 202409 and ma_kpi = 'HCM_DT_PTMOI_060';
