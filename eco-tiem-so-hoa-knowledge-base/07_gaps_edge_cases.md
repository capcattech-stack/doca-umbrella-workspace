# 07 — Gaps Tổng hợp, Edge Cases & Risk Matrix

> **Scope:** BIZ-14 Hủy đơn/Đổi trả · BIZ-16 Reconciliation  
> + Consolidated gaps từ tất cả các file 01–06

---

## BIZ-14: Hủy đơn nhập / Đổi trả hàng (Cập nhật từ PO)

> **Quyết định từ PO:** Hiện tại hệ thống **KHÔNG CHẤP NHẬN** nghiệp vụ Đổi trả/Điều chỉnh đơn hàng (Return/Modify). Thay vào đó, áp dụng workaround: **Hủy đơn cũ và Tạo đơn mới**.

### Luồng Hủy đơn (Cancellation Flow)
```
1. Merchant yêu cầu hủy đơn hàng.
2. Nếu đơn hàng thanh toán bằng Fund hoặc Loan:
   - Hệ thống thực hiện nghiệp vụ hủy giao dịch Fund hoặc Loan tương ứng.
3. Phê duyệt hủy đơn (từ phía hệ thống/Brand).
4. Hoàn trả hạn mức:
   - Đối với Fund: Hạn mức sẽ được hoàn trả lại cho Merchant SAU KHI yêu cầu hủy được duyệt.
   - Đối với Loan: Khoản vay bị hủy, không phát sinh nghĩa vụ nợ.
```

### Gaps đã được giải quyết / Workaround
| # | Vấn đề | Quyết định / Cập nhật |
|---|---|---|
| R-01 | **Luồng Đổi trả phức tạp** | Đã chốt: **Không làm luồng Đổi trả/Điều chỉnh**. Merchant phải hủy đơn và tạo đơn mới. |
| R-03 | **Hoàn tiền Fund** | Hoàn trả hạn mức ngay **sau khi yêu cầu hủy được duyệt**. |
| R-04 | **Hủy Loan** | Hủy giao dịch Loan tương ứng với đơn hàng. |

---

## BIZ-16: Đối soát GMV & Reconciliation định kỳ

### Flow
```
1. Portal ECOM chạy reconciliation job (schedule: hàng ngày/tuần - chưa rõ)
2. So sánh:
   - OMS order value ↔ ERP actual fulfilled value
   - POS sales log ↔ Invoice list
   - Fund/Loan disbursed ↔ Order value thực tế
3. Phát hiện sai lệch → tạo dispute record
4. Finviet Admin review dispute
5. Điều chỉnh: hoàn Fund/Loan chênh lệch / update GMV
6. Merchant nhận notification về kết quả đối soát
```

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| RC-01 | **Chu kỳ đối soát chưa định nghĩa**: T+1? T+7? Merchant không biết khi nào số liệu chính xác | 🔴 Cao |
| RC-02 | **Merchant không thấy được dispute record**: Reconciliation chỉ ở backend → Merchant không có visibility vào sai lệch đang được xử lý | 🟠 TB |
| RC-03 | **ERP Brand không báo trạng thái** → reconciliation phải dựa vào gì? Manual confirmation từ Brand? File exchange? | 🔴 Cao |

---

## CONSOLIDATED EDGE CASES — Top Priority

| # | Edge Case | Hệ thống xử lý? | Risk |
|---|---|---|---|
| EC-01 | (Đã chốt) Rủi ro đồng bộ ERP khi vay Loan | ✅ Đã chốt: Fund/Loan CHỈ áp dụng cho chuỗi SLC của FV, không áp dụng cho đơn hàng API partner. Không còn rủi ro. | 🟢 Closed |
| EC-02 | POS offline → bán 100 giao dịch → online lại → sync conflict với Portal ECOM (tồn kho lệch) | ❌ Chưa có | 🔴 Inventory mismatch |
| EC-03 | Merchant vừa nằm trong whitelist Brand A vừa ở ranh giới 2 Distribution Zone → đơn routing sai | ❌ Chưa có | 🔴 Wrong delivery |
| EC-04 | (Đã chốt) Lỗi thanh toán Mix payment | ✅ Đã chốt: FV không hỗ trợ thanh toán hỗn hợp (mỗi đơn chỉ 1 PTTT). Không còn rủi ro này. | 🟢 Closed |
| EC-05 | QR payment: khách đã chuyển tiền, callback thất bại → POS chờ mãi → Merchant phải xử lý thủ công | ❌ Chưa có | 🔴 Reconciliation |
| EC-06 | Bán âm gây lệch báo cáo thuế | ✅ Đã chốt: Hệ thống cấm bán âm thực tế, rủi ro này đã được loại bỏ. | 🟢 Closed |
| EC-07 | HĐ điện tử đã phát hành, khách trả hàng → cần HĐ điều chỉnh → ECO TSH không có luồng này | ❌ Chưa có | 🔴 Legal |
| EC-08 | Finviet Admin vô hiệu hóa Brand trong khi có đơn đang xử lý tại OMS | ❌ Chưa có | 🔴 Orphan orders |
| EC-09 | 2 nhân viên cùng bán item cuối cùng cùng lúc trên 2 thiết bị | ❌ Chưa có | 🟠 Oversell |
| EC-10 | NPP có nhiều kho: Hệ thống hiện tại không hỗ trợ quản lý kho cho NPP, không thể tách đơn để điều phối về các kho khác nhau của cùng 1 NPP. | ❌ Chưa có | 🟠 Fulfillment |

