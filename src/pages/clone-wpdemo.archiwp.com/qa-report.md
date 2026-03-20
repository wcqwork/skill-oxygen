# QA Report — TheRatio Architecture Theme Clone

**Source:** wpdemo.archiwp.com/theratio (Home 1)
**Generated:** 2026-03-18
**Image Strategy:** B (All placeholders → `https://g3.leadongcdn.cn/cloud/jiBpjKiilpSRikimnnjrjo/default_img.png`)

---

## 1. Token Mapping Table

| Token Key | Source (style-tokens.json) | CSS Applied | Match? |
|---|---|---|---|
| **body font-family** | Raleway, sans-serif | `var(--font-body)` = Raleway, -apple-system, "Segoe UI", sans-serif | ✅ (with fallback) |
| **body font-size** | 16px | `body { font-size: 16px }` | ✅ |
| **body font-weight** | 400 | `body { font-weight: 400 }` | ✅ |
| **body line-height** | 30px | `body { line-height: 30px }` | ✅ |
| **body color** | rgb(85, 85, 85) | `var(--color-text-body)` = rgb(85, 85, 85) | ✅ |
| **h2 font-family** | "Titillium Web", sans-serif | `var(--font-heading)` | ✅ |
| **h2 font-size** | 24px | `h2 { font-size: 24px }` | ✅ |
| **h2 font-weight** | 400 | `h2 { font-weight: 400 }` | ✅ |
| **h2 line-height** | 48px | `h2 { line-height: 48px }` | ✅ |
| **h4 font-size** | 30px | `h4 { font-size: 30px }` | ✅ |
| **h4 text-transform** | uppercase | `h4 { text-transform: uppercase }` | ✅ |
| **h4 letter-spacing** | 0.5px | `h4 { letter-spacing: 0.5px }` | ✅ |
| **h5 font-size** | 24px | `h5 { font-size: 24px }` | ✅ |
| **h5 line-height** | 33.6px | `h5 { line-height: 33.6px }` | ✅ |
| **h6 font-size** | 18px | `h6 { font-size: 18px }` | ✅ |
| **h6 font-weight** | 600 | `h6 { font-weight: 600 }` | ✅ |
| **h6 line-height** | 25.2px | `h6 { line-height: 25.2px }` | ✅ |
| **h6 letter-spacing** | 1px | `h6 { letter-spacing: 1px }` | ✅ |
| **h6 text-transform** | uppercase | `h6 { text-transform: uppercase }` | ✅ |
| **p font-size** | 14px | `p { font-size: 14px }` | ✅ |
| **p line-height** | 26.25px | `p { line-height: 26.25px }` | ✅ |
| **button font-family** | "Titillium Web" | `var(--font-button)` | ✅ |
| **button font-size** | 13px | `.octf-btn { font-size: 13px }` | ✅ |
| **button font-weight** | 600 | `.octf-btn { font-weight: 600 }` | ✅ |
| **button bg** | rgb(26, 26, 26) | `.octf-btn { background: #1a1a1a }` | ✅ |
| **button color** | rgb(255, 255, 255) | `.octf-btn { color: #fff }` | ✅ |
| **button borderRadius** | 0px | `.octf-btn { border-radius: 0px }` | ✅ |
| **button padding** | 15px 39px (hero) / 18px 41px (general) | `.hero-btn: 15px 39px` / `.octf-btn: 18px 41px` | ✅ |
| **button text-transform** | uppercase | `.octf-btn { text-transform: uppercase }` | ✅ |
| **primary color** | #1a1a1a | `var(--color-primary)` | ✅ |
| **accent color** | #b99272 | `var(--color-accent)` | ✅ |
| **bg-dark** | rgb(42, 42, 42) | `var(--color-bg-dark)` | ✅ |
| **bg-light** | #f4f4f4 | `var(--color-bg-light)` | ✅ |
| **section-2 padding** | 90px top/bottom | `.section-about { padding: 90px 0 }` | ✅ |
| **section-3 padding** | 110px top/bottom | `.section-sketch { padding: 110px 0 }` | ✅ |
| **section-4 padding** | 71px, bg #f4f4f4 | `.section-logos { padding: 71px 0; bg: #f4f4f4 }` | ✅ |
| **section-6 padding** | 110px top/bottom | `.section-services { padding: 110px 0 }` | ✅ |
| **section-7 padding** | 0 top, 120px bottom | `.section-portfolio { padding: 0 0 120px }` | ✅ |
| **section-8 padding** | 73px top/bottom | `.section-cta { padding: 73px 0 }` | ✅ |
| **section-9 padding** | 80px top, 120px bottom | `.section-values { padding: 80px 0 120px }` | ✅ |
| **section-10 padding** | 105px top, 86px bottom | `.section-team { padding: 105px 0 86px }` | ✅ |
| **section-11 padding** | 110px top, 120px bottom | `.section-blog { padding: 110px 0 120px }` | ✅ |

---

## 2. getComputedStyle Verification Results

**Viewport:** 1440 × 900 (Desktop)
**Total Checks:** 20
**Passed:** 20/20 (100%)

