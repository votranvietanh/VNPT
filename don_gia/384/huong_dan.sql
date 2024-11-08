BHOL: ap dung từ tháng 9
1- Cto P: loai ds card to post ra vi a Tuyền đã tính PTM
        select SOMAY 
        From TTKD_BSC.DT_PTM_VNP_202409
        where KIEU_LD = 'Chuyen C->P'
        ;
3- Post PTM thang n-1 khong gói đã chi 60k, thì tháng n mua gói không chi --> a Tuyền
        select SOMAY 
        From TTKD_BSC.DT_PTM_VNP_202409
        where LOAI_GOI = 'GOI KHONG KM'
4- Loại các tbao thang n-1 là U1500/U900 --> anh Tuyền
      --916
      
5- Loại thue bao lương tính (a Tuyền)
       select SOMAY 
        From TTKD_BSC.DT_PTM_VNP_202409
        WHERE GOI_LUONGTINH IS NOT NULL
      ;
2- Post --> Card: Khanh có thông  tin lý do huy chuyển tỉnh
        Select thang, kieu_ld, somay From khanhtdt_ttkd.CCBS_ID1896@TTKDDB Where thang = 202409 and kieu_ld = 'P -> C';
        Select thang, kieu_ld, somay From khanhtdt_ttkd.CCBS_ID1896_CT@TTKDDB Where thang = 202409;

 Nếu TB thuộc 'Gia hạn CKD/CKN' and NVOB tư vấn thực hiện nâng chu kỳ/nâng gói -->


                                                                      ----Nhap
                                                                      select * from manpn.bscc_import_goi_bris a
where a.thang = 202409 --and so_tb in (select '84'||SOTHUEBAO from ttkdhcm_ktnv.vnp_yeucau)
;
with raw_dt as (
    select * from manpn.bscc_import_goi_bris_p04 where LOAI_TB_THANG ='HH' and thang = 202409
)
select * from raw_dt
    where ACCS_MTHD_KEY in (select ACCS_MTHD_KEY from raw_dt group by ACCS_MTHD_KEY having count(ACCS_MTHD_KEY)>1 )
    order by ACCS_MTHD_KEY
--DOANH_THU_BAN_GOI/1.1
;
select *from ttkdhcm_ktnv.vnp_yeucau ;
    where to_char(NGAYHOAMANG,'yyyymm') =202410;

    select * from admin_hcm.nhanvien_onebss;
813168222
;
select * from ttkd_bsc.nhanvien where  nhanvien_id =303;
select USERNAME, USERXULY, decode(yeucau,1,'Ðiều chỉnh gói cước',2,'Hủy gói cước') from ttkdhcm_ktnv.vnp_yeucau ;
select * from ttkdhcm_ktnv.VNP_GOICUOC;

select a.*,b.* from manpn.bscc_import_goi_bris a
join ttkdhcm_ktnv.vnp_yeucau b on a.so_tb = '84'||b.sothuebao
where a.USER_KENH_BAN in (
                    select a.user_ccbs from ttkdhcm_ktnv.vnp_yeucau b
                    join ttkd_bsc.nhanvien a
                    on b.USERXULY = a.nhanvien_id
                    where
                    a.thang = 202410
            )
    and a.thang = 202409;
