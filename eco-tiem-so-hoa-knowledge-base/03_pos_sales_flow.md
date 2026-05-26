# 03 — Luồng Bán hàng lẻ (Mini POS / Outbound Flow)

> **Scope:** BIZ-04 Bán hàng POS · BIZ-05 Quản lý tồn kho điểm bán

---

## BIZ-04: Bán hàng lẻ qua Mini POS

### Happy Path
1. Nhân viên/Merchant mở màn hình POS trên ECO TSH
2. Tìm sản phẩm: quét mã vạch / tìm kiếm tên / browse danh mục
3. Thêm sản phẩm vào giỏ (local POS cart)
4. Nhập số lượng, áp dụng giảm giá (nếu có)
5. Tính tổng tiền → Merchant chọn phương thức thu tiền:
   - **[A] Tiền mặt**: Nhập số tiền nhận → App tính tiền thừa → Hoàn tất
   - **[B] QR Code**: App hiển thị VietQR → Khách quét → Callback xác nhận
   - **[C] Ví/Thẻ**: Các phương thức khác (nếu có)
6. Giao dịch hoàn tất → Trừ tồn kho local
7. Option: Xuất hóa đơn điện tử (xem BIZ-12)
8. `POST /sales { merchantId, items[], total, paymentMethod, timestamp }` → sync lên Portal ECOM

### Bán vượt tồn kho (Pre-order / Backorder)
> **Quyết định từ PO:** Hệ thống **KHÔNG CHO PHÉP** bán âm kho thực tế (tồn kho thực tế luôn >= 0). 
- Tùy vào cấu hình của đối tượng bán (NPP/Merchant), có thể cho phép **khách tạo đơn** vượt quá số lượng tồn kho (VD: Kho có 5, khách tạo đơn mua 10).
- Tuy nhiên, để **duyệt bán** (Fulfill) thì bắt buộc bên bán phải nhập thêm kho (đảm bảo tồn >= 10). Tồn kho không bao giờ bị trừ xuống số âm.

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| P-01 | **Offline POS**: Nếu mất kết nối mạng giữa ca bán hàng, POS có tiếp tục hoạt động không? Nếu có, `POST /sales` được queue và sync sau → conflict resolution khi online lại? | 🔴 Cao |
| P-02 | **(Đã chốt) Bán âm**: Cấm bán âm thực tế. Cho phép tạo đơn vượt tồn kho theo config, bắt buộc nhập đủ hàng mới được duyệt bán. | ✅ OK |
| P-03 | **Sản phẩm không có trong catalog ECO TSH**: Merchant bán sản phẩm do họ tự nhập (không qua hệ thống Finviet) → POS xử lý như thế nào? Có thể thêm sản phẩm tự do không? | 🟠 TB |
| P-04 | **Giảm giá / Khuyến mãi**: POS có hỗ trợ discount theo % hoặc fixed amount không? Discount có được ghi nhận vào báo cáo không? | 🟠 TB |
| P-05 | **Đơn hàng bán lẻ bị hủy sau khi hoàn tất**: Khách đổi ý sau khi đã thanh toán QR → quy trình hoàn tiền là gì? | 🔴 Cao |
| P-06 | **QR callback thất bại**: Khách quét QR thành công ở ngân hàng nhưng callback về ECO TSH bị lỗi (network timeout) → giao dịch treo ở trạng thái nào? Merchant xử lý ra sao? | 🔴 Cao |
| P-07 | **Multiple nhân viên cùng bán**: Nếu 2 Staff dùng 2 thiết bị cùng bán cùng 1 sản phẩm cuối cùng trong kho → race condition tồn kho | 🟠 TB |
| P-08 | **Sync POS sale lên Portal ECOM**: Nếu `POST /sales` fail → dữ liệu bán hàng không lên server → bảng kê thuế thiếu dữ liệu. Retry strategy? | 🔴 Cao |

---

## BIZ-05: Quản lý tồn kho tại điểm bán

### Các tác vụ tồn kho Merchant thực hiện trên ECO TSH

| Tác vụ | Mô tả | API call |
|---|---|---|
| Xem tồn kho | Danh sách sản phẩm + số lượng hiện tại | `GET /inventory?merchantId` |
| Điều chỉnh thủ công | Nhập kho / xuất kho / kiểm kê | `PUT /inventory/adjust` |
| Xem lịch sử tồn kho | Log thay đổi số lượng | `GET /inventory/history` |
| Cảnh báo hàng sắp hết | Alert khi dưới ngưỡng tối thiểu | Cấu hình ngưỡng |
| Gợi ý đặt hàng nhập | Auto-suggest khi tồn kho âm / thấp | Link sang BIZ-02 |

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| P-09 | **Source of truth tồn kho**: Local POS hay Portal ECOM? Nếu 2 nguồn lệch nhau (do offline), bên nào được ưu tiên khi sync? | 🔴 Cao |
| P-10 | **Kiểm kê định kỳ**: ECO TSH có hỗ trợ tính năng stock-take (đếm kho thực tế và điều chỉnh) không? | 🟠 TB |
| P-11 | **Ngưỡng cảnh báo tồn kho**: Ai cấu hình ngưỡng? Merchant tự set hay default theo category? | 🟡 Thấp |
| P-12 | **Sản phẩm có hạn sử dụng (expiry)**: POS có hỗ trợ quản lý batch/lot và expiry date không? Đây là nhu cầu thực tế của tạp hóa (thực phẩm, nước uống) | 🟠 TB |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
