--PL1_2024,
--PL4_2024,
--PL1_MONTHLY,
--PL4_MONTHLY,
    delete from PL1_2024 where thang = 202409;
    delete from PL4_2024 where thang = 202409;
    delete from PL1_MONTHLY where thang = 202409;
    delete from PL4_MONTHLY where thang = 202409;
    delete from PL5 where thang = 202409;
select * from PL1_2024 where thang = 202409;
select * from PL4_2024 where thang = 202409;
select * from PL1_MONTHLY where thang = 202409;
select * from PL4_MONTHLY where thang = 202409;
--import PL1_2024,PL4_2024 xong thi chay dong nay
    delete from PL1_2024 where STT =0 ;
    delete from PL4_2024 where STT =0 ;


UPDATE PL1_2024
SET thang = 202409
WHERE To_number(TO_CHAR(ngay_kich_hoat, 'yyyymm')) = 202409;

UPDATE PL4_2024
SET thang = 202409
WHERE To_number(TO_CHAR(ngay_kich_hoat, 'yyyymm')) = 202409;


INSERT INTO PL1_MONTHLY(THANG,MA_TB,PHANLOAI_NHOM,NGAY_INIT,LOAIKENH_DK_TTTB,MANV_DK_TTTB,goicuoc,chuky_goi,dthu_goi,acc_init,kenh_bangoi,acc_bangoi,loaikenh_dk_bangoi,manv_dk_bangoi,DTHU_HMM,geo_state_key,ploai,loai_sim,ngay_ins)
SELECT 202409,MA_TB,loai_sim, NGAY_KICH_HOAT,LOAI_kenh,MA_HRM_USER_DKTT, goi_cuoc,chu_ky_goi,dthu_goi,USER_DKTT,DIEM_CHAM_TIEPTHI,USER_DKTT,LOAI_KENH_CUA_USER,MA_HRM_USER_DKTT,DTHU_HMM,TINH_PSC_5917, 'PL1',loai_sim,sysdate
FROM PL1_2024
WHERE To_number(TO_CHAR(ngay_kich_hoat, 'yyyymm')) = 202409;

;

INSERT INTO PL4_MONTHLY (THANG,MA_TB,NGAY_INIT,goicuoc,chuky_goi,dthu_goi,kenh_bangoi,acc_bangoi,loaikenh_dk_bangoi,manv_dk_bangoi,tennv_dk_bangoi,geo_state_key,ploai,ngay_ins)
SELECT 202409,MA_TB, NGAY_KICH_HOAT, ma_goi,chu_ky_goi,doanh_thu_ban_goi,CONG_CU_BAN_GOI,USER_KENH_BAN,LOAI_KENH_BAN,HRM_NV_BAN_GOI_NV_QLKENH_BAN,NV_BAN_GOI_NV_QL_KENH_BAN,DON_VI_PSC_5917, 'PL4',SYSDATE
FROM PL4_2024
WHERE TO_NUMBER(TO_CHAR(ngay_kich_hoat, 'yyyymm')) = 202409;

;


----
-- C?p nh?t các tr??ng MATO_DK_TTTB, TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, TENNV_DK_TTTB trong b?ng PL1_MONTHLY
UPDATE PL1_MONTHLY a
SET
    a.MATO_DK_TTTB = (SELECT b.MA_TO FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_TTTB AND b.thang = 202409),
    a.TENTO_DK_TTTB = (SELECT b.TEN_TO FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_TTTB AND b.thang = 202409),
    a.MAPB_DK_TTTB = (SELECT b.MA_PB FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_TTTB AND b.thang = 202409),
    a.TENPB_DK_TTTB = (SELECT b.TEN_PB FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_TTTB AND b.thang = 202409),
    a.TENNV_DK_TTTB = (SELECT b.ten_nv FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_TTTB AND b.thang = 202409)
WHERE to_number(TO_CHAR(a.ngay_init, 'yyyymm')) = 202409
AND EXISTS (SELECT 1 FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_TTTB AND b.thang = 202409);

-- C?p nh?t các tr??ng MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI, TENPB_DK_BANGOI, TENNV_DK_BANGOI trong b?ng PL1_MONTHLY
UPDATE PL1_MONTHLY a
SET
    a.MATO_DK_BANGOI = (SELECT b.MA_TO FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_BANGOI AND b.thang = 202409),
    a.TENTO_DK_BANGOI = (SELECT b.TEN_TO FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_BANGOI AND b.thang = 202409),
    a.MAPB_DK_BANGOI = (SELECT b.MA_PB FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_BANGOI AND b.thang = 202409),
    a.TENPB_DK_BANGOI = (SELECT b.TEN_PB FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_BANGOI AND b.thang = 202409),
    a.TENNV_DK_BANGOI = (SELECT b.ten_nv FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_BANGOI AND b.thang = 202409)
