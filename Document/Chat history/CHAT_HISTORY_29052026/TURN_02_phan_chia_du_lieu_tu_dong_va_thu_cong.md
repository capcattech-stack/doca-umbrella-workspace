#### 🙋‍♂️ **Người dùng hỏi:**
> Vậy trong các dữ liệu chung ta đã nhắc đến đâu là dữ liệu lấy tự động đâu lf dữ liệu người vận hành cần chuẩn bị và chuẫn bị thế nào ? Kiến trúc dữ liệu ra sao ?

#### 🤖 **Đặc vụ phản hồi (Sophia & Alan & Leo):**
Chúng tôi đã khởi tạo tài liệu đặc tả chuyên sâu mới: **[SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md)** để phân rã cấu trúc:
*   **Dữ liệu Tự động (Automated Data):** GPS làm tròn, OpenWeatherMap API, trạng thái vận động (`flutter_activity_recognition`), nhịp sinh học, ký ức trích xuất ngầm, và iTunes Search API.
*   **Dữ liệu Người vận hành (Curated Data):** Bản tin văn hóa vùng miền (CMS), danh mục sách & affiliate link, danh mục nhạc hoài cổ, và bản tin tĩnh 4 mùa offline.
*   **Kiến trúc CSDL:** SQLite cục bộ (`owner_memory_vault`, `offline_events_cache`, `baked_seasonal_trivia`) kết hợp Cloud Postgres DB.
