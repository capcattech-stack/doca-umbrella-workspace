# 11 — Actor: Nhân viên bán hàng (Staff)

> **Role-play:** Tôi là Anh Tuấn, 22 tuổi, nhân viên bán hàng tại tiệm tạp hóa của Chị Lan.  
> Ca làm 07:00–17:00. Được chủ giao điện thoại Android đã cài ECO TSH.  
> Không được phép đặt đơn nhập hàng, chỉ bán lẻ.

---

## Mục tiêu & Hạn chế

| Mục tiêu | Kỳ vọng |
|---|---|
| Bán hàng nhanh, không để khách chờ | POS quét mã nhanh, tính tiền đúng |
| Thu tiền đúng, không bị thiếu | App xác nhận thanh toán rõ ràng |
| Không bị chủ trách nhầm | Log giao dịch đầy đủ, có tên người bán |

---

## Hành trình Anh Tuấn — Buổi sáng bán hàng

```
08:00 — Mở ECO TSH bằng tài khoản Staff (do Chủ tạo)
       → [VẤN ĐỀ] Lần đầu dùng, Anh Tuấn không biết Staff thấy gì khác Owner
         Không có màn hình "Chào mừng nhân viên" giải thích quyền hạn

08:05 — Khách mua: 2 gói mì + 1 chai nước = 3 items
       → Quét mã vạch gói mì: tìm thấy ✓
       → Quét mã chai nước: KHÔNG TÌM THẤY
       → [ĐIỂM GÃY S-01] App hiển thị: "Không tìm thấy sản phẩm"
         Tuấn phải:
         (a) Bỏ qua → khách không mua được nước
         (b) Nhập thủ công tên + giá → không có SKU → giao dịch "tự do"
         Không có gợi ý: "Bạn có muốn thêm sản phẩm mới không?"

08:30 — Khách thanh toán QR: 45.000đ
       → App generate QR → khách quét bằng Vietcombank
       → [ĐIỂM GÃY S-02] Màn hình POS hiển thị "Đang chờ xác nhận..."
         Sau 30 giây không có phản hồi
         Khách nói "Tôi đã chuyển rồi, điện thoại báo thành công rồi"
         Tuấn không biết phải làm gì: chờ tiếp? Xác nhận thủ công? Cancel?
         → Không có nút "Xác nhận thanh toán thủ công"
         → Tuấn bấm Cancel → giao dịch hủy → khách phải quét lại
         → Double charge risk: tiền đầu đã chuyển, quét lần 2 → mất tiền

09:15 — Chủ Lan gọi hỏi: "Sáng bán được bao nhiêu?"
       → [VẤN ĐỀ S-03] Tuấn không xem được báo cáo doanh thu (Staff không có quyền)
         Chủ phải tự mở app của mình để xem
         → Không có tính năng "báo cáo ca làm việc" cho Staff

10:00 — Khách mua 5 thùng mì, tổng 750.000đ
       → Khách muốn HĐ điện tử (doanh nghiệp)
       → [ĐIỂM GÃY S-04] Tuấn không biết cách xuất HĐ điện tử
         Tính năng có trong app nhưng không có hướng dẫn cho Staff
         → Tuấn bảo khách: "Để tôi hỏi chủ"
         → Delay UX, khách không hài lòng

11:30 — Hết ca của Anh Minh (nhân viên kia), Tuấn tiếp quản
       → [VẤN ĐỀ S-05] Không có tính năng "bàn giao ca"
         Anh Minh và Anh Tuấn dùng chung 1 tài khoản Staff
         → Giao dịch của 2 người không phân biệt được
         → Nếu có giao dịch sai, không biết ai thực hiện
```

---

## Tổng hợp Gaps từ góc nhìn Staff

| # | Điểm gãy | Mức độ |
|---|---|---|
| S-01 | Sản phẩm không có trong catalog → UX không có lối thoát rõ ràng | 🔴 Cao |
| S-02 | QR callback chậm → Staff không có cách xử lý → risk double charge | 🔴 Cao |
| S-03 | Staff không xem được báo cáo ca → chủ phải tự check | 🟠 TB |
| S-04 | Xuất HĐ điện tử: tính năng có nhưng Staff không được training | 🟠 TB |
| S-05 | Không có tính năng bàn giao ca / phân biệt giao dịch theo nhân viên | 🔴 Cao |
| S-06 | Không có màn hình onboarding cho role Staff | 🟡 Thấp |
| S-07 | Bán âm: Staff bán được nhưng không nhận được cảnh báo → Chủ không biết | 🔴 Cao |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
