# ĐẶC TẢ GIAO DIỆN: SCR-12 — SAFE-VET EMERGENCY SCREEN (TRỢ LÝ Y TẾ CẤP CỨU)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Đây là màn hình **cứu mạng thú cưng**. Khi hệ thống AI phát hiện Sen gõ từ khóa Đèn Đỏ nguy hiểm (như "co giật", "khó thở", "ăn phải bả"), luồng chat thông thường của AI sẽ ngay lập tức bị khóa lại và màn hình này sẽ hiện ra để bảo vệ tối đa tính mạng của Boss.
*   **Vibe cảm xúc**: Rõ ràng, khẩn cấp, tin cậy, không làm người dùng hoảng loạn.
*   **Cơ chế màu sắc**: Sử dụng tông màu đỏ sẫm cảnh báo WCAG đạt độ tương phản tối thiểu **4.5:1** trên nền sáng để Sen dễ đọc thông tin trong trạng thái bối rối.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [⚠️ ĐÈN ĐỎ] CẢNH BÁO Y TẾ KHẨN CẤP                   | <--- AppBar đỏ sẫm #FF5252
|  =================================================    |
|                                                       |
|  +-------------------------------------------------+  |
|  | [⚠️] PHÁT HIỆN DẤU HIỆU NGUY KỊCH               |  | <--- Cảnh báo Red-Flag
|  | Boss đang có triệu chứng co giật / khó thở.     |  |      Nền oatmeal, viền đỏ sẫm H 80dp
|  +-------------------------------------------------+  |
|                                                       |
|  HƯỚNG DẪN SƠ CỨU 3 BƯỚC DUY TRÌ SỰ SỐNG              | <--- Nhóm Label (Inter SemiBold 12px)
|  ___________________________________________________  |
|  1. Đặt thú cưng nằm nghiêng nơi thoáng mát.        | <--- Hướng dẫn đơn giản dễ hiểu
|  2. Kiểm tra dị vật trong miệng / làm sạch dãi.      |
|  3. Tuyệt đối không tự ý cho uống nước / sữa.       |
|  ___________________________________________________  |
|                                                       |
|  3 PHÒNG KHÁM THÚ Y GẦN NHẤT (ĐANG MỞ CỬA)            |
|  ___________________________________________________  |
|  🏥 Vet Clinic A (Cách 1.2km)        [📞 Gọi]  [🗺️ Bản đồ]| <--- Dòng thông tin phòng khám
|  🏥 Bệnh viện thú y B (Cách 2.5km)   [📞 Gọi]  [🗺️ Bản đồ]|      Nút bấm tap target 44x44px
|  🏥 Trung tâm Pet C (Cách 3.1km)     [📞 Gọi]  [🗺️ Bản đồ]|
|  ___________________________________________________  |
|                                                       |
|                 [ Quay Lại Trang Chủ ]                | <--- Nút bấm phụ để thoát an toàn
+-------------------------------------------------------+
|  (Không có Dock điều hướng trong Chế độ Cấp cứu)       |
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Cứu Hộ (Interactions & GPS Triage)

1.  **Gọi điện nhanh (One-click Call)**:
    *   Sen chạm nút **[📞 Gọi]** để trực tiếp gọi số hotline cấp cứu của phòng khám thú y đó mà không cần sao chép số. Kích hoạt rung haptic rung liên tục 2 nhịp dứt khoát (`Medium Impact`).
2.  **Chỉ đường bản đồ (GPS Compass)**:
    *   Sen chạm nút **[🗺️ Bản đồ]** sẽ gọi Deep Link mở ứng dụng Apple Maps (iOS) hoặc Google Maps (Android) vẽ sẵn lộ trình di chuyển nhanh nhất tới phòng khám.
3.  **Khóa tương tác an toàn (Triage Lockout)**:
    *   Khi màn hình này hoạt động, Dock điều hướng 5-Tab bị ẩn đi để ép Sen tập trung vào các hành động sơ cứu cứu mạng Boss. Chỉ có duy nhất một nút quay lại trang chủ phẳng dẹt ở góc dưới cùng khi tình hình đã an toàn.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tiêu đề cảnh báo: `Inter Bold 16px` màu đỏ nguy cấp `#D32F2F`.
    *   Dòng sơ cứu: `Inter Regular 13px` line-height `1.6` màu Obsidian `#1C1C1E`.
    *   Khoảng cách: `Space Mono Regular 12px` cho số liệu khoảng cách (Ví dụ: `1.2km`).
*   **Màu sắc**:
    *   Nền AppBar khẩn cấp: Nền hồng anh đào `#FFEBEE` với viền đỏ đậm `#D32F2F`.
    *   Nút gọi điện: Nền màu gỗ Obsidian `#121212`, chữ trắng.
    *   Nút bản đồ: Nền màu yến mạch `#F5F5F0`, chữ đen Obsidian.
*   **Kích thước & Bo góc**:
    *   Thẻ thông báo Red-Flag: Bo góc `16px` (`Radius.cozyCard`), viền đỏ mảnh `1px solid #FFCDD2`.
    *   Nút bấm Gọi/Bản đồ: Cao `36dp`, bo góc `8px`, tap target bao phủ tối thiểu `44x44px` theo tiêu chuẩn khả dụng.
