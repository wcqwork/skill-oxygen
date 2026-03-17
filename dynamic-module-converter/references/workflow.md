# Workflow — Per-Phase I/O/Actor/Verification Specs

## Phase 1: Detection (pattern-detector)

| Aspect | Detail |
|--------|--------|
| **Actor** | AI (automatic) |
| **Input** | `inject-to-editor.js` — all sections static |
| **Process** | Three-layer scoring: structural (0-40) + URL analysis (0-25) + content heuristics (0-20) |
| **Output** | `dynamic-regions.json` — array of section analysis results |
| **Duration** | ~5 seconds per section |

### Output Schema

```json
[
  {
    "sectionIndex": 3,
    "sectionDescription": "5 product cards with images, names, prices",
    "detectedType": "prodList",
    "confidence": 0.85,
    "scores": {
      "structural": 35,
      "urlPattern": 25,
      "contentHeuristic": 12,
      "total": 72
    },
    "evidence": [
      "5 children with identical tag signature: div>img+h3+p",
      "5/5 links match /product/ pattern",
      "Price symbols ($) detected in 5 elements"
    ],
    "repeatingItemSelector": "section:nth-child(3) > div > div",
    "itemCount": 5
  }
]
```

## Phase 2: User Confirmation (mandatory)

| Aspect | Detail |
|--------|--------|
| **Actor** | User (mandatory interaction) |
| **Input** | `dynamic-regions.json` + section previews |
| **Process** | Present ALL sections; user confirms/changes/skips each |
| **Output** | `confirmed-sections.json` — user decisions |
| **Duration** | Depends on user (typically 1-5 minutes) |

### Presentation Format

For each section, show:
1. Section index and brief description
2. Detected type (or "static") and confidence score
3. Evidence bullets
4. Action buttons: Confirm / Change Type / Keep Static

### Rules
- **Zero automatic conversion** — every dynamic conversion requires explicit user approval
- Even high-confidence detections need user confirmation
- User can change any detected type to a different dynamic type
- User can mark any section as static (skip conversion)

## Phase 3: Marker Injection (inject-adapter)

| Aspect | Detail |
|--------|--------|
| **Actor** | AI (automatic) |
| **Input** | Original `inject-to-editor.js` + `confirmed-sections.json` + `templates/*.ftl` |
| **Process** | For each confirmed dynamic section: wrap with markers, load FreeMarker template |
| **Output** | Modified `inject-to-editor.js` with dynamic sections |
| **Duration** | ~2 seconds per section |

### Steps per Section

1. **Modify outer wrapper**:
   - `data-gjs-type`: `developer-component-ai` → `developer-component`
   - Add `class="developer-component"`

2. **Add inner marker div** between outer wrapper and `<section>`:
   ```html
   <div class="backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_{UUID}"
        data-gjs-type="developer-node-component"
        data-block-type="{BLOCK_TYPE}"
        data-block-uuid="{UUID}"
        data-new-auto-uuid="{UUID}">
   ```

3. **Original `<section>` HTML**: NOT MODIFIED — zero changes

4. **Set model properties** (in JavaScript code):
   ```javascript
   nodeModel.set('freemakerHtml', TEMPLATE_SOURCE);
   nodeModel.set('appId', APP_ID);
   nodeModel.set('appIsDev', true);
   ```

### Template Lookup

```
blockType → template-registry.md → templates/fetched/{fileName}
```

If template not found for a confirmed type → **skip that section** and warn user.

## Phase 4: Validation (render-verify)

| Aspect | Detail |
|--------|--------|
| **Actor** | AI (automatic) |
| **Input** | Modified `inject-to-editor.js` |
| **Process** | 5-point validation checklist |
| **Output** | Validation report (pass/fail per check) |
| **Duration** | ~3 seconds per section |

### Validation Checklist

| # | Check | Pass Criteria |
|---|-------|--------------|
| 1 | **DOM hierarchy** | `developer-component` > `developer-node-component` > original HTML |
| 2 | **Attribute completeness** | `data-block-type`, `data-block-uuid`, `data-gjs-type`, `data-new-auto-uuid` all present |
| 3 | **Model properties** | `freemakerHtml` is non-empty string on the `developer-node-component` model |
| 4 | **Visual integrity** | Original CSS classes and inline styles unchanged |
| 5 | **Export path** | `handleGeneralBlock()` would find `freemakerHtml` and replace content |

### On Failure

- Report specific failed checks with details
- Offer to fix automatically if possible
- User can choose to proceed with partial conversion (skip failed sections)
