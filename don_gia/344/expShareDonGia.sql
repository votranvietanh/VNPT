
===========================================================SIM DAC THU==================================================


-- PBH THU DUC T2: OK
--              gan lai don gia ptm, ten file: ThuDuc_gan_dongia_HMM_2025xx
            select THANG_PTM,MA_TB,NGAY_KH,USERNAME_KH,''NV_THAY_THE
                    from SSS_dgia_202502 where username_kh ='halv_hcm' and tenkieu_ld ='ptm';

        select * from khieunai_td_dgia;
                        --1dong
                        update one_line_202502 a
                        set MANV_PTM = (select x.NGUOI_THAYTHE x from khieunai_td_dgia x
                                                                    where x.thang = 202502
                                                                       and x.MA_TB = a.ma_tb)
                        where  a.ma_tb in (select ma_tb from khieunai_td_dgia x where x.thang = 202502);
                         update one_line_202502 a
                                set (manv_ptm,tennv_ptm,MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_PTM)
                            where ma_tb in  (select ma_tb from khieunai_td_dgia where thang = 202502);




----PBH Tan Binh T2: OK
                            select  MA_TB,''ngay_kh,  MANV_PTM manv_goc, TENNV_PTM, TEN_GOI,TIEN_THULAO_DNHM,tien_goi,TIEN_THULAO_GOI
                            ,tien_goi*5/100 tien_thulao_kk,tien_goi*5/100+TIEN_THULAO_DNHM+TIEN_THULAO_GOI tong_thulao,'' manv_thaythe,''MANV_DTHU,202502 thang
                                from one_line_202502 where  mapb_ptm ='VNP0701600' and ten_goi in ('TR60D','TR80D')
                    select *
                    from SHARE_PBHTB where thang = 202501;
                        select * from share_pbhtb where thang = 202502;
                            select * from one_line_202502 where ma_tb in(select ma_tb from share_pbhtb  where thang = 202502);

                            alter table one_line_202502
                            add ghi_chu varchar2(100)
                            ;

                            update one_line_202502 a
                            set (MANV_PTM, MANV_GOI) = ( select b.MANV_THAYTHE,b.MANV_THAYTHE from share_pbhtb b where b.thang=202502 and a.ma_tb =b.ma_tb)
                            ,HESO_KK = case when (select ma_nv FROM ttkd_bsc.dinhmuc_giao_dthu_ptm
                                                WHERE thang = 202502
                                                    and ma_nv ='CTV051560'
                                                  AND ma_vtcv IN ('VNP-HNHCM_BHKV_15', 'VNP-HNHCM_BHKV_17','VNP-HNHCM_BHKV_15.1')
                                                  AND KQTH >= dinhmuc_2
                                                  AND KHDK >= dinhmuc_2) = 'CTV051560' then 0.05 end --nv thuc hien va ghi nhandoanh thu
                            ,ghi_chu ='VB1036,eO-1036142, pbhtb'
                            where ma_tb in (select ma_tb from share_pbhtb where thang = 202502)
                            ;
                            update one_line_202502
                                set TIEN_THULAO_GOI = nvl(DTHU_DONGIA_GOI,0)*heso_hhbg+(nvl(DTHU_DONGIA_GOI,0)*HESO_KK)
                            where ma_tb in (select ma_tb from share_pbhtb where thang = 202502)
                            ;
                            --update nv DNHM từ nv đã thay thế
                             update one_line_202502 a
                                    set (manv_ptm,tennv_ptm,MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_PTM)
                                where ma_tb in  (select ma_tb from share_pbhtb where thang = 202502)
                                  ;
                            --update nv Bán gói từ nv đã thay thế -- cùng tổ chắc khỏi update chỗ này :)
                             update one_line_202502 a
                                    set (MANV_GOI, MATO_GOI, MAPB_GOI) = ( select x.ma_nv, x.ma_to, x.ma_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_GOI)
                                where ma_tb in  (select ma_tb from share_pbhtb where thang = 202502)
                                  ;

                            ----end PBH TB


