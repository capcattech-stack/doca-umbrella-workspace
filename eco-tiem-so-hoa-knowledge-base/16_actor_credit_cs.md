# 16 — Actor: Nhân viên Tín dụng (Credit Officer) & CS Support

---

## A. Credit Officer — Nhân viên Tín dụng Finviet

> **Role-play:** Tôi là Chị Mai, Credit Officer tại Finviet.  
> Nhiệm vụ: xét duyệt Loan request từ Merchant cho các đơn nhập hàng.

### Hành trình Chị Mai — Xét duyệt Loan

```
09:00 — Có 15 Loan request mới từ tối qua
       → [ĐIỂM GÃY CR-01] Chị Mai xét duyệt trên giao diện nào?
         Portal ECOM có màn hình "Loan Approval Queue" không?
         Hay nhận qua email notification rồi approve thủ công?

       → [ĐIỂM GÃY CR-02] Thông tin để xét duyệt gồm những gì?
         Cần: lịch sử giao dịch Merchant, dư nợ hiện tại, giá trị đơn hàng, credit score
         Tất cả thông tin này có sẵn trên 1 màn hình không?
         Hay Chị Mai phải tra nhiều hệ thống?

09:30 — Merchant #4521 xin Loan 80 triệu (đơn hàng 80 triệu)
       → Chị Mai thấy: đang có dư nợ 30 triệu từ Loan trước
         → Tổng exposure: 110 triệu
       → [ĐIỂM GÃY CR-03] Hệ thống có tự động tính "Total Credit Exposure" không?
         Hay Chị Mai phải cộng tay?
         Nếu Merchant có 3 Loan đang active → cộng thủ công → sai sót

09:45 — Approve Loan 60 triệu (partial approval)
       → [ĐIỂM GÃY CR-04] Merchant nhận thông báo: "Loan được duyệt 60 triệu"
         Nhưng đơn hàng là 80 triệu → 20 triệu còn lại xử lý thế nào?
         App tự động điều chỉnh đơn hàng xuống 60 triệu? Hay Merchant phải tự xử lý?
         Tài liệu không mô tả flow này

10:00 — Reject Loan của Merchant #3312 (bad credit)
       → [ĐIỂM GÃY CR-05] Rejection reason: Chị Mai nhập lý do trong portal
         Merchant có nhận được lý do reject không?
         Tài liệu gốc: chỉ nói "Loan bị từ chối" — không có rejection reason
         → Merchant không biết cải thiện gì để apply lại

14:00 — Phát hiện Merchant #2201 đang overdue 15 ngày
       → [ĐIỂM GÃY CR-06] Ai trigger collection process?
         Hệ thống tự động block Merchant? Hay Chị Mai phải manually flag?
         Không có Overdue Management workflow trong tài liệu
```

### Tổng hợp Gaps — Credit Officer

| # | Điểm gãy | Mức độ |
|---|---|---|
| CR-01 | Không rõ giao diện xét duyệt Loan (Portal ECOM có Loan Queue không?) | 🔴 Cao |
| CR-02 | Thông tin xét duyệt có tập trung 1 màn hình không? | 🟠 TB |
| CR-03 | Không có auto-calculated Total Credit Exposure | 🔴 Cao |
| CR-04 | Partial approval: đơn hàng không tự điều chỉnh → Merchant bị treo | 🔴 Cao |
| CR-05 | Rejection reason không được gửi cho Merchant | 🟠 TB |
| CR-06 | Overdue Management workflow chưa được định nghĩa | 🔴 Cao |

---

## B. Customer Support (CS) — Nhân viên CSKH Finviet

> **Role-play:** Tôi là Anh Hùng, CS Agent tại Finviet.  
> Nhận khiếu nại từ Merchant qua hotline/Zalo.

### Hành trình Anh Hùng — Xử lý khiếu nại

```
10:00 — Chị Lan gọi: "Tôi đặt hàng 5 ngày rồi chưa thấy giao"
       → [ĐIỂM GÃY CS-01] Anh Hùng tra đơn hàng trên đâu?
         - Portal ECOM có CS View với search by phone/merchantId không?
         - Xem được trạng thái đơn real-time không?
         - Nếu OMS không cập nhật từ ERP → Anh Hùng cũng thấy "Đang xử lý" như Merchant

10:15 — Chị Lan phàn nàn: "Tôi bị trừ Fund 20 triệu nhưng đơn chưa giao"
       → [ĐIỂM GÃY CS-02] Anh Hùng không có quyền hoàn Fund
         Phải escalate lên Finance team
         Không có SLA escalation, không có ticket system trong tài liệu
         → Chị Lan phải chờ, không biết khi nào được xử lý

10:30 — Merchant khác: "Tôi xuất hóa đơn sai, cần hủy"
       → [ĐIỂM GÃY CS-03] Anh Hùng không có quyền hủy HĐ điện tử
         Phải qua Finance + Legal approval
         Không có HĐ cancel workflow trong hệ thống (đã phát hiện ở file 06)
         → CS là điểm tiếp nhận nhưng không có tool để giải quyết

11:00 — Merchant báo: "App của tôi không tìm thấy sản phẩm X của Brand Y"
       → [ĐIỂM GÃY CS-04] Anh Hùng phải debug:
         (a) Merchant có trong whitelist không?
         (b) Địa chỉ có đúng zone không?
         (c) Sản phẩm có còn active không?
         → Không có diagnostic tool (đã phát hiện ở file 13 - A-05)
         Anh Hùng mất 20-30 phút cho 1 ticket → capacity vấn đề
```

### Tổng hợp Gaps — CS

| # | Điểm gãy | Mức độ |
|---|---|---|
| CS-01 | CS không có real-time order status → không hỗ trợ được Merchant | 🔴 Cao |
| CS-02 | Không có ticket/escalation system → SLA không được đảm bảo | 🟠 TB |
| CS-03 | CS không có tool xử lý HĐ hủy/điều chỉnh | 🔴 Cao |
| CS-04 | Không có diagnostic tool → debug mỗi ticket mất quá lâu | 🟠 TB |
| CS-05 | Không có self-service cho Merchant (FAQ, chatbot) → mọi thứ qua hotline | 🟡 Thấp |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
