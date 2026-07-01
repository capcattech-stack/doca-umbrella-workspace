# TURN 23: KẾ HOẠCH HOÀN THIỆN & CACHE SWIPE VAULT
*(FOREGROUND IDLE SCANNING & SQLite PHOTO CACHE)*

> **Mã Lượt Chat:** `TURN-30052026-23`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead)

---

## 🙋‍♂️ **Người dùng hỏi:**
> cả team tháo cái nón người nhà ra và tiến hành kiểm thử đối kháng và roll play để duyêt tất cả tai liẹu trong thư mục PRD, của cả bốn chức năng lớn. qua đó chỉ ra các điêm gãy các khoản trống và các mâu thuẩn ở đó . và đưa ra kế hoạch hoàn thiện dựa trên scope đã thống nhất

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chào bạn! Tuân thủ tuyệt đối chỉ thị vô cùng nghiêm khắc và sâu sắc của bạn, toàn bộ đội ngũ cố vấn ảo (Sophia, Alan, Benny và Arthur) đã **tháo bỏ hoàn toàn chiếc mũ "người nhà"**, đóng vai trò là những kỹ sư hệ thống khó tính và những đối thủ phản biện sắc bén nhất để thực hiện một cuộc **Thẩm định Đối kháng Toàn diện đối với cả 4 phân hệ lớn** trong toàn bộ kho tài liệu PRD của Capcat.

Kết quả của cuộc rà soát tàn nhẫn này đã chỉ ra **6 điểm gãy chí tử về mặt kỹ thuật, trải nghiệm người dùng và tính khả thi vận hành** vốn có thể gây ra crash tiến trình chạy ngầm, ngốn pin khủng khiếp, cảnh báo bảo mật đáng sợ từ iOS/Android, hoặc làm người dùng bỏ chạy vì Boss AI trả lời quá chậm.

Tài liệu đúc kết cuộc thẩm định đối kháng toàn diện và lộ trình hoàn thiện đã được lưu trữ chính thức tại:
📑 **Tệp báo cáo thẩm định:** [AUDIT_REPORT_ALL_PRDS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUDIT_REPORT_ALL_PRDS.md)

---

## 💥 6 ĐIỂM GÃY CHÍ TỬ ĐÃ PHÁT HIỆN & GIẢI PHÁP VÁ THỰC TẾ

### 1. Phân hệ 1: Authentication & Onboarding Engine
*   **Điểm gãy 1 - Mâu thuẫn Số điện thoại & Google SSO:** Thiết kế mới tuyên bố loại bỏ hoàn toàn việc đăng ký bằng SĐT để giảm ma sát, nhưng trong kho ngôn ngữ `app_vi.arb` và code cũ lại chứa hàng chục màn hình OTP và key đăng ký bằng SĐT.
    *   *Hậu quả:* Cô lập hoàn toàn và làm gãy luồng đăng nhập của người dùng cũ.
    *   *Giải pháp vá:* Áp dụng **Dual-Auth Strategy**: Giữ Google SSO làm luồng đăng ký mặc định siêu mượt cho người dùng mới, đồng thời cung cấp một nút nhỏ dẹt dưới chân trang chào mừng: *"Đăng nhập bằng số
<truncated 2819 bytes>
nh thú cưng.
    *   *Hậu quả:* Làm nóng máy, hao pin khủng khiếp và lập tức bị OS chấm dứt tiến trình do quá tải CPU.
    *   *Giải pháp vá:* Tuyệt đối không quét ảnh ngầm. Chuyển sang **Foreground Idle Processing** chỉ quét tối đa 10-15 ảnh mới nhất mỗi lần khi người dùng đang mở app và không tương tác, lưu trạng thái index vào SQLite để không bao giờ quét lại ảnh cũ.
*   **Điểm gãy 6 - Khoảng trống chuyển đổi Đơn Boss sang Đa Boss:** Người dùng nuôi 1 boss (hệ thống lưu tất cả ảnh mà không gán ID cụ thể), sau đó đón thêm boss thứ 2 về nhà.
    *   *Hậu quả:* Toàn bộ kho ký ức cũ không được phân loại, hiển thị hỗn loạn.
    *   *Giải pháp vá:* Thiết lập quy trình **Tái phân loại ảnh lịch sử (Retroactive Re-indexing)** bằng cách so sánh vector đặc trưng cũ với Boss mới thông qua một tiến trình ngầm nhỏ khi có Boss thứ 2.

---

## 📅 KẾ HOẠCH HÀNH ĐỘNG HOÀN THIỆN (REFINEMENT ACTION PLAN)

Chúng tôi đã thiết lập danh sách đầu việc hoàn thiện chi tiết (Action Items) được phân bổ cụ thể cho từng vị trí (Sophia - CPO, Alan - Tech Lead, Benny - UI/UX) để tiến hành hiệu chỉnh lại toàn bộ hệ thống tài liệu PRD ngay trong Phase này nhằm đạt độ **Dev-Ready tuyệt đối**.

Chi tiết của báo cáo thẩm định đối kháng này đã được lưu trữ ngăn nắp tại: [AUDIT_REPORT_ALL_PRDS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUDIT_REPORT_ALL_PRDS.md).

Đúng theo chỉ thị của bạn, chúng ta vẫn nằm ở **giai đoạn nghiên cứu và đặc tả tài liệu, hoàn toàn chưa sửa đổi bất kỳ dòng code nào của app**. Bạn thấy bản báo cáo thẩm định đối kháng toàn diện này đã đủ sắc bén, thẳng thắn và đúng định hướng hoàn thiện chưa ạ?
