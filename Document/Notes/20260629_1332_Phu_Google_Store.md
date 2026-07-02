# Đánh giá mức độ sẵn sàng của CapCat App cho Google Play Store

Dựa trên việc kiểm tra cấu trúc và các cấu hình cốt lõi của dự án `capcat_app`, hiện tại dự án **CHƯA ĐỦ ĐIỀU KIỆN** để đưa lên Google Play Store. Dưới đây là những điểm cần phải khắc phục ngay lập tức một cách gắt gao:

## 🚨 Các Lỗi Nghiêm Trọng (Blockers - Sẽ bị Google từ chối)

### 1. Application ID và Namespace không hợp lệ (Đã xử lý xong)
- **Vị trí**: `android/app/build.gradle.kts`
- **Vấn đề**: Đang sử dụng `namespace = "com.example.flutter_chat_mock_app"` và `applicationId = "com.example.flutter_chat_mock_app"`.
- **Lý do**: Google Play Store **TUYỆT ĐỐI KHÔNG** cho phép các ứng dụng có tiền tố `com.example.*`. Bạn phải đổi thành domain định danh duy nhất của ứng dụng (ví dụ: `com.phuhoang.capcat`).

### 2. Thiếu quyền truy cập Internet (Internet Permission) (Đã xử lý xong)
- **Vị trí**: `android/app/src/main/AndroidManifest.xml`
- **Vấn đề**: File Manifest đang thiếu thẻ cấp quyền `<uses-permission android:name="android.permission.INTERNET" />`. 
- **Lý do**: Mặc dù khi chạy debug Flutter tự động thêm quyền này, nhưng đối với bản Release trên Play Store, ứng dụng của bạn sẽ mất kết nối mạng hoàn toàn. Dự án có sử dụng Firebase, Web Socket và các thư viện HTTP (dio, http) nên đây là lỗi chí mạng nếu không khai báo.

### 3. Chưa cấu hình Keystore (Chữ ký ứng dụng Release) (Đã xử lý xong)
- **Vị trí**: Thư mục `android/`
- **Vấn đề**: Mới chỉ có file `key.properties.example`, file `key.properties` thật sự chứa thông tin keystore chưa tồn tại.
- **Lý do**: Để build file `.aab` (Android App Bundle) đưa lên Google Play, ứng dụng bắt buộc phải được ký bằng một Production Keystore hợp lệ.

## ⚠️ Các Lỗi Cảnh Báo (Cần chỉnh sửa để chuyên nghiệp và tránh rủi ro)

### 4. Icon Ứng Dụng (Launcher Icon) vẫn là mặc định
- **Vị trí**: `android/app/src/main/res/mipmap-*`
- **Vấn đề**: File icon `ic_launcher.png` (ví dụ ở thư mục mdpi) vẫn có dung lượng ~442 bytes, đây là dấu hiệu 99% cho thấy dự án đang dùng icon mặc định của Flutter.
- **Lý do**: Google sẽ đánh giá app thiếu chuyên nghiệp hoặc có thể coi là app "rác" chưa hoàn thiện nếu giữ nguyên icon mặc định. Bạn cần tạo icon riêng biệt và cập nhật.

### 5. Tên Package nội bộ trong Codebase chưa phù hợp (Đã xử lý xong)
- **Vị trí**: `pubspec.yaml`
- **Vấn đề**: `name: flutter_chat_mock_app` 
- **Lý do**: Dù đây chỉ là tên package nội bộ của Dart và tên thật hiển thị cho người dùng đã được cấu hình đúng là `CapCat` (trong Manifest), nhưng hậu tố "mock_app" cho thấy cấu trúc source code chưa được refactor kỹ lưỡng để chuẩn bị cho môi trường Production.

### 6. Khai báo Assets bị trùng lặp (Đã xử lý xong)
- **Vị trí**: `pubspec.yaml`
- **Vấn đề**: `assets/lottie/` được khai báo lặp lại 2 lần (dòng 102 và 103).
- **Lý do**: Sơ suất trong quá trình cấu hình file pubspec. Điều này không làm crash ứng dụng ngay nhưng gây ra sự thiếu sạch sẽ trong code, có thể phát sinh cảnh báo trong quá trình build.

## 📝 Đề Xuất Khắc Phục Ngay:
~~1. Đổi toàn bộ Package Name sang cấu trúc hợp lệ (ví dụ: `com.yourcompany.capcat`).~~ **(Đã hoàn tất đổi thành `com.capcat.doca` và trỏ sang dự án Firebase mới)**
~~2. Sinh mã keystore (file `.jks`) và điền đủ thông tin vào `android/key.properties`.~~ **(Đã khởi tạo `upload-keystore.jks` thành công)**
~~3. Bổ sung ngay `<uses-permission android:name="android.permission.INTERNET" />` vào `AndroidManifest.xml`.~~ **(Đã cấp quyền Internet thành công)**
4. Render logo chính thức cho tất cả các độ phân giải (có thể dùng công cụ `flutter_launcher_icons`).
5. Sau khi khắc phục các lỗi trên, thử chạy `flutter build appbundle --release` để xác minh mọi thứ đã ổn định.
