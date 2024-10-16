------TTKD_BSC---- 
CREATE OR REPLACE TRIGGER ttkd_bsc.trg_bangluong_kpi_audit
AFTER UPDATE ON ttkd_bsc.bangluong_kpi
FOR EACH ROW
DECLARE
    v_sql_text VARCHAR2(4000);
    v_session_id VARCHAR2(100);
    v_commit_id VARCHAR2(100);
    v_time_commit TIMESTAMP;
BEGIN
    -- Lấy session ID hiện tại
    v_session_id := SYS_CONTEXT('USERENV', 'SESSIONID');

    -- Lấy ID của transaction hiện tại
    v_commit_id := DBMS_TRANSACTION.LOCAL_TRANSACTION_ID(FALSE);
    v_time_commit := SYSTIMESTAMP;



    -- Kiểm tra sự thay đổi của từng cột
    IF :OLD.CHITIEU_GIAO != :NEW.CHITIEU_GIAO OR :OLD.GIAO != :NEW.GIAO OR :OLD.THUCHIEN != :NEW.THUCHIEN OR :OLD.TYLE_THUCHIEN != :NEW.TYLE_THUCHIEN OR
       :OLD.MUCDO_HOANTHANH != :NEW.MUCDO_HOANTHANH OR :OLD.DIEM_CONG != :NEW.DIEM_CONG OR :OLD.DIEM_TRU != :NEW.DIEM_TRU THEN

        -- Ghi tất cả các cột vào bảng audit khi có bất kỳ thay đổi nào
        INSERT INTO ttkd_bsc.bangluong_kpi_audit (
            THANG, MA_KPI, TEN_KPI, MA_NV, TEN_NV, MA_VTCV, TEN_VTCV, MA_TO, TEN_TO, MA_PB, TEN_PB, NGAYCONG,
            TYTRONG, DONVI_TINH, CHITIEU_GIAO, GIAO, THUCHIEN, TYLE_THUCHIEN, MUCDO_HOANTHANH, DIEM_CONG, DIEM_TRU, GHICHU,
            NGAY_PUBLIC, NGAY_DEADLINE, MANV_PUBLIC, MANV_APPLY, NGAY_APPLY, sql_text, session_id, commit_id,changed_by,changed_on
        )
        VALUES (
             :OLD.THANG, :OLD.MA_KPI,:OLD.ten_kpi, :OLD.MA_NV, :OLD.TEN_NV, :OLD.MA_VTCV, :OLD.TEN_VTCV, :OLD.MA_TO, :OLD.TEN_TO,
            :OLD.MA_PB, :OLD.TEN_PB, :OLD.NGAYCONG, :OLD.TYTRONG, :OLD.DONVI_TINH, :OLD.CHITIEU_GIAO, :OLD.GIAO, :OLD.THUCHIEN,
            :OLD.TYLE_THUCHIEN, :OLD.MUCDO_HOANTHANH, :OLD.DIEM_CONG, :OLD.DIEM_TRU, :OLD.GHICHU, :OLD.NGAY_PUBLIC, :OLD.NGAY_DEADLINE,
            :OLD.MANV_PUBLIC, :OLD.MANV_APPLY, :OLD.NGAY_APPLY, v_sql_text, v_session_id, v_commit_id,user,v_time_commit
        );
    END IF;
END;
/
