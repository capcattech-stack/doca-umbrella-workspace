---
name: cozy-jazz-curator
description: Chuyên gia tìm kiếm và kiểm duyệt nhạc Jazz Big Band chất lượng cao, sạch bản quyền và mang phong cách Glenn Miller cho DOCA.
---

# 🎷 COZY JAZZ CURATION PROTOCOL (GLENN MILLER STYLE)

Nhiệm vụ của đặc vụ là tìm kiếm, đánh giá và tuyển chọn các bản nhạc Jazz đạt chuẩn âm thanh chất lượng cao (Studio Quality), hoàn toàn miễn phí bản quyền (Copyright-Safe) và mang phong cách phối khí ấm áp, cổ điển của **Glenn Miller** để đưa vào ứng dụng DOCA.

---

## 🎯 1. Định nghĩa "Gu" Nhạc (The Cozy Soundscape)

Nhạc được chọn phải mang các đặc tính nghệ thuật sau:
*   **Thể loại chính:** 
    1.  **Big Band Swing / Sweet Jazz (Glenn Miller Style):** Cổ điển, phóng khoáng, thích hợp ban ngày.
    2.  **Showa Jazz (Nhạc Jazz cổ điển Nhật Bản 1950 - 1975):** Mang phong cách retro-kissaten (quán cà phê gỗ kiểu Nhật), chất âm cực kỳ sang trọng, ấm áp, sâu lắng.
    3.  **Ghibli Bedtime Music (Nhạc cover Piano / Lofi giai điệu Ghibli):** Êm dịu, dùng cho buổi tối/đêm muộn để mang lại cảm giác chữa lành tốt nhất.
*   **Ưu tiên giọng hát (Vocal Jazz):** Hệ thống **ưu tiên tuyển chọn các bản nhạc có lời (Vocal Jazz)** có giọng hát ấm áp, truyền cảm, sâu lắng (ví dụ: giọng ca nam trầm ấm hoặc nữ trung/trầm mang phong cách kể chuyện tự sự). Lời ca nên mang sắc thái nhẹ nhàng, hoài niệm, chữa lành cảm xúc để tạo sự kết nối tinh thần tốt hơn cho người nghe.
*   **Nhạc cụ chủ đạo:** Woodwinds (Clarinet, bè Saxophone mềm mại), Brass ấm (Trombone/Trumpet dùng mute giảm thanh), Piano, Double Bass, và Brushes Drum (tránh tiếng trống gõ quá mạnh).
*   **Nhịp điệu:** Medium-slow đến Slow tempo. Tránh các bản bebop quá nhanh hoặc chói tai.
*   **Trải nghiệm cảm xúc (Iyashikei):** Nhẹ nhàng, thư giãn, ấm cúng như không gian quán cà phê chiều mưa hoặc phòng khách ấm áp.

---

## 🛡️ 2. Tiêu chuẩn Bản quyền & Chất lượng (The "Free & Clean" Rule)

*   **Chất lượng âm thanh (Bắt buộc):** Chỉ chọn các bản thu âm kỹ thuật số hiện đại hoặc bản remaster chất lượng cao, âm thanh trong trẻo, không bị lẫn tiếng nổ đĩa rè rè (hiss/pop) quá mức.
*   **Bản quyền hợp pháp:**
    1.  **US Federal Government Works (Public Domain):** Các bản ghi âm được thực hiện bởi các ban nhạc quân đội Hoa Kỳ (ví dụ: *US Air Force Band - Airmen of Note*, *US Army Blues*, *US Navy Band Commodores*).
    2.  **Classic Japanese Jazz (Showa Jazz trước 1976):** Các bản ghi âm Showa Jazz phát hành trước năm 1976 đã hết hạn bảo hộ quyền liên quan (bản quyền bản thu) tại Việt Nam, hoàn toàn hợp pháp để sử dụng.
    3.  **Ghibli Piano/Lofi Cover (Creative Commons CC-BY / CC0):** Các bản nhạc cover giai điệu Ghibli được cấp phép CC-BY. Yêu cầu ghi công nghệ sĩ chơi nhạc rõ ràng tại góc nhỏ của trình phát.
    4.  **Royalty-Free Platforms:** Các kho nhạc như FreePD.com.

