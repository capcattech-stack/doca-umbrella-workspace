# 🗂️ TÀI LIỆU TỔNG HỢP & MỤC LỤC MASTER: DOCA MVP (PHASE 1)
*(THE CONSOLIDATED PRD MASTER GUIDE & INDEX - PHASE 1 MVP - V1.0)*

Tài liệu này là **Hiến pháp Kỹ thuật & Nghiệp vụ** dành cho đội ngũ phát triển (Alan - Tech Lead, Benny - Senior Mobile Dev, và Maya - UI/UX Designer) triển khai phiên bản **DOCA MVP V1.0**. Tài liệu tóm tắt ngắn gọn và liên kết toàn bộ 6 phân hệ kỹ thuật hoạt động trong Phase 1.

---

## 🧭 I. ĐỊNH VỊ SẢN PHẨM & TRIẾT LÝ THIẾT KẾ (ALIGNMENT & DESIGN VALUES)

1.  **Sứ mệnh cảm xúc (Iyashikei):** Chữa lành sự cô đơn của người đô thị thông qua việc nhân cách hóa thú cưng thực tế thành tri kỷ kỹ thuật số độc bản (**DOCA PetTwin**), lưu giữ hành trình cuộc đời tại (**DOCA Capsule**), bày biện không gian tinh thần tại (**DOCA Corner**), và gửi gắm tâm sự tại (**Namiya Mailbox**).
2.  **Triết lý thiết kế MUJI (Warm Minimalism):** 
    *   **Flat 100%:** Thiết kế phẳng, cấu trúc lưới vuông vắn ngăn nắp, tận dụng nhiều khoảng trắng (negative space) rộng lớn để giải tỏa căng thẳng võng mạc.
    *   **Không giả lập vật lý thô ráp:** Loại bỏ hoàn toàn hình ảnh kệ gỗ 3D/2D tả thực, không nét vẽ thô ráp loang lổ, không sound effect xào xạc lướt giấy.
    *   **Màu sắc nhã nhặn:** Nền trắng kem giấy tái chế cực dịu `#FBFBFA`, màu chữ đen ấm Obsidian `#262626`, và các mảng màu pastel nhạt cho từng danh mục.
3.  **Mô hình doanh thu: Tiếp thị liên kết (Contextual Affiliate Monetization):**
    *   **Không quảng cáo banner, không ví tiền ảo CatCoins, không gacha ép buộc.**
    *   Nguồn thu đến từ các liên kết giới thiệu tự nhiên (Shopee/Fahasa cho sách và tranh ảnh, Spotify/Apple Music Partnerize cho âm nhạc) tích hợp tại Bottom Sheet chi tiết của vật phẩm. Tham chiếu chi tiết tại [Đặc tả mô hình Tiếp thị Liên kết](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/AFFILIATE_MONETIZATION/PRD_AFFILIATE_MONETIZATION.md).

---

## 🏛️ II. PHẠM VI MVP V1.0 (ACTIVE SCOPE) VS. TƯƠNG LAI (PHASE 2 DE-SCOPED)

```
┌───────────────────────────────────────┬────────────────────────────────────────┐
│         ACTIVE IN MVP V1.0            │          HOÃN SANG PHASE 2             │
├───────────────────────────────────────┼────────────────────────────────────────┤
│ • Nuôi 1 Pet duy nhất.                │ • Nuôi nhiều Pet hoặc cùng nuôi (Co-up)│
│ • Cozy Chat (Thời tiết, Đêm muộn).    │ • Chỉ số sinh học Tamagotchi (Decay).  │
│ • AI Roast (Đọc hiểu ảnh dìm Vision). │ • Menu hành động chăm sóc (Feed, Walk).│
│ • Trắc nghiệm 9h (Builder Profile).    │ • Game Buffet Ký ức (Tinder swipe).    │
│ • Rương kỷ niệm Timeline & Lưới ảnh.  │ • Bộ lọc ảnh tự động chạy nền (ML).    │
│ • Thêm kỷ niệm thủ công (Bottom Sheet)│ • Hệ thống tiền ảo CatCoins, Gacha shop│
│ • Cozy Corner đĩa nhạc cơ học 30s.     │ • Trợ lý nổi toàn cục (AssistantHost). │
│ • Hòm thư gỗ ẩn danh Namiya.          │ • Custom Lottie chuyển động phức tạp.  │
└───────────────────────────────────────┴────────────────────────────────────────┘
```

---

## 📂 III. BẢN ĐỒ TÀI LIỆU ĐẶC TẢ CHI TIẾT (PRD & SPECS INDEX)

*   **Tài liệu mô tả tổng quan:** [PRODUCT_BRIEF.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/PRODUCT_BRIEF.md): Tài liệu Product Brief mô tả sản phẩm ở giai đoạn MVP và phân tích khoảng cách (GAPs) đối chiếu với Vision & Brand.
*   **Báo cáo thẩm định sản phẩm:** [MOM_TEST_VALIDATION_REPORT.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MOM_TEST_VALIDATION_REPORT.md): Báo cáo đánh giá Mom Test giả lập 10 khách hàng tiềm năng và phân tích khả thi tài chính/BizDev.

