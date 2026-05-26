# 01 — Tổng quan Hệ thống & Kiến trúc Module

> **Scope:** Xác định rõ ranh giới module, actors, và giao thức tương tác giữa ECO TSH (mobile) và Portal ECOM (blackbox API).

---

## 1. Kiến trúc Tổng quan

```
┌─────────────────────────────────────────────────┐
│              ECO TSH (Mobile App)               │
│  - UI/UX cho Merchant                           │
│  - Offline-capable POS                          │
│  - Local state (giỏ hàng, session, cache kho)   │
└────────────────────┬────────────────────────────┘
                     │ HTTPS / REST API
                     │ (JWT Auth)
┌────────────────────▼────────────────────────────┐
│           Portal ECOM  ← BLACKBOX               │
│  INPUT:  API requests từ ECO TSH                │
│  OUTPUT: JSON responses (products, orders,      │
│          inventory, payment status, invoices)   │
│  ─────────────────────────────────────────────  │
│  Internal modules (KHÔNG quan tâm chi tiết):    │
│  PMS · OMS · Inventory · USCR · Finance Engine  │
│  ERP Sync · Invoice Engine · Report Engine      │
└──────┬────────────────────────┬─────────────────┘
       │                        │
  ┌────▼─────┐           ┌──────▼──────┐
  │ ERP Brand│           │ Finviet     │
  │ (3rd party│          │ Finance API │
  │ blackbox) │          │ (Loan/Fund) │
  └──────────┘           └─────────────┘
```

---

## 2. Actors & Vai trò

| Actor | Thiết bị / Interface | Quyền hạn chính |
|---|---|---|
| **Merchant – Chủ tiệm** | ECO TSH mobile | Đặt đơn nhập, bán hàng POS, xem báo cáo, yêu cầu vay |
| **Nhân viên bán hàng** | ECO TSH mobile (role: Staff) | Bán hàng POS, quét mã, thu tiền mặt |
| **Quản lý cửa hàng** | ECO TSH mobile (role: Manager) | Xem báo cáo, duyệt đơn nhập nội bộ |
| **Finviet Admin** | Portal ECOM Web | Cấu hình hệ thống, phân quyền, quản lý Brand |
| **Brand Supplier** | Portal ECOM Web (Brand view) | Upload sản phẩm, whitelist Merchant, xem đơn hàng |
| **Hệ thống ERP Brand** | API/File exchange | Tiếp nhận đơn từ OMS, phản hồi trạng thái (hạn chế) |
| **Khách lẻ (End Consumer)** | Không có app | Trả tiền mặt / QR cho Merchant |

---

## 3. API Contract: ECO TSH → Portal ECOM

### 3.1 Các nhóm API chính (Blackbox Input/Output)

| Nhóm API | Input từ ECO TSH | Output từ Portal ECOM |
|---|---|---|
| **Product Catalog API** | merchantId, location, category | Danh sách sản phẩm (lọc theo zone + whitelist) |
| **Order API** | Cart items, paymentMethod, merchantId | orderId, orderStatus, paymentInstruction |
| **Inventory API** | merchantId, productIds | Số lượng tồn kho hiện tại tại kho merchant |
| **Payment API** | orderId, amount, method (wallet/fund/loan/qr) | paymentStatus, transactionId |
| **Loan API** | orderId, requestedAmount | loanStatus (pending/approved/rejected), loanId |
| **Invoice API** | saleId, buyerInfo, items | invoiceId, invoiceUrl (PDF/XML) |
| **Report API** | merchantId, dateRange, reportType | Aggregated data (sales, tax, inventory) |
| **Auth API** | credentials | JWT token, refreshToken, userProfile + roles |

### 3.2 Điểm chưa rõ trong API Contract

- **[GAP-API-01]** Không rõ authentication flow: JWT hay API Key? Token expiry và refresh strategy khi app ở foreground bán hàng liên tục?
- **[GAP-API-02]** Inventory API là real-time hay cached? Nếu Merchant offline và POS ghi tồn kho local, sync conflict resolution khi online lại là gì?
- **[GAP-API-03]** Không có WebSocket/SSE event feed — Merchant không nhận được push notification khi đơn hàng thay đổi trạng thái từ OMS.
- **[GAP-API-04]** Error code taxonomy chưa định nghĩa — ECO TSH hiển thị lỗi như thế nào khi Portal ECOM trả về 4xx/5xx?

---

## 4. Danh sách Nghiệp vụ Chính (Master List)

| Mã NV | Tên nghiệp vụ | Module chính | File chi tiết |
|---|---|---|---|
| BIZ-01 | Đăng ký & Onboarding Merchant | Auth + USCR | `02_inbound_flow.md` |
| BIZ-02 | Duyệt danh mục & Đặt đơn nhập hàng | PMS + OMS | `02_inbound_flow.md` |
| BIZ-03 | Xác nhận nhận hàng & Cập nhật kho | OMS + Inventory | `02_inbound_flow.md` |
| BIZ-04 | Bán hàng lẻ qua Mini POS | POS local | `03_pos_sales_flow.md` |
| BIZ-05 | Quản lý tồn kho tại điểm bán | Inventory | `03_pos_sales_flow.md` |
| BIZ-06 | Thanh toán bằng tiền mặt | POS local | `04_payment_flow.md` |
| BIZ-07 | Thanh toán bằng Ví ECO (số dư) | Payment API | `04_payment_flow.md` |
| BIZ-08 | Thanh toán bằng Fund (pre-approved) | Finance API | `04_payment_flow.md` |
| BIZ-09 | Quét mã VietQR để thu tiền từ khách | Payment API | `04_payment_flow.md` |
| BIZ-10 | Yêu cầu khoản Loan theo đơn hàng | Loan API | `05_financial_flow.md` |
| BIZ-11 | Giải ngân Loan & Hoàn trả Loan | Finance Engine | `05_financial_flow.md` |
| BIZ-12 | Xuất hóa đơn điện tử cho khách lẻ | Invoice API | `06_invoice_tax_flow.md` |
| BIZ-13 | Lập bảng kê & Kê khai thuế cuối kỳ | Report API | `06_invoice_tax_flow.md` |
| BIZ-14 | Hủy đơn nhập / Đổi trả hàng | OMS + Finance | `07_gaps_edge_cases.md` |
| BIZ-15 | Phân quyền Staff / Manager / Owner | USCR | `01_system_overview.md` |
| BIZ-16 | Đối soát GMV & Reconciliation định kỳ | OMS + Finance | `07_gaps_edge_cases.md` |

---

## 5. [NEEDS CLARIFICATION]

- **NC-01:** Merchant có thể sử dụng ECO TSH khi không có kết nối mạng không? Nếu có, phạm vi offline là gì (chỉ POS bán hàng, hay cả đặt đơn nhập)?
- **NC-02:** Một Merchant có thể quản lý nhiều cửa hàng (nhiều địa điểm) trên cùng một tài khoản không?
- **NC-03:** Brand Supplier có app mobile riêng hay chỉ dùng Portal ECOM Web?
- **NC-04:** Phiên bản MVP có hỗ trợ đầy đủ 16 nghiệp vụ trên không, hay chỉ một subset?


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
