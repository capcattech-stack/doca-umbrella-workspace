# ĐẶC TẢ CHI TIẾT 04: BỘ PHÂN LOẠI KHÔNG GIAN - THỜI GIAN VỔ HÌNH
*(INVISIBLE TEMPORAL GEOSPATIAL CLASSIFIER)*

> **Mã Đặc Tả:** `SPEC-COZY-04`  
> **Chủ trì:** Alan (Tech Lead) & Arthur (Tập tính học hành vi)  
> **Trạng thái:** Hoàn tất đồng bộ (Đã sửa đổi đối kháng - KHÔNG chạy ngầm polling)

---

## 🧭 1. Thiết Kế "Không Giao Diện" (Zero UI Design)

Việc bắt người dùng phải cài đặt tọa độ "Nhà riêng" hay "Cơ quan" trên giao diện thủ công là một trải nghiệm **gượng ép và gây phòng thủ tâm lý**. 

Với Capcat, giao diện định vị này sẽ hoàn toàn biến mất. Chúng ta xác định tọa độ một cách tự nhiên dựa trên **thuật toán tự học vị trí khi mở app (Foreground-Only Clustering)** kết hợp **đối chiếu thời gian thực tế** và dán nhãn theo độ tuổi của Sen.

---

## ⚙️ 2. Thuật Toán Phân Loại Cục Bộ (Temporal Spatial Inference)

Để lấy được tọa độ và dán nhãn thông minh mà không làm hao pin và không bị hệ điều hành iOS/Android chặn hoạt động ngầm:

### 2.1. Gom cụm toạ độ khi mở app (Foreground Event Clustering)
*   **HỦY BỎ Background Workmanager & Geofencing Polling:** Không khởi động tiến trình chạy ngầm định vị vào ban đêm hay ban ngày.
*   **Cơ chế ghi nhận (Foreground Sampling):** 
    *   Mỗi khi người dùng chủ động **mở ứng dụng** (Foreground Session), hệ thống âm thầm ghi nhận một bản ghi dữ liệu cục bộ gồm: `{ timestamp: DateTime.now(), latitude: current_lat, longitude: current_lng }` vào bảng SQLite `local_location_logs`.
    *   Hành động lấy tọa độ này diễn ra dưới 0.2 giây, công suất cực thấp và không ảnh hưởng đến RAM/UI.

### 2.2. Gom cụm tự học & Dán nhãn theo độ tuổi (Age-Based Semantic Tagging)
Sau 3-5 ngày tích lũy dữ liệu khi mở app, một luồng xử lý cục bộ siêu nhẹ sẽ tự động chạy ngầm trên RAM khi người dùng đang ở trạng thái Idle để phân loại vị trí:
1.  **Xác định Nhà riêng (Home):** Gom các bản ghi toạ độ được tạo ra vào khoảng thời gian **10h tối - 5h sáng**. Nếu các tọa độ này hội tụ trong bán kính 100m -> Khóa điểm centroid này làm `🏠 Nhà riêng`.
2.  **Xác định Địa điểm Ban ngày (Day Location):** Gom các bản ghi toạ độ được tạo ra vào khoảng **9h sáng - 5h chiều**. Nếu chúng hội tụ trong bán kính 100m -> Khóa điểm centroid này làm địa điểm ban ngày.
3.  **Dán nhãn thông minh theo độ tuổi (Age Inference):**
    *   Đọc thông tin tuổi của Sen trong Profile (`userProfile.birthday`):
    *   *Trường hợp A: Tuổi < 22 (Học sinh / Sinh viên):* Tự động dán nhãn tọa độ ban ngày là **`🏫 Trường học`**.
    *   *Trường hợp B: Tuổi >= 22 (Người trưởng thành):* Tự động dán nhãn tọa độ ban ngày là **`💼 Cơ quan / Công ty`**.

---

## 🎭 3. Kịch Bản Biến Thiên Hội Thoại Thăng Hoa Của Maya & Arthur

Một khi hệ thống đã dán nhãn ngầm thành công từ dữ liệu cache khi mở app, cuộc trò chuyện giữa Sen và Boss sẽ "biến thiên" đầy bất ngờ dựa trên vị trí thực tế của Sen khi họ mở app hoặc khi gửi notification hẹn giờ cục bộ:

### 3.1. Kịch bản dành cho Học sinh / Sinh viên (Tuổi < 22 - Nhãn: Trường học)
*   **Khi Sen tan học mở app lúc 5:30 PM:**
    *   *Boss nhắn:* `"Sen vừa tan học đúng không? Hôm nay đi học có bị thầy cô phạt đứng góc lớp không ta? Mau về nhà bế trẫm đi nào! 🐾"`
*   **Khi Sen học bài muộn ở nhà mở app lúc 12:00 AM:**
    *   *Boss nhắn:* `"12h đêm rồi mà Sen vẫn ở nhà chong đèn học bài hả? Thi cử áp lực quá đúng không... Lại đây trẫm cho tựa đầu vào bụng ngủ gật tí nè. 💕"`

### 3.2. Dành cho Người đi làm (Tuổi >= 22 - Nhãn: Cơ quan)
*   **Khi Sen rời Cơ quan mở app lúc 6:00 PM:**
    *   *Boss nhắn:* `"Sen vừa tan sở đúng không? Cả ngày chạy deadline sấp mặt mệt lắm rồi đúng không... Đi đường cẩn thận nha, về nhà trẫm sưởi ấm cho Sen! 🐾"`
*   **Khi Sen làm tăng ca muộn tại Cơ quan mở app lúc 9:30 PM:**
    *   *Boss nhắn lo lắng:* `"Hơn 9h đêm rồi mà Sen vẫn ở công ty tăng ca hả? Việc nhiều quá hay sao thế... Đừng cố quá kiệt sức nha Sen, trẫm lo lắm đó. 🥺"`