-- bảng OB CKD
select * from OB_CKD_ct WHERE SO_THUE_BAO ='834454233';
select * from OB_CKN_ct WHERE SO_TB='886035873';
select * from ob_bangoi_ct WHERE '84'||SO_THUE_BAO  IN (SELECT MA_TB FROM PL1_2024);
-- filter điều kiện chu_ky_goi <> null , nếu null tự check la` nó ko Bgoi' trog thang
--GOI_CUOC_DK là gói mua
select * from dgia_hienhuu_pl4;

select * from ob_hvc_ct;
SELECT * FROM ob_bangoi_ct;
select * from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY;

with ds_thuebao as (
        select ACCS_MTHD_KEY ma_tb, SERVICE_CODE ten_goi, P2_CHUKY chu_ky, TOT_RVN_PACKAGE dthu_goi, REGIS_DT ngay_kh, TRANS_TYPE loai_gd, LOAIHINH_TB, USER_CODE user_ban_goi
            , USER_NAME, CHANNEL_TYPE loai_kenh, CHANNEL_MEMBER thanhvien_kenh
            , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi, LOAI_HVC, REGIS_TYPE_GRP
        from dgia_hienhuu_pl4
        where LOAI_TB_THANG ='HH' and thang = 202409
                and REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT')
)
;
select * from dgia_hienhuu_pl4;
drop table DONGIA_DTHU_HIENHUU;

CREATE TABLE DONGIA_DTHU_HIENHUU AS
 select ACCS_MTHD_KEY ma_tb
 ,  CASE
        WHEN (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -2) AND LOAIHINH_TB = 'TT') --DANG TEST DANG T9, THANG 10 FIX 2->1
          OR (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -5) AND LOAIHINH_TB = 'TS')
        THEN 1
        ELSE 0
    END AS IS_TBHH

 ,TO_CHAR(TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS'),'YYYYMM') THANG_KH_SIM, SERVICE_CODE ten_goi, P2_CHUKY chu_ky, TOT_RVN_PACKAGE dthu_goi, REGIS_DT ngay_kh, REGIS_TYPE_GRP , TRANS_TYPE loai_gd, LOAIHINH_TB, USER_CODE user_ban_goi
    , USER_NAME, CHANNEL_TYPE loai_kenh, CHANNEL_MEMBER thanhvien_kenh
    , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi
      , LOAI_HVC,DECODE(LOAI_HVC,'HVC',25,'NOHVC',20) HESO,TOT_RVN_PACKAGE DTHU_TLDG, TOT_RVN_PACKAGE*DECODE(LOAI_HVC,'HVC',25,'NOHVC',20)/100 TIEN_THULAO
    ,  'PL04' nguon, TRANS_TYPE LOAI_GD_tldg
 from dgia_hienhuu_pl4
where LOAI_TB_THANG ='HH' and thang = 202409
        and REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT')
        and P2_CHUKY is not null --bỏ các gói ngày,se~ con` sót lại nhưững gói ngày như MI_YT10k nhưng ct để là ck tháng!
;
-----


Pending// tập gia hạn CKN -CKD

