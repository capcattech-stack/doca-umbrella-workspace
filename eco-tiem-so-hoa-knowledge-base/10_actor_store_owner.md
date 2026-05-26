# 10 — Actor: Merchant — Chủ Tiệm (Store Owner)

> **Role-play:** Tôi là Chị Lan, 42 tuổi, chủ tiệm tạp hóa tại Q.12 TPHCM.  
> Doanh thu ~15 triệu/ngày. Nhập hàng từ 5–7 nhà cung cấp. Có 1 nhân viên phụ.  
> Vừa được Finviet sales giới thiệu app ECO TSH.

---

## Mục tiêu & Động lực

| Mục tiêu | Kỳ vọng vào ECO TSH |
|---|---|
| Nhập hàng nhanh hơn, không cần gọi điện | Đặt đơn online, giao tận nơi |
| Biết mình còn bao nhiêu hàng | Xem tồn kho trên điện thoại |
| Vay vốn khi cần nhập hàng lớn | Loan theo đơn, không cần thế chấp |
| Có hóa đơn cho khách doanh nghiệp | Xuất HĐ điện tử ngay trên app |
| Quản lý được nhân viên | Phân quyền, xem doanh thu |

---

## Hành trình Chị Lan — Ngày 1: Onboarding

```
07:00 — Tải app, đăng ký SĐT, nhập OTP ✓
07:05 — Điền tên tiệm "Tạp hóa Lan", địa chỉ số nhà
       → [LỖ HỔNG] App yêu cầu địa chỉ chính xác để gán zone
         Chị Lan gõ "123 Lê Văn Khương" — không có autocomplete
         → Zone gán sai → thấy sản phẩm sai nhà phân phối

07:10 — Upload CCCD → status "pending_review"
       → [ĐIỂM GÃY #1] Chị Lan không biết chờ bao lâu
         Không có màn hình "Dự kiến xét duyệt trong X giờ"
         Không có kênh liên hệ để hỏi thêm

Ngày 2, 09:00 — Nhận SMS "Tài khoản đã được duyệt"
       → [LỖ HỔNG] Không có hướng dẫn bước tiếp theo
         Chị Lan không biết phải làm gì sau khi vào app
```

**Gaps phát hiện từ góc nhìn Chị Lan:**
- ❌ Không có onboarding tour / hướng dẫn sử dụng
- ❌ Không có SLA hiển thị cho KYC review
- ❌ Địa chỉ nhập tự do → gán sai Distribution Zone

---

## Hành trình Chị Lan — Ngày 3: Đặt đơn nhập hàng đầu tiên

```
10:00 — Mở tab "Nhập hàng"
       → Thấy danh sách sản phẩm (đã lọc theo zone)
       → [VẤN ĐỀ] Chị Lan thường nhập Mì Hảo Hảo của Acecook
         nhưng không thấy trong app
         → [ĐIỂM GÃY #2] Chị Lan KHÔNG BIẾT lý do tại sao không thấy
           Có thể do: chưa trong whitelist Brand | hết hàng | sai zone
           App không hiển thị lý do → Chị Lan bỏ qua, mua ở nhà phân phối khác

10:15 — Chọn một số sản phẩm Thọ Phát (thấy được vì đã trong whitelist)
       → Thêm vào giỏ, chọn số lượng

10:20 — Đến bước thanh toán
       → Chọn "Thanh toán bằng Fund" (vừa được cấp 20 triệu)
       → [VẤN ĐỀ] Đơn hàng 25 triệu, Fund chỉ có 20 triệu
         App yêu cầu chọn thêm phương thức cho 5 triệu còn lại
         Chị Lan chọn "Loan" cho phần chênh lệch
         → [ĐIỂM GÃY #3] App không giải thích:
           - Fund 20M bị trừ ngay
           - Loan 5M chờ duyệt (bao lâu?)
           - Đơn hàng trạng thái: "Đang chờ duyệt Loan" — Chị Lan lo lắng

10:35 — Loan được duyệt sau 15 phút
       → Đơn chuyển "Đã xác nhận"
       → [LỖ HỔNG] Chị Lan không biết đơn đã được gửi sang Thọ Phát chưa
         Không có timeline "Dự kiến giao: 2-3 ngày"

Ngày 5 — Shipper giao hàng
       → Chị Lan nhận hàng, đếm: thiếu 2 thùng nước tương
       → Mở app, tìm cách báo thiếu hàng
       → [ĐIỂM GÃY #4] Không tìm thấy nút "Báo thiếu hàng" / "Đổi trả"
         Chị Lan gọi cho sales Finviet để phàn nàn
         → Flow hoàn tiền 2 thùng: không có trong hệ thống
```

