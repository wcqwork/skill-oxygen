# QA Review Report — TheRatio Clone Preview

**Target URL:** https://wpdemo.archiwp.com/theratio/#
**Review Date:** 2026-03-18
**Review Mode:** FULL (all sections)
**Preview File:** `preview.html` (self-contained static HTML)
**Image Strategy:** B (Placeholder) — all images replaced with default placeholder

---

## Layer A: DOM Structure Diff (Weight: 40%)

### Per-Section Structure Comparison

| # | Section Name | Original Display | Clone Display | Direction Match | Child Count Match | Deduction | Notes |
|---|---|---|---|---|---|---|---|
| 1 | Hero Slider | flex (RevSlider) | flex (static) | ✅ column | ✅ ~6 children | -0 | Static adaptation acceptable; social sidebar + nav arrows preserved |
| 2 | About / Welcome | flex | flex | ✅ row | ✅ 2 cols (50/50) | -0 | Quote + person info layout matches |
| 3 | From Sketch to Life | flex | flex | ✅ row | ⚠️ Missing 1 | -5 | Missing circular text decoration "theratio interior studio since 2012" |
| 4 | Logo Carousel | flex (Swiper) | flex (static) | ✅ row | ✅ 6 items | -5 | Carousel → static flat grid; acceptable for static preview |
| 5 | Portfolio Categories | flex (3-col) | grid (3-col) | ✅ row | ✅ 3 items | -0 | Grid vs flex minor; visual result identical |
| 6 | Services + Counters | flex + inner 3+4 col | grid 3-col + grid 4-col | ✅ row | ✅ 3+4 items | -0 | Inner section structure preserved |
| 7 | Portfolio Metro | flex (filterable) | grid 4-col | ✅ auto-flow | ❌ Missing filter | -12 | **CRITICAL**: Missing portfolio filter tabs (ALL / ARCHITECTURE / DECOR / FURNITURE / INTERIOR) |
| 8 | CTA Banner | flex | flex | ✅ row | ✅ 2 cols (66/33) | -0 | Layout matches perfectly |
| 9 | Company Values | flex | flex | ✅ row | ⚠️ Missing deco | -5 | Missing decorative keyword labels ("QUALITY", "EXPERIENCE", "HARD SKILLS") around image |
| 10 | Team Carousel | flex (Swiper) | grid 5-col | ✅ row | ✅ 5 visible | -0 | Static grid showing 5 of 8 members matches original visible count |
| 11 | Blog / News | flex + Swiper | grid 3-col | ✅ row | ✅ 3 items | -0 | Header row (heading + button) + 3-card grid matches |

**Section 0 (Side Panel):** Intentionally skipped — not reviewed.

### Layer A Score

| Metric | Value |
|---|---|
| Base Score | 100 |
| Section 3 deduction | -5 (missing decorative element) |
| Section 4 deduction | -5 (carousel → static) |
| Section 7 deduction | -12 (missing filter tabs — childCount mismatch) |
| Section 9 deduction | -5 (missing decorative labels) |
| **Layer A Total** | **73 / 100** |

---

## Layer B: CSS Value Comparison (Weight: 35%)

### Typography Comparison

