# Tổng quan Dự án: DOCA App - Soul of Pet

Tài liệu này cung cấp cái nhìn tổng quan về định vị chiến lược, kiến trúc, công nghệ và cấu trúc thư mục của dự án ứng dụng di động **DOCA**.

---

## 1. Thông tin chung & Định vị Dự án

- **Tên dự án (pubspec):** `flutter_chat_mock_app`
- **Nền tảng:** Ứng dụng di động (Flutter) có khả năng biên dịch đa nền tảng (Android, iOS).
- **Mục tiêu tối cao (Vision):** 
  > **"DOCA"** sinh ra không phải để làm một công cụ quản lý dữ liệu khô khan. Sứ mệnh tối cao của chúng tôi là **chữa lành sự cô đơn của con người đô thị**, biến chiếc điện thoại lạnh lẽo thành cầu nối cảm xúc sống động, nơi người dùng có thể trò chuyện, trêu đùa và lưu giữ linh hồn kỹ thuật số của chính chú thú cưng thực tế của họ thông qua **DOCA PetTwin** và **DOCA Capsule**.
  >
  > *"Chúng tôi không bán công cụ; chúng tôi bán sự giải trí, niềm vui và sự xoa dịu cảm xúc."*
- **Tuyên ngôn định vị thương hiệu:** Tuân thủ và vận hành nhất quán theo [Tuyên ngôn định vị thương hiệu & nội dung MKT](file:///Users/macinia/Capcat%20Project/Document/04_BRAND_MARKETING_MANIFESTO.md).
- **Kim chỉ nam phát triển:** Bám sát [Kim chỉ nam dự án: DOCA](file:///Users/macinia/Capcat%20Project/Document/03_VISION_MANIFESTO.md).

### Ba Đối Tượng Tham Chiếu Tinh Thần (The Spiritual Trinity)
1. **Tamagotchi (Sự Chăm Sóc & Trách Nhiệm Cảm Xúc - Hoãn trong Phase 1):** Định hướng dài hạn về sự gắn kết sinh ra từ việc chăm sóc hàng ngày để duy trì các chỉ số sức khoẻ/tình cảm của Pet (hoãn hoàn toàn trong giai đoạn MVP để tập trung vào chat và ký ức).
2. **SimSimi (Sự Hài Hước Bất Ngờ & Khía Hóm Hỉnh):** Tạo ra những tràng cười Dopamine từ những câu trả lời "khịa" dí dỏm dưới góc nhìn thứ nhất, dám trêu chọc và giận dỗi "Sen".
3. **Neko Atsume / Iyashikei (Sự Chữa Lành Yên Bình & Tri Kỷ Thấu Hiểu):** Không áp lực, chỉ có sự bình yên khi nhìn thú cưng vui đùa, những lời thì thầm ấm áp đêm muộn xoa dịu giông bão tâm lý sau ngày dài mệt mỏi.

---

## 2. Các Tính năng Trọng tâm (MVP Features)

Dự án tập trung vào các phân hệ chính giải quyết triệt để bài toán cảm xúc của người dùng (Safe Vet đã bị loại bỏ vì nằm ngoài định vị):

1. **DOCA PetTwin (Hồ sơ sinh học & Cá tính động):**
   - Quản lý thông tin Boss (loài, giống, độ tuổi, cân nặng, quy đổi tuổi thú cưng sang tuổi người).
   - Thiết lập linh hồn AI của Boss thông qua cấu hình tính cách (Ngáo ngơ, Chảnh chọe, Đanh đá, Nịnh nọt), tông giọng và cách xưng hô riêng dưới góc nhìn thứ nhất.
2. **DOCA Capsule (Nhật ký ký ức đồng hành):**
   - Người dùng tải lên hình ảnh dìm hàng, ghi chép nhanh khoảnh khắc hàng ngày của Boss.
   - **Bộ nhớ RAG:** AI sẽ đọc hình ảnh và nội dung nhật ký để ghi nhớ vào bộ não ảo (Cloud RAG & database timeline) của Boss và đồng bộ dữ liệu đám mây, phục vụ cho việc trò chuyện cá nhân hoá.
3. **Trò chuyện tương tác thời gian thực (Real-time Chat Companion):**
   - Kênh kết nối trực tiếp với linh hồn ảo của Boss sử dụng `socket_io_client` & `web_socket_channel`.
   - Ngôn từ biến thiên bất ngờ mang lại Dopamine tức thì, khơi gợi cảm xúc tri kỷ.
4. **Tiệm Tạp Hóa Namiya (Góc gỡ rối ẩn danh):**
   - Hòm thư gỗ MUJI ấm áp đặt cạnh lọ hoa nhỏ ở trang chủ giúp gửi thư ẩn danh gỡ rối nỗi lòng. Nhận phản hồi từ "ông già Namiya và 3 chú mèo" dưới dạng giao diện Flat tinh khiết.
5. **Tiếp thị Liên kết Ngữ cảnh (Contextual Affiliate Monetization):**
   - Tích hợp tinh tế các liên kết tiếp thị sách, đĩa nhạc, vật phẩm, poster chữa lành ngay trong luồng chat và Góc Cảm Xúc (DOCA Corner) nhằm tạo nguồn doanh thu bền vững mà không phá vỡ triết lý tối giản MUJI.

---

## 3. Công nghệ & Thư viện sử dụng (Tech Stack)

Dự án ứng dụng các thư viện tối tân nhất trong hệ sinh thái Flutter để tối ưu hóa trải nghiệm cảm xúc:

- **Quản lý trạng thái (State Management):** `flutter_riverpod` (quản lý đồng bộ trạng thái chat, bộ nhớ Boss, cảm xúc).
- **Kết nối mạng & Real-time Sockets:** 
  - `dio` & `http` cho các luồng REST API nạp ảnh, đăng nhật ký.
  - `socket_io_client` & `web_socket_channel` duy trì kết nối chat tức thì dưới 1 giây.
- **Xác thực, Bảo mật & Đồng bộ Đám mây (Cloud Sync):**
  - `firebase_core`, `firebase_auth`, `google_sign_in` quản lý tài khoản người dùng nhanh gọn qua 1 chạm và đồng bộ dữ liệu lên máy chủ bảo mật.
  - `flutter_secure_storage` & `shared_preferences` lưu trữ an toàn Token bảo mật và lưu đệm cấu hình cá tính Boss cục bộ.
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
- **`theme/`**: Định nghĩa font chữ `Quicksand` & `Motterdam` hiện đại cùng bảng màu tươi sáng, giàu cảm xúc.
- **`utils/`**: Các hàm tiện ích, định dạng, quản lý Toast hiển thị.
- **`l10n/`**: Cấu hình đa ngôn ngữ Việt/Anh.
- **`gen/`**: Thư mục chứa tài nguyên sinh tự động (Assets, Fonts).
- **`config/`, `data/`, `enums/`**: Các hằng số, cấu hình IP server và dữ liệu tĩnh.

---

## 5. Định hướng Kỹ thuật tiếp theo

1. **Cấu hình Prompt thông minh (System Prompt):** Định hình ngôn từ của AI Chat trong `providers/` để bám sát 4 loại tính cách trong `PetPersona`.
2. **Liên kết Moments với Chat Memory:** Viết logic đẩy dữ liệu nhật ký mới đăng vào ngữ cảnh chat của AI.
3. **Tích hợp mô hình Affiliate Ngữ cảnh:** Kết nối luồng chat và Rương ký ức với API trích xuất thực thể để hiển thị gợi ý sách, nhạc kèm link tiếp thị liên kết.
