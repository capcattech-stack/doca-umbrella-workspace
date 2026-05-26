# 📚 ECO TSH — Knowledge Base Index

> **Entry point** cho toàn bộ tài liệu phân tích nghiệp vụ hệ thống ECO Tiệm Số Hóa (Finviet).  
> Mở file này trước — từ đây điều hướng sang file phù hợp với nghiệp vụ cần tra cứu.  
> **Cập nhật:** 2026-04-28

---

## 🗂️ Cấu trúc File

```text
analysis/
├── README.md                  ← BẠN ĐANG Ở ĐÂY (Entry point)
├── 00_eco_tsh_overview.md     ← Tổng quan nghiệp vụ gốc (tóm tắt điều hành)
├── 00_ba_review.md            ← BA Review: gaps, risks, câu hỏi phản biện
├── 01_system_overview.md      ← Kiến trúc hệ thống, API contract
├── 02_inbound_flow.md         ← Nhập hàng: Onboarding → Đặt đơn → Nhận hàng
├── 03_pos_sales_flow.md       ← Bán hàng: Mini POS → Tồn kho
├── 04_payment_flow.md         ← Thanh toán: Tiền mặt / Ví / Fund / VietQR
├── 05_financial_flow.md       ← Tài chính: Loan lifecycle / Fund lifecycle
├── 06_invoice_tax_flow.md     ← Hóa đơn điện tử & Báo cáo thuế (NĐ70/2025)
├── 07_gaps_edge_cases.md      ← Hủy đơn, Edge cases, Risk matrix tổng hợp
├── 10_actor_store_owner.md    ← Role-play: Chủ tiệm
├── 11_actor_staff.md          ← Role-play: Nhân viên bán hàng
├── 12_actor_brand_supplier.md ← Role-play: Nhà cung cấp Brand
├── 13_actor_admin_erp_consumer.md ← Role-play: Admin, ERP, Khách lẻ
├── 14_actor_distributor.md    ← Role-play: Nhà phân phối & Shipper
├── 15_actor_finviet_supply_chain.md ← Role-play: Finviet Supply Chain
├── 16_actor_credit_cs.md      ← Role-play: Nhân viên Tín dụng & CS
└── 17_actor_discovery_list.md ← Discovery: Danh sách 19 Actors
```

---

## 🔍 Tra cứu theo Nghiệp vụ (BIZ Code)

| Mã NV | Tên nghiệp vụ | File | Priority |
|---|---|---|:---:|
| BIZ-01 | Đăng ký & Onboarding Merchant | [02_inbound_flow.md](02_inbound_flow.md) | P0 |
| BIZ-02 | Đặt đơn nhập hàng | [02_inbound_flow.md](02_inbound_flow.md) | P0 |
| BIZ-03 | Xác nhận nhận hàng & Cập nhật kho | [02_inbound_flow.md](02_inbound_flow.md) | P0 |
| BIZ-04 | Bán hàng lẻ qua Mini POS | [03_pos_sales_flow.md](03_pos_sales_flow.md) | P0 |
| BIZ-05 | Quản lý tồn kho điểm bán | [03_pos_sales_flow.md](03_pos_sales_flow.md) | P1 |
| BIZ-06 | Thanh toán Tiền mặt | [04_payment_flow.md](04_payment_flow.md) | P0 |
| BIZ-07 | Thanh toán Ví ECO | [04_payment_flow.md](04_payment_flow.md) | P0 |
| BIZ-08 | Thanh toán Fund (pre-approved) | [04_payment_flow.md](04_payment_flow.md) | P0 |
| BIZ-09 | Thu tiền qua VietQR | [04_payment_flow.md](04_payment_flow.md) | P0 |
| BIZ-10 | Yêu cầu khoản Loan theo đơn | [05_financial_flow.md](05_financial_flow.md) | P0 |
| BIZ-11 | Giải ngân & Hoàn trả Loan | [05_financial_flow.md](05_financial_flow.md) | P1 |
| BIZ-12 | Xuất hóa đơn điện tử | [06_invoice_tax_flow.md](06_invoice_tax_flow.md) | P0 |
| BIZ-13 | Lập bảng kê & Kê khai thuế | [06_invoice_tax_flow.md](06_invoice_tax_flow.md) | P1 |
| BIZ-14 | Hủy đơn / Đổi trả hàng | [07_gaps_edge_cases.md](07_gaps_edge_cases.md) | P0 |
| BIZ-15 | Phân quyền Staff/Manager/Owner | [01_system_overview.md](01_system_overview.md) | P1 |
| BIZ-16 | Đối soát GMV & Reconciliation | [07_gaps_edge_cases.md](07_gaps_edge_cases.md) | P1 |

---

## 🎭 Phân tích Actor Role-Play