---

## Hành trình Chị Lan — Ca bán hàng buổi sáng

```
08:00 — Nhân viên Anh Tuấn mở POS, bắt đầu bán hàng
       → [VẤN ĐỀ] Mạng 4G ở tiệm yếu vào buổi sáng
         POS load chậm, khách xếp hàng chờ
         → [ĐIỂM GÃY #5] Không rõ POS có chế độ offline không

08:30 — Khách mua mì gói, quét mã vạch
       → Mì Hảo Hảo không có trong database ECO TSH
         (vì chưa nhập qua hệ thống)
       → [ĐIỂM GÃY #6] POS không tìm thấy sản phẩm
         Anh Tuấn phải nhập giá tay, không có mã SKU
         → Giao dịch này không có mã hàng hóa → HĐ điện tử sau này ghi gì?

09:15 — Khách lẻ mua 3 sản phẩm, tổng 87.000đ
       → Khách trả tiền mặt 100.000đ
       → App tính tiền thừa 13.000đ ✓
       → [VẤN ĐỀ] Chị Lan muốn xuất HĐ điện tử cho khách này
         Khách không có MST
         → App hỏi thông tin người mua → Chị Lan bỏ qua → HĐ xuất "người tiêu dùng"
         → [LỖ HỔNG] HĐ "người tiêu dùng" theo NĐ70 có format riêng
           Hệ thống có handle case này không?

11:00 — Hết hàng dầu ăn Neptune
       → Tồn kho hệ thống hiển thị còn 3 chai (nhưng thực tế hết)
       → [ĐIỂM GÃY #7] Sai lệch tồn kho do không kiểm đếm thực khi nhận hàng lần trước
         Chị Lan vẫn bán được (bán âm) → tồn kho về -1
         Không có alert nào xuất hiện
```

---

## Hành trình Chị Lan — Cuối tháng: Kê khai thuế

```
31/03 — Chị Lan mở tab "Báo cáo Thuế"
       → Thấy số liệu: Doanh thu 380 triệu, HĐ đã xuất: 45 triệu
       → [ĐIỂM GÃY #8] 335 triệu doanh thu không có HĐ
         Chị Lan lo: "Tôi phải kê khai 380 triệu hay 45 triệu?"
         Theo NĐ70: phải kê khai 380 triệu (POS log)
         Nhưng app không giải thích rõ điều này
         → Chị Lan không biết → kê khai sai → rủi ro bị phạt thuế

       → [ĐIỂM GÃY #9] Xuất file Excel → format không tương thích với phần mềm kê khai thuế
         Chị Lan phải nhờ kế toán làm lại
```

---

## Tổng hợp Gaps từ góc nhìn Store Owner

| # | Điểm gãy | Mức độ | File liên quan |
|---|---|---|---|
| SO-01 | Không có onboarding tour sau khi approved | 🟠 TB | 02 |
| SO-02 | Sản phẩm Brand không hiển thị nhưng không có lý do | 🔴 Cao | 02 |
| SO-03 | Mixed payment (Fund+Loan) không có timeline/giải thích | 🔴 Cao | 04, 05 |
| SO-04 | Không có luồng báo thiếu hàng / đổi trả trong app | 🔴 Cao | 07 |
| SO-05 | POS offline behavior chưa rõ | 🔴 Cao | 03 |
| SO-06 | Sản phẩm không trong ECO catalog: ghi HĐ thế nào? | 🔴 Cao | 06 |
| SO-07 | Bán âm không có alert → tồn kho sai lệch âm thầm | 🔴 Cao | 03 |
| SO-08 | Cuối tháng không rõ phải kê khai số liệu POS hay HĐ | 🔴 Cao | 06 |
| SO-09 | File xuất báo cáo không tương thích phần mềm thuế | 🟠 TB | 06 |
| SO-10 | Không có timeline giao hàng dự kiến sau khi đặt đơn | 🟠 TB | 02 |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