WHERE to_number(TO_CHAR(a.ngay_init, 'yyyymm')) = 202409
AND EXISTS (SELECT 1 FROM ttkd_bsc.nhanvien b WHERE b.MA_NV = a.MANV_DK_BANGOI AND b.thang = 202409);

-----===========
     UPDATE PL1_MONTHLY a
SET
    a.MATO_DK_TTTB = (
        SELECT b.MA_TO
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_TTTB = b.MA_NV AND b.thang = 202409)
    ),
    a.TENTO_DK_TTTB = (
        SELECT b.TEN_TO
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_TTTB = b.MA_NV AND b.thang = 202409)
    ),
    a.MAPB_DK_TTTB = (
        SELECT b.MA_PB
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_TTTB = b.MA_NV AND b.thang = 202409)
    ),
    a.TENPB_DK_TTTB = (
        SELECT b.TEN_PB
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_TTTB = b.MA_NV AND b.thang = 202409)
    ),
    a.TENNV_DK_TTTB = (
        SELECT b.ten_nv
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_TTTB = b.MA_NV AND b.thang = 202409)
    ),
    a.MATO_DK_BANGOI = (
        SELECT b.MA_TO
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_BANGOI = b.MA_NV AND b.thang = 202409)
    ),
    a.TENTO_DK_BANGOI = (
        SELECT b.TEN_TO
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_BANGOI = b.MA_NV AND b.thang = 202409)
    ),
    a.MAPB_DK_BANGOI = (
        SELECT b.MA_PB
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_BANGOI = b.MA_NV AND b.thang = 202409)
    ),
    a.TENPB_DK_BANGOI = (
        SELECT b.TEN_PB
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_BANGOI = b.MA_NV AND b.thang = 202409)
    ),
    a.TENNV_DK_BANGOI = (
        SELECT b.ten_nv
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_BANGOI = b.MA_NV AND b.thang = 202409)
    )
WHERE
    TO_NUMBER(TO_CHAR(a.ngay_init, 'yyyymm')) = 202409
    AND EXISTS (
        SELECT 1
        FROM ttkd_bsc.nhanvien b
        WHERE (a.MANV_DK_TTTB = b.MA_NV OR a.MANV_DK_BANGOI = b.MA_NV)
          AND b.thang = 202409
    );

----=======

            MERGE INTO PL4_monthly a
        USING (
            SELECT
                b.MA_NV,b.MA_TO,b.TEN_TO,b.MA_PB, b.TEN_PB
            FROM
                ttkd_bsc.nhanvien b
            WHERE
                b.thang = 202409
        ) b
        ON (a.MANV_DK_BANGOI = b.MA_NV)
        WHEN MATCHED THEN
        UPDATE SET
            a.MATO_DK_BANGOI = b.MA_TO,
            a.TENTO_DK_BANGOI = b.TEN_TO,
            a.MAPB_DK_BANGOI = b.MA_PB,
            a.TENPB_DK_BANGOI = b.TEN_PB
        WHERE
            to_number(TO_CHAR(a.ngay_init, 'yyyymm')) = 202409;

-----
            UPDATE PL1_monthly --PL1_monthly
                SET DTHU_HMM  = DTHU_HMM/1.1
            WHERE  TO_NUMBER(TO_CHAR(ngay_init, 'yyyymm')) = 202409;

            ;
--======================
            UPDATE PL4_monthly
            SET dthu_tkc = NVL(DTHU_GOI, 0) / 1.1 / CHUKY_GOI
            WHERE  TO_NUMBER(TO_CHAR(ngay_init, 'yyyymm')) = 202409;


    --======
            ;
            update PL1_monthly
            SET TONG_DTHU_PTM = NVL(dthu_hmm,0) + NVL(dthu_tkc,0)
            WHERE  TO_NUMBER(TO_CHAR(ngay_init, 'yyyymm')) = 202409;
    --======

            ;
            update PL4_monthly
            SET TONG_DTHU_PTM = NVL(dthu_hmm,0) + NVL(dthu_tkc,0)
            WHERE  TO_NUMBER(TO_CHAR(ngay_init, 'yyyymm')) = 202409;

            ;
