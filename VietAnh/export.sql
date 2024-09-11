-- Phải tạo dir mới dùng được https://stackoverflow.com/questions/66689241/ora-29280-invalid-directory-path-using-directory-in-sql-developer
CREATE OR REPLACE DIRECTORY my_dir AS 'J:\VNPT\file_tieu_dung\New folder';

DECLARE
    file_handle UTL_FILE.FILE_TYPE;
BEGIN
    file_handle := UTL_FILE.FOPEN('my_dir', 'test_tieudung.csv', 'W');
 
    UTL_FILE.PUT_LINE(file_handle, 'subscriber_id, ma_bts, ma_pb');
 
    FOR rec IN (SELECT   subscriber_id,ma_pb,ma_bts FROM CUOCVINA.tieudung_BTS_202407_KIEUMOI_T 
                WHERE PBHKV = 'Phong Ban Hang Khu Vuc Nam Sai Gon') 
    LOOP
        UTL_FILE.PUT_LINE(file_handle, rec.subscriber_id || ',' || rec.ma_bts || ',' || rec.ma_pb);
    END LOOP;
  
    UTL_FILE.FCLOSE(file_handle);
END;
/
