# 04 — Luồng Thanh toán (Payment Flow)

> **Scope:** BIZ-06 Tiền mặt · BIZ-07 Ví ECO · BIZ-08 Fund · BIZ-09 VietQR

---

## Tổng quan Payment Methods

| Phương thức | Actor chủ động | Xác nhận tức thì? | Portal ECOM API |
|---|---|---|---|
| Tiền mặt | Merchant thu tay | Có (local) | Không cần call |
| Ví ECO (số dư) | Merchant chọn | Có | `POST /payments/wallet` |
| Fund (pre-approved) | Merchant chọn | Có | `POST /payments/fund` |
| VietQR (khách quét) | Khách quét QR | Không (async callback) | `POST /payments/qr` + webhook |
| Loan (Order-based) | Merchant yêu cầu | Không (chờ duyệt) | Xem `05_financial_flow.md` |

---

## BIZ-06: Thanh toán Tiền mặt

### Flow
1. POS tính tổng tiền → Merchant nhập tiền khách đưa
2. App tính tiền thừa → Hiển thị
3. Giao dịch ghi local → `POST /sales` với `paymentMethod: "cash"`
4. **Không có xác nhận từ Portal ECOM** — hoàn toàn local

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| PM-01 | **Tiền mặt không traceable**: Doanh thu tiền mặt chỉ dựa vào POS record. Nếu nhân viên xóa giao dịch sau khi bán → không có audit trail | 🔴 Cao |
| PM-02 | **Báo cáo doanh thu tiền mặt vs ví/QR**: Merchant có thể xem breakdown theo phương thức thanh toán để đối chiếu két tiền mặt cuối ngày không? | 🟠 TB |

---

## BIZ-07: Thanh toán Ví ECO

### Flow
1. Merchant chọn "Thanh toán bằng Ví ECO"
2. `GET /wallet/balance` → hiển thị số dư
3. Nếu đủ số dư → `POST /payments/wallet { orderId, amount }`
4. Output: `{ status: "success", newBalance, transactionId }`
5. Giao dịch hoàn tất → update POS

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| PM-03 | **Ví ECO nạp tiền như thế nào?** Merchant nạp qua đâu (ngân hàng/ATM/cổng)? Quy trình nạp chưa được mô tả | 🟠 TB |
| PM-04 | **Ví dùng cho cả nhập hàng lẫn bán hàng**: Ví có phân tách balance không (balance nhập hàng vs balance khác)? Hay dùng chung? | 🟠 TB |
| PM-05 | **Ví ECO có giới hạn số dư không?** (theo quy định NHNN với ví điện tử: 20M/ngày cho ví thường, 100M với ví định danh) | 🔴 Cao |

---

## BIZ-08: Thanh toán Fund (Pre-approved Balance)

### Flow
1. Merchant đã được cấp Fund limit (ví dụ: 50.000.000đ)
2. Chọn "Thanh toán bằng Fund"
3. `GET /fund/balance { merchantId }` → available balance
4. `POST /payments/fund { orderId, amount }` → tức thì deduct
5. Output: `{ status: "success", usedAmount, remainingFund }`

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| PM-06 | **Fund replenishment**: Fund available = 50M. Merchant dùng 50M mua hàng. Fund về 0. Khi nào Fund được tái cấp? Auto hay Merchant phải apply lại? | 🔴 Cao |
| PM-07 | **Fund expiry**: Fund có hạn sử dụng không? Nếu không dùng trong 6 tháng thì sao? | 🟡 Thấp |
| PM-08 | **Fund vs Loan phân biệt thế nào về kế toán?** Fund là balance sheet item hay off-balance? Merchant có phải trả lãi Fund không? | 🔴 Cao |

---

## BIZ-09: Quét mã VietQR để thu tiền từ khách lẻ

### Flow — Khách quét mã Merchant (Static QR)
```
1. Merchant hiển thị Static VietQR (cố định cho cửa hàng)
2. Khách quét bằng app ngân hàng → chuyển tiền
3. Merchant nhận thông báo từ ngân hàng (SMS/app ngân hàng)
4. Merchant xác nhận thủ công trên POS → hoàn tất giao dịch
```

### Flow — Dynamic QR per Transaction
```
1. POS tính tổng tiền
2. ECO TSH gọi [Portal ECOM API] POST /payments/qr/generate
   Input:  { merchantId, amount, orderId, expiry }
   Output: { qrCode (base64/URL), paymentId, expiry }
3. App hiển thị QR → Khách quét
4. Khách thanh toán → Ngân hàng callback về Portal ECOM webhook
5. Portal ECOM push notification về ECO TSH (hoặc ECO TSH poll)
6. ECO TSH hiển thị "Thanh toán thành công"
```

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| PM-09 | **Static vs Dynamic QR**: Nếu dùng Static QR, merchant không biết chính xác khách đã thanh toán cho giao dịch nào → đối soát thủ công → lỗi cao. Dynamic QR phức tạp hơn nhưng chính xác hơn. Hệ thống dùng loại nào? | 🔴 Cao |
| PM-10 | **QR expiry**: Dynamic QR hết hạn mà khách chưa quét xong → khách thấy gì? Merchant cần generate lại không? | 🟠 TB |
| PM-11 | **Callback thất bại / chậm**: Khách đã thanh toán, ngân hàng confirm nhưng callback về Portal ECOM bị delay → POS treo ở "Đang chờ thanh toán" → Merchant phải đợi hay có thể manual confirm? | 🔴 Cao |
| PM-12 | **Double payment**: Khách quét 2 lần (lỗi người dùng) → Portal ECOM detect duplicate payment không? Hoàn tiền tự động hay manual? | 🔴 Cao |
| PM-13 | **Đối soát VietQR cuối ngày**: Merchant có màn hình đối soát tổng số tiền nhận qua QR trong ngày không? So sánh được với số tiền POS ghi nhận không? | 🟠 TB |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