Nhấp vào các liên kết bên dưới để truy cập trực tiếp tài liệu đặc tả chi tiết của từng phân hệ:

### 1. Phân hệ Nền Tảng: Authentication & Onboarding
*   **Unified PRD:** [PRD_AUTHENTICATION_AND_ONBOARDING.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/AUTHENTICATION_AND_ONBOARDING_ENGINE/PRD_AUTHENTICATION_AND_ONBOARDING.md): Đặc tả hợp nhất toàn bộ luồng Đăng nhập (Google One-Tap SSO), Khởi tạo hồ sơ Boss (Pet Onboarding), Nhận diện hình ảnh cục bộ (ML Kit), Thiết lập tính cách AI (Pronouns 2-way), Giao diện Bottom Sheet hồ sơ và Kiến trúc RAG bộ nhớ chat.

### 2. Phân hệ Phòng Chat Tri Kỷ: Cozy Chat Resonance Engine
*   **Unified PRD:** [PRD_COZY_CHAT_RESONANCE_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/PRD_COZY_CHAT_RESONANCE_ENGINE.md): Đặc tả hợp nhất toàn bộ luồng trò chuyện chủ động và tự phát ngoài app (Dual-Loop Chat, Cozy Delay Buffer), các bộ cảm biến ngoại cảnh foreground-only (GPS làm tròn, thời tiết), thuật toán tự học địa điểm không giao diện (Zero-UI), prompt engineering thấu cảm, đồng bộ dữ liệu CMS qua Google Sheets, chế độ trú ẩn ngoại tuyến (Sanctuary 30 FPS CustomPainter), và đĩa than cơ học cơ bản.
*   **Tài liệu Spec con:**
    *   [SPEC_01_CULTURAL_RESONANCE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_01_CULTURAL_RESONANCE.md): Thiết kế hyperlink chấm mảnh dẫn sang đĩa nhạc, sách cũ.
    *   [SPEC_02_CONTEXT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_02_CONTEXT_SENSING.md): Cơ chế Scheduled Local Push và lời nhắn thì thầm đêm muộn.
    *   [SPEC_03_PROFILE_EXTRACTION.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_03_PROFILE_EXTRACTION.md): Kịch bản hỏi thăm theo Mom Test và trắc nghiệm Conversational Builder.
    *   [SPEC_04_INVISIBLE_GEOSPATIAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_04_INVISIBLE_GEOSPATIAL.md): Gắn nhãn địa điểm ngầm (Nhà riêng/Cơ quan) để gợi ý bối cảnh chat.
    *   [SPEC_05_FREQUENCY_COMPASS.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_05_FREQUENCY_COMPASS.md): Giới hạn tần suất tin nhắn tự phát, rung Purring nhẹ.
    *   [SPEC_06_STORYTELLING_BACKBONE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_06_STORYTELLING_BACKBONE.md): Nguyên tắc Prompt Engineering thấu cảm và cá tính AI.
    *   [SPEC_07_EXTERNAL_AMBIENT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_07_EXTERNAL_AMBIENT_SENSING.md): Cấu hình gọi OpenWeatherMap API lấy dữ liệu thời tiết tức thì.
    *   [SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md): Kiến trúc dữ liệu CMS kết hợp Cozy Openers.
    *   [SPEC_09_OFFLINE_SANCTUARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_09_OFFLINE_SANCTUARY_ENGINE.md): Giao diện Trú ẩn Offline, trộn câu thoại cục bộ và âm thanh thiên nhiên.
    *   [SPEC_10_VIRTUAL_VINYL_STORE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/Specs/SPEC_10_VIRTUAL_VINYL_STORE.md): Giao diện bàn xoay đĩa cơ học và nút tích hợp tiếp thị liên kết Spotify/Apple Music.

### 3. Phân hệ Tiếp thị Liên kết Ngữ cảnh: Contextual Affiliate Monetization
*   **Master PRD:** [PRD_AFFILIATE_MONETIZATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/AFFILIATE_MONETIZATION/PRD_AFFILIATE_MONETIZATION.md)
*   **Tài liệu Spec con:**
    *   [SPEC_01_ENTITY_TAGGING.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/AFFILIATE_MONETIZATION/SPEC_01_ENTITY_TAGGING.md): Thiết kế giải pháp trích xuất thực thể và ánh xạ từ khoá tiếp thị liên kết chạy offline.