SELECT *
FROM (
    SELECT
        CASE
            WHEN (DOANHTHU_TRUOC_GIAHAN - DOANH_THU_DK < 0) AND MAGOI_TRUOC_OB IS NULL THEN 'BAN_GOI'
            WHEN (DOANHTHU_TRUOC_GIAHAN - DOANH_THU_DK > 0) AND MAGOI_TRUOC_OB IS NOT NULL THEN 'HA_GOI'
            WHEN (DOANHTHU_TRUOC_GIAHAN - DOANH_THU_DK < 0) AND MAGOI_TRUOC_OB IS NOT NULL THEN 'NANG_GOI'
            WHEN (
                CASE
                    WHEN CHU_KY_GOI2 = '0' THEN '0' -- Trường hợp 0
                    WHEN INSTR(CHU_KY_GOI2, 'T') > 0 THEN SUBSTR(CHU_KY_GOI2, 1, INSTR(CHU_KY_GOI2, 'T') - 1) -- Trường hợp 3T
                    WHEN INSTR(CHU_KY_GOI2, 'THÁNG') > 0 THEN SUBSTR(CHU_KY_GOI2, 1, INSTR(CHU_KY_GOI2, 'THÁNG') - 1) -- Trường hợp 3 THÁNG
                    ELSE NULL
                END
            ) > (
                CASE
                    WHEN CHU_KY_GOI = '0' THEN '0' -- Trường hợp 0
                    WHEN INSTR(CHU_KY_GOI, 'T') > 0 THEN SUBSTR(CHU_KY_GOI, 1, INSTR(CHU_KY_GOI, 'T') - 1) -- Trường hợp 3T
                    WHEN INSTR(CHU_KY_GOI, 'THÁNG') > 0 THEN SUBSTR(CHU_KY_GOI, 1, INSTR(CHU_KY_GOI, 'THÁNG') - 1) -- Trường hợp 3 THÁNG
                    ELSE NULL
                END
            )
            AND MAGOI_TRUOC_OB = MAGOI_DICHVU_MOI THEN 'NANG_CHU_KY_GOI'

            WHEN (
                CASE
                    WHEN CHU_KY_GOI2 = '0' THEN '0' -- Trường hợp 0
                    WHEN INSTR(CHU_KY_GOI2, 'T') > 0 THEN SUBSTR(CHU_KY_GOI2, 1, INSTR(CHU_KY_GOI2, 'T') - 1) -- Trường hợp 3T
                    WHEN INSTR(CHU_KY_GOI2, 'THÁNG') > 0 THEN SUBSTR(CHU_KY_GOI2, 1, INSTR(CHU_KY_GOI2, 'THÁNG') - 1) -- Trường hợp 3 THÁNG
                    ELSE NULL
                END
            ) < (
                CASE
                    WHEN CHU_KY_GOI = '0' THEN '0' -- Trường hợp 0
                    WHEN INSTR(CHU_KY_GOI, 'T') > 0 THEN SUBSTR(CHU_KY_GOI, 1, INSTR(CHU_KY_GOI, 'T') - 1) -- Trường hợp 3T
                    WHEN INSTR(CHU_KY_GOI, 'THÁNG') > 0 THEN SUBSTR(CHU_KY_GOI, 1, INSTR(CHU_KY_GOI, 'THÁNG') - 1) -- Trường hợp 3 THÁNG
                    ELSE NULL
                END
            )
                AND MAGOI_TRUOC_OB = MAGOI_DICHVU_MOI THEN 'HA_CHU_KY_GOI'

            WHEN (
                CASE
                    WHEN CHU_KY_GOI2 = '0' THEN '0' -- Trường hợp 0
                    WHEN INSTR(CHU_KY_GOI2, 'T') > 0 THEN SUBSTR(CHU_KY_GOI2, 1, INSTR(CHU_KY_GOI2, 'T') - 1) -- Trường hợp 3T
                    WHEN INSTR(CHU_KY_GOI2, 'THÁNG') > 0 THEN SUBSTR(CHU_KY_GOI2, 1, INSTR(CHU_KY_GOI2, 'THÁNG') - 1) -- Trường hợp 3 THÁNG
                    ELSE NULL
                END
            ) = (
                CASE
                    WHEN CHU_KY_GOI = '0' THEN '0' -- Trường hợp 0/-strong/-heart:>:o:-((:-h WHEN INSTR(CHU_KY_GOI, 'T') > 0 THEN SUBSTR(CHU_KY_GOI, 1, INSTR(CHU_KY_GOI, 'T') - 1) -- Trường hợp 3T
                    WHEN INSTR(CHU_KY_GOI, 'THÁNG') > 0 THEN SUBSTR(CHU_KY_GOI, 1, INSTR(CHU_KY_GOI, 'THÁNG') - 1) -- Trường hợp 3 THÁNG
                    ELSE NULL
                END
            )
                AND MAGOI_TRUOC_OB = MAGOI_DICHVU_MOI THEN 'GIA_HAN'
            ELSE 'GIAHAN'
        END AS loai_gd,
        ma_tb,
        MAGOI_TRUOC_OB,
        CHU_KY_GOI,
        DOANHTHU_TRUOC_GIAHAN,
        THOI_GIAN_OB,
        MAGOI_DICHVU_MOI,
        CHU_KY_GOI2,
        DOANH_THU_DK
    FROM (
        SELECT
            '84' || SO_THUE_BAO AS ma_tb,
            MAGOI_TRUOC_OB,
            CHU_KY_GOI,
            DOANHTHU_TRUOC_GIAHAN,
            TO_CHAR(THOI_GIAN_OB) AS THOI_GIAN_OB,
            MAGOI_DICHVU_MOI,
            CHU_KY_GOI2,
            DOANH_THU_DK
        FROM vietanhvh.ob_ckd_ct

        UNION ALL

        SELECT
            '84' || so_tb AS ma_tb,
            MA_GOI_TRUOC_OB,
            TO_CHAR(CHU_KY_GOI) AS CHU_KY_GOI,
            DOANH_THU_TRUOCGIAHAN,
            THOI_GIAN_TH_OB AS THOI_GIAN_OB,
            MA_GOI_DICHVU AS MAGOI_DICHVU_MOI,
            CHU_KY_GOI2,
            DOANH_THU_DK
        FROM vietanhvh.OB_CKN_ct
    )
)




---
insert into DONGIA_DTHU_HIENHUU ( MA_TB, USER_BAN_GOI
                                , MA_HRM
                                , TEN_GOI
                                , DTHU_GOI
                                , NGAY_KH
                                , IS_TBHH
                                , THANG_KH_SIM
                                , LOAIHINH_TB
                                , LOAI_HVC
                                ,DTHU_TLDG
                                ,HESO
                                , nguon)

with data as (
    SELECT '84'||so_thue_bao ma_tb,dtv
    ,ma_hrm,GOI_CUOC_DK ten_goi,DOANH_THU_DK , ngay_mo_dich_vu ngay_kich_goi
    FROM ob_bangoi_ct
)
,dm_goi as (
            select TEN_GOI, to_char(CHU_KY) CHU_KY
            from manpn.BSCC_INSERT_DM_KIT_BUNDLE
            where chu_ky >0
    union all
            select GOI_CUOC TEN_GOI, CHU_KY_THANG CHU_KY
            from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY
            where CHU_KY_THANG <>'N'

        )
Select a.*
     ,CASE
        WHEN (b.DATE_ENTER_ACTIVE < ADD_MONTHS(trunc(sysdate, 'mm'), -2) ) --DANG TEST DANG T9, THANG 10 FIX 2->1
        THEN 1
        ELSE 0
    END AS IS_TBHH
     ,to_char((b.DATE_ENTER_ACTIVE),'yyyymm') ngay_kh,'TT' LOAIHINH_TB
    , case when ma_tb in (select ma_tb  from ob_hvc_ct) then 'HCV'
        else 'NOHVC' end as LOAI_HVC,a.DOANH_THU_DK,20,'OB' nguon
From data a
Left join  CUOCVINA.tieudung_bts_202408@ttkddbbk2 b -- để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84
where  ten_goi in (select ten_goi from dm_goi)
         --tập này bị trùng ưu tiên chọn trong PL4 tại các cói MI_TK10A bị sai trong bangoi
        and a.ma_tb not in (select ma_tb from DONGIA_DTHU_HIENHUU where nguon ='PL04')
;
--
UPDATE DONGIA_DTHU_HIENHUU
set loai_gd = 'GIAHAN_OB'
    ,heso = 3
where
     loai_gd not in ('NANG_GOI','NANG_CHUKY') -- nếu trog file CKN/CKD thì tính theo PL4
    and ma_tb in (select ma_tb
                from (select '84' || so_thue_bao ma_tb
                      from OB_CKD_ct
                    union all
                      select '84' || so_tb
                      from OB_CKN_ct)
                )
 ;
--delete chu kỳ ngày
delete from DONGIA_DTHU_HIENHUU
where ten_goi in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang ='N')
;

  select * from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY a;
  select *  FROM DONGIA_DTHU_HIENHUU;