---- insert to view:
            insert into PL5(THANG,MA_TB, PHANLOAI_NHOM, NGAY_INIT, LOAIKENH_DK_TTTB, MANV_DK_TTTB, TENNV_DK_TTTB, MATO_DK_TTTB,
                 TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, GOICUOC, CHUKY_GOI, DTHU_GOI, ACC_INIT,
                 KENH_BANGOI, ACC_BANGOI, LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI,
                 TENPB_DK_BANGOI, DTHU_HMM, DTHU_TKC, TONG_DTHU_PTM,GEO_STATE_KEY,ploai,LOAI_SIM)

        select * from(
                SELECT
                    202409,
                NVL(a.MA_TB, b.MA_TB) AS MA_TB,
                NVL(a.PHANLOAI_NHOM, b.PHANLOAI_NHOM) AS PHANLOAI_NHOM,
                NVL(a.NGAY_INIT, b.NGAY_INIT) AS NGAY_INIT,
                NVL(a.LOAIKENH_DK_TTTB, b.LOAIKENH_DK_TTTB) AS LOAIKENH_DK_TTTB,
                NVL(a.MANV_DK_TTTB, b.MANV_DK_TTTB) AS MANV_DK_TTTB,
                NVL(a.TENNV_DK_TTTB, b.TENNV_DK_TTTB) AS TENNV_DK_TTTB,
                NVL(a.MATO_DK_TTTB, b.MATO_DK_TTTB) AS MATO_DK_TTTB,
                NVL(a.TENTO_DK_TTTB, b.TENTO_DK_TTTB) AS TENTO_DK_TTTB,
                NVL(a.MAPB_DK_TTTB, b.MAPB_DK_TTTB) AS MAPB_DK_TTTB,
                NVL(a.TENPB_DK_TTTB, b.TENPB_DK_TTTB) AS TENPB_DK_TTTB,
                CASE
                    WHEN a.goicuoc IS NULL THEN b.goicuoc
                    WHEN b.goicuoc IS NULL THEN a.goicuoc
                    ELSE b.goicuoc
                END   AS GOICUOC,
               CASE
                    WHEN a.CHUKY_GOI IS NULL THEN b.CHUKY_GOI
                    WHEN b.CHUKY_GOI IS NULL THEN a.CHUKY_GOI
                    ELSE b.CHUKY_GOI
                END  AS CHUKY_GOI,
                CASE
                    WHEN a.DTHU_GOI IS NULL THEN b.DTHU_GOI
                    WHEN b.DTHU_GOI IS NULL THEN a.DTHU_GOI
                    ELSE b.DTHU_GOI
                END  AS DTHU_GOI,
                NVL(a.ACC_INIT, b.ACC_INIT) AS ACC_INIT,
                NVL(a.KENH_BANGOI, '') || '; ' || NVL(b.KENH_BANGOI, '') AS KENH_BANGOI,
                    CASE
                    WHEN a.ACC_BANGOI IS NULL THEN b.ACC_BANGOI
                    WHEN b.ACC_BANGOI IS NULL THEN a.ACC_BANGOI
                    ELSE b.ACC_BANGOI
                END AS ACC_BANGOI,
                 CASE
                    WHEN a.LOAIKENH_DK_BANGOI IS NULL THEN b.LOAIKENH_DK_BANGOI
                    WHEN b.LOAIKENH_DK_BANGOI IS NULL THEN a.LOAIKENH_DK_BANGOI
                    ELSE b.LOAIKENH_DK_BANGOI
                END AS   LOAIKENH_DK_BANGOI,
                CASE
                    WHEN a.MANV_DK_BANGOI IS NULL THEN b.MANV_DK_BANGOI
                    WHEN b.MANV_DK_BANGOI IS NULL THEN a.MANV_DK_BANGOI
                    ELSE b.MANV_DK_BANGOI
                END AS MANV_DK_BANGOI,
                null AS TENNV_DK_BANGOI,
                null AS MATO_DK_BANGOI,
                null AS TENTO_DK_BANGOI,
                null AS MAPB_DK_BANGOI,
                null AS TENPB_DK_BANGOI,
             NVL(a.DTHU_HMM, 0) + NVL(b.DTHU_HMM, 0)  as DTHU_HMM ,
              NVL(a.DTHU_TKC, 0) + NVL(b.DTHU_TKC, 0) as  DTHU_TKC,
              NVL(a.TONG_DTHU_PTM, 0) + NVL(b.TONG_DTHU_PTM, 0) as  TONG_DTHU_PTM,
              nvl(a.GEO_STATE_KEY,b.GEO_STATE_KEY) as GEO_STATE_KEY,
             CASE
                    WHEN a.ploai = 'PL1' AND b.ploai = 'PL4' THEN 'PL5'
                    WHEN a.ploai IS NULL THEN b.ploai
                    ELSE a.ploai
                END AS ploai,
                a.loai_sim
--         NVL(TO_CHAR(a.ngay_ins, 'DD/MM/YYYY'), TO_CHAR(b.ngay_ins, 'DD/MM/YYYY')) AS ngay_ins
            FROM
                PL1_monthly a
            full JOIN
                PL4_monthly b ON a.ma_tb = b.ma_tb
                )
            WHERE  TO_NUMBER(TO_CHAR(ngay_init, 'yyyymm')) = 202409;

                ;
        -----===================
        MERGE INTO PL5 a
    USING (
        SELECT
            b.MA_NV,b.MA_TO, b.TEN_TO,b.MA_PB,b.TEN_PB,b.ten_nv
        FROM
            ttkd_bsc.nhanvien b
        WHERE
            b.thang = 202409
    ) b
    ON (a.MANV_DK_BANGOI = b.MA_NV)
    WHEN MATCHED THEN
    UPDATE SET
        a.MATO_DK_BANGOI = b.MA_TO,
        a.TENTO_DK_BANGOI = b.TEN_TO,
        a.MAPB_DK_BANGOI = b.MA_PB,
        a.TENPB_DK_BANGOI = b.TEN_PB,
        a.TENNV_DK_BANGOI = b.ten_nv
    WHERE
        to_number(TO_CHAR(a.ngay_init, 'yyyymm')) = 202409

    ;
        --======

                    UPDATE PL5
                SET acc_ghinhan =
                CASE
                    WHEN acc_init IS NOT NULL THEN acc_init
                END
            WHERE  TO_NUMBER(TO_CHAR(ngay_init, 'yyyymm')) = 202409;


