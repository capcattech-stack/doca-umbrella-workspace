# ĐẶC TẢ CHI TIẾT 02: COZY FOREGROUND CONTEXT SENSING FRAMEWORK
*(CẢM BIẾN NGỮ CẢNH CHỮA LÀNH FOREGROUND & HẸN GIỜ CỤC BỘ)*

> **Mã Đặc Tả:** `SPEC-COZY-02`  
> **Chủ trì:** Alan (Tech Lead) & Maya (UX)  
> **Trạng thái:** Hoàn tất đồng bộ (Đã sửa đổi đối kháng - KHÔNG chạy ngầm Geofencing)

---

## 🧭 1. Giác Quan Ngoại Cảm Của Boss (Foreground-Only Sensing)

Để triệt tiêu hao pin và tránh việc hệ điều hành chặn ứng dụng chạy ngầm định vị gây trải nghiệm không an toàn, Capcat **loại bỏ 100% việc quét GPS ngầm dưới nền (Background Geofencing)**. Thay vào đó, hệ thống tích hợp các cảm biến ngầm trên thiết bị di động hoạt động **chỉ khi ứng dụng được mở (Foreground session)** và đồng bộ hóa nhịp sống vật lý của Sen vào hành vi của Boss:

```
       [ Người Dùng Mở Ứng Dụng (Foreground Session) ]
                             │
       ┌─────────────────────┼─────────────────────┐
       ▼                     ▼                     ▼
  [ GPS & Weather ]     [ Active Sensing ]    [ Temporal Memory ]
  - Lấy toạ độ 1 lần     - Kiểm tra hoạt động   - Lập lịch Local
  - Gọi API thời tiết      (Still/Walking)      Push dựa trên giờ
    để nạp Chat Context                         tương tác cuối cùng
```

1.  **Cảm biến thời gian thực khi mở app (Foreground Location & Weather):**
    *   Chỉ khi người dùng mở app, thiết bị mới lấy tọa độ thô (Cell-tower/Wi-Fi công suất cực thấp).
    *   Gọi API thời tiết (OpenWeatherMap) và đối chiếu giờ địa phương để nạp trực tiếp ngữ cảnh môi trường hiện tại của Sen vào cuộc chat (Ví dụ: *"Nắng chiều Quận 3 đang hanh hao quá Sen ơi, Sen đi làm về mệt không..."*).
2.  **Cảm biến trạng thái di chuyển (`flutter_activity_recognition`):**
    *   Kiểm tra trạng thái di chuyển hiện tại khi mở app: *Walking (Đi bộ/Đi dạo)*, *Running (Chạy bộ)*, *Still (Nằm/Ngồi yên)*.
    *   Tự động kích hoạt câu thoại tương thích nếu Sen mở app lúc đang đi bộ (Ví dụ: *"Sen vừa đi bộ vừa bấm điện thoại là trẫm gạt chân đó nha! Tập trung đi dạo đi!"*).
3.  **Lập lịch Thông báo tự phát cục bộ (Scheduled Local Push Notifications):**
    *   Không chạy background worker. Khi Sen đóng app, hệ thống tính toán thời gian nghỉ và **lên lịch hẹn giờ cục bộ (Local Push)** thông qua `flutter_local_notifications`.
    *   Gửi 1 lời thì thầm tự phát (Spontaneous Opener) nhẹ nhàng vào đêm muộn hoặc sáng hôm sau để mời Sen mở lại ứng dụng.

---

## 🎨 2. Luồng Xin Quyền Có Ngữ Cảnh Xuất Sắc (Contextual Permission Opt-In)

Để tránh hiện popup xin quyền định vị đột ngột gây phản cảm và phòng thủ tâm lý:

1.  **Hành vi có chủ ý (Intentional Action):** Người dùng nhấp vào một nút hành động cụ thể trên màn hình chính như **[Xem thời tiết cùng Boss 🌤️]** hoặc **[Dẫn đường qua Tiệm Cafe Sách]**.
2.  **Hộp thoại Cozy Soft Prompt:** Trước khi hiện hộp thoại xin quyền của hệ thống, Boss ảo hiện một bong bóng thoại mộc mạc phong cách Ghibli:
    *   *Lời thoại:* `"Để trẫm biết thời tiết chỗ Sen đang mưa hay nắng để nhắc Sen mang ô, và chuẩn bị sẵn pate nóng hổi đón Sen mở app trò chuyện, Sen cho phép trẫm ghé mắt nhìn vị trí một xíu nhé? 🐾"`
    *   *Hai lựa chọn:* `[Đồng ý cho Boss đồng hành]` hoặc `[Để trẫm tự đi]`.
3.  **Kích hoạt Quyền:**
    *   Khi Sen bấm `[Đồng ý]`, hệ thống mới gọi popup yêu cầu quyền GPS của thiết bị (`Permission.location.request()`).
    *   Tỷ lệ đồng ý (Opt-In Rate) dự kiến đạt **>90%** vì yêu cầu có ngữ cảnh rõ ràng và tràn ngập cảm xúc ấm áp.
    *   Ngay khi có quyền, app âm thầm lưu tọa độ GPS cục bộ làm mốc để gọi API thời tiết tự động.

---

## 🔒 3. Bảo Mật Vị Trí Tuyệt Đối

*   **Không gửi tọa độ thô lên Cloud:** Toàn bộ tọa độ GPS và địa điểm của Sen được lưu trữ và mã hóa cục bộ trên thiết bị của người dùng thông qua SQLite/Hive. Capcat **tuyệt đối không gửi tọa độ GPS thô lên đám mây**.
*   Khi có sự kiện định vị, client chỉ nạp vào bộ nhớ RAM cục bộ để làm giàu Prompt cho API Chat hoặc API sinh câu bình luận ảnh.
