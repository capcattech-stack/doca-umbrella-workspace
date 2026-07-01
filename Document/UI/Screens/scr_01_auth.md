# ĐẶC TẢ GIAO DIỆN: SCR-01 — AUTH SCREEN (MÀN HÌNH ĐĂNG NHẬP TĨNH LẶNG)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Toàn bộ màn hình chìm vào màn đêm **Cozy Dark Mode (`#0D0D0D`)** để giảm tối đa kích thích thị giác khi người dùng đăng nhập vào buổi tối.
*   **Điểm nhấn mỹ thuật**: Một bức ảnh phác thảo đơn nét động (Lottie Sketch Animation) hình chú mèo hoặc chú chó đang cuộn tròn ngủ và thở chậm rãi (`duration: 4.0s` một chu kỳ). Mang lại cảm giác an yên trước khi bước vào phòng khách.
*   **Cơ chế xác thực**: Đơn giản hóa tối đa bằng Google Sign-In một chạm để bỏ qua các thủ tục điền mật khẩu phiền phức.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|                                                       |
|                                                       |
|                      CAPCAT                          | <--- Inter Bold 32px #FFFFFF
|                   Soul of Pet                        | <--- Space Mono Regular 14px #FCAFAF
|                                                       |
|                    /\_/\   * thở nhẹ *               |
|                   ( o.o )  zZZ                        | <--- Lottie Boss Sketch Animation
|                    > ^ <                              |
|                                                       |
|       "Căn phòng ấm áp của ký ức                     |
|         đang đợi Sen trở về..."                      | <--- Space Mono Italic 14px #8C8C8C
|                                                       |
|         +-----------------------------------+         |
|         |  [Lucide: Chrome] Đăng nhập bằng Google |  | <--- Inter Medium 15px
|         +-----------------------------------+         |     H 56dp, radius 16px
|                                                       |
|              * Chạm để bắt đầu chữa lành             | <--- Inter Regular 12px #5C5C58
|                                                       |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                  ____                                 | <--- Muji Bar active indicator (Home)
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Chuyển Động (Interactions & Animations)

1.  **Hoạt ảnh thở của Boss (Breathing Animation)**:
    *   Boss Sketch co giãn nhẹ nhàng từ `scale: 1.0` sang `scale: 1.03` theo chu kỳ hình sin 4 giây để mô phỏng hơi thở sinh học thực tế.
2.  **Tương tác nút Google SSO**:
    *   **Trạng thái Default**: Nền màu yến mạch nhạt `#F5F5F0`.
    *   **Trạng thái Hover / Active**: Scale down nhẹ xuống `98%` để tạo phản hồi xúc giác vật lý, nền tối nhẹ sang `#EAEAEA`.
    *   **Trạng thái Click**: Gọi Google SSO SDK. Khi đang tải, nút chuyển sang trạng thái Skeleton Loading mờ mịn với Shimmer chạy từ trái qua phải.
3.  **Điều hướng tiếp theo**:
    *   *Người dùng mới*: Chuyển sang **SCR-01b: Pet Onboarding**.
    *   *Người dùng cũ*: Chuyển trực tiếp sang **SCR-02: Home Screen / Dashboard**.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tiêu đề CAPCAT: `Inter Bold 32px`, letter-spacing `0.05em` (Tạo cảm giác hiện đại, vững chãi).
    *   Tagline "Soul of Pet": `Space Mono Regular 14px`, màu `#FCAFAF` (Sakura Pink).
    *   Lời thoại dẫn dắt: `Space Mono Italic 14px`, màu `#8C8C8C` (Xám ấm nhạt).
    *   Nhãn nút Google: `Inter Medium 15px`, màu `#1C1C1E` (Obsidian tối).
*   **Màu sắc**:
    *   Nền toàn màn hình: `#0D0D0D` (Deep Obsidian).
    *   Nền nút Google: `#F5F5F0` (Oatmeal nhạt).
*   **Kích thước & Bo góc**:
    *   Chiều cao nút Google: `56dp` (Tap target lớn dễ bấm).
    *   Bo góc nút Google: `16px` (`Radius.cozyCard`).
    *   Icon Chrome/Google: `24x24px`, đặt cách lề trái nút `16px`.
*   **Accessibility (A11y)**:
    *   Đảm bảo nút Google có thuộc tính `semanticsLabel="Đăng nhập bằng tài khoản Google"`.