---PBH Hoc Mon T2: OK
                         select  MA_TB,''ngay_kh,  MANV_PTM manv_goc, TENNV_PTM, TEN_GOI,TIEN_THULAO_DNHM,tien_goi,TIEN_THULAO_GOI
                ,tien_goi*5/100 tien_thulao_kk,tien_goi*5/100+TIEN_THULAO_DNHM+TIEN_THULAO_GOI tong_thulao,'' manv_thaythe,''MANV_DTHU,202502 thang
                    from one_line_202502 where  mapb_ptm ='VNP0702100' and ten_goi in ('TR60D','TR80D');

                        select * from  SHARE_PBHHM where thang = 202502;

                     update one_line_202502 a
                            set( MANV_PTM) = (select  x.MANV_THAYTHE from vietanhvh.SHARE_PBHHM x
                                                                        where x.thang = 202502
                                                                           and x.MA_TB = a.ma_tb
                                                                            and x.tenkieu_ld ='ptm')
                            where  a.ma_tb in (select ma_tb from vietanhvh.SHARE_PBHHM  x where x.thang = 202502  and x.tenkieu_ld ='ptm'
                                                                                            and manv_goc ='VNP019515') ;
                      update one_line_202502 a
                            set( MANV_GOI) = (select  x.MANV_THAYTHE from vietanhvh.SHARE_PBHHM x
                                                                        where x.thang = 202502
                                                                           and x.MA_TB = a.ma_tb
                                                                         and x.tenkieu_ld ='mua_goi')
                            where  a.ma_tb in (select ma_tb from vietanhvh.SHARE_PBHHM  x where x.thang = 202502 and x.tenkieu_ld ='mua_goi'
                                                                                          and manv_goc ='VNP019515');
                    --UPDTAE nv DNHM
                             update one_line_202502 a
                                    set (manv_ptm,tennv_ptm,MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb
                                                                                                            from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm
                                                                                                                                       and x.ma_nv = a.MANV_PTM)
                                where ma_tb in  (select ma_tb from vietanhvh.SHARE_PBHHM where thang = 202502 and tenkieu_ld ='ptm')
                                  ;
                    --UPDTAE nv bán gói
                            update one_line_202502 a
                            set (MANV_GOI, MATO_GOI, MAPB_GOI) = ( select x.ma_nv, x.ma_to, x.ma_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_GOI)
                            where ma_tb in  (select ma_tb from vietanhvh.SHARE_PBHHM where thang = 202502  and tenkieu_ld ='mua_goi')
                          ;

--PBH NAM SAI GON
                        --BEGIN ông Sơn PBHSG
                        select * from vietanhvh.share_nsg where thang = 202502  ;
                    update one_line_202502 a
                    set( MANV_PTM,MANV_GOI) = (select x.MANV_THAYTHE, x.MANV_THAYTHE from vietanhvh.share_nsg x
                                                                where x.thang = 202502
                                                                   and x.MA_TB = a.ma_tb)
                    where  a.ma_tb in (select ma_tb from vietanhvh.share_nsg  x where x.thang = 202502);
            --UPDTAE nv DNHM
                     update one_line_202502 a
                            set (manv_ptm,tennv_ptm,MATO_PTM, TENTO_PTM, MAPB_PTM, TENPB_PTM) = ( select x.ma_nv,x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_PTM)
                        where ma_tb in  (select ma_tb from vietanhvh.share_nsg where thang = 202502)
                          ;
            --UPDTAE nv bán gói
                    update one_line_202502 a
                    set (MANV_GOI, MATO_GOI, MAPB_GOI) = ( select x.ma_nv, x.ma_to, x.ma_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.MANV_GOI)
                    where ma_tb in  (select ma_tb from vietanhvh.share_nsg where thang = 202502)
                  ;

        --END PBHSG



---PBH CHo LON:
                    --update bà Thắng
                    update SSS_dgia_202502_2
                    set MANV_PTM = 'VNP017782'
                    where USERNAME_KH ='thangptv1_hcm' and TENKIEU_LD ='ptm'
                    ;
                     update SSS_dgia_202502_2 a
                            set (tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.manv_ptm)
                        where USERNAME_KH ='thangptv1_hcm' and TENKIEU_LD ='ptm'
                           ;
                             update SSS_dgia_202502_2 a
                             set loai_ld = (select x.TENNHOM_TAT from  ttkd_bsc.dm_nhomld x where x.NHOMLD_ID = a.nhom_tiepthi)
                             where USERNAME_KH ='thangptv1_hcm' and TENKIEU_LD ='ptm'
                            ;
                    update one_line_202502
                    set MANV_PTM = 'VNP017782'
                    where manv_ptm ='VNP016957'
                    ;
                    update one_line_202502
                    set MANV_GOI = 'VNP017782' -- cùng tổ khỏi update tổ,pb
                    where nguon in ('bris; bundle_xuatkho','smrs; bundle_xuatkho') and manv_goc ='VNP016957'
                    ;
                     update one_line_202502 a
                            set (tennv_ptm,MATO_PTM,TENTO_PTM,MAPB_PTM,TENPB_PTM) = ( select x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.manv_ptm)
                        where manv_goc ='VNP016957'
                           ;







---CHECK:
            SELECT * FROM ONE_LINE_202502 WHERE MA_TB IN (SELECT MA_TB FROM SHARE_PBHTB WHERE THANG = 202502);
            SELECT * FROM ttkd_bsc.va_ct_bsc_ptm_vnptt WHERE MA_TB IN (SELECT MA_TB FROM SHARE_PBHHM WHERE THANG = 202502) and thang_ptm = 202502 and MANV_PTM is not null;

select *
from share_pbhhm where ma_tb ='84813793860';

select *
from vietanhvh.share_nsg;



