# 17 — Actor Discovery List: Roles chưa được phân tích

> Tổng hợp tất cả roles có khả năng tương tác trong hệ thống ECO TSH.  
> Phân loại theo mức độ ưu tiên phân tích và trạng thái hiện tại.

---

## Trạng thái Actor Map — Toàn hệ thống

| # | Actor | Đã Role-Play | Ưu tiên | Ghi chú |
|---|---|:---:|:---:|---|
| 1 | **Store Owner (Chủ tiệm)** | ✅ [File 10] | P0 | Người dùng chính |
| 2 | **Staff (Nhân viên bán hàng)** | ✅ [File 11] | P0 | Dùng POS hàng ngày |
| 3 | **Brand Supplier** | ✅ [File 12] | P0 | Tích hợp ERP |
| 4 | **Finviet Admin** | ✅ [File 13] | P0 | Quản trị hệ thống |
| 5 | **ERP Brand System** | ✅ [File 13] | P0 | System actor |
| 6 | **End Consumer (Khách lẻ)** | ✅ [File 13] | P1 | Tương tác gián tiếp |
| 7 | **Distributor/Shipper** | ✅ [File 14] | P0 | Thiếu interface hoàn toàn |
| 8 | **Finviet Supply Chain** | ✅ [File 15] | P0 | Mô hình chưa rõ |
| 9 | **Credit Officer** | ✅ [File 16] | P0 | Loan approval workflow |
| 10 | **CS Support** | ✅ [File 16] | P0 | Tool gap nghiêm trọng |
| 11 | **Store Manager (Quản lý ca)** | ⚠️ Chưa | P1 | Sub-role của Owner |
| 12 | **Field Sales / Merchant Acquisition** | ⚠️ Chưa | P1 | Onboard Merchant |
| 13 | **Regional Zone Manager** | ⚠️ Chưa | P2 | Quản lý vùng phân phối |
| 14 | **Financial Partner (BNPL)** | ⚠️ Chưa | P1 | Nếu Finviet dùng external fund |
| 15 | **Payment Gateway (VietQR/Napas)** | ⚠️ Chưa | P0 | System actor |
| 16 | **Tax Authority / CQT** | ⚠️ Chưa | P0 | System actor |
| 17 | **Marketing/Promotion Manager** | ⚠️ Chưa | P2 | Tạo deal/voucher |
| 18 | **Accountant (Kế toán Finviet)** | ⚠️ Chưa | P1 | Reconciliation |
| 19 | **Compliance/Legal Officer** | ⚠️ Chưa | P1 | NĐ70, giấy phép |

---

## Phân tích Roles chưa làm (⚠️)

### 11. Store Manager (Quản lý ca) — P1
**Mô tả:** Sub-role của Owner. Có quyền xem báo cáo, không được đặt đơn nhập.  
**Tại sao cần phân tích:** USCR phân quyền (Owner > Manager > Staff) nhưng tài liệu không mô tả Manager thấy gì khác Staff.  
**Key question:** Manager có quyền gì? Duyệt đổi trả? Xem lãi lỗ? Chỉnh giá bán?  
**Trạng thái:** Cần xác nhận scope của role Manager trước khi role-play.

### 12. Field Sales / Merchant Acquisition — P1
**Mô tả:** Nhân viên Finviet đi thực địa, onboard Merchant mới.  
**Tại sao cần phân tích:** Merchant có thể được onboard qua app (self-service) HOẶC qua Field Sales (assisted).  
**Key question:** Field Sales có app riêng không? Họ tạo tài khoản Merchant thay không?  
**Trạng thái:** Cần xác nhận có tồn tại flow "assisted onboarding" không.

### 13. Regional Zone Manager — P2
**Mô tả:** Finviet internal — quản lý Distribution Zone, whitelist Brand-Merchant theo vùng.  
**Tại sao cần phân tích:** Zone assignment là critical logic nhưng không có actor nào được giao quản lý.  
**Trạng thái:** Có thể là Finviet Admin với quyền cao hơn — cần làm rõ.

