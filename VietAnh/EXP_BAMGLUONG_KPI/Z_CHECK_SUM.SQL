---CHECK XEM CÓ ĐIỀN THỪA HOẶC THIẾU TRONG DMKPI?
      select ma_kpi,sum(THUCHIEN+ TYLE_THUCHIEN+MUCDO_HOANTHANH) summ  from  ttkd_bsc.blkpi_danhmuc_kpi 
      where thang = 202408 
            AND 
                  ((THUCHIEN+ TYLE_THUCHIEN+MUCDO_HOANTHANH) > 1) -- THỪA               
      group by ma_kpi;

select *  from  ttkd_bsc.blkpi_danhmuc_kpi where thang = 202408 ;
select * from ttkd_bsc.bangluong_kpi where thang = 202408 and ma_kpi ='HCM_TB_MCUOC_001';

select * from ttkd_bsc.bangluong_kpi where thang = 202408 and ma_kpi ='HCM_DT_PTMOI_021' and ma_nv = 'VNP017014'


----------------mọi người dùng 
               select * from ttkd_bsc.blkpi_danhmuc_kpi where thang = 202409;
                      
                      GRANT EXECUTE ON create_kpi_summary_gom TO PUBLIC;


                BEGIN
                    vietanhvh.CREATE_KPI_SUMMARY_GIAO(202409);
                END;
                /
                select * from vietanhvh.BLkpi_202409_giao; --GIAO
                
                 BEGIN
                        vietanhvh.KPI_CONGTRU(202409);
                 END;
                /
                 SELECT * FROM vietanhvh.kpi_CONGTRU_202409;
                
                
                BEGIN
                    vietanhvh.create_kpi_summary_gom(202409);
                END;
                /
--                drop table BL_202408_tonghop;
                select * from vietanhvh.BL_202409_tonghop;
