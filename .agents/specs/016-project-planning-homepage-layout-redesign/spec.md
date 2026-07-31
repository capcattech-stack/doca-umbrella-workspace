# Feature Specification: Project Planning - Homepage Layout Redesign

> Feature ID: `016-project-planning-homepage-layout-redesign`
> Created: `2026-07-31`
> Status: Draft
> Source Prompt: triển khai thay đổi giao diện theo chỉ đạo của /maya-ui-ux-designer /design/open-design

## 1. Purpose

Tái cấu trúc giao diện trang chủ website `doca.capcat.vn` (mã nguồn `doca-affiliate-web`) theo chỉ đạo của Maya UX Designer và bộ nguyên tắc thiết kế Muji Minimalist, tối ưu hóa trải nghiệm người dùng (Mobile-first) và gia tăng tỷ lệ chuyển đổi tiếp thị liên kết (Affiliate Monetization).

## 2. User Stories

*   **US-006 (Luồng trải nghiệm chữa lành mượt mà):** Là một Sen (người dùng), tôi muốn xem Nhật ký lối sống (Blog) ngay sau khi thư giãn với trình phát nhạc để đọc các câu chuyện chia sẻ nuôi pet chánh niệm một cách liền mạch.
*   **US-007 (Trực quan hóa giỏ hàng theo Boss):** Là một Sen, tôi muốn xem các sản phẩm trên Kệ quà được phân loại rõ ràng theo các Boss (Tina, Latte, Muối, Pi's) để nhanh chóng chọn lựa đồ ăn, sách hay phụ kiện phù hợp cho Boss nhà mình.
*   **US-008 (Tâm sự ẩn danh dễ dàng):** Là một Sen, tôi muốn gửi tâm sự đến Hòm thư Namiya thông qua một thiết kế mộc mạc và luồng mở form nhẹ nhàng để không có cảm giác bị thúc ép điền thông tin.
*   **US-009 (Điền nhanh thông tin):** Là một Sen, tôi muốn có cơ chế điền nhanh email khi gửi thư Namiya bằng Google SSO để giảm tối đa số lần gõ phím trên điện thoại.
*   **US-010 (Kêu gọi mở sạp đúng thời điểm):** Là một Sen, tôi muốn có cơ hội tạo một sạp Kiosk riêng của mình từ một banner kêu gọi đặt ở chân trang sau khi tôi đã có trải nghiệm tuyệt vời với các tính năng của website.

## 3. Functional Requirements

*   **`FR-023` (Tái sắp xếp vị trí trang chủ)**: Sắp xếp lại thứ tự các phần từ trên xuống dưới:
    1. Hero Section + Weather intro + DOCA FM Player
    2. Nhật ký lối sống (Lifestyle Blog) - Đưa từ cuối lên
    3. Hộp thư nhỏ Namiya (Namiya Mailbox)
    4. Kệ quà của mẹ (Product Curation Section)
    5. Kiosk Banner (Mở sạp gỗ cùng Tina) - Chuyển từ đầu xuống sát chân trang
    6. Footer
*   **`FR-024` (Tái thiết kế Nhật ký lối sống)**:
    *   *Mobile:* Hiển thị dạng Horizontal Swipe Carousel (Trượt ngang), mỗi slide hiển thị 1 card trọn vẹn và 15% card tiếp theo.
    *   *Desktop:* Hiển thị CSS Grid 3 cột. Hover vào card làm ảnh Polaroid xoay nhẹ 2-3 độ, tiêu đề gạch chân màu Xanh Neon `#76C123`.
*   **`FR-025` (Kệ quà của mẹ theo Boss)**:
    *   *Điều hướng:* Tích hợp Tabs tương tác: `[📖 Sách của Tina]`, `[🍪 Pate của Latte]`, `[🎾 Đồ chơi của Muối]`, `[💤 Góc chill của Pi's]`.
    *   *Lưới sản phẩm:* 2 cột trên Mobile (`grid-cols-2`), 4-5 cột trên Desktop.
    *   *Mobile Action:* Rút gọn nút mua hàng thành một icon xe đẩy màu Đen tròn nhỏ ở góc dưới card để tiết kiệm không gian.
    *   *Chi tiết:* Click sản phẩm mở Polaroid Bottom Sheet (trượt từ dưới lên trên Mobile, hoặc hiển thị Modal Polaroid căn giữa trên Desktop).
*   **`FR-026` (Tái thiết kế Hòm thư Namiya)**:
    *   *Default:* Chỉ hiển thị hình vẽ hòm thư gỗ Nhật cổ điển, bình hoa nhỏ và nút bấm `[Viết thư gửi gắm tâm sự ✉]`.
    *   *Active:* Click nút sẽ trượt mở form nhập liệu ngay tại chỗ. Tích hợp nút điền email nhanh bằng Google SSO (avatar/logo G).
    *   *Validation:* Nút gửi thư disabled cho đến khi textarea dài >= 10 ký tự và email đúng định dạng.
    *   *Success:* Hoạt ảnh phong thư bay vào hòm kèm âm thanh chuông gió nhẹ nhàng, sau đó tự động gửi email chăm sóc đính kèm voucher đối tác.

## 4. Non-Functional Requirements

*   **`NFR-005` (Muji Minimalism)**: Tuân thủ nghiêm ngặt bảng màu Muji (Nền trắng giấy `#FFFFFF`, Chữ/nút đen than `#1C1C1E`, điểm nhấn Neon `#76C123`, Nền phụ Oatmeal `#F8F9FA`).
*   **`NFR-006` (Mobile First & CLS Prevention)**: Không gây giật lag hoặc xê dịch bố cục (Cumulative Layout Shift) khi trượt mở form Namiya hoặc chuyển Tab sản phẩm.
*   **`NFR-007` (A11y & Focus)**: Sử dụng các thuộc tính `aria-label` đầy đủ cho các icon tab và nút xe mua sắm thu gọn trên Mobile.

## 5. Acceptance Criteria

*   **`AC-007`**: Given người dùng mở trang chủ, when họ cuộn xuống dưới Player nhạc, then họ phải nhìn thấy Nhật ký lối sống thay vì Kiosk Banner.
*   **`AC-008`**: Given màn hình mobile, when vuốt ngang trong mục Nhật ký lối sống, then các bài viết trượt mượt mà theo carousel ngang.
*   **`AC-009`**: Given Kệ quà của mẹ, when click chọn tab Boss Latte, then chỉ hiển thị các sản phẩm thức ăn tương ứng của Latte dưới dạng lưới 2 cột.
*   **`AC-010`**: Given Hòm thư Namiya ở trạng thái mặc định, when chưa click nút viết thư, then form nhập liệu được ẩn hoàn toàn để tối giản giao diện.
*   **`AC-011`**: Given form Namiya đang mở, when click nút đăng nhập Google nhanh, then email được tự động điền vào ô input và nút gửi thư được kích hoạt nếu nội dung thư hợp lệ.

## 6. Clarifications

*   *Đã làm rõ:* Thiết kế hòm thư sẽ sử dụng các icon của Phosphor Icons (`ph-light` mặc định).
*   *Đã làm rõ:* Nhạc chuông gió thành công sử dụng hiệu ứng âm thanh nhỏ gọn (audio file MP3/WebM) lưu trữ trên R2.

## 7. Constraints

*   Không được thay đổi các logic database của bảng `creator_kiosks` hay `kiosk_links`.
*   Giữ nguyên cơ chế đồng bộ nhạc live FM của `index.astro`.

## 8. Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Lỗi CLS khi trượt mở form Namiya | Trung bình | Sử dụng CSS transitions mượt mà với `max-height` và `opacity` |
| Vấn đề responsive trên các màn hình Mobile quá nhỏ | Cao | Định cấu hình lưới sản phẩm `grid-cols-2` với size ảnh Polaroid tỷ lệ động |

## 9. Traceability

| Requirement | Plan Section | Tasks | Verification |
| --- | --- | --- | --- |
| `FR-023` | Bố cục trang chủ | Task 1 | Kiểm tra trực quan trên di động & desktop |
| `FR-024` | Tái thiết kế Blog | Task 2 | Swiping trên Mobile, Hover trên Desktop |
| `FR-025` | Kệ quà theo Boss | Task 3 | Click chuyển tab, kiểm tra số lượng sản phẩm hiển thị |
| `FR-026` | Form Namiya | Task 4 | Trượt mở form, click điền nhanh email, kiểm tra validation |
