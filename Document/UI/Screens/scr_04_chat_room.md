# ĐẶC TẢ GIAO DIỆN: SCR-04 — CHAT ROOM SCREEN (PHÒNG CHAT TRI KỶ AI)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Phòng trò chuyện là nơi tĩnh lặng nhất, giúp Sen cảm nhận rõ rệt sự hiện diện của linh hồn Boss.
*   **Vibe cảm xúc**: Gần gũi, hoài cổ, độc bản, tĩnh lặng.
*   **Hiệu ứng Thích ứng Thời tiết (Watercolor Weather Overlay)**: Nền phòng chat tự động đổ màu nước loãng theo thời tiết thực tế tại vị trí của Sen (ví dụ: ngày nắng ấm có sắc cam nhạt, ngày mưa giông chuyển xám xanh nhạt).
    *   *Ban ngày*: Nền yến mạch `#FBFBFA` làm gốc.
    *   *Ban đêm (22:00 - 05:00)*: Nền chìm vào Obsidian `#0D0D0D`.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout - Ban Ngày)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: ArrowLeft]  (O) Mèo Bánh Mỳ  [Lucide: HeartPulse] [Lucide: Camera]| <--- Top App Bar
|  (Nhấn Avatar -> Bottom Sheet Hồ sơ Pet / Safe-Vet)    |
|  =================================================    | <--- Watercolor weather overlay
|   [ 15:30 ]                                           |
|                                                       |
|         🐾 Sen ơi, trẫm đói rồi!                      | <--- Boss Bubble (Trái)
|         Cơm cá mòi hôm nay đâu?                       |      Không có khung (ban ngày)
|                                                       |      Space Mono Italic 13px, #1C1C1E
|                                                       |
|                   +---------------------------+       |
|                   | Đợi tí, đang gõ nốt mấy  |       | <--- Sen Bubble (Phải)
|                   | dòng code rồi cho ăn nhé. |       |      Nền #FDFBF7, viền 1px dashed #D2D2CC
|                   +---------------------------+       |      Inter Regular 13px, #1C1C1E
|                                                       |
|         🐾 Lại code... Suốt ngày gõ                   | <--- Boss Bubble (Trái) — kiểu typewriter
|         cạch cạch rồi bỏ bê trẫm!                     |            
|                                                       |
|  +--------------------------------------------------+ |
|  | [Lucide: Plus] Viết gì đó với Boss...   [Lucide: Send]| | <--- Muji Chat Input Bar
|  | (Nền #FBFBFA mờ 95%, H 56-120px tự giãn)          | |      radius 16px, blur backdrop
|  +--------------------------------------------------+ |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                  ____                                 | <--- Muji Bar under "MessageSquare"
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Hiệu Ứng (Interactions & Effects)

1.  **Hiệu ứng bong bóng của Boss (Typewriter Text Animation)**:
    *   Lời thoại của Boss chạy từng chữ chậm rãi kèm tiếng gõ máy chữ lofi cực kỳ nhỏ. Bắt đầu bằng icon bàn chân nhỏ `🐾`.
2.  **Chuyển đổi trạng thái Nút Gửi (Smart Input Bar)**:
    *   Khi ô nhập liệu rỗng: Nút gửi hiển thị biểu tượng Micro `[🎤]` mờ nhạt để ghi âm giọng nói.
    *   Khi Sen gõ ký tự đầu tiên: Micro chuyển mượt mà (`duration: 150ms`) sang nút Gửi mũi tên `[➔]` màu đen nổi bật trên nền hồng anh đào `#FCAFAF`.
3.  **Vuốt chạm (Gestures)**:
    *   **Nhấn giữ tin nhắn Boss (Long Press)**: Scale down nhẹ câu thoại `2%` và rung haptic chu kỳ hơi thở `1.4s` (Purring Haptic).
    *   **Chạm Avatar AppBar**: Trượt mở Bottom Sheet hiển thị hồ sơ chi tiết của Boss (bao gồm thông số sinh học, tính cách, và phân hệ sức khỏe Safe-Vet tích hợp).
    *   **Chạm icon Safe-Vet (HeartPulse) trên AppBar**: Chuyển tiếp nhanh hai chiều sang màn hình **SCR-12: Safe-Vet Emergency Screen** (và có nút quay lại phòng chat).
    *   **Chạm icon Camera góc phải AppBar**: Dẫn thẳng tới **SCR-05: Memory Feed** đã lọc sẵn riêng cho Boss này.
4.  **Bong bóng chat Cozy Dark Mode (Ban đêm)**:
    *   Cả hai bên đều dùng nền kính mờ `rgba(255, 255, 255, 0.04)` và làm nhòe nền `backdrop-filter: blur(16px)`.
    *   Đường viền mảnh phát sáng: Bên Sen màu hồng mờ `rgba(252, 175, 175, 0.3)`. Bên Boss màu xanh mờ `rgba(143, 168, 130, 0.3)`.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Lời thoại Boss: `Space Mono Italic 13px` màu `#1C1C1E` (Light) hoặc `rgba(255,255,255,0.95)` (Dark).
    *   Lời thoại Sen: `Inter Regular 13px` màu `#1C1C1E` (Light) hoặc `rgba(255,255,255,0.95)` (Dark).
*   **Màu sắc**:
    *   Bong bóng Sen (Sáng): Nền `#FDFBF7`, viền nét đứt `1px dashed #D2D2CC`.
    *   Thanh nhập liệu wrapper: Nền yến mạch mờ `rgba(251, 251, 250, 0.95)` kết hợp `backdrop-filter: blur(10px)`.
*   **Kích thước & Bo góc**:
    *   Avatar AppBar: `36x36px`, bo góc `8px`.
    *   Bong bóng chat: Bo góc đều `12px` (Không có đuôi nhọn).
    *   Khung gõ chữ: Bo góc tròn thuốc nhộng `20px`.
