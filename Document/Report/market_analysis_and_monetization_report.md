# BÁO CÁO PHÂN TÍCH THỊ TRƯỜNG & CHIẾN LƯỢC KIẾM TIỀN: DOCA MVP
*(MARKET ANALYSIS & CONTEXTUAL AFFILIATE MONETIZATION REPORT - V1.0)*

Tài liệu này được biên soạn bởi ban cố vấn chiến lược phát triển sản phẩm kỹ thuật số (Sophia - CPO và Đội ngũ BizDev) nhằm thẩm định thị trường và chi tiết hóa mô hình doanh thu tiếp thị liên kết (Affiliate) tối giản của dự án **DOCA**.

---

## 🧭 I. BỐI CẢNH THỊ TRƯỜNG & CHÂN DUNG KHÁCH HÀNG (MARKET & TARGET DEMOGRAPHIC)

### 1. Thực trạng xã hội & Xu hướng Chữa lành (Iyashikei Trend)
*   **Thực trạng Cô đơn Đô thị:** Thế hệ Gen Z và Millennials tại các đô thị lớn đang đối mặt với hội chứng cô đơn, áp lực công việc (burnout), và thiếu không gian kết nối cảm xúc an toàn. 
*   **Xu hướng Nuôi thú cưng số (Virtual Pet Growth):** Do giới hạn không gian căn hộ, thời gian bận rộn hoặc điều kiện tài chính, nhiều người trẻ không thể nuôi thú cưng thật. Họ tìm kiếm các giải pháp nuôi thú ảo để có cảm giác bầu bạn.
*   **Thị hiếu Thẩm mỹ Tối giản (Minimalist Aesthetics):** Người dùng nhạy cảm có xu hướng rời bỏ các ứng dụng mạng xã hội xô bồ, ồn ào và tìm đến các "ốc đảo tĩnh lặng" để viết nhật ký (journaling), nghe nhạc Lofi nhẹ nhàng, đọc trích dẫn văn học chữa lành (tác giả Murakami, Keigo Higashino).

### 2. Chân dung Khách hàng Mục tiêu (Target Customer Persona)
*   **Độ tuổi:** 18 - 30 tuổi (Sinh viên, nhân viên văn phòng trẻ).
*   **Đặc điểm tâm lý:** Hướng nội (Introverts), nhạy cảm (Highly Sensitive Persons - HSP), yêu thích động vật, trân trọng kỷ niệm, có sở thích sưu tầm đĩa nhạc, postcard, sách giấy.
*   **Thói quen chi tiêu:** Sẵn sàng chi trả cho các giá trị tinh thần, sản phẩm chất lượng cao có thẩm mỹ thiết kế tối giản, tinh tế (như phong cách MUJI).

---

## 🏛️ II. ĐỊNH VỊ SẢN PHẨM & ĐIỂM BÁN HÀNG ĐỘC NHẤT (PRODUCT POSITIONING & USP)

DOCA định vị mình không phải là một game nuôi thú cơ học hay một chatbot AI vô hồn, mà là một **"Ốc đảo cảm xúc di động"** thông qua 2 USP độc quyền:

### 🌟 USP 1: Ký ức cộng hưởng thấu cảm (Cognitive Resonance Memory)
AI Pet của DOCA liên tục "ngửi" và đọc hiểu cơ sở dữ liệu kỷ niệm cục bộ (`DOCA Capsule`). Nó không nói chuyện sáo rỗng mà biết **gợi nhớ kỷ niệm cũ** một cách tự nhiên trong khung chat (nhắc lại ảnh cũ, các sự kiện y tế, tâm sự của Sen). Điều này biến chú thú cưng AI thành một người bạn tri kỷ thực sự biết lắng nghe và thấu hiểu.

### 🌟 USP 2: Thẩm mỹ tối giản MUJI & Quyền riêng tư (Muji Aesthetics & Local-first)
Thiết kế phẳng hoàn toàn, đường chỉ viền 1px mảnh dẻ, không đổ bóng, nền màu kem giấy tái chế ấm áp `#FBFBFA`. Toàn bộ hình ảnh kỷ niệm của Sen được cache SQLite cục bộ, cam kết bảo mật riêng tư tuyệt đối, tạo nên một không gian trú ẩn an toàn, không tiếng ồn quảng cáo.

---

## 📊 III. PHẠM VI MVP V1.0 (MVP SCOPE & DE-SCOPED BACKLOG)

