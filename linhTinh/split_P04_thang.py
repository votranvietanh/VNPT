import pandas as pd
import ftfy

# Đọc file CSV gốc và chuyển mã sang UTF-8
file_path = 'J:\\VNPT\\Don_gia\\dgia_t10\\T10_new_thanghqkd_kenh_bangoi_n_241108080348.csv'
df = pd.read_csv(file_path, encoding='utf-8')

# Hàm sửa chuỗi nhưng bỏ qua giá trị NaN hoặc None
def fix_text_if_valid(text):
    if pd.isna(text):
        return text
    return ftfy.fix_text(text)



# Số dòng mỗi file
rows_per_file = 1_000_000

# Tính toán số file cần tạo
num_files = len(df) // rows_per_file
if len(df) % rows_per_file != 0:
    num_files += 1  # Tạo thêm 1 file nếu có dòng dư

# Lưu từng phần của DataFrame vào file CSV riêng với mã hóa UTF-8
output_dir = 'J:\\VNPT\\output'
for i in range(num_files):
    start_idx = i * rows_per_file
    end_idx = start_idx + rows_per_file
    df_part = df.iloc[start_idx:end_idx]
    output_file = f'{output_dir}\\part_{i + 1}.csv'
    df_part.to_csv(output_file, encoding='utf-8-sig', index=False)
    print(f'Đã lưu {output_file}')

print("Hoàn thành chuyển mã và tách file.")
