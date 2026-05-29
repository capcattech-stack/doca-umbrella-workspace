# Nhật Ký Hội Thoại - Turn 15: Mở Rộng & Tối Ưu Hóa Phân Hệ Hộp Ký Ức (FE-MEMORY-VAULT)
*Thời gian diễn ra: 2026-05-29T23:30:00+07:00*

## 🧭 Tóm Tắt Trích Đoạn Thảo Luận:
1.  **Dopamine Swipe Interaction (Vuốt Lên - Golden Memory):**
    *   Sáng lập viên đề xuất mở rộng cử chỉ **Vuốt Lên** để thực hiện các hành động đặc biệt: Tim, bình luận, và ghi dấu kỷ niệm.
    *   Thống nhất thiết lập **Nghi thức Kỷ niệm Vàng (Golden Memory Ritual)**:
        *   Khi vuốt lên, thẻ Polaroid khựng lại giữa màn hình, kích hoạt pháo hoa vàng óng ánh và biểu tượng Trái Tim Vàng phát sáng.
        *   Một ô nhập bình luận viết tay mềm mại trượt lên từ phía dưới kèm 3 gợi ý tâm sự chữa lành được sinh bởi AI.
        *   Sau khi viết, Sen nhấn nút dập một chiếc **Dấu chân mèo sáp đỏ (Red Cat-Paw Wax Seal)** chắc nịch phát ra âm thanh chân thực (`stamp_press.mp3`) và độ rung Haptic phản hồi mạnh mẽ.
2.  **Zero-Intrusion Local ML Filter (Giải Quyết Hiệu Năng & Chống Lặp):**
    *   Sáng lập viên lo ngại về hiệu năng hao pin/đơ máy khi chạy ML Kit cục bộ và việc người dùng chán nản nếu ngày nào cũng thấy một vài tấm ảnh lặp đi lặp lại.
    *   Thống nhất nâng cấp giải thuật **Quét Lùi Thưa Thớt Ngẫu Nhiên (Randomized Retrogressive Sparse Scanning)**:
        *   Phân rã album ảnh Limited Access ngược thời gian 2 năm thành 24 giỏ tháng.
        *   Mỗi tháng bốc ngẫu nhiên đúng 1-2 bức ảnh đại diện để chạy nhận diện ML Kit. Loại bỏ các ảnh chụp liên tiếp sát giây/phút để tránh lặp góc.
        *   Dừng cực sớm (Early Stopping) ngay khi gom đủ 10-15 ảnh Pet dìm hợp lệ. Điều này giúp CPU tăng không quá 5%, thời gian quét dưới 1.5 giây, triệt tiêu hao pin.
        *   Thiết kế bảng SQLite `processed_photos_cache` lưu toàn bộ danh sách `local_asset_id` đã lướt qua mắt Sen để **loại trừ vĩnh viễn (Blacklist)** khỏi các lượt quét tiếp theo, đảm bảo mỗi tuần Sen đều ngỡ ngàng trước những kỷ niệm mới mẻ đã bám bụi.
3.  **Local Meme Compositing (0đ) & Thử Nghiệm Mom Test:**
    *   Sáng lập viên băn khoăn: *"Mục tiêu là kỷ niệm vậy việc gắn meme nên là một option mở rộng hay tính năng độc lập? Hộp ký ức toàn meme thì có đúng không? Người dùng muốn gì?"*
    *   Arthur chạy Mom Test thực tế và rút ra kết luận: **Kỷ niệm bắt buộc phải nguyên bản 100% (Pure Postcard)** để giữ sự linh thiêng, chữa lành. Hộp lưu niệm chứa toàn hình vẽ chibi châm biếm sẽ tạo cảm giác rẻ tiền, mất chất thơ Iyashikei.
    *   Quyết định: Ghép Meme Chibi chỉ là một **Tác vụ Mở rộng Chủ động (Optional Action)** đặt ẩn tại nút **[Chế Meme 0đ]** ở mặt sau thẻ Polaroid. Ảnh meme xuất ra được lưu riêng để chia sẻ viral ra Story ngoài, tuyệt đối không ô nhiễm ảnh gốc thiêng liêng bên trong Hộp Ký Ức.
