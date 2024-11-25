-- ma LK lay lun ma_nv quan ly trong tndn_simso
update ONE_LINE_202410
set MANV_PTM =
    where ;

update SSS_DGIA_202410 a
set (USERNAME_KH,MANV_PTM) = (SELECT b.MA_NVCS,b.MA_NVCS FROM dgia_TNDN_SIMSO b WHERE b.THANG = 202410 AND a.MA_TB = b.MA_TB )
 where MANV_DKTT like '%LK%' AND TENKIEU_LD ='ptm';
   update SSS_dgia_202410 a
        set (tennv_ptm,ma_to,ten_to, ma_pb, ten_pb, ma_vtcv, nhom_tiepthi) = ( select x.ten_nv, x.ma_to, x.ten_to, x.ma_pb, x.ten_pb, x.ma_vtcv, x.NHOMLD_ID from ttkd_bsc.nhanvien x where x.thang=a.thang_ptm and x.ma_nv = a.manv_ptm)
    where tennv_ptm is null
       ;
         update SSS_dgia_202410 a
         set loai_ld = (select x.TENNHOM_TAT from  ttkd_bsc.dm_nhomld x where x.NHOMLD_ID = a.nhom_tiepthi)
         where a.loai_ld is null
        ;
update SSS_dgia_202410
    set MANV_GOC = MANV_PTM
where MANV_GOC is null ;
;
update SSS_dgia_202410
set  kenh_trong = null,
    DAI_LY = null
,BUNDLE_XK = null;
select * from  SSS_DGIA_202410 where MANV_DKTT like '%LK%'  AND TENKIEU_LD ='ptm' ;
select * from  SSS_DGIA_202410 where MANV_DKTT like '%LK%'  AND TENKIEU_LD ='ptm' ;
select * from ONE_LINE_202410 where ma_tb in('84834859118',
'84886359858',
'84886747669',
'84888248161',
'84888352218',
'84888386411',
'84889778204',
'84941596375',
'84941600217',
'84941782435',
'84942023193',
'84942163315',
'84942182384',
'84942564272',
'84943048396',
'84944913156',
'84945641511',
'84948391235',
'84948936246',
'84949827138');
update ONE_LINE_202410 a
set MANV_PTM = (select b.MANV_PTM from SSS_DGIA_202410 b where b.ma_tb = a.MA_TB and b.tenkieu_ld ='ptm' ),
MANV_GOC = (select b.MANV_PTM from SSS_DGIA_202410 b where b.ma_tb = a.MA_TB and b.tenkieu_ld ='ptm' ),
TENNV_PTM = (select b.TENNV_PTM from SSS_DGIA_202410 b where b.ma_tb = a.MA_TB and b.tenkieu_ld ='ptm' ),
MATO_PTM = (select b.MA_TO from SSS_DGIA_202410 b where b.ma_tb = a.MA_TB and b.tenkieu_ld ='ptm' ),
TENTO_PTM = (select b.TEN_TO from SSS_DGIA_202410 b where b.ma_tb = a.MA_TB and b.tenkieu_ld ='ptm' ),
MAPB_PTM = (select b.ma_pb from SSS_DGIA_202410 b where b.ma_tb = a.MA_TB and b.tenkieu_ld ='ptm' ),
TENPB_PTM = (select b.ten_pb from SSS_DGIA_202410 b where b.ma_tb = a.MA_TB and b.tenkieu_ld ='ptm' )
where ma_tb in('84834859118',
'84886359858',
'84886747669',
'84888248161',
'84888352218',
'84888386411',
'84889778204',
'84941596375',
'84941600217',
'84941782435',
'84942023193',
'84942163315',
'84942182384',
'84942564272',
'84943048396',
'84944913156',
'84945641511',
'84948391235',
'84948936246',
'84949827138');

;
select * from manpn.manpn_GOI_TONGHOP_202410 a where a.ma_tb in( select ma_tb from one_line_202410 where heso_hhbg >0 and TIEN_THULAO_GOI =0);