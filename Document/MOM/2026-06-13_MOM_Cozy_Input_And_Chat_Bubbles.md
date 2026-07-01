# BIÊN BẢN HỌP CHIẾN LƯỢC: HỢP NHẤT Ô NHẬP LIỆU CẢM XÚC LAI & BONG BÓNG CHAT MUJI COZY
*(MINUTES OF MEETING - MOM)*

- **Thời gian diễn ra:** 13:45 - 14:15, ngày 13 tháng 06 năm 2026.
- **Địa điểm:** Workspace Capcat Project.
- **Thành phần tham gia:**
  1.  **Sáng lập viên** (Chủ trì & Quyết định sản phẩm).
  2.  **Sophia** (CPO - Giám đốc Sản phẩm).
  3.  **Alan** (Tech Lead - Kiến trúc sư Kỹ thuật).
  4.  **Leo** (Business & Data Analyst).
  5.  **Arthur** (Behavior & Mom Test Expert - Triệu hồi và phỏng vấn sinh học).
  6.  **Bella** (Lead UI/UX & Animator).
  7.  **Maya** (Principal UI/UX Architect).

---

## I. CÁC QUYẾT ĐỊNH CHIẾN LƯỢC QUAN TRỌNG (THE STRATEGIC DECISIONS)

### 1. Hợp Nhất Ô Nhập Liệu Cảm Xúc Lai (Hybrid Cozy Input Fields)
*   **Quyết định:** Loại bỏ hoàn toàn kiểu ô nhập viền hộp cứng nhắc cũ để triệt tiêu cảm giác điền biểu mẫu công nghiệp. Thay vào đó, áp dụng **Hệ thống Ô nhập lai** phân chia theo 2 bối cảnh:
    *   *Mặc định (Settings, Profile, Chat):* **Muji Soft Block Input** không viền, nền Oatmeal nhạt `#F5F5F0` bo góc `16px`, khi focus tự động chuyển sang màu kem sáng `#FFFDF9` và tỏa bóng mờ mịn, không vẽ viền đen.
    *   *Namiya Mail Draft (Thư tay):* **Vintage Lined Input** không viền hộp, chỉ có dòng kẻ đáy nét mảnh màu `#D2D2CC` chạy song song dưới các dòng văn bản của Sen, giữ nguyên nét hoài cổ.

### 2. Thiết Kế Bong Bóng Chat Muji Cozy (Muji Cozy Chat Bubbles) & Chuyển Đổi Sinh Học
*   **Quyết định:** Chốt phương án thiết kế bong bóng chat phẳng tuyệt đối, loại bỏ hoàn toàn phần đuôi nhọn gây răng cưa rối mắt. Bong bóng chat tự động chuyển đổi theo nhịp sinh học (Bio-Switching):
    *   *Ban ngày (Cozy Light):* Sen hiển thị bằng thẻ giấy kem phẳng `#FDFBF7` viền chỉ nét đứt nâu mộc `#D2D2CC` (Inter). Boss hiển thị không có bong bóng bao quanh, chữ in nghiêng màu xám tro đè trực tiếp lên nền (Space Mono Italic) và chạy hiệu ứng typewriter lách cách.
    *   *Ban đêm (Cozy Dark):* Tự động chuyển đổi sang dạng kính mờ bán trong suốt `rgba(255,255,255,0.04)` (`backdrop-filter: blur(16px)`), viền phát sáng siêu nhẹ màu hồng Sakura (Sen) hoặc Matcha (Boss) ở rìa ngoài với độ mờ 30%.
    *   *Phản hồi xúc giác:* Nhấn giữ tin nhắn kích hoạt nhịp rung nhẹ 1.4s giả lập nhịp thở gừ gừ (purring) của mèo.

### 3. Tích Hợp Thanh Nhập Liệu Chat Tri Kỷ (Muji Chat Input Bar)
*   *Đặc tả:* Thanh nhập liệu dưới đáy chat tự động co giãn chiều cao (`56px` - `120px`), nền yến mạch mờ lọc nhòe. Nút đính kèm `[+]` bên trái, nút gửi đi `[➔]` bên phải. Khi rỗng, nút gửi tự động ẩn đi và chuyển sang biểu tượng micro mờ `[🎤]` để thu tiếng Boss thở.

