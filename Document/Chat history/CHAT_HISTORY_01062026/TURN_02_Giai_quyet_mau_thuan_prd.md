# TURN 02: GIẢI QUYẾT MÂU THUẪN PRD
*(ADVERSARIAL PRD GAP RESOLUTIONS)*

> **Mã Lượt Chat:** `TURN-01062026-02`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead)

---

## 🙋‍♂️ **Người dùng hỏi:**
> giải quyết các vấn đề vaog PRD nha. nay tôi ko muốn thấy những mâu thuẩn nữa đâu.

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã tiến hành cập nhật trực tiếp toàn bộ các tài liệu PRD đặc tả chi tiết của dự án để giải quyết triệt để 5 điểm mâu thuẫn, điểm gãy và khoảng trống kỹ thuật đã được chỉ ra. Từ nay, bộ tài liệu PRD đã hoàn toàn nhất quán và đồng bộ với triết lý thiết kế tối giản, chữa lành Iyashikei.

Dưới đây là tóm tắt các tệp tài liệu đã được cập nhật trực tiếp:

### 🛠️ Các tài liệu PRD đã được đồng bộ hóa và sửa lỗi:

1.  **[SPEC_02_CONTEXT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_02_CONTEXT_SENSING.md) (Cozy Context Sensing):**
    *   **Thay đổi:** Loại bỏ hoàn toàn Background Geofencing và các thư viện định vị ngầm. 
    *   **Đồng bộ:** Chuyển dịch 100% sang **Foreground Sensing** (chỉ lấy toạ độ và thời tiết thực tế bằng API khi người dùng mở ứng dụng) và lên lịch **Local Push Notification** tự phát khi người dùng vừa tắt app.
2.  **[SPEC_04_INVISIBLE_GEOSPATIAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_04_INVISIBLE_GEOSPATIAL.md) (Invisible Geospatial Classifier):**
    *   **Thay đổi:** Loại bỏ tiến trình ngầm của `workmanager` và `Background Tasks API` vốn được đặc tả để tự động thức dậy lúc nửa đêm/ban ngày.
    *   **Đồng bộ:** Thay thế bằng thuật toán gom cụm toạ độ cục bộ **Foreground Event Clustering** (chỉ sample toạ độ khi người dùng chủ động mở app và tự học vị trí sau 3-5 ngày).
3.  **[SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md) (Offline ML Kit & Sparse Scanning):**
    *   **Thay đổi:** Dọn sạch các đoạn mã trùng lặp thừa thãi và loại bỏ tiến trình quét ngầm hàn
<truncated 762 bytes>

    *   **Đồng bộ:** Chuyển sang đặc tả API Endpoint bảo mật `POST /api/rescue/adopt_request`. Client truyền nickname/nội dung qua JSON được mã hoá, server sẽ tự động trích xuất email từ session an toàn của database và gửi email ngầm về cho Admin.
5.  **[SPEC_05_FREQUENCY_COMPASS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_05_FREQUENCY_COMPASS.md) (Frequency Compass):**
    *   **Thay đổi:** Làm rõ sự mập mờ trong bộ đệm trễ 15-45 phút.
    *   **Đồng bộ:** Tách biệt tường minh hệ thống làm 2 chế độ: **Vòng lặp trò chuyện chủ động (Active Chat Loop)** (phản hồi 2-4 giây kèm typing indicator ba chấm nhấp nháy khi Sen đang trong màn hình chat) và **Vòng lặp tự phát ngoài app (Passive Chat Loop)** (trễ ngẫu nhiên 15-45 phút gửi qua Local Push màn hình khoá).

---

### 🐾 BƯỚC TIẾP THEO

Toàn bộ các tài liệu PRD master và đặc tả chi tiết hiện đã ở trạng thái **Thực tế - Nhất quán - Sẵn sàng lập trình**. Bản ghi chép chi tiết về các lỗ hổng đã được vá cũng đã được lưu tại [prd_gap_analysis.md](file:///Users/macinia/.gemini/antigravity-ide/brain/19e3b348-386d-4b29-b795-a8f4b00d7944/prd_gap_analysis.md).

Bây giờ, chúng ta có thể bắt đầu thảo luận chi tiết cho phân hệ tiếp theo. Bạn muốn đội ngũ tập trung làm rõ tính năng nào:

1.  **Phân hệ Chat thấu cảm (Cozy Chat Resonance):** Cách Boss AI sử dụng ngữ cảnh thời tiết, mùa và các gợi ý Cozy Openers để bắt đầu cuộc trò chuyện.
2.  **Động cơ Buffet Ký ức (Tinder Swipe):** Chi tiết thuật toán tự động sinh thơ 4 thành phần (4-Part Poetic Stacking) ngay trên thiết bị mà không tốn chi phí API.
3.  **Hạ tầng Hòm thư Namiya:** Thiết kế database cục bộ và quy trình Admin phản hồi thư qua Google Sheets CMS.
