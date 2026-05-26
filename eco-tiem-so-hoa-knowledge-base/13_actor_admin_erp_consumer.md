# 13 — Actor: Finviet Admin · ERP System · Khách lẻ

---

## A. Finviet Admin (Chị Hương — Ops Manager)

### Gaps

| # | Điểm gãy | Mức độ |
|---|---|---|
| A-01 | Không có SLA target cho KYC approval | 🟠 TB |
| A-02 | Whitelist Merchant phải import thủ công → error-prone (~300 records/Brand) | 🔴 Cao |
| A-03 | Không có real-time monitoring cho bán âm / anomaly | 🔴 Cao |
| A-04 | **CRITICAL**: Deactivate Brand không cảnh báo đơn hàng đang xử lý → orphan orders + bad debt | 🔴 Cao |
| A-05 | Không có diagnostic tool: tại sao Merchant không thấy sản phẩm X? | 🟠 TB |
| A-06 | Không có audit log khi Admin thay đổi cấu hình Brand/Zone/Whitelist | 🔴 Cao |

### Kịch bản nguy hiểm

```
Admin deactivate Brand Y (hợp đồng hết hạn)
  → 15 đơn đang xử lý tại OMS → trở thành orphan
  → Loan đã giải ngân cho 8 đơn đó
  → Merchant không nhận hàng → khiếu nại
  → Finviet phải xử lý thủ công từng đơn
  → Không có playbook cho tình huống này
```

---

## B. Hệ thống ERP Brand (System Actor)

### Gaps

| # | Điểm gãy | Mức độ |
|---|---|---|
| ERP-01 | Protocol tích hợp chưa chuẩn hóa: REST/SOAP/EDI/File per Brand | 🔴 Cao |
| ERP-02 | Không có data contract chuẩn (field names, encoding, nullable) | 🔴 Cao |
| ERP-03 | ERP không support real-time webhook → OMS phải poll → lag | 🟠 TB |
| ERP-04 | ERP adjust/cancel đơn không gửi event về OMS → silent failure | 🔴 Cao |
| ERP-05 | ERP maintenance window → đơn bị kẹt bao lâu? Không có SLA | 🟠 TB |

---

## C. Khách lẻ — End Consumer (Anh Nam)

### Gaps

| # | Điểm gãy | Mức độ |
|---|---|---|
| C-01 | Double-charge QR: khách không có bằng chứng từ merchant side | 🟠 TB |
| C-02 | HĐ điện tử: Staff không biết xuất → khách chờ lâu | 🟠 TB |
| C-03 | Đổi hàng tại quầy không ghi nhận vào POS → tồn kho sai âm thầm | 🔴 Cao |

---

## TỔNG HỢP TẤT CẢ ACTOR GAPS

| Actor | File | Gaps | Critical 🔴 |
|---|---|:---:|:---:|
| Store Owner | `10_actor_store_owner.md` | 10 | 8 |
| Staff | `11_actor_staff.md` | 7 | 4 |
| Brand Supplier | `12_actor_brand_supplier.md` | 9 | 7 |
| Finviet Admin | `13_actor_admin_erp_consumer.md` | 6 | 4 |
| ERP System | `13_actor_admin_erp_consumer.md` | 5 | 3 |
| End Consumer | `13_actor_admin_erp_consumer.md` | 3 | 1 |
| **TỔNG** | | **40** | **27** |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
