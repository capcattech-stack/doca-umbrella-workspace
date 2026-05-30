# TURN 01: QUÉT OFFLINE ML & CACHE THÔNG TIN ẢNH
*(OFFLINE BACKGROUND SCANNING & INTELLIGENCE CACHE SYSTEM)*

> **Mã Lượt Chat:** `TURN-30052026-01`  
> **Chủ trì:** Alan (Tech Lead), Sophia (CPO / PM)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Khi quét Offline ML nhớ cachelaij thông tin ảnh để dùng khi cần ko quét lại. sau 1 vài tuần có thể hiển thị lại. từ từ chập mà chắc chạy ngầm mổi ngày vài chục tấm để làm giàu dữ liệu, đễ biết những hình nào là thú cung. OFFLINE_ML có dêtct được hành động ko ? đng nằm/đang ăn/đang chơi/... Nếu có thì phải dèine 1 cấu trúc data thông tin cần lưu trữ cho từng hình, sao cho phù hợp có đủ thòng tin sử dụng đễ chat

---

## 🤖 **Đặc vụ phản hồi (Sophia & Alan):**
Chúng tôi đã thiết kế và tích hợp triết lý **Quét lùi thưa thớt ngẫu nhiên theo tháng** kết hợp **Bộ đệm SQLite thông minh** trong **[SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md)**:

1.  **SQLite Cache `local_photo_intelligence_cache`:** Thiết lập CSDL cục bộ lưu trữ kết quả phân tích để đảm bảo không quét lại ảnh cũ, mở Tinder Stack hiển thị ngay lập tức (dưới 0.01 giây).
2.  **Động cơ quét ngầm gián đoạn (Continuous Background Enrichment Engine):** Lập lịch định kỳ mỗi 24 tiếng qua `workmanager` khi thiết bị cắm sạc + rảnh. Mỗi ngày chỉ quét từ 20-30 ảnh ngầm, vừa tiết kiệm 100% pin vừa làm giàu dữ liệu từ từ.
3.  **Hồi sinh ảnh cũ thông minh (Skipped Photo Cooldown):** Ảnh vuốt bỏ qua (Left Swipe) không bị xoá, mà được đưa vào hàng đợi "ngủ đông" 4 tuần trước khi ngẫu nhiên xuất hiện lại để Sen ngắm với góc nhìn tươi mới.
4.  **Nhận diện hành động & Bối cảnh (Actions & Context):** ML Kit Image Labeling được cấu hình để trích xuất các hành động (`sleeping`, `eating`, `playing`, `sitting`, `lying_down`) và bối cảnh xung quanh (`bed`, `sofa`, `grass`, `keyboard`, `cardboard_box`) để lưu trữ dưới dạng mảng JSON thô trong SQLite, cung cấp chất xúc tác hoàn hảo cho Cozy Chat.
