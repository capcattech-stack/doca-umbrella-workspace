# TÀI LIỆU YÊU CẦU SẢN PHẨM MASTER: HỘP KÝ ỨC & TRÒ CHƠI SWIPE DOPAMINE
*(MASTER PRODUCT REQUIREMENT DOCUMENT - PRD V1.0)*

> **Mã Tính Năng:** `FE-MEMORY-VAULT`  
> **Trạng thái:** Hoàn tất Thiết kế (Sẵn sàng triển khai)  
> **Tác giả:** Sophia (CPO / PM)  
> **Đơn vị phê duyệt:** Ban Giám đốc Dự án Capcat

---

## 🧭 1. Tầm Nhìn & Mục Tiêu Sản Phẩm (Product Vision & Goals)

Sứ mệnh tối cao của **Capcat: Soul of Pet** là chữa lành sự cô đơn của con người đô thị bằng cách nhân cách hóa chú thú cưng ngoài đời thực của họ thành tri kỷ số độc bản.

Phân hệ **Hộp Ký Ức & Trò chơi Buffet Ký ức Tinder Game (FE-MEMORY-VAULT)** được phát triển nhằm nâng cấp trải nghiệm nạp hình ảnh/kỷ niệm của Boss vào hệ thống dữ liệu ký ức của Capcat với trải nghiệm **không xâm phạm quyền riêng tư**, **tiện lợi cực cao (dưới 5 giây)**, mang tính giải trí gây nghiện (Gamified Dopamine) và kích thích tương tác cảm xúc ngay lập tức giữa Sen và Boss ảo.

### 1.1. Tuyên Ngôn Triết Lý Cốt Lõi (The Master Core Philosophy)
> 🐾 **"Khi tôi tự động đọc ảnh của bạn tui chỉ đọc ảnh có thú cưng (để bảo vệ quyền riêng tư). Tuy nhiên kỷ niệm nào của bạn tui cũng có thể lưu trữ cho bạn (nếu nạp thủ công). Tôi ôn lại kỷ niệm với bạn bằng những kỷ niệm chúng ta đã chia sẻ trong Hộp Ký Ức."**

*   **Ranh giới Quyền Riêng Tư (Privacy Boundary):** Trình quét tự động (Background Scan) và Trò chơi Buffet Ký ức (Swipe Game) **chỉ lọc và hiển thị ảnh có thú cưng** (chó, mèo). Người dùng tuyệt đối không bị cảm giác xâm phạm đời tư khi chơi.
*   **Chủ quyền Dữ liệu của Sen (User Data Sovereignty):** Tuy quét tự động chỉ đọc ảnh thú cưng, nhưng **bất kỳ kỷ niệm/hình ảnh nào** (kể cả không có thú cưng) cũng đều có thể lưu trữ vào Hộp Ký Ức nếu người dùng lựa chọn tải lên thủ công.
*   **Tài nguyên Thấu Hiểu (RAG Context Data Asset):** Ký ức chính là tài sản lớn nhất để Boss ảo thấu hiểu chủ nuôi. Mọi kỷ niệm đã lưu trong Vault (đã chia sẻ) sẽ là chất liệu duy nhất để Boss ôn lại kỷ niệm xưa qua phân hệ Recall Flashback (Hộp Thư Cổ Kính) và RAG Cozy Chat.

### 1.2. Mục tiêu cốt lõi:
1.  **Dopamine Swipe Interaction:** Biến luồng upload ảnh tẻ nhạt thành trò chơi vuốt thẻ bài 5 giây giống Tinder vuốt 3 hướng (Trái, Phải, và cử chỉ **Vuốt Lên - Golden Memory** tích hợp thả tim, comment viết tay và dập con dấu sáp mèo đỏ).
2.  **Zero-Intrusion Local ML Filter & Intelligence Cache:** Quét ngầm cục bộ 100% bằng **Google ML Kit** không gửi ảnh thô lên server. Vận hành **Động cơ làm giàu ngầm gián đoạn mỗi ngày 20-30 ảnh** để tích hợp thông tin hành động Pet (`sleeping`, `eating`, `playing`) và bối cảnh vào cơ sở dữ liệu đệm SQLite nhằm tránh quét lại, đồng thời hồi sinh ảnh bỏ qua thông minh sau 4 tuần.
3.  **Local Meme Compositing (0đ):** Cắt khuôn mặt Pet cục bộ và ghép đè vào 15 mẫu khung Meme Chibi hoài cổ vẽ tay để chia sẻ Story ngoài tăng trưởng viral 0đ, tách biệt hoàn toàn để giữ album kỷ niệm Hộp Ký Ức nguyên bản 100% linh thiêng.
4.  **Sự Minh Bạch Dữ Liệu Tối Cao & Tích Hợp Chat:** Trưng bày Polaroid mộc mạc Japandi cảm ứng Gyroscope và trao **Quyền tối cao** cho Sen được tải sao lưu .zip hoặc xóa vĩnh viễn dữ liệu. Đồng thời, biến metadata hành động/bối cảnh thành chất xúc tác bơm trực tiếp vào Cozy Chat Engine tạo hội thoại chữa lành siêu thực.
5.  **Doanh thu nhân văn (Premium Coexistence):** Từ chối tống tiền cảm xúc. Giữ Hộp Ký Ức miễn phí trọn đời. Doanh thu kiếm từ **Dịch vụ in ảnh thật Polaroid giao tận nhà (Instax Delivery 19k-29k)**, Visual skins dán Washi, và Rewarded Ads tăng lượt quét.
6.  **Nhật ký chăm sóc mộc mạc (Care Diary Engine):** Ghi chép 16 loại sự kiện từ làm đẹp đến tiêm ngừa thông qua nút bấm thủ công hoặc tự động trích xuất ý định (Intent Detection) từ Cozy Chat, đồng thời nhắc hẹn bằng giọng nói Boss.
7.  **Nhận dạng cá thể thú cưng (Pet Visual Fingerprint Engine):** Nhận dạng và phân biệt từng chú thú cưng trong gia đình đa boss bằng TFLite MobileNetV3 small trích xuất 1024 chiều đặc trưng cục bộ, giúp cá nhân hóa toàn diện album, nhật ký và hội thoại.

