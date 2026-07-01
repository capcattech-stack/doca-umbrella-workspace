# 📚 NHẬT KÝ HỘI THOẠI & PHÁT TRIỂN DỰ ÁN CAPCAT (29/05/2026)
*(BIÊN NIÊN SỬ THẢO LUẬN & ĐẶC TẢ CHI TIẾT ĐỘNG CƠ CỘNG HƯỞNG COZY CHAT)*

---

> [!NOTE]
> Tài liệu này lưu trữ toàn bộ lịch sử trao đổi, thảo luận và các quyết định thiết kế kiến trúc dữ liệu, sản phẩm giữa **Sáng lập viên (User)** và đội ngũ **Cố vấn ảo Capcat** (CPO Sophia, Tech Lead Alan, Finance Analyst Leo, Mom Test Expert Arthur).
> Mọi bước tiến từ đặc tả cảm biến thời tiết, thiết lập Google Sheets CMS đến việc chạy giả lập Mom Test và tinh giảm phạm vi MVP được ghi nhận đầy đủ dưới đây.

---

## 🗂️ MỤC LỤC LỰT TRAO ĐỔI (MAY 29, 2026)

- **[Lượt 1]** [Để phục vụ cho đoạn chat thì những thông tin bên ngoài cũng cần ghi nhận...](#-luot-1-chi-tiet-trao-doi)
- **[Lượt 2]** [Đâu là dữ liệu lấy tự động đâu là dữ liệu người vận hành cần chuẩn bị...](#-luot-2-chi-tiet-trao-doi)
- **[Lượt 3]** [Đội ngũ vận hành có thể sử dụng GG Sheet để cập nhật nội dung...](#-luot-3-chi-tiet-trao-doi)
- **[Lượt 4]** [baked_seasonal_trivia (Bản Tin Tĩnh 4 Mùa - Dự phòng Offline) Mục đích để làm gì?](#-luot-4-chi-tiet-trao-doi)
- **[Lượt 5]** [Scenario này cực hấp dẫn và nên được đào sâu hơn, người dùng sẽ nhiều lần cần nó...](#-luot-5-chi-tiet-trao-doi)
- **[Lượt 6]** [Kêu ông Arthur và bài Mom test khắc nghiệt của ông ta vào đánh giá tính năng chat...](#-luot-6-chi-tiet-trao-doi)
- **[Lượt 7]** [Nhờ Nam đánh giá luôn những chức năng khác của tính năng Cozy Chat...](#-luot-7-chi-tiet-trao-doi)
- **[Lượt 8]** [Ông chuyên gia tài chính và kiếm tiền của tôi đâu rồi. Ông đánh giá thế nào?](#-luot-8-chi-tiet-trao-doi)
- **[Lượt 9]** [Các bạn chưa đặc tả cho tôi các bạn định làm gì với tính năng mở bán đĩa than ảo?](#-luot-9-chi-tiet-trao-doi)
- **[Lượt 10]** [Arthur hỏi ông Nam xem ổng muốn mua đĩa than ảo của Sophia không?](#-luot-10-chi-tiet-trao-doi)
- **[Lượt 11]** [Về bản quyền và việc hợp tác phát hành này làm thế nào? Tôi chưa rõ.](#-luot-11-chi-tiet-trao-doi)
- **[Lượt 12]** [Vậy chắc tính năng này nên để sau, hiện chúng ta không có người để liên hệ và kết nối...](#-luot-12-chi-tiet-trao-doi)
- **[Lượt 13]** [Lưu lại nội dung thảo luận vào 1 file MOM mới. Đồng thời lưu lại Chat history...](#-luot-13-chi-tiet-trao-doi)
- **[Lượt 14]** [Tương tự COZY_CHAT giời đội mình bắt đầu phân tích tính năng Hộp ký ức nha.](#-luot-14-chi-tiet-trao-doi)
- **[Lượt 15]** [Dopamine Swipe Interaction: Tôi rất thích nhưng muốn mở rộng. Ngoài vuốt trái và phải có thể vuốt lên...](#-luot-15-chi-tiet-trao-doi)

---

## 💬 CHI TIẾT CÁC LƯỢT TRAO ĐỔI

### 📌 LƯỢT 1: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> ak, để phục vụ cho đoạn chat thì những thông tin bên ngoài cũng cần ghi nhận, ví dụ thời tiết, sự kiện liên quan sở thick, tin tức liên quan sở thích, ... cũng cần được get khi cần để làm mở bài

#### 🤖 **Đặc vụ phản hồi (Sophia & Alan):**
Chúng tôi đã cập nhật và viết lại hoàn toàn tài liệu đặc tả đặc biệt **[SPEC_07_EXTERNAL_AMBIENT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_07_EXTERNAL_AMBIENT_SENSING.md)**:
*   **6 nhóm sở thích:** Music, Literature, Cinema, Cafe, Art, Nature.
*   **Cơ sở dữ liệu tin văn hóa:** Chống tin tức độc hại (Anti-Toxic News), biên soạn thủ công sự kiện văn hóa lãng đãng dưới 80 từ.
*   **Kiến trúc cảm biến:** GPS làm tròn 2 chữ số thập phân gửi lên OpenWeatherMap API để lấy thời tiết, kết hợp sở thích lưu trong Memory Vault làm chất xúc tác mở bài (Cozy Opener).
*   **Bản tin tĩnh 4 mùa:** Fallback offline-first khi thiết bị hoàn toàn ngắt kết nối mạng.

---

### 📌 LƯỢT 2: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Vậy trong các dữ liệu chung ta đã nhắc đến đâu là dữ liệu lấy tự động đâu lf dữ liệu người vận hành cần chuẩn bị và chuẫn bị thế nào ? Kiến trúc dữ liệu ra sao ?

#### 🤖 **Đặc vụ phản hồi (Sophia & Alan & Leo):**
Chúng tôi đã khởi tạo tài liệu đặc tả chuyên sâu mới: **[SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md)** để phân rã cấu trúc:
*   **Dữ liệu Tự động (Automated Data):** GPS làm tròn, OpenWeatherMap API, trạng thái vận động (`flutter_activity_recognition`), nhịp sinh học, ký ức trích xuất ngầm, và iTunes Search API.
*   **Dữ liệu Người vận hành (Curated Data):** Bản tin văn hóa vùng miền (CMS), danh mục sách & affiliate link, danh mục nhạc hoài cổ, và bản tin tĩnh 4 mùa offline.
*   **Kiến trúc CSDL:** SQLite cục bộ (`owner_memory_vault`, `offline_events_cache`, `baked_seasonal_trivia`) kết hợp Cloud Postgres DB.

---

### 📌 LƯỢT 3: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> đội ngũ vận hành có thể sử dụng GG Sheet để cập nhật nội dung và đồng bộ với Databasse vì tôi ko muốn tốn resource portal ở giai đoạn này. Teamplate cũng như enum của từng bản như thế nào ?

#### 🤖 **Đặc vụ phản hồi (Alan & Leo):**
Chúng tôi đã bổ sung chương **Vận hành tinh gọn qua Google Sheets** vào `SPEC_08`:
*   **Các Tab Google Sheets CMS:** 
    1. `curated_events` (Quản lý sự kiện vùng miền).
    2. `affiliate_products` (Quản lý sách/nhạc có gu kèm hoa hồng).
    3. `baked_seasonal_trivia` (Bản tin tĩnh 4 mùa cục bộ).
*   **Enums nghiêm ngặt:** `HobbyCategory`, `City`, `AffiliatePlatform`, `Season`, `TimeOfDay`.
*   **Giải pháp đồng bộ 0đ:** GitHub Actions Cron Job tải CSV mỗi 6 tiếng để parse, validate và UPSERT vào DB hoặc Google Apps Script Webhook đẩy trực tiếp thời gian thực.

---

### 📌 LƯỢT 4: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> baked_seasonal_trivia (Bản Tin Tĩnh 4 Mùa - Dự phòng Offline) Mục đích của bảng này để làm gì

#### 🤖 **Đặc vụ phản hồi (Sophia & Arthur):**
Giải thích mục đích cốt lõi của bảng dữ liệu nạp cứng này dưới 3 khía cạnh:
1.  **Duy trì trải nghiệm chữa lành mọi lúc mọi nơi:** Khi người dùng tắt mạng ngủ hoặc đi máy bay, Pet vẫn "sống", biết mùa và giờ để trò chuyện, duy trì tuyệt đối tính tri kỷ Iyashikei.
2.  **Kỹ thuật Graceful Degradation:** Tải lời chào trong 0.01 giây từ SQLite offline trước khi gọi API thời tiết, tránh spinning wheel vô hồn.
3.  **Phục vụ trạng thái "Ngắt kết nối chủ động":** Hỗ trợ nhu cầu tắt mạng để trú ẩn ban đêm của người trẻ cô đơn đô thị.

---

### 📌 LƯỢT 5: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Senario này cực hấp dẫn và nên được đào xâu hơn, có thể người dùng sẽ nhiêu lần cần nó. và họ sẽ ko thích sự nhàm chán, Các chuyên gia của tôi ơi

#### 🤖 **Đặc vụ phản hồi (Sophia & Arthur & Bella & Alan):**
Tạo lập đặc tả đột phá mới: **[SPEC_09_OFFLINE_SANCTUARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_09_OFFLINE_SANCTUARY_ENGINE.md)**:
*   **Thuật toán trộn câu thoại cục bộ (Deterministic Offline Mixer):** Trộn 4 nhóm mảnh ghép cảm xúc (Hành động pet, Contemplate mùa, Thì thầm giờ, Gia vị ký ức) bằng Seed toán học dựa trên `DayOfYear * 100 + Hour`. Tạo ra hàng ngàn câu thoại ngẫu nhiên nhất quán theo ngày không trùng lặp hoàn toàn offline.
*   **Visual & Audio trầm mặc:** Animation lá phong rơi, tuyết mịn bay chậm bằng CustomPainter 30 FPS tiết kiệm pin. Tích hợp đĩa than xoay phát nhạc loop Mono 64kbps pre-bundled trong máy.

---

### 📌 LƯỢT 6: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Kêu ông Athus và bài Mom test khắc nghiệt của ông ta vào đánh giá tính tăng chat của chúng ta đi

#### 🤖 **Đặc vụ phản hồi (Arthur):**
Arthur mang **Nam (24 tuổi, Dev cô đơn ở Hà Nội, nuôi mèo Bánh Mỳ chảnh chọe)** chạy Mom Test giả thuyết Cozy Chat:
*   **Phản hồi của Nam:** Nam cực kỳ thích việc không bị làm phiền trong giờ làm việc (chỉ nhận tối đa 1 push/ngày sau khi tan sở 15-45 phút). Rất thích rung Purring lúc ôm điện thoại ban đêm.
*   **Kết quả:** Đạt điểm tuyệt đối về khớp nỗi đau (Pain Alignment) và Status Quo Disruption.

---

### 📌 LƯỢT 7: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Nhờ Nam đánh giá lưn những chức năng khác của tính năng COZY_CHAT_RESONANCE_ENGINE nhé

#### 🤖 **Đặc vụ phản hồi (Arthur):**
Nam chạy Mom Test toàn bộ các spec con còn lại:
*   **SPEC_01 (Affiliate Link):** Chấp nhận nhấp vào link màu ấm chấm dotted của Bánh Mỳ để xem đĩa nhạc hay cuốn sách Nhã Nam vì nó mang tính tri kỷ gợi ý, cấm chèn banner nhấp nháy.
*   **SPEC_02 & 04 (Zero-UI Location):** Đồng ý cho phép định vị vì dữ liệu chỉ xử lý local trên máy, cách xin quyền chỉ khi bấm nút Xem Bản Đồ rất tử tế.
*   **SPEC_03 (Memory Vault):** Cảm động vì Bánh Mỳ nhớ thói quen của mình, thích việc có nút [Xóa ký ức] để làm chủ dữ liệu.

---

### 📌 LƯỢT 8: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> ông chuyên gia tài chính và kiếm tiền của tôi đâu rồi. ông đánh giá tính năng Cozy chat của tôi thế nào

#### 🤖 **Đặc vụ phản hồi (Leo):**
Leo phân tích tài chính P&L và đánh giá đây là "Cỗ máy in tiền thầm lặng" nhờ:
*   **Shopee Partner Affiliate (Sách):** CTR dự phóng đạt **8.0% - 12.0%** (banner thường chỉ 1%).
*   **Transit Affiliate (Grab/XanhSM):** Hoa hồng từ nút [Đặt xe đưa Sen đi] tạo dòng tiền đều đặn.
*   **Virtual Vinyl Store (IAP):** Biên lợi nhuận ròng trên **70%** bán đĩa than ảo.
*   **RICE Score:** Đạt **1.53** tuyệt vời nhờ chi phí hạ tầng 0đ ban đầu (Sheets CMS, No-RAG).

---

### 📌 LƯỢT 9: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Sophia và Alan ak, các bạn chưa đặc tả cho tôi các bạn định làm gì với tính năng mở bán đĩa than ảo

#### 🤖 **Đặc vụ phản hồi (Sophia & Bella & Alan):**
Khởi tạo đặc tả **[SPEC_10_VIRTUAL_VINYL_STORE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_10_VIRTUAL_VINYL_STORE.md)**:
*   **Nghi thức khui đĩa:** Vuốt xé màng co nylon bóng bẩy (hiệu ứng haptic), rút đĩa giấy tay lấp lánh rãnh đồng tâm.
*   **Bàn xoay cơ học:** Kéo thả cần kim (Tonearm) đặt lên mâm xoay, phát tiếng nổ đĩa lép bép cổ điển trước khi chạy nhạc.
*   **Mã hóa AES-128:** Mã hóa file nhạc tải về cục bộ, giải mã RAM Stream trực tiếp ngầm tránh lậu nhạc. Tích hợp thanh toán RevenueCat IAP.

---

### 📌 LƯỢT 10: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Athus hỏi ông nam xem ổng muốn mua đỉa than ảo của Sophia ko ?

#### 🤖 **Đặc vụ phản hồi (Arthur & Nam):**
Arthur gặng hỏi hành vi chi tiền thực tế của Nam trong 30 ngày qua:
*   **Nam trả lời:** Nam đang trả **59k/tháng** Spotify Premium, tháng trước vừa bỏ **100k** mua album của Thịnh Suy trực tiếp trên Bandcamp. Do đó, việc bỏ **22k ($0.99)** mua đĩa than ảo trên Capcat có chia sẻ 50% doanh thu cho nghệ sĩ là hành động tự nguyện cực kỳ sẵn lòng, khớp hoàn toàn thói quen chi tiêu thực tế.

---

### 📌 LƯỢT 11: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> về bản quyền và việc hợp tác phát hành này làm thế nào ? tôi chưa rõ

#### 🤖 **Đặc vụ phản hồi (Sophia & Leo):**
Giải thích mô hình xử lý bản quyền âm nhạc tinh gọn:
*   **Nhạc cổ điển (Public Domain):** Mua đứt trọn đời bản ghi âm (Royalty-free) giá $10 - $20 trên các sound libraries hoặc thuê sinh viên Nhạc viện thu âm trọn gói 500k.
*   **Nhạc đối tác Indie:** Ký hợp đồng điện tử phi độc quyền cấp phép bản loop 1-2 phút mượt mà. Chia sẻ doanh thu thực nhận 50/50 sau khi trừ 30% phí store. Không trả trước phí bản quyền (Zero-Upfront License).

---

### 📌 LƯỢT 12: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> vậy chắc tính năng này nên để sau, hiện chúng ta ko có người đẻ liên hệ và kết nối

#### 🤖 **Đặc vụ phản hồi (Sophia & Leo & Alan):**
Đồng ý tuyệt đối với quyết định cắt giảm phạm vi MVP khôn ngoan của Sáng lập viên:
*   Chuyển trạng thái `SPEC_10` thành **[HOÃN - TRIỂN KHAI PHASE 2 / BACKLOG]** trong toàn bộ hệ thống file để DEV tập trung 100% cốt lõi.
*   **Offline Sanctuary (`SPEC_09`)** vẫn giữ nguyên máy quay đĩa than lép bép hoài cổ nhưng chạy hoàn toàn trên nhạc cổ điển Public Domain miễn phí, giúp triệt tiêu 100% chi phí vận hành và rủi ro pháp lý buổi đầu.

---

### 📌 LƯỢT 13: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Lưu lại nội dung thảo luận vào 1 file MOM mới. Đồng thời lưu lại Chat history . Bên cạnh đó viết README cho MOM và Chat history hướng dẫn cách dùng và cách lưu nhất quán

#### 🤖 **Đặc vụ phản hồi (Sophia):**
Tôi đã hoàn tất việc lưu trữ Biên bản họp `2026-05-29_MOM_Cozy_Chat_Resonance_Engine.md` và hai file hướng dẫn vận hành nhất quán:
*   [Document/MOM/README.md](file:///Users/macinia/Capcat%20Project/Document/MOM/README.md)
*   [Document/Chat history/README.md](file:///Users/macinia/Capcat%20Project/Document/Chat%20history/README.md)
Đồng thời, tất cả các lượt thảo luận chất lượng cao ngày hôm nay đang được phân rã tỉ mỉ và lưu trữ thành từng tệp tin riêng biệt dưới thư mục `/Document/Chat history/CHAT_HISTORY_29052026/` để đảm bảo quy trình Git gọn nhẹ và chuyên nghiệp tuyệt đối.

---

### 📌 LƯỢT 14: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Tương tự COZY_CHAT giời đội mình bắt đầu phân tích tính năng Hộp ký ức nha.

#### 🤖 **Đặc vụ phản hồi (Sophia & Alan & Arthur & Leo & Bella):**
Đồng sáng lập viên đã phê duyệt Kế hoạch thiết kế Epic 3: Hộp Ký Ức & Tinder Swipe Game. Đội ngũ cố vấn ảo đã lập tức triển khai xuất sắc toàn bộ 7 tệp tin đặc tả (1 tệp Master PRD + 6 tệp đặc tả chi tiết con) nằm tại thư mục `Document/PRD/MEMORY_VAULT_ENGINE/`:
*   **PRD_MASTER_VAULT.md:** Tuyên ngôn sản phẩm, kiến trúc tổng quan và Success Metrics của phân hệ Hộp Ký Ức.
*   **SPEC_01_SWIPE_STACK_ENGINE.md:** Vật lý vuốt kéo thẻ bài 3D nghiêng góc 15 độ, spring animation, và haptic vibration.
*   **SPEC_02_OFFLINE_ML_FILTERS.md:** Bộ lọc ảnh cục bộ bằng Google ML Kit Object Detection offline 100%, xin quyền Limited Access có ngữ cảnh và nút làm mới Camera tại Settings.
*   **SPEC_03_MEME_CARD_COMPOSITING.md:** Canvas ghép mặt Pet vào 15 khung hình meme chibi vẽ tay cục bộ 0đ, kết xuất PNG 3x có kèm watermark Capcat lan tỏa tự nhiên.
*   **SPEC_04_FEED_MOMENTS_INTEGRATION.md:** Hàng đợi tải ảnh nền ngầm FIFO, tự động tạo Moments và quy tắc tự động ẩn/hiện Banner Buffet to ở trang Home sau khi chơi xong bằng Riverpod.
*   **SPEC_05_MEMORY_VAULT_GALLERY.md:** Giao diện Hộp Ký Ức Polaroid viết tay mộc mạc, hiệu ứng lật thẻ 3D lãng mạn và Quyền tối cao của Sen (Sửa/Xóa vĩnh viễn ký ức).
*   **SPEC_06_LEAN_GACHA_MONETIZATION.md:** Mô hình gacha tinh gọn qua Rewarded Video Ads và Cửa hàng Pate Coins, cùng mẫu nhập liệu Google Sheets CMS Tab 5: `virtual_memes`.

Đã cập nhật tệp kiểm soát chất lượng `walkthrough.md` trong thư mục não bộ để đồng bộ hóa hoàn toàn cụm tính năng Epic 3 chuẩn Dev-Ready.

---

### 📌 LƯỢT 15: CHI TIẾT TRAO ĐỔI
#### 🙋‍♂️ **Người dùng hỏi:**
> Dopamine Swipe Interaction: Tôi rát thích nhưng muốn mở rộng. Ngoài vuốt trái và phải có thể vuốt lên đẻ thực hiện 1 action đặt biệt. Tim, bình luận, ghi dấu kỷ niệm. -> mowr rộng thêm.
> Zero-Intrusion Local ML Filter: Thư viện này có ảnh hưởng performent ko ? nếu có suy nghỉ thêm cơ chế giảm tải VD: Chạy ngẩu nhiên mối tháng 1 hình từ hiện tại đến quá khứ 2 năm, để tiềm ra đủ 10-15 tấm hình đúng điều kiện thì ngưng. ko check tiếp để tiết kiệm. lưu ý cache sao cho nó ko bị lập , ngày nào cũng tháy hoài 1 vài hình chán lắm.
> Local Meme Compositing (0đ): mục tiêu là kỹ niệm vậy việc gắn meme nên là 1 option mở rông hoặc tính năng độc lập ko ? Hợp ý ức toàn meme thì có đúng ko ? Mom test giúp tôi xem người dùng muốn gì.
> Sự Minh Bạch Dữ Liệu Tối Cao: Đặt tả cái inter face ở đây, làm sao để nó Nhật bản , nó chữa lành, nó IYASHIKEI nhất.
> Doanh thu tinh gọn (Free-to-Play): Ký ức là nguyên liệu quý giá và là lý do giữ chân User có nên ràng buộc họ lại để kiếm tiền ko ? Còn có thể kiếm tiền ở đâu cách nào ?

#### 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chúng tôi đã phân tích thấu đáo và cập nhật trực tiếp vào 5 tệp tin đặc tả phân hệ Hộp Ký Ức (`SPEC_01` -> `SPEC_06`):
1.  **Vuốt Lên - Nghi Thức Kỷ Niệm Vàng (`SPEC_01`):** Thiết kế nghi thức 4 bước: Khựng lại giữa màn hình -> Bùng nổ pháo hoa vàng & Thả tim vàng -> Bảng bình luận giấy thô viết tay có 3 câu chọc ghẹo chữa lành của AI -> Đóng một chiếc **Dấu chân mèo sáp đỏ (Red Cat-Paw Wax Seal)** chắc nịch kèm âm thanh dập dấu cơ học chân thật (`stamp_press.mp3`) và Intimacy +15.
2.  **Quét Lùi Thưa Thớt Ngẫu Nhiên Siêu Tiết Kiệm (`SPEC_02`):** ML Kit có ảnh hưởng hiệu năng nếu quét toàn bộ. Ta nâng cấp bộ quét chia dòng thời gian 2 năm thành 24 giỏ tháng, mỗi tháng chỉ bốc ngẫu nhiên 1-2 ảnh chạy nhận diện. Dừng quét lập tức khi đủ 10-15 ảnh Pet. Tích hợp bảng SQLite cache blacklist loại trừ vĩnh viễn ảnh đã hiển thị khỏi các lượt quét tuần sau, đảm bảo Sen không bao giờ bị lặp ảnh cũ.
3.  **Mom Test & Định Vị Ghép Meme Chibi (`SPEC_03`):** Arthur khảo sát Mom Test và kết luận hộp ký ức toàn meme là sai lầm, phá hủy tính thiêng liêng hoài niệm. Quyết định: Ký ức trong Hộp Ký Ức bắt buộc giữ nguyên bản 100% (Pure Postcard). Chế meme là **Tác vụ Mở rộng Chủ động tự nguyện** ẩn ở mặt sau Polaroid, ảnh meme xuất ra được lưu riêng để đi khoe Story bên ngoài chứ không làm ô nhiễm hộp ký ức.
4.  **Cảm Quan Iyashikei & Drawer Minh Bạch Dữ Liệu Tối Cao (`SPEC_05`):** Palette beige nhám tự nhiên, tích hợp **cảm biến Gyroscope** giúp hạt bụi nắng bay xiên nhẹ theo góc nghiêng điện thoại. Tích hợp ngăn kéo sớ giấy da giải trình minh bạch dữ liệu, đi kèm bộ đôi nút quyền lực: **[Tải Sao Lưu .zip]** (tải album offline xem trên PC) và **[Quên Đi Vĩnh Viễn]** dọn sạch dữ liệu cục bộ lẫn máy chủ tôn trọng quyền tối cao của Sen.
5.  **Mô Hình Doanh Thu Premium Coexistence (`SPEC_06`):** Leo kịch liệt phản đối tống tiền cảm xúc. Hộp ký ức cốt lõi là free trọn đời. Ta kiếm tiền siêu lợi nhuận bằng: **Dịch vụ in ảnh Polaroid thật giao tận nhà (Instax Delivery)** giá 19k - 29k/ảnh (biên lợi nhuận ròng 50-60%), bán **Visual Skin Packs** băng keo Washi/Nhạc nền Lofi trang trí (9k-15k), và Rewarded Video Ads để mở rộng lượt quét tự nguyện.