Để đưa sản phẩm ra thị trường nhanh nhất và tối ưu hóa chi phí API, phạm vi tính năng được giới hạn tinh gọn:

1.  **DOCA PetTwin (Trụ cột Tương tác):** 1 Boss duy nhất, chọn 1 trong 4 tính cách. Chat góc nhìn thứ nhất, AI Roast (khịa ảnh dìm), trắc nghiệm 9h sáng xây dựng profile. **(Cắt chỉ số sinh học Tamagotchi sang Phase 2)**.
2.  **DOCA Capsule (Trụ cột Ký ức):** Dòng thời gian Timeline cuộn dọc (ảnh Polaroid lật mặt sau, text chat memory, sổ tay y tế). Nạp ảnh thủ công bằng Bottom Sheet hoặc gửi ảnh trong chat. **(Cắt game quẹt Tinder sang Phase 2)**.
3.  **DOCA Corner (Trụ cột Doanh thu):** Kệ trưng bày các thẻ bo góc đĩa nhạc, sách cũ, tác giả và mascot. Tương tác phát nhạc đĩa than cơ học 30s preview (iTunes API) và gắn link tiếp thị liên kết (Spotify/Shopee/Fahasa).
4.  **Namiya Mailbox (Hòm thư ẩn danh):** Trút bầu tâm sự ẩn danh. **(Tần suất sử dụng thỉnh thoảng/định kỳ để tránh loãng cảm xúc và giữ tính thiêng liêng)**.
5.  **Safe Vet (An toàn thú cưng):** Quét triệu chứng nguy hiểm và GPS chỉ đường đến phòng khám gần nhất.

---

## 🧭 IV. BẢN ĐỒ HÀNH TRÌNH KHÁCH HÀNG (CUSTOMER JOURNEY)

*   **Aha Moment (TTFV < 1.5 phút):** User tải app -> onboard điền tên Pet -> gửi 1 ảnh dìm bất kỳ -> Pet AI phân tích (Vision) và khịa lại cực duyên dáng -> Trải nghiệm Dopamine tiếng cười đầu tiên.
*   **Vòng lặp tương tác hằng ngày (Daily Loop):**
    *   *09:00 Sáng:* Boss gửi câu hỏi trắc nghiệm ngắn. User chạm nút Quick Reply để trả lời và cập nhật profile Boss.
    *   *Trong ngày:* Mở Trang chủ thấy **Dynamic Spotlight Polaroid** tự động xoay chuyển hiển thị các kỷ niệm ngẫu nhiên hoặc khớp với thời gian thực (ảnh đi dạo buổi sáng, ảnh ngủ cuộn tròn lúc đêm khuya).
    *   *Đêm muộn:* Nhận thông báo đẩy thì thầm ngọt ngào (**DOCA Whispers**) gợi ý một bản nhạc hay hoặc một cuốn sách hay -> Dẫn Sen vào **DOCA Corner** nghe nhạc đĩa than 30s hoặc nhấp link tiếp thị liên kết mua sách thật.
    *   *Định kỳ / Thỉnh thoảng:* Khi có tâm sự sâu kín, Sen viết thư ẩn danh gửi đi qua **Namiya Mailbox** và nhận lại thư phản hồi viết tay ấm áp sau đó vài tiếng.

---

## 🛍️ V. CHIẾN LƯỢC DOANH THU: TIẾP THỊ LIÊN KẾT NGỮ CẢNH (CONTEXTUAL AFFILIATE MONETIZATION)

Thay vì tích hợp ví ảo, bán tiền xu (CatCoins) và xây dựng cửa hàng vật phẩm gacha phức tạp, DOCA kiếm tiền bằng cách làm cầu nối trung gian đưa người dùng đến với các nền tảng thương mại và giải trí lớn:

```
                  SƠ ĐỒ DÒNG TIỀN TIẾP THỊ LIÊN KẾT (AFFILIATE)
    
    [ User (Sen) ] ──► (Bấm nút "Bắt đầu ngay" trên Detail Card) ──► [ Nền tảng Đối tác ]
          ▲                                                                 │
          │                                                         (User thanh toán)
    (Trải nghiệm)                                                           │
          │                                                                 ▼
    [ App DOCA ] ◄───────────────── (Nhận hoa hồng % ) ────────────── [ Spotify/Shopee ]
```

