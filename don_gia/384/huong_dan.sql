--list table import:

--USER CỦA pbh onL KO CÓ TRONG DM KENH CHI pHUONG GUI.
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
use Bảng tiêu dùng để tìm ngày kích sim cuả tập STB:
vd tháng 10 bangoi có 15 STB sau khi quét qua tieudung thang 9 thì exitst 10 STB -> dung` DATE_ENTER_ACTIVE
con` lai 5 STB nay` 95% ,3% la C2P trong thang 9 -> se ko tinh don gia nen ko can tim`
                        2% là gói mua thang 6 xong giahan nen T9 ko co ? ->  hoho GIAHAN auto = PTM :)) --> flag is_HH = 1
                                                                                     co TS la cook



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
select *from ttkdhcm_ktnv.vnp_yeucau
    where to_char(NGAYHOAMANG,'yyyymm') =202410;


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
select count(*) from dgia_hienhuu_pl4;
select * from DONGIA_DTHU_HIENHUU;
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
select count(*) from ds_thuebao
;
select * from dgia_hienhuu_pl4 where ACCS_MTHD_KEY= '84329665567';
drop table DONGIA_DTHU_HIENHUU_202410;
select count(ma_tb) from DONGIA_DTHU_HIENHUU_202410;

---START
CREATE TABLE DONGIA_DTHU_HIENHUU_202410 AS
 select ACCS_MTHD_KEY ma_tb
 ,  CASE
        WHEN (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -2) AND LOAIHINH_TB = 'TT')
          OR (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -6) AND LOAIHINH_TB = 'TS')
        THEN 1
        ELSE 0
    END AS IS_TBHH

 ,TO_CHAR(TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS'),'YYYYMM') THANG_KH_SIM, SERVICE_CODE ten_goi, P2_CHUKY chu_ky, TOT_RVN_PACKAGE dthu_goi, REGIS_DT ngay_kh, REGIS_TYPE_GRP , TRANS_TYPE loai_gd, LOAIHINH_TB, USER_CODE user_ban_goi
    , USER_NAME, CHANNEL_TYPE loai_kenh, CHANNEL_MEMBER thanhvien_kenh
    , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi
      , LOAI_HVC,DECODE(LOAI_HVC,'HVC',25,'NOHVC',20) HESO,TOT_RVN_PACKAGE DTHU_TLDG, TOT_RVN_PACKAGE*DECODE(LOAI_HVC,'HVC',25,'NOHVC',20)/100 TIEN_THULAO
    ,  'BRIS_P04' nguon, TRANS_TYPE LOAI_GD_tldg
 from bscc_import_goi_bris_p04
where LOAI_TB_THANG ='HH' and thang = 202410
        and (REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT') OR USER_CODE NOT IN ('SYSTEM','SMS','sms','ccbs_vnp','crosssell_vnp','4G-SPR','1543|TDL_CTNET','1543|TELESALE'))
        and P2_CHUKY is not null --bỏ các gói ngày,se~ con` sót lại nhưững gói ngày như MI_YT10k nhưng ct để là ck tháng!
;

delete DONGIA_DTHU_HIENHUU_202410
where
     ma_tb in (select ma_tb
                from (select '84' || so_thue_bao ma_tb
                      from OB_CKD_ct
                      where thang = 202410
                    union all
                      select '84' || so_tb
                      from OB_CKN_ct
                      where thang = 202410
                      )
                )
and loai_gd not in('DANGKY','NANG_GOI','NANG_CHUKY')
 ;
--OK// INSERT tập gia hạn CKN -CKD
INSERT INTO DONGIA_DTHU_HIENHUU_202410(LOAI_GD,IS_TBHH,ma_tb,USER_BAN_GOI,thang_kh_sim,ngay_kh,ten_goi,chu_ky,dthu_goi,DTHU_TLDG,LOAIHINH_TB,LOAI_HVC,nguon)

SELECT a.LOAI_GD, 1 IS_TBHH,a.MA_TB,a.USER_DTV
        ,to_number(to_char(b.DATE_ENTER_ACTIVE,'yyyymm'))              DATE_ENTER_ACTIVE
        , to_date(a.NGAYMO_DICHVU,'dd/mm/yyyy hh24:mi:ss')  NGAYMO_DICHVU
     , a.MAGOI_DICHVU_MOI,
        CASE
        WHEN REGEXP_LIKE(a.CHU_KY_GOI2, '^\d+T$') THEN TO_NUMBER(REGEXP_SUBSTR(a.CHU_KY_GOI2, '^\d+'))
        WHEN REGEXP_LIKE(a.CHU_KY_GOI2, '^\d+\s*tháng$') THEN TO_NUMBER(REGEXP_SUBSTR(a.CHU_KY_GOI2, '^\d+'))
        ELSE NULL
    END AS CHU_KY_GOI2,
       a.DOANH_THU_DK,a.DOANH_THU_DK,'TT' -- có ca CTP nma so it, truong hop hoi se tra CCOS
     , case when a.ma_tb in (select ma_tb  from ob_hvc_ct where thang = 202410) then 'HCV'
        else 'NOHVC' end as LOAI_HVC
,'CKN_CKD' nguon

FROM (
    SELECT
        CASE
            WHEN (DOANHTHU_TRUOC_GIAHAN - DOANH_THU_DK < 0) AND MAGOI_TRUOC_OB IS NULL THEN 'GIAHAN'
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
            AND MAGOI_TRUOC_OB = MAGOI_DICHVU_MOI THEN 'NANG_CHUKY'

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
                AND MAGOI_TRUOC_OB = MAGOI_DICHVU_MOI THEN 'HA_CHUKY'

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
        ma_tb,USER_DTV,
        MAGOI_TRUOC_OB,
        CHU_KY_GOI,
        DOANHTHU_TRUOC_GIAHAN,
        NGAYMO_DICHVU,
        MAGOI_DICHVU_MOI,
        CHU_KY_GOI2,
        DOANH_THU_DK
    FROM (
        SELECT
            '84' || SO_THUE_BAO AS ma_tb,
            MAGOI_TRUOC_OB,USER_DTV,
            CHU_KY_GOI,
            DOANHTHU_TRUOC_GIAHAN,
            TO_CHAR(NGAYMO_DICHVU) AS NGAYMO_DICHVU,
            MAGOI_DICHVU_MOI,
            CHU_KY_GOI2,
            DOANH_THU_DK
        FROM vietanhvh.ob_ckd_ct
        where thang = 202410

        UNION ALL

        SELECT
            '84' || so_tb AS ma_tb,
            MA_GOI_TRUOC_OB,USER_DTV,
            TO_CHAR(CHU_KY_GOI) AS CHU_KY_GOI,
            DOANH_THU_TRUOCGIAHAN,
            NGAY_MO_DICHVU AS NGAY_MO_DICHVU,
            MA_GOI_DICHVU AS MAGOI_DICHVU_MOI,
            CHU_KY_GOI2,
            DOANH_THU_DK
        FROM vietanhvh.OB_CKN_ct
        where thang = 202410
    )
) a
left join  CUOCVINA.tieudung_bts_202409@ttkddbbk2 b --edit tieudung để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84
where a.ma_tb  not in (select ma_tb from DONGIA_DTHU_HIENHUU_202410) --edit ten bang theo thang

;


---
insert into DONGIA_DTHU_HIENHUU_202410 ( MA_TB, USER_BAN_GOI
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
                                , nguon
                                ,loai_gd)

with data as (
    SELECT '84'||so_thue_bao ma_tb,dtv
    ,ma_hrm,GOI_CUOC_DK ten_goi,DOANH_THU_DK , ngay_mo_dich_vu ngay_kich_goi
    FROM ob_bangoi_ct
    where thang= 202410
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
        else 'NOHVC' end as LOAI_HVC,a.DOANH_THU_DK,20,'OB_BG' nguon
    ,'DANGKY' loai_gd
From data a
Left join  CUOCVINA.tieudung_bts_202409@ttkddbbk2 b -- edit để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84
where  ten_goi in (select ten_goi from dm_goi)
         --tập này bị trùng ưu tiên chọn trong PL4 tại các cói MI_TK10A bị sai trong bangoi
        and a.ma_tb not in (select ma_tb from DONGIA_DTHU_HIENHUU_202410 where nguon ='BRIS_P04') --edit
;
--

-- tạo bảng lọc 1 dòng loại luôn chu ky ngày,Loại trừ các TH a Tuyen,a Khann
drop table S_DONGIA_DTHU_HIENHUU_202410;
        create table S_DONGIA_DTHU_HIENHUU_202410 as
        with src_data as (select 202410 thang,
                            a.MA_TB, IS_TBHH, a.THANG_KH_SIM, a.TEN_GOI, a.CHU_KY, a.DTHU_GOI, a.NGAY_KH,
                            a.REGIS_TYPE_GRP, a.LOAI_GD, a.LOAIHINH_TB, a.USER_BAN_GOI, a.USER_NAME, a.LOAI_KENH,
                            a.THANHVIEN_KENH, a.MA_HRM, a.TEN_NV
                            , (select x.ma_vtcv from ttkd_bsc.nhanvien x where x.thang= 202410 and a.ma_hrm = x.ma_nv) ma_vtcv
                            , (select x.ma_pb from ttkd_bsc.nhanvien x where x.thang= 202410 and a.ma_hrm = x.ma_nv) ma_pb
                            , (select x.ten_pb from ttkd_bsc.nhanvien x where x.thang= 202410 and a.ma_hrm = x.ma_nv) ten_pb
                            ,a.CONG_CU_BAN_GOI, a.LOAI_HVC, a.HESO, a.DTHU_TLDG, a.TIEN_THULAO, a.NGUON, a.LOAI_GD_TLDG
            ,row_number() over (partition by a.ma_tb order by a.USER_BAN_GOI ,a.dthu_goi desc) rnk
             from DONGIA_DTHU_HIENHUU_202410 a
        )
        , r_data as ( select * from src_data where rnk = 1)
           --ds stb loai_tru
        , prevent_data as (select SOMAY
                           From TTKD_BSC.DT_PTM_VNP_202409
                           where KIEU_LD = 'Chuyen C->P' -- C->P
                              or LOAI_GOI = 'GOI KHONG KM' --Post PTM thang n-1 khong gói đã chi 60k, thì tháng n mua gói không chi
                              or GOI_LUONGTINH IS NOT NULL
                              or (loai_tb = 'EZPOST'
                                   and (loai_goi like '%1500%'
                                   or loai_goi like '%900%')
                               )
                        union all
                           Select somay --P-->C
                           From khanhtdt_ttkd.CCBS_ID1896@TTKDDB
                           Where thang = 202409
                             and kieu_ld = 'P -> C'
                        union all
                           Select somay -- Chuyen tinh khac
                           From khanhtdt_ttkd.CCBS_ID1896_CT@TTKDDB
                           Where thang = 202409
                           )

        select *
        from r_data
        where ten_goi  not in (select goi_cuoc from manpn.BSCC_INSERT_DM_GOICUOC_PHANKY where chu_ky_thang ='N')
            and ma_tb not in(select SOMAY From prevent_data)
        ;

select * from S_DONGIA_DTHU_HIENHUU_202410;
--update ma_hrm con thieu:
        update S_DONGIA_DTHU_HIENHUU_202410 a
        set ma_hrm = (select (b.ma_nv) from ttkd_bsc.nhanvien b where b.thang = 202410 and b.ma_nv = a.USER_BAN_GOI) -- tháng 9 ttvt_ctv086203_hcm đag bị double nên dùng max
        where USER_BAN_GOI like 'CTV%'
            or  USER_BAN_GOI like 'VNP%'
        ;
      update S_DONGIA_DTHU_HIENHUU_202410 a
        set ma_hrm = (select (b.ma_nv) from ttkd_bsc.nhanvien b where b.thang = 202410 and b.USER_CCBS = a.USER_BAN_GOI) -- tháng 9 ttvt_ctv086203_hcm đag bị double nên dùng max
        where ma_hrm is null
        ;
        update S_DONGIA_DTHU_HIENHUU_202410 a
        set ma_hrm = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202410 and b.USER_CCOS = a.USER_BAN_GOI)
        where ma_hrm is null
        ;
        update S_DONGIA_DTHU_HIENHUU_202410 a
        SET ma_hrm = (SELECT c.ma_nv
                     FROM manpn.bscc_import_kenh_noibo b
                     JOIN ttkd_bsc.nhanvien c
                       ON c.thang = 202410
                      AND SUBSTR(C.MAIL_VNPT, 1, INSTR(C.MAIL_VNPT, '@') - 1) = LOWER(
                           CASE
                              WHEN INSTR(b.MA, '_') > 0 THEN SUBSTR(b.MA, 1, INSTR(b.MA, '_') - 1)
                              ELSE b.MA
                           END
                       )
                    WHERE b.thang = 202410
                      AND b.SO_ELOAD = a.USER_BAN_GOI
                  )
        WHERE ma_hrm IS NULL;

update S_DONGIA_DTHU_HIENHUU_202410
    set (ten_nv,TEN_PB, MA_VTCV, MA_PB) = (select x.ten_nv,x.TEN_PB, x.MA_VTCV, x.MA_PB from ttkd_bsc.nhanvien x where ma_hrm =ma_nv and thang = 202410)
;
--ADMIN kich giup: user GDV không được quyền tác động bán gói:
alter table S_DONGIA_DTHU_HIENHUU_202410
add user_tam varchar2(100);
update S_DONGIA_DTHU_HIENHUU_202410
set user_tam =USER_BAN_GOI;
-- create index inx_dg on S_DONGIA_DTHU_HIENHUU_202410(ma_tb);
-- drop index inx_dg;
MERGE INTO S_DONGIA_DTHU_HIENHUU_202410 b
USING (
    SELECT
        b.LOAIHINH_TB,
        b.ma_tb,
        REPLACE(b.TEN_GOI, 'Gói ', '') AS ten_goi_tldg,
        COALESCE(d.tengoicuoc, '') || ' ' || COALESCE(e.tengoicuoc, '') AS ten_goicuoc,
        a.ngayxuly,
        TO_CHAR(a.ngayxuly, 'yyyymm') AS aaa,
        a.NGAYCAPNHAT,
        b.ngay_kh AS ngay_kh_goi,
        x.ma_nv,
        a.NV_YEUCAU,
        a.yeucau
    FROM
        ttkdhcm_ktnv.vnp_yeucau a
    JOIN
        S_DONGIA_DTHU_HIENHUU_202410 b ON '84' || a.sothuebao = b.ma_tb
    LEFT JOIN
        ttkdhcm_ktnv.VNP_GOICUOC d ON a.GOICUOCDENGHI = d.idgoicuoc
    LEFT JOIN
        ttkdhcm_ktnv.VNP_GOICUOC e ON a.GOICUOCCAMKET = e.idgoicuoc
    LEFT JOIN
        ttkd_bsc.nhanvien x ON x.thang = 202410 AND a.userxuly = x.nhanvien_id
    WHERE
        TO_CHAR(a.ngayxuly, 'yyyymm') IN ('202410', '202409')
        AND a.ngayxuly <= b.NGAY_KH
        AND a.hoantat = 1
        AND a.yeucau = 1
        AND REPLACE(b.TEN_GOI, 'Gói ', '') = COALESCE(d.tengoicuoc, '') || ' ' || COALESCE(e.tengoicuoc, '')
) src
ON (b.ma_tb = src.ma_tb)
WHEN MATCHED THEN
    UPDATE SET b.USER_BAN_GOI = src.NV_YEUCAU;


;
;

---Tinh tiennnnnn noVat./1.1
update S_DONGIA_DTHU_HIENHUU_202410
set heso = 0;
update S_DONGIA_DTHU_HIENHUU_202410
set heso = case when loai_gd in ('NANG_GOI','DANGKY','NANG_CHUKY') and LOAI_HVC ='HVC' then 25
                when loai_gd in ('NANG_GOI','DANGKY','NANG_CHUKY') and LOAI_HVC ='NOHVC' then 20
                when loai_gd in ('GIAHAN','GIAHAN_OB','GIAHAN_TUDONG')  then 3
                when loai_gd in('HA_CHUKY','HA_GOI') then 0
            else 0 --HA_GOI, HA_CHUKY
end
where IS_TBHH = 1
;

update S_DONGIA_DTHU_HIENHUU_202410
set TIEN_THULAO = round((DTHU_TLDG/1.1)*heso/100*IS_TBHH)
;


select distinct  loai_gd from  S_DONGIA_DTHU_HIENHUU ;
select *from S_DONGIA_DTHU_HIENHUU ;where  loai_gd is null;

;

  select * from manpn.BSCC_INSERT_DM_KIT_BUNDLE a;

  select *  FROM DONGIA_DTHU_HIENHUU;

WITH raa AS (
    SELECT
        b.LOAIHINH_TB,
        b.ma_tb
        ,  d.tengoicuoc ||' '|| e.tengoicuoc  AS ten_goi_tldg
       ,
        a.ngayxuly,
        TO_CHAR(a.ngayxuly, 'yyyymm') AS aaa,
        a.NGAYCAPNHAT,
        b.ngay_kh AS ngay_kh_goi,
        x.ma_nv,
        a.NV_YEUCAU,
        a.yeucau
        ,row_number () over (partition by b.ma_tb order by a.ngayxuly desc) rnk
    FROM
        ttkdhcm_ktnv.vnp_yeucau a
    JOIN
        S_DONGIA_DTHU_HIENHUU_202410 b ON '84' || sothuebao = b.ma_tb
    LEFT JOIN
        ttkdhcm_ktnv.VNP_GOICUOC d ON a.GOICUOCDENGHI = d.idgoicuoc
    LEFT JOIN
        ttkdhcm_ktnv.VNP_GOICUOC e ON a.GOICUOCCAMKET = e.idgoicuoc
    LEFT JOIN
        ttkd_bsc.nhanvien x ON x.thang = 202410 AND a.userxuly = x.nhanvien_id
    WHERE
        TO_CHAR(a.ngayxuly, 'yyyymm') IN ('202410', '202409')
        AND a.ngayxuly <= b.NGAY_KH
        AND a.hoantat = 1
        AND a.yeucau = 1
    --max ngayxuly
--     and REPLACE(b.TEN_GOI, 'Gói ', '') = COALESCE(d.tengoicuoc, '') ||' '|| COALESCE(e.tengoicuoc, '')
)
, final_data as (
    select * from raa where rnk = 1
)
SELECT *
FROM final_data
where  ma_tb in (SELECT ma_tb
FROM final_data
group by ma_tb having count(ma_tb)>1)
;
