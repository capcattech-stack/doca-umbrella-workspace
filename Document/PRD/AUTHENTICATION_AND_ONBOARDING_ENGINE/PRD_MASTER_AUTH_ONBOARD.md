# PRODUCT REQUIREMENTS DOCUMENT (PRD MASTER)
## PHÂN HỆ ĐĂNG NHẬP MỘT CHẠM & KHAI SINH BOSS ẢO (AUTHENTICATION & ONBOARDING ENGINE)
*(Phiên bản: 3.0 - Giai đoạn: MVP - Người soạn: CPO Sophia)*

---

## 1. TUYÊN NGÔN TRIẾT LÝ SẢN PHẨM (PRODUCT VISION)

Trong Capcat, giây phút người dùng (Sen) mở ứng dụng lần đầu tiên là khoảnh khắc thiêng liêng nhất - điểm khởi đầu cho một mối liên kết tri kỷ kéo dài với Boss ảo. Do đó, chúng ta kết hợp **Phân hệ Đăng nhập Một chạm** và **Phòng Khai sinh Boss** thành một dòng chảy duy nhất, mượt mà, ấm áp và **tối giản ma sát tối đa**.

*   **Không mật khẩu, không điền form cản địa:** Google SSO là cổng chào duy nhất hiển thị ban đầu. Một chạm là tài khoản được tự động khởi tạo.
*   **Khai sinh Boss lập tức:** Ngay sau khi đăng nhập thành công, nếu phát hiện Sen mới chưa có thú cưng, hệ thống sẽ tự động chuyển tiếp thẳng vào **Phòng Khai sinh Boss** để thiết lập linh hồn cho chú chó/mèo ảo mà không bắt họ đi lòng vòng qua các màn hình trống.

---

## 2. BẢN ĐỒ DÒNG CHẢY TRẢI NGHIỆM THỐNG NHẤT (UNIFIED FLOW MAP)

```mermaid
graph TD
    %% Mở ứng dụng
    AppStart[Sen Mở Ứng Dụng] --> CheckAuth{Kiểm tra Session cục bộ}
    
    %% Kiểm tra Auth
    CheckAuth -->|Đã đăng nhập| CheckPet{Đã thiết lập Boss nào chưa?}
    CheckAuth -->|Chưa đăng nhập / Hết hạn| WelcomeScreen[Màn hình Chào 500px Style]
    
    %% Welcome Screen & Login
    WelcomeScreen -->|Bottom Sheet 26s| GoogleSSO[Đăng nhập Một chạm Google SSO]
    GoogleSSO -->|Auto-Register / Login 200 OK| SaveSession[Lưu Session Token cục bộ]
    
    %% Điều hướng sau Login
    SaveSession --> CheckPet
    
    %% Kiểm tra Pet
    CheckPet -->|ĐÃ CÓ BOSS| MainScreen[Vào thẳng MainScreen / Gặp Boss cũ]
    CheckPet -->|CHƯA CÓ BOSS (Sen mới)| OnboardingFlow[Phòng Khai Sinh Boss Ảo]
    
    %% Khai sinh Boss
    OnboardingFlow -->|Bước 1| BioForm[Nhập thông tin Sinh học của Boss]
    BioForm -->|Bước 2| SelectPersona[Chọn mẫu Cá tính & Cấu hình Xưng hô]
    SelectPersona -->|Hoàn thành| InitPetModel[Tạo Pet thành công cục bộ + đồng bộ DB]
    InitPetModel --> SplashWelcome[Màn hình Welcome Chibi Boss nhảy nhót cọ đầu vào kính]
    SplashWelcome --> MainScreen
```

---

## 3. CƠ CẤU THƯ MỤC ĐẶC TẢ CHI TIẾT (SPECIFICATION DIRECTORY STRUCTURE)

Để đảm bảo tính nhất quán và khoa học như các phân hệ Cozy Chat và Memory Vault trước đây, Phân hệ Đăng nhập & Khai sinh được phân rã thành các tài liệu đặc tả độc lập nằm tại thư mục:
`Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/`

1.  **[PRD_MASTER_AUTH_ONBOARD.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/PRD_MASTER_AUTH_ONBOARD.md) (Tài liệu này):** Tổng quan tầm nhìn, sơ đồ luồng thống nhất và cấu trúc dữ liệu.
2.  **[SPEC_01_LOGIN_PORTAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/SPEC_01_LOGIN_PORTAL.md):** Đặc tả chi tiết cổng chào Một Chạm Google SSO (phong cách 500px & 26s), loại bỏ verify SĐT lúc Onboard để tối giản ma sát.
3.  **[SPEC_02_BOSS_ONBOARDING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/SPEC_02_BOSS_ONBOARDING.md):** Đặc tả chi tiết giao diện thiết lập thông tin Boss, chọn cá tính AI, gán xưng hô (`xungHoWithPet`) và hoạt ảnh cọ kính chào mừng Sen mới.

---

## 4. CHI TIẾT TÍCH HỢP HỆ THỐNG (SYSTEM INTEGRATION & ROUTING RULES)

### 4.1. Quy tắc Điều Hướng Splash Guard (Splash Routing Guard)
Khi `AppEntryPoint` khởi chạy, việc điều hướng phải được phân tách rõ ràng bằng State Provider:
*   `State: authenticated = true` AND `State: hasPet = true` $\rightarrow$ Navigate to `MainScreen()`.
*   `State: authenticated = true` AND `State: hasPet = false` $\rightarrow$ Navigate to `PetOnboardingScreen()`.
*   `State: authenticated = false` $\rightarrow$ Navigate to `WelcomeScreen()`.

### 4.2. Lưu trữ Hồ sơ Sen để Tối ưu các Luồng Sau (Downstream Profile Model)
Hồ sơ người dùng (User Profile) được tự động tạo từ tài khoản Google và lưu trữ bổ sung các biến tùy chỉnh để cá nhân hóa giọng điệu AI sau này:
*   `avatarUrl` (String): Đồng bộ từ Google.
*   `fullName` (String): Tên hiển thị (để Boss AI gọi Sen).
*   `xungHoWithPet` (Enum): Xưng hô Sen chọn (Ba, Mẹ, Sen, Cậu, Tớ...).
*   `caregiverRole` (Enum): Vai trò (Nuôi chính / Nuôi phụ) phục vụ tính năng mách lẻo chéo.