### 4. Đồng Bộ Thanh Điều Hướng Đáy (Bottom Navigation Dock) & Hộp Thoại (Pop-up Sheets)
*   *Thanh Dock:* Thiết kế phẳng 5 tab cốt lõi (Trang Chủ, Tri Kỷ, Hộp Ký Ức, Góc Thư Giãn, Tôi), nền yến mạch `#FBFBFA`/Obsidian `#0D0D0D`, viền đỉnh `1px`, icon single-line mờ, haptic active.
*   *Hộp thoại:* Phân lớp rõ rệt thành 3 loại: Dialog xác nhận tối giản, Tấm trượt đáy bo góc lớn 24px, và Lá thư phẳng 2D hoài cổ.

---

## II. HỆ THỐNG ĐẶC TẢ CHI TIẾT ĐÃ HOÀN THÀNH (SPECS INDEX)

Tất cả các thay đổi thiết kế trên đã được Maya cập nhật và lưu trữ vào các file spec chính thức:

| Số | Đặc Tả Chi Tiết | Phiên Bản | Phạm Vi Thay Đổi |
| :---: | :--- | :---: | :--- |
| **01** | [08_DESIGN_SYSTEM_FOUNDATION.md](file:///Users/macinia/Capcat%20Project/Document/UI/08_DESIGN_SYSTEM_FOUNDATION.md) | `v1.13.0-Cozy5TabDock` | Bổ sung mục 12.1 (Hybrid Inputs), mục 12.5 (Bottom Dock 5 Tab & Bottom Sheets), mục 12.6 (Cozy Chat Bubbles). |
| **02** | [09_COMPONENT_CATALOG.md](file:///Users/macinia/Capcat%20Project/Document/UI/09_COMPONENT_CATALOG.md) | `v1.15.0-Cozy5TabDock` | Cập nhật mục 2 (Hybrid Input Specs), mục 2.4 (Chat Input Bar), mục 2.5 (Cozy Chat Bubbles), mục 8.10 (Navigation Dock 5 Tab) & 8.11 (Pop-ups & Sheets). |
| **03** | [11_COZY_PAGE_TEMPLATES.md](file:///Users/macinia/Capcat%20Project/Document/UI/11_COZY_PAGE_TEMPLATES.md) | `v1.3.0-CozyHybridInputs` | Đồng bộ hóa Template 6 (Namiya Mail Draft) sang cơ chế Vintage Lined Input. |

---

## III. KẾT QUẢ ĐÁNH GIÁ PHẢN BIỆN (MOM TEST & DOANH THU)

### 1. Phỏng vấn Mom Test đối với Nam (24 tuổi, Dev độc thân - Thực hiện bởi Arthur):
*   *Về giao diện ban đêm:* Thừa nhận Zalo màu xanh chói mắt ban đêm khiến cậu nhức mắt và nhanh tắt app. Rất thích ý tưởng bong bóng kính phát sáng mờ sương và nền tối Obsidian.
*   *Về đuôi bong bóng:* Cảm giác đuôi nhọn nhấp nhô khi cuộn tin nhắn làm rối chữ và phân tâm. Ủng hộ việc cắt bỏ đuôi nhọn để tập trung đọc văn bản phẳng.
*   *Về typewriter lách cách & purring haptic:* Mang lại rung động cảm xúc sâu sắc và sự thấu cảm, kích thích cậu viết thêm tin nhắn.

---

## IV. KẾ HOẠCH HÀNH ĐỘNG TIẾP THEO (ACTION ITEMS)

1.  **Sophia (CPO):** Đóng gói biên bản MOM và cập nhật tài liệu kiểm chứng. **(✅ Hoàn thành)**
2.  **Benny (Senior Frontend Dev):**
    *   Lập trình Custom Widget cho Muji Cozy Chat Bubbles với cơ chế tự động chuyển đổi giao diện Cozy Light (Kem phẳng, thoại Boss không khung) sang Cozy Dark (Kính mờ, viền phát quang Sakura/Matcha).
    *   Tích hợp nhịp rung `purring` chu kỳ 1.4s bằng thư viện `vibration` khi người dùng đè ngón tay vào bong bóng chat của Boss.
    *   Phát triển widget chat input tự động nở rộng và tự động chuyển đổi icon micro/mũi tên gửi đi.

---
*Biên bản được phê chuẩn bởi CPO Sophia cùng Đội ngũ Sáng lập Capcat.*