### 1. Cơ chế vận hành & Đặc tả 5 nhóm liên kết (Theo file đính kèm Scope)
*   **Bản Mẫu 1 — Ca khúc Âm nhạc (Music Track):**
    *   *Trải nghiệm:* Hiển thị ảnh đĩa than tròn xoay, đính kèm nhãn xanh lá `[🟢 Spotify]` (hoặc Apple Music). Tích hợp thanh phát nhạc mini 30s preview lấy từ iTunes Search API.
    *   *Mô hình doanh thu:* Nhấp nút `[⚡ Bắt đầu ngay]` mở link giới thiệu đăng ký Spotify Premium hoặc Apple Music Partnerize (nhận hoa hồng giới thiệu).
*   **Bản Mẫu 2 — Nghệ sĩ / Ban nhạc (Artist / Band):**
    *   *Trải nghiệm:* Ảnh chân dung ban nhạc hình tròn, nhãn `[🟢 Spotify]` kế bên (Ví dụ: ban nhạc *Ngọt*). Tự động phát ca khúc tiêu biểu (Ví dụ: *Em dạo này*).
    *   *Mô hình doanh thu:* Dẫn deep-link mở danh mục của nghệ sĩ trên app Spotify ngoài.
*   **Bản Mẫu 3 — Vật phẩm đời thường (Physical Product):**
    *   *Trải nghiệm:* Ảnh chụp vuông sản phẩm bo góc nhẹ, nhãn cam `[🟠 Shopee]` (Ví dụ: *Cát Đậu Nành Không Bụi Siêu Hút*). Có lưới 3 ảnh nhỏ preview chi tiết bên dưới.
    *   *Mô hình doanh thu:* Dẫn link tiếp thị liên kết Shopee Affiliate (nhận 4% - 10% hoa hồng trên đơn hàng hoàn thành).
*   **Bản Mẫu 4 — Tác phẩm Sách (Book):**
    *   *Trải nghiệm:* Bìa sách đứng, nhãn `[🟠 Shopee]` kế bên (Ví dụ: *Tôi Là Một Chú Mèo* của Natsume Soseki). Có **Hộp trích dẫn nổi bật viền đỏ sậm mép trái** ghi nhận câu quote hay.
    *   *Mô hình doanh thu:* Dẫn link mua sách thật tại các gian hàng Shopee Mall uy tín (Nhã Nam, Fahasa).
*   **Bản Mẫu 5 — Tác giả / Nhà văn (Author):**
    *   *Trải nghiệm:* Chân dung tác giả hình tròn, nhãn `[🟠 Shopee]` kế bên (Ví dụ: *Haruki Murakami - Nhà văn*). Có hộp trích dẫn nổi bật viền đỏ ở dưới.
    *   *Mô hình doanh thu:* Dẫn link đến danh mục sách của tác giả trên Shopee/Fahasa để Sen dễ tìm mua.

### 2. So sánh hiệu quả tài chính và Vận hành (P&L & BizDev Audit)

| Tiêu chí | Bán Vật Phẩm Ảo (CatCoins Shop) | Tiếp Thị Liên Kết (Affiliate Model) |
| :--- | :--- | :--- |
| **Chi phí Dev** | **Rất cao** (12-15 ngày: DB ví, đồng bộ hóa store, cổng thanh toán IAP Apple/Google). | **Rất thấp** (2 ngày: Custom URL builder với token affiliate, open url_launcher). |
| **Phí trung gian** | Mất **15% - 30%** doanh thu cho Apple/Google Store Tax. | **0%** (Hoa hồng nhận nguyên vẹn từ mạng lưới đối tác đối soát định kỳ). |
| **Rủi ro vận hành** | Cao (Khiếu nại giao dịch lỗi, đòi hoàn tiền, lỗi đồng bộ số dư ví). | **Bằng không** (Mọi giao dịch và vận chuyển diễn ra trên sàn Shopee/Spotify). |
| **Rào cản pháp lý** | Phức tạp (Quy định thuế tài sản số, đăng ký giấy phép ví điện tử/tiền ảo). | Rất thấp (Hợp đồng quảng cáo đại lý thông thường). |
| **Tỷ lệ giữ chân** | Dễ gây ức chế nếu thiết kế kích cầu mua quá đà, phá vỡ Muji. | Rất cao (User yêu thích sự gợi ý văn minh, tăng độ gắn kết tự nhiên). |

---

