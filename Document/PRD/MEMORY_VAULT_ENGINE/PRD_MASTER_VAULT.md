# TÀI LIỆU YÊU CẦU SẢN PHẨM MASTER: HỘP KÝ ỨC & TRÒ CHƠI SWIPE DOPAMINE
*(MASTER PRODUCT REQUIREMENT DOCUMENT - PRD V1.1 - ĐÃ SỬA LỖI ĐỐI KHÁNG)*

> **Mã Tính Năng:** `FE-MEMORY-VAULT`  
> **Trạng thái:** Hoàn tất Thiết kế & Vá Đối kháng (Sẵn sàng triển khai)  
> **Tác giả:** Sophia (CPO / PM)  
> **Đơn vị phê duyệt:** Ban Giám đốc Dự án Capcat

---

## 🧭 1. TẦM NHÌN & MỤC TIÊU SẢN PHẨM (PRODUCT VISION & GOALS)

Sứ mệnh tối cao của **Capcat: Soul of Pet** là chữa lành sự cô đơn của con người đô thị bằng cách nhân cách hóa chú thú cưng ngoài đời thực của họ thành tri kỷ số độc bản.

Phân hệ **Hộp Ký Ức & Trò chơi Buffet Ký ức Tinder Game (FE-MEMORY-VAULT)** được phát triển nhằm nâng cấp trải nghiệm nạp hình ảnh/kỷ niệm của Boss vào hệ thống dữ liệu ký ức của Capcat với trải nghiệm **không xâm phạm quyền riêng tư**, **tiện lợi cực cao**, mang tính giải trí gây nghiện (Gamified Dopamine) và kích thích tương tác cảm xúc ngay lập tức giữa Sen và Boss ảo.

### 1.1. Tuyên Ngôn Triết Lý Cốt Lõi (The Master Core Philosophy)
> 🐾 *"Khi tôi tự động đọc ảnh của bạn tui chỉ đọc ảnh có thú cưng (để bảo vệ quyền riêng tư). Tuy nhiên kỷ niệm nào của bạn tui cũng có thể lưu trữ cho bạn (nếu nạp thủ công). Tôi ôn lại kỷ niệm với bạn bằng những kỷ niệm chúng ta đã chia sẻ trong Hộp Ký Ức."*

*   **Ranh giới Quyền Riêng Tư (Privacy Boundary):** Trình quét tự động (Foreground Scan) và Trò chơi Buffet Ký ức (Swipe Game) **chỉ lọc và hiển thị ảnh có thú cưng** (chó, mèo). Người dùng tuyệt đối không bị cảm giác xâm phạm đời tư khi chơi.
*   **Chủ quyền Dữ liệu của Sen (User Data Sovereignty):** Tuy quét tự động chỉ đọc ảnh thú cưng, nhưng **bất kỳ kỷ niệm/hình ảnh nào** (kể cả không có thú cưng) cũng đều có thể lưu trữ vào Hộp Ký Ức nếu người dùng lựa chọn tải lên thủ công.
*   **Tài nguyên Thấu Hiểu (RAG Context Data Asset):** Ký ức chính là tài sản lớn nhất để Boss ảo thấu hiểu chủ nuôi. Mọi kỷ niệm đã lưu trong Vault (đã chia sẻ) sẽ là chất liệu duy nhất để Boss ôn lại kỷ niệm xưa qua phân hệ Recall Flashback (Hộp Thư Cổ Kính) và RAG Cozy Chat.

---

## 🛠️ 2. THIẾT KẾ ĐỐI KHÁNG VÀ TỐI ƯU HIỆU NĂNG (ADVERSARIAL REFINEMENTS)

Để vượt qua các giới hạn ngặt nghèo của hệ điều hành di động, triệt tiêu hao pin và đảm bảo trải nghiệm quẹt thẻ gây nghiện, phân hệ áp dụng 3 cải tiến kỹ thuật cốt lõi:

### 2.1. Giải pháp quét ảnh "Foreground Idle Batch Scan & SQLite Caching"
*   **Không quét ảnh chạy ngầm (No background scanning):** Loại bỏ hoàn toàn background job để tránh bị OS tắt tiến trình do quá tải CPU.
*   **Foreground Idle Processing:** Tiến trình quét chỉ chạy khi người dùng **đang mở ứng dụng** và **không tương tác (trạng thái Idle)**, hoặc khi đang xem banner "Buffet Ký ức".
*   **Quét theo lô thông minh (Batch of 50):** Mỗi lần kích hoạt, app sẽ quét một lô tối đa **50 hình ảnh mới nhất** từ thư viện bằng thư viện Google ML Kit offline cực nhanh.
*   **Đảm bảo số lượng quẹt tối thiểu (At least 15 pet photos):** Để trò chơi Buffet không bị trống trải hay cụt hứng, tiến trình quét sẽ lặp lại các lô 50 ảnh cho đến khi lọc được **tối thiểu 15 ảnh chứa chó/mèo** sẵn sàng trong hàng đợi quẹt.
*   **Cơ chế lưu đệm thông minh (SQLite Caching):** 
    *   Hệ thống lưu trữ danh sách các Asset ID ảnh đã được xác nhận là chó/mèo vào bảng CSDL cục bộ `local_photo_intelligence_cache`.
    *   Càng tích lũy nhiều ảnh chó mèo vào cache càng tốt, giúp người dùng có thể quẹt liên tục mà không cần chờ đợi quét lại thư viện ảnh thực tế. Các ảnh đã quẹt sẽ được cập nhật flag `is_swiped = 1` trong SQLite để tránh hiển thị lại.

### 2.2. Luồng tái phân loại ảnh khi nâng cấp từ Đơn Boss sang Đa Boss (Retroactive Re-indexing)
*   **Vấn đề:** Khi người dùng ban đầu chỉ nuôi 1 boss (ảnh lưu không phân biệt ID), sau đó đón thêm boss thứ 2, toàn bộ kho ảnh cũ sẽ bị lẫn lộn.
*   **Giải pháp:** Khi phát hiện boss thứ 2 được tạo thành công, app hiển thị một hộp thoại gợi ý nhẹ nhàng: *"Nhà mình có thành viên mới! Bạn có muốn Lucky giúp bạn phân loại lại kho ký ức cũ không? 🐾"*.
*   Nếu đồng ý, một tiến trình chạy ngầm nhỏ trên máy sẽ so sánh vector đặc trưng 1024 chiều của toàn bộ ảnh lịch sử (sử dụng TFLite MobileNetV3 small) với boss mới để tự động cập nhật lại trường `pet_id` chính xác.

---

## 🏛️ 3. Danh Sách Tài Liệu Đặc Tả Trực Thuộc (Specs Index)

Toàn bộ phân hệ được đóng gói nhất quán trong thư mục tính năng [MEMORY_VAULT_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/), bao gồm 8 đặc tả kỹ thuật và nghiệp vụ chi tiết:

| Số Thứ Tự | Tên Tài Liệu Đặc Tả | Phạm Vi Giải Quyết |
| :---: | :--- | :--- |
| **01** | [SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md) | Vật lý vuốt kéo thẻ bài 3D, spring animation, phản hồi rung Haptic. |
| **02** | [SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md) | Bộ lọc ảnh offline cục bộ bằng **Google ML Kit** kết hợp SQLite Caching và tích lũy tối thiểu 15 ảnh chó mèo. |
| **03** | [SPEC_03_MEME_CARD_COMPOSITING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_03_MEME_CARD_COMPOSITING.md) | Cắt ghép mặt Pet vào 15 khung hình meme Ghibli màu nước bằng Canvas, xuất ảnh có logo watermark. |
| **04** | [SPEC_04_FEED_MOMENTS_INTEGRATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_04_FEED_MOMENTS_INTEGRATION.md) | Hàng đợi tải ảnh nền ngầm FIFO, auto-hide banner to ở trang Home sau khi chơi xong. |
| **05** | [SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md) | Giao diện Hộp Ký Ức Polaroid viết tay mộc mạc, hiệu ứng lật thẻ 3D, nút Sửa/Xóa vĩnh viễn ký ức. |
| **06** | [SPEC_06_LEAN_GACHA_MONETIZATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_06_LEAN_GACHA_MONETIZATION.md) | Quảng cáo video nhận thưởng (Rewarded Ads), cửa hàng Pate Coins và Google Sheets CMS Tab 5. |
| **07** | [SPEC_07_CARE_DIARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_07_CARE_DIARY_ENGINE.md) | Nhật ký ghi nhận sự kiện chăm sóc và dấu mốc của Pet. Nhận diện ý định Cozy Chat & Safe-Vet AI. |
| **08** | [SPEC_08_PET_INDIVIDUAL_RECOGNITION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_08_PET_INDIVIDUAL_RECOGNITION.md) | Nhận dạng cá thể Pet bằng TFLite MobileNetV3 small & Cosine Similarity cho người dùng nuôi 2+ boss kết hợp luồng Tái phân loại lịch sử. |

---

*Tài liệu đặc tả đối kháng này đã được cập nhật và sẵn sàng chuyển giao lập trình. Ký tên: Team Cố vấn Capcat (Sophia, Alan, Benny)*
