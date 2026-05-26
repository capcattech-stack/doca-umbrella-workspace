# 02 — Luồng Nhập hàng (Inbound / Purchase Order Flow)

> **Scope:** BIZ-01 Onboarding · BIZ-02 Đặt đơn nhập · BIZ-03 Nhận hàng & cập nhật kho

---

## BIZ-01: Onboarding Merchant

### Happy Path
1. Mở ECO TSH → Đăng ký SĐT → OTP
2. Nhập thông tin: tên tiệm, địa chỉ, loại hình KD
3. Upload KYC (CCCD / Giấy phép KD)
4. `POST /merchants/register` → `{ status: "pending_review" | "approved" }`
5. Nếu approved → vào Home; nếu pending → chờ Finviet Admin duyệt

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| I-01 | SLA duyệt KYC chưa định nghĩa (auto hay manual?) | 🔴 Cao |
| I-02 | Địa chỉ sai → sai Distribution Zone → sai danh mục. Validate địa chỉ ra sao? | 🔴 Cao |
| I-03 | Merchant thay đổi địa chỉ sau khi approved → có re-evaluate zone + whitelist không? | 🔴 Cao |
| I-04 | Tiệm không đăng ký HKD vẫn onboard được không? Giới hạn tính năng ra sao? | 🟠 TB |

---

## BIZ-02: Đặt đơn nhập hàng

### Happy Path
1. Mở màn hình Nhập hàng → `GET /products/catalog?merchantId&location&businessType`
2. Browse sản phẩm (đã lọc zone + whitelist + businessType)
3. Thêm vào giỏ hàng (local state)
4. Chọn thanh toán: Ví / Cổng / Fund / Loan / Mix
5. `POST /orders { merchantId, items[], paymentMethod }` → `{ orderId, status }`
6. Nếu Fund/Ví: confirm ngay → Synced to ERP
7. Nếu Loan: status = `pending_loan_approval` → xem BIZ-10
8. Merchant xem trạng thái đơn trên app

### Order State Machine
```
Draft → Pending Payment → [Confirmed | Payment Failed]
                                  ↓
                        [Pending Loan Approval]
                                  ↓
                           Synced to ERP
                           ↙           ↘
              Partially Fulfilled    Fulfilled
                           ↓
                        Cancelled
```

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| I-06 | (Đã chốt) Mix payment | ✅ Hệ thống KHÔNG hỗ trợ thanh toán hỗn hợp hay thanh toán 1 phần. | 🟢 Closed |
| I-07 | (Đã chốt) OMS sync: Fund/Loan không áp dụng cho đơn API Partner (chỉ nội bộ SLC). Đơn ECOM chỉ chuyển "Xác nhận mua" sau khi đã thanh toán. | 🟢 Closed |
| I-08 | Catalog API có cache không? Đặt hàng nhưng hết hàng thực tế → OMS reject muộn | 🟠 TB |
| I-09 | Giỏ hàng local bị mất khi app crash giữa chừng? | 🟠 TB |
| I-11 | **(Đã giải quyết 1 phần)** Giỏ hàng tự tách theo Nhà Phân Phối (NPP), nên không cần OMS tách sub-order. Tuy nhiên **chưa hỗ trợ đa kho** cho NPP (đơn 1 NPP nhưng hàng nằm ở nhiều kho thì hệ thống không tách được). | 🟠 TB |

---

## BIZ-03: Xác nhận nhận hàng & Cập nhật kho

### Happy Path
1. Nhà phân phối giao hàng tại cửa hàng
2. Merchant mở ECO TSH → "Đơn đang giao"
3. Kiểm tra hàng thực tế
4. Xác nhận: nhận đủ / nhận thiếu / không nhận
5. `PUT /orders/{id}/receive { receivedItems[], actualQty[] }` → inventory updated
6. ECO TSH cập nhật POS local inventory (cộng vào tồn kho hiện tại)

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| I-12 | Tồn kho = -50 (đã bán âm) → nhập 100 → hệ thống có alert "bạn đã bán trước 50 đơn vị" không? | 🔴 Cao |
| I-13 | Staff nhận hàng thay Chủ tiệm → hệ thống log ai xác nhận không? Tranh chấp giải quyết thế nào? | 🔴 Cao |
| I-14 | Không có tính năng chụp ảnh bằng chứng giao nhận → không có evidence khi tranh chấp | 🟠 TB |
| I-15 | Không có SLA giao hàng + alert khi đơn quá hạn | 🟠 TB |
| I-16 | Partial delivery: phần còn lại giao tiếp hay hủy? Fund/Loan điều chỉnh ra sao? | 🔴 Cao |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
