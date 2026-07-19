# Feature Specification: Project Planning - Quiz Game Lead Capture

> Feature ID: `014-project-planning-quiz-game-lead-capture`
> Created: `2026-07-05`
> Status: Draft
> Source Prompt: thêm 1 tinh năng quiz game để làm thu hút từ social qua web. đăng 1 link chứa câu hỏi thú dị từ web sao cho thumbnail của link có thể đọc được câu hỏi. gười dùng bấm vào dẫn đên web và phân trả lời chọn đám án gửi câu tar lời thì kêu nhập mail để xem kết quả

## 1. Purpose

Xây dựng tính năng câu hỏi trắc nghiệm (Quiz Game) trên ứng dụng web DOCA nhằm thu hút lượng truy cập tự nhiên (Organic Traffic) từ các mạng xã hội (Facebook Page, Facebook Group, YouTube) chuyển đổi thành khách hàng tiềm năng (Leads). 
Khi chia sẻ liên kết câu hỏi lên mạng xã hội, ảnh xem trước (Open Graph Thumbnail) của liên kết phải hiển thị rõ ràng nội dung câu hỏi để tăng tỷ lệ nhấp chuột (CTR). Khi khách truy cập trả lời câu hỏi trên web, hệ thống sẽ yêu cầu nhập Email (Lead Capture) để xem kết quả và đáp án đúng.

## 2. User Stories

*   **US-001 (Người xem mạng xã hội):** Là một người theo dõi fanpage/group, tôi muốn nhìn thấy ảnh xem trước (thumbnail) của liên kết hiển thị câu hỏi trắc nghiệm thú vị và hình ảnh bắt mắt để kích thích tôi bấm vào liên kết.
*   **US-002 (Khách truy cập web):** Là một khách truy cập, tôi muốn đọc câu hỏi và nhấp chọn các đáp án một cách dễ dàng, trực quan trên giao diện ấm cúng (cozy) của DOCA để kiểm tra hiểu biết của mình về thú cưng.
*   **US-003 (Khách truy cập nhận kết quả):** Là một khách truy cập sau khi trả lời, tôi muốn nhập email của mình để mở khóa xem ngay kết quả đúng/sai cùng lời giải thích chi tiết, dí dỏm của host Tina.
*   **US-004 (Quản trị viên tiếp thị):** Là một quản trị viên, tôi muốn thu thập các email mà người dùng đã gửi cùng kết quả trả lời của họ để phân tích thị hiếu và thực hiện các chiến dịch tiếp thị email chăm sóc sau này.

## 3. Functional Requirements

*   **FR-001 (Định cấu hình Quiz bằng JSON):** Hệ thống phải định nghĩa danh sách câu hỏi thông qua một tệp cấu hình JSON cục bộ (ví dụ: `src/data/quizzes.json`), mỗi câu hỏi gồm các trường: `slug`, `question`, `options` (danh sách lựa chọn), `correctAnswer` (chỉ số đáp án đúng), `explanation` (giải thích từ Tina), và `ogImage` (đường dẫn ảnh thumbnail chứa câu hỏi).
*   **FR-002 (Định tuyến động Quiz):** Hệ thống phải có trang định tuyến động `/quiz/[slug]` để tải và hiển thị nội dung câu hỏi tương ứng dựa trên slug trong cấu hình.
*   **FR-003 (Thẻ siêu dữ liệu Open Graph):** Trang `/quiz/[slug]` phải chèn các thẻ meta Open Graph đúng chuẩn (`og:title`, `og:description`, `og:image`) trỏ tới tiêu đề câu hỏi và tệp ảnh `ogImage` tương ứng của câu hỏi đó để các nền tảng social hiển thị chính xác.
*   **FR-004 (Trình chọn đáp án & Nút Gửi):** Người dùng có thể nhấp chọn một trong các phương án (A, B, C, D). Khi chọn xong, nút "Gửi câu trả lời" sẽ sáng lên để người dùng bấm gửi.
*   **FR-005 (Luồng chặn khóa và Lead Capture):** Khi người dùng bấm gửi câu trả lời, màn hình sẽ hiển thị hiệu ứng chặn khóa kết quả (Cozy Modal hoặc Bottom Sheet), yêu cầu nhập email. Form nhập email phải có xác thực định dạng (Regex email validation).
*   **FR-006 (Ghi nhận Lead & Hiển thị kết quả):** Khi người dùng gửi email hợp lệ:
    *   Hệ thống gửi dữ liệu (Email, Quiz Slug, Chọn lựa) về máy chủ Supabase và ghi nhận vào bảng `quiz_leads`.
    *   Sau khi lưu thành công, khóa chặn biến mất, trang hiển thị kết quả đúng/sai kèm theo giải thích chi tiết của host Tina và hiển thị CTA điều hướng đến **Kệ Quà Của Mẹ** hoặc **Tina's FM Station**.

