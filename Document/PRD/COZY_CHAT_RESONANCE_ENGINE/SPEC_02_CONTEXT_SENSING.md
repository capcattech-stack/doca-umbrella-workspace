# ĐẶC TẢ CHI TIẾT 02: COZY CONTEXT SENSING FRAMEWORK
*(CẢM BIẾN NGỮ CẢNH CHỮA LÀNH)*

> **Mã Đặc Tả:** `SPEC-COZY-02`  
> **Chủ trì:** Alan (Tech Lead) & Maya (UX)  

---

## 🧭 1. Giác Quan Ngoại Cảm Của Boss

Hệ thống tích hợp các cảm biến ngầm trên thiết bị di động (công suất cực thấp) để tự động đồng bộ hóa nhịp sống vật lý của Sen ngoài đời thực vào hành vi của Boss ảo.

```
       [ Cảm Biến Hệ Thống Trên Thiết Bị ]
                       │
       ┌───────────────┼───────────────┐
       ▼               ▼               ▼
  [ Geofencing ]  [ Activity ]    [ Temporal ]
  - geofence_     - flutter_      - workmanager /
    flutter         activity_       Background
                    recognition     Tasks
```

1.  **Định vị Geofencing (`geofence_flutter` hoặc `flutter_background_geolocation`):**
    *   Thiết lập vòng tròn địa lý bán kính 100m xung quanh "Nhà" của Sen.
    *   Sử dụng định vị Wi-Fi/Cell-tower công suất thấp (hao 0% pin). Chỉ phát tín hiệu ngầm: `Enter Home` (Về nhà) hoặc `Exit Home` (Rời nhà).
2.  **Cảm biến hành vi di chuyển (`flutter_activity_recognition`):**
    *   Trích xuất trạng thái: *Walking (Đi bộ)*, *Running (Chạy bộ)*, *In Vehicle (Đi xe)*, hoặc *Still (Nằm/Ngồi yên)*.
3.  **Cảm biến giấc ngủ (Temporal Sensing):**
    *   Phát hiện sự kiện người dùng mở khóa điện thoại lúc đêm muộn (từ 1:00 AM - 4:00 AM).

---

## 🎨 2. Luồng Xin Quyền Có Ngữ Cảnh Xuất Sắc (Contextual Permission Opt-In)

Để tránh hiện popup xin quyền định vị đột ngột gây phản cảm và phòng thủ tâm lý:

1.  **Hành vi có chủ ý (Intentional Action):** Người dùng nhấp vào nút **[Dẫn đường cho Sen / Xem Bản đồ]** trên Bottom Sheet giới thiệu Cafe sách hoặc Pet Spa.
2.  **Hộp thoại Cozy Soft Prompt:** Trước khi hiện hộp thoại hệ thống, Boss ảo hiện một thông điệp nhỏ ấm áp:
    *   *Lời thoại:* `"Để trẫm chỉ đường cho Sen qua tiệm cafe gỗ này, và giúp trẫm biết khi nào Sen đi làm về để đợi sẵn ở cửa gỗ đón Sen, Sen cho phép trẫm ghé mắt nhìn định vị vị trí nhé?"`
    *   *Hai lựa chọn:* `[Đồng ý cho Boss dẫn đường]` hoặc `[Để trẫm tự đi]`.
3.  **Kích hoạt Geofencing:**
    *   Khi Sen bấm `[Đồng ý]`, hệ thống mới yêu cầu quyền GPS của thiết bị (`Permission.location.request()`).
    *   Tỷ lệ đồng ý (Opt-In Rate) dự kiến đạt **>90%** vì yêu cầu hoàn toàn có ngữ cảnh rõ ràng.
    *   Ngay khi có quyền, app âm thầm lưu tọa độ GPS hiện tại làm mốc "Nhà" mặc định và khởi tạo cảm biến Geofence `Cozy Sensing` một cách hoàn toàn tự nhiên dưới nền.

---

## 🔒 3. Bảo Mật Vị Trí Tuyệt Đối
*   **Không gửi tọa độ thô:** Toàn bộ tọa độ GPS "Nhà" của Sen được lưu trữ và mã hóa cục bộ trên thiết bị của người dùng thông qua SQLite/Hive. Capcat **tuyệt đối không gửi tọa độ GPS thô lên đám mây**.
*   Khi Geofence kích hoạt, client chỉ bắn sự kiện ngầm đã mã hóa: `{ "event": "enter_home_late" }` để server kích hoạt cuộc thoại phù hợp.