---

## 🏛️ 2. Danh Sách Tài Liệu Đặc Tả Trực Thuộc (Specs Index)

Toàn bộ phân hệ được đóng gói nhất quán trong thư mục tính năng [MEMORY_VAULT_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/), bao gồm 8 đặc tả kỹ thuật và nghiệp vụ chi tiết:

| Số Thứ Tự | Tên Tài Liệu Đặc Tả | Phạm Vi Giải Quyết |
| :---: | :--- | :--- |
| **01** | [SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md) | Vật lý vuốt kéo thẻ bài 3D, spring animation, phản hồi rung Haptic. |
| **02** | [SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md) | Bộ lọc ảnh offline cục bộ bằng **Google ML Kit**, tích hợp nhận diện cá thể (SPEC-08), sinh chú thích lãng đãng offline. |
| **03** | [SPEC_03_MEME_CARD_COMPOSITING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_03_MEME_CARD_COMPOSITING.md) | Cắt ghép mặt Pet vào 15 khung hình meme chibi bằng Canvas, xuất ảnh có logo watermark. |
| **04** | [SPEC_04_FEED_MOMENTS_INTEGRATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_04_FEED_MOMENTS_INTEGRATION.md) | Hàng đợi tải ảnh nền ngầm FIFO, auto-hide banner to ở trang Home sau khi chơi xong. |
| **05** | [SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md) | Giao diện Hộp Ký Ức Polaroid viết tay mộc mạc, hiệu ứng lật thẻ 3D, nút Sửa/Xóa vĩnh viễn ký ức. |
| **06** | [SPEC_06_LEAN_GACHA_MONETIZATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_06_LEAN_GACHA_MONETIZATION.md) | Quảng cáo video nhận thưởng (Rewarded Ads), cửa hàng Pate Coins và Google Sheets CMS Tab 5. |
| **07** | [SPEC_07_CARE_DIARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_07_CARE_DIARY_ENGINE.md) | Nhật ký ghi nhận sự kiện chăm sóc và dấu mốc của Pet. Nhận diện ý định Cozy Chat & Safe-Vet AI. |
| **08** | [SPEC_08_PET_INDIVIDUAL_RECOGNITION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_08_PET_INDIVIDUAL_RECOGNITION.md) | Nhận dạng cá thể Pet bằng TFLite MobileNetV3 small & Cosine Similarity cho người dùng nuôi 2+ boss. |

---

## 🛠️ 3. Ma Trận Kỹ Thuật Thực Tế (The Real-world Technical Stack)

Để đảm bảo tính khả thi cao nhất cho đội ngũ lập trình, Capcat cam kết sử dụng các thư viện kỹ thuật hoàn toàn có thật và dễ dàng tích hợp:
*   **Vật lý vuốt thẻ bài:** [flutter_card_swiper](https://pub.dev/packages/flutter_card_swiper) – Package vuốt thẻ tốt nhất của Flutter hỗ trợ đầy đủ kéo, xoay nghiêng 3D mượt mà.
*   **Nhận diện ảnh cục bộ:** [google_mlkit_image_labeling](https://pub.dev/packages/google_mlkit_image_labeling) – Chạy offline 100% không tốn chi phí gọi mạng.
*   **Nhận diện cá thể thú cưng (SPEC-08):** [tflite_flutter](https://pub.dev/packages/tflite_flutter) – Load model MobileNetV3-Small (2.5MB) trích xuất 1024-dim embedding vector cục bộ và so sánh Cosine Similarity.
*   **Đồ họa & Repaint:** `RepaintBoundary` & `CustomPainter` tích hợp sẵn trong Flutter – Kết xuất ảnh meme chất lượng cao 3x mà không cần GPU đám mây.
*   **Tải ảnh ngầm:** [dio](https://pub.dev/packages/dio) – Quản lý hàng đợi FIFO Background Upload Queue.
*   **Tích hợp Quảng cáo:** [google_mobile_ads](https://pub.dev/packages/google_mobile_ads) – Hiển thị video quảng cáo nhận thưởng (Rewarded Video Ads).
*   **Bộ nhớ đệm & CSDL cục bộ:** [sqflite](https://pub.dev/packages/sqflite) – Quản lý trạng thái hoàn thành Buffet, lưu trữ metadata cache hình ảnh `local_photo_intelligence_cache`, ảnh tham chiếu `pet_reference_photos` và sự kiện nhật ký `care_diary_events`.