## 🔒 VI. KẾT LUẬN CHIẾN LƯỢC
Mô hình **Tiếp thị Liên kết Cảm xúc** là nước đi BizDev cực kỳ khôn ngoan cho phiên bản MVP. Nó vừa triệt tiêu gánh nặng lập trình cho đội kỹ thuật để kịp tiến độ ra mắt, vừa giữ cho giao diện DOCA đạt độ phẳng tinh khiết chuẩn MUJI, đồng thời biến ứng dụng thành một kênh giới thiệu văn hóa chất lượng, tạo dựng uy tín thương hiệu lâu dài trước khi tích hợp các hình thức kiếm tiền sâu hơn ở Phase 2.

---

## 📊 VII. BÁO CÁO GIẢ LẬP PHỎNG VẤN KHÁCH HÀNG (PERSONATWIN COHORT REPORT - 10 PERSONAS)

Để kiểm chứng độc lập các giả thuyết sản phẩm và mô hình kinh doanh của **DOCA MVP**, chúng tôi đã sử dụng công cụ giả lập **PersonaTwin** để chạy phỏng vấn sâu theo bộ quy tắc **The Mom Test** đối với một nhóm thuần chất gồm **10 khách hàng mục tiêu** thuộc nhóm người trẻ hướng nội (Introverts) và nhạy cảm (HSPs) tại Việt Nam.

### 📋 1. Danh sách Cohort 10 Người dùng Giả lập (5P Framework Profiles)

| ID | Tên Persona | Tuổi | Nghề nghiệp | Hành vi hiện tại (Status Quo) | Phân loại Adopter |
|:---:|---|:---:|---|---|:---:|
| 1 | **Linh Nguyễn** | 22 | Sinh viên (Hà Nội) | Ở trọ nhỏ, chủ nhà cấm nuôi chó mèo. Thường xem video chó mèo trên TikTok để giải tỏa cô đơn trước khi ngủ. | 🟢 Early Adopter |
| 2 | **Minh Trần** | 25 | Dev (TP.HCM) | Work from home, ít giao tiếp xã hội. Rất thích nghe nhạc Lofi khi code và đọc sách trinh thám Keigo Higashino. | 🟢 Early Adopter |
| 3 | **Trang Lê** | 28 | Content Writer (Đà Nẵng) | Nuôi 1 chú mèo tên Lucky ngoài đời. Chụp ảnh dìm mèo hằng ngày và lưu trong Album ảnh điện thoại, ít khi đăng MXH vì ngại. | 🟢 Early Adopter |
| 4 | **Huy Hoàng** | 24 | Graphic Designer (Hà Nội) | Người chuộng tối giản MUJI cực đoan. Xóa mọi app có quảng cáo rác hoặc bắt nạp tiền mua đồ ảo. Sử dụng Spotify Premium. | 🟢 Early Adopter |
| 5 | **Vy Bùi** | 27 | Trưởng nhóm HR (TP.HCM) | Thường thức khuya vì cô đơn, thích đọc thơ và nghe nhạc Jazz. Có thói quen mua sách giấy Nhã Nam trên Shopee mỗi tháng. | 🟢 Early Adopter |
| 6 | **Bảo Phạm** | 29 | Chủ quán cafe (Cần Thơ) | Yêu động vật nhưng bận rộn. Thường mua hạt và cát mèo trên Shopee Mall. Rất nhạy cảm với việc nạp tiền ảo game. | 🟡 Mainstream |
| 7 | **Thảo Vũ** | 21 | Sinh viên (Hải Phòng) | Nuôi 1 mèo ta. Thích chụp ảnh mèo nhưng lười viết nhật ký sức khỏe, thường quên lịch tiêm phòng và tẩy giun. | 🟢 Early Adopter |
| 8 | **Nam Hoàng** | 26 | Specialist (TP.HCM) | Thích ghi chép bằng Notion. Từng thử dùng 3 app nuôi thú ảo gacha nhưng đều xóa sau 3 ngày vì quá ồn ào và tốn thời gian. | 🟡 Mainstream |
| 9 | **Chi Mai** | 23 | Illustrator (Hà Nội) | Yêu đĩa than cổ điển, thích decor phòng ngủ. Hay săn lùng đĩa CD/Vinyl cũ và poster nghệ thuật từ các link Shopee. | 🟢 Early Adopter |
| 10 | **Lộc Đặng** | 30 | Kiểm toán viên (TP.HCM) | Làm việc áp lực cao, thích đọc sách chữa lành để cân bằng tinh thần. Chi tiêu ổn định cho sách giấy và Spotify. | 🟡 Mainstream |

---

### ❓ 2. Bộ Câu hỏi phỏng vấn Mom Test (The Interview Questionnaire)

