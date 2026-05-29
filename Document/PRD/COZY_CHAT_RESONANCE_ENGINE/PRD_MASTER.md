# TÀI LIỆU YÊU CẦU SẢN PHẨM MASTER: COZY CHAT RESONANCE ENGINE
*(MASTER PRODUCT REQUIREMENT DOCUMENT - PRD V1.0)*

> **Mã Tính Năng:** `FE-COZY-CHAT`  
> **Trạng thái:** Hoàn tất Thiết kế & Đối tác (Chờ triển khai)  
> **Tác giả:** Sophia (CPO / PM)  
> **Đơn vị phê duyệt:** Ban Giám đốc Dự án Capcat  

---

## 🧭 1. Tầm Nhìn & Mục Tiêu Sản Phẩm (Product Vision & Goals)

Sứ mệnh tối cao của **Capcat: Soul of Pet** là **chữa lành sự cô đơn của con người đô thị** thông qua việc tái sinh thú cưng ảo thành những tri kỷ sành điệu, ấm áp. 

Phân hệ **Cozy Chat Resonance Engine (FE-COZY-CHAT)** được phát triển nhằm nâng cấp giao tiếp giữa Chủ nuôi (Sen) và Thú cưng ảo (Boss) từ những đoạn chat chatbot thông thường thành một **trải nghiệm cộng hưởng không gian - thời gian thực tế**, đồng thời mở rộng mô hình doanh thu tiếp thị liên kết (affiliate) một cách tinh tế và đậm chất nghệ thuật Iyashikei.

### Mục tiêu cốt lõi:
1.  **Zero-UI Context Sensing:** Tự động đồng bộ hóa nhịp sinh học và vị trí của Sen ngoài đời thực ngầm dưới nền, hoàn toàn loại bỏ các giao diện cài đặt định vị gây phòng thủ tâm lý.
2.  **Cozy Pop Culture & Monetization:** Biến Boss ảo thành tri kỷ có gu nghệ thuật (biết nhạc Jazz, sách Nhã Nam, đĩa nhạc The Beatles). Tích hợp tiếp thị liên kết mượt mà qua các hyperlink màu ấm tự nhiên.
3.  **Empathetic Profile Extraction:** Tự động lắng nghe và trích xuất thông tin sinh học của Pet cũng như thói quen cảm xúc của Sen thông qua các cuộc hội thoại "Mom Test" thấu cảm để làm giàu cơ sở dữ liệu dài hạn.
4.  **Anti-Clingy Regulation:** Khống chế tần suất thông báo đẩy nghiêm ngặt và áp dụng bộ trễ ngẫu nhiên 15-45 phút để bảo tồn không gian tĩnh lặng chữa lành.

---

## 🏛️ 2. Danh Sách Tài Liệu Đặc Tả Trực Thuộc (Specs Index)

Toàn bộ phân hệ được đóng gói nhất quán trong thư mục tính năng [COZY_CHAT_RESONANCE_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/), bao gồm 7 đặc tả kỹ thuật và nghiệp vụ chi tiết:

| Số Thứ Tự | Tên Tài Liệu Đặc Tả | Phạm Vi Giải Quyết |
| :--- | :--- | :--- |
| **01** | [SPEC_01_CULTURAL_RESONANCE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_01_CULTURAL_RESONANCE.md) | Thiết kế Hyperlink hoài cổ, nguồn nhạc 30s iTunes API, Shopee Books Affiliate và Spotify Fallback. |
| **02** | [SPEC_02_CONTEXT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_02_CONTEXT_SENSING.md) | Thư viện định vị Geofencing, nhận diện hành vi di chuyển, mất ngủ đêm khuya, và luồng xin quyền Contextual Opt-In. |
| **03** | [SPEC_03_PROFILE_EXTRACTION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_03_PROFILE_EXTRACTION.md) | Kịch bản hỏi thăm thấu cảm "Cozy Inquiry" theo chuẩn Mom Test để trích xuất thông tin sức khỏe Pet và cảm xúc Sen. |
| **04** | [SPEC_04_INVISIBLE_GEOSPATIAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_04_INVISIBLE_GEOSPATIAL.md) | Thuật toán lập lịch lấy tọa độ ngầm (12h đêm, 10h sáng, 3h chiều) và dán nhãn thông minh (Trường học/Cơ quan) theo độ tuổi. |
| **05** | [SPEC_05_FREQUENCY_COMPASS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_05_FREQUENCY_COMPASS.md) | Hệ thống khống chế tần suất (1 tin/ngày), bộ đệm trễ ngẫu nhiên (15-45 phút) chống vồ vập, âm haptic Purring. |
| **06** | [SPEC_06_STORYTELLING_BACKBONE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_06_STORYTELLING_BACKBONE.md) | Khung xương sống dẫn dắt cốt truyện 3 Giai đoạn (Hook - Lead - Close) và bộ nguyên tắc prompt engineering thấu cảm. |
| **07** | [SPEC_07_EXTERNAL_AMBIENT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_07_EXTERNAL_AMBIENT_SENSING.md) | Cảm nhận thời tiết thực tế bằng OpenWeatherMap API và bơm ngữ cảnh sự kiện văn hóa nghệ thuật thủ công làm Cozy Opener. |
| **08** | [SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md) | Kiến trúc cơ sở dữ liệu (Hybrid Postgres/SQLite) và quy trình chuẩn bị dữ liệu thủ công (CMS) kết hợp dữ liệu tự động cho Cozy Openers. |
| **09** | [SPEC_09_OFFLINE_SANCTUARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_09_OFFLINE_SANCTUARY_ENGINE.md) | Động cơ Trú ẩn Chủ động, thuật toán trộn câu thoại cục bộ (Deterministic Offline Mixer) và hệ thiết kế thính giác/thị giác trầm mặc (Lá rơi, đĩa than offline). |
| **10** | [SPEC_10_VIRTUAL_VINYL_STORE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_10_VIRTUAL_VINYL_STORE.md) | **[PHASE 2 / BACKLOG]** Cửa hàng Đĩa than ảo (Virtual Vinyl Store), trải nghiệm khui đĩa (unboxing), giao diện phát đĩa cơ học (turntable mechanical UI) và cổng thanh toán IAP. |

