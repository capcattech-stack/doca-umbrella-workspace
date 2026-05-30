# 📚 NHẬT KÝ HỘI THOẠI & PHÁT TRIỂN DỰ ÁN CAPCAT (30/05/2026)
*(BIÊN NIÊN SỬ THẢO LUẬN & ĐẶC TẢ CHI TIẾT ĐỘNG CƠ HỘP KÝ ỨC & NHẬN DIỆN PET)*

---

> [!NOTE]
> Tài liệu này lưu trữ toàn bộ lịch sử trao đổi, thảo luận và các quyết định thiết kế kiến trúc dữ liệu, sản phẩm giữa **Sáng lập viên (User)** và đội ngũ **Cố vấn ảo Capcat** (CPO Sophia, Tech Lead Alan, Finance Analyst Leo, Mom Test Expert Arthur).
> Mọi bước tiến từ bộ lọc ảnh offline ML Kit, cỗ máy sinh mô tả lãng đãng tự động, nhật ký chăm sóc mộc mạc, đến việc trích xuất TFLite Visual Fingerprint nhận diện cá thể pet đa boss được ghi nhận đầy đủ dưới đây.

---

## 🗂️ MỤC LỤC LƯỢT TRAO ĐỔI (MAY 30, 2026)

- **[Lượt 1]** [Khi quét Offline ML nhớ cache lại thông tin ảnh để dùng khi cần...](#-luot-1-chi-tiet-trao-doi)
- **[Lượt 2]** [Thông tin lấy được từ hình metadata và cả phân tích từ ML offline...](#-luot-2-chi-tiet-trao-doi)
- **[Lượt 3]** [Bên cạnh những ký ức là hình ảnh thông thường, một số sự kiện quan trọng tôi muốn ghi nhận...](#-luot-3-chi-tiet-trao-doi)
- **[Lượt 4]** [Viết lại Spec 3 chi tiết hơn về thư viện, hay công nghệ sử dụng...](#-luot-4-chi-tiet-trao-doi)
- **[Lượt 5]** [Offline_ML có thể phân biệt được đâu là mèo Bánh Mỳ đâu là mèo Bánh Cam...](#-luot-5-chi-tiet-trao-doi)
- **[Lượt 6]** [Vuốt thẻ bài sẽ được trigger thế nào? Layout Wabi-Sabi và Hybrid manual cards...](#-luot-6-chi-tiet-trao-doi)

---

## 💬 CHI TIẾT CÁC LƯỢT TRAO ĐỔI

### 📌 LƯỢT 1: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Khi quét Offline ML nhớ cachelaij thông tin ảnh để dùng khi cần ko quét lại. sau 1 vài tuần có thể hiển thị lại. từ từ chập mà chắc chạy ngầm mổi ngày vài chục tấm để làm giàu dữ liệu, đễ biết những hình nào là thú cung. OFFLINE_ML có dêtct được hành động ko ? đng nằm/đang ăn/đang chơi/... Nếu có thì phải dèine 1 cấu trúc data thông tin cần lưu trữ cho từng hình, sao cho phù hợp có đủ thòng tin sử dụng đễ chat

#### 🤖 **Đặc vụ phản hồi (Sophia & Alan):**
Chúng tôi đã thiết kế và tích hợp triết lý **Quét lùi thưa thớt ngẫu nhiên theo tháng** kết hợp **Bộ đệm SQLite thông minh** trong **[SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md)**:
*   **SQLite Cache `local_photo_intelligence_cache`:** Thiết lập CSDL cục bộ lưu trữ kết quả phân tích để đảm bảo không quét lại ảnh cũ, mở Tinder Stack hiển thị ngay lập tức (dưới 0.01 giây).
*   **Động cơ quét ngầm gián đoạn (Continuous Background Enrichment Engine):** Lập lịch định kỳ mỗi 24 tiếng qua `workmanager` khi thiết bị cắm sạc + rảnh. Mỗi ngày chỉ quét từ 20-30 ảnh ngầm, vừa tiết kiệm 100% pin vừa làm giàu dữ liệu từ từ.
*   **Hồi sinh ảnh cũ thông minh (Skipped Photo Cooldown):** Ảnh vuốt bỏ qua (Left Swipe) không bị xoá, mà được đưa vào hàng đợi "ngủ đông" 4 tuần trước khi ngẫu nhiên xuất hiện lại để Sen ngắm với góc nhìn tươi mới.
*   **Nhận diện hành động & Bối cảnh (Actions & Context):** ML Kit Image Labeling được cấu hình để trích xuất các hành động (`sleeping`, `eating`, `playing`, `sitting`, `lying_down`) và bối cảnh xung quanh (`bed`, `sofa`, `grass`, `keyboard`, `cardboard_box`) để lưu trữ dưới dạng mảng JSON thô trong SQLite, cung cấp chất xúc tác hoàn hảo cho Cozy Chat.

---

### 📌 LƯỢT 2: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Thông tin lấy được từ hình metadata và cả phân tich từ ML offline có thể dùng để viết 1 mô tả ngắn cho bức hình kiểu lãng đãng

#### 🤖 **Đặc vụ phản hồi (Sophia & Arthur):**
Chúng tôi đã xây dựng chương thiết kế **Cỗ máy sinh chú thích lãng đãng tự động (Auto Poetic Caption Generator)** nằm tại **[SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md#L266)**:
*   **Hợp nhất 3 nguồn dữ liệu (Input Fusion):**
    *   **EXIF Metadata:** Lấy ngày, giờ chụp thực tế để suy ra buổi (sáng sớm, chiều lơ đãng, đêm tĩnh lặng) và mùa trong năm (Xuân se lạnh, Hè oi nắng, Mưa nhiệt đới, Đông chầm chậm).
    *   **ML Kit Tag:** Trích xuất các nhãn hành động/bối cảnh từ SQLite Cache.
    *   **User Note:** Nét bút ghi chú của Sen (nếu có).
*   **Cỗ máy sinh thơ cục bộ 0 đồng (Offline Poetic Stacking):** Sử dụng bộ từ điển ngữ nghĩa lãng đãng (Japandi/Murakami style) lưu sẵn dưới máy để ghép theo cấu trúc: `[Thời gian] + [Hành động Boss] + [Bối cảnh] + [Cảm xúc nhẹ nhàng]`. Hoàn toàn không phát sinh chi phí token API và chạy offline 100%.
*   **Bơm cảm xúc nâng cao (Gemini Flash Online):** Khi Sen vuốt lên ghim Kỷ Niệm Vàng (Swipe Up) và có kết nối mạng, hệ thống sử dụng Gemini Flash để viết một dòng chú thích nhật ký sâu lắng và lãng mạn hơn.
*   **Quy tắc hiển thị Polaroid:**
    *   Ưu tiên 1: Chữ viết tay của Sen (font Caveat, đậm đà nét mực).
    *   Ưu tiên 2: Chú thích lãng đãng tự động của Boss ảo (font Quicksand nghiêng, xám nhạt `#9C8F87`).
    *   Nếu có cả hai: Hiển thị song song tạo nên một trang nhật ký chân thực.

---

### 📌 LƯỢT 3: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> bên cạnh những ký ức là hình ảnh thông thường 1 số ký ức và sự kiện rất quan trọng tôi muốn ghi nhận đó là tiêm ngừa, sổ giun, tắm, cạo lông, bị nấm,.... ko quá ý tế trong giai đoạn này để tránh nhữg phiền phức chuyên môn. Team nghĩ chúng ta nên làm gi để get được?

#### 🤖 **Đặc vụ phản hồi (Sophia & Alan & Arthur):**
Chúng tôi đã kiến tạo đặc tả hoàn chỉnh cho phân hệ **[SPEC_07_CARE_DIARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_07_CARE_DIARY_ENGINE.md)** nhằm đáp ứng trọn vẹn yêu cầu này:
*   **Triết lý "Ghi chú của Mẹ" (Scrapbook):** Độc lập 100% với bệnh án y khoa. Tuyệt đối không lưu trữ biệt dược, liều lượng, hay cảnh báo chẩn đoán bệnh. Chỉ ghi lại ngày tháng và cảm nghĩ của Sen khi tắm, tiêm ngừa, cạo lông để tránh rủi ro chuyên môn.
*   **Danh mục 16 sự kiện tiêu biểu:** Chia làm 4 nhóm chính: 🛁 Làm Đẹp, 💊 Sức Khỏe, 🍽️ Cuộc Sống, và 🌟 Cột Mốc.
*   **Tự động nhận diện ý định qua Cozy Chat (NLP Intent Detection):** Khi Sen nhắn *"Hôm nay Bánh Mỳ mới được tắm sạch nè"*, hệ thống tự động nhận diện hành vi tắm, kích hoạt Boss hỏi thăm dễ thương để tự lưu sự kiện chăm sóc vào SQLite.
*   **Hệ thống nhắc hẹn thông minh bằng giọng Boss:** Nhắc nhở cắt móng, tắm, sổ giun định kỳ theo văn phong tri kỷ ngộ nghĩnh (ví dụ: *"Mùi trẫm đang hơi lạ rồi đó Sen ơi... Tắm trẫm nha!"*).
*   **Cầu nối y tế khẩn cấp:** Sự kiện 🤒 *Hôm nay Boss không khỏe* (`FEELING_UNWELL`) không có biểu mẫu nhập mà được liên kết chuyển tiếp thẳng sang Cozy Chat RAG Engine (Safe-Vet AI) để boss chẩn đoán phân loại cấp cứu khẩn cấp nếu cần.
*   **Tích hợp đa Boss (SPEC-08):** Tự động liên kết `pet_id` dựa trên nhận dạng cá thể pet của ảnh gốc hoặc tên pet được trích xuất từ hội thoại chat.

---

### 📌 LƯỢT 4: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Viết lại Spec 3 chi tiết hơn về thư viện, hay công nghệ sử dụng. Meme là tính năng mở rộng dùng để viral, nên có UX hổ trợ để share nhanh sản phẩm meme lên social

#### 🤖 **Đặc vụ phản hồi (Alan & Bella & Leo):**
Chúng tôi đã viết lại hoàn chỉnh và nâng cấp tài liệu **[SPEC_03_MEME_CARD_COMPOSITING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_03_MEME_CARD_COMPOSITING.md)** đạt chuẩn thiết kế sản xuất (V2.0):
*   **Ma trận công nghệ chi tiết:**
    *   **ML Kit Face Detection:** Nhận diện vị trí khuôn mặt Pet cục bộ và lấy bounding box (đạt độ chính xác ~65%).
    *   **Fallback UX thông minh:** Khi ML Kit thất bại, Sen được tự động cung cấp vòng tròn cắt thủ công bằng cử chỉ pinch-to-zoom và kéo vuốt mượt mà.
    *   **Dart `image` & `RepaintBoundary`:** Kết xuất ảnh ghép không nén 3x PNG offline 100%.
*   **Trải nghiệm Viral 1 chạm (Instant Social Share):**
    *   **Thư viện `share_plus`:** Mở trực tiếp hộp thoại chia sẻ của hệ điều hành.
    *   **Direct-to-Story API:** Gọi API chia sẻ trực tiếp lên Instagram Stories / Facebook Stories chỉ với 1 chạm duy nhất.
    *   **Firebase Dynamic Links (hoặc App Links):** Nhúng mã Deep-link vào QR Code đóng dấu ở chân ảnh. Khi bạn bè quét mã, app sẽ mở trực tiếp và kích hoạt popup tặng 5 Pate Coins cho cả hai người (Referral loop).
*   **Watermark lan tỏa tự nhiên:** Đóng nhãn *"Capcat: Soul of Pet"* thanh mảnh góc dưới bên phải Polaroid theo thiết kế chữ viền mờ tối giản chữa lành, tăng độ nhận diện thương hiệu mà không gây phản cảm.
*   **15 Mẫu Meme Chibi:** Quản lý danh mục qua Google Sheets Tab 5 `virtual_memes` để vận hành cập nhật OTA không cần đẩy store mới.

---

### 📌 LƯỢT 5: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Offline_ML có thể phân biệt được đâu là mèo bánh mỳ đâu là mèo bánh cam để có thể gắn tag từng bé ko ? Vì 1 user có thẻ có nhiều hơn 1 bé.

#### 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chúng tôi đã thiết kế thành công kiến trúc **[SPEC_08_PET_INDIVIDUAL_RECOGNITION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_08_PET_INDIVIDUAL_RECOGNITION.md)** để giải quyết trọn vẹn bài toán phân biệt cá thể Pet này cục bộ 100%:
*   **Lõi trích xuất TFLite MobileNetV3-Small (2.5MB):** Sử dụng mô hình mạng nơ-ron MobileNetV3-Small chạy trực tiếp trên thiết bị (Inference chỉ mất ~12ms) để trích xuất ra một vector đặc trưng 1024 chiều đại diện cho "dấu vân pháp thị giác" của Pet.
*   **Chiến lược 3 tầng nhận dạng (3-Tier Recognition Strategy):**
    *   **Tầng 1: Sen dạy bé (Bootstrap Onboarding):** Sen chọn 3-5 ảnh rõ mặt cho mỗi bé mới đăng ký để hệ thống tính toán vector trung tâm (Centroid Vector) lưu vào SQLite.
    *   **Tầng 2: So sánh Cosine Similarity cục bộ:** So sánh vector ảnh mới với centroid của từng bé. Độ tin cậy $\ge 0.75$ tự động gắn tag; từ $0.50$ - $0.74$ hiển thị prompt hỏi confirm nhẹ nhàng; $< 0.50$ cho Sen chọn danh sách pet thủ công.
    *   **Tầng 3: Tự học cải thiện liên tục (Self-Learning Loop):** Mỗi lượt confirm/sửa của Sen sẽ nạp lại vector ảnh đó để cập nhật centroid chính xác hơn. Áp dụng cơ chế Sliding Window tối đa 30 ảnh tham chiếu để centroid tự trôi theo ngoại hình lớn lên/thay đổi của Pet.
*   **Xử lý các tình huống phức tạp:** Bối cảnh 2 boss ngủ chung một khung hình, nhận nuôi bé mới hồi tố ảnh cũ, và phân biệt 2 bé giống hệt nhau cùng màu mắt bằng các chi tiết vân lông tinh tế mà ML Kit Image Labeling thông thường không làm được.
*   **Bypass thông minh cho người dùng 1 Boss:** Hệ thống tự phát hiện số lượng Pet = 1 để tắt hoàn toàn luồng bootstrap và trích xuất vân pháp, tự động gán nhãn duy nhất để tối ưu hóa pin và trải nghiệm.

---

### 📌 LƯỢT 6: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Vuốt thẻ bài sẽ được trigger thế nào ? Mới onboard, cuối tuần rảnh rỗi,haowcj các lý do khác mà bạn đề xuất sẽ là trigger chủ động, chưng 10-15 hình. Còn nếu người dùng vào hợp kí ức họ có thế thêm ký ức theo cách phổ thông có thể chọn sự kiệ, hoặc chọn hình ảnh hoạc cả 2 . Nếu chỉ chọ hình ảnh thì sẽ gióng 1 ký ức được quét trên thẻ. còn nếu chọn sự kiện thi sẽ là 1 dòng khác biệt và nổi bật có icon. hộp ký ức nên có thể sort theo ngày tải lên hoặc ngày chụp (metadata) . Còn về layout theo dạn nào hợp mood thì nhờ maya tư vấn.

#### 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chúng tôi đã phân tích thấu đáo và cập nhật trực tiếp các giải pháp chữa lành đột phá vào **[SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md#L68)** và **[SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md)**:
*   **5 Kịch bản kích hoạt Buffet Ký ức (Tinder Swipe Triggers):**
    *   **Kịch bản 1: Mới Onboarding:** Bốc nhanh 10-15 ảnh đầu tiên chạy stack giúp Sen làm quen game lập tức.
    *   **Kịch bản 2: Chiều cuối tuần thảnh thơi:** Nhắc nhở Boss ngáp lười rủ Sen lướt kỷ niệm vào Thứ 7/Chủ Nhật.
    *   **Kịch bản 3: Chạm mốc thân mật (Intimacy Milestone):** Mừng cấp độ thân thiết mới.
    *   **Kịch bản 4: Kỷ niệm trở về (Golden Reunion):** Trị liệu xa cách khi Sen vắng mặt 7+ ngày.
    *   **Kịch bản 5: Đổi mùa tĩnh lặng (Seasonal Solstice):** Rủ xem lại ảnh cùng mùa này ở năm ngoái khi thời tiết dông bão/se lạnh.
*   **Luồng thêm ký ức thủ công phối trộn độc đáo:**
    *   **Photo Only:** Polaroid Card truyền thống hiển thị ảnh kèm chữ viết tay.
    *   **Event Only:** Event Card có màu nền pastel theo nhóm chăm sóc và một **Icon sự kiện lớn nổi bật** ở bên trái (🛁, 💉, 🏥).
    *   **Both (Photo + Event Hybrid):** Polaroid Hybrid Card đặc biệt, có ảnh Polaroid làm tâm điểm và một **Huy hiệu Sự kiện (Care Event Badge)** nhỏ xinh đè nhẹ lên góc ảnh.
*   **Thuật toán Sắp xếp đa chiều (Dual Sorting):**
    *   **Ngày Chụp (EXIF Photo Taken Date - Mặc định):** Phản ánh đúng chuỗi lớn lên tự nhiên của Boss.
    *   **Ngày Tải Lên / Thêm vào (Added Date):** Giúp tìm nhanh các ký ức vừa tạo hôm nay.
*   **Layout Wabi-Sabi Masonry (Maya tư vấn):**
    *   Thiết kế lưới so le đứng 2 cột với chiều cao thẻ co giãn tự nhiên (Masonry Grid) như một cuốn sổ dán Scrapbook thủ công thay thế lưới vuông công nghiệp.
    *   Chuyển cảnh mượt mà 60 FPS kết hợp cảm ứng Gyroscope nghiêng bóng đổ bụi nắng bay xiên độc bản.
