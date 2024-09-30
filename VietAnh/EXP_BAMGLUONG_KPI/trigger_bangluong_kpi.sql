CREATE OR REPLACE TRIGGER trg_audit_bangluong_kpi
AFTER UPDATE ON bangluong_kpi
FOR EACH ROW
DECLARE
    v_sql_text VARCHAR2(4000);
    v_session_id VARCHAR2(100);
    v_audit_id NUMBER;
    v_commit_id VARCHAR2(100);
    v_time_commit TIMESTAMP;
BEGIN
    -- Lấy session ID hiện tại
    v_session_id := SYS_CONTEXT('USERENV', 'SESSIONID');
    
    -- Lấy ID của transaction hiện tại
    v_commit_id := DBMS_TRANSACTION.LOCAL_TRANSACTION_ID(FALSE);
    v_time_commit := SYSTIMESTAMP;

    -- Lấy câu lệnh SQL từ v$sql
    SELECT sql_fulltext INTO v_sql_text
    FROM ttkd_bsc.v_sql
    WHERE sql_id = (SELECT sql_id FROM ttkd_bsc.v_session WHERE audsid = v_session_id);

    -- Lấy audit_id từ sequence
    v_audit_id := audit_id_seq.NEXTVAL;

    -- Kiểm tra sự thay đổi của từng cột
    IF :OLD.GIAO != :NEW.GIAO OR :OLD.THUCHIEN != :NEW.THUCHIEN OR :OLD.TYLE_THUCHIEN != :NEW.TYLE_THUCHIEN OR
       :OLD.MUCDO_HOANTHANH != :NEW.MUCDO_HOANTHANH OR :OLD.DIEM_CONG != :NEW.DIEM_CONG OR :OLD.DIEM_TRU != :NEW.DIEM_TRU THEN
       
        -- Ghi tất cả các cột vào bảng audit khi có bất kỳ thay đổi nào
        INSERT INTO audit_bangluong_kpi (
            audit_id, thang, ma_kpi,ten_kpi, ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, ngaycong,
            tytrong, donvi_tinh, donvi_giao, giao, thuchien, tyle_thuchien, mucdo_hoanthanh, diem_cong, diem_tru, ghichu,
            ngay_public, ngay_deadline, manv_public, manv_apply, ngay_apply, sql_text, session_id, commit_id,changed_by,changed_on
        )
        VALUES (
            v_audit_id, :OLD.THANG, :OLD.MA_KPI,:OLD.ten_kpi, :OLD.MA_NV, :OLD.TEN_NV, :OLD.MA_VTCV, :OLD.TEN_VTCV, :OLD.MA_TO, :OLD.TEN_TO,
            :OLD.MA_PB, :OLD.TEN_PB, :OLD.NGAYCONG, :OLD.TYTRONG, :OLD.DONVI_TINH, :OLD.DONVI_GIAO, :OLD.GIAO, :OLD.THUCHIEN,
            :OLD.TYLE_THUCHIEN, :OLD.MUCDO_HOANTHANH, :OLD.DIEM_CONG, :OLD.DIEM_TRU, :OLD.GHICHU, :OLD.NGAY_PUBLIC, :OLD.NGAY_DEADLINE,
            :OLD.MANV_PUBLIC, :OLD.MANV_APPLY, :OLD.NGAY_APPLY, v_sql_text, v_session_id, v_commit_id,user,v_time_commit
        );
    END IF;
END;
/
