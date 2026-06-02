# ĐẶC TẢ CHI TIẾT 05: COZY FREQUENCY COMPASS
*(BỘ ĐIỀU PHỐI TẦN SUẤT & CHỐNG VỒ VẬP)*

> **Mã Đặc Tả:** `SPEC-COZY-05`  
> **Chủ trì:** Sophia (CPO / PM) & Arthur (Tập tính học hành vi)  

---

## 🧭 1. Triết Lý "Boss Độc Lập, Bạn Đồng Hành Chữa Lành"

Sự vồ vập quá mức (hyper-activeness) của các thông điệp cảm biến thông minh sẽ phá nát không gian tĩnh lặng chữa lành của thể loại Iyashikei. Thú cưng ngoài đời thực dành 16 tiếng mỗi ngày để ngủ và rất độc lập. Boss ảo của Capcat cũng phải giữ phong thái **yên bình, chậm rãi** và chỉ cất tiếng vào những khoảnh khắc đắt giá nhất.

---

## ⚙️ 2. Hệ Thống Vòng Lặp Kép Phân Phối Tần Suất (Dual-Mode Chat Loop)

Để đảm bảo tính tinh tế tuyệt đối, hệ thống tách biệt trải nghiệm trò chuyện thành 2 chế độ phản hồi dựa trên trạng thái phiên tương tác của người dùng:

### 2.1. Vòng lặp trò chuyện chủ động (Active Chat Loop - Khi mở màn hình chat)
*   **Trễ phản hồi nhanh (2-4 giây):** Khi người dùng đang mở màn hình chat và gửi tin nhắn, Boss AI sẽ phản hồi sau **2-4 giây** ngẫu nhiên.
*   **Hiệu ứng ba chấm (Typing Indicator):** Trong khoảng thời gian chờ 2-4 giây này, ứng dụng bắt buộc hiển thị bong bóng thoại ba chấm gõ chữ nhấp nháy chuyển động nhẹ nhàng để tạo cảm giác Boss đang suy nghĩ tự nhiên, đồng thời duy trì Dopamine hội thoại cho Sen.
*   **Xử lý khi thoát màn hình:** Nếu người dùng gửi tin nhắn và lập tức thoát ứng dụng trước khi Boss phản hồi xong, hệ thống sẽ tự động chuyển đổi tin nhắn này thành một tin nhắn của luồng Passive và gửi qua thông báo đẩy sau.

### 2.2. Vòng lặp tự phát ngoài app (Passive Chat Loop - Cozy Delay Buffer)
*   **Ngắt gửi tức thì:** Khi cảm biến mở app (Foreground) ghi nhận một dấu mốc đặc biệt của Sen (Ví dụ: Về nhà muộn sau 9h tối, Đi dạo lúc hoàng hôn), hệ thống **tuyệt đối không gửi tin nhắn ngay lập tức** vì điều này tạo cảm giác rình rập, giả tạo.
*   **Bộ đệm trễ ngẫu nhiên ngoài app (15 - 45 phút):** Hệ thống áp dụng một bộ đệm trễ ngẫu nhiên từ 15 đến 45 phút kể từ thời điểm ghi nhận dấu mốc hoặc sau khi Sen đã đóng app.
*   **Thông báo tự phát (Spontaneous Opener):** Lời mở lời tự phát sẽ được gửi qua Local Push Notification màn hình khóa. Tối đa chỉ **1 tin nhắn tự phát/ngày** để kéo Sen quay lại ứng dụng một cách ấm áp, tinh tế.

### 2.3. Cấp độ thân mật khống chế tần suất (Intimacy Gating)
*   **Cấp độ 1 - 2 (Bạn mới):** `Không gửi thông báo ngoài app`. Cảm biến chỉ phục vụ tối ưu hóa thoại *bên trong* màn hình chat khi Sen chủ động mở.
*   **Cấp độ 3 - 4 (Thân thiết):** Tối đa `1 tin nhắn/48 giờ` cho các sự kiện cơ bản ngoài app (Về nhà sớm, đi dạo).
*   **Cấp độ 5+ (Tri kỷ):** Tối đa `1 tin nhắn/24 giờ` cho các sự kiện nhạy cảm ngoài app (Về nhà rất muộn, mất ngủ lúc 2h sáng).

---

## 🎵 3. Thiết Kế Âm Thanh & Rung Purring
*   **Chuông gió thì thầm:** Âm thanh thông báo được thiết kế riêng với các tiếng gõ thanh gỗ nhẹ dịu hoặc tiếng chuông gió đung đưa rất khẽ, tránh hoàn toàn các tiếng chuông hệ thống mặc định gắt tai.
*   **Rung hơi thở mèo (Purring Haptic):** Nhịp rung thông báo nhẹ dịu, ngắt quãng mô phỏng hoàn hảo nhịp thở ấm áp của chú mèo đang ngủ say.
