# PRODUCT REQUIREMENTS DOCUMENT (PRD MASTER)
## PHÂN HỆ ĐĂNG NHẬP MỘT CHẠM & ĐÓN BOSS VỀ NHÀ (AUTHENTICATION & ONBOARDING ENGINE)
*(Phiên bản: 3.1 - Giai đoạn: MVP - Người soạn: CPO Sophia - Đã sửa lỗi đối kháng)*

---

## 1. TUYÊN NGÔN TRIẾT LÝ SẢN PHẨM (PRODUCT VISION)

Trong Capcat, chúng tôi tôn trọng quyền tự do trải nghiệm của người dùng (Sen). Thay vì **ép buộc** Sen phải điền form đón Boss ảo về nhà ngay lập tức sau khi đăng nhập (gây ra cảm giác áp lực và tăng tỷ lệ thoát app), Capcat MVP áp dụng triết lý **"Trải nghiệm tĩnh lặng trước - Kết nối cảm xúc sau"**:

*   **Một chạm vào thẳng vườn nhà:** Sau khi đăng nhập Google SSO, Sen được đưa thẳng vào trang chủ `MainScreen` với trạng thái "Vườn nhà trống". Họ có thể ngắm giao diện, chuyển đổi các tab để làm quen với không gian mộc mạc Wabi-Sabi.
*   **Điểm kích hoạt (CTA) tự nhiên:** Phòng Đón Boss Về Nhà chỉ được kích hoạt một cách tự nguyện qua hai điểm chạm:
    1.  **CTA "Mảnh vườn chờ trông" trên trang Home:** Một chiếc card gỗ retro xinh xắn mời gọi Sen gieo mầm linh hồn đầu tiên.
    2.  **Gate chặn tại Phòng Chat:** Khi Sen bấm vào tab Chat, vì phòng chat cần có đối tượng giao tiếp, app sẽ trượt lên một Action Sheet mời Sen đón Boss về nhà để bắt đầu trò chuyện tri kỷ.

---

## 2. THIẾT KẾ ĐỐI KHÁNG VÀ TỐI ƯU TRẢI NGHIỆM (ADVERSARIAL REFINEMENTS)

Để giải quyết triệt để các điểm gãy về đăng nhập của người dùng cũ và tính ổn định khi ngoại tuyến, phân hệ áp dụng 2 cải tiến cốt lõi:

### 2.1. Kiến trúc Đăng nhập Kép hỗ trợ người dùng cũ (Dual-Auth Strategy)
*   **Vấn đề:** Thiết kế mới chỉ dùng duy nhất Google SSO, nhưng mã nguồn cũ chứa nhiều màn hình OTP và key ngôn ngữ đăng nhập bằng số điện thoại (SĐT), gây gãy luồng cho người dùng cũ.
*   **Giải pháp:** 
    *   Giữ luồng đăng nhập một chạm **Google SSO làm mặc định (Default)** ở vị trí trung tâm để giảm ma sát cho 90% người dùng mới.
    *   Cung cấp một nút nhỏ, phẳng ở dưới chân trang chào mừng (Welcome Screen): *"Đăng nhập bằng Số điện thoại (Tài khoản cũ) 📱"*.
    *   Khi bấm vào, ứng dụng sẽ mở luồng đăng nhập SĐT nhận OTP truyền thống để hỗ trợ các tài khoản cũ đăng nhập và đồng bộ mượt mà, không ép buộc người dùng mới phải khai báo SĐT lúc Onboard.

### 2.2. Cơ chế tạo profile và quét Bio offline (Offline Creation & Background Sync)
*   **Vấn đề:** Khi người dùng chụp ảnh thú cưng để AI quét Bio nhưng thiết bị không có mạng hoặc máy ảnh chụp vật thể không phải chó/mèo.
*   **Giải pháp:**
    *   *Chặn ảnh rác:* Bộ lọc ML Kit offline chạy trực tiếp trên máy sẽ phân tích ảnh. Nếu độ tin cậy nhận dạng chó/mèo < 70%, lập tức hiển thị cảnh báo: *"Hình như đây là góc phòng tĩnh lặng chứ không phải Boss? Sen chụp lại rõ nét hơn chút nhé! 📸"*.
    *   *Lưu trữ ngoại tuyến:* Cho phép người dùng hoàn thành biểu mẫu sinh học Boss, chọn tính cách và xưng hô bình thường khi mất mạng. Dữ liệu tạm thời lưu vào SQLite cục bộ.
    *   *Tự động đồng bộ:* Ngay khi phát hiện thiết bị có mạng trở lại (`connectivity_plus`), một Background Sync Job sẽ tự động đẩy dữ liệu profile thú cưng và ảnh đại diện lên server, đảm bảo tính nhất quán dữ liệu.

---

## 3. BẢN ĐỒ DÒNG CHẢY TRẢI NGHIỆM THỐNG NHẤT (UNIFIED FLOW MAP)

```
                                 +---------------------------+
                                 |    Sen Mở Ứng Dụng        |
                                 +---------------------------+
                                               |
                                     {Kiểm tra Session}
                                               |
                        +----------------------+----------------------+
                        | (Chưa đăng nhập)                            | (Đã đăng nhập)
                        v                                             v
          +----------------------------+                +----------------------------+
          | Màn Hình Chào Mừng 500px   |                |   Vào Trang Chủ MainScreen |
          +----------------------------+                +----------------------------+
            |                        |                                |
    (Mặc định mới)             (Tài khoản cũ)                         |
            v                        v                                v
  +------------------+     +------------------+             {Kiểm tra hasPet}
  |  Google SSO SSO  |     | Đăng nhập SĐT OTP|                       |
  +------------------+     +------------------+            +----------+----------+
            |                        |                     |                     |
            +------------+-----------+               (Chưa có Pet)          (Đã có Pet)
                         |                                 v                     v
                         v                         +---------------+     +---------------+
                  [ MainScreen ]                   | Hiện Card Gỗ  |     | Home Carousel |
                                                   | Đón Boss ngay |     | Trò chuyện mở |
                                                   +---------------+     +---------------+
```

---

## 4. CƠ CẤU THƯ MỤC ĐẶC TẢ CHI TIẾT (SPECIFICATION DIRECTORY STRUCTURE)

Tất cả các tài liệu đặc tả độc lập nằm tại thư mục [AUTHENTICATION_AND_ONBOARDING_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/):

1.  **[PRD_MASTER_AUTH_ONBOARD.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/PRD_MASTER_AUTH_ONBOARD.md) (Tài liệu này):** Tổng quan tầm nhìn, giải pháp đối kháng và sơ đồ luồng.
2.  **[SPEC_01_LOGIN_PORTAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/SPEC_01_LOGIN_PORTAL.md):** Đặc tả chi tiết cổng chào Một Chạm Google SSO và luồng đăng nhập SĐT phụ trợ.
3.  **[SPEC_02_BOSS_ONBOARDING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/SPEC_02_BOSS_ONBOARDING.md):** Giao diện thiết lập thông tin Boss, chọn cá tính AI, gán xưng hô, chặn ảnh rác và cơ chế đồng bộ offline.
4.  **[SPEC_03_SOUL_MIRROR_SCAN.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/SPEC_03_SOUL_MIRROR_SCAN.md):** Thuật toán ML Kit quét Bio offline trên thiết bị.

---

*Tài liệu đặc tả đối kháng này đã được cập nhật và sẵn sàng chuyển giao lập trình. Ký tên: Team Cố vấn Capcat (Sophia, Alan, Benny)*
