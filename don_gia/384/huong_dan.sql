--list table import:
trong P04 nếu 2 gói cùng dky 1 tháng thì nó tự ghlafala DANGKY nhung thuc ra goi dau tien la Dangky con goi thu 2 la gia han
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
                                                                                ;

ob_hvc_ct
ob_hvc2_ct
ob_bangoi_ct
ob_ckn_ct
ob_ckd_ct
update ob_ckd_ct
            set thang = 202412
            where thang is null;
select* from ob_ckd_ct where thang = 202412;




with raw_dt as (
    select * from manpn.bscc_import_goi_bris_p04 where LOAI_TB_THANG ='HH' and thang = 202409
)
select * from raw_dt
    where ACCS_MTHD_KEY in (select ACCS_MTHD_KEY from raw_dt group by ACCS_MTHD_KEY having count(ACCS_MTHD_KEY)>1 )
    order by ACCS_MTHD_KEY
--DOANH_THU_BAN_GOI/1.1
;
select *from ttkdhcm_ktnv.vnp_yeucau where sothuebao ='833577251';
    where to_char(NGAYHOAMANG,'yyyymm') =202412;


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
                    a.thang = 202412
            )
    and a.thang = 202412;
-- bảng OB CKD
select * from OB_CKD_ct WHERE SO_THUE_BAO ='834454233';
select * from OB_CKN_ct WHERE SO_TB='886035873';
select * from ob_bangoi_ct WHERE '84'||SO_THUE_BAO  IN (SELECT MA_TB FROM PL1_2024);
-- filter điều kiện chu_ky_goi <> null , nếu null tự check la` nó ko Bgoi' trog thang
--GOI_CUOC_DK là gói mua
select count(*) from dgia_hienhuu_pl4;
select * from DONGIA_DTHU_HIENHUU_202412 where ma_tb ='84948966139';
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
drop table DONGIA_DTHU_HIENHUU_202412;
select * from DONGIA_DTHU_HIENHUU_202412 ;
select * from DONGIA_DTHU_HIENHUU_202412 where loai_gd ='DANGKY' and ma_tb in (select ma_tb
                                                                               from (select '84' || so_thue_bao ma_tb
                                                                                     from OB_CKD_ct
                                                                                     where thang = 202412
                                                                                     union all
                                                                                     select '84' || so_tb ma_tb
                                                                                     from OB_CKN_ct
                                                                                     where thang = 202412
                                                                                  )where ma_tb='84843409496');








drop table DONGIA_DTHU_HIENHUU_202412;
---START
CREATE TABLE DONGIA_DTHU_HIENHUU_202412 AS
 select ACCS_MTHD_KEY ma_tb
             ,  CASE
                    WHEN (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -1) AND LOAIHINH_TB = 'TT') --1
                      OR (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -6) AND LOAIHINH_TB = 'TS') --6
                    THEN 1
                    ELSE 0
                END AS IS_TBHH

             ,TO_CHAR(TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS'),'YYYYMM') THANG_KH_SIM, SERVICE_CODE ten_goi, P2_CHUKY chu_ky, TOT_RVN_PACKAGE dthu_goi, REGIS_DT ngay_kh, REGIS_TYPE_GRP , TRANS_TYPE loai_gd, LOAIHINH_TB, USER_CODE user_ban_goi
                , USER_NAME,RESELLER_NAME pbh, CHANNEL_TYPE loai_kenh, CHANNEL_MEMBER thanhvien_kenh
                , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi
                  , LOAI_HVC,DECODE(LOAI_HVC,'HVC',25,'NOHVC',20) HESO,TOT_RVN_PACKAGE DTHU_TLDG, TOT_RVN_PACKAGE*DECODE(LOAI_HVC,'HVC',25,'NOHVC',20)/100 TIEN_THULAO
                ,  CAST('BRIS_P04' AS NVARCHAR2(30)) nguon, TRANS_TYPE LOAI_GD_tldg
 from MANPN.bscc_import_goi_bris_p04 a
 LEFT JOIN ttkd_bsc.a_vcc_ccbs b ON a.ACCS_MTHD_KEY = b.somay
where LOAI_TB_THANG ='HH' and thang = 202412
        AND b.somay IS NULL -- loai cac STB VCC
        and (REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT')) -- loai tru cac user_code bi null
        and TRANS_TYPE  in ('DANGKY','NANG_GOI','NANG_CHUKY','GIAHAN')--chi lay cac tieu chi tren o PL4,13/12 them dieu kien GIAHANde co record cho PTTT
--     and SERVICE_CODE not in (SELECT goi_cuoc FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' )
        and USER_CODE NOT IN ('SYSTEM','SMS','sms','ccbs_vnp','crosssell_vnp','4G-SPR','1543|TDL_CTNET','1543|TELESALE')
        and P2_CHUKY is not null --bỏ các gói ngày,se~ con` sót lại nhưững gói ngày như MI_YT10k nhưng ct để là ck tháng!