---

## 🛠️ 3. Ma Trận Kỹ Thuật Thực Tế (The Real-world Technical Stack)

Để đảm bảo tính khả thi cao nhất cho đội ngũ lập trình, Capcat cam kết sử dụng các thư viện kỹ thuật và chương trình đối tác **hoàn toàn có thật, được công nhận toàn cầu và dễ dàng tích hợp**:

### 3.1. Các thư viện Flutter Client (Client Packages)
*   **Background Geofencing:** [flutter_background_geolocation](https://pub.dev/packages/flutter_background_geolocation) – Giải pháp định vị Geofencing tiết kiệm pin chạy ngầm tốt nhất cho cả iOS và Android.
*   **Activity Recognition:** [flutter_activity_recognition](https://pub.dev/packages/flutter_activity_recognition) – Trích xuất trạng thái vận động cơ thể (Walking, Running, Still, In_Vehicle) qua Apple CoreMotion và Android Google Play Services.
*   **Background Job Scheduler:** [workmanager](https://pub.dev/packages/workmanager) (Android) & iOS Native **Background Tasks API** – Hỗ trợ lên lịch đánh thức app ngầm vào 12h đêm, 10h sáng và 3h chiều trong đúng 10 giây.
*   **Audio Background Player:** [just_audio](https://pub.dev/packages/just_audio) & [audio_session](https://pub.dev/packages/audio_session) – Tải luồng và stream nhạc 30s preview MP3 ngầm, quản lý audio focus fade-out/fade-in mượt mà.
*   **Image Compression:** [flutter_image_compress](https://pub.dev/packages/flutter_image_compress) – Nén ảnh dìm hàng ngầm xuống ~80% dung lượng trước khi upload lên S3.
*   **Local Caching Database:** [sqflite](https://pub.dev/packages/sqflite) hoặc [hive](https://pub.dev/packages/hive) – Quản lý bộ đệm ngoại tuyến (Offline cache) cho các thẻ Postcard trivia.

### 3.2. Chương trình Đối tác & API Service (Partners & APIs)
*   **Nguồn Nhạc Preview:** [iTunes Search API](https://performance-partnerize.com/) – Hoàn toàn public, trả về đường dẫn phát thử 30s `previewUrl` trực tiếp mà không cần OAuth đăng nhập.
*   **Tiếp thị liên kết Nhạc:** **Apple Services Affiliate Program** (quản lý thông qua mạng lưới toàn cầu **Partnerize**) – Duyệt nhanh tại Việt Nam, hoa hồng tính bằng USD.
*   **Tiếp thị liên kết Sách & Sản phẩm:** **Shopee Partner Program (Shopee Mall)** – Đăng ký duyệt tự động trong 5 phút. Hỗ trợ liên kết đến các gian hàng Shopee Mall uy tín của **Nhã Nam**, **Bloom Books**, **Phục Hưng Books**.

---

## 🔒 4. Ranh Giới Đỏ Về Quyền Riêng Tư (Privacy Redlines)

1.  **Tuyệt đối không gửi tọa độ GPS thô lên đám mây:** Toàn bộ tọa độ địa lý của Nhà riêng, Cơ quan hay Trường học đều được tính toán và gom cụm cục bộ (On-Device) trên thiết bị của người dùng thông qua SQLite/Hive mã hóa.
2.  **Tín hiệu sự kiện đã ẩn danh:** Client chỉ gửi các tín hiệu sự kiện phi định dạng lên Backend (Ví dụ: `{ "event": "enter_home_late" }` hoặc `{ "event": "insomnia_detected" }`).
3.  **Tính năng Memory Vault:** Cung cấp giao diện minh bạch tại Profile, cho phép Sen chủ động chỉnh sửa hoặc xóa bỏ bất kỳ ký ức nào Boss đang ghi nhớ về mình.

---

## 📈 5. Chỉ Số Đo Lường Hiệu Quả (Success Metrics)

*   **Chỉ số Gắn kết (Retention & Session Duration):** Tăng thời gian sử dụng màn hình chat thêm 20% nhờ kịch bản biến thiên thăng hoa và nghe thử nhạc Yesterday.
*   **Tỷ lệ Click Hyperlink (CTR):** Dự kiến đạt **8.0% - 12.0%** đối với tệp người trẻ hướng nội thích nhạc Lofi và sách chữa lành (cao gấp 8 lần banner quảng cáo thông thường).
*   **Doanh thu trên mỗi người dùng hoạt động (ARPU):** Tăng trưởng 15% thông qua việc mở bán Đĩa than ảo (Virtual Vinyl) trong Cửa hàng Ký ức bằng tiền thật.
