# SPECIFICATION 01: CỔNG CHÀO MỘT CHẠM GOOGLE SSO
## (GOOGLE ONE-TAP SSO PORTAL - WABI-SABI STYLE)
*(Phiên bản: 3.0 - Giai đoạn: MVP - Người soạn: CPO Sophia & Alan)*

---

## 1. MÔ TẢ GIAO DIỆN CHUNG (VISUAL LAYOUT SPECIFICATION)

Màn hình Welcome (`WelcomeScreen`) được tái thiết kế hoàn hảo để mang lại cảm giác chữa lành, ấm áp ngay giây đầu tiên, loại bỏ toàn bộ các ô nhập dữ liệu rườm rà cản địa:

```
+------------------------------------------+
|                                          |
|                 [500px Logo / Quote]     |
|             "Discover the silent soul    |
|               of your best friend."      |
|                                          |
|                                          |
|                                          |
|                                          |
|                   .  .  .                |
|  +------------------------------------+  |
|  |     [26s Glassmorphic Sheet]       |  |
|  |                                    |  |
|  |      G Đăng nhập bằng Google       |  |
|  |                                    |  |
|  |   Bằng cách đăng nhập, bạn đồng ý  |  |
|  |   với Điều khoản và Chính sách...  |  |
|  |                                    |  |
|  |  Lựa chọn khác  .  . . App Language|  |
|  +------------------------------------+  |
+------------------------------------------+
```

### 1.1. Nửa trên (Cinematic Art Gallery - 500px Style)
*   **Background:** Hiển thị một `PageView` tự động chạy ngầm, xoay vòng 3 hình ảnh thú cưng nghệ thuật (vintage, tone trầm mộc mạc) đã được nén dung lượng cực nhẹ dưới dạng `.webp`.
*   **Quote:** Một đoạn quote màu trắng mờ viết bằng font `Caveat` hoặc `Quicksand` nằm ở giữa: *"Discover the silent soul of your best friend."*
*   **Indicator:** 3 dấu chấm tròn nhỏ mờ ảo nằm ở mép trên Bottom Sheet để Sen biết ảnh nền có thể lướt xem.

### 1.2. Nửa dưới (Sleek Bottom Sheet - 26s Style)
*   **Bottom Sheet:** Trượt từ dưới lên khi màn hình khởi tạo xong (sau 1.5 giây splash).
*   **Chất liệu:** Kính mờ Glassmorphism trong suốt (`BackdropFilter` với `sigmaX: 15.0, sigmaY: 15.0`). Màu nền xám đậm mờ ảo (`Colors.black.withOpacity(0.45)`).
*   **Nút Google SSO (Tiêu điểm tối cao):**
    *   Nút bấm màu đen bóng bẩy bo tròn góc tối đa (Capsule Shape).
    *   Tích hợp Logo chữ "G" của Google nguyên bản đa màu sắc ở góc trái, chữ *"Đăng nhập bằng Google"* màu trắng tinh tế ở giữa.
*   **Chân Bottom Sheet (Secondary Actions):**
    *   *Trái:* Nút text *"Tôi không dùng Google"* hoặc *"Lựa chọn đăng nhập khác"*. Khi bấm sẽ trượt mở Action Sheet điền Số điện thoại & Mật khẩu cổ điển.
    *   *Phải:* Tab chọn ngôn ngữ ứng dụng nhỏ nhắn (ENG / VIE).

---

## 2. QUY TRÌNH KỸ THUẬT & API (TECHNICAL INTEGRATION)

### 2.1. Đăng ký Google SSO Tự động (One-Tap Auto-Registration)
Để tối thiểu ma sát cho MVP, **bỏ qua hoàn toàn bước bắt buộc xác minh số điện thoại nhận OTP khi đăng nhập bằng Google lần đầu tiên.**
1.  Sen nhấn nút **"Đăng nhập bằng Google"**.
2.  App kích hoạt Google SDK $\rightarrow$ Lấy về ID Token $\rightarrow$ Gửi lên backend thông qua API `socialLogin`.
3.  **Backend Auto-Registration:** Nếu Google ID chưa tồn tại, backend tự động tạo User mới trong hệ thống bằng dữ liệu của Google và trả về mã thành công `200 OK` kèm Session Token.
4.  App lưu token xuống `Secure Storage` cục bộ và chuyển hướng thẳng vào **Phòng Khai Sinh Boss** (nếu là Sen mới) hoặc **MainScreen** (nếu là Sen cũ đã tạo Boss).

### 2.2. Xử lý Lỗi Mềm (Soft Error Handling - Ràng buộc 100% không Crash)
*   **Sen bấm hủy Popup Google:** Không crash, không đơ, app hiển thị một Toast mỏng nhẹ dưới chân Bottom Sheet: *"Đăng nhập bị hủy"*.
*   **Lỗi mất kết nối mạng:** Hiển thị Dialog chữa lành: *"Có vẻ Boss ảo của bạn đang mải chơi ngoài vườn và không nghe thấy tiếng gọi... Hãy kiểm tra kết nối mạng nhé!"*.

---

## 3. TIÊU CHÍ NGHIỆM THU (ACCEPTANCE CRITERIA)

*   **AC-1 (Perfect Wabi-Sabi Render):** Màn hình chào hiển thị ảnh nghệ thuật full-bleed dưới 1.2 giây, Bottom Sheet kính mờ Glassmorphic trượt lên mượt mà không bị giật khung hình.
*   **AC-2 (Primary Gate Action):** Nhấn nút Google SSO kích hoạt chính xác popup tài khoản của Google SDK. Khi chọn tài khoản, ứng dụng hiển thị indicator loading tròn mượt ngầm trong 1.5 giây trước khi chuyển cảnh.
*   **AC-3 (Zero-Friction Linkage Bypass):** Đăng nhập Google tài khoản mới thành công là chuyển thẳng đến Phòng Khai Sinh Boss, tuyệt đối không bắt nhập OTP điện thoại.
*   **AC-4 (Backup Flow Accessibility):** Nhấn "Lựa chọn đăng nhập khác" trượt mở form Số điện thoại/Mật khẩu cũ hoạt động ổn định, bảo toàn 100% tính năng đăng nhập truyền thống.