### 14. Financial Partner (BNPL/Lending Partner) — P1
**Mô tả:** Nếu Finviet không tự cho vay mà dùng đối tác (FE Credit, Lotte Finance, ngân hàng).  
**Tại sao cần phân tích:** Nếu có đối tác tài chính → data flow khác hoàn toàn (Loan approval ở external system).  
**Key question:** Finviet tự cho vay bằng vốn của mình hay dùng đối tác?  
**Trạng thái:** ⚠️ **[NEEDS CLARIFICATION P0]** — ảnh hưởng toàn bộ architecture Loan.

### 15. Payment Gateway (VietQR / Napas / VNPAY) — P0 System Actor
**Mô tả:** Hệ thống trung gian xử lý QR payment.  
**Tại sao cần phân tích:** Callback failure là rủi ro đã xác định (PM-11). Cần biết protocol cụ thể.  
**Integration points:**
- ECO TSH → Portal ECOM → Payment Gateway: generate QR
- Khách quét → Ngân hàng → Payment Gateway → Portal ECOM: webhook callback
- Timeout, retry, duplicate payment handling

### 16. Tax Authority / CQT — P0 System Actor
**Mô tả:** Cổng thuế điện tử (eTax) nhận HĐ điện tử từ Portal ECOM.  
**Tại sao cần phân tích:** HĐ bị CQT từ chối → Merchant cần xử lý → ECO TSH có flow alert không?  
**Integration points:**
- Portal ECOM → CQT: gửi HĐ (ký số, format XML theo chuẩn TTCC)
- CQT → Portal ECOM: acknowledge / reject / query status

### 17. Marketing/Promotion Manager — P2
**Mô tả:** Tạo chương trình khuyến mãi (giảm giá theo đơn, BOGOF, voucher...).  
**Key question:** POS có hỗ trợ áp promotion code không? Promotion rule engine ở Portal ECOM?

### 18. Kế toán Finviet — P1
**Mô tả:** Chịu trách nhiệm reconciliation cuối kỳ, báo cáo P&L.  
**Key question:** Kế toán dùng Portal ECOM export data hay kết nối ERP/accounting system riêng?

### 19. Compliance/Legal Officer — P1
**Mô tả:** Đảm bảo hệ thống tuân thủ NĐ70/2025, giấy phép trung gian thanh toán.  
**Key question:** Ai review khi luật thay đổi? Có process để update hệ thống kịp thời không?

---

## Top Priority Gaps từ Actors mới phân tích (File 14–16)

| # | Gap | Actor | Mức độ |
|---|---|---|---|
| NEW-01 | **Distributor không có interface trong hệ thống** → xác nhận giao hàng thủ công | Distributor | 🔴 Cao |
| NEW-02 | **Finviet Supply Chain chưa rõ mô hình** (wholesale vs dropship) → ảnh hưởng inventory architecture | FSC | 🔴 Cao |
| NEW-03 | **Không có approval workflow cho sản phẩm mới** trong Finviet Supply Chain | FSC | 🔴 Cao |
| NEW-04 | **Partial loan approval**: đơn hàng không tự điều chỉnh → Merchant bị treo | Credit | 🔴 Cao |
| NEW-05 | **Overdue Management workflow** chưa định nghĩa | Credit | 🔴 Cao |
| NEW-06 | **Financial Partner**: Finviet tự cho vay hay dùng đối tác? → ảnh hưởng architecture | [UNKNOWN] | 🔴 Cao |
| NEW-07 | CS không có real-time order view → không support được Merchant | CS | 🔴 Cao |

---

## Đề xuất bước tiếp theo

**Confirm với Stakeholder (trả lời NC trước khi role-play tiếp):**
- NC-FS1: Finviet Supply Chain: wholesale hay dropship?
- NC-D1: Distributor có Distributor Portal không?
- NC-14: Financial Partner (BNPL): tự vay hay external?
- NC-12: Có flow "assisted onboarding" qua Field Sales không?

**Sau khi confirm → Role-play tiếp:**
- File 12b: Field Sales / Merchant Acquisition
- File 15b: Financial Partner integration flow
- File 17: Payment Gateway + CQT system actors (integration protocol)


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
