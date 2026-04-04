# Hướng dẫn chạy dự án (Run Guide)

Tài liệu này hướng dẫn chi tiết từng bước để khởi chạy database, nạp dữ liệu thô, thực hiện dbt data transformation và kết nối thẳng với Power BI để trực quan hóa.

---

## Bước 1: Khởi động PostgreSQL (Docker)
Dự án sử dụng docker-compose để host một PostgreSQL database local.
1. Đảm bảo bạn đã cài và bật **Docker Desktop**.
2. Mở Terminal (Command Prompt / PowerShell) ở thư mục dự án `Ecommerce-Customer-Analytics-dbt`.
3. Chạy lệnh sau để khởi động Postgres:
   ```bash
   docker-compose up -d
   ```
   *Database `online_retail` sẽ được chạy trên `localhost:5432` với user: `dbt_user` và password: `dbt_password`.*

---

## Bước 2: Chuẩn bị môi trường Python & Load dữ liệu thô (Raw Data)
Cần nạp dữ liệu từ file csv (`online_retail_II.csv`) vào database bằng Python.
1. Activate môi trường ảo (virtual environment) của bạn:
   ```powershell
   .\.venv\Scripts\activate
   ```
2. Đảm bảo mọi thư viện cần thiết đã có sẵn (đặc biệt là `psycopg2` để Python nói chuyện được với Postgres):
   ```bash
   pip install -r requirements.txt
   ```
3. Chạy file script load dữ liệu:
   ```bash
   python scripts/load_csv.py
   ```
   *Script này sẽ báo thành công và log ra số lượng dòng đã load (khoảng 1 triệu records).*

---

## Bước 3: Chạy dbt pipeline (Transformation)
Dữ liệu đang ở bảng raw. Giờ chúng ta gọi dbt để làm sạch, xử lý và tạo ra các Mart tables (Bảng tổng hợp).
Vẫn trong môi trường virtual environment:
1. Đảm bảo dbt có thể kết nối được với database:
   ```bash
   dbt debug
   ```
   *Phải thấy chữ `All checks passed!`*
2. Chạy toàn bộ pipeline của dự án (tạo staging, fact, dim và analytics):
   ```bash
   dbt run
   ```
3. *(Tuỳ chọn)* Chạy test để đảm bảo dữ liệu không bị lỗi logic:
   ```bash
   dbt test
   ```

---

## Bước 4: Kết nối Power BI với PostgreSQL
Khi thư mục dbt chạy xong, dữ liệu "vàng" (Gold Layer) đã sẵn sàng trong schema `public`.

1. Khởi động ứng dụng **Power BI Desktop**.
2. Trên Ribbon ở trang Home, chọn **Get Data** (Lấy dữ liệu) -> Chọn **More...** (Thêm...).
3. Chọn mục **Database** (Cơ sở dữ liệu) bên trái -> Chọn **PostgreSQL database** -> Bấm **Connect**.
4. Điền thiết lập máy chủ:
   - **Server**: `localhost` (hoặc `localhost:5432`)
   - **Database**: `online_retail`
   - **Data Connectivity mode**: Bạn có thể chọn `Import` (nhập thẳng vào PowerBI để nhanh nhất) hoặc `DirectQuery`.
   - Bấm **OK**.
5. Màn hình yêu cầu đăng nhập Database sẽ hiện ra:
   - Tab bên trái chọn **Database** (không phải Windows).
   - **User name**: `dbt_user`
   - **Password**: `dbt_password`
   - Bấm **Connect**. (Nếu có báo Security Exception Encryption thì cứ bấm OK/Accept).
6. Ở màn hình **Navigator**:
   - Bạn thả thư mục `public` xuống.
   - Chọn các views/tables có hậu tố ở mục `analytics` hoặc các `dim_` / `fact_`. Đặc biệt chú ý các bảng sau để làm báo cáo:
     - `product_performance_metrics`
     - `geographic_sales_metrics`
     - `daily_sales_performance`
     - `customer_segment_metrics`
   - Hoặc nếu bạn muốn trực tiếp Query SQL để kiểm soát đầu vào: Lúc ở màn hình Get Data -> PostgreSQL, bạn ấn vào dòng **Advanced options** (Tùy chọn nâng cao) -> Paste các câu SQL trong file `bi/bi_queries.md` vào phần SQL Statement.
7. Bấm **Load** (hoặc **Transform Data** nếu cần chỉnh thêm gì đó) và bắt đầu kéo thả Dashboard vẽ biểu đồ!