| # | Label | Property | Expected | Actual | Pass |
|---|---|---|---|---|---|
| 1 | Hero h1 fontFamily | fontFamily | "Titillium Web", -apple-system, "Segoe UI", sans-serif | "Titillium Web", -apple-system, "Segoe UI", sans-serif | ✅ |
| 2 | Hero h1 fontWeight | fontWeight | 200 | 200 | ✅ |
| 3 | Hero h1 fontSize | fontSize | 90px | 90px | ✅ |
| 4 | Hero btn fontSize | fontSize | 13px | 13px | ✅ |
| 5 | Hero btn fontWeight | fontWeight | 600 | 600 | ✅ |
| 6 | Hero btn padding | padding | 15px 39px | 15px 39px | ✅ |
| 7 | Hero btn bgColor | backgroundColor | rgb(26, 26, 26) | rgb(26, 26, 26) | ✅ |
| 8 | Counter h6 fontSize | fontSize | 18px | 18px | ✅ |
| 9 | Counter h6 fontWeight | fontWeight | 600 | 600 | ✅ |
| 10 | Counter h6 letterSpacing | letterSpacing | 1px | 1px | ✅ |
| 11 | Counter h6 textTransform | textTransform | uppercase | uppercase | ✅ |
| 12 | Logo section bg | backgroundColor | rgb(244, 244, 244) | rgb(244, 244, 244) | ✅ |
| 13 | About section paddingTop | paddingTop | 90px | 90px | ✅ |
| 14 | About section paddingBottom | paddingBottom | 90px | 90px | ✅ |
| 15 | Dark btn bgColor | backgroundColor | rgb(26, 26, 26) | rgb(26, 26, 26) | ✅ |
| 16 | Dark btn color | color | rgb(255, 255, 255) | rgb(255, 255, 255) | ✅ |
| 17 | Dark btn borderRadius | borderRadius | 0px | 0px | ✅ |
| 18 | Services paddingTop | paddingTop | 110px | 110px | ✅ |
| 19 | CTA paddingTop | paddingTop | 73px | 73px | ✅ |
| 20 | Team paddingTop | paddingTop | 105px | 105px | ✅ |

---

## 3. Section Inventory

| Section # | Name | Status | Notes |
|---|---|---|---|
| 0 | Side Panel | ⏭️ Skipped | As instructed — sidebar overlay, not main content |
| 1 | Hero Slider | ✅ Built | Static slide 2 ("High-end Interior Design"), bg outline text "quality", social links, nav arrows |
| 2 | About / Welcome | ✅ Built | Dark bg with overlay, italic quote, David Oswald avatar + info |
| 3 | From Sketch to Life | ✅ Built | 50/50 layout, grid lines decoration, ot-heading with dots, button with ::before/::after lines |
| 4 | Client Logo Carousel | ✅ Built | Flat 6-item grid on #f4f4f4 background |
| 5 | Portfolio Categories | ✅ Built | 3-column grid, image + overlay text + stroke numbers (01/02/03) |
| 6 | Services + Counters | ✅ Built | Centered heading, 3 service icon-boxes, 4 counters with static values |
| 7 | Portfolio Metro Grid | ✅ Built | 4-column CSS grid with 2 span-2 items, hover overlay with info |
| 8 | CTA Banner | ✅ Built | Dark bg, italic h2, description, white "GET IN TOUCH" button |
| 9 | Company Values | ✅ Built | 50/50 layout, heading + progress bars (65%/85%/55%) + image |
| 10 | Team Carousel | ✅ Built | 5-member flat grid, hover overlay with name/role, pagination dots |
| 11 | Blog / News | ✅ Built | Header row + "VIEW ALL" button, 3 blog cards with category tags |

---

## 4. Interaction Handling (Static Rules)

| Interaction Type | Original | Preview Implementation |
|---|---|---|
| Revolution Slider (hero) | 3 slides with autoplay | Static: shows slide 2 only |
| Logo Carousel (Swiper) | 6 slides, loop, autoplay | Static: flat 6-item row |
| Team Carousel (Swiper) | 5+ slides, 3 visible, dots | Static: 5-item flat grid, decorative dots |
| Blog Carousel (Swiper) | 3 slides, 2 visible, dots | Static: 3-item flat grid |
| Counters (countUp) | Animated count from 0 | Static: shows target values (180+, 10+, 35+, 5+) |
| Portfolio hover | Overlay with title + category | CSS :hover only (opacity transition) |
| Team hover | Info overlay reveal | CSS :hover only (opacity transition) |

---

## 5. Compliance Checks

| Rule | Status |
|---|---|
| Zero `<script>` tags | ✅ No script tags in preview.html |
| No external CDN references | ✅ No Bootstrap/unpkg/cdnjs/Google Fonts |
| No original site URLs | ✅ No wpdemo.archiwp.com references |
| All styles in `<style>` | ✅ Single `<style>` block |
| System font fallbacks | ✅ -apple-system, "Segoe UI", sans-serif |
| Placeholder images | ✅ All use leadongcdn default_img.png |
| Token-driven values | ✅ 20/20 getComputedStyle checks pass |
| `<div>` for text containers | ✅ Class-bearing text containers use `<div>` |
| Responsive breakpoints | ✅ @media 1024px, 767px, 480px |

---

## 6. Screenshots

| Viewport | Resolution | File |
|---|---|---|
| Desktop | 1440 × 900 | `screenshots/preview-desktop.png` |
| Tablet | 768 × 1024 | `screenshots/preview-tablet.png` |
| Mobile | 375 × 812 | `screenshots/preview-mobile.png` |

---

## 7. Known Limitations

1. **Fonts not loaded** — System fallbacks are used since Google Fonts CDN is prohibited. Titillium Web and Raleway will render as -apple-system/Segoe UI on systems without these fonts installed.
2. **Hero slider** — Only slide 2 is displayed; slides 1 and 3 content is not visible.
3. **Portfolio grid** — Simplified from the original Masonry/Isotope layout to CSS Grid; proportions approximate but not pixel-identical.
4. **Grid line decorations** — Simplified from original (subtle vertical lines) — present but may differ in exact opacity/position.
5. **Image placeholders** — All images are identical gray placeholders; visual impact differs significantly from original imagery.
