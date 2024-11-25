-- vcc = loaitb_id = 149
SELECT *FROM DONGIA_DTHU_HIENHUU_202410_v2 where MA_TB ='84823280760';
create table DONGIA_DTHU_HIENHUU_202410_v2 as;
SELECT * FROM DONGIA_DTHU_HIENHUU_202410 where LOAI_GD ='BRIS_P04' and MA_TB ='84919008123';


drop table DONGIA_DTHU_HIENHUU_202410_v2;
create table DONGIA_DTHU_HIENHUU_202410_ as
SELECT * FROM DONGIA_DTHU_HIENHUU_202410;
--SỬA TAY CÁC GOÓI TRÙNG ĐÚNG LẠI LOAI_GD -> DANGKY-> NANG_GOI/NANG CHU KY SE~ CON LAI NHUNG GOI DANGKY VA GIAHAN
delete FROM ob_ckn_ct
WHERE ROWID IN (
    SELECT rid
    FROM (
        SELECT ROWID AS rid,
               ROW_NUMBER() OVER (PARTITION BY SO_TB, MA_GOI_DICHVU, LOAI_GD ORDER BY ngay_kh asc ,ROWID) AS rn
        FROM ob_ckn_ct
    )
    WHERE rn > 1
);

delete FROM DONGIA_DTHU_HIENHUU_202410_v2
WHERE ROWID IN (
    SELECT rid
    FROM (
        SELECT ROWID AS rid,
               ROW_NUMBER() OVER (PARTITION BY MA_TB, TEN_GOI, LOAI_GD ORDER BY ngay_kh asc ,ROWID) AS rn
        FROM DONGIA_DTHU_HIENHUU_202410_v2
        WHERE  LOAI_GD ='DANGKY'
    )
    WHERE rn > 1
);
delete FROM DONGIA_DTHU_HIENHUU_202410_v2
WHERE ROWID IN (
    SELECT rid
    FROM (
        SELECT ROWID AS rid,
               ROW_NUMBER() OVER (PARTITION BY MA_TB, TEN_GOI ORDER BY ngay_kh asc ,ROWID) AS rn
        FROM DONGIA_DTHU_HIENHUU_202410_v2
        WHERE
        nguon = 'BRIS_P04'
    )
    WHERE rn > 1
);


insert into DONGIA_DTHU_HIENHUU_202410_v2 ( MA_TB, USER_BAN_GOI
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
    where thang= 202410
union all
        select '84'||MA_TB, DTV, MA_HRM,  GOICUOC_DANGKY, DTHU_DKY_USER,
              to_date(NGAY_KH,'DD/MM/YYYY HH24:MI:SS'),'HVC'loai_HVC
    from ob_hvc_ct
    where thang = 202410
)

Select a.*
     ,CASE
         WHEN (b.DATE_ENTER_ACTIVE < ADD_MONTHS(TRUNC(SYSDATE, 'mm'), -1))
             THEN 1
        ELSE 0
    END AS IS_TBHH
     ,(to_char((b.DATE_ENTER_ACTIVE),'yyyymm')) ngay_kh,'TT' LOAIHINH_TB
    ,a.DOANH_THU_DK,'OB_BG' nguon
    ,'DANGKY' loai_gd
From data a
Left join  CUOCVINA.tieudung_bts_202409@ttkddbbk2 b -- edit để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84
where ma_tb not in(select ma_tb from DONGIA_DTHU_HIENHUU_202410_v2 where loai_gd in ('DANGKY','NANG_GOI','NANG_CHUKY'))
;
delete from DONGIA_DTHU_HIENHUU_202410_v2 where nguon in ('OB_BG','CKN_CKD');
---
INSERT INTO DONGIA_DTHU_HIENHUU_202410_v2(LOAI_GD,IS_TBHH,ma_tb,USER_BAN_GOI,thang_kh_sim,ngay_kh,ten_goi,chu_ky,dthu_goi,DTHU_TLDG,LOAIHINH_TB,LOAI_HVC,nguon)

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
            case when DOANH_THU_DK > DECODE(DOANHTHU_TRUOC_GIAHAN, 0, DOANH_THU_DK, DOANHTHU_TRUOC_GIAHAN) then 'NANG_GOI'
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
        where thang = 202410

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
        where thang = 202410
    )
) a
left join  CUOCVINA.tieudung_bts_202409@ttkddbbk2 b --edit tieudung để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84
where loai_gd = 'GIAHAN'


;
INSERT INTO DONGIA_DTHU_HIENHUU_202410_v2(LOAI_GD,IS_TBHH,ma_tb,USER_BAN_GOI,thang_kh_sim,ngay_kh,ten_goi,chu_ky,dthu_goi,DTHU_TLDG,LOAIHINH_TB,LOAI_HVC,nguon)

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
            case when DOANH_THU_DK > DECODE(DOANHTHU_TRUOC_GIAHAN, 0, DOANH_THU_DK, DOANHTHU_TRUOC_GIAHAN) then 'NANG_GOI'
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
        where thang = 202410

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
        where thang = 202410
    )
) a
left join  CUOCVINA.tieudung_bts_202409@ttkddbbk2 b --edit tieudung để tìm ngày_kh cho sim trong file bangoi ccos
    on a.ma_tb = b.subscriber_id_84
