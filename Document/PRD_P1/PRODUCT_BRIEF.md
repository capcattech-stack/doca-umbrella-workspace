# 📝 TÀI LIỆU PRODUCT BRIEF: DOCA MVP (PHASE 1)

---

## 🧭 I. ĐỊNH VỊ SẢN PHẨM & TẦM NHÌN MVP (PRODUCT POSITIONING & VISION)

Ứng dụng **DOCA** (Soul of Pet) là nền tảng di động chữa lành cảm xúc, kết nối linh hồn kỹ thuật số độc bản của thú cưng với chủ nuôi (Sen). Mục tiêu tối thượng của phiên bản **MVP (Phase 1)** là chứng minh giả thuyết sản phẩm cốt lõi: **"Người trẻ đô thị sẵn sàng trò chuyện, lưu trữ ký ức và nhận tương tác thấu cảm từ Pet Twin kỹ thuật số để xoa dịu nỗi cô đơn."**

Sản phẩm được xây dựng xung quanh việc hiện thực hóa **4 Cột Trụ Trải Nghiệm** và tuân thủ chặt chẽ tinh thần **Iyashikei (Chữa lành Nhật Bản)** cùng ngôn ngữ thiết kế **MUJI Warm Minimalism**. Để đáp ứng hiệu năng xử lý ngôn ngữ tự nhiên tối ưu và đảm bảo **ký ức của thú cưng không bao giờ biến mất khi người dùng đổi thiết bị**, MVP chuyển đổi mô hình lưu trữ sang kiến trúc **Đồng bộ Đám mây Bảo mật & Cloud RAG**.

---

## 🏛️ II. BẢN ĐỒ TÍNH NĂNG GIAI ĐOẠN MVP (MVP FEATURE SCOPE)

MVP tập trung nguồn lực phát triển vào các phân hệ cốt lõi với cấu trúc Client-Server bảo mật, xoay quanh điểm tựa là Trang Chủ:

### 1. Phân hệ Nền tảng: Authentication & Onboarding
*   **Google SSO & OTP:** Cổng đăng nhập tối giản 1-Click.
*   **Soul Mirror Scan (Gương soi linh hồn):** Quét ảnh chụp thú cưng bằng ML Kit cục bộ hoặc API nhận diện đám mây để trích xuất màu lông chuẩn, phân tích giống loài và tự động gợi ý **1 trong 4 tính cách AI** (Ngáo ngơ, Chảnh chọe, Đanh đá, Nịnh nọt).
*   **Avatar Ghibli Presets:** Đối với trường hợp ảnh mờ hoặc người dùng chọn bỏ qua, hệ thống tự động gán ảnh minh họa màu nước phong cách Studio Ghibli cục bộ độc quyền (không chibi).

### 2. Trang Chủ Bình Yên (Cozy Dashboard - Trái Tim Trải Nghiệm Cảm Xúc)
Màn hình đầu tiên Sen nhìn thấy khi mở ứng dụng, được thiết kế như một căn phòng khách tĩnh lặng, mộc mạc của Boss cưng. Đây là trung tâm kết nối và khơi gợi nhiều cảm xúc bình yên nhất:
*   **Ngôn ngữ thị giác phẳng (Flat Muji Grid):** Bố cục ngăn nắp, hạn chế tối đa các đường viền đậm màu, tận dụng negative space rộng rãi trên nền kem giấy tái chế ấm áp `#FBFBFA`.
*   **Ambient Weather & Circadian Light (Cộng hưởng sinh học):** AppBar hiển thị thời tiết thực tế tại địa phương (Ví dụ: `⛅ Hà Nội, 24°C` hoặc `🌧️ Sài Gòn, Cozy Rain`). Màu nền toàn trang chuyển động mờ nhạt (Watercolor gradient) đồng bộ theo múi giờ mặt trời thực tế, tự động chuyển sang chế độ Cozy Dark Mode vào lúc 22h00 đêm để xoa dịu võng mạc.
*   **Khung Ảnh Kỷ Niệm Chân Thực (Real Pet Memory Canvas):** Vị trí trung tâm Trang chủ hiển thị **hình ảnh chụp thực tế và các khoảnh khắc kỷ niệm chân thật của thú cưng** do chính chủ nuôi đăng tải (được thiết kế theo tỷ lệ Polaroid viền kem phẳng hoặc Muji Card, tự động lấy từ Moment gần nhất).
    *   *Chạm/Giữ Khung Ảnh:* Kích hoạt nhịp rung mô phỏng tiếng mèo gừ/chó thở (Purring Haptic Motor) và hiển thị bong bóng lời nhắn thì thầm ấm áp (`DOCA Whispers`) dựa trên bối cảnh thời gian hoặc ký ức cũ.
