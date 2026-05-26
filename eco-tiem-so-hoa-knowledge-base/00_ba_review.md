# 00 — BA Review: Phân tích Tính nhất quán, Gap & Rủi ro

> **Thực hiện bởi:** Sophia — Senior Business Analyst (M2C / Supply Chain / Fintech)  
> **Phương pháp:** Consistency Check · Gap Analysis · Edge Case · Risk Scoring  
> **Nguồn phân tích:** `00_eco_tsh_overview.md` (tài liệu nghiệp vụ gốc)  
> **Chi tiết theo nghiệp vụ:** xem các file `02` → `07`

---

## I. Mâu thuẫn Nội tại (Consistency Issues)

| Mã | Mô tả | Vị trí | Mức độ |
|---|---|---|---|
| C-01 | Merchant xác nhận nhận hàng → tồn kho cộng thêm, **nhưng** nếu đã bán âm trước đó thì không có bước kiểm đếm thực tế → tồn kho sai vĩnh viễn | Inbound + POS | 🔴 |
| C-02 | Cấm bán chéo (Bộ lọc cạnh tranh) | ✅ Đã chốt: Finviet Admin quản lý. Cửa hàng nhánh bị ẩn SP đối thủ cạnh tranh. |
| C-03 | Mixed payment | ✅ Đã chốt: Hệ thống KHÔNG CÓ thanh toán hỗn hợp hay thanh toán 1 phần. Mỗi đơn 1 PTTT duy nhất. | Inbound Flow | 🟢 |
| C-04 | Tài liệu ghi "Bi-directional ERP sync" nhưng ngay bên dưới thừa nhận ERP Brand **thường không phản hồi** → mâu thuẫn thiết kế | OMS | 🔴 |
| C-05 | Bảng kê thuế: tài liệu gốc tự đặt câu hỏi mà không trả lời → **source of truth chưa được xác định** | Outbound + Tax | 🔴 |

---

## II. Gap Analysis — Luồng nghiệp vụ thiếu hoàn toàn

| Mã | Luồng thiếu | Tác động |
|---|---|---|
| G-01 | **Hủy đơn / Đổi trả** (Đã chốt) | ✅ Cấm Đổi trả/Điều chỉnh. Chỉ cho Hủy và tạo đơn mới. Hoàn Fund sau khi duyệt. |
| G-02 | **Onboarding Merchant** (KYC, gán zone, phê duyệt) | Ảnh hưởng toàn bộ hệ thống nếu gán sai zone |
| G-03 | **Loan approval flow** chi tiết (SLA, actor duyệt, fallback) | Merchant bị block không rõ lý do |
| G-04 | **Reconciliation định kỳ** (chu kỳ, agent, output) | GMV accuracy không đảm bảo |
| G-05 | **Thay đổi giá theo nhóm Merchant** — PMS có nhưng flow hiển thị cho Merchant không có | Minh bạch giá |
| G-06 | **Thu hộ / Chi hộ** — Finviet có giấy phép nhưng không có flow nào dùng | VAS opportunity bỏ phí |

---

## III. Top 10 Edge Cases chưa xử lý

| # | Edge Case | Risk |
|---|---|---|
| EC-01 | (Closed) Rủi ro API Partner với Loan | 🟢 Fund/Loan chỉ dùng cho SLC nội bộ. |
| EC-02 | POS offline → bán 100 giao dịch → online → sync conflict tồn kho | 🔴 Inventory mismatch |
| EC-03 | Merchant nằm ở ranh giới 2 Distribution Zone → routing sai đơn | 🔴 Delivery fail |
| EC-04 | (Closed) Rủi ro thanh toán Mixed | 🟢 FV không hỗ trợ Mixed payment. |
| EC-05 | QR payment: khách đã chuyển, callback timeout → POS treo "Đang chờ" | 🔴 Reconciliation |
| EC-06 | Bán âm tồn kho gây sai bảng kê thuế | 🟢 Closed (Cấm bán âm) |
| EC-07 | HĐ điện tử đã phát hành → khách trả hàng → cần HĐ điều chỉnh (chưa có luồng) | 🔴 Legal |
| EC-08 | Admin vô hiệu hóa Brand → đơn đang xử lý tại OMS trở thành orphan | 🔴 Data integrity |
| EC-09 | 2 Staff bán cùng item cuối cùng cùng lúc trên 2 thiết bị | 🟠 Oversell |
| EC-10 | Đơn hàng của 1 NPP nhưng hàng nằm ở nhiều kho — hệ thống không hỗ trợ tách đơn | 🟠 Fulfillment |

---

## IV. Risk Matrix Tóm tắt

| Mã | Rủi ro | Score | Mitigation |
|---|---|:---:|---|
| RM-01 | Loan giải ngân trước ERP confirm → bad debt | 🟢 OK | Fund/Loan không dùng cho API Partner. |
| RM-02 | Bảng kê thuế sai source → vi phạm pháp lý | 🔴 8 | POS log = source of truth |
| RM-03 | Bán âm vô hạn → kho mất kiểm soát | 🟢 OK | Cấm bán âm thực tế. Cho phép khách đặt trước (pre-order). |
| RM-04 | QR callback fail → giao dịch treo | 🟠 7 | Timeout + manual confirm |
| RM-05 | Offline POS sync conflict | 🟠 7 | Last-write-wins + conflict UI |
| RM-06 | Không có Return flow → Fund/Loan không điều chỉnh được | ✅ OK | Workaround: Không cho phép Return, bắt buộc Hủy & Tạo đơn mới |
| RM-07 | HĐ điện tử thiếu luồng điều chỉnh/hủy | 🔴 9 | Implement trước khi launch |

---

## V. Câu hỏi Phản biện cần trả lời (P0)

**Nhóm A — Nghiệp vụ cốt lõi**

- **A1.** (Đã chốt) Cấm bán chéo: Do Finviet Admin cấu hình qua "Bộ Lọc Cạnh tranh", giới hạn mua theo nhánh và ẩn sản phẩm đối thủ.
- **A2.** (Đã chốt) FV không dùng Fund/Loan cho API Partner. ECOM chỉ chuyển đơn sang "Đã xác nhận mua" khi đã thanh toán (trừ COD).
- **A3.** Hard limit cho bán âm: ai set? Merchant hay Finviet cấu hình?
- **A4.** Partial fulfillment từ Brand: Fund/Loan điều chỉnh ngay hay đợi đối soát?

**Nhóm B — Tài chính & Tuân thủ**

- **B1.** Merchant không có MST/HKD: hệ thống giới hạn tính năng gì?
- **B2.** Bảng kê thuế: POS log hay Invoice list? (phải là POS log theo NĐ70)
- **B3.** HĐ điều chỉnh/hủy: hệ thống có hỗ trợ không?
- **B4.** Fund có tính lãi không? Hoàn trả theo cơ chế nào?

**Nhóm C — Kỹ thuật**

- **C1.** ERP Brand tích hợp giao thức gì? REST/SOAP/EDI/File?
- **C2.** Inventory sync: real-time push hay batch pull? Conflict resolution?
- **C3.** Mini POS hoạt động offline không? Sync strategy?
- **C4.** ECOM Portal: Admin UI hay API Gateway? Cần tách nếu là cả hai.

---

> Chi tiết từng nhóm → xem file tương ứng trong [README.md](README.md)
