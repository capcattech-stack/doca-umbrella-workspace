# TURN 02: ĐỘNG CƠ SINH MÔ TẢ LÃNG ĐÃNG
*(AUTO POETIC CAPTION GENERATION SYSTEM)*

> **Mã Lượt Chat:** `TURN-30052026-02`  
> **Chủ trì:** Sophia (CPO / PM), Arthur (Mom Test Expert)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Thông tin lấy được từ hình metadata và cả phân tich từ ML offline có thể dùng để viết 1 mô tả ngắn cho bức hình kiểu lãng đãng

---

## 🤖 **Đặc vụ phản hồi (Sophia & Arthur):**
Chúng tôi đã xây dựng chương thiết kế **Cỗ máy sinh chú thích lãng đãng tự động (Auto Poetic Caption Generator)** nằm tại **[SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md#L266)**:

1.  **Hợp nhất 3 nguồn dữ liệu (Input Fusion):**
    *   **EXIF Metadata:** Lấy ngày, giờ chụp thực tế để suy ra buổi (sáng sớm, chiều lơ đãng, đêm tĩnh lặng) và mùa trong năm (Xuân se lạnh, Hè oi nắng, Mưa nhiệt đới, Đông chầm chậm).
    *   **ML Kit Tag:** Trích xuất các nhãn hành động/bối cảnh từ SQLite Cache.
    *   **User Note:** Nét bút ghi chú của Sen (nếu có).
2.  **Cỗ máy sinh thơ cục bộ 0 đồng (Offline Poetic Stacking):** Sử dụng bộ từ điển ngữ nghĩa lãng đãng (Japandi/Murakami style) lưu sẵn dưới máy để ghép theo cấu trúc: `[Thời gian] + [Hành động Boss] + [Bối cảnh] + [Cảm xúc nhẹ nhàng]`. Hoàn toàn không phát sinh chi phí token API và chạy offline 100%.
3.  **Bơm cảm xúc nâng cao (Gemini Flash Online):** Khi Sen vuốt lên ghim Kỷ Niệm Vàng (Swipe Up) và có kết nối mạng, hệ thống sử dụng Gemini Flash để viết một dòng chú thích nhật ký sâu lắng và lãng mạn hơn.
4.  **Quy tắc hiển thị Polaroid:**
    *   Ưu tiên 1: Chữ viết tay của Sen (font Caveat, đậm đà nét mực).
    *   Ưu tiên 2: Chú thích lãng đãng tự động của Boss ảo (font Quicksand nghiêng, xám nhạt `#9C8F87`).
    *   Nếu có cả hai: Hiển thị song song tạo nên một trang nhật ký chân thực.
