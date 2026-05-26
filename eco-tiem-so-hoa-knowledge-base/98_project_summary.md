# Tóm tắt Dự án: ECO Tiệm Số Hóa (Finviet)

## 1. Tổng quan Hệ sinh thái
**ECO Tiệm Số Hóa (ECO TSH)** là nền tảng cốt lõi trong hệ sinh thái M2C (Manufacturer to Consumer) của Finviet, được thiết kế chuyên biệt để số hóa các điểm bán lẻ truyền thống (tạp hóa - General Trade). Hệ thống không chỉ là một ứng dụng bán hàng thông thường, mà là giải pháp toàn diện bao phủ: **Chuỗi cung ứng - Bán lẻ (POS) - Thanh toán - Tài chính - Kế toán Thuế**.

## 2. Kiến trúc Hệ thống
Hệ thống được chia làm hai phần chính giao tiếp qua REST API:
- **ECO TSH (Mobile App):** "Điểm chạm" của các chủ tiệm (Merchant). Giao diện để thao tác nghiệp vụ hàng ngày (nhập hàng, bán hàng, quản lý kho, yêu cầu vay vốn). 
- **Portal ECOM (Back-office / Blackbox API):** Hệ thống quản trị trung tâm, bao gồm nhiều module nội bộ:
  - **PMS:** Quản lý sản phẩm & giá.
  - **OMS:** Quản lý đơn hàng & đồng bộ với ERP của đối tác (Brand).
  - **Inventory:** Quản lý tồn kho.
  - **USCR:** Quản lý tài khoản, phân quyền.
  - **Finance Engine:** Xử lý các khoản thanh toán, Fund, Loan.

## 3. Các Luồng Nghiệp vụ Chính

### A. Luồng Nhập hàng (Inbound Flow)
- **Onboarding:** Merchant đăng ký, thực hiện eKYC và chờ Finviet duyệt.
- **Nguyên tắc phân phối:** Hệ thống kiểm soát hiển thị hàng hóa cực kỳ nghiêm ngặt:
  - **Non-cross-selling:** Chỉ hiển thị sản phẩm của Brand mà Merchant được phép bán.
  - **Zone-based:** Điều phối đơn vị phân phối (NPP) theo khu vực địa lý của cửa hàng.
- **Đặt hàng & Giao nhận:** Merchant chọn thanh toán (Ví, Fund, Loan) -> Đơn được đẩy qua ERP của Brand -> NPP giao hàng -> Merchant xác nhận nhận hàng trên app để tự động cộng tồn kho.

### B. Luồng Bán lẻ (Outbound / Mini POS)
- **Hoạt động như máy POS cầm tay:** Nhân viên dùng app quét mã vạch sản phẩm, tính tiền cho khách lẻ.
- **Thanh toán:** Hỗ trợ nhận tiền mặt hoặc khách lẻ quét mã VietQR.
- **Bán vượt tồn kho:** Chốt không cho phép bán âm kho thực tế. Chỉ cho phép tạo đơn pre-order vượt tồn kho (nếu được cấu hình), nhưng phải nhập hàng vào mới được duyệt bán.
- **Quản lý kho local:** Tồn kho được quản lý tại điểm bán, có khả năng đồng bộ dữ liệu lên Portal.

### C. Dịch vụ Thanh toán & Tài chính
- **Thanh toán đa dạng:** Hỗ trợ Ví điện tử, VietQR, Cổng thanh toán.
- **Hỗ trợ vốn lưu động:**
  - **Fund:** Hạn mức số dư được duyệt trước (Pre-approved).
  - **Loan:** Khoản vay được duyệt theo từng đơn hàng nhập (Order-based).

### D. Hóa đơn điện tử & Thuế
- Tích hợp sâu các yêu cầu pháp lý (Nghị định 70/2025/NĐ-CP). 
- Tự động xuất hóa đơn điện tử từng giao dịch bán lẻ.
- Tổng hợp bảng kê và dữ liệu xuất file chuẩn hỗ trợ Merchant khai thuế.

## 4. Các Tác nhân Tham gia (Actors)
1. **Merchant (Chủ tiệm):** Quản lý toàn bộ hoạt động (Nhập hàng, bán hàng, thuế).
2. **Staff (Nhân viên / Quản lý):** Bán hàng POS, kiểm kho.
3. **Brand Supplier:** Quản lý sản phẩm, tiếp nhận đơn qua ERP.
4. **Finviet Admin:** Quản trị toàn hệ thống.
5. **NPP / Shipper:** Thực hiện giao nhận hàng hóa.
6. **Khách hàng lẻ:** Người mua hàng cuối cùng tại tiệm.

## 5. Các Vấn đề Tồn đọng & Rủi ro (Gaps)
Quá trình phân tích đã chỉ ra nhiều điểm "nóng" cần được chốt trước khi phát triển:
- **Offline POS:** Chưa chốt cơ chế đồng bộ dữ liệu nếu app mất mạng khi đang bán hàng.
- **Blackbox ERP:** ERP của các Brand đối tác không trả về trạng thái đơn chi tiết, gây khó khăn cho việc đối soát và cập nhật tiến độ giao hàng cho Merchant.
- **Cơ chế Hủy/Đổi trả:** Đang thiếu luồng hoàn trả (Refund) hoàn chỉnh, đặc biệt ảnh hưởng đến số dư Fund/Loan nếu đơn bị hủy hoặc điều chỉnh.
- **QR Code & Hóa đơn:** Cần chốt dùng Static QR hay Dynamic QR cho khách lẻ, cũng như quy trình phát hành series hóa đơn chung hay riêng từng Merchant.

---
*Tóm tắt được tổng hợp từ các tài liệu phân tích nghiệp vụ (Analysis) trong Knowledge Base.*