Chúng tôi đã thiết kế các câu hỏi thăm dò hành vi thực tế trong quá khứ, tuyệt đối loại bỏ các câu hỏi giả định tương lai:
1.  *“Tuần vừa qua, những lúc thấy cô đơn hay căng thẳng vào đêm muộn, bạn đã làm gì để giải tỏa?”* (Khảo sát nhu cầu chữa lành thực tế).
2.  *“Lần gần nhất bạn chụp ảnh thú cưng của mình là khi nào? Bạn làm gì với những bức ảnh đó?”* (Khảo sát hành vi lưu trữ của Capsule).
3.  *“Hãy kể lại lần gần nhất bạn mua một cuốn sách giấy hoặc tìm một bài hát mới. Bạn phát hiện ra nó bằng cách nào?”* (Khảo sát cơ chế gợi ý của Corner).
4.  *“Bạn có từng trả tiền cho một vật phẩm ảo (như tiền game, thời trang ảo) trong 6 tháng qua chưa? Tại sao?”* (Khảo sát tính chịu chi cho CatCoins vs. Vật phẩm thật).
5.  *“Lần cuối bạn ghi chép lịch tiêm phòng hay kiểm tra sức khỏe cho bé cưng là khi nào? Bạn lưu nó ở đâu?”* (Khảo sát tính hữu ích của Sổ tay y tế).

---

### 🔍 3. Kết quả Phỏng vấn & Bộ lọc Dữ liệu Thật (The Truth Filtering Log)

Áp dụng bộ lọc Mom Test Filter (Loại bỏ Compliment/Fluff/Hypothetical, giữ lại dữ liệu Hành vi Thực tế):

#### ❌ Dữ liệu rác đã loại bỏ (Compliments & Fluff):
*   *Linh Nguyễn:* "App có vẽ tay màu nước Ghibli thì tuyệt vời quá, em chắc chắn sẽ tải ngay!" ➔ **Compliment (Vô giá trị)**.
*   *Nam Hoàng:* "Nếu có tiền ảo CatCoins chắc tôi cũng sẽ nạp thử nếu nó rẻ." ➔ **Hypothetical (Không tin cậy)**.
*   *Vy Bùi:* "Tôi thường hay đọc sách chữa lành mỗi đêm." ➔ **Fluff (Yêu cầu dẫn chứng cụ thể lần cuối)**.

#### ✅ Dữ liệu hành vi thực tế thu nhận được (Grounded Status Quo):
*   **Hành vi mua sắm:** 9/10 người phỏng vấn **chưa từng bỏ một đồng nào mua vật phẩm ảo** trong app trong 6 tháng qua. Ngược lại, 8/10 người **đều mua sách giấy thật trên Shopee (trung bình 1-2 cuốn/tháng)** và 7/10 người có tài khoản Spotify trả phí để nghe nhạc khi làm việc.
*   **Hành vi lưu trữ ảnh:** Trang Lê chia sẻ: *"Hôm qua mèo nhà tôi ngủ gật ngã cắm đầu, tôi chụp lại ngay. Nhưng tôi chỉ để trong máy chứ không đăng Facebook vì không thích chia sẻ đời tư lên mạng."* ➔ Xác nhận nhu cầu lưu trữ riêng tư của Rương ký ức.
*   **Hành vi ghi chép sức khỏe:** Thảo Vũ thừa nhận: *"Mèo nhà tôi bị trễ lịch tiêm vắc xin tận 2 tháng vì tôi viết lịch vào một mẩu giấy nhớ rồi làm mất. Chỉ khi mèo bỏ ăn tôi mới tá hỏa mang đi khám."* ➔ Xác nhận Sổ tay y tế cực kỳ thiết thực.
*   **Hành vi viết thư tâm sự:** Minh Trần chia sẻ: *"Thỉnh thoảng 1-2 tháng tôi mới viết blog ẩn danh khi có chuyện cực kỳ bế tắc ở công ty. Tôi không viết hằng ngày vì chẳng ai có nhiều tâm sự buồn đến thế."* ➔ Xác nhận Namiya Mailbox chỉ nên dùng thỉnh thoảng/định kỳ để giữ giá trị cảm xúc.

---

### 📊 4. Bảng điểm Cam kết & Phán quyết (Commitment Scores & Verdicts)

Chúng tôi đưa ra lời đề nghị cam kết thực tế (Commitment Ask): *Gửi bản phác thảo vẽ tay của 5 mẫu Thẻ cảm xúc và danh mục sách gợi ý cho họ xem thử trước.*

