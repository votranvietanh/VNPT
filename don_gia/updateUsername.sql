        --username có dạng theo số ELOAD(nội bộ)
        UPDATE SSS_kenh_noi_bo a
        SET 
            thang = TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'yyyymm')),
            (ma_nv, ma_pb) = (
                SELECT b.ma_nv, b.ma_pb
                FROM ttkd_bsc.nhanvien b
                WHERE thang = TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'yyyymm'))
                AND LOWER(
                    CASE
                        WHEN INSTR(a.ma, '_') > 0 THEN SUBSTR(a.ma, 1, INSTR(a.ma, '_') - 1)
                        ELSE a.ma
                    END
                ) = SUBSTR(b.MAIL_VNPT, 1, INSTR(b.MAIL_VNPT, '@') - 1)
            )
        WHERE thang is null;

        --username theo dạng mã điểm bán , dòng 20 dùng distinct vì để tìm luôn các ma_nhanvien-delete ( nếu lỗi nhiều dòng thì bỏ distinct thêm tháng cho bảng nhân viên)
        UPDATE ttkd_bsc.ds_diemban_31import b -- Lúc imp bảng này thì vào excel sửa luôn cột STT thành cột tháng
        SET manv_hrm = (SELECT distinct ma_nv 
                        FROM ttkd_bsc.nhanvien d
                        WHERE 
                            LOWER(
                CASE
                    WHEN INSTR(B.ma_nhanvien, '_') > 0 THEN
                        SUBSTR(B.ma_nhanvien, 1, INSTR(B.ma_nhanvien, '_') - 1)
                    ELSE
                        B.ma_nhanvien
                END
            ) = SUBSTR(D.MAIL_VNPT, 1, INSTR(D.MAIL_VNPT, '@') - 1)
                        )
                            
        WHERE b.thang = TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'yyyymm')) AND b.manv_hrm is NULL;



        --======update manv_ptm
        update SSS_dgia_202408 b
        set TIEN_GOI = ( select a.GIAGOI_SAUCK_COVAT from MANPN.BSCC_INSERT_DM_KIT_BUNDLE a where a.ten_goi = b.ten_goi)
        where tien_goi is null and (nguon = 'bundle_xuatkho' or nguon = 'bundle')
        ;
        update SSS_dgia_202408
        set TIEN_THULAO_DNHM = 20000
        where tenkieu_ld = 'ptm'
        ;
        update SSS_dgia_202408 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202408 and b.USER_CCBS = a.username_kh)
        where manv_ptm is null
        ;
        update SSS_dgia_202408 a
        set MANV_PTM = (select b.ma_nv from ttkd_bsc.nhanvien b where b.thang = 202408 and b.USER_CCOS = a.username_kh)
        where manv_ptm is null
        ;
        update SSS_dgia_202408 a
        set MANV_PTM = (select b.ma_nv from SSS_kenh_noi_bo b where b.thang = 202408 and b.SO_ELOAD = a.username_kh)
        where manv_ptm is null
        ;
        MERGE INTO SSS_dgia_202408 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = d.ma_diem_ban AND d.thang = 202408)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.manv_ptm IS NULL;
            
            MERGE INTO SSS_dgia_202408 a
        USING ttkd_bsc.ds_diemban_31import d
        ON (a.username_kh = to_char(d.so_eload) AND d.thang = 202408)
        WHEN MATCHED THEN
            UPDATE SET a.manv_ptm = d.manv_hrm
            WHERE a.manv_ptm IS NULL;
            
        UPDATE SSS_dgia_202408 a
        SET MANV_PTM = (
            SELECT b.ma_nv 
            FROM ttkd_bsc.nhanvien b
            WHERE username_kh = b.ma_nv and thang = 202408
        )
        WHERE a.manv_ptm IS NULL;
        update SSS_dgia_202408
        set TENNV_PTM = (select b.ten_nv from ttkd_bsc.nhanvien b where b.thang = 202408 and manv_Ptm = b.ma_nv)
        ;

        --=====checkNoiBo --> UPDATE cột kenh_trong? 

                  UPDATE SSS_dgia_202408 a
        SET KENH_TRONG = 1
        WHERE EXISTS (
            SELECT 1 
            FROM ttkd_bct.va_dm_loaikenh_bh b
            WHERE b.ma_nd = a.username_kh 
            AND b.thang = 202408 
            AND b.LOAIKENH = 'Nội bộ'
        );
        --==
         merge into SSS_dgia_202408 a
        using ttkd_bct.va_dm_loaikenh_bh x
        on (a.username_kh = x.ma_nd and x.thang = 202408)
        when matched then 
            update set a.phan_loai_kenh = x.phanloai_kenh
            where a.phan_loai_kenh is null


