# 06 — Luồng Hóa đơn điện tử & Báo cáo Thuế

> **Scope:** BIZ-12 Xuất hóa đơn · BIZ-13 Bảng kê & Kê khai thuế  
> **Pháp lý tham chiếu:** Nghị định 70/2025/NĐ-CP, Thông tư 78/2021/TT-BTC

---

## BIZ-12: Xuất Hóa đơn Điện tử cho Khách lẻ

### Happy Path — Xuất HĐ ngay sau bán hàng
```
1. POS hoàn tất giao dịch bán hàng (BIZ-04)
2. Khách yêu cầu hóa đơn
3. Merchant chọn "Xuất hóa đơn điện tử"
4. Nhập thông tin bên mua (tùy chọn):
   - Tên / MST (nếu khách là doanh nghiệp)
   - Email / SĐT nhận hóa đơn
5. [Portal ECOM API] POST /invoices
   Input:  { saleId, sellerInfo, buyerInfo, items[], total, taxRate }
   Output: { invoiceId, invoiceNo, invoiceUrl, status: "issued" }
6. Hệ thống ký số và gửi lên cơ quan thuế (qua CQT Portal)
7. ECO TSH hiển thị QR code hóa đơn / link tải PDF
8. Gửi cho khách qua SMS/Email/Zalo
```

### Happy Path — Xuất HĐ sau giao dịch (delayed)
```
1. Giao dịch đã hoàn tất nhưng không xuất HĐ ngay
2. Merchant vào lịch sử giao dịch
3. Chọn giao dịch → "Xuất hóa đơn"
4. Giới hạn thời gian xuất HĐ sau bán? (Theo NĐ70: phải xuất trong ngày hoặc chậm nhất T+1)
```

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| T-01 | **Merchant không đủ điều kiện xuất HĐ**: Tiệm tạp hóa không có MST / không đăng ký HKD → không thể xuất HĐ điện tử. Hệ thống có phân loại Merchant đủ/không đủ điều kiện không? Nếu khách yêu cầu HĐ mà Merchant không đủ điều kiện → UX hiển thị gì? | 🔴 Cao |
| T-02 | **HĐ điều chỉnh và hủy HĐ**: Theo NĐ70, HĐ đã phát hành có thể được điều chỉnh (tăng/giảm) hoặc thay thế. ECO TSH có hỗ trợ luồng này không? Nếu khách trả hàng sau khi đã có HĐ → phải xuất HĐ điều chỉnh/thay thế. | 🔴 Cao |
| T-03 | **HĐ bị từ chối bởi cơ quan thuế**: Portal ECOM gửi HĐ lên CQT → CQT từ chối (lỗi format, MST sai). ECO TSH alert Merchant để xử lý thế nào? | 🔴 Cao |
| T-04 | **Thời hạn xuất HĐ**: Giao dịch POS lúc 23:50 → Merchant xuất HĐ lúc 00:10 hôm sau → có hợp lệ theo NĐ70 không? Hệ thống có cảnh báo không? | 🟠 TB |
| T-05 | **HĐ cho giao dịch QR**: Khi khách thanh toán QR, thông tin người mua (tên/MST) lấy từ đâu? Ngân hàng không bắt buộc cung cấp tên người chuyển | 🟠 TB |
| T-06 | **Số series hóa đơn**: Mỗi Merchant có series HĐ riêng hay dùng chung series của Finviet? Ảnh hưởng đến việc đăng ký mẫu HĐ với cơ quan thuế | 🔴 Cao |

---

## BIZ-13: Lập bảng kê & Kê khai Thuế cuối kỳ

### Happy Path
```
1. Cuối tháng/quý, Merchant mở màn hình Báo cáo Thuế
2. [Portal ECOM API] GET /reports/tax?merchantId&period
   Output: {
     totalRevenue,        -- tổng doanh thu POS
     totalInvoiced,       -- tổng giá trị HĐ đã xuất
     totalCashSales,      -- bán hàng tiền mặt không HĐ
     taxableAmount,       -- doanh thu chịu thuế
     taxAmount,           -- số thuế phải nộp
     invoiceList[],       -- danh sách HĐ đã xuất
     exportFormats: ["XML", "Excel", "PDF"]
   }
3. Merchant xuất file → nộp lên cổng thuế (thủ công bên ngoài hệ thống)
```

### Source of Truth — Vấn đề cốt lõi

```
Doanh thu thực tế (POS log)  ≠  Doanh thu trên HĐ điện tử
         |                              |
  Bao gồm:                      Chỉ bao gồm:
  - Bán tiền mặt không HĐ        - Giao dịch đã xuất HĐ
  - Bán âm (chưa có hàng)        - Giao dịch khách yêu cầu HĐ
  - QR không xuất HĐ
```

**Câu hỏi quyết định:** Bảng kê thuế dựa trên POS log hay HĐ list?

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| T-07 | **[CRITICAL] Source of truth cho bảng kê**: Nếu dựa trên HĐ → thiếu doanh thu tiền mặt/QR không xuất HĐ → **vi phạm NĐ70** (khai thiếu doanh thu). Phải dựa trên POS log + HĐ kết hợp | 🔴 Cao |
| T-08 | **Giao dịch "bán âm" trên bảng kê**: Bán sản phẩm không có trong kho hệ thống → không có mã hàng hóa chuẩn → HĐ xuất ra sẽ ghi gì ở phần hàng hóa? | 🔴 Cao |
| T-09 | **Merchant không nộp thuế qua hệ thống**: ECO TSH chỉ hỗ trợ xuất file, không nộp thay. Có tích hợp với eTax GNVNT (cổng thuế điện tử) không? | 🟠 TB |
| T-10 | **Thuế suất**: Mặt hàng FMCG có nhiều mức thuế VAT khác nhau (0%, 5%, 10%). PMS có gắn thuế suất cho từng SKU không? Nếu không → bảng kê tính sai | 🔴 Cao |
| T-11 | **Kỳ kê khai**: Merchant kê khai theo tháng hay quý? Hệ thống có tự nhận biết kỳ kê khai của từng Merchant không? | 🟠 TB |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
