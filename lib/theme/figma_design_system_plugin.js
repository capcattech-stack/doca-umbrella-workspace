// ═══════════════════════════════════════════════════════════════════
// CAPCAT DESIGN SYSTEM — Figma Plugin Script
// Version: v1.2.0-MujiUnifiedComponents
// Cách chạy: Xem hướng dẫn ở cuối file
// ═══════════════════════════════════════════════════════════════════

(async () => {

// ── HELPERS ──────────────────────────────────────────────────────────
const hex = (h) => {
  const r = parseInt(h.slice(1,3),16)/255;
  const g = parseInt(h.slice(3,5),16)/255;
  const b = parseInt(h.slice(5,7),16)/255;
  return { r, g, b };
};
const solid = (h, a=1) => ({ type:'SOLID', color: hex(h), opacity: a });

const loadFont = async (family, style) => {
  try { await figma.loadFontAsync({ family, style }); }
  catch(e) { await figma.loadFontAsync({ family: 'Inter', style: 'Regular' }); }
};

// Pre-load all fonts used
await Promise.all([
  figma.loadFontAsync({ family:'Inter', style:'Regular' }),
  figma.loadFontAsync({ family:'Inter', style:'Medium' }),
  figma.loadFontAsync({ family:'Inter', style:'Semi Bold' }),
  figma.loadFontAsync({ family:'Inter', style:'Bold' }),
]);

// ── SWITCH TO DESIGN SYSTEM PAGE ────────────────────────────────────
const pages = figma.root.children;
let dsPage = pages.find(p => p.name.includes('Design System') || p.name.includes('🎨'));
if (!dsPage) {
  dsPage = figma.createPage();
  dsPage.name = '🎨 Design System';
}
await figma.setCurrentPageAsync(dsPage);
for (const child of [...dsPage.children]) child.remove();
dsPage.backgrounds = [{ type:'SOLID', color:{ r:0.961, g:0.961, b:0.961 } }];

// ── COLOR PALETTE ────────────────────────────────────────────────────
const COLORS = {
  // Cozy Light
  pureWhite:    '#FBFAF6',
  oatmealBg:    '#E8E3D6',
  milkBeige:    '#F4F1E9',
  paperCream:   '#FBFAF6',
  deepObsidian: '#15170F',
  charcoalBlack:'#15170F',
  borderLight:  '#EAEAEA',
  hintGray:     '#8C8C8C',
  // Cozy Dark
  darkSlate:    '#0D0D0D',
  ticketCharcoal:'#1E1F24',
  neonGreen:    '#76C123',
  warmAmber:    '#FFF9C4',
  // Accents
  sakuraPink:   '#F4ABBE',
  matchaGreen:  '#8FBF4F',
  sakuraPinkPastel: '#F4ABBE',
  sakuraPinkBright: '#E07090',
  sakuraPinkMauve:  '#C470A0',
  matchaGreenForest:'#4A8A2E',
  matchaGreenWarm:  '#8FBF4F',
  matchaGreenDark:  '#1F3E12',
  matchaCreamWarm:  '#F5EDD5',
  catPeach:     '#FFD1BA',
  // Wood Accents
  woodSugi:     '#8B5E3C',
  woodKogecha:  '#4A2418',
  woodKohaku:   '#B8860A',
  // Semantic
  successBg:    '#E8F5E9',
  warningBg:    '#FFE0B2',
  errorBg:      '#FFCDD2',
  infoBg:       '#E1F5FE',
};

// ── LAYOUT CONSTANTS ──────────────────────────────────────────────────
const PAD = 48;
const COL_GAP = 24;
const ROW_GAP = 64;
let cursorY = PAD;

// ── TEXT HELPER ──────────────────────────────────────────────────────
const makeText = async (content, { x=0, y=0, size=14, weight='Regular', color='#1C1C1E', width=null } = {}) => {
  const t = figma.createText();
  const style = weight === 'Bold' ? 'Bold' : weight === 'Semi Bold' ? 'Semi Bold' : weight === 'Medium' ? 'Medium' : 'Regular';
  await figma.loadFontAsync({ family:'Inter', style });
  t.fontName = { family:'Inter', style };
  t.fontSize = size;
  t.characters = content;
  t.fills = [solid(color)];
  t.x = x; t.y = y;
  if (width) { t.textAutoResize = 'HEIGHT'; t.resize(width, t.height); }
  return t;
};

// ── FRAME HELPER ─────────────────────────────────────────────────────
const makeFrame = ({ x=0, y=0, w=200, h=100, fill=null, radius=0, stroke=null, name='Frame' } = {}) => {
  const f = figma.createFrame();
  f.name = name;
  f.x = x; f.y = y;
  f.resize(w, h);
  f.cornerRadius = radius;
  f.fills = fill ? [solid(fill)] : [{ type:'SOLID', color:{r:0,g:0,b:0}, opacity:0 }];
  if (stroke) {
    f.strokes = [solid(stroke)];
    f.strokeWeight = 1;
    f.strokeAlign = 'INSIDE';
  }
  return f;
};

// ═══════════════════════════════════════════════════════════════════
// SECTION 1: HEADER
// ═══════════════════════════════════════════════════════════════════
const CANVAS_W = 1440;

// Header background
const header = makeFrame({ x:0, y:0, w:CANVAS_W, h:180, fill:COLORS.warmAmber, name:'🎨 Header' });
header.fills = [{
  type: 'GRADIENT_LINEAR',
  gradientTransform: [[1,0,0],[0,1,0]],
  gradientStops: [
    { position:0, color:{ r:1, g:0.976, b:0.769, a:1 } },
    { position:1, color:{ r:1, g:0.820, b:0.729, a:0.4 } },
  ]
}];
dsPage.appendChild(header);

const h1 = await makeText('🎨  Capcat Design System', { x:PAD, y:40, size:36, weight:'Bold', color:COLORS.charcoalBlack });
header.appendChild(h1);
const h2 = await makeText('Iyashikei · Muji Warmth · Cozy Healing  —  v1.2.0-MujiUnifiedComponents', { x:PAD, y:90, size:14, weight:'Regular', color:COLORS.hintGray });
header.appendChild(h2);

const badge1 = makeFrame({ x:PAD, y:120, w:80, h:26, fill:COLORS.charcoalBlack, radius:6, name:'Badge Flutter' });
header.appendChild(badge1);
const bt1 = await makeText('Flutter · Dart', { x:10, y:5, size:11, weight:'Semi Bold', color:COLORS.pureWhite });
badge1.appendChild(bt1);

const badge2 = makeFrame({ x:PAD+90, y:120, w:80, h:26, fill:COLORS.borderLight, radius:6, name:'Badge Maya' });
header.appendChild(badge2);
const bt2 = await makeText('Maya · UI/UX', { x:10, y:5, size:11, weight:'Semi Bold', color:COLORS.hintGray });
badge2.appendChild(bt2);

cursorY = 220;

// ═══════════════════════════════════════════════════════════════════
// SECTION 2: COLOR TOKENS
// ═══════════════════════════════════════════════════════════════════
const sectionLabel = async (label, emoji, y) => {
  const sFrame = makeFrame({ x:PAD, y, w:CANVAS_W-PAD*2, h:36, name:`Section ${label}` });
  dsPage.appendChild(sFrame);
  const sLabel = await makeText(`${emoji}  ${label}`, { x:0, y:4, size:20, weight:'Bold', color:COLORS.charcoalBlack });
  sFrame.appendChild(sLabel);
  // Divider line
  const line = figma.createLine();
  line.x = 0; line.y = 33;
  line.resize(CANVAS_W-PAD*2, 0);
  line.strokes = [solid(COLORS.borderLight)];
  line.strokeWeight = 1;
  sFrame.appendChild(line);
  return sFrame.height + 16;
};

cursorY += await sectionLabel('Color Tokens', '🎨', cursorY);

// Sub-label helper
const subLabel = async (text, x, y) => {
  const t = await makeText(text, { x, y, size:11, weight:'Semi Bold', color:COLORS.hintGray });
  dsPage.appendChild(t);
  return t;
};

// Color swatch helper
const makeSwatch = async ({ label, hex: h, desc, x, y, dark=false }) => {
  const card = makeFrame({ x, y, w:160, h:110, radius:12, stroke:COLORS.borderLight, name:`Swatch/${label}` });
  dsPage.appendChild(card);
  // Color block
  const colorBlock = makeFrame({ x:0, y:0, w:160, h:66, fill:h, name:'Color' });
  if (h === COLORS.pureWhite || h === COLORS.paperCream || h === COLORS.oatmealBg || h === COLORS.milkBeige) {
    colorBlock.strokes = [solid(COLORS.borderLight)];
    colorBlock.strokeWeight = 1;
    colorBlock.strokeAlign = 'INSIDE';
  }
  card.appendChild(colorBlock);
  // Info
  const nameT = await makeText(label, { x:10, y:72, size:11, weight:'Semi Bold', color:COLORS.charcoalBlack });
  card.appendChild(nameT);
  const hexT = await makeText(h, { x:10, y:88, size:10, weight:'Regular', color:COLORS.hintGray });
  card.appendChild(hexT);
};

// Cozy Light swatches
await subLabel('COZY LIGHT — CHỦ ĐẠO', PAD, cursorY);
cursorY += 20;

const lightSwatches = [
  { label:'Pure White',     hex:COLORS.pureWhite,     desc:'Nền ứng dụng' },
  { label:'Oatmeal Bg',     hex:COLORS.oatmealBg,     desc:'Nền phụ' },
  { label:'Milk Beige',     hex:COLORS.milkBeige,     desc:'Thẻ Moments' },
  { label:'Paper Cream',    hex:COLORS.paperCream,    desc:'Nền input' },
  { label:'Deep Obsidian',  hex:COLORS.deepObsidian,  desc:'Chữ chính' },
  { label:'Charcoal Black', hex:COLORS.charcoalBlack, desc:'Primary Button' },
  { label:'Border Light',   hex:COLORS.borderLight,   desc:'Viền' },
  { label:'Cat Peach',      hex:COLORS.catPeach,      desc:'Chat bubble Sen' },
];
for (let i=0; i<lightSwatches.length; i++) {
  await makeSwatch({ ...lightSwatches[i], x: PAD + i*(160+12), y: cursorY });
}
cursorY += 110 + 28;

// Cozy Dark swatches
await subLabel('COZY DARK — CHUYÊN BIỆT', PAD, cursorY);
cursorY += 20;
const darkSwatches = [
  { label:'Dark Slate',      hex:COLORS.darkSlate },
  { label:'Ticket Charcoal', hex:COLORS.ticketCharcoal },
  { label:'Neon Green',      hex:COLORS.neonGreen },
  { label:'Warm Amber',      hex:COLORS.warmAmber },
];
for (let i=0; i<darkSwatches.length; i++) {
  await makeSwatch({ ...darkSwatches[i], x: PAD + i*(160+12), y: cursorY });
}
cursorY += 110 + 28;

// Accents
await subLabel('EMOTIONAL ACCENTS — NHẬT BẢN', PAD, cursorY);
cursorY += 20;
const accentSwatches = [
  { label:'Sakura Pastel',  hex:COLORS.sakuraPinkPastel },
  { label:'Sakura Bright',  hex:COLORS.sakuraPinkBright },
  { label:'Sakura Mauve',   hex:COLORS.sakuraPinkMauve },
  { label:'Matcha Warm',    hex:COLORS.matchaGreenWarm },
  { label:'Matcha Forest',  hex:COLORS.matchaGreenForest },
  { label:'Matcha Dark',    hex:COLORS.matchaGreenDark },
  { label:'Matcha Cream',   hex:COLORS.matchaCreamWarm },
];
for (let i=0; i<accentSwatches.length; i++) {
  await makeSwatch({ ...accentSwatches[i], x: PAD + i*(160+12), y: cursorY });
}
cursorY += 110 + 28;

// Wood Accents
await subLabel('WOOD ACCENTS — GỖ TRUYỀN THỐNG NHẬT BẢN', PAD, cursorY);
cursorY += 20;
const woodSwatches = [
  { label:'Wood Sugi',    hex:COLORS.woodSugi },
  { label:'Wood Kogecha', hex:COLORS.woodKogecha },
  { label:'Wood Kohaku',  hex:COLORS.woodKohaku },
];
for (let i=0; i<woodSwatches.length; i++) {
  await makeSwatch({ ...woodSwatches[i], x: PAD + i*(160+12), y: cursorY });
}
cursorY += 110 + 28;

// Semantic
await subLabel('SEMANTIC SOFT COLORS', PAD, cursorY);
cursorY += 20;
const semanticSwatches = [
  { label:'Cozy Success', hex:COLORS.successBg },
  { label:'Cozy Warning', hex:COLORS.warningBg },
  { label:'Cozy Error',   hex:COLORS.errorBg },
  { label:'Cozy Info',    hex:COLORS.infoBg },
];
for (let i=0; i<semanticSwatches.length; i++) {
  await makeSwatch({ ...semanticSwatches[i], x: PAD + i*(160+12), y: cursorY });
}
cursorY += 110 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 3: TYPOGRAPHY
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('Typography Scale', '✍️', cursorY);
cursorY += 52;

const typeRows = [
  { token:'displayLarge',  sample:'Bánh Mỳ & Lucky', size:32, weight:'Bold',      spec:'Quicksand Bold · 32px · 1.2' },
  { token:'headlineLarge', sample:'Thẻ Ký Ức Hôm Nay', size:24, weight:'Bold',   spec:'Quicksand Bold · 24px · 1.3' },
  { token:'titleLarge',    sample:'Nguyên Đặng · Tiêu đề Chat', size:20, weight:'Semi Bold', spec:'Quicksand SemiBold · 20px · 1.4' },
  { token:'bodyLarge',     sample:'Nội dung tin nhắn thân mật của Boss & Sen', size:16, weight:'Medium', spec:'Quicksand Medium · 16px · 1.5' },
  { token:'bodyMedium',    sample:'Mô tả hoạt động chăm sóc thường nhật, thẻ phụ, trang cài đặt', size:14, weight:'Regular', spec:'Nunito Regular · 14px · 1.5' },
  { token:'buttonText',    sample:'Bắt Đầu Ngay →', size:15, weight:'Semi Bold', spec:'Quicksand SemiBold · 15px · 1.0' },
  { token:'numericLabel',  sample:'4.2 kg  ·  32 phút  ·  18:30', size:13, weight:'Semi Bold', spec:'Outfit SemiBold · 13px · 1.2' },
  { token:'captionText',   sample:'Hôm nay lúc 22:15  ·  Chú thích phụ', size:12, weight:'Regular', spec:'Nunito Regular · 12px · 1.4', color:COLORS.hintGray },
];

for (const row of typeRows) {
  // Token chip
  const chip = makeFrame({ x:PAD, y:cursorY, w:180, h:28, fill:COLORS.oatmealBg, radius:6, stroke:COLORS.borderLight, name:`TypeToken/${row.token}` });
  dsPage.appendChild(chip);
  const ct = await makeText(row.token, { x:10, y:7, size:11, weight:'Semi Bold', color:COLORS.hintGray });
  chip.appendChild(ct);

  // Spec label
  const specT = await makeText(row.spec, { x:PAD+190, y:cursorY+8, size:11, weight:'Regular', color:COLORS.hintGray });
  dsPage.appendChild(specT);

  // Sample text
  const sampleT = await makeText(row.sample, {
    x: PAD+440, y: cursorY + (28 - row.size*1.2)/2,
    size: row.size,
    weight: row.weight,
    color: row.color || COLORS.charcoalBlack,
    width: CANVAS_W - PAD - 440 - PAD,
  });
  dsPage.appendChild(sampleT);

  cursorY += Math.max(28, row.size * 1.4) + 16;
}
cursorY += ROW_GAP - 16;

// ═══════════════════════════════════════════════════════════════════
// SECTION 4: BORDER RADIUS
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('Border Radius & Shapes', '🎴', cursorY);
cursorY += 52;

const radii = [
  { r:8,  label:'cozyTag · cozyAvatar\nInput · Grid Card' },
  { r:12, label:'cozyButton\nNút hành động' },
  { r:16, label:'cozyCard\nThẻ chính · Dialog' },
  { r:24, label:'Bottom Sheet\n(top corners)' },
  { r:28, label:'Boarding Pass\nThẻ cao cấp' },
];

for (let i=0; i<radii.length; i++) {
  const { r, label } = radii[i];
  const x = PAD + i * (140 + 16);
  const card = makeFrame({ x, y:cursorY, w:140, h:80, fill:COLORS.pureWhite, radius:r, stroke:COLORS.borderLight, name:`Radius/${r}px` });
  dsPage.appendChild(card);
  const valT = await makeText(`${r}px`, { x:50, y:24, size:22, weight:'Bold', color:COLORS.charcoalBlack });
  card.appendChild(valT);
  const lblT = await makeText(label, { x:PAD + i*(140+16), y:cursorY+90, size:11, weight:'Regular', color:COLORS.hintGray, width:140 });
  dsPage.appendChild(lblT);
}
cursorY += 80 + 48 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 5: BUTTONS
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('UI Components — Buttons', '🛠', cursorY);
cursorY += 52;

const buttons = [
  { label:'Bắt Đầu Ngay →', bg:COLORS.charcoalBlack, fg:COLORS.pureWhite, name:'Primary Button' },
  { label:'Quay Lại',        bg:COLORS.oatmealBg,     fg:COLORS.deepObsidian, stroke:COLORS.borderLight, name:'Secondary Button' },
  { label:'Cho Bánh Mỳ Ăn 💖', bg:'#EAB0B233', fg:COLORS.deepObsidian, name:'Cat Sensory Button' },
  { label:'Đi Dạo Lucky 🐾', bg:'#A3B89233',  fg:COLORS.deepObsidian, name:'Dog Sensory Button' },
  { label:'Premium ✦',       bg:COLORS.neonGreen, fg:COLORS.charcoalBlack, name:'Premium Button' },
];

let btnX = PAD;
for (const btn of buttons) {
  const textWidth = btn.label.length * 8 + 48;
  const btnFrame = makeFrame({ x:btnX, y:cursorY, w:textWidth, h:48, radius:12, name:btn.name });
  // Fill
  if (btn.bg.length === 9) { // hex with alpha
    const alpha = parseInt(btn.bg.slice(7,9),16)/255;
    const baseHex = btn.bg.slice(0,7);
    btnFrame.fills = [{ type:'SOLID', color: hex(baseHex), opacity: alpha }];
  } else {
    btnFrame.fills = [solid(btn.bg)];
  }
  if (btn.stroke) {
    btnFrame.strokes = [solid(btn.stroke)];
    btnFrame.strokeWeight = 1;
    btnFrame.strokeAlign = 'INSIDE';
  }
  dsPage.appendChild(btnFrame);
  const btnT = await makeText(btn.label, { x:24, y:15, size:15, weight:'Semi Bold', color:btn.fg });
  btnFrame.appendChild(btnT);
  // Label below
  const nameT = await makeText(btn.name, { x:btnX, y:cursorY+56, size:10, weight:'Regular', color:COLORS.hintGray });
  dsPage.appendChild(nameT);
  btnX += textWidth + 16;
}
cursorY += 48 + 48 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 6: CARDS
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('UI Components — Cards', '🗂', cursorY);
cursorY += 52;

// Card 1: Light Card
const lightCard = makeFrame({ x:PAD, y:cursorY, w:220, h:160, fill:COLORS.pureWhite, radius:16, stroke:COLORS.borderLight, name:'Light Card' });
dsPage.appendChild(lightCard);
const lc1 = await makeText('Bánh Mỳ', { x:16, y:16, size:16, weight:'Bold', color:COLORS.charcoalBlack });
lightCard.appendChild(lc1);
const lcTag = makeFrame({ x:16, y:44, w:64, h:22, fill:COLORS.oatmealBg, radius:6, stroke:COLORS.borderLight, name:'Tag' });
lightCard.appendChild(lcTag);
const lcTagT = await makeText('🐱 Mèo', { x:8, y:4, size:11, weight:'Semi Bold', color:COLORS.hintGray });
lcTag.appendChild(lcTagT);
const lcDesc = await makeText('Thẻ bài chính · Light mode\nBorder 1px · Shadow loãng', { x:16, y:76, size:12, weight:'Regular', color:COLORS.hintGray, width:188 });
lightCard.appendChild(lcDesc);
const lcLbl = await makeText('Light Card · pureWhite bg', { x:PAD, y:cursorY+168, size:10, weight:'Regular', color:COLORS.hintGray });
dsPage.appendChild(lcLbl);

// Card 2: Moments Card
const momCard = makeFrame({ x:PAD+244, y:cursorY, w:220, h:160, fill:COLORS.milkBeige, radius:16, stroke:COLORS.borderLight, name:'Moments Card' });
dsPage.appendChild(momCard);
const mc1 = await makeText('✨ Ký Ức Hôm Nay', { x:16, y:16, size:14, weight:'Bold', color:COLORS.charcoalBlack });
momCard.appendChild(mc1);
const mc2 = await makeText('Nền Milk Beige · Moments\nGiấy thủ công ấm áp', { x:16, y:50, size:12, weight:'Regular', color:COLORS.hintGray, width:188 });
momCard.appendChild(mc2);
const mcLbl = await makeText('Moments Card · milkBeige bg', { x:PAD+244, y:cursorY+168, size:10, weight:'Regular', color:COLORS.hintGray });
dsPage.appendChild(mcLbl);

// Card 3: Dark Ticket
const tickCard = makeFrame({ x:PAD+488, y:cursorY, w:220, h:160, fill:COLORS.ticketCharcoal, radius:16, name:'Ticket Card' });
tickCard.strokes = [solid('#2C2C2E')]; tickCard.strokeWeight=1; tickCard.strokeAlign='INSIDE';
dsPage.appendChild(tickCard);
const tc1 = await makeText('🚂 Boarding Pass', { x:16, y:16, size:14, weight:'Bold', color:COLORS.pureWhite });
tickCard.appendChild(tc1);
const tc2 = await makeText('Ticket Charcoal · Dark mode\nBo góc 16px sang trọng', { x:16, y:50, size:12, weight:'Regular', color:COLORS.hintGray, width:188 });
tickCard.appendChild(tc2);
const premiumDot = makeFrame({ x:16, y:116, w:80, h:22, fill:COLORS.neonGreen, radius:11, name:'Premium Badge' });
tickCard.appendChild(premiumDot);
const pdT = await makeText('● PREMIUM', { x:8, y:4, size:11, weight:'Semi Bold', color:COLORS.charcoalBlack });
premiumDot.appendChild(pdT);
const tcLbl = await makeText('Ticket Card · ticketCharcoal bg', { x:PAD+488, y:cursorY+168, size:10, weight:'Regular', color:COLORS.hintGray });
dsPage.appendChild(tcLbl);

// Card 4: Boarding Pass (28px)
const bpCard = makeFrame({ x:PAD+732, y:cursorY, w:220, h:160, fill:COLORS.ticketCharcoal, radius:28, name:'Boarding Pass Card' });
bpCard.strokes = [solid('#2C2C2E')]; bpCard.strokeWeight=1; bpCard.strokeAlign='INSIDE';
dsPage.appendChild(bpCard);
const bp1 = await makeText('🎫 Boarding Pass+', { x:16, y:16, size:14, weight:'Bold', color:COLORS.pureWhite });
bpCard.appendChild(bp1);
const bp2 = await makeText('Bo góc 28px đặc biệt\nCao cấp nhất', { x:16, y:50, size:12, weight:'Regular', color:COLORS.hintGray, width:188 });
bpCard.appendChild(bp2);
const bpLbl = await makeText('Boarding Pass · radius 28px', { x:PAD+732, y:cursorY+168, size:10, weight:'Regular', color:COLORS.hintGray });
dsPage.appendChild(bpLbl);

cursorY += 160 + 56 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 7: CHAT BUBBLES
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('UI Components — Chat Bubbles', '💬', cursorY);
cursorY += 52;

const chatFrame = makeFrame({ x:PAD, y:cursorY, w:360, h:180, fill:COLORS.pureWhite, radius:16, stroke:COLORS.borderLight, name:'Chat Demo' });
dsPage.appendChild(chatFrame);

// Sen bubble (right)
const senBubble = makeFrame({ x:100, y:16, w:244, h:48, fill:COLORS.catPeach, radius:16, name:'Bubble Sen' });
senBubble.bottomRightRadius = 4;
chatFrame.appendChild(senBubble);
const sb1 = await makeText('Hôm nay Bánh Mỳ có ngoan không? 🐱', { x:12, y:14, size:13, weight:'Medium', color:COLORS.charcoalBlack, width:220 });
senBubble.appendChild(sb1);

// Pet bubble (left)
const petBubble = makeFrame({ x:16, y:76, w:244, h:48, fill:COLORS.milkBeige, radius:16, name:'Bubble Pet' });
petBubble.bottomLeftRadius = 4;
chatFrame.appendChild(petBubble);
const pb1 = await makeText('Mèo đã ăn xong và đang ngủ trưa ấm áp 💤', { x:12, y:14, size:13, weight:'Medium', color:COLORS.charcoalBlack, width:220 });
petBubble.appendChild(pb1);

// Sen bubble 2
const senBubble2 = makeFrame({ x:100, y:136, w:244, h:32, fill:COLORS.catPeach, radius:16, name:'Bubble Sen 2' });
senBubble2.bottomRightRadius = 4;
chatFrame.appendChild(senBubble2);
const sb2 = await makeText('Ngoan quá! Tối nay Sen sẽ vuốt ve nhiều 💖', { x:12, y:8, size:13, weight:'Medium', color:COLORS.charcoalBlack, width:220 });
senBubble2.appendChild(sb2);

cursorY += 180 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 8: GRADIENTS
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('Healing Gradients', '🌅', cursorY);
cursorY += 52;

const gradients = [
  {
    name:'☀️ Vạt Nắng Xiên',
    stops:[
      { position:0, color:{ r:1, g:0.976, b:0.769, a:1 } },
      { position:1, color:{ r:1, g:0.820, b:0.729, a:0.4 } },
    ],
    textColor: COLORS.charcoalBlack
  },
  {
    name:'🌆 Hoàng Hôn Ga Tàu',
    stops:[
      { position:0, color:{ r:0.071, g:0.055, b:0.180, a:1 } },
      { position:1, color:{ r:0.071, g:0.071, b:0.071, a:1 } },
    ],
    textColor: COLORS.milkBeige
  },
  {
    name:'💗 Hơi Ấm Trái Tim',
    stops:[
      { position:0, color:{ r:1, g:0.898, b:0.851, a:1 } },
      { position:1, color:{ r:1, g:1, b:1, a:1 } },
    ],
    textColor: COLORS.charcoalBlack
  },
];

for (let i=0; i<gradients.length; i++) {
  const g = gradients[i];
  const gFrame = makeFrame({ x:PAD + i*(240+16), y:cursorY, w:240, h:100, radius:16, name:`Gradient/${g.name}` });
  gFrame.fills = [{
    type:'GRADIENT_LINEAR',
    gradientTransform:[[1,0,0],[0,1,0]],
    gradientStops: g.stops
  }];
  gFrame.strokes = [solid(COLORS.borderLight)];
  gFrame.strokeWeight = 1;
  gFrame.strokeAlign = 'INSIDE';
  dsPage.appendChild(gFrame);
  const gT = await makeText(g.name, { x:16, y:68, size:13, weight:'Semi Bold', color:g.textColor });
  gFrame.appendChild(gT);
}
cursorY += 100 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 9: INPUT FIELD
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('UI Components — Input Field', '✏️', cursorY);
cursorY += 52;

const inputDemo = makeFrame({ x:PAD, y:cursorY, w:320, h:52, fill:COLORS.paperCream, radius:8, stroke:COLORS.borderLight, name:'Input/Default' });
dsPage.appendChild(inputDemo);
const inputHint = await makeText('Nhập tên biệt danh của Boss...', { x:16, y:16, size:15, weight:'Regular', color:COLORS.hintGray });
inputDemo.appendChild(inputHint);

const inputActive = makeFrame({ x:PAD+340, y:cursorY, w:320, h:52, fill:COLORS.paperCream, radius:8, name:'Input/Active' });
inputActive.strokes = [solid(COLORS.charcoalBlack)]; inputActive.strokeWeight=1; inputActive.strokeAlign='INSIDE';
dsPage.appendChild(inputActive);
const inputText = await makeText('Bánh Mỳ yêu quý~', { x:16, y:16, size:15, weight:'Medium', color:'#262626' });
inputActive.appendChild(inputText);

const inputLbl1 = await makeText('Default state', { x:PAD, y:cursorY+60, size:10, weight:'Regular', color:COLORS.hintGray });
dsPage.appendChild(inputLbl1);
const inputLbl2 = await makeText('Active / Focused (border #121212)', { x:PAD+340, y:cursorY+60, size:10, weight:'Regular', color:COLORS.hintGray });
dsPage.appendChild(inputLbl2);

cursorY += 52 + 48 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 10: BOTTOM SHEET PREVIEW
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('UI Components — Bottom Sheet', '📋', cursorY);
cursorY += 52;

const bsFrame = makeFrame({ x:PAD, y:cursorY, w:360, h:220, fill:COLORS.paperCream, radius:24, stroke:COLORS.borderLight, name:'Bottom Sheet' });
bsFrame.bottomLeftRadius = 0; bsFrame.bottomRightRadius = 0;
dsPage.appendChild(bsFrame);

// Drag handle
const dh = makeFrame({ x:160, y:12, w:40, h:4, fill:COLORS.borderLight, radius:2, name:'Drag Handle' });
bsFrame.appendChild(dh);
// Title
const bsTitle = await makeText('Ghi Nhận Ký Ức', { x:24, y:36, size:18, weight:'Bold', color:COLORS.charcoalBlack });
bsFrame.appendChild(bsTitle);
// Body
const bsBody = await makeText('Thêm khoảnh khắc đặc biệt hôm nay vào kho lưu trữ tình cảm của bạn và Bánh Mỳ.', { x:24, y:72, size:13, weight:'Regular', color:COLORS.hintGray, width:312 });
bsFrame.appendChild(bsBody);
// CTA Button
const bsCta = makeFrame({ x:24, y:150, w:312, h:48, fill:COLORS.charcoalBlack, radius:12, name:'CTA Button' });
bsFrame.appendChild(bsCta);
const bsCtaT = await makeText('Lưu Ký Ức này ✦', { x:120, y:15, size:15, weight:'Semi Bold', color:COLORS.pureWhite });
bsCta.appendChild(bsCtaT);

cursorY += 220 + ROW_GAP;

// ═══════════════════════════════════════════════════════════════════
// SECTION 11: SEMANTIC BADGES
// ═══════════════════════════════════════════════════════════════════
await sectionLabel('UI Components — Semantic Badges', '🏷', cursorY);
cursorY += 52;

const badges = [
  { label:'✓ Cozy Success', bg:COLORS.successBg, fg:'#4E6A3E' },
  { label:'⚠ Cozy Warning', bg:COLORS.warningBg, fg:'#7A4E00' },
  { label:'✕ Cozy Error',   bg:COLORS.errorBg,   fg:'#B71C1C' },
  { label:'ℹ Cozy Info',    bg:COLORS.infoBg,    fg:'#01579B' },
];
let badgeX = PAD;
for (const b of badges) {
  const bFrame = makeFrame({ x:badgeX, y:cursorY, w:b.label.length*8+20, h:28, fill:b.bg, radius:8, name:`Badge/${b.label}` });
  dsPage.appendChild(bFrame);
  const bT = await makeText(b.label, { x:10, y:7, size:12, weight:'Semi Bold', color:b.fg });
  bFrame.appendChild(bT);
  badgeX += b.label.length*8+20 + 12;
}

cursorY += 28 + ROW_GAP*2;

// ── ZOOM TO FIT ──────────────────────────────────────────────────────
figma.viewport.scrollAndZoomIntoView(dsPage.children);

return {
  status: '✅ Capcat Design System đã được tạo thành công trên Figma!',
  page: dsPage.name,
  sections: ['Color Tokens', 'Typography Scale', 'Border Radius', 'Buttons', 'Cards', 'Chat Bubbles', 'Gradients', 'Input Fields', 'Bottom Sheet', 'Semantic Badges'],
  totalHeight: cursorY
};

})();


// ═══════════════════════════════════════════════════════════════════
// HƯỚNG DẪN CHẠY SCRIPT NÀY TRONG FIGMA
// ═══════════════════════════════════════════════════════════════════
//
// CÁCH 1 — Dùng Figma Plugin "Script Runner" (dễ nhất):
//   1. Mở Figma → file DOCA-UI
//   2. Menu: Plugins → Find more plugins → tìm "Script Runner" → Install
//   3. Chạy Script Runner → paste toàn bộ nội dung file này → Run
//
// CÁCH 2 — Dùng Figma Dev Mode / Console:
//   1. Mở Figma Desktop App
//   2. Menu: Plugins → Development → Open Console
//   3. Paste toàn bộ nội dung file này → Enter
//
// CÁCH 3 — Tạo Figma Plugin thủ công:
//   1. Menu: Plugins → Development → New Plugin
//   2. Chọn "Run once" template
//   3. Thay thế nội dung code.js bằng file này
//   4. Run plugin
//
// ⚠️  Lưu ý: Script sẽ tự navigate đến page "🎨 Design System"
//     và xóa sạch nội dung cũ trước khi tạo mới.
// ═══════════════════════════════════════════════════════════════════