*   **Phân vai Minh họa Ghibli hệ thống (System Ghibli Illustrations):** Tranh phác họa màu nước phong cách Studio Ghibli (không chibi, không hoạt hình dẹt công nghiệp) được dành riêng cho các trạng thái hệ thống UI: xuất hiện trên popup chào mừng, sheet thông báo y tế/cảnh báo ấm áp, màn hình trống (blank page) khi Sen chưa tải ảnh thật nào lên, và mascot Ông lão Namiya.
*   **Hòm Thư Bưu Điện Namiya (Mailbox Slot):** Một khe nhận thư gỗ phẳng tối giản bám ở góc màn hình bên cạnh một chậu hoa nhỏ. Khi có thư tay phản hồi ẩn danh mới gửi về từ Admin/Mascot, một chấm tròn báo tin màu cánh đào ấm (`● #FFE0B2`) sẽ thầm lặng phát sáng.
*   **Moments Card Highlight:** Một khung ảnh Polaroid nhỏ hiển thị khoảnh khắc nhật ký gần nhất của Sen. Chạm nhẹ sẽ lật trượt 2D phẳng mượt mà (<0.15s) dẫn lối vào rương ký ức.

### 3. Phân hệ Cozy Chat Resonance (Phòng Chat Tri Kỷ)
*   **Hội thoại cá nhân hóa:** Trò chuyện 2 chiều với Pet ảo sử dụng LLM tích hợp Prompt thấu cảm xử lý trên Cloud backend, xưng hô theo đúng cá tính Pet đã chọn.
*   **Ambient Sensing (Cảm biến ngữ cảnh):** Tự động đổi màu nền chat theo thời tiết (Watercolor Rain/Sunlight) và giờ thực tế, đồng bộ với Trang chủ.
*   **Cozy Openers:** Pet tự nhắn tin mở lời hỏi thăm vào 9h sáng (dạng trắc nghiệm điền hồ sơ) hoặc gửi lời thì thầm đêm muộn (`DOCA Whispers`) hiển thị ngoài màn hình khóa thông qua thông báo đẩy cục bộ.

### 4. Phân hệ DOCA Capsule (Chiếc Rương Kỷ Niệm)
*   **Timeline ký ức đồng bộ:** Cơ sở dữ liệu SQLite cục bộ lưu giữ các Moment (ảnh kèm ghi chú do Sen đăng), nhật ký y tế, và các đoạn chat, tự động đồng bộ lên cơ sở dữ liệu server để bảo toàn dữ liệu khi đổi thiết bị.
*   **Recall Flashback:** Pet tự động truy xuất các kỷ niệm trong rương (thông qua Cloud RAG) để gợi mở câu chuyện cũ, tạo chiều sâu gắn kết.
*   **Lật thẻ 2D phẳng:** Moments card hiển thị lưới Muji đồng đều, chạm vào khẽ trượt ngang 2D mượt mà dưới 0.15s để xem mặt sau chứa nhật ký cảm xúc của Sen.

### 5. Phân hệ DOCA Corner (Góc Cảm Xúc)
*   **Không gian trưng bày Muji:** Khay triển lãm phẳng tối giản trưng bày các đĩa nhạc cũ (phát thử tối đa 15-30s bản preview) và sách cũ (chỉ hiển thị đoạn trích và bài đánh giá cảm xúc từ Boss AI). **Ứng dụng không có chức năng đọc toàn bộ cuốn sách hay nghe trọn vẹn bài nhạc** trực tiếp trên MVP; thay vào đó sẽ cung cấp nút hành động liên kết ra webview hoặc ứng dụng của các nền tảng chuyên nghiệp ngoài (Shopee, Fahasa, Spotify, Apple Music).
*   **Wishlist "Ước cho Boss" 🎁:** Nút quà tặng giúp đưa vật phẩm vào danh sách mong muốn của thú cưng, tăng điểm thân mật.

