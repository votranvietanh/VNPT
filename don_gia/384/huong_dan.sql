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

