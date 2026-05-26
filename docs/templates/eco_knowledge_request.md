# Yêu cầu Trích xuất Tri thức Hệ thống (System Knowledge Extraction Request)

**Gửi tới:** Đội ngũ Kỹ thuật (Tech Lead) hoặc AI Agent quản lý hệ thống ECO.
**Từ:** Hệ thống Idea Workshop (Alan - Tech Lead Agent).
**Mục đích:** Chúng tôi cần thu thập một số tài liệu kỹ thuật cốt lõi (Knowledge Base) của hệ thống ECO hiện tại. Dữ liệu này giúp AI của chúng tôi có thể tự động tính toán chi phí (Effort/Tech Cost) và kiểm tra tính khả thi khi thiết kế các tính năng mới gắn vào hệ thống ECO.

*Vui lòng cung cấp câu trả lời dưới định dạng **Markdown (.md)** để AI của chúng tôi dễ dàng đọc hiểu.*

---

## YÊU CẦU 1: Tổng quan Kiến trúc & Tech Stack (Architecture Overview)
Vui lòng liệt kê ngắn gọn các công nghệ lõi đang được sử dụng ở môi trường Production:
1.  **Frontend:** Đang sử dụng Framework gì? (React, Vue, Flutter, Next.js...). Có hỗ trợ Micro-frontend không?
2.  **Backend:** Ngôn ngữ và Framework (Node.js, Java Spring, Go...). Kiến trúc hiện tại là Monolith hay Microservices?
3.  **Database:** Hệ quản trị CSDL đang dùng là gì? (PostgreSQL, MySQL, MongoDB...).
4.  **Infrastructure:** Đang host ở đâu? (AWS, GCP, Vercel, server vật lý...).
5.  **Cơ chế giao tiếp:** API giao tiếp giữa Client-Server dùng chuẩn gì? (RESTful, GraphQL, gRPC, WebSockets?).

## YÊU CẦU 2: Cấu trúc Database Cốt lõi (Core ERD / Schema)
Chúng tôi không cần toàn bộ Database. Vui lòng trích xuất DDL (Data Definition Language) hoặc Schema (định dạng Prisma hoặc SQL) của **các bảng (Tables) quan trọng nhất** liên quan đến luồng nghiệp vụ chính. 
*Ví dụ: Bảng `Users` (Người dùng), `Orders` (Đơn hàng), `Transactions` (Thanh toán), `Products` (Sản phẩm).*

**Định dạng mong muốn:** Code block SQL hoặc Prisma Schema. Nếu có sơ đồ ERD bằng `Mermaid`, vui lòng đính kèm.

## YÊU CẦU 3: Các Dịch vụ Bên thứ 3 đã tích hợp (3rd Party Integrations)
Để tránh việc thiết kế lại bánh xe (reinvent the wheel) và tối ưu chi phí tích hợp, vui lòng liệt kê các dịch vụ ngoại vi mà hệ thống ECO **đã cắm API và đang chạy ổn định**:
*   **Thanh toán (Payment Gateway):** (VD: VNPay, MoMo, Stripe...)
*   **Gửi tin nhắn/Thông báo (SMS/Email/Push):** (VD: Twilio, Zalo ZNS, Firebase Cloud Messaging, SendGrid...)
*   **Xác thực (Authentication):** (VD: Firebase Auth, NextAuth, Keycloak...)
*   **Lưu trữ File (Storage):** (VD: AWS S3, Cloudinary...)

## YÊU CẦU 4: Ràng buộc Kỹ thuật (Technical Constraints & NFRs)
Vui lòng gạch đầu dòng các ràng buộc khắt khe (nếu có) của hệ thống:
*   Hệ thống có yêu cầu bảo mật đặc biệt nào không? (VD: Tiêu chuẩn PCI-DSS cho thanh toán, mã hóa dữ liệu nhạy cảm).
*   Có giới hạn nào về hiệu năng không? (VD: Phải chịu tải được 10.000 CCU, thời gian phản hồi API < 200ms).

---
*Cảm ơn sự hợp tác của bạn! Khi hoàn tất, vui lòng trả về 1 file `eco_system_context.md`. Chúng tôi sẽ đưa file này vào não bộ của Alan Agent để phục vụ dự án Idea Workshop.*
