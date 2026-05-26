# 14 — Actor: Nhà phân phối & Shipper (Distributor / Delivery Agent)

> **Role-play:** Tôi là Anh Phúc, nhân viên giao hàng tại Công ty TNHH Phân phối Đông Nam.  
> Đông Nam là nhà phân phối được Thọ Phát ủy quyền tại khu vực Q.12 – HCM.  
> Mỗi ngày giao 40-60 điểm. Không có app riêng của Finviet.

---

## Vai trò trong hệ thống

| Trách nhiệm | Hiện trạng |
|---|---|
| Nhận danh sách giao hàng từ Brand/Finviet | Email / điện thoại / file Excel |
| Giao hàng đến Merchant | Thủ công, không có xác nhận digital |
| Xác nhận giao hàng thành công | Merchant ký tay trên phiếu giấy |
| Báo cáo giao hàng thất bại | Gọi điện cho Brand/Finviet Admin |

---

## Hành trình Anh Phúc — Ngày làm việc

```
07:00 — Nhận danh sách giao hàng buổi sáng
       → [ĐIỂM GÃY D-01] Danh sách giao hàng đến từ đâu?
         - Nếu từ OMS Portal ECOM: Đông Nam có tài khoản Portal ECOM không?
         - Nếu qua email từ Brand: không real-time, có thể lỗi thời
         - Nếu qua điện thoại: không có audit trail
         → Hệ thống hiện tại không định nghĩa kênh truyền thông tin cho Distributor

09:30 — Đến cửa hàng Chị Lan, giao 30 thùng
       → Chị Lan đếm: thiếu 2 thùng nước tương
       → Anh Phúc ký vào phiếu giao hàng giấy
       → [ĐIỂM GÃY D-02] Phiếu giấy được Chị Lan ký nhận đủ (vì vội)
         Sau đó Chị Lan vào app báo thiếu hàng
         → Anh Phúc không có bằng chứng digital nào
         → Tranh chấp: Merchant nói thiếu, Distributor nói đủ
         → Ai đúng? Không có evidence từ hệ thống

10:15 — Đến cửa hàng thứ 2: không có người
       → [ĐIỂM GÃY D-03] Merchant không ở nhà, không nhận hàng
         Anh Phúc phải làm gì?
         - Giữ hàng trên xe → giao lại chiều
         - Để hàng trước cửa → rủi ro mất hàng
         - Gọi điện → Merchant không nghe máy
         → ECO TSH không có tính năng "Giao hàng thất bại" với lý do

11:00 — Brand Thọ Phát gọi hỏi: "Đơn #12345 giao chưa?"
       → [ĐIỂM GÃY D-04] Anh Phúc chỉ biết dựa trên ghi chú tay của mình
         Portal ECOM không có real-time delivery tracking
         → Brand không biết đơn đang ở đâu trong chuỗi giao hàng

14:00 — Giao xong, cần báo cáo cuối ngày
       → [ĐIỂM GÃY D-05] Gửi file Excel tổng hợp về cho Đông Nam Manager
         Đông Nam Manager tổng hợp báo cáo cho Thọ Phát
         Thọ Phát gửi báo cho Finviet
         → Dữ liệu giao hàng trễ 1-2 ngày mới lên hệ thống
         → OMS không biết đơn đã giao hay chưa theo real-time
```

---

## Luồng nghiệp vụ Giao hàng — Gaps hệ thống

```
OMS (Portal ECOM) → [???] → Distributor → [???] → Merchant
                  ^                                  ^
           Không có kênh                    Merchant xác nhận
           thông báo chính thức              trong app (có)
           cho Distributor                  nhưng Distributor
                                            không biết
```

**Vấn đề cốt lõi:** Distributor là actor quan trọng NHẤT trong việc hoàn tất đơn hàng nhưng **không có interface nào trong hệ thống**.

---

## Tổng hợp Gaps

| # | Điểm gãy | Mức độ |
|---|---|---|
| D-01 | Không có kênh thông báo đơn giao hàng cho Distributor (email/app/file) | 🔴 Cao |
| D-02 | Không có xác nhận giao hàng digital → tranh chấp số lượng không có evidence | 🔴 Cao |
| D-03 | Không có flow "Giao hàng thất bại" (không có người nhận, địa chỉ sai...) | 🔴 Cao |
| D-04 | Không có real-time delivery tracking cho Brand và Merchant | 🟠 TB |
| D-05 | Dữ liệu giao hàng lag 1-2 ngày → OMS reconcile muộn | 🔴 Cao |
| D-06 | Distributor có thể là bên thứ 3 (không phải Brand, không phải Finviet) — quyền truy cập hệ thống là gì? | 🔴 Cao |

---

## [NEEDS CLARIFICATION]

- **NC-D1:** Finviet có Distributor Portal hay Distributor App không? Hay Distributor hoàn toàn ngoài hệ thống?
- **NC-D2:** Ai confirm "Đã giao hàng" trong OMS? Merchant (hiện tại) hay Distributor?
- **NC-D3:** Một đơn hàng có thể được giao bởi nhiều Distributor không (split delivery)?


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
