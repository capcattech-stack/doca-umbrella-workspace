# ĐẶC TẢ CHI TIẾT 04: BỘ PHÂN LOẠI KHÔNG GIAN - THỜI GIAN VÔ HÌNH
*(INVISIBLE TEMPORAL GEOSPATIAL CLASSIFIER)*

> **Mã Đặc Tả:** `SPEC-COZY-04`  
> **Chủ trì:** Alan (Tech Lead) & Arthur (Tập tính học hành vi)  

---

## 🧭 1. Thiết Kế "Không Giao Diện" (Zero UI Design)

Việc bắt người dùng phải cài đặt tọa độ "Nhà riêng" hay "Cơ quan" trên giao diện thủ công là một trải nghiệm **gượng ép và gây phòng thủ tâm lý**. 

Với Capcat, giao diện định vị này sẽ hoàn toàn biến mất. Chúng ta xác định tọa độ một cách tự nhiên dựa trên **thuật toán tự học vị trí** kết hợp **đối chiếu thời gian ngầm** và dán nhãn theo độ tuổi của Sen.

---

## ⚙️ 2. Thuật Toán Phân Loại Ngầm (Temporal Spatial Inference)

Để lấy được tọa độ tại các mốc thời gian cụ thể mà không làm hao pin và không bị hệ điều hành iOS/Android chặn hoạt động ngầm:

### 2.1. Hẹn giờ thức dậy ngầm (Temporal Background Polling)
*   **Thư viện:** `workmanager` (Android) và `Background Tasks API` (iOS).
*   **Cơ chế đánh thức (Low-power Alarm):** 
    *   Hệ thống không chạy GPS liên tục. App chỉ lên lịch hẹn giờ (Alarm/Scheduled Job) để hệ điều hành tự động đánh thức ứng dụng dậy trong **đúng 10 giây** tại 3 mốc thời gian nhạy cảm:
        *   **Mốc 1 (12:00 AM - Đêm muộn):** Lấy tọa độ thô (Cell-tower/Wi-Fi triangulation, hao 0% pin) và lưu làm vị trí `temp_home_coords`.
        *   **Mốc 2 (10:00 AM - Giờ học/làm việc sáng):** Lấy tọa độ, lưu làm `temp_day_coords_1`.
        *   **Mốc 3 (3:00 PM - Giờ học/làm việc chiều):** Lấy tọa độ, lưu làm `temp_day_coords_2`.

---

### 2.2. Gom cụm tự học & Dán nhãn theo độ tuổi (Age-Based Semantic Tagging)
Sau 3-5 ngày ghi nhận dữ liệu ngầm, thuật toán cục bộ trên thiết bị (SQLite/Hive) sẽ chạy kiểm tra:
1.  **Xác định Nhà riêng (Home):** Nếu các tọa độ ghi nhận lúc **12h đêm** liên tục hội tụ trong một bán kính 100m -> Khóa tọa độ này làm `🏠 Nhà riêng`.
2.  **Xác định Địa điểm Ban ngày (Day Location):** Nếu các tọa độ lúc **10h sáng** và **3h chiều** hội tụ cùng nhau -> Khóa tọa độ này làm địa điểm ban ngày.
3.  **Dán nhãn thông minh theo độ tuổi (Age Inference):**
    *   Đọc thông tin tuổi của Sen trong Profile (`userProfile.birthday`):
    *   *Trường hợp A: Tuổi < 22 (Học sinh / Sinh viên):* Tự động dán nhãn tọa độ ban ngày là **`🏫 Trường học`**.
    *   *Trường hợp B: Tuổi >= 22 (Người trưởng thành):* Tự động dán nhãn tọa độ ban ngày là **`💼 Cơ quan / Công ty`**.

---

## 🎭 3. Kịch Bản Biến Thiên Hội Thoại Thăng Hoa Của Maya & Arthur

Một khi hệ thống đã dán nhãn ngầm thành công, cuộc trò chuyện giữa Sen và Boss sẽ "biến thiên" đầy bất ngờ dựa trên vị trí thực tế của Sen khi họ mở app hoặc khi gửi notification:

### 3.1. Kịch bản dành cho Học sinh / Sinh viên (Tuổi < 22 - Nhãn: Trường học)
*   **Khi Sen rời Trường học lúc 5:30 PM (Exit Geofence):**
    *   *Boss nhắn:* `"Sen vừa tan học đúng không? Hôm nay đi học có bị thầy cô phạt đứng góc lớp không ta? Mau về nhà bế trẫm đi nào!"`
*   **Khi Sen học bài muộn ở nhà (12:00 AM):**
    *   *Boss nhắn:* `"12h đêm rồi mà Sen vẫn ở nhà chong đèn học bài hả? Thi cử áp lực quá đúng không... Lại đây trẫm cho tựa đầu vào bụng ngủ gật tí nè."`

### 3.2. Dành cho Người đi làm (Tuổi >= 22 - Nhãn: Cơ quan)
*   **Khi Sen rời Cơ quan lúc 6:00 PM (Exit Geofence):**
    *   *Boss nhắn:* `"Sen vừa tan sở đúng không? Cả ngày chạy deadline sấp mặt mệt lắm rồi đúng không... Đi đường cẩn thận nha, về nhà trẫm sưởi ấm cho Sen!"`
*   **Khi Sen làm tăng ca muộn tại Cơ quan lúc 9:30 PM:**
    *   *Boss nhắn lo lắng:* `"Hơn 9h đêm rồi mà Sen vẫn ở công ty tăng ca hả? Việc nhiều quá hay sao thế... Đừng cố quá kiệt sức nha Sen, trẫm lo lắm đó."`