| Property | Token Value | Preview CSS Value | Match | Tolerance |
|---|---|---|---|---|
| body font-family | Raleway, sans-serif | `var(--font-body)` = Raleway | ✅ | exact |
| body font-size | 16px | 16px | ✅ | exact |
| body font-weight | 400 | 400 | ✅ | exact |
| body line-height | 30px | 30px | ✅ | exact |
| body color | rgb(85, 85, 85) | `var(--color-text-body)` = rgb(85,85,85) | ✅ | exact |
| h2 font-family | "Titillium Web" | `var(--font-heading)` = "Titillium Web" | ✅ | exact |
| h2 font-size | 24px | 24px | ✅ | exact |
| h2 font-weight | 400 | 400 | ✅ | exact |
| h2 line-height | 48px | 48px | ✅ | exact |
| h4 font-size | 30px | 30px | ✅ | exact |
| h4 font-weight | 400 | 400 | ✅ | exact |
| h4 line-height | 36px | 36px | ✅ | exact |
| h4 letter-spacing | 0.5px | 0.5px | ✅ | exact |
| h4 text-transform | uppercase | uppercase | ✅ | exact |
| h5 font-size | 24px | 24px | ✅ | exact |
| h5 font-weight | 400 | 400 | ✅ | exact |
| h5 line-height | 33.6px | 33.6px | ✅ | exact |
| h6 font-size | 18px | 18px | ✅ | exact |
| h6 font-weight | 600 | 600 | ✅ | exact |
| h6 line-height | 25.2px | 25.2px | ✅ | exact |
| h6 letter-spacing | 1px | 1px | ✅ | exact |
| h6 text-transform | uppercase | uppercase | ✅ | exact |

### Button Comparison

| Property | Token Value | Preview CSS Value | Match | Notes |
|---|---|---|---|---|
| font-family | "Titillium Web" | `var(--font-button)` = "Titillium Web" | ✅ | |
| font-size | 13px | 13px | ✅ | |
| font-weight | 600 | 600 | ✅ | |
| backgroundColor | rgb(26, 26, 26) | `var(--color-primary)` = #1a1a1a | ✅ | Same value |
| color | rgb(255, 255, 255) | `var(--color-text-white)` | ✅ | |
| borderRadius | 0px | 0px | ✅ | |
| textTransform | uppercase | uppercase | ✅ | |
| padding | 15px 39px | 18px 41px (.octf-btn) | ⚠️ | +3px top/bottom, +2px L/R. hero-btn uses correct 15px 39px |

### Color Palette Comparison

| Color Name | Token Value | Preview CSS Variable | Match |
|---|---|---|---|
| primary | #1a1a1a | `--color-primary: #1a1a1a` | ✅ |
| secondary | #555555 | `--color-secondary: #555555` | ✅ |
| accent | #b99272 | `--color-accent: #b99272` | ✅ |
| background-dark | rgb(42, 42, 42) | `--color-bg-dark: rgb(42, 42, 42)` | ✅ |
| background-light | #f4f4f4 | `--color-bg-light: #f4f4f4` | ✅ |
| background-white | #ffffff | `--color-bg-white: #ffffff` | ✅ |
| text-dark | rgb(35, 35, 35) | `--color-text-dark: rgb(35, 35, 35)` | ✅ |
| text-body | rgb(85, 85, 85) | `--color-text-body: rgb(85, 85, 85)` | ✅ |
| text-light | rgb(208, 207, 207) | `--color-text-light: rgb(208, 207, 207)` | ✅ |
| text-white | rgb(255, 255, 255) | `--color-text-white: rgb(255, 255, 255)` | ✅ |

### Section Spacing Comparison

| Section | Token Padding | Preview Padding | Token BG | Preview BG | Match |
|---|---|---|---|---|---|
| S2 About | 90px 0px | 90px 0 | transparent (+ bg-image) | dark + bg-image overlay | ✅ |
| S3 Sketch | 110px 0px | 110px 0 | transparent | transparent | ✅ |
| S4 Logos | 71px 0px | 71px 0 | rgb(244,244,244) | var(--color-bg-light) = #f4f4f4 | ✅ |
| S6 Services | 110px 0px | 110px 0 | transparent | transparent | ✅ |
| S7 Portfolio | 0px / 120px | 0 0 120px | transparent | transparent | ✅ |
| S8 CTA | 73px 0px | 73px 0 | transparent (+ bg-image) | dark + bg-image overlay | ✅ |
| S9 Values | 80px / 120px | 80px 0 120px | transparent | transparent | ✅ |
| S10 Team | 105px / 86px | 105px 0 86px | transparent (+ bg-image) | light + bg-image overlay | ✅ |
| S11 Blog | 110px / 120px | 110px 0 120px | transparent | transparent | ✅ |

