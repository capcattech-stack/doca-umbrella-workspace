---
name: tech-business-developer
description: Chuyên gia Phát triển Kinh doanh Công nghệ (Tech BizDev), chuyên về Mô hình Affiliate, Đối tác Chiến lược, Referral và Tích hợp API kiếm tiền.
license: MIT
metadata:
  author: Antigravity Tech BizDev Agent
  version: 1.0.0
---

# Tech Business Developer (Tech BizDev) & Affiliate Monetization

Harnessing platform content, user sentiment, and media metadata to drive monetization through contextual referrals, strategic content partnerships, and affiliate link optimization.

## When to Use

**Triggers:**
- "How do we monetize without virtual items or ads?"
- "Should we build an in-app economy (virtual items) or refer to external partners?"
- "Integrating Affiliate Links (books, music, goods) in a natural, clean design."
- "Monetizing emotional or niche products (like MUJI style apps)."
- "Partnering with e-commerce, book stores, and streaming APIs."

**Context:**
- Products focusing on emotional connection, journaling, curation (DOCA Corner, books, music).
- Lean MVP teams wishing to bypass heavy payment gateway integrations, virtual inventory logic, and legal digital tax compliance.
- High-trust user bases where recommendations feel curated and organic rather than forced.

---

## Core Frameworks

### 1. Virtual Assets Shop vs. Contextual Affiliate Referral (Comparison)

| Metric | Virtual Item Shop (CatCoins, Pate, Toys) | Contextual Affiliate Referral (Books, Music, Items) |
| :--- | :--- | :--- |
| **Development Cost** | **High** (Inventory database, transaction ledgers, item state sync, store UI). | **Low** (Simple metadata mapping, URL builder with affiliate ID, standard WebView/InAppBrowser). |
| **Payment Integration**| **Complex** (App Store / Google Play In-App Purchases: 15-30% cut, local bank gateways, audit trails). | **None** (User pays on the partner platform; payout happens via partner dashboard: Shopee, Fahasa, Tiki, Amazon). |
| **Legal & Compliance** | **High** (Virtual currency regulation, VAT/tax filing on digital goods, anti-money laundering risk). | **Negligible** (Standard advertising referral agreements, no handling of user financial data). |
| **UI/UX Philosophy** | **Intrusive** (Forces "buying" triggers, gamification loops, popups, breaking MUJI minimalism). | **Cozy & Organic** (Curation shelf, natural links, reading recommendations like a friend sharing a link). |
| **Conversion Mechanics**| In-app currency exchange, microtransactions. | Natural contextual entity identification (e.g., clicking on a book name, song, or character porter). |

---

### 2. The Contextual Referral Link Engine (Entity to Yield)

To turn mentions of cultural artifacts (books, music, characters, posters) in **DOCA Corner** or **DOCA Capsule** into revenue without breaking MUJI minimalism:

1. **Entity Extraction**: 
   When a user adds a record to their Timeline (DOCA Capsule) or updates their shelf (DOCA Corner) with a book, artist, or song, extract the metadata:
   - `Type`: Book, Music, Poster, Figure, Cozy Item.
   - `Key`: Title, Author/Artist, Publisher.

2. **Affiliate Link Resolution (Local-first with API Fallback)**:
   - For Books: Construct affiliate deep links using the **Fahasa Affiliate API**, **Tiki Affiliate**, **Shopee Link Generator**, or **Amazon Associates** (for global/US market).
   - For Music: Redirect to **Spotify Premium/Apple Music Referral** (if applicable) or **Shopee/Tiki** for vinyl/CD products.
   - For Merchandise (Posters, figures): Redirect to **Shopee/Lazada Affiliate** search pages using the specific keyword query with the developer's affiliate token.

3. **Minimalist Presentation (The Muji Way)**:
   - Avoid flashy "Buy Now" banners.
   - Use clean, 1px-border cards with standard typography.
   - Use simple indicators like `[Tìm hiểu thêm ↗]` or `[Ghé Fahasa / Shopee ↗]`.
   - Text links should be styled cleanly in inline text.

---

### 3. Monetization Optimization Loop

1. **Keep it Native to Curation**: The user edits their cozy shelf (DOCA Corner) because they genuinely love these books and songs. The affiliate links act as an enabler for *others* visiting the shelf or the virtual pet recommending books during chat based on the pet's "reading list".
2. **Double Down on High-Margin Categories**:
   - Physical Books: Higher trust, Fahasa/Tiki/Amazon referral rates are stable (4% - 10%).
   - Cozy MUJI-style home goods (Diffusers, blankets, notebooks): High ticket items on Shopee/Lazada, yielding higher absolute commissions.
3. **Conversational Referral Trigger**:
   - The pet (DOCA PetTwin) asks: *"Hôm nay ba đang đọc cuốn sách gì thế?"* (What book are you reading today, Dad?)
   - User replies: *"Ba đang đọc Chiến Binh Cầu Vồng"* (I'm reading The Rainbow Troops).
   - Pet records the event in the Timeline and responds with a cozy recommendation: *"Cuốn đó hay lắm ba! Con thấy ở góc đọc sách của nhiều ba mẹ khác cũng treo quyển này. Để con bỏ vào Sổ Tay cho ba dễ tìm nhé!"* -> In the notebook tab, the book "Chiến Binh Cầu Vồng" appears with a clean Fahasa/Shopee affiliate link.

---

## Decision Trees

### Virtual Item Economy vs. Affiliate Curation

```
Are you launching an MVP with <3 months dev time?
├─ Yes → Choose Affiliate Link Model (Zero payment gateway integration, easy validation)
└─ No → Do you have licensing for intellectual property or unique artwork?
    ├─ No → Choose Affiliate Link Model (Cozy curation is cheaper to operate)
    └─ Yes → Consider Virtual Item Shop (If custom Lottie assets are highly requested)
```

---

## Common Mistakes

1. **Breaking Minimalism with Aggressive Ad-banners**: Putting popups or blinking "Shop Now" buttons violates the MUJI design philosophy and drives users away.
2. **Broken Affiliate Redirects**: Standard deep links must open gracefully in an In-App Browser/System Browser and retain the affiliate cookie payload.
3. **Overcomplicating the Catalog**: Trying to catalog millions of items. Instead, use search query affiliate redirects: `shopee.vn/search?keyword=[Item_Name]&utm_source=doca_affiliate`.

---

## Related Skills
- **gtm-product-led-growth**: Aligning acquisition with monetization triggers.
- **finance-expert**: Calculating unit economics and commission paybacks.
- **product-brainstorming**: Translating user hobbies into monetization categories.
