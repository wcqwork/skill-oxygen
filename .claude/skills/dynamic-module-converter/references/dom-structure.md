# DOM Structure — Marker Injection Mechanism

## Editor-Compatible DOM Hierarchy

Dynamic sections must follow this exact hierarchy for the editor to recognize them:

```html
<!-- Level 1: Outer wrapper (developer-component) -->
<div class="developer-component"
     data-gjs-type="developer-component">

  <!-- Level 2: Inner node (developer-node-component) -->
  <div class="backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_{UUID}"
       data-gjs-type="developer-node-component"
       data-block-type="{BLOCK_TYPE}"
       data-block-uuid="{UUID}">

    <!-- Level 3: Original static HTML (UNCHANGED) -->
    <section class="...">
      <!-- All original HTML exactly as cloned -->
    </section>

  </div>
</div>
```

## Required Attributes

### Outer Wrapper (`developer-component`)

| Attribute | Value | Source |
|-----------|-------|--------|
| `data-gjs-type` | `developer-component` | Changed from `developer-component-ai` |
| `class` | `developer-component` | Added |

### Inner Node (`developer-node-component`)

| Attribute | Value | Source |
|-----------|-------|--------|
| `data-gjs-type` | `developer-node-component` | New |
| `data-block-type` | e.g. `phoenix_blocks_prodlist` | From template registry |
| `data-block-uuid` | Unique UUID | Generated |
| `data-new-auto-uuid` | Same UUID | Required by `initComponentDataView()` |
| `class` | `backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_{UUID}` | New |

## GrapesJS Model Properties

After `editor.addComponents()`, set on the `developer-node-component` model:

| Property | Type | Description |
|----------|------|-------------|
| `freemakerHtml` | `string` | Complete FreeMarker template source code |
| `appId` | `string` | Application ID from the platform |
| `appIsDev` | `boolean` | Whether this is a dev environment app |
| `appVersion` | `string` | App version string |

## Marker Injection Code Pattern

```javascript
// In inject-to-editor.js, replace addSection with addDynamicSection:
function addDynamicSection(html, css, freemakerHtml, blockType, blockUuid, appId, index, globalCSS) {
  const uuid = blockUuid || generateUUID();

  const markedHtml = `
    <div class="developer-component" data-gjs-type="developer-component">
      <div class="backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_${uuid}"
           data-gjs-type="developer-node-component"
           data-block-type="${blockType}"
           data-block-uuid="${uuid}"
           data-new-auto-uuid="${uuid}">
        ${html}
      </div>
    </div>`;

  var components = editor.addComponents(markedHtml);
  var outerModel = components[0];
  var nodeModel = outerModel.findType('developer-node-component')[0];

  nodeModel.set('freemakerHtml', freemakerHtml);
  nodeModel.set('appId', appId);
  nodeModel.set('appIsDev', true);

  // Add scoped CSS
  if (css) {
    editor.Css.addRules(css);
  }
}
```

## Export Replacement Flow

1. User clicks Export/Save
2. `replaceFreemakerCode()` finds all `DEV_ELEMENT_TYPE` models
3. `handleGeneralBlock()` reads `model.get('freemakerHtml')`
4. If `freemakerHtml` exists → Replace DOM content with FreeMarker source
5. If no `freemakerHtml` but has `appId` → Fetch via `getFreemakerCodeByAppId` API
6. If neither → `isBadHtml = true` (error logged)
7. Final HTML output contains FreeMarker template code

## Key Codebase References

- `packages/blockeditor/src/dynamicComponents/developerComponent/index.ts` — `isComponent`, `init()`, `handlerSetting`
- `packages/blockeditor/src/plugins/pageExportStatic/Model/PageExportStaticHTML.ts` — `handleGeneralBlock`, `replaceFreemakerCode`
- `packages/blockeditor/src/dynamicComponents/utils/index.ts` — `initComponentDataView()`
- `packages/blockeditor/src/components/modulesSetting/components/dynamicSourceData/hooks/index.ts` — Block type definitions
