# 15 — Actor: Finviet Supply Chain (Nhà cung cấp Finviet tự tìm)

> **Role-play:** Tôi là Anh Bình, Sourcing Manager tại Finviet.  
> Finviet không chỉ kết nối Brand — Finviet còn tự đàm phán với các nhà cung cấp  
> vừa và nhỏ (không có brand mạnh) để đưa vào nền tảng ECO TSH.  
> Đây là "Finviet Supply Chain" — khác hoàn toàn với Brand Supplier đã phân tích.

---

## Phân biệt Brand Supplier vs Finviet Supply Chain

| Tiêu chí | Brand Supplier (Thọ Phát, Acecook) | Finviet Supply Chain |
|---|---|---|
| Brand | Mạnh, tự quản lý | Yếu / không có brand |
| ERP | Có SAP/Misa riêng | Thường không có ERP |
| Whitelist | Brand tự quản lý | Finviet quản lý thay |
| Phân phối | Có distributor network riêng | Dựa vào Finviet logistics |
| Ví dụ | Acecook, Thọ Phát | Cơ sở sản xuất nhỏ, HTX, nông sản |
| Tích hợp hệ thống | OMS ↔ ERP | OMS → Finviet Warehouse |

---

## Hành trình Anh Bình — Onboard Nhà Cung cấp mới (HTX Rau sạch Đà Lạt)

```
Tuần 1 — Đàm phán xong, cần đưa sản phẩm vào hệ thống
       → [ĐIỂM GÃY FS-01] HTX không có ERP, không có API
         Finviet phải NHẬP TAY sản phẩm vào PMS:
         - Tên sản phẩm, mô tả, hình ảnh, giá, đơn vị tính
         - Thuế suất VAT (5% hay 10%?)
         - Ngành hàng, category
         → Nếu có 200 SKU → mất 2-3 ngày nhập tay → error-prone

       → [ĐIỂM GÃY FS-02] Ai phê duyệt sản phẩm trước khi hiển thị cho Merchant?
         - QC: chất lượng sản phẩm (giấy VSATP, CO/CQ...)
         - Legal: nhãn hàng đúng quy định?
         - Pricing: giá có cạnh tranh không?
         → Không có approval workflow trong tài liệu

Tuần 2 — Sản phẩm đã lên hệ thống, Merchant bắt đầu đặt hàng
       → Merchant đặt 50 thùng cà chua
       → OMS tạo đơn → gửi cho... AI?
       → [ĐIỂM GÃY FS-03] OMS gửi đơn đến đâu?
         HTX không có ERP, không có API
         → Finviet nhận đơn từ OMS rồi gọi điện cho HTX?
         → Hay HTX được cấp tài khoản Portal ECOM để xem đơn?
         → Không có "Supplier Portal" cho nhà cung cấp nhỏ
```

---

## Hành trình Anh Bình — Quản lý Tồn kho Kho Finviet

```
Scenario: Finviet tự lấy hàng từ HTX, lưu kho Finviet, rồi giao cho Merchant
         → Đây là mô hình Finviet làm Wholesaler/Distributor

       → [ĐIỂM GÃY FS-04] Kho Finviet quản lý tồn kho như thế nào?
         - Portal ECOM Inventory module: có quản lý kho vật lý của Finviet không?
         - Hay chỉ quản lý "tồn kho tại kho Brand" và "tồn kho tại Merchant"?
         - Kho Finviet là layer thứ 3 chưa được mô tả

       → [ĐIỂM GÃY FS-05] Finviet Supply Chain có nhiều kho không?
         - Kho trung tâm HCM
         - Kho vệ tinh theo vùng (HN, Đà Nẵng?)
         - Mỗi kho có capacity riêng → zone assignment phức tạp hơn

Scenario: Merchant đặt 200 đơn vị, kho Finviet chỉ còn 150
       → [ĐIỂM GÃY FS-06] Hệ thống tự động partial fill hay reject toàn bộ?
         Nếu partial fill: Merchant không được thông báo trước khi confirm đơn
         → Tương tự vấn đề với Brand ERP nhưng control được hơn vì Finviet owns kho
```

---

## Pricing & Margin Management

```
Anh Bình đàm phán mua từ HTX: 5.000đ/kg cà chua
Finviet bán cho Merchant: 7.500đ/kg
Margin Finviet: 50%

       → [ĐIỂM GÃY FS-07] PMS quản lý cost price (giá vốn) riêng với sell price không?
         Nếu không: Finviet không theo dõi được margin per SKU
         → Không có P&L visibility cho Finviet Supply Chain business

       → [ĐIỂM GÃY FS-08] Giá Finviet Supply Chain có thay đổi theo mùa/vùng không?
         Cà chua mùa nghịch giá cao hơn
         Zone HN có thể có giá logistics khác Zone HCM
         → PMS dynamic pricing rule chưa được mô tả
```

---

## Tổng hợp Gaps

| # | Điểm gãy | Mức độ |
|---|---|---|
| FS-01 | Onboarding sản phẩm nhà cung cấp nhỏ (không ERP): phải nhập tay | 🟠 TB |
| FS-02 | Không có approval workflow cho sản phẩm mới (QC, legal, pricing) | 🔴 Cao |
| FS-03 | Nhà cung cấp nhỏ nhận đơn qua kênh nào? Không có Supplier Portal | 🔴 Cao |
| FS-04 | Kho Finviet (layer thứ 3) chưa được mô tả trong Inventory module | 🔴 Cao |
| FS-05 | Finviet có nhiều kho vật lý không? Ảnh hưởng đến zone assignment | 🟠 TB |
| FS-06 | Kho Finviet hết hàng: partial fill hay reject? Merchant được báo không? | 🔴 Cao |
| FS-07 | PMS không có cost price → không tính được margin per SKU | 🟠 TB |
| FS-08 | Dynamic pricing (mùa/vùng) chưa được mô tả | 🟠 TB |

---

## [NEEDS CLARIFICATION]

- **NC-FS1:** Finviet Supply Chain hoạt động theo mô hình nào: Wholesale (tự mua tồn kho) hay Dropship (chuyển đơn cho nhà cung cấp giao thẳng)?
- **NC-FS2:** Finviet có kho vật lý không? Bao nhiêu kho? Vị trí?
- **NC-FS3:** Nhà cung cấp Finviet Supply Chain có được cấp tài khoản Portal ECOM không?


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