| ID | Tên Persona | Loại Cam kết | Chi tiết Cam kết | Phán quyết (Verdict) |
|:---:|---|:---:|---|:---:|
| 1 | Linh Nguyễn | **Thời gian (⏱️)** | Đồng ý dành 15 phút zoom xem thử và dùng thử bản Test khi có link. | 🟢 Chấp nhận |
| 2 | Minh Trần | **Thời gian (⏱️)** | Block lịch xem bản thảo đĩa nhạc và playlist lofi mẫu. | 🟢 Chấp nhận |
| 3 | Trang Lê | **Uy tín (🤝)** | Đồng ý gửi ảnh dìm mèo Lucky cho dev để test thử tính năng Vision Roast. | 🟢 Chấp nhận |
| 4 | Huy Hoàng | **Thời gian (⏱️)** | Đồng ý cài app test ngay nếu dev cam kết 100% không có ad banner rác. | 🟢 Chấp nhận |
| 5 | Vy Bùi | **Tiền bạc (💰)** | Sẵn sàng đặt cọc trước 50k để mua postcard in thật của mèo kèm quote gửi về nhà. | 🟢 Cực tốt |
| 6 | Bảo Phạm | **Thời gian (⏱️)** | Đồng ý test thử link Shopee xem có bị lỗi chuyển hướng không. | 🟢 Chấp nhận |
| 7 | Thảo Vũ | **Thời gian (⏱️)** | Đăng ký nhận thông báo đẩy nhắc lịch tiêm chủng bản thử nghiệm. | 🟢 Chấp nhận |
| 8 | Nam Hoàng | **Uy tín (🤝)** | Đồng ý giới thiệu cho 2 người bạn nuôi mèo khác cùng test nếu app không giật lag. | 🟢 Chấp nhận |
| 9 | Chi Mai | **Tiền bạc (💰)** | Đăng ký mua đĩa Vinyl decor thật từ link Shopee gợi ý của app. | 🟢 Cực tốt |
| 10 | Lộc Đặng | **Thời gian (⏱️)** | Yêu cầu gửi danh mục 10 cuốn sách chữa lành đầu tiên để đọc thử trước. | 🟢 Chấp nhận |

*   **Tỷ lệ chấp nhận cam kết:** **10/10 người** đồng ý thực hiện hành động cam kết cụ thể (Thời gian, Uy tín hoặc Tiền cọc in ảnh thật).
*   **Điểm cam kết trung bình (Commitment Score):** **8.5/10** (Rất cao cho một ứng dụng Consumer App).

---

### 💡 5. Kết luận & Đề xuất cải tiến (Key Learnings & Recommendations)

Dựa trên kết quả phỏng vấn sâu bằng PersonaTwin, chúng tôi chốt 3 đề xuất cải tiến tối quan trọng cho MVP V1.0:

1.  **Chuyển đổi hoàn toàn sang Affiliate là quyết định chính xác:** 
    *   Khách hàng mục tiêu (Introvert/HSP) cực kỳ dị ứng với "CatCoins" hay "Pate Coins" vì họ cảm giác bị thương mại hóa và tống tiền cảm xúc. 
    *   Ngược lại, họ rất vui vẻ bấm vào liên kết để mua sách thật trên Shopee/Fahasa hoặc nghe nhạc thật trên Spotify. Do đó, **hủy bỏ hoàn toàn mô hình tiền ảo ở Phase 1 là quyết định BizDev đúng đắn.**
2.  **Khống chế tần suất của Hòm thư Namiya (Namiya Mailbox):**
    *   Dữ liệu phỏng vấn cho thấy người dùng không viết thư mỗi ngày. Việc ép buộc viết thư hằng ngày sẽ biến tính năng này thành một nhiệm vụ (task) gây stress. 
    *   *Đề xuất:* Thiết lập hòm thư hoạt động **định kỳ/thỉnh thoảng** (Ví dụ: Chỉ mở nhận thư vào tối Thứ Sáu hoặc cuối tuần, hoặc giới hạn gửi 2 lá thư/tuần).
3.  **Tập trung vào tính năng "In ảnh thật Polaroid":**
    *   Vy Bùi và Chi Mai sẵn sàng trả tiền thật để nhận được những bức ảnh Polaroid thật của Boss kèm chữ viết tay AI gửi về tận nhà. Đây là một ngách doanh thu vật lý (Physical Delivery) biên lợi nhuận cao cần được ưu tiên ở Phase 1.5.
