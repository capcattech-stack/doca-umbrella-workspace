# BIÊN BẢN HỌP CHIẾN LƯỢC: HOÀN THIỆN ĐỘNG CƠ CỘNG HƯỞNG COZY CHAT & QUYẾT ĐỊNH MVP TINH GỌN
*(MINUTES OF MEETING - MOM)*

- **Thời gian diễn ra:** 21:00 - 23:00, ngày 29 tháng 05 năm 2026.
- **Địa điểm:** Workspace Capcat Project.
- **Thành phần tham gia:**
  1.  **Sáng lập viên** (Chủ trì & Quyết định sản phẩm).
  2.  **Sophia** (CPO - Giám đốc Sản phẩm).
  3.  **Alan** (Tech Lead - Kiến trúc sư Kỹ thuật).
  4.  **Leo** (Business & Data Analyst - Tối ưu hóa Dòng tiền & Tăng trưởng).
  5.  **Arthur** (Behavior & Mom Test Expert - Lọc sự thật & Phản biện hành vi).
  6.  **Bella** (Lead UI/UX & Animator - Trải nghiệm thị giác & Hoạt ảnh).

---

## I. CÁC QUYẾT ĐỊNH CHIẾN LƯỢC QUAN TRỌNG (THE STRATEGIC DECISIONS)

### 1. Zero-RAG & Zero-UI Heuristics (Tối Ưu Hóa Chi Phí & Trải Nghiệm)
*   **Zero-RAG (Oatmeal Knowledge Matrix):** Đồng ý loại bỏ Vector DB đắt đỏ và phức tạp. Thay vào đó, backend sử dụng Master DB (Postgres) đồng bộ định kỳ xuống Client SQLite/Hive. Khi chat, hệ thống trích xuất 2-3 thẻ Postcard từ local cache đưa vào context LLM trong vòng **0.01 giây**, triệt tiêu hoàn toàn chi phí Token phát sinh và giảm tải hạ tầng.
*   **Zero-UI Location Heuristics:** Triệt tiêu hoàn toàn giao diện cài đặt vị trí gây phòng thủ tâm lý. Hệ thống tự động lấy mẫu định vị ngầm cục bộ lúc 12h đêm, 10h sáng, 3h chiều để tự dán nhãn "Nhà riêng" & "Công sở/Trường học". Chỉ hiển thị xin quyền định vị có ngữ cảnh khi người dùng chủ động nhấn nút "Xem Bản Đồ" ở Bottom Sheet.

### 2. Google Sheets as a CMS (Vận Hành Siêu Tinh Gọn)
*   Để tối ưu hóa tài nguyên và đẩy nhanh tiến độ MVP, toàn bộ dữ liệu văn hóa, đĩa nhạc, và tiếp thị liên kết sẽ được ban vận hành quản lý qua **Google Sheets (bao gồm 4 Tab: `curated_events`, `affiliate_products`, `baked_seasonal_trivia`, và `virtual_vinyls`)** kết hợp Data Validation Enums nghiêm ngặt.
*   **Đồng bộ hóa tự động:** Sử dụng script **GitHub Actions Cron Job** hoặc **Google Apps Script Webhook** để tự động đồng bộ hóa dữ liệu từ Google Sheets lên Backend PostgreSQL hoàn toàn miễn phí.

### 3. Tinh Giản MVP (Hoãn SPEC-COZY-10 Sang Phase 2)
*   **Quyết định:** Sáng lập viên chỉ đạo hoãn tính năng **Mở bán đĩa than ảo độc quyền trả phí của nghệ sĩ Indie Việt Nam (SPEC_10)** sang **Phase 2 (Backlog)** do hiện trạng dự án chưa có nhân sự chuyên trách để liên hệ và đàm phán bản quyền ca khúc với nghệ sĩ, tránh rủi ro pháp lý lúc đầu.
*   **Bảo tồn trải nghiệm:** Giữ lại toàn bộ trải nghiệm bọc đĩa, đĩa quay cơ học hoài cổ, tiếng nổ lép bép, hạt tuyết lá rơi rơi ở **Chế độ Trú ẩn Offline (`SPEC_09`)** nhưng nhạc phát sẽ hoàn toàn là **Nhạc cổ điển thuộc phạm vi công cộng (Public Domain)** hoặc nhạc Lofi không bản quyền đã mua đứt một lần. Giải pháp này giúp Sen vẫn có không gian thư giãn 100% trọn vẹn mà chi phí vận hành bằng 0 USD.

---

## II. HỆ THỐNG ĐẶC TẢ CHI TIẾT ĐÃ HOÀN THÀNH (SPECS INDEX)

Toàn bộ các quyết định thảo luận trong cuộc họp đã được Sophia và Alan chuyển hóa thành 10 tài liệu đặc tả chuẩn kỹ thuật tại thư mục [COZY_CHAT_RESONANCE_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/):