## 4. Non-Functional Requirements

*   **NFR-001 (Hiệu năng):** Trang quiz động phải được render ở chế độ SSG (Static Site Generation) tại thời điểm build (hoặc ISR) để đảm bảo tốc độ tải trang dưới 1.2 giây, tránh rớt traffic từ social.
*   **NFR-002 (Bảo mật & Spam):** Phải có cơ chế kiểm tra định dạng email và giới hạn tần suất gửi (rate limiting) ở client để tránh spam email ảo.
*   **NFR-003 (Thiết kế Cozy & Icons):** Sử dụng thiết kế đồng bộ với hệ thống DOCA (Matcha Green, Warm Cream), các nút bấm sử dụng bộ icon **Phosphor Icons** phiên bản nét mảnh (`ph-light` mặc định, `ph-fill` khi được chọn).

## 5. Acceptance Criteria

*   **AC-001:** Khi chia sẻ liên kết `/quiz/meo-hieu-tieng-nguoi-khong` lên Facebook, ảnh thumbnail Open Graph phải hiển thị đúng file ảnh chứa câu hỏi trắc nghiệm đã được cấu hình.
*   **AC-002:** Khi truy cập trang quiz, nhấp chọn phương án A và bấm "Gửi câu trả lời", một modal/Bottom Sheet hiện lên yêu cầu nhập email. Nội dung kết quả và lời giải thích của Tina phải được ẩn hoàn toàn trước đó.
*   **AC-003:** Khi nhập email không đúng định dạng (ví dụ `test@xyz`), hệ thống hiển thị thông báo lỗi. Khi nhập email đúng (ví dụ `user@example.com`) và nhấn "Xem kết quả", một yêu cầu mạng được gửi đến bảng Supabase `quiz_leads`, sau đó màn hình mở khóa và hiển thị: *"Chúc mừng! Bạn đã trả lời đúng"* hoặc *"Ồ tiếc quá! Đáp án chính xác là..."* kèm CTA của Tina.

## 6. Clarifications

*   [NEEDS CLARIFICATION: Phương án tạo ảnh OG thumbnail? Để tối ưu hiển thị, ta sử dụng ảnh thiết kế tĩnh có sẵn trong thư mục `/public/images/quizzes/` hay tạo một endpoint render ảnh động từ văn bản?]
    *   *Quyết định:* Để đảm bảo độ ổn định và hiển thị nhanh trên Facebook/Zalo, ta chọn **thiết kế tĩnh sẵn ảnh cho từng câu hỏi**. Mỗi câu hỏi mới được thêm sẽ đi kèm một file ảnh tĩnh được lưu trong `public/images/quizzes/[slug].png`.
*   [NEEDS CLARIFICATION: Cách lưu trữ Email Lead?]
    *   *Quyết định:* Lưu trữ vào một bảng mới trong cơ sở dữ liệu Supabase có tên là `quiz_leads` với cấu trúc đơn giản (id, email, quiz_slug, selected_option, created_at).

## 7. Constraints

*   Bộ icon sử dụng: **Phosphor Icons** (CDN đã nhúng, sử dụng lớp `ph-light`).
*   Thư mục phát triển: `doca-affiliate-web/src/pages/quiz/[slug].astro`.
*   Tệp dữ liệu: `doca-affiliate-web/src/data/quizzes.json`.

## 8. Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Người dùng điền email ảo | High | Tích hợp Regex check và kiểm tra tính hợp lệ của domain email cơ bản ở client. |
| Độ trễ khi lưu lead vào Supabase | Medium | Hiển thị trạng thái loading mượt mà trên nút bấm (Loading spinner) để người dùng không bấm nhiều lần. |

## 9. Traceability

| Requirement | Plan Section | Tasks | Verification |
| --- | --- | --- | --- |
| `FR-001` | Cấu trúc dữ liệu | Tạo file quizzes.json | Kiểm tra cấu trúc JSON |
| `FR-002` | Định tuyến trang | Tạo trang [slug].astro | Truy cập route kiểm thử |
| `FR-003` | Open Graph | Nhúng og:image động | Kiểm thử qua Facebook Sharing Debugger |
| `FR-005` | Lead Capture | Tạo Form Email Modal | Gửi thử email |
| `FR-006` | Supabase | Tạo bảng quiz_leads | Kiểm tra dữ liệu ghi nhận |