### Component-Level Comparison

| Component | Property | Token/Expected | Preview | Match |
|---|---|---|---|---|
| .ot-heading span | font-size | 14px | 14px | ✅ |
| .ot-heading span | color | accent | var(--color-accent) | ✅ |
| .ot-heading span | text-transform | uppercase | uppercase | ✅ |
| .ot-heading span | letter-spacing | 3px | 3px | ✅ |
| .ot-heading .main-heading | font-size | 36px | 36px | ✅ |
| .is-dots::after | color | accent | var(--color-accent) | ✅ |
| counter num | font-size | 48px | 48px | ✅ |
| counter num | font-weight | 200 | 200 | ✅ |
| counter h6 | font-size/weight | 18px/600 | 18px/600 | ✅ |
| progress bar | height | 2px | 2px | ✅ |
| progress bar | bg | #e5e5e5 | #e5e5e5 | ✅ |
| service-box | border | 1px solid | 1px solid #eee | ✅ |
| blog card thumb | height | ~240px | 240px | ✅ |
| category-tag | font-size | 11px | 11px | ✅ |
| blog meta | font-size | 12px | 12px | ✅ |
| team card img | height | ~420px | 420px | ✅ |
| team overlay | bg | dark ~0.8 | rgba(26,26,26,0.8) | ✅ |
| hero title | font-size | 90px | 90px | ✅ |
| hero title | font-weight | 200 | 200 | ✅ |
| hero desc | font-size | 18px | 18px | ✅ |

### Layer B Score

| Metric | Value |
|---|---|
| Total properties checked | 51 |
| Properties passed | 50 |
| Properties failed (within tolerance) | 1 (button padding ±3px) |
| **Layer B Total** | **98 / 100** |

---

## Layer D: Visual Screenshot Comparison (Weight: 25%)

### Per-Section Visual Assessment