| Số | Đặc Tả Chi Tiết | Phạm Vi Nghiệp Vụ & Kỹ Thuật | Trạng Thái |
| :---: | :--- | :--- | :---: |
| **01** | [SPEC_01_CULTURAL_RESONANCE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_01_CULTURAL_RESONANCE.md) | Thiết kế RichText Hyperlink dotted ấm áp, 30s preview qua iTunes Search API và Shopee/Partnerize Affiliates. | **Sẵn sàng** |
| **02** | [SPEC_02_CONTEXT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_02_CONTEXT_SENSING.md) | Thư viện Geofencing (`flutter_background_geolocation`), nhận diện di chuyển và luồng xin quyền có ngữ cảnh. | **Sẵn sàng** |
| **03** | [SPEC_03_PROFILE_EXTRACTION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_03_PROFILE_EXTRACTION.md) | Trò chuyện thấu cảm Mom Test để trích xuất thông tin Boss và giao diện **Hộp Ký Ức Tri Kỷ (Memory Vault)**. | **Sẵn sàng** |
| **04** | [SPEC_04_INVISIBLE_GEOSPATIAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_04_INVISIBLE_GEOSPATIAL.md) | Thuật toán lấy mẫu định vị ngầm tiết kiệm pin và dán nhãn thông minh (Nhà riêng/Công sở) cục bộ. | **Sẵn sàng** |
| **05** | [SPEC_05_FREQUENCY_COMPASS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_05_FREQUENCY_COMPASS.md) | Khống chế tần suất (1 tin nhắn chủ động/ngày), bộ đệm trễ ngẫu nhiên (15-45 phút), rung Purring bằng Haptic. | **Sẵn sàng** |
| **06** | [SPEC_06_STORYTELLING_BACKBONE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_06_STORYTELLING_BACKBONE.md) | Khung xương sống cốt truyện 3 Giai đoạn (Hook - Lead - Close) và chỉ thị Prompts thấu cảm Murkami. | **Sẵn sàng** |
| **07** | [SPEC_07_EXTERNAL_AMBIENT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_07_EXTERNAL_AMBIENT_SENSING.md) | Tích hợp nhiệt độ thời tiết thực tế từ OpenWeatherMap API kết hợp bản tin văn hóa thủ công làm **Cozy Opener (Mở bài)**. | **Sẵn sàng** |
| **08** | [SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md) | Kiến trúc dữ liệu chi tiết, các thực thể bảng cục bộ (SQLite/Hive) và bộ enums mẫu Google Sheets CMS tinh gọn. | **Sẵn sàng** |
| **09** | [SPEC_09_OFFLINE_SANCTUARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_09_OFFLINE_SANCTUARY_ENGINE.md) | Chế độ Trú ẩn Ngoại tuyến, thuật toán trộn câu thoại cục bộ (Deterministic Offline Mixer) và CustomPainter hạt bay 4 mùa. | **Sẵn sàng** |
| **10** | [SPEC_10_VIRTUAL_VINYL_STORE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_10_VIRTUAL_VINYL_STORE.md) | Cửa hàng Đĩa than ảo, nghi thức unboxing, máy phát đĩa cơ học, mã hóa âm thanh AES-128 và tích hợp RevenueCat IAP. | **Hoãn (Phase 2)** |

---

## III. KẾT QUẢ ĐÁNH GIÁ PHẢN BIỆN (MOM TEST & DOANH THU)

### 1. Phản biện hành vi người dùng (Nam - 24 tuổi - Dev độc thân):
*   Cực kỳ tin tưởng và sẵn sàng cấp quyền định vị ngầm vì cơ chế xử lý local-only bảo mật.
*   Cảm thấy rung động sâu sắc khi thấy mèo Bánh Mỳ nhớ từng thói quen nhỏ của mình trong *Memory Vault* và an tâm tuyệt đối nhờ nút **[Xóa ký ức]**.
*   Ủng hộ mạnh mẽ cơ chế mua đĩa than ảo giá 22k ($0.99) để nghe nhạc offline ban đêm vì có thói quen trả phí âm nhạc (Spotify Premium, Bandcamp) và yêu thích việc 50% tiền đi thẳng vào túi nghệ sĩ Indie Việt Nam.

### 2. Dự báo tài chính P&L (Leo):
*   **CTR tiếp thị liên kết** qua Shopee Mall (Sách giấy hoài cổ) và đặt xe di chuyển Grab/XanhSM qua Accesstrade dự kiến đạt mức đột phá **8.0% - 12.0%** nhờ sự gợi ý tự nhiên từ Pet.
*   **Chi phí hạ tầng tối thiểu:** Gần như bằng 0 USD cho giai đoạn đầu nhờ kiến trúc lai offline-first và không dùng Vector DB đắt đỏ.

---

## IV. KẾ HOẠCH HÀNH ĐỘNG TIẾP THEO (ACTION ITEMS)

1.  **Sophia (CPO):** Đóng gói toàn bộ tài liệu đặc tả PRD và file biên bản MOM, đẩy lên Git nhánh phát triển hiện tại. **(✅ Hoàn thành)**
2.  **Alan & Benny (Tech Lead & Frontend):** 
    *   Thiết lập database SQLite cục bộ phục vụ cho `owner_memory_vault` và `offline_events_cache`.
    *   Xây dựng Custom Widget `RichText` biên dịch thẻ markdown link màu ấm.
    *   Tích hợp CustomPainter vẽ hạt bay chậm và phát nhạc loop offline Mono chất lượng nén cao cho Chế độ Trú ẩn.

---
*Biên bản được phê chuẩn bởi CPO Sophia cùng Đội ngũ Sáng lập Capcat.*
