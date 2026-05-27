# Tổng quan Dự án: Capcat App (flutter_chat_mock_app) - Soul of Pet

Tài liệu này cung cấp cái nhìn tổng quan về kiến trúc, công nghệ và cấu trúc thư mục của dự án ứng dụng Flutter `capcat_app` theo định hướng chiến lược mới **"Capcat: Soul of Pet"**.

---

## 1. Thông tin chung
- **Tên dự án (pubspec):** `flutter_chat_mock_app`
- **Nền tảng:** Ứng dụng di động (Flutter) có khả năng biên dịch đa nền tảng (Android, iOS, Web, macOS, Linux, Windows).
- **Mục tiêu tối cao:** Xây dựng một ứng dụng giải trí và kết nối cảm xúc chữa lành, biến chiếc điện thoại thành cầu nối giúp chủ nuôi trò chuyện, chơi đùa với linh hồn kỹ thuật số độc bản của chính chú thú cưng thực tế của họ.
- **Kim chỉ nam phát triển:** Tuân thủ nghiêm ngặt Bản tuyên ngôn sứ mệnh tại [Document/04_VISION_MANIFESTO.md](file:///Users/macinia/Capcat%20Project/Document/04_VISION_MANIFESTO.md).

---

## 2. Các Tính năng Trọng tâm (MVP Features)

Dự án tập trung vào 4 phân hệ chính giải quyết triệt để bài toán cảm xúc của người dùng:

1.  **Hồ sơ sinh học & Cá tính động (`PetDetail` & `PetPersona`):**
    *   Quản lý thông tin Boss (loài, giống, độ tuổi, cân nặng).
    *   Thiết lập linh hồn AI của Boss thông qua cấu hình tính cách (chảnh chọe, lười biếng, ngáo ngơ, trung thành), tông giọng và cách xưng hô riêng.
2.  **Nhật ký ký ức đồng hành (`Moments Feed`):**
    *   Nơi chủ nuôi tải lên hình ảnh dìm hàng, ghi chép nhanh khoảnh khắc hàng ngày của Boss.
    *   **Bộ nhớ RAG:** AI sẽ đọc hình ảnh và nội dung nhật ký để ghi nhớ vào bộ não ảo của Boss, phục vụ cho việc trò chuyện cá nhân hoá sau này.
3.  **Trò chuyện thời gian thực tương tác (`Real-time Chat Companion`):**
    *   Kênh kết nối trực tiếp với linh hồn ảo của Boss sử dụng `socket_io_client` & `web_socket_channel`.
    *   Ngôn từ hài hước, biến thiên bất ngờ mang lại Dopamine tức thì, khơi gợi cảm xúc giống như trào lưu nuôi thú ảo Tamagotchi hay SimSimi xưa.
4.  **Trợ lý ảo ẩn hiện toàn cục (`AssistantHost`):**
    *   Lớp phủ giao diện (Overlay Widget) thông minh giúp Boss ảo có thể "xuất hiện" nhanh ở bất kỳ màn hình nào thông qua Floating Action Button (FAB) động, gửi các lời thì thầm ngọt ngào/hài hước (`whisper`) cho chủ nuôi.

---

## 3. Công nghệ & Thư viện sử dụng (Tech Stack)

Dự án ứng dụng các thư viện tối tân nhất trong hệ sinh thái Flutter để tối ưu hóa trải nghiệm cảm xúc:

- **Quản lý trạng thái (State Management):** `flutter_riverpod` (quản lý đồng bộ trạng thái chat, bộ nhớ Boss, cảm xúc).
- **Kết nối mạng & Real-time Sockets:** 
  - `dio` & `http` cho các luồng REST API nạp ảnh, đăng nhật ký.
  - `socket_io_client` & `web_socket_channel` duy trì kết nối chat tức thì dưới 1 giây.
- **Xác thực & Bảo mật cục bộ:**
  - `firebase_core`, `firebase_auth`, `google_sign_in` quản lý tài khoản người dùng nhanh gọn qua 1 chạm.
  - `flutter_secure_storage` & `shared_preferences` lưu trữ an toàn Token bảo mật và cấu hình cá tính Boss.
- **Hiệu ứng đồ họa & Đa phương tiện:**
  - `flutter_svg`, `lottie` hiển thị hoạt ảnh Boss sinh động, các biểu cảm ngộ nghĩnh.
  - `cached_network_image` tải và lưu đệm hình ảnh mượt mà, tránh chờ đợi.
  - `shimmer` tạo hiệu ứng Skeleton Loading sang trọng khi chờ AI tải câu trả lời.
  - `photo_view` phóng to thu nhỏ hình ảnh dìm hàng của Boss trong nhật ký.
- **Đa ngôn ngữ (Localization):** `flutter_localizations`, `intl` phục vụ đa dạng ngôn ngữ giao tiếp.

---

## 4. Kiến trúc Cấu trúc Thư mục (`lib/`)

Mã nguồn được tổ chức theo mô hình Clean Architecture phân lớp rõ ràng:

- **`models/`**: Định nghĩa cấu trúc dữ liệu (`PetDetail`, `PetPersona`, `Message`, `Moment`).
- **`providers/`**: Trái tim State Management của Riverpod điều phối luồng dữ liệu (ví dụ: `nanny_chat_provider.dart` xử lý kết nối chat với AI).
- **`repositories/`**: Giao tiếp lấy dữ liệu từ Local Database hoặc Remote API.
- **`services/`**: Các service cốt lõi (Auth, Socket, Media Service).
- **`screens/`**: Giao diện các màn hình chính (Splash, Home, Chat, Profile, My Pets).
- **`widgets/`**: Các UI Component dùng chung (nút bấm hiệu ứng `tap_effect`, loading overlay).
- **`assistant/`**: Trợ lý ảo toàn cục chứa FAB động và Overlay Host (`assistant_host.dart`).
- **`theme/`**: Định nghĩa font chữ `Quicksand` & `Motterdam` hiện đại cùng bảng màu tươi sáng, giàu cảm xúc.
- **`utils/`**: Các hàm tiện ích, định dạng, quản lý Toast hiển thị.
- **`l10n/`**: Cấu hình đa ngôn ngữ Việt/Anh.
- **`gen/`**: Thư mục chứa tài nguyên sinh tự động (Assets, Fonts).
- **`config/`, `data/`, `enums/`**: Các hằng số, cấu hình IP server và dữ liệu tĩnh.

---

## 5. Định hướng Kỹ thuật tiếp theo

Dựa trên cấu trúc kiến trúc vững chắc này, bước tiếp theo đội ngũ sẽ:
1.  **Cấu hình Prompt thông minh (System Prompt):** Định hình ngôn từ của AI Chat trong `providers/` để bám sát 4 loại tính cách trong `PetPersona`.
2.  **Liên kết Moments với Chat Memory:** Viết logic đẩy dữ liệu nhật ký mới đăng vào ngữ cảnh chat của AI.
3.  **Tích hợp vật phẩm ảo (Gacha/Tamagotchi):** Bổ sung các widget cửa hàng vật phẩm ảo để kích hoạt mô hình kinh doanh Giao dịch nhỏ (Micro-transaction).