### 6. Phân hệ Tiệm Thư Namiya (Mailbox ẩn danh)
*   **Notion-Style Editor:** Trình soạn thảo thư tay mộc mạc với các dòng kẻ đáy nhạt màu (Vintage Lined Input).
*   **Milk Box Inbox (Thùng Sữa):** Nhận thư hồi âm ẩn danh từ mascot và Admin thông qua server định tuyến bảo mật tuyệt đối, băm định danh SHA256.

### 7. Mô hình Tiếp thị Liên kết Ngữ cảnh (Contextual Affiliate Monetization)
*   **Tích hợp tự nhiên:** Gắn hyperlink chấm mảnh vào các từ khóa sách, nhạc. Bottom Sheet chi tiết hiển thị thông quan sản phẩm và nút chuyển tiếp sang Shopee/Fahasa/Spotify kèm Partner ID.
*   **Không quảng cáo, không Gacha, không tiền ảo CatCoins, không hiển thị giá tiền gián tiếp gây áp lực.**

---

## ⚖️ III. ĐỐI CHIẾU VỚI TUYÊN NGÔN VISION & BRAND (ALIGNMENT GAP ANALYSIS)

Dựa trên việc đối chiếu phạm vi tính năng MVP ở trên với [Kim chỉ nam Sứ mệnh (Vision)](file:///Users/macinia/Capcat%20Project/Document/03_VISION_MANIFESTO.md) và [Tuyên ngôn Thương hiệu (Brand)](file:///Users/macinia/Capcat%20Project/Document/04_BRAND_MARKETING_MANIFESTO.md), chúng tôi xác định 7 khoảng trống (GAPs) sau và đề xuất phương án giải quyết:

### GAP 1: Cụm tính năng Tamagotchi (Cột trụ 4 của Vision) bị loại bỏ hoàn toàn khỏi MVP
*   **Mô tả Gap:** [Tuyên ngôn Sứ mệnh](file:///Users/macinia/Capcat%20Project/Document/03_VISION_MANIFESTO.md) quy định tương tác Tamagotchi (Dinh dưỡng, Vận động, Hạnh phúc) và các hành động chăm sóc hàng ngày (Cho ăn, Đi dạo, Chải lông, Chơi đùa) là cột trụ quan trọng để Sen tích lũy trách nhiệm cảm xúc. Tuy nhiên, ở giai đoạn MVP (Phase 1), toàn bộ cụm tính năng tương tác chăm sóc này đã bị loại bỏ hoàn toàn để tinh giản phạm vi sản phẩm và tập trung 100% tài nguyên phát triển cho hai cột trụ Chat và Rương Ký Ức.
*   **Giải pháp Mitigation:**
    *   Trang chủ hoàn toàn không hiển thị khay nút chăm sóc (Cozy Care Tray) hay các cơ chế kéo thả vật phẩm vào thú cưng.
    *   Cơ sở dữ liệu SQLite và Cloud giữ nguyên cấu trúc tinh giản, loại bỏ hoàn toàn các trường dữ liệu liên quan đến chỉ số sinh học hay lịch sử hành động chăm sóc (Care logs).
    *   Đội ngũ phát triển tập trung hoàn toàn vào việc xây dựng hội thoại tri kỷ thông qua Chat, trắc nghiệm Conversational Builder lúc 9h sáng và lưu giữ Moments viết tay hoài niệm. Cụm tính năng chăm sóc Tamagotchi sẽ được đánh giá kỹ lưỡng để đưa vào Phase 2 khi sản phẩm cốt lõi đã chứng minh được mức độ gắn kết cảm xúc.

### GAP 2: Tranh vẽ minh họa ảo hóa (Ghibli) vs. Sự chân thực của Ký ức thú cưng trên Trang Chủ
*   **Mô tả Gap:** Việc sử dụng các phác họa nét vẽ màu nước Ghibli mặc dù mang tính chữa lành cao, nhưng nếu đặt làm nhân vật hiển thị chính ở Trang chủ sẽ gây ra khoảng cách xa lạ đối với chú thú cưng ngoài đời của Sen, làm giảm tính thiêng liêng của ký ức (Memory Vault) và đi ngược lại chỉ thị của Brand Manifesto về việc "Thủ thư lưu giữ ký ức bình dị thực tế".
*   **Giải pháp Mitigation:** Trang chủ của ứng dụng sẽ chỉ tập trung tôn vinh **hình ảnh chụp thực tế và các Moments** của chú thú cưng do chính người dùng đăng tải. Tranh màu nước Ghibli nghệ thuật được đưa về đúng vai trò bổ trợ trải nghiệm UI: xuất hiện trên popup chào mừng, sheet thông báo y tế, các màn hình trống (blank/empty pages) khi Sen chưa tải ảnh thật lên, và làm avatar mặc định. Đồng thời, loại bỏ hoàn toàn mọi hình ảnh hoạt hình dẹt, nhãn dán chibi đầu to mình nhỏ.

### GAP 3: Ràng buộc Bảo mật Riêng tư vs. Kiến trúc Cloud RAG & Đồng bộ Server
*   **Mô tả Gap:** Cả hai tuyên ngôn ban đầu đều đề xuất giữ dữ liệu hoàn toàn trên thiết bị của Sen (Offline-First). Tuy nhiên, việc chạy RAG (Shared Memory Recall) và hội thoại LLM trực tiếp trên thiết bị di động tầm trung gây quá nhiệt, hao pin và không thể thực thi các mô hình ngôn ngữ lớn có Prompt thấu cảm sâu sắc. Đồng thời, nếu không lưu trữ ở server, người dùng sẽ mất toàn bộ ký ức và lịch sử chat khi đổi hoặc mất thiết bị, vi phạm nguyên lý "Thủ thư lưu giữ ký ức vĩnh cửu" của Brand Manifesto.
*   **Giải pháp Mitigation:** Chuyển dịch sang kiến trúc **Đồng bộ Đám mây Bảo mật & Cloud RAG**:
    *   Dữ liệu thô (ảnh, nhật ký, chat logs) được lưu tạm ở SQLite cục bộ để tối ưu tốc độ phản hồi offline, sau đó tự động đồng bộ ngầm thầm lặng lên cơ sở dữ liệu Server được mã hóa chuẩn **AES-256**.
    *   Bảo vệ dữ liệu truyền tải bằng SSL/TLS.
    *   Khi gọi API ngôn ngữ lớn đám mây (Gemini Flash API), toàn bộ thông tin nhạy cảm của người dùng (như ID người dùng, email) được băm ẩn danh, chỉ gửi ngữ cảnh sự kiện ký ức dạng văn bản thuần túy được lọc sạch thông tin nhận dạng cá nhân (PII Redaction).
    *   Cam kết bảo mật dữ liệu tuyệt đối: Dữ liệu đồng bộ chỉ nhằm mục đích phục hồi và cá nhân hóa trải nghiệm của chính chủ tài khoản đó, tuyệt đối không dùng để huấn luyện mô hình chung hoặc bán cho bên thứ ba.

### GAP 4: Safe-Vet Engine vs. Ranh giới chẩn đoán Y tế
*   **Mô tả Gap:** Phân hệ Safe-Vet nhằm xoa dịu nỗi lo âu y tế cho Sen. Tuy nhiên, việc đưa ra lời khuyên y tế/chẩn đoán bệnh lý là **Ranh giới đỏ cực kỳ nguy hiểm** đối với sản phẩm Iyashikei và pháp lý (AI không được phép làm bác sĩ thú y chuyên nghiệp).
*   **Giải pháp Mitigation:** Safe-Vet Engine chỉ đóng vai trò là một **Bộ quét từ khóa triệu chứng nguy hiểm ngầm** (Emergency Keyword Scanner) chạy trên server kết hợp local.
    *   Nếu phát hiện từ khóa nguy hiểm (ví dụ: *co giật, ngộ độc, khó thở*), AI Pet sẽ không chẩn đoán mà chuyển lời nhắn ấm áp gợi ý Sen mở Sổ tay sức khỏe hoặc tự động hiển thị danh sách phòng khám thú y gần nhất dựa trên định vị.
    *   Banner cảnh báo ngoài trang chủ sử dụng màu cam nhạt quả chín (`Cozy Warning - #FFE0B2`), tuyệt đối không dùng màu đỏ khẩn cấp gây hoảng loạn cho chủ nuôi.

### GAP 5: Cozy Openers & Local Push vs. Kiệt sức đô thị (Urban Burnout)
*   **Mô tả Gap:** Brand Manifesto nghiêm cấm việc "gửi thông báo hối thúc hay đe dọa phạt/trừ điểm khi người dùng không tương tác". Tuy nhiên, Cozy Openers có cơ chế tự gửi tin nhắn hỏi thăm lúc 9h sáng hoặc lời thì thầm đêm muộn. Nếu tần suất quá dày, nó sẽ trở thành gánh nặng hành động (Daily Streak) gây phiền nhiễu cho người dùng đang mệt mỏi.
*   **Giải pháp Mitigation:**
    *   Khống chế tần suất Cozy Openers tối đa **1 lần/ngày**. Nếu người dùng không mở ứng dụng trong vòng 48 giờ, hệ thống sẽ tự động chuyển sang chế độ ngủ đông (decay intervals) giãn cách thông báo sang **3-5 ngày** thay vì dồn dập gửi mỗi ngày.
    *   Tuyệt đối không xây dựng hệ thống đếm ngày đăng nhập liên tục (Daily Streak), không phạt trừ điểm thân mật hay khóa tính năng khi Sen không phản hồi.
    *   Nội dung thông báo đẩy luôn ở dạng tĩnh lặng, chia sẻ vô điều kiện và không đòi hỏi phản hồi (ví dụ: *"Trăng đêm nay đẹp quá Sen ơi, trẫm đi ngủ khò đây, Sen cũng ngủ sớm nhé"*).

### GAP 6: Tiếp thị Liên kết (Contextual Affiliate) vs. Áp lực Nuôi Pet Hoàn Hảo
*   **Mô tả Gap:** Thương hiệu cam kết "bình thường hóa việc nuôi dưỡng bình dân", không tạo mặc cảm tự ti hay ép chi tiêu đắt đỏ. Tuy nhiên, việc chèn các liên kết tiếp thị Shopee/Fahasa nếu không được kiểm soát có thể dẫn đến việc gợi ý các sản phẩm thức ăn ngoại nhập xa xỉ hoặc các giáo điều y tế ép mua sắm.
*   **Giải pháp Mitigation:**
    *   MVP giới hạn bộ lọc từ khóa tiếp thị liên kết chỉ áp dụng cho **các sản phẩm chữa lành tinh thần phi vật chất** (sách cũ hoài niệm, đĩa nhạc lofi mộc mạc) và **các vật dụng chăm sóc cơ bản giá rẻ** (cỏ mèo tự trồng, lược chải lông bằng gỗ đơn giản).
    *   Tuyệt đối loại bỏ khỏi hệ thống gợi ý các loại thức ăn, thực phẩm chức năng đắt tiền hoặc các bài viết chê bai khẩu phần ăn bình dân của thú cưng.
    *   Giao diện Bottom Sheet giới thiệu vật phẩm không hiển thị giá tiền so sánh, không gắn tag giật tít khuyến mãi, không dùng trigger khan hiếm (scarcity) hay bảng xếp hạng bán chạy.

### GAP 7: Tiệm Thư Ẩn Danh Namiya vs. Tính Riêng Tư của Thư Tín
*   **Mô tả Gap:** Mặc dù Namiya Mailbox hoạt động ẩn danh giúp Sen trút bỏ bầu tâm sự, việc truyền nhận dữ liệu thư tay lên máy chủ để Admin/Mascot phản hồi có nguy cơ rò rỉ các bí mật cảm xúc thầm kín nhất của người dùng nếu máy chủ bị xâm nhập.
*   **Giải pháp Mitigation:**
    *   Toàn bộ nội dung thư tay gửi đi được mã hóa bất đối xứng (End-to-End Encryption) từ client đến tài khoản Admin tiếp nhận.
    *   Thông tin định danh người gửi được băm ẩn danh bằng thuật toán SHA-256 kết hợp mã muối (Salt) sinh ngẫu nhiên cục bộ. Server hoàn toàn không lưu trữ IP hay User ID thật liên kết trực tiếp với bức thư ở dạng văn bản rõ (cleartext).
    *   Sau khi thư phản hồi được gửi và tải xuống thiết bị người nhận thành công, nội dung thư trên máy chủ sẽ được **tự động xóa sạch hoàn toàn trong vòng 24 giờ**, chỉ giữ lại trạng thái logic (đã phản hồi) dạng boolean để giải phóng dữ liệu.

---

## 📊 IV. MA TRẬN ĐỐI CHIẾU NGHIỆM THU MVP (ALIGNMENT MATRIX)

| Phân hệ MVP | So chiếu Vision Manifesto | So chiếu Brand Manifesto | Đánh giá Trạng thái & Giải pháp giảm thiểu |
| :--- | :--- | :--- | :--- |
| **Google SSO & Profile** | Đạt (Onboarding 3 bước) | Đạt (Xưng hô theo 4 cá tính) | **✅ ALIGNED** |
| **Soul Mirror Scan** | Đạt (Khớp màu lông 0đ) | Đạt (Tranh màu nước Ghibli) | **✅ ALIGNED** |
| **Trang Chủ Bình Yên** | Đạt (Khung ảnh kỷ niệm thực tế) | Đạt (Muji Grid, Kem ấm `#FBFBFA`) | **✅ ALIGNED** (Đồng bộ thời tiết, Cozy Dark Mode 22h) |
| **Cozy Chat AI** | Đạt (Prompt thấu cảm 2 chiều) | Đạt (Thì thầm đêm muộn Space Mono)| **✅ ALIGNED** (LLM Cloud qua API ẩn danh băm định danh) |
| **Shared Memory Vault** | Đạt (RAG Timeline) | Đạt (Lưu trữ an toàn, lật thẻ 2D) | **✅ ALIGNED** (Đồng bộ đám mây mã hóa AES-256 bảo toàn dữ liệu khi đổi máy) |
| **DOCA Corner** | Đạt (Chỉ nghe preview 30s, đọc đoạn trích/bài đánh giá sách cũ) | Đạt (Không giá tiền, không giỏ hàng) | **✅ ALIGNED** (Liên kết ngoài ra webview/app chuyên dụng) |
| **Tiệm Namiya** | Đạt (Gỡ rối ẩn danh, sớ thư 2D)| Đạt (Không có thông báo hối thúc) | **✅ ALIGNED** (Mã hóa đầu cuối thư tín, xoá sạch dữ liệu server sau 24h) |
| **Affiliate Monetization**| Đạt (Doanh thu thụ động tự nhiên)| Đạt (Giữ vững tối giản MUJI) | **✅ ALIGNED** (Chỉ gợi ý sách/nhạc/đồ cơ bản, loại bỏ sản phẩm xa xỉ) |

---

## 💎 V. GIÁ TRỊ TRAO TẶNG & MÔ HÌNH DOANH THU (USER VALUE & MONETIZATION MODEL)

### 1. Người dùng sẽ nhận được gì? (What the User Receives)
*   **Người bạn tri kỷ 24/7 (PetTwin):** Sự xoa dịu nỗi cô đơn đô thị thông qua một AI Pet có cá tính rõ rệt (1 trong 4 nhân cách), biết trêu đùa dí dỏm, lắng nghe thấu cảm và đặc biệt là **có trí nhớ dài hạn** (nhắc lại các kỷ niệm cũ trong phòng chat).
*   **Sự an tâm bảo toàn kỷ niệm (Memory Integrity):** Một "Chiếc rương ký ức" (DOCA Capsule) lưu giữ trọn vẹn hình ảnh dìm hàng, nhật ký y tế và lịch sử trò chuyện. Nhờ hệ thống **Đồng bộ Đám mây Bảo mật**, mọi kỷ niệm về thú cưng được đóng băng vĩnh cửu và khôi phục nguyên vẹn khi Sen đổi thiết bị.
*   **Không gian trú ẩn tĩnh lặng (Quiet Sanctuary):** Trải nghiệm giao diện phẳng chuẩn MUJI, nghe thử nhạc lofi mộc mạc (preview 30s) và thưởng thức đoạn trích/bài đánh giá sách cũ tại Góc Thư Giãn (không có chức năng nghe nhạc đầy đủ hay đọc sách toàn văn trực tiếp để giữ ứng dụng gọn nhẹ). Ứng dụng cam kết **3 KHÔNG: Không banner quảng cáo ồn ào, không ép buộc làm nhiệm vụ (Streak-free), không gây áp lực tài chính**.
*   **Nơi gửi gắm tâm sự thầm kín (Namiya Mailbox):** Một kênh ẩn danh an toàn để viết thư tay trút bỏ những áp lực cuộc sống và nhận lại những lời hồi âm ấm áp, chậm rãi từ Mascots/Admin được mã hóa bảo mật.

### 2. CAPCAT sẽ thu lợi nhuận từ đâu? (How CAPCAT Generates Profit)
Để tuân thủ tuyệt đối triết lý tối giản MUJI và cam kết *"Không bán gói đăng ký tháng ép buộc (Forced Subscriptions)"*, mô hình doanh thu của CAPCAT được phân lớp rõ ràng giữa Phase 1 MVP và các giai đoạn sau:

*   **Doanh thu trong giai đoạn MVP (Phase 1): Tập trung 100% vào Tiếp thị Liên kết Ngữ cảnh (Contextual Affiliate Referrals)**
    *   **Cơ chế hoạt động:** Tích hợp tự nhiên các link affiliate dạng chấm mảnh dưới từ khóa sách cũ, đĩa nhạc, hoặc vật dụng cơ bản trong chat và Góc Thư Giãn. Khi người dùng nhấp vào link chuyển tiếp sang Shopee/Fahasa (sách, cỏ mèo, lược chải) hoặc Spotify/Apple Music (âm nhạc), CAPCAT nhận phần trăm hoa hồng giới thiệu từ các sàn đối tác. Đây là mô hình doanh thu thụ động, tự nhiên và không gây bất kỳ phiền nhiễu hay cảm giác thương mại hóa nào cho Sen.
*   **Các mô hình doanh thu hoãn lại và xem xét lại trong Phase 2:**
    *   **Thẻ Hành Trình Tri Kỷ (Boarding Pass - Hoãn sang Phase 2 để xem xét lại):** Bản chất đây là mô hình đăng ký dịch vụ định kỳ (Subscription) vốn dễ gây áp lực tài chính và xung đột với tôn chỉ chữa lành tự do. Trong Phase 2, mô hình này sẽ được cân nhắc chuyển đổi sang hình thức ủng hộ một lần (One-time Lifetime Pass / Tip Jar) hoặc chỉ mở khóa các tính năng tuỳ chỉnh giao diện nâng cao, tuyệt đối không khoá tính năng lõi.
    *   **Dịch vụ In Kỷ Niệm Vật Lý (Physical Memorabilia - Hoãn sang Phase 2):** Dịch vụ đặt in trực tiếp các Moments trong rương ký ức thành album ảnh Polaroid giấy mỹ thuật gửi về nhà (hợp tác với xưởng in địa phương) được dời toàn bộ sang Phase 2 để tối giản hạ tầng vận hành trong giai đoạn MVP.

---

*Tài liệu Product Brief này được biên soạn bởi Maya (UX Designer) và PM Sophia, được ký duyệt làm khung tham chiếu kỹ thuật và mỹ thuật tối cao cho toàn bộ đội ngũ phát triển DOCA MVP.*
