    WITH STT0 AS (select * from manpn.bscc_import_goi_bris where thang = 202409
    and loai_tb_thang = 'HH'
    and loai_giao_dich ='DANGKY' --327K
    )
    SELECT * FROM STT0;
    -- dgia = 0  <=> Các thuê bao có trạng thái P2C trong tháng n và n-1
        Select ma_tb from PL1_2024
            where HINHTHUC_HOAMANG in ('P2C') and thang >= 202408 -- nếu tính dgia tháng 09
        ;
    -- danh sách TB C2P lấy của a Tuyền
_Nâng chu kỳ:
    tính đơn giá cho tb có:
     + USER_KENH_BAN  thuộc kênh nội bộ
     + nếu admin pktnv hoặc GDV quyền admin thì -> tính cho nv yêu cầu admin thực hiện
;
select a.*,a.sothuebao, a.username from TTKDHCM_KTNV.vnp_yeucau a;

    --
    SELECT * FROM PL1_2024;

select distinct USER_KENH_BAN from MANPN.bscc_import_goi_bris where thang = 202409;

select * from nhuy.userld_202409_goc;