# Pattern Rules — Three-Layer Detection Algorithm

## Overview

Dynamic module detection uses a three-layer scoring system to identify which static HTML sections should be converted to dynamic modules. Total score: 0-85 (40+25+20), threshold: 50 for auto-suggestion.

## Layer 1: Structural Analysis (Score: 0-40)

Tag-based, class-agnostic analysis. Reuses approach from `transformAi.ts`.

### Rules

1. Find sections with **3+ children** sharing identical **tag signatures**:
   - Tag name
   - Nesting depth
   - Presence of `img`/`a`/heading elements

2. Class names are **ignored** (often minified/hashed in cloned sites)

3. Score calculation:
   - 3-4 identical children: 25 points
   - 5-8 identical children: 35 points
   - 9+ identical children: 40 points

### Example

```html
<!-- Score: 35 (5 identical children with img+h3+p structure) -->
<section>
  <div class="xk3f"><img src="..."><h3>Product A</h3><p>$29.99</p></div>
  <div class="xk3f"><img src="..."><h3>Product B</h3><p>$39.99</p></div>
  <div class="xk3f"><img src="..."><h3>Product C</h3><p>$19.99</p></div>
  <div class="xk3f"><img src="..."><h3>Product D</h3><p>$49.99</p></div>
  <div class="xk3f"><img src="..."><h3>Product E</h3><p>$24.99</p></div>
</section>
```

## Layer 2: URL Pattern Analysis (Score: 0-25)

Extract `<a href>` links from each section and match against known URL patterns.

### Pattern → Type Mapping

| URL Pattern | Detected Type | Score |
|---|---|---|
| `/product/`, `/p/`, `/item/`, `/shop/` | `prodList` | 25 |
| `/blog/`, `/news/`, `/article/`, `/post/` | `articleList` | 25 |
| `/gallery/`, `/photo/`, `/album/` | `galleryList` | 25 |
| `/faq/`, `/help/`, `/support/` | `FAQList` | 20 |
| YouTube/Vimeo domains, `/video/` | `videoList` | 25 |
| `/download/`, `/resource/` | `downloadList` | 20 |

### Scoring Rules

- All links in section match same pattern: full score
- 80%+ links match: score × 0.8
- 50-80% links match: score × 0.5
- <50% links match: 0 points

## Layer 3: Content Heuristics (Score: 0-20)

Analyze text content, tag types, and semantic patterns within the section.

### Heuristic Rules

| Heuristic | Detected Type | Score |
|---|---|---|
| Price regex (`$`, `€`, `¥`, `USD`, currency symbols) | `prodList` | 15 |
| "Add to Cart", "Buy Now" text | `prodList` | 20 |
| Date patterns (`<time>`, ISO dates, "Jan 2024" etc.) | `articleList` | 15 |
| "Read More", "Continue Reading" text | `articleList` | 10 |
| `<iframe>` or `<video>` tags | `videoList` | 20 |
| Accordion pattern (question + collapsible answer) | `FAQList` | 20 |
| File size/type indicators (.pdf, .zip, MB, KB) | `downloadList` | 15 |

## Combined Scoring

```
Total Score = Layer1 + Layer2 + Layer3
Maximum possible: 85 (40 + 25 + 20)

≥ 50: Auto-suggest as dynamic (presented in Phase 2 for confirmation)
< 50: Suggest as static (user can override in Phase 2)
```

## Phase 2 Presentation Format

ALL sections are presented regardless of score:

```
Section 3: "Hot Products" (Score: 72/85)
  ├── Structure: 5 repeating cards with img+h3+p (35/40)
  ├── URL: 5/5 links match /product/ pattern (25/25)
  ├── Content: Price symbols detected (12/20)
  └── Suggested type: prodList [Confirm] [Change ▼] [Keep static]

Section 7: "Company Info" (Score: 12/85)
  ├── Structure: No repeating pattern (0/40)
  ├── URL: Mixed links (0/25)
  ├── Content: General text (12/20)
  └── Suggested type: static [Confirm] [Change ▼] [Mark dynamic]
```
