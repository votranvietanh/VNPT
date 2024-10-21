#HDSD đang làm xuất file từ oracle, tên file đặt theo quy ước 3 chữ cái: đầu giữa cuối, mỗi lần chạy code phải sửa tháng #EDIT_1 và #EDIT_2

import ftplib
import os

# Thông tin đăng nhập FTP
ftp_host = '10.70.115.98'  # Thay đổi với địa chỉ FTP của bạn
ftp_user = 'anhvtv'        # Thay đổi với tên người dùng của bạn
ftp_pass = 'Ktnv#768'      # Thay đổi với mật khẩu của bạn

# Danh sách các file cần chuyển và tên file đích
files_and_directories = {
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/BCH.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVBinhChanh/BCH_CHITIET_TIEUDUNG_202407.xlsx', #EDIT_1
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/CCI.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVCuChi/CCI_CHITIET_TIEUDUNG_202407.xlsx',
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/CLN.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVChoLon/CLN_CHITIET_TIEUDUNG_202407.xlsx',
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/GDH.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVGiaDinh/GDH_CHITIET_TIEUDUNG_202407.xlsx',
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/HMN.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVHocMon/HMN_CHITIET_TIEUDUNG_202407.xlsx',
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/NSG.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVNamSaiGon/NSG_CHITIET_TIEUDUNG_202407.xlsx',
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/SGN.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVSaiGon/SGN_CHITIET_TIEUDUNG_202407.xlsx',
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/TBH.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVTanBinh/TBH_CHITIET_TIEUDUNG_202407.xlsx',
    'J:/sqldeveloper/sqldeveloper/bin/07_2024/TDC.xlsx': '/PhongKyThuatNghiepVu/Public/BHKVThuDuc/TDC_CHITIET_TIEUDUNG_202407.xlsx'
}

subdirectory_name = '07-2024'  # EDIT_2

try:
    # Kết nối đến FTP
    ftp = ftplib.FTP(ftp_host)
    ftp.login(ftp_user, ftp_pass)

    for local_file, ftp_target_path in files_and_directories.items():
        # Kiểm tra xem file có tồn tại không
        if os.path.exists(local_file):
            # Phân tách đường dẫn đích trên FTP thành thư mục và tên file
            ftp_target_directory, ftp_target_filename = os.path.split(ftp_target_path)

            # Chuyển đến thư mục đích trên FTP
            try:
                ftp.cwd(ftp_target_directory)
            except ftplib.error_perm:
                # Nếu thư mục không tồn tại, tạo thư mục mới
                directories = ftp_target_directory.strip('/').split('/')
                for directory in directories:
                    try:
                        ftp.mkd(directory)  # Tạo thư mục
                    except ftplib.error_perm:
                        pass  # Nếu thư mục đã tồn tại thì bỏ qua
                    ftp.cwd(directory)  # Chuyển vào thư mục đã tạo

            # Kiểm tra và tạo thư mục con "09-2024" nếu chưa tồn tại
            try:
                ftp.cwd(subdirectory_name)  # Thử chuyển vào thư mục con
            except ftplib.error_perm:
                # Nếu thư mục con không tồn tại, tạo nó
                ftp.mkd(subdirectory_name)
                ftp.cwd(subdirectory_name)  # Chuyển vào thư mục con vừa tạo

            # Mở file để đọc
            with open(local_file, 'rb') as file:
                # Chuyển file lên FTP với tên mới
                ftp.storbinary(f'STOR {ftp_target_filename}', file)
                print(f'Đã chuyển {os.path.basename(local_file)} lên {ftp_target_directory}/{subdirectory_name} thành {ftp_target_filename}.')
        else:
            print(f'File không tồn tại: {local_file}')

    # Ngắt kết nối
    ftp.quit()

except ftplib.all_errors as e:
    print('Lỗi FTP:', e)
