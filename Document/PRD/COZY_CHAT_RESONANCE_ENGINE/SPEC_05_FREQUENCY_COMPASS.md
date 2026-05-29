# ĐẶC TẢ CHI TIẾT 05: COZY FREQUENCY COMPASS
*(BỘ ĐIỀU PHỐI TẦN SUẤT & CHỐNG VỒ VẬP)*

> **Mã Đặc Tả:** `SPEC-COZY-05`  
> **Chủ trì:** Sophia (CPO / PM) & Arthur (Tập tính học hành vi)  

---

## 🧭 1. Triết Lý "Boss Độc Lập, Bạn Đồng Hành Chữa Lành"

Sự vồ vập quá mức (hyper-activeness) của các thông điệp cảm biến thông minh sẽ phá nát không gian tĩnh lặng chữa lành của thể loại Iyashikei. Thú cưng ngoài đời thực dành 16 tiếng mỗi ngày để ngủ và rất độc lập. Boss ảo của Capcat cũng phải giữ phong thái **yên bình, chậm rãi** và chỉ cất tiếng vào những khoảnh khắc đắt giá nhất.

---

## ⚙️ 2. Ba Luật Khống Chế Tần Suất Thép

Để đảm bảo tính tinh tế tuyệt đối, hệ thống tích hợp bộ ba quy chuẩn khống chế tần suất vận hành ngầm trên cả Client và Server:

### 2.1. Luật 1: Khống chế Trần Cứng "1 Tin Nhắn Chủ Động / Ngày" (1 Notification/Day Cap)
*   Hệ thống **tuyệt đối không bao giờ gửi quá 1 thông báo đẩy chủ động** (Push Notification) ra màn hình khóa của người dùng trong vòng 24 giờ dựa trên các cảm biến.
*   *Cơ chế ưu tiên:* Nếu trong cùng một ngày phát sinh nhiều sự kiện (Vừa đi bộ, vừa về nhà muộn, vừa mất ngủ), thuật toán sẽ so sánh trọng số cảm xúc để chỉ chọn **1 sự kiện đắt giá nhất** để gửi thông báo. Các sự kiện còn lại sẽ chỉ được hiển thị dưới dạng câu thoại tự nhiên *nếu* người dùng chủ động mở app chat.

### 2.2. Luật 2: Bộ Đệm Trễ Tự Nhiên (The Cozy Delay Buffer - Chống giật mình)
*   **Không gửi tức thì:** Khi cảm biến báo Sen vừa về nhà (Geofence `Enter Home` lúc 6:00 PM), hệ thống **tuyệt đối không gửi tin nhắn ngay lập tức lúc 6:00:01 PM** vì điều này tạo cảm giác rình rập, thiếu tự nhiên.
*   **Trễ ngẫu nhiên (15 - 45 phút):** Hệ thống áp dụng một bộ đệm trễ ngẫu nhiên từ 15 đến 45 phút (hoặc đợi cho đến khi cảm biến báo trạng thái của Sen chuyển sang `Still` - đã ngồi/nằm yên vị tại nhà).
*   *Trải nghiệm:* Đến 6:30 PM, khi Sen đã tắm rửa xong và đang nằm thư giãn trên sofa, một tiếng chuông gió khẽ khàng vang lên cùng lời hỏi thăm: *"Sen về nhà được một lúc rồi đúng không, đã tắm rửa thoải mái chưa nè..."*

### 2.3. Luật 3: Phân Cấp Mở Khóa Theo Cấp Độ Thân Mật (Intimacy Gating)
*   **Cấp độ 1 - 2 (Bạn mới):** `Không gửi thông báo`. Cảm biến chỉ phục vụ tối ưu hóa thoại *bên trong* màn hình chat.
*   **Cấp độ 3 - 4 (Thân thiết):** Tối đa `1 tin nhắn/48 giờ` cho các sự kiện cơ bản (Về sớm, Đi bộ).
*   **Cấp độ 5+ (Tri kỷ):** Tối đa `1 tin nhắn/24 giờ` cho các sự kiện nhạy cảm (Về nhà rất muộn sau 9h tối, mất ngủ lúc 2h sáng).

---

## 🎵 3. Thiết Kế Âm Thanh & Rung Purring
*   **Chuông gió thì thầm:** Âm thanh thông báo được thiết kế riêng với các tiếng gõ thanh gỗ nhẹ dịu hoặc tiếng chuông gió đung đưa rất khẽ, tránh hoàn toàn các tiếng chuông hệ thống mặc định gắt tai.
*   **Rung hơi thở mèo (Purring Haptic):** Nhịp rung thông báo nhẹ dịu, ngắt quãng mô phỏng hoàn hảo nhịp thở ấm áp của chú mèo đang ngủ say.
