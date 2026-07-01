# ĐẶC TẢ GIAO DIỆN: SCR-02 — HOME SCREEN / DASHBOARD (TRANG CHỦ NHẬT KÝ & WIDGET TIỆM CẬN)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Thiết kế giao diện phẳng tối giản MUJI kết hợp các mảng màu nước pastel hữu cơ chạy ẩn phía sau nền. Giao diện được sắp xếp theo dạng cột đứng (Vertical Stack) cân bằng, tập trung tiêu điểm vào kỷ niệm của Boss.
*   **Các phân hệ hiển thị chính**: 
    1.  **DOCA PetTwin (Chân dung & Avatar Pet):** Hiển thị tên, biệt danh, tuổi của Boss và avatar bo tròn có viền Matcha. (Các thanh chỉ số sinh học dời sang Phase 2).
    2.  **DOCA Whispers (Thì thầm gợi mở):** Bong bóng thoại suy tư hoặc câu hỏi của Boss kèm nút chạm chuyển nhanh vào phòng chat.
    3.  **DOCA Capsule (Rương Ký Ức Polaroid):** Khung ảnh Polaroid lớn ở trung tâm hiển thị khoảnh khắc đáng yêu mới nhất của Boss. Chạm vào mở màn hình Dòng thời gian.
*   **Menu tương tác hằng ngày (Tamagotchi Action - [HOÃN SANG PHASE 2]):** Lớp phủ các nút cho ăn, đi dạo, tắm rửa được hoãn hoàn toàn để giữ màn hình chính phẳng phiêu cực hạn.

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  Bình Dương, 24°C ⛈️                [ ✉ ]   (UserAvatar)| <--- Row 1: Weather, Mailbox & User Profile
|                                                       |
|  (🐶) Latte, 3y 🞽                      /-------\      | <--- Row 2: Dropdown Selector &
|                                        |  (O)  |      |      Pet Avatar with Green Ring
|                                        \-------/      |
|                                                       |
|  +-------------------------------------------------+  |
|  |  💬 Hôm nay ông về trễ quá vậy? 🐾               |  | <--- DOCA Whispers (Speech Bubble)
|  |  +-------------------------------------------+  |  |
|  |  | ✍️ Chạm để trả lời bé                      |  |  | <--- Quick reply action button
|  |  +-------------------------------------------+  |  |
|  |  *DOCA Whispers                                  |  |
|  +-------------------------------------------------+  |
|                                                       |
|  +-------------------------------------------------+  |
|  |  +-------------------------------------------+  |  | <--- DOCA Capsule (Central Polaroid Card)
|  |  |                                           |  |  |
|  |  |               ẢNH PET THẬT                |  |  |
|  |  |                                           |  |  |
|  |  +-------------------------------------------+  |  |
|  |  3 ngày, 2 giờ...                            |  |  |
|  |  Trẫm đã đi dạo xong rồi Sen ơi! Đói...      |  |  |
|  |  ------------------------------------------  |  |  |
|  |  12/06/2025 - 08:32                          |  |  |
|  |  *DOCA Capsule                               |  |  |
|  +-------------------------------------------------+  |
+-------------------------------------------------------+
|   __                                                  |
|  [📺]                 [💬]                 [⚃]         | <--- 3-Tab Bottom Dock (Home, Chat, Menu)
+-------------------------------------------------------+
```

---

## 📐 3. Đặc Tả Chi Tiết Các Widget (Figma Specs)

### 3.1. Hàng thông tin đầu trang (Top Info & Avatar)
*   **Weather & Mail Row**: Horizontal Auto Layout.
*   **Pet Select Row**: Horizontal Auto Layout.
    *   *Trái*: Dropdown chọn Pet (`Latte, 3y` + Chevron Down). Font: `Inter Bold 18px`.
    *   *Phải*: Avatar của Boss (`64x64px`, bo tròn hoàn toàn) có viền tròn màu xanh Matcha (`2px solid #8FA882`) bao quanh.

### 3.2. Widget: **DOCA PetTwin** (Chỉ số sinh học - [HOÃN SANG PHASE 2])
*   Toàn bộ vạch chỉ số *Dinh dưỡng, Vận động, Hạnh phúc* và logic suy giảm tự động được dời sang Phase 2. Giao diện trang chủ MVP sẽ không hiển thị thanh chỉ số để đảm bảo tính tối giản tối đa.

