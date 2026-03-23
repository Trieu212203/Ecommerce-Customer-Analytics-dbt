# Hướng Dẫn Chạy Project (Run Guide)

Dưới đây là các bước ngắn gọn để chạy toàn bộ quá trình tải dữ liệu và transform bằng **dbt**:

### Bước 1: Chuẩn bị môi trường Python
Đảm bảo bạn đã kích hoạt môi trường ảo (virtual environment) và cài đặt các thư viện cần thiết:
```bash
pip install -r requirements.txt
# Hoặc cài đặt thủ công psycopg2 nếu bị lỗi thiếu thư viện: 
# pip install psycopg2-binary
```

### Bước 2: Tải dữ liệu CSV vào PostgreSQL (Cực Nhanh)
Chạy script dưới đây để tự động tạo schema `raw`, tạo bảng và dùng `COPY` để tải file CSV vào database:
```bash
python scripts/load_csv.py
```
*(Nếu thành công, bạn sẽ thấy log báo số lượng rows đã được load vài giây sau đó).*

### Bước 3: Chạy dbt để Transform Dữ Liệu
Sau khi dữ liệu thô (raw) đã nằm trong database, sử dụng các lệnh dbt để xử lý, làm sạch và nối các bảng:

Kiểm tra kết nối tới Database:
```bash
dbt debug
```

Chạy toàn bộ các model (bao gồm cả staging models vừa sửa):
```bash
dbt run
```

Kiểm tra lỗi dữ liệu (như missing `InvoiceNo` hoặc `CustomerID`):
```bash
dbt test
```

*(Mẹo: Bạn có thể chạy cả `run` và `test` cùng lúc bằng lệnh `dbt build`)* 
