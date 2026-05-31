#### 🙋‍♂️ **Người dùng hỏi:**
> đội ngũ vận hành có thể sử dụng GG Sheet để cập nhật nội dung và đồng bộ với Databasse vì tôi ko muốn tốn resource portal ở giai đoạn này. Teamplate cũng như enum của từng bản như thế nào ?

#### 🤖 **Đặc vụ phản hồi (Alan & Leo):**
Chúng tôi đã bổ sung chương **Vận hành tinh gọn qua Google Sheets** vào `SPEC_08`:
*   **Các Tab Google Sheets CMS:** 
    1. `curated_events` (Quản lý sự kiện vùng miền).
    2. `affiliate_products` (Quản lý sách/nhạc có gu kèm hoa hồng).
    3. `baked_seasonal_trivia` (Bản tin tĩnh 4 mùa cục bộ).
*   **Enums nghiêm ngặt:** `HobbyCategory`, `City`, `AffiliatePlatform`, `Season`, `TimeOfDay`.
*   **Giải pháp đồng bộ 0đ:** GitHub Actions Cron Job tải CSV mỗi 6 tiếng để parse, validate và UPSERT vào DB hoặc Google Apps Script Webhook đẩy trực tiếp thời gian thực.