where ma_tb not in(select ma_tb from DONGIA_DTHU_HIENHUU_202410_v2 where  LOAI_GD in ('DANGKY','NANG_CHUKY','NANG_GOI'))
and loai_gd = 'NANG_GOI'


;
select ma_tb
               from (select '84' || so_thue_bao ma_tb
                     from OB_CKD_ct
                     where thang = 202410
                     union all
                     select '84' || so_tb
                     from OB_CKN_ct
                     where thang = 202410
                     union all
                     select '84' || so_thue_bao
                     from ob_bangoi_ct
                     where thang = 202410
                     union all
                     select '84' || MA_TB
                     from ob_hvc_ct
                     where thang = 202410)
               where ma_tb not in(select ma_tb from  DONGIA_DTHU_HIENHUU_202410);

----===
drop table S_DONGIA_DTHU_HIENHUU_202410_v3;

UPDATE S_DONGIA_DTHU_HIENHUU_202410_v3 a
SET lydo_khongtinh =
    CASE
        WHEN  EXISTS (SELECT 1 FROM manpn.BSCC_INSERT_DM_GOICUOC_PHANKY WHERE chu_ky_thang = 'N' AND goi_cuoc = a.ten_goi)
            THEN 'Khong phải CK tháng'
        WHEN  EXISTS (SELECT 1
                         FROM ttkd_bsc.nhanvien
                         WHERE thang = 202410
                           AND (user_ccbs = a.user_ban_goi OR user_ccos = a.user_ban_goi OR ma_nv = a.user_ban_goi)
        ) THEN 'ko phải nv noi bo'
        WHEN IS_TBHH = 0 then 'PTM ko tinh'
        ELSE NULL
    END
WHERE lydo_khongtinh IS NULL; -- chỉ cập nhật nếu chưa có giá trị
UPDATE S_DONGIA_DTHU_HIENHUU_202410_v3
set lydo_khongtinh = null
where USER_BAN_GOI in (select so_eload  from manpn.bscc_import_kenh_noibo where thang = 202410);

create table vhn_384 as; select * from vhn_384 where ma_tb ='84852444404';
    --ADMIN kich giup: user GDV không được quyền tác động bán gói:
alter table S_DONGIA_DTHU_HIENHUU_202410_v3
add user_tam varchar2(100);
update S_DONGIA_DTHU_HIENHUU_202410_v3
set user_tam =USER_BAN_GOI;
-- create index inx_dg on S_DONGIA_DTHU_HIENHUU_202410_v3(ma_tb);
-- drop index inx_dg;
MERGE INTO vhn_384 b
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
        vhn_384 b ON '84' || a.sothuebao = b.ma_tb
    LEFT JOIN
        ttkdhcm_ktnv.VNP_GOICUOC d ON a.GOICUOCDENGHI = d.idgoicuoc
    LEFT JOIN
        ttkdhcm_ktnv.VNP_GOICUOC e ON a.GOICUOCCAMKET = e.idgoicuoc
    LEFT JOIN
        ttkd_bsc.nhanvien x ON x.thang = 202410 AND a.userxuly = x.nhanvien_id
    WHERE
        TO_CHAR(a.ngayxuly, 'yyyymm') IN ('202410', '202409')
        AND TRUNC(a.ngayxuly) <= TRUNC(b.ngay_kh)
        AND a.hoantat = 1
        AND a.yeucau = 1
        AND REPLACE(b.TEN_GOI, 'Gói ', '') = COALESCE(d.tengoicuoc, '') || ' ' || COALESCE(e.tengoicuoc, '')
) src
ON (b.ma_tb = src.ma_tb)
WHEN MATCHED THEN
    UPDATE SET b.USER_BAN_GOI = src.NV_YEUCAU;


--update ma_hrm con thieu:
        update S_DONGIA_DTHU_HIENHUU_202410_v3 a
        set ma_hrm = (select (b.ma_nv) from ttkd_bsc.nhanvien b where b.thang = 202410 and b.ma_nv = a.USER_BAN_GOI) -- tháng 9 ttvt_ctv086203_hcm đag bị double nên dùng max
        where USER_BAN_GOI like 'CTV%'
            or  USER_BAN_GOI like 'VNP%'
        ;
      update S_DONGIA_DTHU_HIENHUU_202410_v3 a
        set ma_hrm = (select (b.ma_nv) from ttkd_bsc.nhanvien b where b.thang = 202410 and b.USER_CCBS = a.USER_BAN_GOI) -- tháng 9 ttvt_ctv086203_hcm đag bị double nên dùng max
        where ma_hrm is null

        ;
        update S_DONGIA_DTHU_HIENHUU_202410_v3 a
        set ma_hrm = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202410 and b.USER_CCOS = a.USER_BAN_GOI)
        where ma_hrm is null
        ;
        update S_DONGIA_DTHU_HIENHUU_202410_v3 a
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