---

## MASTER RISK MATRIX

| Mã | Rủi ro | Likelihood | Impact | Score | Mitigation |
|---|---|:---:|:---:|:---:|---|
| RM-01 | Rủi ro ERP confirm Loan | - | - | 🟢 OK | Fund/Loan không áp dụng cho Brand API, chỉ áp dụng cho nội bộ SLC FV. |
| RM-02 | Tax compliance vi phạm NĐ70 (bảng kê sai source) | TB | Rất cao | 🔴 8 | POS log = source of truth |
| RM-03 | Bán âm vô hạn → kho âm → báo cáo vô nghĩa | - | - | 🟢 OK | Quy tắc: Hệ thống cấm bán âm kho thực tế. Bắt buộc có đủ kho mới được duyệt bán. |
| RM-04 | QR callback fail → giao dịch treo | TB | Cao | 🟠 7 | Timeout + manual confirm |
| RM-05 | Offline POS sync conflict | TB | Cao | 🟠 7 | Last-write-wins + conflict UI |
| RM-06 | Mixed payment lock | - | - | 🟢 OK | Không hỗ trợ thanh toán hỗn hợp. |
| RM-07 | Không có luồng Return → tài chính không điều chỉnh được | - | - | ✅ OK | Workaround: Không cho phép Return, bắt buộc Hủy & Tạo đơn mới |
| RM-08 | HĐ điện tử không có luồng điều chỉnh/hủy | Cao | Cao | 🔴 9 | Implement trước khi launch |

---

## NEEDS CLARIFICATION — Master List

| # | Câu hỏi | Owner | Priority |
|---|---|---|---|
| NC-01 | SLA KYC duyệt Merchant: bao lâu? Auto hay manual? | Product Owner | P0 |
| NC-02 | (Đã chốt) Đơn hàng ECOM: trạng thái "Đã thanh toán" mới chuyển "Đã xác nhận mua". | Tech Lead | P0 |
| NC-03 | Bảng kê thuế: POS log hay Invoice list là source of truth? | Legal + Product | P0 |
| NC-04 | Return/Refund flow: có trong scope V1 không? | Product Owner | P0 |
| NC-05 | Mini POS có hoạt động offline không? Sync strategy? | Tech Lead | P0 |
| NC-06 | Fund hoàn trả cơ chế nào? Có lãi không? | Finance | P0 |
| NC-07 | Static hay Dynamic QR cho thu tiền khách lẻ? | Product + Tech | P1 |
| NC-08 | Multi-store (nhiều địa chỉ) dưới 1 tài khoản không? | Product | P1 |
| NC-09 | NPP có đa kho: Có bổ sung logic quản lý kho và tách đơn theo kho của NPP không? | Tech Lead | P1 |
| NC-10 | Thuế suất VAT: PMS có gắn per-SKU không? | Tech Lead | P1 |

---

## File Index — Toàn bộ Knowledge Base

| File | Nội dung | Nghiệp vụ |
|---|---|---|
| `business_flow.md` | Tổng quan gốc + BA Review | Tất cả |
| `01_system_overview.md` | Kiến trúc, Actors, API contract, Master list NV | BIZ-15 |
| `02_inbound_flow.md` | Đặt đơn nhập, Onboarding, Nhận hàng | BIZ-01,02,03 |
| `03_pos_sales_flow.md` | Bán hàng Mini POS, Quản lý kho | BIZ-04,05 |
| `04_payment_flow.md` | Tiền mặt, Ví, Fund, VietQR | BIZ-06,07,08,09 |
| `05_financial_flow.md` | Loan lifecycle, Fund lifecycle | BIZ-10,11 |
| `06_invoice_tax_flow.md` | HĐ điện tử, Bảng kê thuế | BIZ-12,13 |
| `07_gaps_edge_cases.md` | Hủy đơn, Reconciliation, Edge Cases, Risk Matrix | BIZ-14,16 |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
