# ĐẶC TẢ GIAO DIỆN: SCR-11 — NAMIYA MAILBOX SHEET (THÙNG SỮA TRƯỚC HIÊN NHÀ)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Thay vì hòm thư điện tử công nghiệp, Capcat tái hiện **"Thùng sữa treo trước hiên nhà"** lãng mạn. Là nơi chứa những lá thư tay từ thú cưng ở quá khứ hoặc lời gỡ rối từ tiệm tạp hóa ẩn danh Namiya.
*   **Vibe cảm xúc**: Bất ngờ, hoài cổ, cảm động, ấm áp.
*   **Cơ chế mở hộp thư**: Chạm vào biểu tượng hộp sữa `[🥛]` trên AppBar Trang Chủ. Một tấm sớ thư tay phẳng cổ điển (`Retro Flat Letter Sheet`) sẽ mở ra bằng hoạt ảnh lật nếp giấy 2D tinh tế dưới `0.15s`.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: X]  Thư Gửi Boss       [🔲 Tem]  [Lucide: HelpCircle]| <--- Top Bar (Tem góc phải)
|  =================================================    |
|                                                       |
|  Gửi Boss ở quá khứ / tương lai...                    | <--- Placeholder mờ (Inter Regular 14px #D2D2CC)
|  ___________________________________________________  | <--- Vintage Lined Input (line #D2D2CC)
|  Trăng đêm nay thật đẹp, Boss có đang                 |
|  ngủ ngon không? Sen nhớ Boss nhiều...                | <--- Space Mono Regular 13px #1C1C1E
|  ___________________________________________________  |
|  ___________________________________________________  |
|                                                       |
|  (Cuộn scrollable khi bàn phím lên)                   |
|                                                       |
|  +--------------------------------------------------+ |
|  | [B] [I] [Lucide: List] [Lucide: Quote] [Lucide: Smile] | [Gửi Đi ✉] | | <--- Notion Toolbar
|  | (Bám sát trên bàn phím, H 44px)                  | |
|  +--------------------------------------------------+ |
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Chuyển Động (Interactions & Sheets)

1.  **Hiệu ứng Mở Thư tay (Paper Unfolding Animation)**:
    *   Tấm sớ thư trượt lên từ đáy màn hình kết hợp hiệu ứng giãn nếp gấp 2 chiều (giả lập giấy thư tay mở ra) trong `200ms`.
    *   Màn hình nền phía sau tối đi mờ ảo với lớp overlay phủ đen `rgba(0,0,0,0.5)`. Chạm vào lớp overlay này lập tức đóng thư mượt mà.
2.  **Khung soạn thảo hoài cổ (Vintage Lined Input)**:
    *   Không thiết kế ô nhập hình chữ nhật. Toàn bộ giao diện soạn thảo là các dòng kẻ ngang mảnh màu `#D2D2CC` chạy suốt chiều ngang.
    *   Chữ do người dùng gõ hiển thị dạng phông máy đánh chữ Space Mono, căn thẳng hàng bám sát trên dòng kẻ.
3.  **Nút Hành động khơi mở hội thoại (Interaction CTA)**:
    *   Đáy bức thư nhận được có đính kèm nút: **[🕯️ Trò chuyện về kỷ niệm này]**.
    *   Khi bấm vào, thư đóng lại và chuyển tiếp Sen thẳng vào **SCR-04: Chat Room Screen** của Boss tương ứng, đồng thời nạp bức thư này vào prompt ngữ cảnh của AI để Boss bắt đầu trò chuyện về chủ đề đó.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Nội dung thư tay: `Space Mono Regular 13px` màu đen Obsidian `#1C1C1E`.
    *   Placeholder hướng dẫn: `Inter Regular 14px` màu xám trung tính nhạt `#D2D2CC`.
    *   Tem thư góc phải: Nhãn `Space Mono 10px` in chìm.
*   **Màu sắc**:
    *   Nền sớ thư tay: Màu trắng sữa giấy thô tái chế `#FFFDF9`.
    *   Dòng kẻ ngang: `1px solid #D2D2CC`.
    *   Nút gửi đi: Nền xám đen Obsidian `#121212`, chữ trắng `#FFFFFF`.
*   **Kích thước & Bo góc**:
    *   Tem thư: `36x44px`, bo góc `4px` có răng cưa nhỏ quanh viền.
    *   Thanh Toolbar soạn thảo: Cao `44dp`, bám sát ngay phía trên bàn phím ảo của hệ điều hành.
    *   Bo góc sớ thư: `24px` ở 2 góc trên cùng.
