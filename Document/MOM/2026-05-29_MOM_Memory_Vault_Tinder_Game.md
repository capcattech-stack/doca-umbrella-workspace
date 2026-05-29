# BIÊN BẢN HỌP CHIẾN LƯỢC: PHÂN HỆ HỘP KÝ ỨC & TRÒ CHƠI SWIPE DOPAMINE
*(MINUTES OF MEETING - EPIC 3: FE-MEMORY-VAULT)*

> **Mã Tài Liệu:** `MOM-2026-05-29-MEMORY-VAULT`  
> **Thời gian:** 2026-05-29T23:40:00+07:00  
> **Địa điểm:** Văn phòng Cố Vấn Ảo Capcat (Workspace Cổ điển)  
> **Chủ trì:** Sophia (CPO / PM)  
> **Thư ký:** Arthur (Mom Test Specialist)  
> **Thành viên tham dự:** Sáng lập viên (User), Alan (Tech Lead), Leo (Financial Analyst), Bella (Lead UI/UX & Animator)

---

## 🧭 I. CÁC QUYẾT ĐỊNH CHIẾN LƯỢC QUAN TRỌNG (STRATEGIC DECISIONS)

1.  **Nghi thức Vuốt Lên (Swipe Up Golden Memory):** 
    *   Thống nhất nâng cấp cử chỉ Vuốt Lên thành một nghi thức 4 bước chữa lành trọn vẹn: Khựng thẻ lơ lửng -> Bùng nổ pháo hoa vàng & Thả tim phát sáng -> Bảng viết bình luận thô ráp có 3 câu gợi ý AI -> **Dập dấu sáp đỏ chân mèo cổ điển** phát âm thanh chân thực (`stamp_press.mp3`) và Intimacy +15.
2.  **Động cơ Quét Lùi Thưa Thớt Ngẫu Nhiên (Randomized Sparse Scan):**
    *   Để triệt tiêu hao pin và tránh đơ máy của model ML Kit cục bộ, bộ quét chia lịch sử 2 năm thành 24 giỏ tháng. Mỗi tháng bốc ngẫu nhiên đúng 1-2 bức ảnh để chạy AI phân loại.
    *   Dừng quét lập tức khi bộ bài Tinder Stack gom đủ 10-15 ảnh Pet dìm hợp lệ.
    *   Lưu toàn bộ ảnh hiển thị vào bảng SQLite `processed_photos_cache` làm bộ đệm Blacklist loại trừ vĩnh viễn, ngăn chặn 100% hiện tượng trùng lặp gây chán nản.
3.  **Tách Biệt Meme Chibi Hài Hước Để Giữ Sự Thiêng Liêng:**
    *   Báo cáo thực chứng Mom Test của Arthur chỉ ra: Hộp ký ức ngập tràn meme chibi châm biếm sẽ làm loãng và mất đi sự thiêng liêng, thơ mộng của tình tri kỷ.
    *   Thống nhất: Polaroid hiển thị chính diện trong Hộp Ký Ức bắt buộc giữ nguyên bản 100% (Pure Postcards). Ghép Meme Chibi 0đ chỉ là một **Tác vụ Mở rộng Tự nguyện** ẩn ở mặt sau thẻ. Ảnh meme xuất ra được lưu riêng để chia sẻ viral bên ngoài mà không ô nhiễm album gốc chữa lành.
4.  **Cảm Quan Chữa Lành Iyashikei Nhật Bản:**
    *   Thiết kế bảng màu thô beige tự nhiên (`#F9F6F0`), phông chữ viết tay mảnh dẻ, màu chữ xám than củi ấm áp (`#3C3C3C`).
    *   Tích hợp cảm biến **Con quay hồi chuyển (Gyroscope)** để điều khiển bụi nắng mờ lơ lửng bay xiên 3D theo góc nghiêng điện thoại. Tích hợp 3 loại âm thanh cơ học thô ráp.
    *   Thiết kế ngăn kéo sớ giấy da **[Minh Bạch Dữ Liệu 🔒]** giải trình minh bạch dữ liệu cục bộ vs điện toán đám mây. Cung cấp hai nút bấm đặc quyền: **[Tải Sao Lưu .zip]** (album xem offline trên PC) và **[Quên Đi Vĩnh Viễn]** (purging sạch dữ liệu) để bảo vệ quyền tối cao của chủ nuôi.
5.  **Mô Hình Doanh Thu Nhân Văn (Premium Coexistence):**
    *   Leo phản đối kịch liệt việc tống tiền cảm xúc. Hộp ký ức cốt lõi là MIỄN PHÍ TRỌN ĐỜI.
    *   Kích hoạt 3 kênh kiếm tiền tinh tế:
        *   **Dịch vụ in ảnh Polaroid thật giao tận nhà (Instax Delivery):** Đóng gói trong bao thư kraft thô, đóng dấu sáp mèo đỏ và ship tận tay Sen với giá 19.000đ - 29.000đ/ảnh. Biên lợi nhuận ròng siêu lớn đạt **50-60%**.
        *   **Visual Skins Băng Keo Washi & Gói Âm Thanh Lofi:** Giá 9.000đ - 15.000đ / bộ.
        *   **Rewarded Ads:** Xem video quảng cáo 30s để nạp thêm 5 lượt quét khi dùng hết 15 lượt miễn phí trong tuần.

