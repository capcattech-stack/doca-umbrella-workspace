# ĐẶC TẢ GIAO DIỆN: SCR-01B — PET ONBOARDING (QUY TRÌNH THIẾT LẬP LINH HỒN BOSS)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Loại bỏ sự tẻ nhạt của các biểu mẫu khai báo thông tin. Onboarding của Capcat là một **hành trình trò chuyện ấm áp** để kiến tạo nên linh hồn ảo của Boss.
*   **Vibe cảm xúc**: Gần gũi, hoài cổ, thú vị.
*   **Cấu trúc quy trình**: Chia làm 3 bước chính rõ ràng, mỗi bước chỉ tập trung vào một câu hỏi duy nhất để tránh gây ngợp cho Sen.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout - Bước 2/3)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: X Bỏ qua]                  [ 02 / 03 Bước ] |
|-------------------------------------------------------|
|                                                       |
|         THẦN THÁI & NHÂN CÁCH AI CỦA BOSS             | <--- Inter Bold 18px
|                                                       |
|  +---------------------------------------------------+|
|  |  Nhân cách chủ đạo của Boss là gì?               ||
|  |                                                   ||
|  |  [ ] Chảnh chọe (Mèo Quý Tộc)                   || <--- Radio Options (Inter Regular 14px)
|  |  [x] Ngáo ngơ (Ngọc Hoàng thất sủng)            ||
|  |  [ ] Nịnh nọt (Chuyên viên gác đùi)             ||
|  |  [ ] Đanh đá (Thanh tra khu phố)                 ||
|  +---------------------------------------------------+|
|                                                       |
|  { Giống loài... [Lucide: Search] }                   | <--- Muji Soft Block Input (radius 16px)
|                                                       |
|  { Cân nặng hiện tại: 5.2 kg }                        | <--- Muji Soft Block Input (radius 16px)
|                                                       |
|            +-----------------------+                  |
|            |   Kế Tiếp [Lucide: ArrowRight]  |        | <--- Primary Button H 56dp #121212
|            +-----------------------+                  |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Chi Tiết Các Bước (Step-by-step Flow)

1.  **Bước 1: Nhận dạng sinh học (Identity)**:
    *   Sen điền Tên Boss, chọn Loài (Chó/Mèo) và chọn Giống loài từ danh mục kéo thả mượt.
2.  **Bước 2: Cấu hình Nhân cách AI (Persona Setup)**:
    *   **Ngáo ngơ**: Cách nói chuyện ngây ngô, hay hỏi những câu ngớ ngẩn.
    *   **Chảnh chọe**: Xưng hô "Trẫm" và "Sen", giọng điệu kiêu kỳ, khó chiều.
    *   **Nịnh nọt**: Suốt ngày đòi vuốt ve, khen ngợi Sen hết lời.
    *   **Đanh đá**: Hay khịa Sen, thích phán xét mọi hành vi của Sen.
    *   *Tương tác*: Khi chọn một nhân cách, điện thoại sẽ phát một nhịp rung nhẹ mô phỏng cảm xúc đó (ví dụ: Chảnh chọe = 1 nhịp dứt khoát, Nịnh nọt = rung nhẹ kéo dài).
3.  **Bước 3: Tải ảnh đại diện (Profile Picture)**:
    *   Sen tải lên bức ảnh đầu tiên của Boss. Hệ thống tự động cắt khung tròn và trích xuất tone màu chủ đạo của bức ảnh để làm màu nền cho phòng chat sau này.
4.  **Tương tác Input Fields**:
    *   Muji Soft Block Input: Bình thường nền `#F5F5F0` không viền. Khi focus, viền đen mảnh `#1C1C1E`. Khi nhập lỗi, viền hồng `#FCAFAF` kèm thông báo lỗi nhỏ phía dưới.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tiêu đề bước: `Inter Bold 18px` màu `#1C1C1E`.
    *   Lựa chọn nhân cách: `Inter Regular 14px` màu `#1C1C1E`.
    *   Chữ trong ô nhập: `Inter Medium 13px`.
*   **Màu sắc**:
    *   Nền toàn màn hình: `#FBFBFA` (Cozy Light oatmeal).
    *   Nền ô nhập liệu: `#F5F5F0` (Muji Soft Block).
    *   Nút Kế tiếp: Nền `#121212` (Charcoal Black), chữ `#FFFFFF`.
*   **Kích thước & Bo góc**:
    *   Ô nhập liệu: Cao `56dp`, bo góc `16px`.
    *   Nút Kế tiếp: Cao `56dp`, bo góc `12px`, chiều rộng tự co giãn hoặc full width `312px` tùy độ rộng màn hình.
    *   Thanh tiến trình (Stepping bar): Nằm sát dưới AppBar, dày `2px`, màu xanh Matcha `#8FA882` cho phần đã hoàn thành, màu xám `#EAEAEA` cho phần còn lại.
