CREATE TABLE ct_vnp_bris_202411
AS SELECT * FROM vietanhct_vnp_bris WHERE 1 = 0

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
    d.ma_tb, d.ngay_init, d.loaikenh_dk_tttb, d.MANV_DK_TTTB, d.TENNV_DK_TTTB,
    d.ACC_INIT, d.KENH_BANGOI, d.ACC_BANGOI, d.LOAIKENH_DK_BANGOI,
    d.MANV_DK_BANGOI, d.TENNV_DK_BANGOI, d.DTHU_HMM, d.DTHU_TKC_ngay, d.geo_state_key,
    d.ngay_ins, d.thang, d.goicuoc, d.chuky_goi, d.dthu_goi,
    d.MATO_DK_TTTB, d.TENTO_DK_TTTB, d.MAPB_DK_TTTB, d.TENPB_DK_TTTB, d.acc_ghinhan,
    d.phanloai_nhom, d.MATO_DK_BANGOI, d.TENTO_DK_BANGOI, d.MAPB_DK_BANGOI, d.TENPB_DK_BANGOI
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

rollback
update ct_vnp_bris_202411
set dthu_tkc = (ROUND(dthu_goi/1.1/chuky_goi,0))


update ct_vnp_bris_202411
set tong_dthu_ptm = (dthu_hmm + dthu_tkc)

UPDATE ct_vnp_bris_202411
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
