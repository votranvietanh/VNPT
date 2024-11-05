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
select * from OB_CKD_ct;
select * from OB_CKN_ct;
select * from ob_bangoi_ct WHERE '84'||SO_THUE_BAO  IN (SELECT MA_TB FROM PL1_2024);
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
    , HRM_CODE ma_hrm, STAFF_NAME ten_nv, REGIS_SYSTEM_CD cong_cu_ban_goi, LOAI_HVC,DECODE(LOAI_HVC,'HVC',25,'NOHVC',20) HESO,TOT_RVN_PACKAGE DTHU_TLDG, TOT_RVN_PACKAGE*DECODE(LOAI_HVC,'HVC',25,'NOHVC',20)/100 TIEN_THULAO
from dgia_hienhuu_pl4
where LOAI_TB_THANG ='HH' and thang = 202409
        and REGIS_SYSTEM_CD NOT IN('SELFCARE','MYVNPT')
  --        AND ACCS_MTHD_KEY NOT IN (select '84'||SO_THUE_BAO from ob_bangoi_ct where thang = 202409 )
;
SELECT * FROM DONGIA_DTHU_HIENHUU ;


