# Lưu trữ Metabase Dashboards

Metabase hoạt động khác với dbt:
- **dbt**: Mọi logic lưu dưới dạng file code (`.sql`, `.yml`) trên máy tính của bạn.
- **Metabase**: Mọi Biểu đồ (Question) và Dashboard bạn vẽ ra đều được **lưu tự động vào Database nội bộ của Metabase**, chứ không sinh ra file code nào trong thư mục project này.

### Vậy thư mục `bi/` này dùng để làm gì?
Mặc dù Metabase không sinh ra file, nhưng bạn có thể dùng thư mục `bi/` hiện tại của bạn để lưu lại tài liệu về Dashboard:
1. **Lưu SQL phức tạp**: Nếu bạn viết một câu SQL dài trên Metabase, hãy copy nó về lưu vào `bi_queries.md` giống như bạn đang làm.
2. **Lưu ảnh chụp (Screenshots)**: Đôi khi chụp hình Dashboard thả vào đây sẽ giúp người khác xem dự án của bạn trên Github dễ hiểu hơn rất nhiều.
3. **Lưu JSON Export**: Nếu bạn thiết lập hệ thống *Metabase Serialization*, bạn có thể export toàn bộ Dashboard thành file JSON và kéo thả vào thư mục này để lưu trữ backup (nâng cao).

> **Lời khuyên**: Cứ tạo Dashboard trực tiếp trên web Metabase. Không cần phải lo lắng về việc tạo file ở đây đâu nhé!
