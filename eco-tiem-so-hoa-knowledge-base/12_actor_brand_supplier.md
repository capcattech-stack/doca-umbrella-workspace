# 12 — Actor: Nhà cung cấp Brand (Brand Supplier)

> **Role-play:** Tôi là Anh Khoa, Key Account Manager tại Thọ Phát.  
> Thọ Phát đã ký hợp đồng với Finviet để phân phối hàng qua ECO TSH.  
> ERP của Thọ Phát là SAP B1, tích hợp với Portal ECOM qua REST API.

---

## Mục tiêu & Kỳ vọng

| Mục tiêu | Kỳ vọng vào ECO ecosystem |
|---|---|
| Tăng độ phủ kênh GT | Tiếp cận hàng nghìn tiệm tạp hóa qua 1 nền tảng |
| Bảo vệ kênh phân phối hiện tại | Non-cross-selling: chỉ tiệm trong whitelist Thọ Phát mới đặt được |
| Nhận đơn hàng tự động | OMS → SAP sync không cần nhập tay |
| Theo dõi doanh số | Dashboard số lượng đơn, GMV theo vùng |

---

## Hành trình Anh Khoa — Setup ban đầu

```
Tuần 1 — Ký hợp đồng xong, IT team Thọ Phát tích hợp SAP với Portal ECOM
       → [VẤN ĐỀ B-01] Portal ECOM cung cấp tài liệu API dạng gì?
         Swagger/OpenAPI? PDF? Không có trong tài liệu nào đề cập
         → IT Thọ Phát mù thông tin, phải chờ Finviet Tech support

       → [ĐÃ CHỐT B-02] Quản lý bảo hộ bán chéo (Bộ Lọc Cạnh tranh)
         - Tính năng này do **Finviet Admin** cấu hình dựa trên thương lượng bảo hộ với Brand.
         - Cửa hàng nhánh của Thọ Phát sẽ chỉ thấy/bán hàng của Thọ Phát.
         - Nếu được phép mua chéo ngành hàng khác, cửa hàng vẫn bị bộ lọc ẩn đi các sản phẩm cạnh tranh trực tiếp với Thọ Phát.
         → Brand không tự cấu hình self-service.

Tuần 2 — Tích hợp xong, Anh Khoa muốn xem test đơn hàng đầu tiên
       → [ĐIỂM GÃY B-03] Không có môi trường Sandbox/Test
         Phải test trực tiếp trên Production với Merchant thật
         → Rủi ro: đơn test bị tính vào GMV thật
```

---

## Hành trình Anh Khoa — Vận hành hàng ngày

```
09:00 — Anh Khoa muốn xem đơn hàng hôm nay từ các tiệm trong hệ thống
       → Mở Portal ECOM → Dashboard Brand View
       → [ĐIỂM GÃY B-04] Portal ECOM có Brand View riêng không?
         Hay chỉ có Admin View của Finviet?
         Nếu không có Brand View: Anh Khoa không tự xem được đơn

10:00 — OMS gửi đơn hàng sang SAP của Thọ Phát
       → SAP nhận đơn, team kho bắt đầu xử lý
       → [VẤN ĐỀ B-05] OMS gửi đơn theo format gì?
         SAP B1 cần: purchase order XML với item code, quantity, delivery address
         Nếu format không khớp → import error → đơn bị treo trong SAP
         Team kho không thấy đơn → không xử lý → Merchant chờ vô thời hạn

10:30 — Kho Thọ Phát xử lý đơn, phát hiện hết hàng sản phẩm A
       → [ĐIỂM GÃY B-06] SAP Thọ Phát cancel/adjust đơn
         OMS có nhận được event "OrderAdjusted" từ SAP không?
         Tài liệu nói "bi-directional sync" nhưng thực tế ERP thường không báo về
         → Merchant không được thông báo → chờ mãi → tự hỏi đơn đi đâu

14:00 — Giao hàng xong, shipper về
       → [ĐIỂM GÃY B-07] Ai xác nhận "Đã giao hàng" trong hệ thống?
         Shipper của Thọ Phát không có app ECO TSH
         Merchant xác nhận "Nhận hàng" trên app
         Nhưng nếu Merchant không mở app → đơn vẫn trạng thái "Đang giao"
         → Thọ Phát không biết giao hàng thành công hay chưa
```

---

## Hành trình Anh Khoa — Cuối tháng: Đối soát

```
31/03 — Anh Khoa cần đối soát:
         Tổng đơn OMS nhận = 500
         Tổng đơn SAP xử lý = 480 (20 đơn bị adjust/cancel)
       → [ĐIỂM GÃY B-08] Anh Khoa không có báo cáo đối soát từ Portal ECOM
         Phải tự pull từ SAP, gửi email cho Finviet để reconcile thủ công
         
       → [VẤN ĐỀ B-09] GMV Finviet tính cho Thọ Phát dựa trên đơn đã sync (500)
         hay đơn thực tế fulfilled (480)?
         20 đơn chênh lệch → ai chịu trách nhiệm?
         Không có dispute resolution process nào được định nghĩa
```

---

## Tổng hợp Gaps từ góc nhìn Brand Supplier

| # | Điểm gãy | Mức độ |
|---|---|---|
| B-01 | Tài liệu API tích hợp cho Brand ERP chưa rõ format/protocol | 🔴 Cao |
| B-02 | (Đã chốt) Bảo hộ bán chéo do Finviet Admin cấu hình qua Bộ Lọc Cạnh tranh, không có Brand self-service. | ✅ OK |
| B-03 | Không có môi trường Sandbox cho Brand test tích hợp | 🟠 TB |
| B-04 | Brand Portal (view riêng cho Brand) có tồn tại không? Chưa được mô tả | 🔴 Cao |
| B-05 | Format đơn hàng OMS → ERP chưa được chuẩn hóa → risk import error | 🔴 Cao |
| B-06 | ERP adjust/cancel đơn nhưng OMS không nhận event → Merchant không được báo | 🔴 Cao |
| B-07 | Không có giao thức xác nhận giao hàng từ phía Brand/Shipper | 🟠 TB |
| B-08 | Không có báo cáo đối soát tự động cho Brand | 🔴 Cao |
| B-09 | Chưa định nghĩa dispute resolution khi GMV Finviet ≠ GMV Brand | 🔴 Cao |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
