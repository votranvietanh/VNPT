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



    -- Kiểm tra sự thay đổi của từng cột, hàm NVL để trigger so sánh được với NULL
     IF NVL(:OLD.CHITIEU_GIAO, 0) != NVL(:NEW.CHITIEU_GIAO, 0) OR
       NVL(:OLD.GIAO, 0) != NVL(:NEW.GIAO, 0) OR
       NVL(:OLD.THUCHIEN, 0) != NVL(:NEW.THUCHIEN, 0) OR
       NVL(:OLD.TYLE_THUCHIEN, 0) != NVL(:NEW.TYLE_THUCHIEN, 0) OR
       NVL(:OLD.MUCDO_HOANTHANH, 0) != NVL(:NEW.MUCDO_HOANTHANH, 0) OR
       NVL(:OLD.DIEM_CONG, 0) != NVL(:NEW.DIEM_CONG, 0) OR
       NVL(:OLD.DIEM_TRU, 0) != NVL(:NEW.DIEM_TRU, 0) THEN

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