4.  **Sự Minh Bạch Dữ Liệu Tối Cao & Cảm Quan Iyashikei:**
    *   Thiết kế giao diện Wabi-Sabi trầm ấm với nền beige nhám vân giấy thô tự nhiên (`#F9F6F0`), các góc thẻ Polaroid đổ bóng mềm oặt như thật (`rgba(139,126,116,0.08)`).
    *   Tích hợp cảm biến **Con quay hồi chuyển (Gyroscope)**: các hạt bụi nắng lơ lửng chuyển động chậm rãi xiên góc theo chiều nghiêng của điện thoại.
    *   Tích hợp ngăn kéo **[Minh Bạch Dữ Liệu 🔒]** dạng sớ giấy da tối giản, giải trình trực quan những gì lưu cục bộ vs những gì đồng bộ mã hóa lên mây (100% không bán dữ liệu, không quảng cáo bám đuổi).
    *   Trao đặc quyền tối cao cho Sen: nút **[Tải Sao Lưu .zip]** (tải trọn bộ ảnh Polaroid kèm trang index xem ngoại tuyến) và nút thanh trừng dữ liệu **[Quên Đi Vĩnh Viễn]** tôn trọng quyền năng tối cao của chủ nuôi.
5.  **Doanh Thu Tinh Gọn (Free-to-Play):**
    *   Leo phản đối kịch liệt việc khóa ký ức cũ để đòi phí xem lại ("bẫy tống tiền cảm xúc"). Hộp ký ức cốt lõi bắt buộc phải MIỄN PHÍ TRỌN ĐỜI để làm neo giữ chân người dùng.
    *   Mở rộng 3 động cơ doanh thu nhân văn:
        *   **In Ảnh Polaroid Thật Gửi Về Nhà (Physical Instax Polaroid Delivery):** Sen bấm in ảnh dìm, Capcat đóng gói thủ công bằng phong bì kraft thô mộc, đóng dấu sáp đỏ mèo dễ thương và giao tận nhà với giá rẻ 19.000đ - 29.000đ/ảnh. Biên lợi nhuận ròng đạt tới **50% - 60%**.
        *   **Cửa Hàng Visual Skins (Premium Washi-Tape):** Bán các khung dán băng keo giấy Washi hoạt ảnh hoa đào bay, nhạc nền mưa rơi Lofi tĩnh lặng.
        *   **Ad-Supported Rewarded Ads:** Xem video 30s để có thêm 5 lượt quét khi đã dùng hết hạn mức 15 lượt quét miễn phí trong tuần.

## 🛠️ Đặc Tả Kỹ Thuật Đã Cập Nhật (Specs Index):
*   [MODIFY] [SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md): Tích hợp nghi thức vuốt lên (Tim, comment giấy thô giả lập, đóng dấu cat-paw wax seal đỏ).
*   [MODIFY] [SPEC_02_OFFLINE_ML_FILTERS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_02_OFFLINE_ML_FILTERS.md): Nâng cấp giải thuật quét lùi ngẫu nhiên theo block tháng và cơ chế SQLite cache blacklist chống trùng.
*   [MODIFY] [SPEC_03_MEME_CARD_COMPOSITING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_03_MEME_CARD_COMPOSITING.md): Báo cáo thực chứng Mom Test, tách biệt meme thành tính năng mở rộng phụ trợ tự nguyện.
*   [MODIFY] [SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md): Chi tiết hóa UI/UX Iyashikei Nhật Bản, cảm biến Gyroscope điều hướng hạt nắng lơ lửng, âm thanh sột soạt và ngăn kéo Minh Bạch Dữ Liệu Tối Cao.
*   [MODIFY] [SPEC_06_LEAN_GACHA_MONETIZATION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_06_LEAN_GACHA_MONETIZATION.md): Xóa bỏ IAP tống tiền cảm xúc, xây dựng cấu trúc doanh thu từ Polaroid vật lý gửi tận nhà (19k-29k), Visual skins dán Washi và Rewarded Video Ads.