---

## 📂 II. HỆ THỐNG ĐẶC TẢ CHI TIẾT ĐÃ CẬP NHẬT (SPECS INDEX)

Toàn bộ 5 tệp tin đặc tả trực thuộc thư mục [Document/PRD/MEMORY_VAULT_ENGINE/](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/) đã được đồng bộ hóa hoàn hảo với các quyết định họp:

| Mã Đặc Tả | Tên Tài Liệu Đặc Tả | Phạm Vi Điều Chỉnh | Trạng Thái |
| :---: | :--- | :--- | :---: |
| **SPEC-VAULT-01** | [SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md) | Bổ sung nghi thức thả tim, ô bình luận viết tay thô ráp, và dập dấu sáp đỏ mèo chân thật (`stamp_press.mp3`) khi Vuốt Lên. | **HOÀN THÀNH ✅** |
| **SPEC-VAULT-02** | [SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md) | Thêm phân tích tải CPU của ML Kit, tích hợp giải thuật Quét lùi thưa ngẫu nhiên theo giỏ tháng, dừng cực sớm, và cơ chế Blacklist SQLite cache chống trùng. | **HOÀN THÀNH ✅** |
| **SPEC-VAULT-03** | [SPEC_03_MEME_CARD_COMPOSITING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_03_MEME_CARD_COMPOSITING.md) | Ghi nhận báo cáo Mom Test của Arthur, khóa meme thành tác vụ mở rộng phụ trợ độc lập, bảo tồn tính thiêng liêng của album gốc. | **HOÀN THÀNH ✅** |
| **SPEC-VAULT-05** | [SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md) | Thiết kế tone màu củi than `#3C3C3C`, hạt nắng 3D cảm ứng Gyroscope, soundpack sột soạt lật trang lướt thẻ, và ngăn kéo sớ giấy da Minh Bạch Dữ Liệu (Sao lưu zip & purges vĩnh viễn). | **HOÀN THÀNH ✅** |
| **SPEC-VAULT-06** | [SPEC_06_LEAN_GACHA_MONETIZATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_06_LEAN_GACHA_MONETIZATION.md) | Xóa bỏ hoàn toàn cơ chế khóa bắt nạp tiền xem ký ức. Tích hợp IAP bán gói dán băng keo Washi, dịch vụ in ảnh Instax giao tận nhà siêu hời (19k-29k), và Rewarded video ads. | **HOÀN THÀNH ✅** |

---

## 🛠️ III. KẾ HOẠCH HÀNH ĐỘNG TIẾP THEO (ACTION ITEMS)

| Đầu Việc | Phân Vai Chịu Trách Nhiệm | Trạng Thái |
| :--- | :--- | :---: |
| Tích hợp cơ sở dữ liệu SQLite: Thiết lập các bảng `processed_photos_cache` và `local_virtual_memes`. | Tech Lead **Alan** | ⏳ Chờ Code |
| Xây dựng lõi nhận diện ảnh ngầm `RetrogressiveScanner` bằng Google ML Kit cục bộ tích hợp bốc ngẫu nhiên theo tháng. | Tech Lead **Alan** | ⏳ Chờ Code |
| Thiết kế Canvas RepaintBoundary ghép mặt pet lên 15 chibi templates vẽ tay pastel và kết xuất PNG 3x có watermark. | UI/UX **Benny** & **Bella** | ⏳ Chờ Code |
| Thiết kế UI lật thẻ 3D lãng mạn, con quay hồi chuyển hạt bụi lơ lửng, ngăn kéo sớ giấy da Minh Bạch dữ liệu và bộ sột soạt soundpack. | Animator **Bella** & Tech **Alan** | ⏳ Chờ Code |
| Thiết lập mô hình in nhiệt Instax liên kết đơn vị giao vận cục bộ và cấu trúc thanh toán in ảnh Polaroid thật. | Finance **Leo** & CPO **Sophia** | ⏳ Chờ Code |

---
*Biên bản họp được ký số và đóng dấu lưu trữ cục bộ. Mọi thay đổi tiếp theo cần được thông qua Ban giám đốc dự án Capcat.*  
*Xem thêm nhật ký thảo luận chi tiết của phiên họp tại: [CHAT_HISTORY_29052026.md](file:///Users/macinia/Capcat%20Project/Document/CHAT_HISTORY_29052026.md#lượt-15-chi-tiết-trao-doi)*
