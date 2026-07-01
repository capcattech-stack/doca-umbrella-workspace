# ĐẶC TẢ GIAO DIỆN: SCR-03 — CHAT LIST SCREEN (DANH SÁCH CUỘC TRÒ CHUYỆN)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Bối cảnh sử dụng**: Chỉ hiển thị khi người dùng nuôi **từ 2 thú cưng trở lên**. Nếu chỉ nuôi 1 Pet, hệ thống định tuyến (Riverpod Router) sẽ bỏ qua màn hình này và dẫn thẳng vào **SCR-04: Chat Room Screen**.
*   **Vibe cảm xúc**: Ngăn nắp, trật tự, tinh tế như danh bạ sổ tay gỗ.
*   **Triết lý thiết kế**: Thiết kế phẳng dẹt hoàn toàn. Sử dụng nét vẽ mảnh phân rã không tạo khung card cồng kềnh, giảm bớt áp lực thị giác.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: ArrowLeft] Hộp Trò Chuyện   [Lucide: Search] |
|  =================================================    |
|                                                       |
|  ĐÀN BOSS TRONG NHÀ                                   | <--- Nhóm Label (Inter Medium 11px #8C8C8C)
|  ___________________________________________________  |
|  (O) Bánh Mỳ                           14:32   ●     | <--- Chat Row (H 72px)
|      "Sen ơi, mua pate cho trẫm..."               |      Avatar 40px, radius 8px
|  ___________________________________________________  |      ● = Cherry Blossom Dot #FCAFAF 6px
|  (O) Lucky                             12:15         |      Tên: Inter SemiBold 14px #1C1C1E
|      "Gâu! Sen về chưa?"                         |      Tin nhắn cuối: Inter Regular 13px #8C8C8C
|  ___________________________________________________  |      Time: Space Mono Regular 11px #8C8C8C
|                                                       |
|  BẠN BÈ GHÉ THĂM & HÀNG XÓM                          |
|  ___________________________________________________  |
|  (O) Mèo Mướp Hàng Xóm                Hôm qua       |
|      "Trộm được cá kho nhà Sen nè!"               |
|  ___________________________________________________  |
|  (O) Ông Lão Namiya                    06.11         |
|      "Thư hồi âm đã sẵn sàng..."                 |
|  ___________________________________________________  |
|                                                       |
|  [Vuốt trái 1 row -> Hiện nút [Ký ức 📸] màu Matcha] |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                  ____                                 | <--- Muji Bar under "MessageSquare"
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Cử Chỉ (Gestures & Interaction Flow)

1.  **Chạm chọn hàng (Row Tap)**:
    *   Chạm vào một dòng Pet bất kỳ sẽ điều hướng mượt sang **SCR-04: Chat Room Screen** của Pet đó.
    *   *Trường hợp đặc biệt*: Chạm vào dòng **Ông Lão Namiya** sẽ mở trực tiếp popup sớ thư **SCR-11: Namiya Mailbox Sheet** thay vì vào chat thread của Pet.
    *   Nếu dòng đó có chấm đỏ chưa đọc, chấm đó sẽ mờ dần và biến mất, đánh dấu đã đọc.
2.  **Vuốt trái mở nhanh (Swipe Left for Quick Gallery)**:
    *   Sen vuốt dòng Pet sang bên trái (Swipe Left) sẽ lộ ra một nút hành động màu xanh Matcha: **[Ký ức 📸]**.
    *   Chạm nút này mở thẳng màn hình **SCR-05: Memory Feed** đã được bộ lọc tự động lọc sẵn ảnh của chú Pet đó.
3.  **Haptic Feedback**:
    *   Khi vuốt sang trái đạt tới ngưỡng kích hoạt nút (Threshold 60dp): phát ra nhịp rung nhẹ `selectionClick`.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tên Boss/NPC: `Inter SemiBold 14px` màu `#1C1C1E`.
    *   Tin nhắn cuối: `Inter Regular 13px` màu xám `#8C8C8C` (Tự động cắt chuỗi nếu vượt quá 1 dòng).
    *   Thời gian gửi: `Space Mono Regular 11px` màu `#8C8C8C`.
    *   Nhãn nhóm: `Inter Medium 11px` màu `#8C8C8C` (viết hoa).
*   **Màu sắc**:
    *   Nền: `#FBFBFA` (Màu yến mạch giấy tái chế).
    *   Đường phân cách: `1px solid #EAEAEA`.
    *   Chấm tin chưa đọc (Cherry Dot): `#FCAFAF` (Sakura Pink), kích thước đường kính `6px`.
    *   Nút vuốt trái: Nền xanh Matcha `#8FA882`, icon hoặc chữ trắng `#FFFFFF`.
*   **Kích thước & Bo góc**:
    *   Chiều cao dòng chat row: `72dp`.
    *   Avatar Pet: `40x40px`, bo góc `8px` (`Radius.cozyAvatar`).
    *   Bottom Navigation Dock H: `56dp`, active indicator bar `16x2px` trượt nằm sát dưới icon MessageSquare.