--            upgrade
                    MERGE INTO PL5 a
                    USING (
                        SELECT ma_tb, ngay_kich_hoat, DT_TKC
                        FROM PL1_2024
                        WHERE thang = 202409
                    ) b
                    ON (a.ma_tb = b.ma_tb AND a.NGAY_INIT = b.ngay_kich_hoat)
                    WHEN MATCHED THEN
                        UPDATE SET DTHU_TKC_NGAY = b.DT_TKC
                    WHERE to_number(TO_CHAR(a.ngay_init, 'yyyymm')) = 202409;


            --tong-dthu-ngay:
            update PL5 a
            set TONG_DTHU_PTM_NGAY = nvl(DTHU_TKC_NGAY,0) + DTHU_HMM
            where to_number(TO_CHAR(a.ngay_init, 'yyyymm')) = 202409;

    ---- phanloai_nhomm:
            update PL5
        SET loai_sim = case when ploai ='PL5' then null
        else loai_sim
        end
        where thang = 202409 --(SYSDATE, 'DD/MM/YYYY')
        ;
        --
              MERGE INTO PL5 a
            USING (
                SELECT b.ma_tb, b.phanloai_nhom
                FROM pl1_monthly b
                WHERE b.phanloai_nhom = 'BUNDLE'
                AND b.thang = 202409
            ) b
            ON (
                a.ma_tb = b.ma_tb
                AND a.ngay_init >= TO_DATE('202409-01', 'yyyymm-dd')

            )
            WHEN MATCHED THEN
            UPDATE SET a.phanloai_nhom = b.phanloai_nhom;

        ---
        update PL5
        SET phanloai_nhom = CASE
            WHEN ploai = 'PL1' AND loai_sim ='BUNDLE' then 'Bundle'
            WHEN ploai = 'PL1' AND loai_sim = 'SIMDONLE' then null
            WHEN ploai = 'PL5' AND goicuoc IS NOT NULL THEN 'Mua gói'
            WHEN ploai = 'PL4' AND goicuoc IS NULL THEN 'Chua gói'
            WHEN ploai = 'PL4' AND goicuoc IS NOT NULL THEN 'Mua gói'
            ELSE phanloai_nhom
        END
        where thang = 202409--TO_CHAR(SYSDATE, 'DD/MM/YYYY')
        ;

        update PL5
        SET phanloai_nhom = CASE
            WHEN ploai = 'PL1' AND goicuoc IS NOT NULL THEN 'Mua gói'
            WHEN ploai = 'PL1' AND goicuoc IS NULL THEN 'Chua gói'
            ELSE phanloai_nhom
        END
        where PHANLOAI_NHOM is null and  to_number(TO_CHAR(ngay_init, 'yyyymm')) = 202409--TO_CHAR(SYSDATE, 'DD/MM/YYYY')
        ;
    ---- final:
    --delete xong them :
    delete from ttkdhcm_ktnv.TBL_VNP_BRIS where thang = 202409;


    insert into ttkdhcm_ktnv.TBL_VNP_BRIS(MA_TB, PHANLOAI_NHOM, NGAY_INIT, LOAIKENH_DK_TTTB, MANV_DK_TTTB, TENNV_DK_TTTB, MATO_DK_TTTB, TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, GOICUOC, CHUKY_GOI, DTHU_GOI, ACC_INIT, KENH_BANGOI, ACC_BANGOI, LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI, TENPB_DK_BANGOI, DTHU_HMM, DTHU_TKC, TONG_DTHU_PTM, ACC_GHINHAN, LOAIKENH_GHINHAN, NGUON, NGAY_INS,  DTHU_TKC_NGAY, TONG_DTHU_PTM_NGAY, GEO_STATE_KEY, THANG)
    select to_char(MA_TB), PHANLOAI_NHOM, NGAY_INIT, LOAIKENH_DK_TTTB, MANV_DK_TTTB, TENNV_DK_TTTB, MATO_DK_TTTB, TENTO_DK_TTTB, MAPB_DK_TTTB, TENPB_DK_TTTB, GOICUOC, CHUKY_GOI, DTHU_GOI, ACC_INIT, KENH_BANGOI, ACC_BANGOI, LOAIKENH_DK_BANGOI, MANV_DK_BANGOI, TENNV_DK_BANGOI, MATO_DK_BANGOI, TENTO_DK_BANGOI, MAPB_DK_BANGOI, TENPB_DK_BANGOI, DTHU_HMM, DTHU_TKC, TONG_DTHU_PTM, ACC_GHINHAN, LOAIKENH_GHINHAN,  ploai, SYSDATE, DTHU_TKC_NGAY, TONG_DTHU_PTM_NGAY, GEO_STATE_KEY, THANG
    from PL5--ttkd_bct.va_ct_vnp_bris
    where  to_number(TO_CHAR(ngay_init, 'yyyymm')) = 202409;

    -- check trung` ma_tb
--                 select*
--                 from ttkdhcm_ktnv.TBL_VNP_BRIS
--                 where thang = 202409
--                     and ma_tb in ( select ma_tb
--                     from ttkdhcm_ktnv.TBL_VNP_BRIS
--                     where thang = 202409 group by ma_tb having count(ma_tb)>1);

        -- del accghi nhan null --> ko map dc kenh ban
                delete from ttkdhcm_ktnv.TBL_VNP_BRIS
                where thang = 202409
                and acc_ghinhan is null;
        -- del case trung ma_tb vi` nhieu goi_cuoc ->> chose the greatest one
               DELETE FROM ttkdhcm_ktnv.TBL_VNP_BRIS
                WHERE
                    thang = 202409
                    AND ROWID IN (
                        SELECT ROWID FROM (
                            SELECT
                                ROWID,
                                ROW_NUMBER() OVER (PARTITION BY ma_tb ORDER BY dthu_goi DESC) AS rn
                            FROM
                                ttkdhcm_ktnv.TBL_VNP_BRIS
                            WHERE
                                thang = 202409
                        )
                        WHERE rn > 1
                    );

--END



                select * from PL1_2024;
                select * from PL4_2024;

                select * from PL5 where thang = 202409;

                select thang,ma_tb,phanloai_nhom,dthu_tkc,rank() over (partition by thang,ma_tb order by dthu_tkc desc) rnk from ttkdhcm_ktnv.TBL_VNP_BRIS where thang between 202401 and 202403 and ma_tb = '84814397614';



                select * from PL1_monthly where thang = 202407;
                select * from PL4_monthly where thang = 202407;
               select* from PL5 where thang = 202409;

               select * from ttkdhcm_ktnv.TBL_VNP_BRIS where thang = 202409;

               select thang,count(*) from pL5 group by thang;

    SELECT * FROM ttkdhcm_ktnv.TBL_VNP_BRIS WHERE THANG = 202409;
    select * from PL5 where thang = 202409;


                
        
                
