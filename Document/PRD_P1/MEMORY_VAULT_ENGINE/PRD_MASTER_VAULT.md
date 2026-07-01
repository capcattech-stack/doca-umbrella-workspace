# TÀI LIỆU YÊU CẦU SẢN PHẨM MASTER: CHIẾC RƯƠNG KÝ ỨC (DOCA CAPSULE) & TRÒ CHƠI SWIPE
*(MASTER PRODUCT REQUIREMENT DOCUMENT - PRD V1.2 - THƯƠNG HIỆU: DOCA)*

---

## 🧭 1. TẦM NHÌN & MỤC TIÊU SẢN PHẨM (PRODUCT VISION & GOALS)

Sứ mệnh tối cao của **DOCA** là chữa lành sự cô đơn của con người đô thị bằng cách nhân cách hóa chú thú cưng ngoài đời thực của họ thành tri kỷ số độc bản thông qua **DOCA PetTwin** và lưu trữ hành trình cuộc đời của chúng tại **DOCA Capsule**.

Phân hệ **Chiếc Rương Ký Ức (DOCA Capsule)** được phát triển nhằm tích lũy và tổ chức toàn bộ các dữ liệu kỷ niệm (Hình ảnh Moments tải lên, Ký ức chat trích xuất dạng text, và Nhật ký y tế từ Sổ tay của mẹ) thành một **Dòng thời gian (Timeline) thống nhất trong Database**, làm nguyên liệu thấu hiểu (Context) cho AI Pet.

### 1.1. Tuyên Ngôn Triết Lý Cốt Lõi (The Master Core Philosophy)
> 🐾 *"Tôi lưu giữ mọi dấu vết đồng hành của bạn trong DOCA Capsule. Khi tự động quét thư viện ảnh, tôi chỉ lọc ra các ảnh có thú cưng (để bảo vệ quyền riêng tư). Mọi ký ức của bạn được sử dụng làm chất liệu ôn chuyện tri kỷ."*

*   **Ranh giới Quyền Riêng Tư (Privacy Boundary):** Trò chơi Buffet Ký ức (Tinder Swipe) quét offline chỉ lọc ảnh chứa chó/mèo.
*   **Chủ quyền Dữ liệu của Sen (User Data Sovereignty):** Ngoài ảnh quét tự động, người dùng có thể nạp thủ công bất kỳ hình ảnh nào vào dòng thời gian.
*   **Dòng thời gian Đa thể loại (Unified Timeline):** Lưu giữ các sự kiện Sổ tay Y tế và Moments dưới dạng văn bản thuần túy (Text-based records).

---

## 🛠️ 2. THIẾT KẾ ĐỐI KHÁNG VÀ TỐI ƯU HIỆU NĂNG (ADVERSARIAL REFINEMENTS)

Để vượt qua các giới hạn ngặt nghèo của hệ điều hành di động, triệt tiêu hao pin và đảm bảo trải nghiệm quẹt thẻ mượt mà, phân hệ áp dụng các cải tiến kỹ thuật cốt lõi:

### 2.1. Giải pháp quét ảnh "Foreground Idle Batch Scan & SQLite Caching"
*   **Không quét ảnh chạy ngầm (No background scanning):** Tránh bị OS tắt tiến trình do quá tải CPU.
*   **Foreground Idle Processing:** Tiến trình quét chỉ chạy khi người dùng đang mở ứng dụng ở trạng thái rảnh (Idle), hoặc khi đang xem màn hình "Buffet Ký ức".
*   **Quét theo lô thông minh (Batch of 50):** Quét tối đa 50 hình ảnh mới nhất từ thư viện bằng Google ML Kit offline. Lặp lại cho đến khi lọc được **tối thiểu 15 ảnh chứa chó/mèo** sẵn sàng trong hàng đợi quẹt.
*   **Cơ chế lưu đệm thông minh (SQLite Caching):** Lưu Asset ID ảnh chó mèo vào bảng `local_photo_cache` cục bộ để người dùng có thể chơi ngay lập tức mà không bị cụt hứng.

### 2.2. Đơn giản hóa MVP (Scope Guillotine)
*   **Loại bỏ tính năng Đa Boss:** MVP V1.0 chỉ hỗ trợ 1 Boss duy nhất, do đó loại bỏ luồng "Tái phân loại ảnh cho Đa Boss" (Retroactive Re-indexing) để tránh phình to quy mô phát triển.

---

## 🏛️ 3. Danh Sách Tài Liệu Đặc Tả Trực Thuộc (Specs Index)

Toàn bộ phân hệ được đóng gói nhất quán trong thư mục tính năng [MEMORY_VAULT_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/), bao gồm các đặc tả kỹ thuật và nghiệp vụ chi tiết:

| Số Thứ Tự | Tên Tài Liệu Đặc Tả | Phạm Vi Giải Quyết | Trạng thái |
| :---: | :--- | :--- | :--- |
| **01** | [SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md) | Vật lý vuốt kéo thẻ bài, spring animation, phản hồi rung Haptic khi quẹt Buffet Ký ức. | **[HOÃN - PHASE 2]** |
| **02** | [SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md) | Bộ lọc ảnh offline cục bộ bằng **Google ML Kit** kết hợp SQLite Caching. | **[HOÃN - PHASE 2]** |
| **03** | [SPEC_04_FEED_MOMENTS_INTEGRATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_04_FEED_MOMENTS_INTEGRATION.md) | Hàng đợi tải ảnh nền ngầm FIFO, auto-hide banner sau khi chơi xong Buffet Ký ức. | **[HOÃN - PHASE 2]** |
| **04** | [SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md) | Giao diện hiển thị dòng thời gian Polaroid viết tay mộc mạc, lưới phẳng và thẻ sự kiện text. Hỗ trợ nút Thêm Kỷ Niệm thủ công. | **[MVP V1.0]** |
| **05** | [SPEC_07_CARE_DIARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/SPEC_07_CARE_DIARY_ENGINE.md) | Cơ chế lưu trữ sự kiện Chat Memories, Sổ tay Y tế, và kết nối ngữ cảnh Chat. (Tạm cắt bỏ nhật ký Tamagotchi). | **[MVP V1.0]** |
| **06** | [SPEC_09_RAG_TIMELINE_RETRIEVAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/MEMORY_VAULT_ENGINE/SPEC_09_RAG_TIMELINE_RETRIEVAL.md) | Kiến trúc Cloud RAG, tiền lọc ngữ cảnh (Context-Sensing), đồng bộ server và gom prompt tối ưu token. | **[MVP V1.0]** |

*Lưu ý:* Đặc tả cắt ghép meme `SPEC_03_MEME_CARD_COMPOSITING.md` và cơ chế tiền coin gacha phức tạp `SPEC_06_LEAN_GACHA_MONETIZATION.md` được **loại bỏ hoàn toàn khỏi phạm vi phát triển**. Hệ thống chuyển sang mô hình Tiếp thị Liên kết Ngữ cảnh ([PRD_AFFILIATE_MONETIZATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/AFFILIATE_MONETIZATION/PRD_AFFILIATE_MONETIZATION.md)) để tạo doanh thu mộc mạc, bền vững cho ứng dụng.

---

*Tài liệu đặc tả đối kháng này đã được cập nhật và sẵn sàng chuyển giao lập trình. Ký tên: Team Cố vấn DOCA (Sophia, Alan, Benny)*
