import os
import time
import sys
import random

def type_text(text, delay=0.03):
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    print()

def main():
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

    print("\n" + "="*60)
    print(f"{BOLD}{BLUE}    🛠️  PRODUCT FORGE - COMMAND LINE PROTOTYPE (MVP v0)    {RESET}")
    print("="*60 + "\n")
    
    type_text(f"{YELLOW}[System]{RESET} Booting Marcus Orchestrator & Agents...", 0.01)
    time.sleep(0.5)
    type_text(f"{YELLOW}[System]{RESET} Sophia (Product Agent): ONLINE", 0.01)
    type_text(f"{YELLOW}[System]{RESET} Arthur (Market Agent): ONLINE", 0.01)
    type_text(f"{YELLOW}[System]{RESET} Leo (Data Agent): ONLINE", 0.01)
    type_text(f"{YELLOW}[System]{RESET} Alan (Tech Agent): ONLINE", 0.01)
    type_text(f"{YELLOW}[System]{RESET} Eve (QA Agent): ONLINE", 0.01)
    print("\n" + "-"*60 + "\n")
    
    idea = input(f"{BOLD}💡 Bạn có ý tưởng gì mới cho sản phẩm?{RESET}\n> ")
    if not idea.strip():
        print("Ý tưởng trống. Tự động thoát hệ thống.")
        return
        
    idea_id = f"IDEA-{random.randint(1000, 9999)}"
    
    print("\n" + "-"*60)
    pin = input(f"🔑 {BOLD}Vui lòng thiết lập Mã PIN 4 số để bảo vệ ý tưởng này:{RESET}\n> ")
    while len(pin) != 4 or not pin.isdigit():
        pin = input(f"⚠️ {BOLD}Mã PIN không hợp lệ. Nhập đúng 4 chữ số:{RESET}\n> ")
    print(f"✅ Đã ghi nhận ý tưởng! Mã định danh: {BOLD}{BLUE}#{idea_id}{RESET}")
    time.sleep(1)

    # ---------------------------------------------------------
    # DAG Node 1: Sophia Classify
    # ---------------------------------------------------------
    print(f"\n{YELLOW}[Sophia]{RESET} Đang phân loại ý tưởng (Auto-Routing)...")
    time.sleep(1)
    type_text(f"{BOLD}🤖 [Cố Vấn Ảo]:{RESET} Để có hướng đánh giá chuẩn xác, ý tưởng này của bạn thuộc nhóm nào?")
    print("  1. [NEW] Tính năng mới hoàn toàn (Kỳ vọng mang lại lợi nhuận).")
    print("  2. [ENHANCE] Cải tiến/Tối ưu (Kỳ vọng tăng tỉ lệ chuyển đổi, giảm rủi ro).")
    choice = input(f"> Chọn (1 hoặc 2): ")

    is_new_feature = (choice.strip() == "1")

    doc_type = ""
    doc_content = ""

    if is_new_feature:
        # ---------------------------------------------------------
        # DAG Node 2A: PATH A (P&L)
        # ---------------------------------------------------------
        print(f"\n{YELLOW}[Sophia]{RESET} Routing -> PATH A: P&L Trade-off")
        time.sleep(1)
        type_text(f"{BOLD}🤖 [Cố Vấn Ảo - Market Agent]:{RESET} Vì đây là tính năng mới, bạn cam kết tính năng này sẽ mang lại bao nhiêu doanh thu (VNĐ) mỗi tháng để bù đắp chi phí phát triển?")
        revenue_str = input("> Doanh thu kỳ vọng/tháng (VNĐ): ")
        revenue = int(revenue_str.replace(",","").replace(".","")) if revenue_str.isdigit() else 0
        
        print(f"\n{YELLOW}[Alan (Tech)]{RESET} Quét Vector DB... Ước tính tốn 15 Man-days. Rủi ro kiến trúc: Cao (Tạo bảng DB mới).")
        print(f"{YELLOW}[Leo (Data)]{RESET} Tính toán P&L: Doanh thu ({revenue:,} VNĐ) - Chi phí Dev (15 days * 1.000.000 VNĐ) = {revenue - 15000000:,} VNĐ.")
        
        if revenue >= 15000000:
            print(f"\n✅ {GREEN}[Sophia]{RESET} P&L Dương. Đáng để đầu tư!")
            doc_type = "PRD"
        else:
            print(f"\n❌ {YELLOW}[Sophia]{RESET} Lỗ vốn! Chi phí Dev cao hơn doanh thu cam kết. Bắt buộc thu hẹp Scope (Đưa vào Out of Scope).")
            doc_type = "PRD"
    else:
        # ---------------------------------------------------------
        # DAG Node 2B: PATH B (RICE Score)
        # ---------------------------------------------------------
        print(f"\n{YELLOW}[Sophia]{RESET} Routing -> PATH B: RICE Score")
        time.sleep(1)
        print(f"{YELLOW}[Leo (Data)]{RESET} Đọc file `baseline_metrics.md` -> Reach = 10,000 User VIP.")
        
        type_text(f"{BOLD}🤖 [Cố Vấn Ảo - Market Agent]:{RESET} Bạn dựa vào bằng chứng/data nào để tin rằng sự thay đổi này sẽ có tác động tích cực?")
        evidence = input("> Bằng chứng của bạn: ")
        
        confidence = 10
        if "data" in evidence.lower() or "báo cáo" in evidence.lower() or "mixpanel" in evidence.lower():
            confidence = 80
            print(f"✅ {GREEN}[Market Agent]{RESET} Bằng chứng có cơ sở (Confidence = 80%).")
        else:
            print(f"⚠️ {YELLOW}[Market Agent]{RESET} Đây chỉ là cảm tính cá nhân. Áp dụng hình phạt (Confidence = 10%).")
            
        print(f"{YELLOW}[Alan (Tech)]{RESET} Ước tính tốn 2 Man-days. Rủi ro: Rất thấp (Chỉ sửa UI).")
        
        rice_score = (10000 * 2 * (confidence/100)) / 2
        print(f"{YELLOW}[Sophia]{RESET} Tổng điểm RICE: {int(rice_score)}")
        
        if confidence == 10:
            print(f"\n❌ {YELLOW}[Sophia]{RESET} Điểm RICE quá thấp do thiếu bằng chứng thực tế. Ý tưởng BỊ TỪ CHỐI.")
            return
        else:
            print(f"\n✅ {GREEN}[Sophia]{RESET} Điểm RICE Đạt. Tính năng này được thông qua!")
            doc_type = "UserStory"

    # ---------------------------------------------------------
    # DAG Node 3: Sizing & Artifact Generation
    # ---------------------------------------------------------
    print("\n" + "-"*60)
    print(f"{YELLOW}[Sophia]{RESET} Đang gọi Output Sizing Matrix...")
    time.sleep(1)
    
    os.makedirs("samples", exist_ok=True)
    
    if doc_type == "PRD":
        print(f"  {BLUE}[Sophia]{RESET} Ý tưởng Size L/XL -> Sinh PRD 10 Phần theo PRD_Template.md...")
        filename = f"samples/{idea_id}_PRD.md"
        doc_content = f"# 📄 ĐẶC TẢ PRD - #{idea_id}\n\n## 1. Thông Tin Chung\n- Mức độ: L/XL\n- Người dùng mục tiêu: Khách hàng thanh toán\n\n## 2. Bối cảnh\n{idea}\n\n## 3. Mục tiêu & Chỉ số đo lường\n- Tăng doanh thu hoặc giảm chi phí.\n\n## 5. Scope Management\n- **In Scope:** Tính năng lõi.\n- **Out of scope:** Lọc các tính năng thừa để giữ P&L Dương.\n\n## 8. User Stories & AC\n- Phân rã luồng chính.\n\n## 10. UAT Test Cases\n- [ ] Happy path test.\n- [ ] Edge cases test."
    else:
        print(f"  {BLUE}[Sophia]{RESET} Ý tưởng Size S -> Chặn Over-engineering. Chỉ sinh User Story + AC...")
        filename = f"samples/{idea_id}_UserStory.md"
        doc_content = f"# 🏷️ USER STORY - #{idea_id}\n\n**Bối cảnh:** {idea}\n\n**User Story:**\n- As a User, I want to [Tối ưu] so that I save time.\n\n**Acceptance Criteria (AC):**\n1. Given... When... Then...\n2. Check boundary conditions."
        
    time.sleep(1.5)
    print(f"  {BLUE}[Eve (QA Agent)]{RESET} Đang gắn Test-cases nghiệm thu (Auto-UAT) vào tài liệu...")
    
    with open(filename, "w", encoding="utf-8") as f:
        f.write(doc_content)
        
    print(f"\n🎉 {BOLD}XONG!{RESET} Luồng xử lý DAG đã hoàn tất.")
    print(f"Tài liệu đã được lưu tự động tại: {BOLD}{GREEN}{filename}{RESET}")
    print("\n" + "="*60 + "\n")

if __name__ == "__main__":
    main()
