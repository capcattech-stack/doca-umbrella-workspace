# 📄 MẪU TÀI LIỆU ĐẶC TẢ YÊU CẦU (Product Forge PRD Standard)

> **Mục đích:** Đây là bộ khung chuẩn (Template) mà Hội đồng AI (Product Agent) bắt buộc phải sử dụng để sinh ra PRD đối với các tính năng lớn (Size L/XL). 

---

## 1. Thông Tin Chung (Meta Information)
*   **Mã định danh:** `#IDEA-XXX`
*   **Người đề xuất:** (Anonymous User PIN / Admin)
*   **Người dùng mục tiêu (Target Audience):** Nhóm đối tượng trực tiếp sử dụng và hưởng lợi từ tính năng này là ai? (Ví dụ: Chủ tiệm tạp hóa, User hạng Vàng).
*   **Mức độ (Size):** L / XL

## 2. Bối Cảnh & Vấn Đề (Context & Problem)
*   **Ý tưởng gốc (Raw Idea):** Lời trích dẫn nguyên bản của người dùng.
*   **Nỗi đau (Pain-point):** Vấn đề cụ thể mà người dùng đang gặp phải là gì?
*   **Bằng chứng Thị trường (Validation Evidence):** Bằng chứng từ Mom Test hoặc data hiện hữu chứng minh đây là vấn đề đáng giải quyết.

## 3. Mục Tiêu & Chỉ Số Đo Lường (Objectives & Success Metrics)
*   **Mục tiêu (Objective):** Tính năng này sinh ra để làm gì? (Tăng trưởng doanh thu, tối ưu vận hành, hay sửa lỗi luồng).
*   **Chỉ số Đo lường (Success Metrics):** Các chỉ số định lượng để đánh giá thành công sau khi Launch. (Ví dụ: Tăng Conversion Rate thêm 5%, Giảm Support Ticket xuống 20%).

## 4. Phân Tích Đánh Đổi (Trade-off & ROI)
*   **Dự phóng Lợi ích (Value):** Doanh thu kỳ vọng hoặc mức độ tác động.
*   **Dự phóng Chi phí (Tech Effort/OpEx):** Số Man-days thực thi và chi phí Server/API hàng tháng.
*   **Đánh giá P&L / RICE Score:** Thời gian hòa vốn (ROI) hoặc Tổng điểm RICE.

## 5. Phạm Vi Sản Phẩm (Scope Management)
*   **Trong phạm vi (In Scope):** Các tính năng cốt lõi sẽ được Dev thực hiện trong Phase này.
*   **Ngoài phạm vi (Out of Scope):** Ghi chú lại rõ ràng các tính năng *đã bị cắt giảm* sau quá trình AI thương lượng ép người dùng thu hẹp Scope để chốt được ROI khả thi. (Đây là "bằng chứng" để tránh Scope Creep về sau).

## 6. Giải Pháp Trải Nghiệm (User Flow / UX)
*   **Luồng thao tác (Step-by-step):** Hành trình của người dùng qua các màn hình.
*   **Yêu cầu Giao diện (Wireframe Requirements):** Các thành phần bắt buộc phải có mặt trên UI.

## 7. Quyết Định Kiến Trúc & Kỹ Thuật (Technical Decisions)
*   **Tác động Hệ thống:** Ảnh hưởng đến DB nào? Cần tạo bảng mới không?
*   **Tích hợp (Integrations):** Các API bên thứ 3 cần gọi.
*   **Rủi ro Kỹ thuật (Tech Risks):** Rủi ro quá tải, bảo mật và giải pháp xử lý (Rate-limit, Cache).

## 8. Danh Sách User Stories & Tiêu Chí Nghiệm Thu (AC)
*   **US01:** Là một [Ai], tôi muốn [Hành động] để [Nhận được giá trị].
    *   **AC1:** Hành vi mong đợi 1...
    *   **AC2:** Hành vi mong đợi 2...

## 9. Xử Lý Ngoại Lệ & Rủi Ro Biên (Edge Cases & Unhappy Paths)
*   Mất mạng (Network Timeout) thì sao?
*   User không đủ quyền hạn truy cập (Unauthorized) thì hệ thống báo lỗi gì?
*   Hệ thống đối tác bị sập (Third-party down) thì xử lý fallback thế nào?

## 10. Kịch Bản Kiểm Thử (UAT Test Cases)
*   **TC01:** [Happy Path] - Kiểm tra luồng hoàn hảo.
*   **TC02...TCXX:** [Edge Cases] - Kiểm thử các trường hợp ngoại lệ đã liệt kê ở Mục 9.
