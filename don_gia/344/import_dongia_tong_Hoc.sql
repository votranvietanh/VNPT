insert into ttkd_bsc.ct_bsc_ptm(dich_vu, dichvuvt_id, loaitb_id, tenkieu_ld, kieuld_id, loaihd_id
			,THANG_TLKPI_HOTRO,THANG_TLDG_DT_NVHOTRO,THANG_TLKPI_DNHM,THANG_TLDG_DNHM,THANG_PTM,NGUON,GHI_CHU
			,MA_TB,GOI_CUOC,sothang_dc,MANV_PTM,TENNV_PTM,ma_to,ten_to,ma_pb,ten_pb,TIEN_DNHM,DOANHTHU_DONGIA_DNHM,LUONG_DONGIA_DNHM_NVPTM,MANV_hotro,
            mato_hotro,mapb_hotro,dthu_goi,datcoc_csd,DOANHTHU_DONGIA_NVHOTRO,LUONG_DONGIA_NVHOTRO,DOANHTHU_KPI_DNHM,DOANHTHU_KPI_NVHOTRO,LYDO_KHONGTINH_DONGIA)

select 'VNPTT', 2, 21, 'Hòa mạng mới di động' tenkieu_ld, 2 kieuld_id, 1 loaihd_id,THANG_PTM,THANG_PTM,THANG_PTM,THANG_PTM,THANG_PTM
			,NGUON,PHAN_LOAI_KENH,MA_TB,TEN_GOI,CK_GOI_TLDG,MANV_PTM,TENNV_PTM,MATO_PTM,TENTO_PTM,MAPB_PTM,TENPB_PTM,TIEN_DNHM,DTHU_DONGIA_DNHM
            ,TIEN_THULAO_DNHM,MANV_GOI,MATO_GOI,MAPB_GOI,TIEN_GOI,TIEN_GOI,DTHU_DONGIA_GOI,TIEN_THULAO_GOI
		  ,DTHU_DNHM_KPI,DTHU_KPI,(LYDO_KHONGTINH|| ';'||LYDO_KHONGTINH_KPI) LYDO_KHONGTINH_DONGIA
		  from vietanhvh.one_line_202409
		  where thang_ptm = 202409
            ;





-----VA: code T10 public tren ID88
--tach từ 1 dòng -> 2 dòng, rồi gom thêm phần bổ sung
select * from (
     --nv mua goi
         select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG,
                 MANV_GOI ma_nv,b.ten_nv, MATO_GOI ma_to,b.ten_to, MAPB_GOI ma_pb,b.ten_pb,'mua_goi' tenkieu_ld, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
                 DTHU_KPI, LYDO_KHONGTINH
         from vietanhvh.one_line_202410 a
            join ttkd_bsc.nhanvien b
                on b.thang = a.thang_ptm and a.manv_goi = b.ma_nv
union all
    --nv PTM
         select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG, MANV_PTM ma_nv, TENNV_PTM,
                MATO_PTM ma_to, TENTO_PTM, MAPB_PTM ma_pb, TENPB_PTM,'ptm' tenkieu_ld, TIEN_DNHM, DTHU_DONGIA_DNHM, TIEN_THULAO_DNHM
                , DTHU_DNHM_KPI, LYDO_KHONGTINH
         from vietanhvh.one_line_202410
union all
    --Bo sungg
         select THANG_PTM thang, NGUON, PHAN_LOAI_KENH, MA_TB, TEN_GOI, CK_GOI_TLDG,
                MANV_GOI ma_nv,b.ten_nv, MATO_GOI ma_to,b.ten_to, MAPB_GOI ma_pb,b.ten_pb,'mua_goi' tenkieu_ld, TIEN_GOI, DTHU_DONGIA_GOI, TIEN_THULAO_GOI,
    DTHU_KPI, LYDO_KHONGTINH
         from vietanhvh.bosung_T10 a
            join ttkd_bsc.nhanvien b
                on b.thang = a.thang_ptm and a.manv_goi = b.ma_nv
         ) where MA_TB ='84917150409'
;
insert into