| Mã Role | Tên Actor | File | Priority |
|---|---|---|:---:|
| R-01 | Store Owner (Chủ tiệm) | [10_actor_store_owner.md](10_actor_store_owner.md) | P0 |
| R-02 | Staff (Nhân viên) | [11_actor_staff.md](11_actor_staff.md) | P0 |
| R-03 | Brand Supplier | [12_actor_brand_supplier.md](12_actor_brand_supplier.md) | P0 |
| R-04 | Admin / ERP / Consumer | [13_actor_admin_erp_consumer.md](13_actor_admin_erp_consumer.md) | P0/P1 |
| R-05 | Distributor & Shipper | [14_actor_distributor.md](14_actor_distributor.md) | P0 |
| R-06 | Finviet Supply Chain | [15_actor_finviet_supply_chain.md](15_actor_finviet_supply_chain.md) | P0 |
| R-07 | Credit Officer & CS | [16_actor_credit_cs.md](16_actor_credit_cs.md) | P0 |
| R-ALL | **Discovery List (19 Actors)** | [17_actor_discovery_list.md](17_actor_discovery_list.md) | ALL |

---

## ⚠️ Top Gaps cần giải quyết TRƯỚC khi dev

| Mã | Vấn đề cốt lõi | File chi tiết |
|---|---|---|
| **RM-01** 🟢 | **Rủi ro Loan với ERP Partner** | Đã chốt: Fund/Loan không áp dụng cho Partner API. Đơn nội bộ chỉ duyệt sau khi thanh toán. |
| **RM-07** 🔴 | Hoàn toàn **thiếu luồng Hủy đơn/Đổi trả** → Fund/Loan không điều chỉnh được | [07_gaps_edge_cases.md](07_gaps_edge_cases.md) |
| **RM-08** 🔴 | **Thiếu luồng điều chỉnh/hủy HĐ điện tử** → vi phạm NĐ70/2025 | [06_invoice_tax_flow.md](06_invoice_tax_flow.md) |
| **RM-02** 🔴 | Bảng kê thuế phải dựa trên **POS log**, không phải danh sách HĐ | [06_invoice_tax_flow.md](06_invoice_tax_flow.md) |
| **RM-03** 🟢 | **Bán âm vô hạn** | Đã xử lý: Cấm bán âm kho thực tế, chỉ cho phép Pre-order. |
| **I-07** 🟢 | **Mixed payment** | Đã chốt: KHÔNG hỗ trợ Mixed payment. |
| **I-11** 🟠 | **NPP có nhiều kho**: Hệ thống không hỗ trợ tách đơn về từng kho của 1 NPP. | [02_inbound_flow.md](02_inbound_flow.md) |
| **P-01** 🔴 | **Offline POS**: sync strategy khi mạng phục hồi chưa định nghĩa | [03_pos_sales_flow.md](03_pos_sales_flow.md) |
| **PM-09** 🔴 | **Static vs Dynamic QR**: chưa quyết định → đối soát không khớp | [04_payment_flow.md](04_payment_flow.md) |
| **T-06** 🔴 | **Series hóa đơn**: per-Merchant hay dùng chung series Finviet? | [06_invoice_tax_flow.md](06_invoice_tax_flow.md) |

---

## ❓ Needs Clarification — Master List (P0)

| # | Câu hỏi | Owner |
|---|---|---|
| NC-01 | SLA duyệt KYC Merchant: bao lâu? Auto hay manual? | Product Owner |
| NC-02 | **OMS sync với ERP / Loan** | Đã chốt: Không dùng Loan cho Partner. ECOM xác nhận đơn sau khi thanh toán xong. |
| NC-03 | Bảng kê thuế source of truth: **POS log hay Invoice list**? | Legal + Product |
| NC-04 | Luồng Return/Refund có trong **scope V1** không? | Product Owner |
| NC-05 | Mini POS có hoạt động **offline** không? Sync strategy? | Tech Lead |
| NC-06 | Fund hoàn trả cơ chế nào? Có tính lãi không? | Finance |
| NC-07 | **Static hay Dynamic QR** cho thu tiền khách lẻ? | Product + Tech |
| NC-08 | **Multi-store** (nhiều địa chỉ) dưới 1 tài khoản không? | Product |
| NC-09 | **NPP có đa kho**: Có bổ sung logic tách đơn theo kho của NPP không? | Tech Lead |
| NC-10 | **Thuế suất VAT per-SKU**: PMS có gắn thuế suất không? | Tech Lead |

---

## 🏗️ Kiến trúc tóm tắt

```
ECO TSH (Mobile)  ──HTTPS/REST──►  Portal ECOM (Blackbox API)
                                         │
                              ┌──────────┼──────────┐
                           ERP Brand   Finance    CQT
                           (3rd party)  Engine   (Thuế)
```

**Portal ECOM là blackbox** — ECO TSH chỉ quan tâm đến Input/Output API, không phụ thuộc vào chi tiết nội bộ.

Xem chi tiết API contract: [01_system_overview.md → Section 3](01_system_overview.md)

---

## 🚦 Trạng thái phân tích

| Nhóm nghiệp vụ | Phân tích | Gaps xác định | NC còn mở |
|---|:---:|:---:|:---:|
| Inbound (Nhập hàng) | ✅ | 11 gaps | 3 |
| POS / Outbound (Bán hàng) | ✅ | 12 gaps | 2 |
| Payment (Thanh toán) | ✅ | 13 gaps | 2 |
| Financial (Tài chính) | ✅ | 10 gaps | 2 |
| Invoice / Tax | ✅ | 11 gaps | 1 |
| Return / Reconciliation | ⚠️ Sơ bộ | 8 gaps | 0 |
| Notification System | ❌ Chưa phân tích | — | — |
| Reporting / Analytics | ❌ Chưa phân tích | — | — |
