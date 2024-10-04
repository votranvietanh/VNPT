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

