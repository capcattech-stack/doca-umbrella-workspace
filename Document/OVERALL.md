# Tổng quan Dự án: Capcat App (flutter_chat_mock_app)

Tài liệu này cung cấp cái nhìn tổng quan về kiến trúc, công nghệ và cấu trúc thư mục của dự án ứng dụng Flutter `capcat_app`.

## 1. Thông tin chung
- **Tên dự án (pubspec):** `flutter_chat_mock_app`
- **Nền tảng:** Ứng dụng di động (Flutter) có khả năng biên dịch đa nền tảng (Android, iOS, Web, macOS, Linux, Windows).
- **Mục tiêu:** Xây dựng một ứng dụng có tính năng chat thời gian thực (real-time chat), kết nối mạng, xác thực người dùng và hiển thị đa phương tiện (ảnh, lottie, svg,...).

## 2. Công nghệ & Thư viện sử dụng (Tech Stack)

Dự án sử dụng các công nghệ hiện đại và phổ biến nhất trong hệ sinh thái Flutter:

- **Quản lý trạng thái (State Management):** `flutter_riverpod`
- **Kết nối mạng & Real-time:** 
  - `dio` & `http` cho REST API.
  - `socket_io_client` & `web_socket_channel` cho real-time chat/kết nối.
- **Xác thực (Authentication) & Backend (BaaS):** 
  - `firebase_core`, `firebase_auth`
  - `google_sign_in`
- **Lưu trữ cục bộ (Local Storage):**
  - `shared_preferences` (lưu cài đặt nhỏ)
  - `flutter_secure_storage` (lưu token, dữ liệu nhạy cảm)
- **Xử lý Đa phương tiện & File:**
  - `image_picker`, `file_picker`, `flutter_image_compress` (chọn và nén ảnh/file)
  - `cached_network_image`, `flutter_cache_manager` (hiển thị và cache ảnh mạng)
  - `flutter_svg`, `lottie`, `photo_view` (hiển thị đồ họa và xem ảnh)
- **Đa ngôn ngữ (Localization):** `flutter_localizations`, `intl`
- **Tiện ích khác:** `permission_handler` (cấp quyền), `url_launcher` (mở link), `shimmer` (hiệu ứng loading), `connectivity_plus` & `internet_connection_checker` (kiểm tra mạng).

## 3. Kiến trúc Cấu trúc Thư mục (`lib/`)

Dự án áp dụng mô hình kiến trúc phân lớp (phong cách Feature-based/Layer-based) nhằm đảm bảo clean code và dễ mở rộng:

- **`models/`**: Chứa các class dữ liệu (Data models), định nghĩa các thực thể trong app (ví dụ: User, Message, ChatRoom...).
- **`providers/`**: Chứa các file quản lý state của Riverpod, kết nối giao diện với dữ liệu.
- **`repositories/`**: Chứa các class xử lý logic giao tiếp với Backend/Services (ẩn đi chi tiết về Dio, Firebase).
- **`services/`**: Các service cốt lõi của hệ thống (ví dụ: AuthService, SocketService, StorageService).
- **`screens/`**: Chứa các màn hình giao diện chính của ứng dụng.
- **`widgets/`**: Các thành phần UI có thể tái sử dụng (reusable components) như nút bấm, input, card,...
- **`routes/`**: Cấu hình điều hướng (navigation/routing) trong ứng dụng.
- **`storage/`**: Xử lý việc lưu trữ local (Secure Storage, Shared Prefs).
- **`theme/`**: Cấu hình màu sắc, typography và chủ đề chung (dark/light mode).
- **`utils/`**: Các hàm tiện ích, định dạng ngày tháng, hằng số (constants).
- **`l10n/`**: Các file liên quan đến đa ngôn ngữ.
- **`gen/`**: Thư mục sinh code tự động (ví dụ: gen assets, font,...).
- **`assistant/`, `config/`, `data/`, `enums/`**: Các file cấu hình, dữ liệu tĩnh, và hằng số phân loại.

## 4. Định hướng Tiếp theo

Dựa trên cấu trúc này, ứng dụng đã có sẵn một "khung xương" rất vững chắc cho một ứng dụng có tính tương tác cao (như chat hoặc mạng xã hội). Khi phát triển tiếp, chúng ta sẽ:
- Dựa vào `Riverpod` để duy trì luồng dữ liệu (Data flow).
- Mở rộng các `repositories` nếu thêm API mới.
- Tạo các feature mới trong `screens` và tái sử dụng component tại `widgets`.