update S_DONGIA_DTHU_HIENHUU_202410_v3
    set (ten_nv,TEN_PB, MA_VTCV, MA_PB) = (select x.ten_nv,x.TEN_PB, x.MA_VTCV, x.MA_PB from ttkd_bsc.nhanvien x where ma_hrm =ma_nv and thang = 202410)
;


;
;
update S_DONGIA_DTHU_HIENHUU_202410_v3
    set IS_TBHH = 1
where THANG_KH_SIM is null;
---Tinh tiennnnnn noVat./1.1
update S_DONGIA_DTHU_HIENHUU_202410_v3
set heso = 0;

update S_DONGIA_DTHU_HIENHUU_202410_v3
set heso = case when loai_gd in ('NANG_GOI','DANGKY','NANG_CHUKY') and LOAI_HVC ='HVC' then 25
                when loai_gd in ('NANG_GOI','DANGKY','NANG_CHUKY') and LOAI_HVC ='NOHVC' then 20
                when loai_gd in ('GIAHAN','GIAHAN_OB','GIAHAN_TUDONG')  then 3
                when loai_gd in('HA_CHUKY','HA_GOI') then 0
            else 0 --HA_GOI, HA_CHUKY
end
where IS_TBHH = 1
;
select *

from S_DONGIA_DTHU_HIENHUU_202410_v3 where ma_tb in ('84886370864',
'84912879867',
'84918139728',
'84886370647',
'84916664035',
'84913827268',
'84945823186',
'84949516086',
'84817072108',
'84915570757',
'84949183486'
);

update S_DONGIA_DTHU_HIENHUU_202410_v3
set TIEN_THULAO = round((DTHU_TLDG/1.1)*heso/100*IS_TBHH)
where LYDO_KHONGTINH is null
;
select LOAI_GD,ma_tb from S_DONGIA_DTHU_HIENHUU_202410_v3
where LOAI_GD ='DANGKY'
    group by LOAI_GD,ma_tb having count(MA_TB)>1
;
select *from S_DONGIA_DTHU_HIENHUU_202410_v3 where ma_tb ='84945823186';where LYDO_KHONGTINH ='DS loại trừ: C2P,EZPOST1500/900,P2C,Chuyển tỉnh tháng trước'
;

update S_DONGIA_DTHU_HIENHUU_202410_v3
set LYDO_KHONGTINH = null
where LYDO_KHONGTINH ='DS loại trừ: C2P,EZPOST1500/900,P2C,Chuyển tỉnh tháng trước'
;
select * from S_DONGIA_DTHU_HIENHUU_202410_v3
         where LYDO_KHONGTINH ='DS loại trừ: C2P,EZPOST1500/900,P2C,Chuyển tỉnh tháng trước';
where ma_tb in ('84815161161',
'84848022823',
'84854919286',
'84855558475',
'84886162268',
'84888881287',
'84912100923',
'84912491920',
'84913727657',
'84914384115',
'84914924878',
'84915304346',
'84915852139',
'84916131903',
'84916311715',
'84917381392',
'84918510269',
'84918779117',
'84919196309',
'84919204080',
'84919848900',
'84942354321',
'84943230331',
'84944143230',
'84945302955',
'84947132036',
'84949746271')
-- drop table S_DONGIA_DTHU_HIENHUU_202410_v3;
update S_DONGIA_DTHU_HIENHUU_202410_v3
set LYDO_KHONGTINH = 'Loại trừ C2P,P2C'
    , TIEN_THULAO = 0
    where ma_tb in (
  SELECT SOMAY
    FROM TTKD_BSC.DT_PTM_VNP_202410
    WHERE KIEU_LD = 'Chuyen C->P'
union all
     SELECT somay
    FROM khanhtdt_ttkd.CCBS_ID1896@TTKDDB
    WHERE thang = 202410 AND kieu_ld = 'P -> C')
;
select sum(TIEN_THULAO) from S_DONGIA_DTHU_HIENHUU_202410_v3  ; --395481030

select yeucau from ttkdhcm_ktnv.vnp_yeucau
where sothuebao in ('913615001');
select * from vhn_384 where ma_tb in (
    '84852444404',
'84888001400',
'84888890033',
'84911572007',
'84913113145',
'84913512001',
'84913615001',
'84913675001',
'84913850890',
'84913910460',
'84913942821',
'84913976118',
'84915515815',
'84917528963',
'84918533788',
'84918851441',
'84918858687',
'84918869064',
'84919797439',
'84919861995',
'84942105151',
'84943377770',
'84944414556',
'84946107171',
'84986191206'

    );
select trunc(to_date('2024-10-01 04:38:30','yyyy-mm-dd hh24:mi:ss')) from dual;