;
--  84853545129 trong P04 2 goi giong nhau dangky,giahan PL04 de dangky het
--t11: 84903941945
MERGE INTO DONGIA_DTHU_HIENHUU_202412 tgt
USING (
    SELECT
        t1.ma_tb,
        t1.ngay_kh,
        t2.ngay_kh AS ngay_kh_muon
    FROM DONGIA_DTHU_HIENHUU_202412 t1
    JOIN DONGIA_DTHU_HIENHUU_202412 t2
        ON t1.ten_goi = t2.ten_goi
        AND t1.ma_tb=t2.ma_tb
        AND t1.DTHU_GOI = t2.DTHU_GOI
        AND t1.nguon = 'BRIS_P04'
        AND t2.nguon = 'BRIS_P04'
        AND t1.ngay_kh < t2.ngay_kh -- chỉ lấy các bản ghi có ngày_kh muộn hơn
) src
ON (tgt.ma_tb = src.ma_tb AND tgt.nguon = 'BRIS_P04' and src.ngay_kh_muon = tgt.ngay_kh)
WHEN MATCHED THEN
    UPDATE SET tgt.loai_gd = 'GIAHAN';
--INSERT Ghi nhận doanh thu nâng chu kỳ các thuê bao trả sau cho các Phòng thực hiện tháng 10, 11 mà trên P04 Bris đang ghi nhận loại GD là "Hạ chu kỳ".
INSERT INTO DONGIA_DTHU_HIENHUU_202412
     select ACCS_MTHD_KEY ma_tb
             ,  CASE
                    WHEN (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -1) AND LOAIHINH_TB = 'TT') --1
                      OR (TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS') < ADD_MONTHS(trunc(sysdate, 'mm'), -6) AND LOAIHINH_TB = 'TS') --6
                    THEN 1
                    ELSE 0
                END AS IS_TBHH

             ,TO_CHAR(TO_DATE(ACTVTN_DT,'DD/MM/YYYY HH24:MI:SS'),'YYYYMM') THANG_KH_SIM, SERVICE_CODE ten_goi, P2_CHUKY chu_ky, TOT_RVN_PACKAGE dthu_goi, REGIS_DT ngay_kh, REGIS_TYPE_GRP , 'NANG_CHUKY' loai_gd, LOAIHINH_TB, USER_CODE user_ban_goi
                , USER_NAME,RESELLER_NAME pbh, CHANNEL_TYPE loai_kenh, CHANNEL_MEMBER thanhvien_kenh
                , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi
                  , LOAI_HVC,DECODE(LOAI_HVC,'HVC',25,'NOHVC',20) HESO,TOT_RVN_PACKAGE DTHU_TLDG, TOT_RVN_PACKAGE*DECODE(LOAI_HVC,'HVC',25,'NOHVC',20)/100 TIEN_THULAO
                ,  'BRIS_P04_ts' nguon, 'NANG_CHUKY' LOAI_GD_tldg
 from MANPN.bscc_import_goi_bris_p04 a
 LEFT JOIN ttkd_bsc.a_vcc_ccbs b ON a.ACCS_MTHD_KEY = b.somay
where LOAI_TB_THANG ='HH' and thang = 202412
        and LOAIHINH_TB ='TS' --#
        AND TRANS_TYPE ='HA_GOI'
        AND b.somay IS NULL -- loai cac STB VCC
        and (REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT')) -- loai tru cac user_code bi null
        and USER_CODE NOT IN ('SYSTEM','SMS','sms','ccbs_vnp','crosssell_vnp','4G-SPR','1543|TDL_CTNET','1543|TELESALE')
        and P2_CHUKY is not null --bỏ các gói ngày,se~ con` sót lại nhưững gói ngày như MI_YT10k nhưng ct để là ck tháng!
;


-- 4/12 da comment --> sua thanh not exist cho gon tai PL chi thieu, chu ko sai nen insert vo lun
delete DONGIA_DTHU_HIENHUU_202412
where
     ma_tb in (select ma_tb
               from (
                     select '84' || so_thue_bao ma_tb,NGAY_MO_DICH_VU ngay_kh
                     from ob_bangoi_ct
                     where thang = 202412
--                      union all
--                      select '84' || MA_TB,to_date(NGAY_KH,'dd/mm/yyyy hh24:mi:Ss') change_date
--                      from ob_hvc_ct
--                      where thang = 202412
                    union all
                     select '84' || MA_TB , TO_DATE(REPLACE(NGAY_SD, '.0', ''), 'yyyy-mm-dd hh24:mi:ss')
                     from ob_hvc2_ct
                     where DTHU_GOI> 20000 and thang = 202412
                     )

                 WHERE TRUNC(ngay_kh) = TRUNC(DONGIA_DTHU_HIENHUU_202412.ngay_kh)
               )
 ;

---HVC+BANGOI: sua bang tieudung
insert into DONGIA_DTHU_HIENHUU_202412 ( MA_TB, USER_BAN_GOI
                                , MA_HRM
                                , TEN_GOI
                                , DTHU_GOI
                                , NGAY_KH
                                , LOAI_HVC
                                , IS_TBHH
                                , THANG_KH_SIM
                                , LOAIHINH_TB
                                ,DTHU_TLDG
                                , nguon
                                ,loai_gd)

with data as (
    SELECT '84'||so_thue_bao ma_tb,dtv
    ,ma_hrm,GOI_CUOC_DK ten_goi,to_number(DOANH_THU_DK) DOANH_THU_DK , to_date(to_char(ngay_mo_dich_vu,'dd-mm-yyyy'),'dd-mm-yyyy') ngay_kich_goi,'NOHVC' loai_HVC
    FROM ob_bangoi_ct
    where thang= 202412
-- union all
--         select '84'||MA_TB, DTV, MA_HRM,  GOICUOC_DANGKY, DTHU_DKY_USER,
--               to_date(NGAY_KH,'DD/MM/YYYY HH24:MI:SS'),'HVC'loai_HVC
--     from ob_hvc_ct
--     where thang = 202412
)

Select a.*
     ,CASE
         WHEN (b.DATE_ENTER_ACTIVE < ADD_MONTHS(TRUNC(SYSDATE, 'mm'), -1))
             THEN 1
          WHEN b.DATE_ENTER_ACTIVE is null then 0
        ELSE 0
    END AS IS_TBHH
     ,(to_char((b.DATE_ENTER_ACTIVE),'yyyymm')) ngay_kh,'TT' LOAIHINH_TB
    ,a.DOANH_THU_DK,'OB_BG' nguon
    ,'DANGKY' loai_gd
From data a
Left join  CUOCVINA.tieudung_bts_202411@ttkddbbk2 b -- edit để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84
;
insert into DONGIA_DTHU_HIENHUU_202412 ( MA_TB, USER_BAN_GOI
                                , MA_HRM
                                , TEN_GOI
                                , DTHU_GOI
                                , NGAY_KH
                                , LOAI_HVC
                                , IS_TBHH
                                , THANG_KH_SIM
                                , LOAIHINH_TB
                                ,DTHU_TLDG
                                , nguon
                                ,loai_gd)
select '84'||ma_tb,USER_DK,MA_NV,TEN_GOI,DTHU_GOI,TO_DATE(REPLACE(NGAY_SD, '.0', ''), 'yyyy-mm-dd hh24:mi:ss'),'HVC'
 ,CASE
         WHEN (b.DATE_ENTER_ACTIVE < ADD_MONTHS(TRUNC(SYSDATE, 'mm'), -1))
             THEN 1
          WHEN b.DATE_ENTER_ACTIVE is null then 0
        ELSE 0
    END AS IS_TBHH
            ,to_number(to_char(b.DATE_ENTER_ACTIVE,'yyyymm'))              DATE_ENTER_ACTIVE

    ,(select x.LOAIHINH_TB from manpn.bscc_import_goi_bris_p04 x where x.thang = 202412 and x.ACCS_MTHD_KEY = '84'||a.ma_tb group by x.LOAIHINH_TB)
,DTHU_GOI,'HVC_moi', case when LOAI_GD in('Gia hạn CKD','Gia hạn CKN') then 'GIAHAN'
                                                when LOAI_GD='Bán gói tập không gói' then 'DANGKY'end
from OB_HVC2_CT a
Left join  CUOCVINA.tieudung_bts_202411@ttkddbbk2 b -- edit để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id
where a.DTHU_GOI>24000
;

delete DONGIA_DTHU_HIENHUU_202412
where
     ma_tb in (select ma_tb
               from (select '84' || so_thue_bao ma_tb,NGAYMO_DICHVU ngay_kh
                     from OB_CKD_ct
                     where thang = 202412
                     union all
                     select '84' || so_tb,to_date(NGAY_MO_DICHVU,'dd/mm/yyyy hh24:mi:ss')
                     from OB_CKN_ct
                     where thang = 202412
                     )
                WHERE TRUNC(ngay_kh) = TRUNC(DONGIA_DTHU_HIENHUU_202412.ngay_kh)
               )
 ;


--OK// INSERT tập gia hạn CKN -CKD
INSERT INTO DONGIA_DTHU_HIENHUU_202412(LOAI_GD,IS_TBHH,ma_tb,USER_BAN_GOI,thang_kh_sim,ngay_kh,ten_goi,chu_ky,dthu_goi,DTHU_TLDG,LOAIHINH_TB,LOAI_HVC,nguon)

SELECT a.LOAI_GD, CASE
         WHEN (b.DATE_ENTER_ACTIVE < ADD_MONTHS(TRUNC(SYSDATE, 'mm'), -1))
             THEN 1
        WHEN b.DATE_ENTER_ACTIVE is null then 0
        ELSE 0
    END AS IS_TBHH,a.MA_TB,a.USER_DTV
        ,to_number(to_char(b.DATE_ENTER_ACTIVE,'yyyymm'))              DATE_ENTER_ACTIVE
        , to_date(a.NGAYMO_DICHVU,'dd/mm/yyyy hh24:mi:ss')  NGAYMO_DICHVU
     , a.MAGOI_DICHVU_MOI,
        CASE
        WHEN REGEXP_LIKE(a.CHU_KY_GOI2, '^\d+T$') THEN TO_NUMBER(REGEXP_SUBSTR(a.CHU_KY_GOI2, '^\d+'))
        WHEN REGEXP_LIKE(a.CHU_KY_GOI2, '^\d+\s*tháng$') THEN TO_NUMBER(REGEXP_SUBSTR(a.CHU_KY_GOI2, '^\d+'))
        ELSE NULL
    END AS CHU_KY_GOI2,
       a.DOANH_THU_DK,a.DOANH_THU_DK,'TT' -- có ca CTP nma so it, truong hop hoi se tra CCOS
     , case when a.ma_tb in (select ma_tb  from ob_hvc_ct where thang = 202412) then 'HCV'
        else 'NOHVC' end as LOAI_HVC
,'CKN_CKD' nguon

FROM (
    SELECT
            case
                when magoi_truoc_ob like '%_0K' and DOANHTHU_TRUOC_GIAHAN = 0 then 'GIAHAN'
                when DOANH_THU_DK > DOANHTHU_TRUOC_GIAHAN then 'NANG_GOI'
                when DOANH_THU_DK < DOANHTHU_TRUOC_GIAHAN then 'GIAHAN' -- test
                else 'GIAHAN' end as loai_gd,
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
             CASE
        WHEN REGEXP_LIKE(CHU_KY_GOI, '^\d+T$') THEN TO_NUMBER(REGEXP_SUBSTR(CHU_KY_GOI, '^\d+'))
        WHEN REGEXP_LIKE(CHU_KY_GOI, '^\d+\s*tháng$') THEN TO_NUMBER(REGEXP_SUBSTR(CHU_KY_GOI, '^\d+'))
        ELSE NULL
    END AS CHU_KY_GOI,
            DOANHTHU_TRUOC_GIAHAN,
            TO_CHAR(NGAYMO_DICHVU) AS NGAYMO_DICHVU,
            MAGOI_DICHVU_MOI,
             CASE
        WHEN REGEXP_LIKE(CHU_KY_GOI2, '^\d+T$') THEN TO_NUMBER(REGEXP_SUBSTR(CHU_KY_GOI2, '^\d+'))
        WHEN REGEXP_LIKE(CHU_KY_GOI2, '^\d+\s*tháng$') THEN TO_NUMBER(REGEXP_SUBSTR(CHU_KY_GOI2, '^\d+'))
        ELSE NULL
    END AS CHU_KY_GOI2,
            DOANH_THU_DK
        FROM vietanhvh.ob_ckd_ct
        where thang = 202412

        UNION ALL

        SELECT
            '84' || so_tb AS ma_tb,
            MA_GOI_TRUOC_OB,USER_DTV,
            CASE
        WHEN REGEXP_LIKE(TO_CHAR(CHU_KY_GOI), '^\d+T$') THEN TO_NUMBER(REGEXP_SUBSTR(TO_CHAR(CHU_KY_GOI), '^\d+'))
        WHEN REGEXP_LIKE(TO_CHAR(CHU_KY_GOI), '^\d+\s*tháng$') THEN TO_NUMBER(REGEXP_SUBSTR(TO_CHAR(CHU_KY_GOI), '^\d+'))
        ELSE NULL
    END AS CHU_KY_GOI,
            DOANH_THU_TRUOCGIAHAN,
            NGAY_MO_DICHVU AS NGAY_MO_DICHVU,
            MA_GOI_DICHVU AS MAGOI_DICHVU_MOI,
             CASE
        WHEN REGEXP_LIKE(CHU_KY_GOI2, '^\d+T$') THEN TO_NUMBER(REGEXP_SUBSTR(CHU_KY_GOI2, '^\d+'))
        WHEN REGEXP_LIKE(CHU_KY_GOI2, '^\d+\s*tháng$') THEN TO_NUMBER(REGEXP_SUBSTR(CHU_KY_GOI2, '^\d+'))
        ELSE NULL
    END AS CHU_KY_GOI2,
            DOANH_THU_DK
        FROM vietanhvh.OB_CKN_ct
        where thang = 202412
    )
) a
left join  CUOCVINA.tieudung_bts_202411@ttkddbbk2 b --edit tieudung để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84

;

--update HVC
            MERGE INTO DONGIA_DTHU_HIENHUU_202412 a
        USING (
            SELECT ACCS_MTHD_KEY
            FROM (select ACCS_MTHD_KEY from  bi_nctt.hvc_202412_chot@coevnpt where tinh_PSC = 'HCM')
            ) b
        ON (a.ma_tb = b.ACCS_MTHD_KEY)
        WHEN MATCHED THEN
            UPDATE SET a.loai_hvc = 'HVC'
--         WHERE a.nguon IN ('CKN_CKD', 'OB_BG')
        ;
        UPDATE DONGIA_DTHU_HIENHUU_202412
        SET loai_hvc = 'NOHVC'
        WHERE  loai_hvc IS NULL;
select *
from S_DONGIA_DTHU_HIENHUU_202412_test
where ma_tb ='84948966139';
--xoa chu ky ngay
delete
from DONGIA_DTHU_HIENHUU_202412 a
where exists( SELECT 1 FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' AND goi_cuoc = a.ten_goi);
drop table S_DONGIA_DTHU_HIENHUU_202412_test;
-- tạo bảng lọc 1 dòng loại luôn chu ky ngày,Loại trừ các TH a Tuyen,a Khann
   CREATE TABLE S_DONGIA_DTHU_HIENHUU_202412_test_3 AS
WITH src_data AS (
    SELECT 202412 AS thang,
           a.MA_TB, IS_TBHH, a.THANG_KH_SIM, a.TEN_GOI, a.CHU_KY, a.DTHU_GOI, a.NGAY_KH,
           a.REGIS_TYPE_GRP, a.LOAI_GD, a.LOAIHINH_TB, a.USER_BAN_GOI,a.USER_BAN_GOI user_temp,cast(null as nvarchar2(100)) USER_NAME, a.LOAI_KENH,
           a.THANHVIEN_KENH, a.MA_HRM, a.TEN_NV,
           x.ma_vtcv
           ,(select ma_to from ttkd_bsc.nhanvien where ma_nv=ma_hrm and thang = 202412) ma_to
           ,(select ten_to from ttkd_bsc.nhanvien where ma_nv=ma_hrm and thang = 202412) ten_to
           ,x.ma_pb, x.ten_pb, -- lấy dữ liệu từ bảng ttkd_bsc.nhanvien
           a.CONG_CU_BAN_GOI, a.LOAI_HVC, a.HESO, a.DTHU_TLDG,round(TIEN_THULAO / 0.8, 0) DTHU_KPI, a.TIEN_THULAO, a.NGUON, a.LOAI_GD_TLDG,
--            ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.USER_BAN_GOI, a.dthu_goi DESC) AS rnk
           ROW_NUMBER() OVER (PARTITION BY a.ma_tb ORDER BY a.NGAY_KH DESC) AS rnk

    FROM DONGIA_DTHU_HIENHUU_202412 a
    LEFT JOIN ttkd_bsc.nhanvien x
           ON a.ma_hrm = x.ma_nv AND x.thang = 202412
)
-- ds stb loai_tru
, prevent_data AS (
    SELECT somay
    FROM khanhtdt_ttkd.CCBS_ID1896@TTKDDB
    WHERE thang = 202412 AND kieu_ld = 'P -> C'
)
SELECT a.*,
       CASE
           WHEN IS_TBHH = 0
               then 'PTM ko tinh( 6 thang voi TS, 1 thang voi Tratruoc'
           WHEN  ma_pb ='VNP0700800'
                then 'PTTT ko tính'
--            WHEN pd.SOMAY IS NOT NULL
--                 THEN 'DS loại trừ: P2C'
            WHEN  EXISTS (SELECT 1 FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' AND goi_cuoc = a.ten_goi)
                THEN 'Khong phải CK tháng'


        ELSE NULL
       END AS lydo_khongtinh
FROM src_data a
-- LEFT JOIN prevent_data pd ON a.ma_tb = pd.SOMAY
   ;
888176039 ;
select * from S_DONGIA_DTHU_HIENHUU_202412_test where ma_tb ='84888176039';
    --ADMIN kich giup: user GDV không được quyền tác động bán gói:
create index inx_dg_202412 on S_DONGIA_DTHU_HIENHUU_202412_test(ma_tb);
-- drop index inx_dg;
MERGE INTO S_DONGIA_DTHU_HIENHUU_202412_test b
USING (
    SELECT
        LOAIHINH_TB,
        ma_tb,
        ngayxuly,
        aaa,
        NGAYCAPNHAT,
        ngay_kh_goi,
        ma_nv,
        NV_YEUCAU,
        yeucau
    FROM (
        SELECT
            b.LOAIHINH_TB,
            b.ma_tb,
            a.ngayxuly,
            TO_CHAR(a.ngayxuly, 'yyyymm') AS aaa,
            a.NGAYCAPNHAT,
            b.ngay_kh AS ngay_kh_goi,
            x.ma_nv,
            a.NV_YEUCAU,
            a.yeucau,
            ROW_NUMBER() OVER (PARTITION BY b.ma_tb ORDER BY a.ngayxuly DESC) AS rn
        FROM
            ttkdhcm_ktnv.vnp_yeucau a
        JOIN
            S_DONGIA_DTHU_HIENHUU_202412_test b ON '84' || a.sothuebao = b.ma_tb
        LEFT JOIN
            ttkd_bsc.nhanvien x ON x.thang = 202412 AND a.userxuly = x.nhanvien_id
        WHERE
             a.NV_YEUCAU is not null
    )
    WHERE rn = 1
) src
ON (b.ma_tb = src.ma_tb)
WHEN MATCHED THEN
    UPDATE SET
        b.USER_BAN_GOI = src.NV_YEUCAU;

--code duoi sau khi update nhan vien kich gium ms dung
update S_DONGIA_DTHU_HIENHUU_202412_test a
    set lydo_khongtinh = case WHEN not EXISTS (
                                SELECT 1 FROM ttkd_bsc.nhanvien
                                WHERE thang = 202412
                                  AND (user_ccbs = a.user_ban_goi OR user_ccos = a.user_ban_goi OR ma_nv = a.user_ban_goi)
                            ) THEN 'ko phải nv noi bo'
else lydo_khongtinh end
where lydo_khongtinh is null


;



--update ma_hrm con thieu:
        update S_DONGIA_DTHU_HIENHUU_202412_test a
        set ma_hrm = (select (b.ma_nv) from ttkd_bsc.nhanvien b where b.thang = 202412 and b.ma_nv = a.USER_BAN_GOI) -- tháng 9 ttvt_ctv086203_hcm đag bị double nên dùng max
        where USER_BAN_GOI like 'CTV%'
            or  USER_BAN_GOI like 'VNP%'
        ;
      update S_DONGIA_DTHU_HIENHUU_202412_test a
        set ma_hrm = (select (b.ma_nv) from ttkd_bsc.nhanvien b where b.thang = 202412 and b.USER_CCBS = a.USER_BAN_GOI) -- tháng 9 ttvt_ctv086203_hcm đag bị double nên dùng max
        where ma_hrm is null

        ;
        update S_DONGIA_DTHU_HIENHUU_202412_test a
        set ma_hrm = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202412 and b.USER_CCOS = a.USER_BAN_GOI)
        where ma_hrm is null
        ;
        update S_DONGIA_DTHU_HIENHUU_202412_test a
        SET ma_hrm = (SELECT c.ma_nv
                     FROM manpn.bscc_import_kenh_noibo b
                     JOIN ttkd_bsc.nhanvien c
                       ON c.thang = 202412
                      AND SUBSTR(C.MAIL_VNPT, 1, INSTR(C.MAIL_VNPT, '@') - 1) = LOWER(
                           CASE
                              WHEN INSTR(b.MA, '_') > 0 THEN SUBSTR(b.MA, 1, INSTR(b.MA, '_') - 1)
                              ELSE b.MA
                           END
                       )
                    WHERE b.thang = 202412
                      AND b.SO_ELOAD = a.USER_BAN_GOI
                  )
        ,lydo_khongtinh = null
       where exists (select 1 FROM manpn.bscc_import_kenh_noibo b where b.SO_ELOAD = a.USER_BAN_GOI );

update S_DONGIA_DTHU_HIENHUU_202412_test
    set (ten_nv,TEN_PB,ma_to,ten_to, MA_VTCV, MA_PB) = (select x.ten_nv,x.TEN_PB,x.ma_to,x.ten_to ,x.MA_VTCV, x.MA_PB from ttkd_bsc.nhanvien x where ma_hrm =ma_nv and thang = 202412)
;
--2 cai trung nhau dang gGIAHAN --> update ma_tb co ngay_kh min = dangky
UPDATE S_DONGIA_DTHU_HIENHUU_202412_test a
SET loai_gd = 'DANGKY'
WHERE a.ma_tb IN (
    SELECT a.ma_tb
    FROM S_DONGIA_DTHU_HIENHUU_202412_test a
    JOIN S_DONGIA_DTHU_HIENHUU_202412_test b
      ON a.ma_tb = b.ma_tb
     AND a.ten_goi = b.ten_goi
     AND a.DTHU_GOI = b.DTHU_GOI
     AND b.NGAY_KH < a.NGAY_KH
     AND TRUNC(a.NGAY_KH) - TRUNC(b.NGAY_KH) > 25
     AND a.LOAI_GD = 'GIAHAN'
     AND b.LOAI_GD = 'GIAHAN'
) and rnk = 2;
update S_DONGIA_DTHU_HIENHUU_202412_test
set heso = 0,TIEN_THULAO=0,LYDO_KHONGTINH='PTTT ko tính'
where ma_pb ='VNP0700800'
;

---Tinh tiennnnnn noVat./1.1
update S_DONGIA_DTHU_HIENHUU_202412_test
set heso = 0
where IS_TBHH=0 or lydo_khongtinh is not null;


update S_DONGIA_DTHU_HIENHUU_202412_test
set heso = case when loai_gd in ('NANG_GOI','DANGKY','NANG_CHUKY') and LOAI_HVC ='HVC' then 25
                when loai_gd in ('NANG_GOI','DANGKY','NANG_CHUKY') and LOAI_HVC ='NOHVC' then 20
                when loai_gd in ('GIAHAN','GIAHAN_OB','GIAHAN_TUDONG')  then 3
                when loai_gd in('HA_CHUKY','HA_GOI') then 0
            else 0 --HA_GOI, HA_CHUKY
end
where IS_TBHH = 1 and lydo_khongtinh is null
;
update S_DONGIA_DTHU_HIENHUU_202412_test
set heso = 0
,lydo_khongtinh ='Ko phải nv BHOL'
where LOAI_GD = 'GIAHAN' and ma_pb <> 'VNP0703000'
;
update S_DONGIA_DTHU_HIENHUU_202412_test
set TIEN_THULAO = round((DTHU_TLDG/1.1)*heso/100*IS_TBHH)
,DTHU_KPI = round((DTHU_TLDG/1.1)*heso/100*IS_TBHH/0.8)
;

delete
from
S_DONGIA_DTHU_HIENHUU_202412_test
where ma_tb in (select a.ma_tb from S_DONGIA_DTHU_HIENHUU_202412_test a
   , S_DONGIA_DTHU_HIENHUU_202412_test b
   where a.ten_goi =b.ten_goi and  b.NGAY_KH < a.NGAY_KH
      AND  trunc(a.NGAY_KH )- trunc(b.NGAY_KH) <=2 and a.ma_tb =b.ma_tb and a.DTHU_GOI=b.DTHU_GOI)
and nguon = 'CKN_CKD'

;
--thucong thang 11,thang 12 fix lai code
--pbh online sheeet 2
update S_DONGIA_DTHU_HIENHUU_202412_test
set LOAI_GD = 'GIAHAN'
    where LOAI_GD ='DANGKY' and  ma_tb in ('84812250654',
'84812301904',
'84812311676',
'84812390901',
'84813981015',
'84812787323',
'84813419705',
'84817642026',
'84817112259',
'84822953812',
'84819863880',
'84818528851',
'84818662678',
'84886561602',
'84845260060',
'84843408726',
'84855611054',
'84852935535',
'84846999479',
'84857833422',
'84848445007',
'84848486628',
'84847533367',
'84855390273',
'84855452465',
'84843222313',
'84848899659',
'84913100765',
'84912847800',
'84913515070',
'84911652613',
'84913127272',
'84912587905',
'84913278525',
'84911409622',
'84913602807',
'84888236465',
'84912709712',
'84913621675',
'84917099120',
'84916369675',
'84913796304',
'84916436830',
'84913733100',
'84913835180',
'84913845251',
'84916308791',
'84915880058',
'84916804713',
'84829587100',
'84835771813',
'84838447027',
'84837956471',
'84837168809',
'84837182913',
'84827213668',
'84834180959',
'84943217611',
'84919472108',
'84941920870',
'84942450117',
'84942734419',
'84943282606',
'84919499911',
'84942000012',
'84942525204',
'84942816429',
'84942821265',
'84942587727',
'84943400004',
'84943127275',
'84944292372',
'84948293728',
'84945336208',
'84945080567',
'84944870279',
'84948133330',
'84945695752',
'84947049059',
'84945179768',
'84947985560',
'84948861109',
'84839794019',
'84949358258',
'84813024913',
'84815497313',
'84823221217',
'84817453955',
'84815527442',
'84827308775',
'84949213063',
'84824922804',
'84848397980',
'84839515262',
'84948770016',
'84819183400',
'84824408500',
'84829076791',
'84829882809',
'84836075457',
'84918337968',
'84919300970',
'84918671059',
'84918273466',
'84919343624',
'84917335772',
'84917788463',
'84918833218',
'84918128816',
'84918403425',
'84918215302',
'84917901818',
'84918627729',
'84918060428',
'84859067409',
'84838414228',
'84837065871',
'84836486634',
'84912739423',
'84842407218',
'84858530645',
'84911147776',
'84839892268',
'84886181901',
'84856687987',
'84847845924',
'84886342907',
'84852273847',
'84838893263',
'84886859467',
'84943063878',
'84949852928',
'84946121327',
'84946188020',
'84948397056',
'84919677907',
'84937238123',
'84918516160',
'84941524770',
'84944205216',
'84945302057',
'84944927857',
'84949224676',
'84819627277',
'84943234808',
'84919185552',
'84942618720',
'84917462019',
'84918010753',
'84912303904',
'84917138527',
'84918798808',
'84912029104',
'84918231657',
'84918152526',
'84919489523',
'84919585850',
'84914438778',
'84911291003',
'84913738030',
'84913741811',
'84917073378',
'84913689679',
'84917171851',
'84941113300',
'84911563854',
'84917663370'
)
;





select count(*) from S_DONGIA_DTHU_HIENHUU_202412_test a; where ma_tb ='84329805606';
select *
from DONGIA_DTHU_HIENHUU_202412 where ma_tb ='84329805606';





-----------------=================END_-----------=============================
5/12: da fix rank o nhanvien yeucau kich gium
  OK: 84815995876 true = DKY,nma dang la GIAHAN --> lydo: tai goi truoc OB co duoi la 0K dang loi doanh thu =0 nen de la gianhan het
  -> update tu code nay
       select * from S_DONGIA_DTHU_HIENHUU_202412_test where ma_tb in (
   select a.ma_tb from S_DONGIA_DTHU_HIENHUU_202412_test a
   , S_DONGIA_DTHU_HIENHUU_202412_test b
   where a.ten_goi =b.ten_goi and  b.NGAY_KH < a.NGAY_KH
      AND  trunc(a.NGAY_KH )- trunc(b.NGAY_KH) >20 and a.ma_tb =b.ma_tb and a.DTHU_GOI=b.DTHU_GOI )
  84816573646
  - OK 843409496 lay THOI_GIAN_TH_OB thay vi NGAY_MO_DICHVU thi moi loc duoc bangoi (GIAHAN_DK_THANHCONG)
  => del    select * from S_DONGIA_DTHU_HIENHUU_202412_test where ma_tb in (
   select a.ma_tb from S_DONGIA_DTHU_HIENHUU_202412_test a
   , S_DONGIA_DTHU_HIENHUU_202412_test b
   where a.ten_goi =b.ten_goi and  a.NGAY_KH < b.NGAY_KH
      AND  trunc(b.NGAY_KH )- trunc(a.NGAY_KH) = 1 and a.ma_tb =b.ma_tb and a.DTHU_GOI=b.DTHU_GOI and a.USER_BAN_GOI = b.USER_BAN_GOI)
   ;

  MERGE INTO DONGIA_DTHU_HIENHUU_202412 tgt
USING (
    SELECT
        t1.ma_tb,
        t1.ngay_kh,
        t2.ngay_kh AS ngay_kh_muon
    FROM DONGIA_DTHU_HIENHUU_202412 t1
    JOIN DONGIA_DTHU_HIENHUU_202412 t2
        ON t1.ten_goi = t2.ten_goi
        AND t1.DTHU_GOI = t2.DTHU_GOI
        AND t1.nguon = 'BRIS_P04'
        AND t2.nguon = 'BRIS_P04'
        AND t1.ngay_kh < t2.ngay_kh -- chỉ lấy các bản ghi có ngày_kh muộn hơn
) src
ON (tgt.ma_tb = src.ma_tb AND tgt.nguon = 'BRIS_P04')
WHEN MATCHED THEN
    UPDATE SET tgt.loai_gd = 'giahan';

-- thang 11 co pl4 chay luon, thay cac tham so va ten bang
