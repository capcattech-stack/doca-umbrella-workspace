# 🐾 ĐẶC TẢ PRD & KIẾN TRÚC KỸ THUẬT: HỒ SƠ PET TỐI GIẢN CỰC HẠN & LUỒNG ONBOARDING HỘI THOẠI THÔNG MINH
*(SPEC_06_SHARABLE_PET_PROFILE - EXTREME MINIMALIST MUJI PROFILE & CONVERSATIONAL ONBOARDING SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC_06_SHARABLE_PET_PROFILE`  
> **Phân hệ cha:** `AUTHENTICATION_AND_ONBOARDING_ENGINE`  
> **Chủ trì:** PM Sophia (CPO), Maya (UI/UX), Alan (Tech Lead), Benny (Senior Mobile Dev)  
> **Trạng thái:** Dev-Ready (Đã tinh giản tối đa theo phản hồi phỏng vấn Cohort Thực chứng)

---

## 🧪 I. KẾT QUẢ PHỎNG VẤN THỰC CHỨNG 3 PERSONA (COHORT SIMULATION REPORT)

Chúng tôi đã thực hiện một cuộc phỏng vấn giả định chuẩn **Mom Test** trên 3 nhóm người dùng mục tiêu khác nhau để thẩm định thiết kế hồ sơ Pet cũ (20 trường nhập liệu + biểu đồ thú y phức tạp) so với triết lý **Tối giản cực hạn Muji**:

### 1. Phỏng vấn Vy (24 tuổi, Copywriter tại Hà Nội - Sống một mình cùng chú chó Poodle Bột)
*   **Thói quen thực tế:** Thường xuyên đi làm muộn, cảm giác tội lỗi vì để Poodle Bột ở nhà một mình. Hận các form nhập liệu phức tạp.
*   **Phản hồi Mom Test:** *"Tôi đi làm cả ngày mệt đứt hơi rồi. Mở app ra chỉ muốn cưng nựng nó cho đỡ cô đơn. Nếu app bắt tôi ngồi điền cân nặng, rồi vaccine, rồi tạo bảng biểu đồ... tôi xóa app ngay lập tức. Nhưng nếu app cho tôi một ô nhật ký tự do để tôi gõ linh tinh: 'Bột sợ tiếng sấm, thích ăn đùi gà và hay ngủ gác đầu lên chân tôi', tôi thấy gần gũi và ấm áp hơn nhiều. Nó giống như cuốn sổ tay tôi viết tay cho nó vậy."*

### 2. Phỏng vấn Anh Minh (35 tuổi, Chủ quán cafe tại Đà Nẵng - Nuôi mèo cứu hộ Miu Miu)
*   **Thói quen thực tế:** Thực dụng, bận rộn, không kiên nhẫn với công nghệ rườm rà.
*   **Phản hồi Mom Test:** *"Mấy cái app bắt điền form rườm rà là tôi chịu chết, không bao giờ dùng. Tôi chỉ muốn một cái gì đó mở ra là dùng ngay. Việc trò chuyện rồi app tự lưu thông tin thằng Miu Miu vào hồ sơ là quá thông minh. Tôi không cần biểu đồ thú y làm gì cả, sổ tiêm phòng của nó phòng khám thú y đã giữ rồi, tôi không rảnh để log tay."*

### 3. Phỏng vấn Chi (19 tuổi, Sinh viên năm nhất tại TP.HCM - Nhớ mèo Mập ở quê)
*   **Thói quen thực tế:** Nghiện Ghibli, Pinterest, thích viết status đêm muộn, rất nhớ Pet ở quê.
*   **Phản hồi Mom Test:** *"Việc ẩn mấy cái tag Prompt AI đi là cực kỳ đúng đắn! Em muốn tin bé Mập là tri kỷ thật đang tâm sự với em, chứ nhìn thấy mấy cái tag 'Tone: Chảnh chọe, Prompt ID: 5' thì giống như đang chơi với một cái máy lạnh lùng. Em thích giao diện phẳng Muji, chỉ có ảnh Polaroid, ngày bên nhau và trang nhật ký viết tay trơn."*

---

## 🎯 II. QUYẾT ĐỊNH THAY ĐỔI CHIẾN LƯỢC SẢN PHẨM (THE COMPACT PIVOT)

Từ phản hồi đồng thuận 100% của 4 Persona (Nam, Vy, Minh, Chi), Capcat quyết định **Tái Cấu Trúc Cực Hạn (80% Slashing)**:

1.  **Loại bỏ 100% gánh nặng biểu đồ y khoa & đo lường hành chính:** Chém bỏ hoàn toàn biểu đồ cân nặng, mã số RFID, trục tiêm phòng chi tiết và lịch ăn uống JSON. Trả lại sự thuần khiết cho một app chữa lành Iyashikei.
2.  **Hộp Sổ Tay Tự Do Duy Nhất (Cozy Scrapbook Note):** Gộp toàn bộ các trường thói quen, dị ứng, dặn dò thành **một vùng nhập liệu trơn (TextField) duy nhất** được thiết kế như một trang nhật ký cũ mở ra trên mặt bàn gỗ. Sen viết gì cũng được, không ép buộc cấu trúc.
3.  **Bảo toàn Ma Thuật AI (Zero Prompt Exposure):** Ẩn hoàn toàn các thông số kỹ thuật AI. Persona của Pet sẽ được hình thành tự nhiên thông qua luồng Onboarding hội thoại và các cuộc Cozy Chat.

---

## 💬 III. LUỒNG ONBOARDING HỘI THOẠI THÔNG MINH (SMART CONVERSATIONAL COLLECTOR)

Để triệt tiêu hoàn toàn tỷ lệ người dùng bỏ app khi gặp form đăng ký ban đầu (Zero-Friction Conversion), thông tin của Boss sẽ được thu thập một cách tự nhiên thông qua một cuộc **Trò chuyện thấu cảm màu nước Ghibli (Conversational Onboarding)**:

```
[BƯỚC 1: ĐÓN CHÀO]
Giao diện hiển thị nét chì phác thảo một mảnh vườn Ghibli tĩnh lặng.
Bác bảo vệ vườn ký ức (hoặc Ông già Namiya) chào Sen bằng font serif Nunito ấm áp:
"Chào bạn... Mảnh vườn nhỏ đang sương mù tĩnh lặng chờ trông. 
Bạn đang dắt theo một bé cưng nào về nhà chung của chúng ta thế?"

             ┌────────────────────────────────────────────────────────┐
             │ Sen gõ chat: "Mình dẫn theo bé mèo Anh lông ngắn     │
             │ tên là Bánh Mỳ."                                       │
             └────────────────────────────────────────────────────────┘
                                         │
                                         ▼
                 [HỆ THỐNG AI CỤC BỘ TRÍCH XUẤT TỰ ĐỘNG (NLP)]
                 - name: "Bánh Mỳ"
                 - species: "cat"
                 - breed: "Mèo Anh lông ngắn"

                                         │
                                         ▼
[BƯỚC 2: HỎI THĂM KỶ NIỆM]
"Bánh Mỳ... cái tên nghe ấm áp và thơm phức như ổ bánh mì ban mai vậy.
Hai bạn lần đầu gặp nhau vào ngày nào thế? Hoặc ngày sinh nhật của bé là bao nhiêu?"

             ┌────────────────────────────────────────────────────────┐
             │ Sen gõ chat: "Bé sinh ngày 15/05/2024, mình đón bé     │
             │ về nuôi được tầm 3 tháng nay rồi."                     │
             └────────────────────────────────────────────────────────┘
                                         │
                                         ▼
                 [HỆ THỐNG AI CỤC BỘ TRÍCH XUẤT TỰ ĐỘNG (NLP)]
                 - birthday: "2024-05-15"
                 - adopted_at: "2026-03-01" (Tự động lùi 3 tháng so với hiện tại)

                                         │
                                         ▼
[BƯỚC 3: DẶN DÒ TÌNH CẢM]
"Mình đã dọn sẵn một góc phòng ấm áp cho Bánh Mỳ rồi. 
Bé có thói quen đặc biệt nào, hay có món gì dị ứng/ghét cay ghét đắng 
mà bạn muốn mình lưu ý không?"

             ┌────────────────────────────────────────────────────────┐
             │ Sen gõ chat: "Bé rất sợ tiếng sấm dông, thích nằm ngủ  │
             │ cuộn tròn cuối giường và ghét tắm nước lạnh nhé."     │
             └────────────────────────────────────────────────────────┘
                                         │
                                         ▼
                 [HỆ THỐNG AI CỤC BỘ TRÍCH XUẤT TỰ ĐỘNG (NLP)]
                 - cozy_notes: "Bé rất sợ tiếng sấm dông, thích nằm ngủ cuộn tròn cuối giường và ghét tắm nước lạnh nhé."
                 - self_term: "Trẫm" (AI tự suy luận dựa trên giống mèo và tên)
                 - owner_term: "Sen"

                                         │
                                         ▼
[BƯỚC 4: HOÀN TẤT]
"Mọi thứ đã sẵn sàng rồi... Hãy bước vào vườn nhà ấm áp cùng Bánh Mỳ nhé 🐾"
(Server tự động ghi dữ liệu vào SQLite cục bộ và trượt mở Trang Chủ Home)
```

---

## 💾 IV. HỆ THỐNG HÓA CƠ SỞ DỮ LIỆU CỤC BỘ TINH GỌN (THE FLAT SQLite SCHEMA)

Nhờ triết lý tối giản cực hạn, cơ sở dữ liệu của Boss được tinh giản từ **4 bảng phức tạp xuống chỉ còn đúng 1 bảng phẳng duy nhất** `pet_profile`:

```sql
-- Bảng phẳng duy nhất lưu giữ toàn bộ tâm hồn & thông tin của Boss cưng
CREATE TABLE pet_profile (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    species TEXT NOT NULL,              -- 'cat' hoặc 'dog' (AI trích xuất tự động)
    breed TEXT NOT NULL,                -- Giống loài (Mèo Anh lông ngắn, Husky...)
    birthday TEXT,                      -- Lưu dạng YYYY-MM-DD để trigger sự kiện sinh nhật Boss
    adopted_at TEXT,                    -- Ngày nhận nuôi (YYYY-MM-DD) để trigger ngày kỷ niệm hai đứa bên nhau
    avatar_url TEXT,                    -- Đường dẫn ảnh đại diện (ảnh thật của Boss do Sen chọn)
    cozy_notes TEXT,                    -- [Góc Lưu Ý Của Sen] Trang nhật ký tự do ghi chép thói quen, dị ứng viết tay
    self_term TEXT,                     -- [Ẩn hoàn toàn] Pet tự xưng khi chat (Trẫm, Em, Bé, Con...)
    owner_term TEXT,                    -- [Ẩn hoàn toàn] Pet gọi Sen khi chat (Sen, Mẹ, Anh, Chị...)
    persona_template_id INTEGER,        -- [Ẩn hoàn toàn] ID bộ nhân cách AI đang chạy ngầm
    updated_at INTEGER NOT NULL         -- Epoch timestamp phục vụ đồng bộ ngoại tuyến thầm lặng
);

CREATE INDEX idx_pet_profile_dates ON pet_profile(birthday, adopted_at);
```

---

## 🎨 V. ĐẶC TẢ CHI TIẾT GIAO DIỆN HỒ SƠ PET PHẲNG MUJI MỚI (`PetProfileScreen`)

Giao diện hồ sơ mới được thu gọn lại thành một cấu trúc phẳng 2D cực kỳ thanh nhã và ngăn nắp, loại bỏ hoàn toàn biểu đồ và các danh mục hành chính:

```
+-------------------------------------------------------------+
|  [🏠]                  HỒ SƠ CỦA BÁNH MỲ              [📸]  | <-- Flat AppBar (Home vs Album shortcuts)
|-------------------------------------------------------------|
|                                                             |
|                         /\_/\                               |
|                        ( =.o=)   <-- Bánh Mỳ                |
|                        / >🍑< \                             |
|                                                             |
|                 BÁNH MỲ (Mèo Anh Lông Ngắn)                 | <-- Tên & Giống loài
|               Đồng hành cùng nhau: 42 ngày 🐾               | <-- Dòng chữ Outfit lãng mạn
|                                                             |
|  +-------------------------------------------------------+  |
|  | "Trông trẫm lúc ngủ hơi dìm hàng nhỉ Sen, thế mà cũng |  | <-- Whisper Bubble thấu cảm
|  |  chụp lại cho bằng được!"                             |  |     (Rung khò khò khi chạm)
|  +-------------------------------------------------------+  |
|                                                             |
|  📅 SỰ KIỆN QUAN TRỌNG                                      |
|  - Sinh nhật của bé: Ngày 15 tháng 05                       | <-- Ngày sinh nhật phẳng Muji
|  - Ngày về nhà mới: Ngày 01 tháng 03                        | <-- Ngày nhận nuôi phẳng Muji
|                                                             |
|  📝 GÓC LƯU Ý CỦA SEN (Scrapbook Notes)                      |
|  +-------------------------------------------------------+  |
|  | Bé rất sợ tiếng sấm dông, thích nằm ngủ cuộn tròn     |  | <-- Text Field trơn viết tự do
|  | cuối giường và ghét tắm nước lạnh nhé.                |  |     viền 1px mảnh màu #EAEAEA
|  |                                                       |  |
|  | [Chỉnh sửa nhật ký 📝]                                |  |
|  +-------------------------------------------------------+  |
|                                                             |
|  =========================================================  |
|  [ 🏠 Home ]        [ 💬 Chat ]         [ 📸 Ký Ức ]  [👤 Tôi] | <-- Bottom Navigation Dock
+-------------------------------------------------------------+
```

---

## 🔒 VI. TIÊU CHÍ NGHIỆM THU TỐI GIẢN (ACCEPTANCE CRITERIA)

1.  **AC-1 (Zero Form Onboarding):** Xác minh rằng người dùng mới Onboard **không phải điền bất kỳ một ô Input Form hành chính nào**. Toàn bộ thông tin tên, loài, ngày sinh, ghi chú đều được trích xuất tự động qua luồng chat hội thoại Ghibli và lưu vào SQLite ngầm.
2.  **AC-2 (1-Table Database Integrity):** Xác minh SQLite cục bộ chỉ duy nhất tồn tại 1 bảng phẳng `pet_profile` để lưu trữ thông tin Boss. Hủy bỏ hoàn toàn các bảng logs cân nặng, tiêm phòng cũ để bảo toàn tài nguyên bộ nhớ.
3.  **AC-3 (Zero Prompt Leakage):** Tuyệt đối không để lộ các thông số cấu hình AI ("Tone", "Style", "Prompt") lên bất kỳ góc nào của giao diện hồ sơ Pet công khai.
4.  **AC-4 (Draggable Parallax Boundary):** Drag handle kéo trượt tấm sheet hoạt động mượt mà ở tần số 60fps, Avatar nổi to tự động co tỷ lệ về 0.0x khi cuộn qua mốc 80% chiều cao mà không bị va chạm layout với AppBar.
5.  **AC-5 (Single Text Field Scrapbook):** Phần ghi chép của Sen (`cozy_notes`) hoạt động dưới dạng 1 TextField tự do duy nhất, hỗ trợ xuống dòng và tự động đồng bộ SQLite khi người dùng nhấn nút hoàn tất chỉnh sửa nhật ký.
D `microchip_id` cục bộ lên các tấm tờ rơi dán quanh khu phố. Cực kỳ thực tiễn và hữu dụng.
*   **Chia Sẻ Phân Quyền (Share Profile Button):**
    *   *Tính năng thực tế:* Cho phép người dùng chọn 1 trong 2 chế độ xuất ảnh:
        1.  *Chế độ Thú Y (Vet Clinic Access):* Chỉ trích xuất ảnh Polaroid + Bảng biểu đồ cân nặng + Lịch sử Vaccine.
        2.  *Chế độ Khách Sạn (Pet Boarding Access):* Chỉ trích xuất thông tin ăn hạt, pate, thói quen ngủ và dị ứng thức ăn.
    *   Sau khi chọn, hệ thống tạo ra một liên kết tĩnh dạng `.html` phẳng Muji để Sen gửi nhanh qua Zalo cho Bác sĩ hoặc nhân viên trông hộ thú cưng, giữ an toàn tuyệt đối các bí mật trò chuyện riêng tư của gia đình.

---

## 🔒 VI. TIÊU CHÍ NGHIỆM THU HỒ SƠ PET ĐA CHIỀU (ACCEPTANCE CRITERIA)

1.  **AC-1 (God Class Elimination):** Mã nguồn `pet_profile_screen.dart` bắt buộc được bẻ nhỏ hoàn toàn. File màn hình chính không được vượt quá `500 dòng code`, mọi widget hiển thị nội dung phải nằm độc lập tại thư mục `widgets/pet_profile/`.
2.  **AC-2 (Riverpod & Zero-setState):** Tuyệt đối không sử dụng `setState` của Flutter cho các thay đổi dữ liệu lớn. Mọi trạng thái cập nhật hồ sơ từ các Bottom Sheet phải được xử lý tập trung thông qua `petProfileProvider` và Riverpod state notification.
3.  **AC-3 (Offline-First Performance):** Mở màn hình khi mất mạng hoàn toàn -> Giao diện hồ sơ hiển thị đầy đủ thông tin Pet dưới <50ms lấy từ SQLite cục bộ. Không có bất kỳ Spinner Loading chặn màn hình nào xuất hiện.
4.  **AC-4 (Zero-Collision Parallax):** Khi vuốt cuộn tấm sheet lên kịch trần, Avatar nổi biến mất hoàn toàn và thanh AppBar hiển thị sắc nét ảnh đại diện tròn nhỏ cùng tên Pet mà không bị đè chồng lấp chéo hình ảnh.
5.  **AC-5 (Privacy Shield Enforced):** Khi xuất bản sao lưu hoặc link chia sẻ hồ sơ ra ngoài, các trường dữ liệu xưng hô AI (`self_term`, `owner_term`) bắt buộc không được xuất hiện trong JSON payload hay HTML output.