### 4. Phân hệ Góc Trưng Bày: DOCA Corner
*   **Master PRD:** [PRD_MASTER_SHELF.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_SHELF_LIBRARY_ENGINE/PRD_MASTER_SHELF.md)
*   **Tài liệu Spec con:**
    *   [SPEC_01_MUJI_GRID_SHELF.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_SHELF_LIBRARY_ENGINE/SPEC_01_MUJI_GRID_SHELF.md): Thiết kế lưới phẳng ngăn nắp, tab phân loại và TabBar Muji.
    *   [SPEC_02_SHELF_BOTTOMSHEET.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_SHELF_LIBRARY_ENGINE/SPEC_02_SHELF_BOTTOMSHEET.md): Hộp thoại chi tiết trích dẫn sách (link Shopee/Fahasa) và máy nghe nhạc 30s.

### 5. Phân hệ Chiếc Rương Kỷ Niệm: DOCA Capsule
*   **Master PRD:** [PRD_MASTER_VAULT.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/PRD_MASTER_VAULT.md)
*   **Tài liệu Spec con:**
    *   [SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md): Lưới ảnh Polaroid lật thẻ, luồng Thêm kỷ niệm thủ công (Bottom Sheet) và bảng quản lý dữ liệu riêng tư.
    *   [SPEC_07_CARE_DIARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/SPEC_07_CARE_DIARY_ENGINE.md): Đồng bộ ký ức chat và nhật ký y tế (Sổ tay của mẹ) xuống SQLite cục bộ và máy chủ đám mây bảo mật.
    *   [SPEC_09_RAG_TIMELINE_RETRIEVAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/SPEC_09_RAG_TIMELINE_RETRIEVAL.md): Kiến trúc Cloud RAG, tiền lọc ngữ cảnh (Context-Sensing), đồng bộ server và gom prompt tối ưu token.

### 6. Phân hệ Tiệm Thư Ẩn Danh: Namiya Mailbox
*   **Master PRDs & Specs:** 
    *   [PRD_NAMIYA_MAILBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/NAMIYA_MAILBOX_ENGINE/PRD_NAMIYA_MAILBOX.md): Quy trình gửi thư ẩn danh và nhận hồi âm từ Namiya.
    *   [SPEC_NOTION_EDITOR.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/NAMIYA_MAILBOX_ENGINE/SPEC_NOTION_EDITOR.md): Trình chỉnh sửa phong thư tối giản Notion-style.
    *   [SPEC_MILK_BOX_INBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/NAMIYA_MAILBOX_ENGINE/SPEC_MILK_BOX_INBOX.md): Thùng sữa đựng thư hồi âm phẳng.
    *   [PRD_HIDDEN_ADOPTION_FLOW.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/PRD_HIDDEN_ADOPTION_FLOW.md): Luồng nhận nuôi bí ẩn thông qua trao đổi thư tín. **[HOÃN SANG PHASE 2]**

---

## 🎨 IV. TIÊU CHUẨN THIẾT KẾ UI & HƯỚNG DẪN HOÀI CỔ CHỮA LÀNH
*   [01_DESIGN_PHILOSOPHY_AND_MOOD.md](file:///Users/macinia/Capcat%20Project/Document/UI/01_DESIGN_PHILOSOPHY_AND_MOOD.md): Triết lý thẩm mỹ Iyashikei, Modernist Minimalism và phong cách vẽ màu nước Ghibli (không chibi).
*   [02_DESIGN_SYSTEM_TOKENS.md](file:///Users/macinia/Capcat%20Project/Document/UI/02_DESIGN_SYSTEM_TOKENS.md): Quy chuẩn Tokens màu sắc (Light/Dark Mode), typography (Inter, Space Mono), Radius, Shadows và Lucide Icons.
*   [03_COMPONENT_CATALOG.md](file:///Users/macinia/Capcat%20Project/Document/UI/03_COMPONENT_CATALOG.md): Đặc tả chi tiết các thành phần giao diện (Bottom Dock, Nút bấm, Ô nhập liệu, Cards, Lists, Bottom Sheets).
*   [04_COZY_UX_PATTERNS.md](file:///Users/macinia/Capcat%20Project/Document/UI/04_COZY_UX_PATTERNS.md): Sổ tay 5 Cozy UX Patterns (Cộng hưởng môi trường, rung haptic, trí nhớ dài hạn, care log).
*   [05_WIREFRAMES_AND_TEMPLATES.md](file:///Users/macinia/Capcat%20Project/Document/UI/05_WIREFRAMES_AND_TEMPLATES.md): Tổng hợp 10 page templates cốt lõi và wireframe phác thảo ASCII.
*   [06_UX_WRITING_GUIDELINES.md](file:///Users/macinia/Capcat%20Project/Document/UI/06_UX_WRITING_GUIDELINES.md): Hướng dẫn viết microcopy, tone giọng xưng hô 4 cá tính Boss và lời thì thầm đêm muộn.

---

*Tài liệu tổng hợp này do CPO Sophia phê chuẩn, đóng vai trò làm điểm hạ cánh (Landing Page) cho toàn bộ Đội ngũ phát triển DOCA.*
