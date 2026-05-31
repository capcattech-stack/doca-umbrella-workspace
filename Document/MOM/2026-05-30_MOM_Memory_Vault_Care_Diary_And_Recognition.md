# BIÊN BẢN HỌP CHIẾN LƯỢC: HỘP KÝ ỨC, NHẬT KÝ CHĂM SÓC & TRÒ CHƠI SWIPE DOPAMINE
*(STRATEGIC MINUTES OF MEETING - MEMORY VAULT, CARE DIARY, & INDIVIDUAL RECOGNITION)*

---

> **Mã Tài Liệu:** `2026-05-30_MOM_Memory_Vault_Care_Diary_And_Recognition`  
> **Thời gian:** 14:30 - 15:50 ngày 30/05/2026  
> **Địa điểm:** Não bộ & Workspace cục bộ Capcat  
> **Thành viên tham gia:**
> *   **Sáng lập viên (User)** - Phê duyệt chiến lược sản phẩm.
> *   **Sophia (CPO / PM)** - Chủ trì định hướng sản phẩm & UX.
> *   **Maya (UI/UX Designer)** - Chủ trì thiết kế Layout & Cảm quan chữa lành Wabi-Sabi.
> *   **Alan (Tech Lead)** - Chủ trì kiến trúc kỹ thuật & CSDL SQLite, ML Kit, TFLite.
> *   **Arthur (Mom Test Expert)** - Bảo đảm thấu cảm sản phẩm & bảo mật dữ liệu Sen.
> *   **Leo (Finance Analyst)** - Bảo đảm tối ưu hoá P&L & dòng doanh thu nhân văn.
> *   **Bella (Frontend Animator)** - Đảm nhận hoạt ảnh 3D và tương tác Dopamine.
>
> **Tài liệu tham chiếu liên quan:** 
> *   [Document/CHAT_HISTORY_30052026.md](file:///Users/macinia/Capcat%20Project/Document/CHAT_HISTORY_30052026.md) (Nhật ký hội thoại chi tiết của ngày)

---

## I. CÁC QUYẾT ĐỊNH CHIẾN LƯỢC QUAN TRỌNG (STRATEGIC DECISIONS)

Sau khi phân tích thấu đáo các phản biện từ Sáng lập viên và các đề xuất thiết kế từ Designer Maya, đội ngũ Cố vấn ảo thống nhất thông qua 6 quyết định chiến lược cốt lõi:

1.  **5 Kịch bản kích hoạt Buffet Ký ức (Tinder Swiper triggers):**
    *   *Mới Onboarding:* Bốc 10-15 ảnh đầu tiên khởi chạy stack ngay để Sen làm quen game.
    *   *Chiều cuối tuần thảnh thơi:* Nhắc hẹn push giọng Boss vào chiều Thứ 7/Chủ Nhật khi Sen thong thả nhất.
    *   *Mốc Thân Mật (Intimacy Milestone):* Kỷ niệm các mốc Intimacy đặc biệt.
    *   *Kỷ niệm trở về (Golden Reunion):* Chào đón ấm áp khi Sen vắng mặt 7+ ngày.
    *   *Đổi mùa tĩnh lặng (Seasonal Solstice):* Mời xem lại ảnh cùng mùa này của năm ngoái khi thời tiết chuyển lạnh/mưa dông.
2.  **Luồng thêm ký ức thủ công phối trộn đa dạng (Hybrid Memory Entry):**
    *   Sen được cung cấp FAB "Thêm kỷ niệm" ở gallery để log 3 chế độ:
        *   *Chỉ hình ảnh (Photo Only):* Thẻ Polaroid truyền thống hiển thị ảnh và nét bút viết tay.
        *   *Chỉ sự kiện (Event Only):* Event Card đặc trưng, có nền pastel theo nhóm sự kiện, **Icon sự kiện to đậm nổi bật** ở bên trái (🛁, 💉, 🏥), tên sự kiện và ghi chú ở bên phải.
        *   *Phối hợp cả hai (Photo + Event Hybrid):* Thẻ Polaroid Hybrid đặc biệt, có ảnh làm tâm điểm và một **Huy hiệu Sự kiện (Care Event Badge)** xinh xắn đè nhẹ lên góc ảnh Polaroid.
3.  **Thuật toán Sắp xếp đa chiều (Dual Sorting):**
    *   Sen có thể chuyển đổi 1 chạm sắp xếp theo:
        *   **Ngày chụp thực tế (EXIF Photo Taken Date - Mặc định):** Phản ánh đúng chuỗi lớn lên sinh học của Pet.
        *   **Ngày tải lên / Thêm vào (Added Date):** Tìm kiếm cực nhanh những ảnh vừa vuốt/sự kiện vừa log chiều nay.
4.  **Maya tư vấn: Thiết kế Lưới So Le Wabi-Sabi Masonry:**
    *   Từ bỏ lưới ô vuông phẳng công nghiệp khô cứng. Hộp ký ức áp dụng lưới so le dọc 2 cột (Vertical Masonry Grid) với chiều cao thẻ co giãn tự nhiên theo nội dung.
    *   Giao diện mang cảm giác một cuốn **Sổ dán Scrapbook thủ công** ấm áp, Japandi thô mộc (`#F9F6F0` nền beige thô, `#FDFBF7` ngà Polaroid).
    *   Tích hợp vi hoạt ảnh Gyroscope bóng đổ dịch chuyển và bụi nắng bay xiên theo góc nghiêng điện thoại mang lại chiều sâu cảm giác bình yên tối đa.
5.  **Nhận diện cá thể Pet Đa Boss cục bộ 100% (SPEC-08):** 
    *   Quyết định tích hợp model **TFLite MobileNetV3-Small (2.5MB, ~12ms inference)** chạy trực tiếp trên thiết bị để trích vector đặc trưng 1024 chiều. So sánh khớp cá thể bằng thuật toán Cosine Similarity trên SQLite cục bộ.
    *   Bypass hoàn toàn quy trình này đối với người dùng 1 Boss để tránh hao pin vô ích và không làm phiền Sen.
6.  **Nhật ký chăm sóc mộc mạc "Ghi chú của Mẹ" (SPEC-07):**
    *   Xác lập ranh giới y tế: Ghi chép 16 loại sự kiện cuộc sống, không lưu biệt dược/liều lượng để loại bỏ rủi ro pháp lý chuyên môn.
    *   Cozy Chat tích hợp NLP để tự nhận diện ý định (Intent Detection) và hỏi Sen lưu lịch sử cực kỳ thông minh.

---

## II. HỆ THỐNG ĐẶC TẢ CHI TIẾT ĐÃ HOÀN THÀNH (SPECS INDEX)

Phân hệ **Memory Vault Engine** hiện đã hoàn tất 8 tài liệu đặc tả chi tiết và sẵn sàng chuyển giao cho đội ngũ lập trình (Dev-Ready):

| Số | Tên Tài Liệu Đặc Tả | Vai Trò Cốt Lõi | Trạng Thái |
| :---: | :--- | :--- | :---: |
| **01** | [SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md) | Tinder Swipe Game, 5 Kịch bản Trigger, Spring Physics, Vuốt Lên dập dấu sáp đỏ. | ✅ Hoàn thành |
| **02** | [SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md) | Bộ quét lùi thưa thớt ngẫu nhiên SQLite Cache, sinh chú thích lãng đãng offline. | ✅ Hoàn thành |
| **03** | [SPEC_03_MEME_CARD_COMPOSITING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_03_MEME_CARD_COMPOSITING.md) | Ghép mặt chibi chibi 15 mẫu, share Story 1 chạm và QR Code. | ✅ Hoàn thành |
| **04** | [SPEC_04_FEED_MOMENTS_INTEGRATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_04_FEED_MOMENTS_INTEGRATION.md) | Tải ảnh ngầm FIFO Dio queue, ẩn/hiện dynamic banner, Cozy Chat Bridge XML. | ✅ Hoàn thành |
| **05** | [SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md) | Lưới so le Wabi-Sabi, thêm ảnh/sự kiện/hybrid thủ công, sắp xếp đa chiều, sớ giấy da Minh bạch dữ liệu. | ✅ Hoàn thành |
| **06** | [SPEC_06_LEAN_GACHA_MONETIZATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_06_LEAN_GACHA_MONETIZATION.md) | Doanh thu in ảnh thật Polaroid Instax, Washi skin packs, Pate Coins. | ✅ Hoàn thành |
| **07** | [SPEC_07_CARE_DIARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_07_CARE_DIARY_ENGINE.md) | Nhật ký chăm sóc 16 sự kiện, Cozy Chat NLP Intent, nhắc hẹn push giọng Boss. | ✅ Hoàn thành |
| **08** | [SPEC_08_PET_INDIVIDUAL_RECOGNITION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_08_PET_INDIVIDUAL_RECOGNITION.md) | Nhận dạng cá thể đa Boss bằng TFLite MobileNetV3 + Cosine Similarity. | ✅ Hoàn thành |

---

## III. KẾT QUẢ ĐÁNH GIÁ PHẢN BIỆN (MOM TEST & DOANH THU)

*   **Arthur (Mom Test Expert):** 
    *   Thiết kế lưới Masonry Wabi-Sabi so le tạo ấn tượng hoài cổ, giảm cảm giác nhàm chán cực kỳ tốt. 
    *   Luồng thêm ký ức thủ công đáp ứng tuyệt đối nhu cầu ghi chép cá nhân hóa, đặc biệt thẻ kết hợp (Hybrid Card) tạo ra sự thèm muốn lưu giữ kỷ niệm cực cao.
*   **Leo (Finance Analyst):** 
    *   Việc chạy 100% on-device đối với các mô hình nhận dạng vân pháp và ML Kit giúp triệt tiêu chi phí hạ tầng máy chủ AI, đảm bảo dòng tiền từ Instax in ảnh Polaroid thật đạt tỉ lệ lợi nhuận ròng lý tưởng **50-60%**.

---

## IV. KẾ HOẠCH HÀNH ĐỘNG TIẾP THEO (ACTION ITEMS)

| Người chịu trách nhiệm | Mô tả chi tiết đầu việc | Hạn chót | Trạng thái |
| :--- | :--- | :---: | :---: |
| **🎨 Maya (Designer)** | Hoàn thiện bản vẽ vector 15 mẫu khung chibi meme pastel và visual layout cho Event Card. | *Phase 2* | ⏳ Chờ thực hiện |
| **🛠️ Alan (Tech Lead)** | Hợp nhất SQLite schema các cột matched_pet, auto_caption vào `SPEC_02_OFFLINE_ML_FILTERS.md` Section 3.1. | *Ngay lập tức* | ✅ Hoàn thành |
| **👩‍💼 Sophia (CPO / PM)** | Đồng bộ hóa và cập nhật prompt Cozy Narrative Bridge Section 5 trong `SPEC_06_STORYTELLING_BACKBONE.md`. | *Ngay lập tức* | ✅ Hoàn thành |
| **🧠 Arthur & Alan** | Đồng bộ hóa cơ chế trích xuất `pet_id` tự động khi log Care Diary từ ảnh Polaroid. | *Ngay lập tức* | ✅ Hoàn thành |
| **🛠️ Alan & Benny** | Triển khai viết mã nguồn thử nghiệm (Scratch scripts) load model MobileNetV3 small trên Flutter. | *Phase 2* | ⏳ Chờ thực hiện |

---

*Biên bản họp được ký tên và đóng dấu ảo bởi Team Capcat — PM Sophia, Designer Maya, Tech Lead Alan, Chuyên gia Arthur*