### 3.3. Widget: **DOCA Whispers** (Thought Bubble & Quick Action)
*   **Thiết kế**: Bong bóng thoại nằm ngang bo góc mềm mại (`16px`), nền màu xanh Matcha nhạt (`#E8F5E9`).
*   **Nội dung**: 
    *   Lời thoại của Boss: `💬 Hôm nay ông về trễ quá vậy? 🐾` (Inter Medium, 12px, màu tối).
    *   **Nút "Chạm để trả lời bé"**: Nằm bên trong bong bóng thoại. Thiết kế capsule bo góc, màu nền Matcha nhạt hơn (`#F1F8F5`). Chứa icon bút chì vẽ tay nhỏ và text.
*   **UX**: Khi người dùng nhấn vào nút này, ứng dụng sẽ chuyển hướng mượt mà sang màn hình Chat riêng biệt (`Chat Screen`), trong đó câu hỏi này xuất hiện như tin nhắn incoming cuối cùng của Boss để người dùng gõ trả lời.

### 3.4. Widget: **DOCA Capsule** (Central Polaroid Memory Card - Dynamic Spotlight)
*   **Vị trí**: Nằm ở trung tâm màn hình Home.
*   **Nền (Fill)**: `#FFFFFF` (Trắng giấy), bo góc `16px`, viền `1px solid #EAEAEA`, shadow loãng `rgba(0,0,0,0.02) blur 12px`.
*   **Thành phần con**:
    *   `Photo`: Tỷ lệ `1:1` hoặc `4:3` (vuông), Clip content. **Hiển thị hình ảnh thay đổi linh hoạt theo từng thời điểm (Dynamic Spotlight):**
        - *Sáng sớm (06:00 - 09:00):* Ưu tiên hiển thị các bức ảnh đi dạo ngoài trời hoặc ảnh ngủ dậy ngái ngủ của Boss.
        - *Chiều tối (17:00 - 20:00):* Hiển thị ảnh ăn tối hoặc ảnh chạy giỡn đùa nghịch hóm hỉnh.
        - *Đêm muộn (22:00 - 02:00):* Hiển thị ảnh Boss ngủ cuộn tròn sưởi ấm tâm hồn.
        - *Thời điểm khác:* Random ngẫu nhiên một kỷ niệm cũ bất kỳ trong SQLite để nhắc nhớ kỷ niệm, tối đa không lặp lại ảnh cũ quá 2 lần/ngày.
    *   `Title`: Tiêu đề tự động (Ví dụ: `Nhớ hồi đó ghê ba...` hoặc quy đổi thời gian `25 ngày trước...`, Space Mono Bold, 12px, `#1C1C1E`).
    *   `Content`: Lời thoại AI thấu cảm hoặc câu khía của Boss viết kèm ảnh (Inter Regular, 10px, màu tối).
    *   `Divider`: Nét đứt `1px dashed #D2D2CC`.
    *   `Date`: Ngày diễn ra sự kiện gốc (Space Mono Regular, 9px, `#8C8C8C`).
    *   Chữ ghi chú nhỏ ở góc dưới trái: `*DOCA Capsule`.
*   **UX**: Chạm trực tiếp vào thẻ Polaroid này sẽ dẫn người dùng mở màn hình dòng thời gian đầy đủ của Rương ký ức (`DOCA Capsule Screen`).

### 3.5. Nút nổi tương tác "Hey yo! Tamagotchi" ([HOÃN SANG PHASE 2])
*   Nút nổi (FAB) Obsidian và menu lớp phủ Care Action Overlay Menu (cho ăn, đi dạo, tắm rửa) được hoãn hoàn toàn sang Phase 2.

### 3.6. Dock điều hướng đáy (Bottom Navigation Bar)
*   **Đồng bộ với Figma Layout**: Thanh ngang mỏng H `56px`, nền `#FBFBFA`. 
*   **Rút gọn 3 Tab**:
    1.  Tab 1 (Active): Home `[📺]` (Có đường kẻ mảnh `MujiBar` phía trên biểu tượng).
    2.  Tab 2: Chat tri kỷ `[💬]`.
    3.  Tab 3: DOCA Corner & Sổ tay `[⚃]` (Góc cảm xúc trưng bày đĩa nhạc, sách cũ, card bo góc, kết hợp tab Sổ tay của mẹ).
