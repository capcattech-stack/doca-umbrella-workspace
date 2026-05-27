# EPIC 0: ĐĂNG NHẬP MỘT CHẠM (ONE-TAP GOOGLE SSO AUTHENTICATION)
*(ĐẶC TẢ CHI TIẾT USER STORIES & ACCEPTANCE CRITERIA)*

---

## 🔐 MÔ TẢ EPIC
Phân hệ này giải quyết bài toán xác thực danh tính người dùng một cách nhanh chóng, mượt mà và an toàn nhất ở giai đoạn MVP. Sử dụng Google Sign-In làm cổng SSO chính và liên kết đồng bộ tài khoản với Firebase Authentication để quản lý phiên làm việc bảo mật cao.

---

## 📋 DANH SÁCH USER STORIES

### US-0.1: Đăng nhập Nhanh chóng qua Google SSO (Single Sign-On)
*   **Phát biểu:** 
    *   *Là một:* Người dùng bận rộn (Sen),
    *   *Tôi muốn:* Đăng nhập vào app bằng tài khoản Google của mình chỉ với một chạm,
    *   *Để:* Tôi có thể sử dụng ngay ứng dụng mà không cần qua các bước điền form đăng ký email/mật khẩu phiền phức.
*   **Mô tả chi tiết:**
    Khi người dùng mở ứng dụng lần đầu tiên hoặc sau khi đăng xuất, họ sẽ được chào đón bằng một màn hình Welcome tuyệt đẹp. Màn hình này có một nút bấm duy nhất màu trắng, tích hợp logo chữ "G" của Google, giúp họ đăng nhập nhanh chóng.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Sleek Welcome UI):** Hiển thị màn hình Chào mừng (Welcome Screen) mang phong cách thương hiệu sắc sảo, có nút bấm bo cong Glassmorphism nổi bật **"Đăng nhập bằng Google"**.
    *   **AC-2 (Google SDK Integration):** Khi nhấn nút, app kích hoạt hộp thoại xác thực bảo mật của Google SDK. Nhận về đầy đủ thông tin hồ sơ người dùng (Tên hiển thị, Email, Ảnh đại diện Google URL).
    *   **AC-3 (Firebase Auth Synchronization):** Đồng bộ tài khoản Google vừa xác thực với hệ thống **Firebase Authentication** để cấp Token truy cập và tạo Session trên máy chủ.
    *   **AC-4 (Error Handling):** Nếu người dùng huỷ bỏ hộp thoại đăng nhập của Google, app không bị crash, hiển thị một Toast thông báo nhẹ nhàng: *"Đăng nhập bị huỷ"*. Nếu mất kết nối mạng, hiển thị Modal cảnh báo mất kết nối.
*   **Technical Context (Alan):** Sử dụng các package đã có sẵn trong `pubspec.yaml`: `google_sign_in` và `firebase_auth`.

---

### US-0.2: Duy trì phiên đăng nhập & Tự động đăng nhập (Auto-login)
*   **Phát biểu:**
    *   *Là một:* Người dùng cũ quay lại app,
    *   *Tôi muốn:* Ứng dụng tự động đăng nhập thẳng vào màn hình chính mà không bắt tôi phải bấm lại nút đăng nhập,
    *   *Để:* Tôi tiết kiệm thời gian tiếp cận Boss ảo.
*   **Mô tả chi tiết:**
    Khi người dùng mở app sau khi đã tắt hoặc khởi động lại máy, màn hình Splash Screen sẽ xuất hiện trong vòng 1.5 - 2 giây để kiểm tra Token bảo mật đã lưu trữ. Nếu Token hợp lệ, app tự động chuyển tiếp thẳng vào màn hình Home mà không cần tương tác thủ công.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Token Caching):** Lưu an toàn Session Token và thông tin cơ bản của Sen (Tên, Email, Avatar URL) xuống **Secure Storage cục bộ** (`flutter_secure_storage`) sau khi đăng nhập thành công ở US-0.1.
    *   **AC-2 (Splash Verification):** Tại màn hình Splash Screen, app tự động kiểm tra trạng thái đăng nhập của Firebase Auth cục bộ.
        - *GIVEN* Token hợp lệ -> chuyển tiếp thẳng vào Home Screen.
        - *GIVEN* Token hết hạn hoặc chưa đăng nhập -> chuyển hướng nhẹ nhàng (Fade transition) về Welcome Screen.
*   **Technical Context (Benny):** Tái cấu trúc luồng check auth của `[old]auth_check_screen.dart` thành một Splash Guard mượt mà bằng Riverpod state.