---

## 🔍 3. Chiến lược Tìm kiếm cho Agent (Search Heuristics)

Khi tìm kiếm nhạc mới, Agent phải sử dụng các từ khóa và nguồn sau:

### Nguồn 1: Archive.org & Wikimedia Commons (Showa Jazz & US Military Band)
*   **Từ khóa tìm kiếm:** 
    *   `"Showa Jazz"`, `"Japanese Jazz 1950s"`, `"Japanese Jazz 1960s"`, `"Classic Japanese Jazz before 1976"`.
    *   `"Airmen of Note"`, `"US Army Blues"`, `"US Navy Band"`.
*   **Cách kiểm tra giấy phép:** Đảm bảo năm phát hành của bản thu âm Showa Jazz là trước năm 1976 để đảm bảo hết hạn quyền bảo hộ bản thu tại Việt Nam.

### Nguồn 2: FreePD.com & Các nền tảng CC (Ghibli Piano/Lofi Cover)
*   **Từ khóa tìm kiếm:**
    *   `"Ghibli lofi cover CC-BY"`, `"Ghibli piano cover"`, `"Studio Ghibli cover royalty free"`.
    *   Lọc chuyên mục `Jazz & Blues` hoặc `Sentimental` trên FreePD.

---

## 🛠️ 4. Quy trình Curation Tự động V4 (Automated Curation Pipeline V4)

Hệ thống vận hành curation tự động theo các tiêu chuẩn sau:

### 4.1 Cấu trúc hạt giống nhạc (`curated_seeds.json`)
Lưu trữ trên Git để dễ dàng chỉnh sửa. Mỗi bài hát cần có các trường kỹ thuật sau:
```json
{
  "id": "stardust",
  "file": "File:US Army Blues - 05 - Stardust.ogg",
  "title": "Stardust 🌟",
  "artist": "U.S. Army Blues",
  "slot": "evening",
  "culture": "western",
  "tempo": "slow",
  "vocal_type": "instrumental",
  "tone": "C Major"
}
```
*   `culture`: `"western"` (Âu Mỹ) hoặc `"japanese"` (Nhật Bản/Ghibli) để đồng bộ ngày phát.
*   `tempo`: `"slow"`, `"medium"`, `"fast"` để kiểm soát tiết tấu chuyển tiếp.
*   `vocal_type`: `"instrumental"` hoặc `"vocal"` (Hệ thống ưu tiên `"vocal"` để có nhạc có lời ấm áp, truyền cảm).
*   `tone`: Giọng/Tone chủ đạo của bản nhạc.

### 4.2 Lịch phát sóng phân tách Văn hóa (Cultural Split)
*   **Ngày Âu Mỹ (Thứ 2, Thứ 4, Thứ 6, Chủ Nhật):** Chỉ phát nhạc có `culture: "western"`.
*   **Ngày Nhật Bản (Thứ 3, Thứ 5, Thứ Bảy):** Chỉ phát nhạc có `culture: "japanese"`.

### 4.3 Chuẩn bị trước 2 ngày (T-2 Buffer)
*   Job Serverless chạy **hàng giờ** trên GitHub Actions sẽ tải dần bài hát mới (1 bài/slot/lượt chạy).
*   Khi chạy ở ngày `T`, script tính toán và ghi đè playlist cho ngày `T+2` (sau 48 tiếng) vào `playlist.json`. Điều này giúp đảm bảo luôn có đủ bài hát mới tích lũy để đáp ứng tỉ lệ phát **50% bài hát mới gần đây** và **50% bài hát cũ quay vòng**.
