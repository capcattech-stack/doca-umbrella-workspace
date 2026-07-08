# Báo cáo Đánh giá Mức độ Sẵn sàng Release lên Google Play Store - CapCat App

Dựa trên việc rà soát thực tế mã nguồn, các cấu hình trong thư mục `capcat_app` và kết quả chạy build thử nghiệm thực tế, dưới đây là kết quả đánh giá chi tiết:

## 🟢 Kết Luận Chung: **ĐỦ ĐIỀU KIỆN (READY)**

Ứng dụng **CapCat App** hiện tại đã khắc phục toàn bộ các lỗi nghiêm trọng (Blockers) và các cảnh báo được nêu trong file [20260629_1332_Phu_Google_Store.md](file:///Users/phuhoang/Development/capcat_project/document/Notes/20260629_1332_Phu_Google_Store.md). Bản build Release App Bundle (`.aab`) đã được tạo thành công với cấu hình ký số chính thức (Production Signing Key).

---

## 🔍 Chi Tiết Kết Quả Rà Soát

### 1. Application ID & Namespace (Đã Khắc Phục)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: Trong file [build.gradle.kts](file:///Users/phuhoang/Development/capcat_project/capcat_app/android/app/build.gradle.kts), cấu hình đã được đổi từ `com.example.flutter_chat_mock_app` sang **`com.capcat.doca`**.
*   **Google Services**: File [google-services.json](file:///Users/phuhoang/Development/capcat_project/capcat_app/android/app/google-services.json) cũng đã trỏ chính xác về package name `com.capcat.doca` của dự án Firebase `capcat-doca`.

### 2. Quyền Truy Cập Internet (Đã Khắc Phục)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: File [AndroidManifest.xml](file:///Users/phuhoang/Development/capcat_project/capcat_app/android/app/src/main/AndroidManifest.xml) đã được bổ sung quyền truy cập Internet chính xác:
    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    ```
    Đồng thời các quyền truy cập Camera và Đọc thư viện ảnh cũng đã được thiết lập đầy đủ cho các tính năng chọn/chụp ảnh trong app.

### 3. Keystore & Chữ ký Release (Đã Khắc Phục)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: 
    *   File [key.properties](file:///Users/phuhoang/Development/capcat_project/capcat_app/android/key.properties) đã được tạo và chứa thông tin trỏ tới file keystore thật.
    *   File keystore thật `upload-keystore.jks` đã được lưu tại thư mục [android/app/](file:///Users/phuhoang/Development/capcat_project/capcat_app/android/app).
    *   Cấu hình Gradle tự động nạp keystore khi build Release đã chạy hoàn toàn ổn định và an toàn (các file nhạy cảm này đã được chặn trong [android/.gitignore](file:///Users/phuhoang/Development/capcat_project/capcat_app/android/.gitignore) to avoid leaking them).

### 4. Tên Hiển Thị Ứng Dụng (App Name) (Đã Khắc Phục)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: Tên hiển thị của ứng dụng trong file [AndroidManifest.xml](file:///Users/phuhoang/Development/capcat_project/capcat_app/android/app/src/main/AndroidManifest.xml) đã được đổi từ `CapCat` sang **`Doca`**:
    ```xml
    android:label="Doca"
    ```
    Khi cài đặt trên điện thoại Android, ứng dụng sẽ xuất hiện với tên chính thức là **Doca**.

### 5. Icon Ứng Dụng & Cấu Hình Adaptive Icon (Đã Khắc Phục Triệt Để)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: 
    *   Đã chuyển đổi sang **Adaptive Icon** chuẩn của Android. Logo mèo trắng/xanh đã được co nhỏ lại về tỉ lệ **60%** và căn giữa trong khung hình trong suốt `512x512`.
    *   Cấu hình màu nền background `#1f2022` (màu đen xám trùng khớp với màu nền logo gốc) trong [pubspec.yaml](file:///Users/phuhoang/Development/capcat_project/capcat_app/pubspec.yaml).
    *   Đã chạy generate lại toàn bộ icon bằng công cụ `flutter_launcher_icons` với tính năng `adaptive_icons` được kích hoạt đầy đủ.

### 6. Sửa Lỗi App Treo Ở Màn Hình Splash (Đã Khắc Phục)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: Đã sửa file [main.dart](file:///Users/phuhoang/Development/capcat_project/capcat_app/lib/main.dart), bọc lệnh khởi tạo Firebase trong khối `try-catch` an toàn để tránh làm treo ứng dụng trong trường hợp Firebase đã được khởi tạo ngầm từ trước.

### 7. Sửa Lỗi Lệch Width Của Các Ô Nhập Liệu Trên Tablet (Đã Khắc Phục Mới)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: 
    *   Đã sửa lỗi ô nhập số điện thoại (`PhoneInput`) và ô nhập mã xác thực (`NumberInputField`) bị ngắn hơn so với ô mật khẩu và nút bấm khi chạy trên Tablet 7-inch & 10-inch.
    *   Thay đổi thuộc tính chiều rộng `width` từ kích thước cố định `SizeConfig.sw(327)` sang **`double.infinity`** cho cả 2 widget [phone_input.dart](file:///Users/phuhoang/Development/capcat_project/capcat_app/lib/widgets/input/phone_input.dart) và [number_input_field.dart](file:///Users/phuhoang/Development/capcat_project/capcat_app/lib/widgets/number_input_field.dart). 
    *   Các ô nhập liệu hiện tại sẽ tự động giãn ra đồng đều, thẳng hàng tăm tắp với nhau theo lề của form cha trên mọi kích thước màn hình.

### 8. Tên Package Nội Bộ Trong Codebase (Đã Khắc Phục)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: Tên ứng dụng trong file [pubspec.yaml](file:///Users/phuhoang/Development/capcat_project/capcat_app/pubspec.yaml) đã được sửa đổi thành `capcat_doca` thay vì tên mock cũ.

### 9. Khai Báo Trùng Lặp Assets (Đã Khắc Phục)
*   **Trạng thái**: Đã đạt.
*   **Chi tiết**: Assets lottie trùng lặp trong [pubspec.yaml](file:///Users/phuhoang/Development/capcat_project/capcat_app/pubspec.yaml) đã được làm sạch, hiện tại mỗi folder asset chỉ được khai báo duy nhất một lần.

### 10. Thử Nghiệm Build Release Thực Tế (Đã Đạt)
*   **Lệnh thực hiện**: `flutter build apk --release` & `flutter build appbundle --release`
*   **Kết quả**: Cả hai lệnh build đều thành công và xuất ra file cài đặt ổn định.
*   **Đường dẫn APK đầu ra**: `build/app/outputs/flutter-apk/app-release.apk` (89.6 MB)
*   **Đường dẫn AAB đầu ra**: `build/app/outputs/bundle/release/app-release.aab` (74.6 MB)

---

## ⚠️ Các Lưu Ý Quan Trọng Khi Release Lên Google Play Console

Để đảm bảo quá trình release không gặp lỗi và các tính năng hoạt động trơn tru sau khi tải từ Google Play Store, bạn cần thực hiện các bước sau:

1.  **Cấu hình SHA-1 & SHA-256 cho Google Sign-In (Đã hoàn tất)**:
    *   *Trạng thái*: Người dùng đã cấu hình đầy đủ mã băm SHA-1 & SHA-256 từ file keystore `upload-keystore.jks` vào phần **Settings -> Project Settings -> General -> SDK setup and configuration** trên Firebase Console của dự án `capcat-doca`.
2.  **Cấu hình Google Play App Signing**:
    *   Khi bạn upload file `.aab` lên Google Play Console, Google sẽ tự động kích hoạt tính năng *Play App Signing*. Google sẽ ký lại app bằng mã khóa release của riêng họ trước khi phân phối cho người dùng.
    *   **QUAN TRỌNG**: Bạn phải truy cập vào trang quản lý ứng dụng trên Google Play Console -> **Setup -> App Integrity** để lấy mã SHA-1 của **App signing key** do Google quản lý, sau đó thêm mã SHA-1 này vào Firebase Console của bạn. Nếu không, người dùng tải app từ store về cũng sẽ không thể đăng nhập qua Google được.
3.  **Tăng Version Code cho các bản cập nhật tiếp theo**:
    *   Bản build hiện tại có cấu hình `version: 1.0.0+1` (Version Name: `1.0.0`, Version Code: `1`).
    *   Trong tương lai, nếu cần sửa lỗi hoặc cập nhật tính năng mới, bạn bắt buộc phải tăng số build number (phần sau dấu cộng) trong [pubspec.yaml](file:///Users/phuhoang/Development/capcat_project/capcat_app/pubspec.yaml), ví dụ thành `1.0.0+2`, if not Google Play will reject it.
4.  **Chính Sách Bảo Mật (Privacy Policy)**:
    *   Vì ứng dụng của bạn sử dụng quyền Internet, lưu trữ và có tính năng xác thực người dùng, Google bắt buộc phải có link đến trang *Chính sách bảo mật*. Hãy chuẩn bị trước một trang web đơn giản chứa các điều khoản bảo mật và điền link này vào Google Play Console khi điền thông tin mô tả app.
