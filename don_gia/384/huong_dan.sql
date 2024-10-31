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