| # | Section | Visual Score | Strengths | Weaknesses |
|---|---|---|---|---|
| 1 | Hero | 70 | Layout structure matches (centered content, vertical social links, nav arrows). Background text "quality" stroke effect correct. Button styling matches. | Placeholder gray bg vs real interior photo. Different slide content ("High-end Interior Design" vs original's multiple slides). |
| 2 | About | 85 | Dark overlay bg matches. Quote italic styling correct. Person info layout (image + name + title) matches. 50/50 split preserved. | Placeholder circle vs real person photo. Missing signature-style "Oswald" decorative text. |
| 3 | Sketch | 65 | Text column matches well: subtitle, heading, dots, paragraph, button. Grid lines decoration present. Button pseudo-element styling (::before/::after) matches. | Rectangular placeholder vs original's complex circular image composition. Missing rotating text "theratio interior studio since 2012". |
| 4 | Logos | 75 | 6 logo items in row. Grayscale filter applied. Opacity 0.5 matching original's muted look. Light gray bg (#f4f4f4) correct. | Placeholder images vs actual brand logos. Gap spacing slightly wider than Swiper carousel. |
| 5 | Categories | 80 | 3-column grid matches. Gradient overlay on images. Text positioning (bottom-left) matches. Stroke numbers (01, 02, 03) positioned correctly. | Placeholder images. Image height (300px) approximation of original. |
| 6 | Services | 82 | Centered heading with subtitle and dots. 3 service boxes with border, icon, title, description, "READ MORE" link. 4 counters with bracket format [N+]. | Placeholder images for icons. Service box hover shadow matches. |
| 7 | Portfolio | 65 | 4-column metro grid with span-2 items. Hover overlay with title + category. Gap 0 matches. | **Missing filter tabs entirely** (ALL/ARCHITECTURE/DECOR/FURNITURE/INTERIOR). Placeholder images. |
| 8 | CTA | 90 | Dark overlay bg matches. Italic heading styling. Left text + right button layout (66/33). White button with pseudo-elements. | Minor: no actual background architectural blueprint visible. |
| 9 | Values | 68 | Progress bars excellent: 2px height, arrow indicators, percentage labels, all 3 values correct (65%/85%/55%). Heading + dots match. | Rectangular placeholder vs circular image with decorative labels. Missing "QUALITY/EXPERIENCE/HARD SKILLS" keyword labels. |
| 10 | Team | 78 | 5-column grid matches visible carousel count. Overlay hover effect with dark bg. Name in h4 uppercase. Pagination dots with active state. Light bg with overlay. | Placeholder images. 5 static cards vs 8-member carousel. |
| 11 | Blog | 85 | Header row (heading left + VIEW ALL button right). 3-column card grid. Category tag positioning. Meta styling (date + author with dot separator). Card structure matches. | Placeholder images. Grid lines decoration present. |

### Responsive Assessment

| Viewport | Status | Notes |
|---|---|---|
| Desktop (1660×1080) | ✅ Good | All sections render at correct widths. 1200px container constraint works. Grid columns correct. |
| Tablet (1024×768) | ✅ Good | Breakpoint at 1024px applies: flex → column for About/Sketch/CTA/Values. Services grid → 2-col. Team → 3-col. |
| Mobile (767px) | ✅ Good | Breakpoint at 767px: Hero title shrinks. All multi-col → single/2-col. Blog → 1-col. Categories → 1-col. |

### Layer D Score

| Metric | Value |
|---|---|
| Per-section average | (70+85+65+75+80+82+65+90+68+78+85) / 11 = **76.6** |
| Responsive quality bonus | +0 (already factored) |
| **Layer D Total** | **77 / 100** |

---

## Final Score Calculation

| Layer | Raw Score | Weight | Weighted |
|---|---|---|---|
| A — DOM Structure | 73 | × 0.40 | 29.2 |
| B — CSS Values | 98 | × 0.35 | 34.3 |
| D — Visual | 77 | × 0.25 | 19.3 |
| **FINAL SCORE** | | | **82.8** |

---

## Issues List (Prioritized by Severity)

### 🔴 Critical (blocks fidelity)

| ID | Section | Issue | Impact | Fix Effort |
|---|---|---|---|---|
| C1 | S7 Portfolio | **Missing portfolio filter tabs** — Original has filterable categories (ALL / ARCHITECTURE / DECOR / FURNITURE / INTERIOR) as a horizontal tab row above the grid. Clone has no filter UI. | -12 structure, -15 visual | Medium (add static tab row HTML + CSS) |

### 🟠 Major (significant visual gap)

| ID | Section | Issue | Impact | Fix Effort |
|---|---|---|---|---|
| M1 | S3 Sketch | **Missing circular text decoration** — Original has rotating text "theratio interior studio since 2012" as a circular badge on the right side near the heading. Clone omits this element. | -5 structure, -10 visual | Low (add SVG/CSS circular text) |
| M2 | S9 Values | **Missing decorative keyword labels** — Original has "QUALITY", "EXPERIENCE", "HARD SKILLS" labels positioned around the circular image with connecting dots. Clone has plain rectangular image. | -5 structure, -10 visual | Medium (add positioned text elements) |
| M3 | S2 About | **Missing signature decoration** — Original has a cursive "Oswald" signature-style text behind the person info area. Clone omits it. | -0 structure, -5 visual | Low (add italic/script font text) |

### 🟡 Minor (polish)

| ID | Section | Issue | Impact | Fix Effort |
|---|---|---|---|---|
| m1 | S1 Hero | **Different slide content** — Clone shows "High-end Interior Design" (Slide 2); original screenshot captured "Best Furniture and Decor". | -0 (acceptable) | N/A — design choice |
| m2 | Global | **Button padding deviation** — `.octf-btn` uses 18px 41px vs token 15px 39px. The `.hero-btn` correctly uses 15px 39px. | -2 CSS | Low (adjust padding) |
| m3 | S4 Logos | **Carousel → static grid** — Original uses Swiper horizontal carousel; clone uses static flex wrap. | -5 structure | N/A — expected for static preview |
| m4 | S10 Team | **5 static cards vs 8-member carousel** — Only showing first 5 of 8 team members. | -0 (matches visible count) | Low (add remaining 3 as hidden) |

---

## Decorative Elements Audit

| Element | Original | Clone | Status |
|---|---|---|---|
| Grid vertical lines | 3 vertical lines (left/center/right) at 1200px container width | ✅ Present in S3, S6, S9, S11 via `.has-grid-lines` | ✅ |
| Dot decoration (.is-dots) | "..............." in accent color below headings | ✅ Present via `.ot-heading.is-dots::after` | ✅ |
| Button pseudo-elements | Bottom line + right line with hover animation | ✅ Present via `.octf-btn::before/::after` | ✅ |
| Hero bg stroke text | Large transparent text with white stroke | ✅ "quality" via `.hero-bg-text` | ✅ |
| Category stroke numbers | 80px transparent numbers with white stroke | ✅ via `.number-stroke` | ✅ |
| Progress bar arrows | Arrow indicator at progress bar end | ✅ via `.progress-bar::after` border-triangle | ✅ |
| Pagination dots | Circle dots with active state | ✅ via `.team-pagination .dot` | ✅ |
| Counter brackets | [N+] format with brackets | ✅ via `.num-wrap span` | ✅ |
| Circular text badge (S3) | Rotating "theratio interior studio since 2012" | ❌ Missing | ❌ |
| Signature text (S2) | Cursive "Oswald" decorative text | ❌ Missing | ❌ |
| Keyword labels (S9) | "QUALITY/EXPERIENCE/HARD SKILLS" positioned labels | ❌ Missing | ❌ |
| Portfolio filter tabs (S7) | ALL / ARCHITECTURE / DECOR / FURNITURE / INTERIOR | ❌ Missing | ❌ |

---

## QA Verdict

```json
{
  "fidelity_score": 82.8,
  "status": "NEEDS_WORK",
  "layer_scores": {
    "A_dom_structure": 73,
    "B_css_values": 98,
    "D_visual": 77
  },
  "failing_sections": [3, 7, 9],
  "critical_count": 1,
  "major_count": 3,
  "minor_count": 4,
  "sections_total": 11,
  "sections_passing": 8,
  "next_action": "fix_and_rescan",
  "top_3_fixes": [
    {
      "priority": 1,
      "section": 7,
      "issue": "Add portfolio filter tabs row (ALL / ARCHITECTURE / DECOR / FURNITURE / INTERIOR) above the metro grid. Use horizontal flex with h6-style typography (13px, 600, uppercase, letter-spacing 1px). Active tab should have bottom border accent.",
      "estimated_score_gain": "+8 points"
    },
    {
      "priority": 2,
      "section": 3,
      "issue": "Add circular text decoration 'theratio interior studio since 2012' as a rotating badge near the heading area. Use CSS animation with border-radius 50% text path or SVG.",
      "estimated_score_gain": "+4 points"
    },
    {
      "priority": 3,
      "section": 9,
      "issue": "Add decorative keyword labels ('QUALITY', 'EXPERIENCE', 'HARD SKILLS') positioned around the values image area with small circle icons and connecting elements.",
      "estimated_score_gain": "+4 points"
    }
  ]
}
```

---

## Summary

The clone preview achieves **strong CSS fidelity (98/100)** with nearly all typography, color, and spacing values matching the original style tokens precisely. The DOM structure is generally sound with correct flex/grid layouts across most sections.

**Primary gap**: The preview is missing 4 decorative/functional elements that are visually prominent in the original:
1. Portfolio filter tabs (critical — functional UI missing)
2. Circular text decoration in Section 3
3. Decorative keyword labels in Section 9
4. Signature text in Section 2

Applying the top 3 fixes would bring the estimated score from **82.8 → ~99** (assuming CSS/typography remain stable).
