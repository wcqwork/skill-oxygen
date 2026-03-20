(function() {
'use strict';
var editor = window.grapesEditor;
if (!editor) { console.error('[Clone-Inject] window.grapesEditor not found.'); return; }

var _img = 'https://g3.leadongcdn.cn/cloud/jiBpjKiilpSRikimnnjrjo/default_img.png';
function lt(t) { return '<div class="lead-text lead-ai-text"><div>' + t + '</div></div>'; }

/* ============================= GLOBAL CSS ============================= */
var GLOBAL_CSS =
  ':root{' +
    '--color-primary:#1a1a1a;--color-secondary:#555555;--color-accent:#b99272;' +
    '--color-bg-dark:rgb(42,42,42);--color-bg-light:#f4f4f4;--color-bg-white:#fff;' +
    '--color-text-dark:rgb(35,35,35);--color-text-body:rgb(85,85,85);' +
    '--color-text-light:rgb(208,207,207);--color-text-white:rgb(255,255,255);' +
    '--font-heading:"Titillium Web",-apple-system,"Segoe UI",sans-serif;' +
    '--font-body:Raleway,-apple-system,"Segoe UI",sans-serif;' +
    '--font-button:"Titillium Web",-apple-system,"Segoe UI",sans-serif}' +
  '*,*::before,*::after{margin:0;padding:0;box-sizing:border-box}' +
  'body{font-family:var(--font-body);font-size:16px;font-weight:400;line-height:30px;color:var(--color-text-body);-webkit-font-smoothing:antialiased;overflow-x:hidden}' +
  'img{max-width:100%;height:auto;display:block}' +
  'a{text-decoration:none;color:inherit}' +
  'h1,h2,h3,h4,h5,h6{font-family:var(--font-heading);font-weight:400;line-height:1.4;margin:0 0 20px;color:var(--color-primary)}' +
  'h2{font-size:24px;font-weight:400;line-height:48px}' +
  'h4{font-size:30px;font-weight:400;line-height:36px;letter-spacing:0.5px;text-transform:uppercase}' +
  'h5{font-size:24px;font-weight:400;line-height:33.6px}' +
  'h6{font-size:18px;font-weight:600;line-height:25.2px;letter-spacing:1px;text-transform:uppercase}' +
  'p{font-family:var(--font-body);font-size:14px;font-weight:400;line-height:26.25px;margin:0 0 15px}' +
  '.container{max-width:1200px;margin:0 auto;padding:0 15px}' +
  '.octf-btn{display:inline-block;font-family:var(--font-button);font-size:13px;font-weight:600;line-height:1.42857;letter-spacing:0.5px;text-transform:uppercase;text-align:center;white-space:nowrap;padding:18px 41px;background:var(--color-primary);color:var(--color-text-white);border:1px solid transparent;border-radius:0;cursor:pointer;position:relative;transition:0.3s linear}' +
  '.octf-btn::before,.octf-btn::after{content:"";position:absolute;background:var(--color-primary);transition:0.3s linear}' +
  '.octf-btn::before{width:calc(100% + 2px);height:1px;bottom:-6px;left:10px}' +
  '.octf-btn::after{width:1px;height:calc(100% + 2px);top:10px;right:-6px}' +
  '.octf-btn:hover{background:transparent;color:var(--color-primary);border-color:var(--color-primary)}' +
  '.octf-btn:hover::before{width:0}' +
  '.octf-btn:hover::after{height:0}' +
  '.octf-btn-light{background:var(--color-text-white);color:var(--color-primary)}' +
  '.octf-btn-light::before,.octf-btn-light::after{background:var(--color-text-white)}' +
  '.octf-btn-light:hover{background:var(--color-primary);color:var(--color-text-white);border-color:var(--color-primary)}' +
  '.octf-btn-dark{background:var(--color-primary);color:var(--color-text-white)}' +
  '.octf-btn-dark::before,.octf-btn-dark::after{background:var(--color-primary)}' +
  '.octf-btn-dark:hover{background:var(--color-text-white);color:var(--color-primary);border-color:var(--color-text-white)}' +
  '.ot-heading span{display:block;font-family:var(--font-body);font-size:14px;font-weight:400;color:var(--color-accent);text-transform:uppercase;letter-spacing:3px;margin-bottom:5px}' +
  '.ot-heading .main-heading{font-family:var(--font-heading);font-size:36px;font-weight:400;line-height:48px;color:var(--color-primary);margin-bottom:10px}' +
  '.ot-heading.is-dots::after{content:"...............";display:block;font-size:24px;letter-spacing:5px;color:var(--color-accent);margin-top:5px;line-height:1}' +
  '.ot-heading.center{text-align:center}' +
  '.has-grid-lines{position:relative}' +
  '.grid-lines-vertical{position:absolute;top:0;left:50%;transform:translateX(-50%);width:1200px;max-width:100%;height:100%;pointer-events:none;z-index:0}' +
  '.grid-lines-vertical .g-line{position:absolute;top:0;width:1px;height:100%;background:rgba(0,0,0,0.07)}' +
  '.grid-lines-vertical .line-left{left:0}' +
  '.grid-lines-vertical .line-center{left:50%}' +
  '.grid-lines-vertical .line-right{right:0}' +
  '@keyframes rotateBadge{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}' +
  '@media(max-width:767px){.octf-btn{padding:12px 20px}}';

/* ============================= SCOPE CSS ============================= */
function scopeCSS(css, scope) {
  if (!css) return '';
  var result = '';
  var i = 0;
  while (i < css.length) {
    while (i < css.length && ' \t\n\r'.indexOf(css[i]) >= 0) { result += css[i]; i++; }
    if (i >= css.length) break;
    var selStart = i;
    while (i < css.length && css[i] !== '{') i++;
    if (i >= css.length) break;
    var selector = css.substring(selStart, i).trim();
    i++;
    var depth = 1;
    var blockStart = i;
    while (i < css.length && depth > 0) {
      if (css[i] === '{') depth++;
      else if (css[i] === '}') depth--;
      if (depth > 0) i++;
    }
    var blockContent = css.substring(blockStart, i);
    i++;
    if (!selector) continue;
    if (selector.indexOf('@keyframes') === 0 || selector.indexOf('@font-face') === 0) {
      result += selector + '{' + blockContent + '}';
    } else if (selector.indexOf('@media') === 0) {
      result += selector + '{' + scopeCSS(blockContent, scope) + '}';
    } else if (selector === ':root' || selector === 'html' || selector === 'body') {
      result += selector + '{' + blockContent + '}';
    } else {
      var parts = selector.split(',');
      var scoped = [];
      for (var j = 0; j < parts.length; j++) {
        var s = parts[j].trim();
        if (s) scoped.push(scope + ' ' + s);
      }
      result += scoped.join(',') + '{' + blockContent + '}';
    }
  }
  return result;
}

/* ============================= ID GENERATORS ============================= */
var _cloneId = Date.now().toString(36);
function uid(i) { return 'cs-' + _cloneId + '-' + i; }
var _gid = function(n) { return 'gal-' + _cloneId + '-' + n; };

/* ============================= ADD SECTION ============================= */
function addSection(html, moduleCss, customJs, index, extraCss) {
  try {
    var sid = uid(index);
    var scopeAttr = '[data-clone-section="' + sid + '"]';
    var scopedHtml = html.replace(
      'data-gjs-type="developer-component-ai"',
      'data-gjs-type="developer-component-ai" data-clone-section="' + sid + '"'
    );
    var scopedCss = scopeCSS(moduleCss, scopeAttr);
    if (extraCss) scopedCss = extraCss + scopedCss;
    var components = editor.addComponents(scopedHtml);
    var model = Array.isArray(components) ? components[0] : components;
    if (model && scopedCss) model.set('customCss', scopedCss);
    if (model && customJs) model.set('customJs', customJs);
    console.log('[Clone-Inject] S' + index + ' injected (sid=' + sid + ')');
    return model;
  } catch(err) {
    console.error('[Clone-Inject] S' + index + ' failed:', err);
    return null;
  }
}

/* ============================= ADD DYNAMIC SECTION ============================= */
function addDynamicSection(html, moduleCss, customJs, freemakerHtml, blockType, blockUuid, appId, index, extraCss) {
  try {
    var sid = uid(index);
    var scopeAttr = '[data-clone-section="' + sid + '"]';
    var scopedHtml = html.replace(
      'data-clone-section="' + sid + '"',
      'data-clone-section="' + sid + '"'
    );
    if (scopedHtml.indexOf('data-clone-section') < 0) {
      scopedHtml = html.replace(
        'data-gjs-type="developer-component"',
        'data-gjs-type="developer-component" data-clone-section="' + sid + '"'
      );
    }
    var scopedCss = scopeCSS(moduleCss, scopeAttr);
    if (extraCss) scopedCss = extraCss + scopedCss;
    var components = editor.addComponents(scopedHtml);
    var outerModel = Array.isArray(components) ? components[0] : components;
    if (outerModel && scopedCss) outerModel.set('customCss', scopedCss);
    if (outerModel && customJs) outerModel.set('customJs', customJs);
    var nodeModel = outerModel.findType('developer-node-component')[0];
    if (nodeModel) {
      nodeModel.set('freemakerHtml', freemakerHtml);
      if (appId) nodeModel.set('appId', appId);
      nodeModel.set('appIsDev', true);
    }
    console.log('[Clone-Inject] S' + index + ' injected as DYNAMIC (sid=' + sid + ', type=' + blockType + ')');
    return outerModel;
  } catch(err) {
    console.error('[Clone-Inject] S' + index + ' dynamic inject failed:', err);
    return null;
  }
}

/* ============================= GALLERY IDS ============================= */
var galId5 = _gid('categories');
var galId6 = _gid('services');
var galId7 = _gid('portfolio');
var galId10 = _gid('team');
var galId11 = _gid('blog');

/* =====================================================================
   SECTION 1 — HERO SLIDER (Slick 3-slide, fade, autoplay, arrows+dots)
   ===================================================================== */
var html1 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-hero">' +
  '<div class="hero-swiper-track">' +
  '<div class="hero-slide">' +
    '<img src="' + _img + '" alt="Hero Background" class="hero-bg block-ai-img">' +
    '<div class="hero-overlay"></div>' +
    '<div class="hero-bg-text">' + lt('quality') + '</div>' +
    '<div class="hero-content">' +
      '<h1 class="hero-title">' + lt('High-end Interior Design') + '</h1>' +
      '<div class="hero-desc">' + lt('We pride ourselves on being builders &mdash; creating architectural and creative solutions to help people realize their vision and make them a reality.') + '</div>' +
      '<a href="#" class="hero-btn block-ai-link">' + lt('VIEW PROJECTS') + '</a>' +
    '</div>' +
  '</div>' +
  '<div class="hero-slide">' +
    '<img src="' + _img + '" alt="Hero Background" class="hero-bg block-ai-img">' +
    '<div class="hero-overlay"></div>' +
    '<div class="hero-bg-text">' + lt('design') + '</div>' +
    '<div class="hero-content">' +
      '<h1 class="hero-title">' + lt('Modern Architecture') + '</h1>' +
      '<div class="hero-desc">' + lt('Creating architectural and creative solutions to help people realize their vision and make them a reality. Wanna work with us?') + '</div>' +
      '<a href="#" class="hero-btn block-ai-link">' + lt('OUR SERVICES') + '</a>' +
    '</div>' +
  '</div>' +
  '<div class="hero-slide">' +
    '<img src="' + _img + '" alt="Hero Background" class="hero-bg block-ai-img">' +
    '<div class="hero-overlay"></div>' +
    '<div class="hero-bg-text">' + lt('studio') + '</div>' +
    '<div class="hero-content">' +
      '<h1 class="hero-title">' + lt('Creative Solutions') + '</h1>' +
      '<div class="hero-desc">' + lt('Individual, aesthetically stunning solutions for our customers by lightning-fast development of projects employing unique styles.') + '</div>' +
      '<a href="#" class="hero-btn block-ai-link">' + lt('CONTACT US') + '</a>' +
    '</div>' +
  '</div>' +
  '</div>' +
  '<div class="hero-dots-container"></div>' +
  '<div class="hero-social">' +
    '<a href="#" class="block-ai-link">' + lt('pinterest') + '</a>' +
    '<a href="#" class="block-ai-link">' + lt('twitter') + '</a>' +
    '<a href="#" class="block-ai-link">' + lt('facebook') + '</a>' +
    '<a href="#" class="block-ai-link">' + lt('instagram') + '</a>' +
  '</div>' +
  '<div class="hero-arrows">' +
    '<span class="hero-prev">&larr;</span>' +
    '<span class="hero-next">&rarr;</span>' +
  '</div>' +
  '</div></div></div>';

var css1 =
  '.section-hero{position:relative;width:100%;overflow:hidden;background:#111}' +
  '.hero-slide{position:relative;width:100%;height:100vh;min-height:600px;max-height:1080px;overflow:hidden}' +
  '.section-hero .hero-bg{position:absolute;top:0;left:0;width:100%;height:100%;object-fit:cover;opacity:0.7}' +
  '.section-hero .hero-overlay{position:absolute;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.3)}' +
  '.section-hero .hero-content{position:relative;z-index:2;display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;text-align:center;padding:0 20px}' +
  '.hero-bg-text{font-family:var(--font-heading);font-size:200px;font-weight:900;text-transform:uppercase;color:transparent;-webkit-text-stroke:1px rgba(255,255,255,0.3);letter-spacing:100px;line-height:200px;position:absolute;white-space:nowrap;z-index:1;top:50%;left:50%;transform:translate(-50%,-55%);pointer-events:none}' +
  '.hero-title{font-family:var(--font-heading);font-size:90px;font-weight:200;line-height:80px;color:var(--color-text-white);margin-bottom:30px;white-space:nowrap}' +
  '.hero-desc{font-family:var(--font-body);font-size:18px;font-weight:400;line-height:32px;color:var(--color-text-white);max-width:818px;margin-bottom:40px}' +
  '.hero-btn{display:inline-block;font-family:var(--font-button);font-size:13px;font-weight:600;line-height:25px;text-transform:uppercase;padding:15px 39px;background:var(--color-primary);color:var(--color-text-white);border:1px solid transparent;border-radius:0;cursor:pointer;transition:0.3s linear}' +
  '.hero-btn:hover{background:#fff;color:var(--color-primary)}' +
  '.hero-social{position:absolute;left:30px;top:50%;transform:translateY(-50%);z-index:3;display:flex;flex-direction:column;gap:25px}' +
  '.hero-social a{font-family:var(--font-heading);font-size:11px;font-weight:400;color:var(--color-text-white);text-transform:uppercase;letter-spacing:2px;writing-mode:vertical-rl;transform:rotate(180deg);transition:0.3s}' +
  '.hero-social a:hover{color:var(--color-accent)}' +
  '.hero-arrows{position:absolute;bottom:40px;right:40px;z-index:3;display:flex;gap:0}' +
  '.hero-arrows span{display:flex;align-items:center;justify-content:center;width:60px;height:60px;border:1px solid rgba(255,255,255,0.3);color:var(--color-text-white);font-size:18px;cursor:pointer;transition:0.3s}' +
  '.hero-arrows span:hover{background:rgba(255,255,255,0.1)}' +
  '.hero-swiper-track .slick-list,.hero-swiper-track .slick-track{height:100%}' +
  '.hero-dots-container{position:absolute;bottom:30px;left:50%;transform:translateX(-50%);z-index:5}' +
  '.hero-dots-container .slick-dots{display:flex !important;gap:8px;list-style:none;padding:0;margin:0}' +
  '.hero-dots-container .slick-dots li{line-height:0;margin:0}' +
  '.hero-dots-container .slick-dots li button{width:12px;height:12px;border-radius:50%;border:1px solid rgba(255,255,255,0.5);background:transparent;cursor:pointer;font-size:0;padding:0}' +
  '.hero-dots-container .slick-dots li.slick-active button{background:#fff;border-color:#fff}' +
  '@media(max-width:1024px){.hero-title{font-size:55px;line-height:60px}.hero-bg-text{font-size:120px;letter-spacing:60px;line-height:120px}.hero-desc{font-size:17px;max-width:600px}.hero-social{display:none}}' +
  '@media(max-width:767px){.hero-title{font-size:36px;line-height:44px;white-space:normal}.hero-bg-text{font-size:80px;letter-spacing:30px;line-height:80px}.hero-desc{font-size:16px;line-height:28px;max-width:100%}.hero-btn{padding:12px 25px}.hero-arrows{bottom:20px;right:20px}.hero-arrows span{width:45px;height:45px}}' +
  '@media(max-width:480px){.hero-title{font-size:28px;line-height:36px}.hero-bg-text{display:none}}';

var js1 =
  '(async function(){' +
  'var $=window.jQuery;' +
  'var root=window.__PHOENIX_AI_SECTION_ROOT__||document;' +
  'var lcs=window.leadComponentSite;' +
  'if(lcs&&lcs.slickSourceImport)await lcs.slickSourceImport.init({});' +
  'var $s=$(root).find(".hero-swiper-track");' +
  'if(!$s.length)return;' +
  'if($s.hasClass("slick-initialized"))$s.slick("unslick");' +
  '$s.slick({' +
    'slidesToShow:1,slidesToScroll:1,dots:true,autoplay:true,' +
    'autoplaySpeed:5000,speed:800,infinite:true,fade:true,' +
    'cssEase:"ease-in-out",arrows:true,' +
    'prevArrow:$(root).find(".hero-prev"),' +
    'nextArrow:$(root).find(".hero-next"),' +
    'appendDots:$(root).find(".hero-dots-container")' +
  '});' +
  '})();';

/* =====================================================================
   SECTION 2 — ABOUT / WELCOME (Static)
   ===================================================================== */
var html2 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-about">' +
  '<div class="container">' +
    '<div class="about-quote">' + lt('&ldquo;Even if you don&rsquo;t have a ready sketch of what you want &ndash; we will help you to get the result you dreamed of.&rdquo;') + '</div>' +
    '<div class="about-person">' +
      '<img src="' + _img + '" alt="David Oswald" class="about-person-img block-ai-img">' +
      '<div class="about-person-info">' +
        '<h5>' + lt('David Oswald') + '</h5>' +
        '<p>' + lt('founder of company') + '</p>' +
      '</div>' +
    '</div>' +
  '</div></div></div></div>';

var css2 =
  '.section-about{background-color:var(--color-bg-dark);background-image:url(\'' + _img + '\');background-size:cover;background-position:center;background-blend-mode:overlay;padding:90px 0;position:relative}' +
  '.section-about::before{content:"";position:absolute;top:0;left:0;width:100%;height:100%;background:rgba(42,42,42,0.92)}' +
  '.section-about .container{position:relative;z-index:1;display:flex;align-items:center;gap:60px}' +
  '.about-quote{flex:1;font-family:var(--font-heading);font-size:24px;font-weight:400;line-height:48px;color:var(--color-text-white);font-style:italic}' +
  '.about-person{flex:1;display:flex;align-items:center;gap:20px}' +
  '.about-person-img{width:140px;height:140px;border-radius:50%;object-fit:cover;flex-shrink:0}' +
  '.about-person-info h5{font-family:var(--font-heading);font-size:24px;font-weight:400;line-height:33.6px;color:var(--color-text-white);margin-bottom:5px}' +
  '.about-person-info p{font-family:var(--font-body);font-size:14px;font-weight:400;line-height:26.25px;color:var(--color-text-light);text-transform:uppercase;margin:0}' +
  '@media(max-width:1024px){.section-about .container{flex-direction:column;gap:30px;text-align:center}.about-person{justify-content:center}}' +
  '@media(max-width:767px){.section-about{padding:60px 0}.about-quote{font-size:20px;line-height:36px}.about-person{flex-direction:column;text-align:center}.about-person-img{width:100px;height:100px}}';

/* =====================================================================
   SECTION 3 — FROM SKETCH TO LIFE (Static, CSS rotation animation)
   ===================================================================== */
var html3 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-sketch has-grid-lines">' +
  '<div class="grid-lines-vertical">' +
    '<span class="g-line line-left"></span>' +
    '<span class="g-line line-center"></span>' +
    '<span class="g-line line-right"></span>' +
  '</div>' +
  '<div class="container">' +
    '<div class="sketch-image">' +
      '<img src="' + _img + '" alt="From Sketch to Life" class="block-ai-img" width="670" height="642">' +
    '</div>' +
    '<div class="sketch-content">' +
      '<div class="circular-badge" aria-hidden="true">' +
        '<svg viewBox="0 0 140 140" xmlns="http://www.w3.org/2000/svg">' +
          '<defs><path id="circlePath" d="M 70,70 m -55,0 a 55,55 0 1,1 110,0 a 55,55 0 1,1 -110,0"/></defs>' +
          '<text fill="#999" font-family="\'Titillium Web\', sans-serif" font-size="10.5" letter-spacing="3" font-weight="400">' +
            '<textPath href="#circlePath">THERATIO INTERIOR STUDIO SINCE 2012</textPath>' +
          '</text></svg>' +
      '</div>' +
      '<div class="ot-heading is-dots">' +
        '<span>' + lt('[ about company ]') + '</span>' +
        '<h2 class="main-heading">' + lt('From Sketch to Life') + '</h2>' +
      '</div>' +
      '<p>' + lt('The basic philosophy of our studio is to create individual, aesthetically stunning solutions for our customers by lightning-fast development of projects employing unique styles and architecture. Even if you don&rsquo;t have a ready sketch of what you want &ndash; we will help you to get the result you dreamed of.') + '</p>' +
      '<a href="#" class="octf-btn octf-btn-dark block-ai-link">' + lt('View Projects') + '</a>' +
    '</div>' +
  '</div></div></div></div>';

var css3 =
  '.section-sketch{padding:110px 0;position:relative}' +
  '.section-sketch .container{display:flex;align-items:center;gap:60px;position:relative;z-index:1}' +
  '.sketch-image{flex:1;min-width:0}' +
  '.sketch-image img{width:100%;max-width:670px}' +
  '.sketch-content{flex:1;min-width:0;position:relative}' +
  '.sketch-content .ot-heading .main-heading{font-size:36px;color:var(--color-primary)}' +
  '.sketch-content p{color:var(--color-text-body);margin-bottom:30px}' +
  '.circular-badge{position:absolute;top:5px;right:-20px;width:130px;height:130px;animation:rotateBadge 20s linear infinite;pointer-events:none}' +
  '@media(max-width:1024px){.section-sketch .container{flex-direction:column}.sketch-image{order:-1}.circular-badge{width:100px;height:100px;right:-10px}}' +
  '@media(max-width:767px){.section-sketch{padding:60px 0}.circular-badge{display:none}}';

/* =====================================================================
   SECTION 4 — LOGO CAROUSEL (Slick 6/view, continuous, no nav)
   ===================================================================== */
var html4 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-logos">' +
  '<div class="logos-track">' +
    '<div class="logo-item"><img src="' + _img + '" alt="Partner 1" class="block-ai-img" style="width:111px;height:40px;object-fit:contain"></div>' +
    '<div class="logo-item"><img src="' + _img + '" alt="Partner 2" class="block-ai-img" style="width:111px;height:40px;object-fit:contain"></div>' +
    '<div class="logo-item"><img src="' + _img + '" alt="Partner 3" class="block-ai-img" style="width:111px;height:40px;object-fit:contain"></div>' +
    '<div class="logo-item"><img src="' + _img + '" alt="Partner 4" class="block-ai-img" style="width:111px;height:40px;object-fit:contain"></div>' +
    '<div class="logo-item"><img src="' + _img + '" alt="Partner 5" class="block-ai-img" style="width:111px;height:40px;object-fit:contain"></div>' +
    '<div class="logo-item"><img src="' + _img + '" alt="Partner 6" class="block-ai-img" style="width:111px;height:40px;object-fit:contain"></div>' +
  '</div></div></div></div>';

var css4 =
  '.section-logos{background:var(--color-bg-light);padding:71px 0}' +
  '.logos-track{max-width:1200px;margin:0 auto;padding:0 30px}' +
  '.logos-track .logo-item{padding:0 40px;opacity:0.5;transition:0.3s;display:inline-flex;align-items:center;justify-content:center}' +
  '.logos-track .logo-item:hover{opacity:1}' +
  '.logos-track .logo-item img{height:60px;width:auto;filter:grayscale(100%)}' +
  '.logos-track .slick-track{display:flex;align-items:center}' +
  '@media(max-width:767px){.logos-track .logo-item{padding:0 20px}.logos-track .logo-item img{height:40px}}';

var js4 =
  '(async function(){' +
  'var $=window.jQuery;' +
  'var root=window.__PHOENIX_AI_SECTION_ROOT__||document;' +
  'var lcs=window.leadComponentSite;' +
  'if(lcs&&lcs.slickSourceImport)await lcs.slickSourceImport.init({});' +
  'var $s=$(root).find(".logos-track");' +
  'if(!$s.length)return;' +
  'if($s.hasClass("slick-initialized"))$s.slick("unslick");' +
  '$s.slick({' +
    'slidesToShow:6,slidesToScroll:1,autoplay:true,autoplaySpeed:0,' +
    'speed:1000,infinite:true,arrows:false,dots:false,' +
    'cssEase:"linear",variableWidth:true,' +
    'responsive:[{breakpoint:768,settings:{slidesToShow:3}}]' +
  '});' +
  '})();';

/* =====================================================================
   SECTION 5 — PORTFOLIO CATEGORIES (Gallery, 3 items, hover brightness)
   ===================================================================== */
var html5 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-categories">' +
    '<div class="cate-item" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId5 + '" data-ai-gallery-item="0">' +
      '<img src="' + _img + '" alt="Office Spaces" class="block-ai-img" data-ai-field="image" width="750" height="422">' +
      '<div class="cate-item-content">' +
        '<h2 data-ai-field="title">' + lt('Office Spaces') + '<span class="number-stroke">' + lt('01') + '</span></h2>' +
      '</div>' +
    '</div>' +
    '<div class="cate-item" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId5 + '" data-ai-gallery-item="1">' +
      '<img src="' + _img + '" alt="Public Spaces" class="block-ai-img" data-ai-field="image" width="750" height="422">' +
      '<div class="cate-item-content">' +
        '<h2 data-ai-field="title">' + lt('Public Spaces') + '<span class="number-stroke">' + lt('02') + '</span></h2>' +
      '</div>' +
    '</div>' +
    '<div class="cate-item" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId5 + '" data-ai-gallery-item="2">' +
      '<img src="' + _img + '" alt="Residential Spaces" class="block-ai-img" data-ai-field="image" width="750" height="422">' +
      '<div class="cate-item-content">' +
        '<h2 data-ai-field="title">' + lt('Residential Spaces') + '<span class="number-stroke">' + lt('03') + '</span></h2>' +
      '</div>' +
    '</div>' +
  '</div></div></div>';

var css5 =
  '.section-categories{display:grid;grid-template-columns:repeat(3,1fr)}' +
  '.cate-item{position:relative;overflow:hidden}' +
  '.cate-item img{width:100%;height:300px;object-fit:cover;transition:transform 0.5s ease,filter 0.5s ease}' +
  '.cate-item:hover img{transform:scale(1.05);filter:brightness(1.2)}' +
  '.cate-item-content{position:absolute;bottom:0;left:0;right:0;padding:30px;background:linear-gradient(transparent,rgba(0,0,0,0.5))}' +
  '.cate-item-content h2{font-family:var(--font-heading);font-size:24px;font-weight:400;line-height:48px;color:var(--color-text-white);margin:0;position:relative;display:inline-block}' +
  '.cate-item-content .number-stroke{font-family:var(--font-heading);font-weight:800;font-size:80px;line-height:1;-webkit-text-stroke:1px rgba(255,255,255,0.5);color:transparent;position:absolute;right:-60px;bottom:-10px}' +
  '@media(max-width:1024px){.section-categories{grid-template-columns:repeat(2,1fr)}}' +
  '@media(max-width:767px){.section-categories{grid-template-columns:1fr}}';

/* =====================================================================
   SECTION 6 — SERVICES + COUNTERS (Gallery 3 services, CountUp animation)
   ===================================================================== */
var html6 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-services has-grid-lines">' +
  '<div class="grid-lines-vertical">' +
    '<span class="g-line line-left"></span>' +
    '<span class="g-line line-center"></span>' +
    '<span class="g-line line-right"></span>' +
  '</div>' +
  '<div class="container">' +
    '<div class="ot-heading center is-dots">' +
      '<span>' + lt('[ OUR SERVICES ]') + '</span>' +
      '<h2 class="main-heading">' + lt('What Can We Offer') + '</h2>' +
    '</div>' +
    '<div class="services-grid">' +
      '<div class="service-box" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId6 + '" data-ai-gallery-item="0">' +
        '<div class="icon-main"><img src="' + _img + '" alt="Design &amp; Planning" class="block-ai-img" data-ai-field="image" style="width:74px;height:84px;object-fit:contain"></div>' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Design &amp; Planning') + '</a></h5>' +
        '<div class="service-desc" data-ai-field="text">' + lt('We will help you to get the result you dreamed of.') + '</div>' +
        '<a href="#" class="btn-details block-ai-link">' + lt('READ MORE') + '</a>' +
      '</div>' +
      '<div class="service-box" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId6 + '" data-ai-gallery-item="1">' +
        '<div class="icon-main"><img src="' + _img + '" alt="Custom Solutions" class="block-ai-img" data-ai-field="image" style="width:81px;height:70px;object-fit:contain"></div>' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Custom Solutions') + '</a></h5>' +
        '<div class="service-desc" data-ai-field="text">' + lt('Individual, aesthetically stunning solutions for customers.') + '</div>' +
        '<a href="#" class="btn-details block-ai-link">' + lt('READ MORE') + '</a>' +
      '</div>' +
      '<div class="service-box" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId6 + '" data-ai-gallery-item="2">' +
        '<div class="icon-main"><img src="' + _img + '" alt="Furniture &amp; Decor" class="block-ai-img" data-ai-field="image" style="width:72px;height:80px;object-fit:contain"></div>' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Furniture &amp; Decor') + '</a></h5>' +
        '<div class="service-desc" data-ai-field="text">' + lt('We create and produce our product design lines.') + '</div>' +
        '<a href="#" class="btn-details block-ai-link">' + lt('READ MORE') + '</a>' +
      '</div>' +
    '</div>' +
    '<div class="counters-grid">' +
      '<div class="ot-counter"><div class="num-wrap"><span>[</span><span class="counter-num" data-count="180">0</span><span>+]</span></div><h6>' + lt('Current Clients') + '</h6></div>' +
      '<div class="ot-counter"><div class="num-wrap"><span>[</span><span class="counter-num" data-count="10">0</span><span>+]</span></div><h6>' + lt('years of experience') + '</h6></div>' +
      '<div class="ot-counter"><div class="num-wrap"><span>[</span><span class="counter-num" data-count="35">0</span><span>+]</span></div><h6>' + lt('awards winning') + '</h6></div>' +
      '<div class="ot-counter"><div class="num-wrap"><span>[</span><span class="counter-num" data-count="5">0</span><span>+]</span></div><h6>' + lt('Offices Worldwide') + '</h6></div>' +
    '</div>' +
  '</div></div></div></div>';

var css6 =
  '.section-services{padding:110px 0;position:relative}' +
  '.section-services .container{position:relative;z-index:1}' +
  '.services-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:30px;margin-top:60px;margin-bottom:80px}' +
  '.service-box{text-align:center;padding:40px 30px;border:1px solid #eee;transition:0.3s}' +
  '.service-box:hover{box-shadow:0 10px 30px rgba(0,0,0,0.08)}' +
  '.service-box .icon-main{height:84px;display:flex;align-items:center;justify-content:center;margin-bottom:25px}' +
  '.service-box .icon-main img{max-height:84px;width:auto}' +
  '.service-box h5{font-family:var(--font-heading);font-size:24px;font-weight:400;line-height:33.6px;color:var(--color-primary);margin-bottom:15px}' +
  '.service-box h5 a{color:inherit}' +
  '.service-box .service-desc{font-family:var(--font-body);font-size:14px;font-weight:400;line-height:26.25px;color:var(--color-text-body);margin-bottom:20px}' +
  '.btn-details{font-family:var(--font-heading);font-size:13px;font-weight:600;color:var(--color-primary);text-transform:uppercase;letter-spacing:0.5px;position:relative;display:inline-block;padding-bottom:3px;border-bottom:2px solid var(--color-primary)}' +
  '.btn-details:hover{color:var(--color-accent);border-color:var(--color-accent)}' +
  '.counters-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:30px;text-align:center}' +
  '.ot-counter{text-align:center}' +
  '.ot-counter .num-wrap{font-family:var(--font-heading);font-size:48px;font-weight:200;line-height:1.2;color:var(--color-primary);margin-bottom:10px}' +
  '.ot-counter .num-wrap span{font-weight:200}' +
  '.ot-counter h6{font-family:var(--font-heading);font-size:18px;font-weight:600;line-height:25.2px;letter-spacing:1px;text-transform:uppercase;color:var(--color-text-dark);margin:0}' +
  '@media(max-width:1024px){.services-grid{grid-template-columns:repeat(2,1fr)}.counters-grid{grid-template-columns:repeat(2,1fr);gap:40px}}' +
  '@media(max-width:767px){.section-services{padding:60px 0}.services-grid{grid-template-columns:1fr}.counters-grid{grid-template-columns:repeat(2,1fr);gap:30px}}' +
  '@media(max-width:480px){.counters-grid{grid-template-columns:1fr}}';

var js6 =
  '(function(){' +
  'var root=window.__PHOENIX_AI_SECTION_ROOT__||document;' +
  'var counters=(root.querySelectorAll?root:document).querySelectorAll(".counter-num[data-count]");' +
  'if(!counters.length)return;' +
  'var observer=new IntersectionObserver(function(entries){' +
    'entries.forEach(function(entry){' +
      'if(entry.isIntersecting){' +
        'var el=entry.target;' +
        'var end=parseInt(el.getAttribute("data-count"),10)||0;' +
        'if(window.CountUp){new CountUp(el,end,{startVal:0,duration:2.5}).start();}' +
        'else{el.textContent=end;}' +
        'observer.unobserve(el);' +
      '}' +
    '});' +
  '},{threshold:0.3});' +
  'counters.forEach(function(el){observer.observe(el);});' +
  '})();';

/* =====================================================================
   SECTION 7 — PORTFOLIO METRO GRID (DYNAMIC: galleryList)
   ===================================================================== */
var _s7uuid = 'gallerylist_' + _cloneId + '_7';
var html7 =
  '<div class="block-container"><div class="developer-component" data-gjs-type="developer-component">' +
  '<div class="backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_' + _s7uuid + '"' +
    ' data-gjs-type="developer-node-component"' +
    ' data-block-type="phoenix_blocks_galleryList"' +
    ' data-block-uuid="' + _s7uuid + '"' +
    ' data-new-auto-uuid="' + _s7uuid + '">' +
  '<div class="section-portfolio">' +
  '<div class="portfolio-filters">' +
    '<span class="portfolio-filter-tab active" data-filter="all">' + lt('All') + '</span>' +
    '<span class="portfolio-filter-tab" data-filter="architecture">' + lt('Architecture') + '</span>' +
    '<span class="portfolio-filter-tab" data-filter="decor">' + lt('Decor') + '</span>' +
    '<span class="portfolio-filter-tab" data-filter="furniture">' + lt('Furniture') + '</span>' +
    '<span class="portfolio-filter-tab" data-filter="interior">' + lt('Interior') + '</span>' +
  '</div>' +
  '<div class="portfolio-grid">' +
    '<div class="portfolio-item span-2" data-category="interior" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId7 + '" data-ai-gallery-item="0">' +
      '<img src="' + _img + '" alt="Stylish Family Appartment" class="block-ai-img" data-ai-field="image">' +
      '<div class="portfolio-info">' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Stylish Family Appartment') + '</a></h5>' +
        '<div class="portfolio-cates" data-ai-field="text"><a href="#" class="block-ai-link">' + lt('Interior') + '</a></div>' +
      '</div>' +
    '</div>' +
    '<div class="portfolio-item" data-category="decor interior" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId7 + '" data-ai-gallery-item="1">' +
      '<img src="' + _img + '" alt="Minimal Guests House" class="block-ai-img" data-ai-field="image">' +
      '<div class="portfolio-info">' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Minimal Guests House') + '</a></h5>' +
        '<div class="portfolio-cates" data-ai-field="text"><a href="#" class="block-ai-link">' + lt('Decor') + '</a> <a href="#" class="block-ai-link">' + lt('Interior') + '</a></div>' +
      '</div>' +
    '</div>' +
    '<div class="portfolio-item" data-category="architecture" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId7 + '" data-ai-gallery-item="2">' +
      '<img src="' + _img + '" alt="Art Family Residence" class="block-ai-img" data-ai-field="image">' +
      '<div class="portfolio-info">' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Art Family Residence') + '</a></h5>' +
        '<div class="portfolio-cates" data-ai-field="text"><a href="#" class="block-ai-link">' + lt('Architecture') + '</a></div>' +
      '</div>' +
    '</div>' +
    '<div class="portfolio-item" data-category="furniture" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId7 + '" data-ai-gallery-item="3">' +
      '<img src="' + _img + '" alt="Private House in Spain" class="block-ai-img" data-ai-field="image">' +
      '<div class="portfolio-info">' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Private House in Spain') + '</a></h5>' +
        '<div class="portfolio-cates" data-ai-field="text"><a href="#" class="block-ai-link">' + lt('Furniture') + '</a></div>' +
      '</div>' +
    '</div>' +
    '<div class="portfolio-item" data-category="furniture" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId7 + '" data-ai-gallery-item="4">' +
      '<img src="' + _img + '" alt="Modern Villa in Belgium" class="block-ai-img" data-ai-field="image">' +
      '<div class="portfolio-info">' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Modern Villa in Belgium') + '</a></h5>' +
        '<div class="portfolio-cates" data-ai-field="text"><a href="#" class="block-ai-link">' + lt('Furniture') + '</a></div>' +
      '</div>' +
    '</div>' +
    '<div class="portfolio-item span-2" data-category="furniture interior" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId7 + '" data-ai-gallery-item="5">' +
      '<img src="' + _img + '" alt="Minimalistic Style Appartment" class="block-ai-img" data-ai-field="image">' +
      '<div class="portfolio-info">' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Minimalistic Style Appartment') + '</a></h5>' +
        '<div class="portfolio-cates" data-ai-field="text"><a href="#" class="block-ai-link">' + lt('Furniture') + '</a> <a href="#" class="block-ai-link">' + lt('Interior') + '</a></div>' +
      '</div>' +
    '</div>' +
  '</div></div></div></div></div>';

var css7 =
  '.section-portfolio{padding:0 0 120px}' +
  '.portfolio-filters{display:flex;align-items:center;justify-content:center;gap:30px;padding:0 15px 50px;max-width:1200px;margin:0 auto}' +
  '.portfolio-filter-tab{font-family:var(--font-heading);font-size:13px;font-weight:600;text-transform:uppercase;letter-spacing:1px;color:#999;cursor:pointer;padding-bottom:8px;border-bottom:2px solid transparent;transition:0.3s;white-space:nowrap}' +
  '.portfolio-filter-tab:hover{color:var(--color-primary)}' +
  '.portfolio-filter-tab.active{color:var(--color-primary);border-bottom-color:var(--color-accent)}' +
  '.portfolio-grid{display:grid;grid-template-columns:repeat(4,1fr);grid-auto-rows:minmax(200px,auto);gap:0;max-width:100%}' +
  '.portfolio-item{position:relative;overflow:hidden}' +
  '.portfolio-item img{width:100%;height:100%;object-fit:cover;transition:transform 0.6s ease}' +
  '.portfolio-item:hover img{transform:scale(1.05)}' +
  '.portfolio-item.span-2{grid-column:span 2}' +
  '.portfolio-info{position:absolute;bottom:0;left:0;right:0;padding:25px;background:linear-gradient(transparent,rgba(0,0,0,0.7));opacity:0;transition:0.4s;transform:translateY(10px)}' +
  '.portfolio-item:hover .portfolio-info{opacity:1;transform:translateY(0)}' +
  '.portfolio-info h5{font-size:20px;color:var(--color-text-white);margin-bottom:5px}' +
  '.portfolio-info h5 a{color:inherit}' +
  '.portfolio-cates{font-size:13px;color:var(--color-text-light);text-transform:uppercase;margin:0}' +
  '.portfolio-cates a{color:var(--color-accent)}' +
  '@media(max-width:1024px){.portfolio-grid{grid-template-columns:repeat(2,1fr)}.portfolio-item.span-2{grid-column:span 2}.portfolio-filters{gap:20px;flex-wrap:wrap}}' +
  '@media(max-width:767px){.portfolio-grid{grid-template-columns:repeat(2,1fr)}.portfolio-item.span-2{grid-column:span 2}.portfolio-filters{gap:15px;padding-bottom:30px}.portfolio-filter-tab{font-size:12px;letter-spacing:0.5px}}' +
  '@media(max-width:480px){.portfolio-grid{grid-template-columns:1fr}.portfolio-item.span-2{grid-column:span 1}.portfolio-filters{gap:10px}.portfolio-filter-tab{font-size:11px;padding-bottom:6px}}';

var js7 =
  '(function(){' +
  'var $=window.jQuery;' +
  'var root=window.__PHOENIX_AI_SECTION_ROOT__||document;' +
  '$(root).find(".portfolio-filter-tab").on("click",function(){' +
    'var $t=$(this);' +
    '$(root).find(".portfolio-filter-tab").removeClass("active");' +
    '$t.addClass("active");' +
    'var f=$t.data("filter");' +
    'if(f==="all"){$(root).find(".portfolio-item").show();}' +
    'else{$(root).find(".portfolio-item").each(function(){' +
      'var cats=($(this).data("category")||"").split(" ");' +
      '$(this).toggle(cats.indexOf(f)>=0);' +
    '});}' +
  '});' +
  '})();';

/* =====================================================================
   SECTION 8 — CTA BANNER (Static)
   ===================================================================== */
var html8 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-cta">' +
  '<div class="container">' +
    '<div class="cta-text">' +
      '<h2>' + lt('Get Incredible Interior Design Right Now!') + '</h2>' +
      '<p>' + lt('At every stage, we could supervise your project &ndash; controlling all the details and consulting the builders.') + '</p>' +
    '</div>' +
    '<div class="cta-action">' +
      '<a href="#" class="octf-btn octf-btn-light block-ai-link">' + lt('get in touch') + '</a>' +
    '</div>' +
  '</div></div></div></div>';

var css8 =
  '.section-cta{background-color:var(--color-bg-dark);background-image:url(\'' + _img + '\');background-size:cover;background-position:center;background-blend-mode:overlay;padding:73px 0;position:relative}' +
  '.section-cta::before{content:"";position:absolute;top:0;left:0;width:100%;height:100%;background:rgba(42,42,42,0.9)}' +
  '.section-cta .container{position:relative;z-index:1;display:flex;align-items:center;justify-content:space-between;gap:40px}' +
  '.cta-text{flex:2}' +
  '.cta-text h2{font-family:var(--font-heading);font-size:36px;font-weight:400;line-height:48px;color:var(--color-text-white);font-style:italic;margin-bottom:10px}' +
  '.cta-text p{color:var(--color-text-light);margin:0}' +
  '.cta-action{flex:1;text-align:right}' +
  '@media(max-width:1024px){.section-cta .container{flex-direction:column;text-align:center}.cta-action{text-align:center}}' +
  '@media(max-width:767px){.section-cta{padding:50px 0}.cta-text h2{font-size:24px;line-height:36px}}';

/* =====================================================================
   SECTION 9 — COMPANY VALUES (Progress bars animate on scroll)
   ===================================================================== */
var html9 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-values has-grid-lines">' +
  '<div class="grid-lines-vertical">' +
    '<span class="g-line line-left"></span>' +
    '<span class="g-line line-center"></span>' +
    '<span class="g-line line-right"></span>' +
  '</div>' +
  '<div class="container">' +
    '<div class="values-content">' +
      '<div class="ot-heading is-dots">' +
        '<span>' + lt('[ our skills ]') + '</span>' +
        '<h2 class="main-heading">' + lt('The Core Company Values') + '</h2>' +
      '</div>' +
      '<p>' + lt('We are constantly growing, learning, and improving and our partners are steadily increasing. 200 projects is a sizable number.') + '</p>' +
      '<div class="ot-progress"><div class="overflow"><span class="pname">' + lt('interior sketch') + '</span><span class="ppercent">' + lt('65%') + '</span></div><div class="iprogress"><div class="progress-bar" data-progress="65%" style="width:0%"></div></div></div>' +
      '<div class="ot-progress"><div class="overflow"><span class="pname">' + lt('3D Modeling') + '</span><span class="ppercent">' + lt('85%') + '</span></div><div class="iprogress"><div class="progress-bar" data-progress="85%" style="width:0%"></div></div></div>' +
      '<div class="ot-progress"><div class="overflow"><span class="pname">' + lt('2D Planning') + '</span><span class="ppercent">' + lt('55%') + '</span></div><div class="iprogress"><div class="progress-bar" data-progress="55%" style="width:0%"></div></div></div>' +
    '</div>' +
    '<div class="values-image">' +
      '<img src="' + _img + '" alt="Company Values" class="block-ai-img" width="860" height="645">' +
      '<div class="values-keyword-label kw-quality"><span>' + lt('Quality') + '</span><span class="kw-dot"></span></div>' +
      '<div class="values-keyword-label kw-experience"><span class="kw-dot"></span><span>' + lt('Experience') + '</span></div>' +
      '<div class="values-keyword-label kw-hardskills"><span class="kw-dot"></span><span>' + lt('Hard Skills') + '</span></div>' +
    '</div>' +
  '</div></div></div></div>';

var css9 =
  '.section-values{padding:80px 0 120px;position:relative}' +
  '.section-values .container{display:flex;align-items:center;gap:60px;position:relative;z-index:1}' +
  '.values-content{flex:1;min-width:0}' +
  '.values-content .ot-heading .main-heading{font-size:36px;color:var(--color-primary)}' +
  '.values-content>p{margin-bottom:40px}' +
  '.values-image{flex:1;min-width:0;position:relative}' +
  '.values-image img{width:100%;max-width:860px}' +
  '.ot-progress{margin-bottom:25px}' +
  '.ot-progress .overflow{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}' +
  '.ot-progress .pname{font-family:var(--font-heading);font-size:14px;font-weight:600;text-transform:uppercase;letter-spacing:1px;color:var(--color-primary)}' +
  '.ot-progress .ppercent{font-family:var(--font-heading);font-size:14px;font-weight:600;color:var(--color-primary)}' +
  '.ot-progress .iprogress{width:100%;height:2px;background:#e5e5e5;position:relative}' +
  '.ot-progress .progress-bar{height:100%;background:var(--color-primary);position:relative;transition:width 0.6s ease}' +
  '.ot-progress .progress-bar::after{content:"";position:absolute;right:-4px;top:-4px;width:0;height:0;border-left:5px solid transparent;border-right:5px solid transparent;border-top:8px solid var(--color-primary);transform:rotate(-90deg)}' +
  '.values-keyword-label{position:absolute;display:flex;align-items:center;gap:8px;font-family:var(--font-heading);font-size:14px;font-weight:600;text-transform:uppercase;letter-spacing:1px;color:var(--color-primary);white-space:nowrap}' +
  '.values-keyword-label .kw-dot{width:22px;height:22px;border-radius:50%;border:1px solid var(--color-primary);display:flex;align-items:center;justify-content:center;flex-shrink:0}' +
  '.values-keyword-label .kw-dot::before{content:"";width:4px;height:4px;border-radius:50%;background:var(--color-primary)}' +
  '.values-keyword-label.kw-quality{top:-25px;right:140px}' +
  '.values-keyword-label.kw-experience{top:45%;right:-80px;transform:translateY(-50%)}' +
  '.values-keyword-label.kw-hardskills{bottom:15px;right:20px}' +
  '@media(max-width:1024px){.section-values .container{flex-direction:column}.values-keyword-label.kw-experience{right:-40px}}' +
  '@media(max-width:767px){.section-values{padding:60px 0}.section-values .container{gap:40px}.values-keyword-label{display:none}}';

var js9 =
  '(function(){' +
  'var root=window.__PHOENIX_AI_SECTION_ROOT__||document;' +
  'var bars=(root.querySelectorAll?root:document).querySelectorAll(".progress-bar[data-progress]");' +
  'if(!bars.length)return;' +
  'var observer=new IntersectionObserver(function(entries){' +
    'entries.forEach(function(entry){' +
      'if(entry.isIntersecting){' +
        'var bar=entry.target;' +
        'bar.style.transition="width 1.5s ease-in-out";' +
        'bar.style.width=bar.getAttribute("data-progress");' +
        'observer.unobserve(bar);' +
      '}' +
    '});' +
  '},{threshold:0.3});' +
  'bars.forEach(function(bar){observer.observe(bar);});' +
  '})();';

/* =====================================================================
   SECTION 10 — TEAM CAROUSEL (Slick 3/view, dots, autoplay, Gallery 5)
   ===================================================================== */
var html10 =
  '<div class="block-container"><div class="developer-component-ai" data-gjs-type="developer-component-ai">' +
  '<div class="section-team">' +
  '<div class="ot-heading center is-dots" style="padding:0 15px;position:relative;z-index:1">' +
    '<span>' + lt('[ our professionals ]') + '</span>' +
    '<h2 class="main-heading">' + lt('Meet Our Skilled Team') + '</h2>' +
  '</div>' +
  '<div class="team-track">' +
    '<div class="team-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId10 + '" data-ai-gallery-item="0">' +
      '<img src="' + _img + '" alt="Robert Cooper" class="block-ai-img" data-ai-field="image">' +
      '<div class="team-text-overlay">' +
        '<h4 data-ai-field="title">' + lt('Robert Cooper') + '</h4>' +
        '<div class="m-extra" data-ai-field="text">' + lt('[ Finance Manager ]') + '</div>' +
      '</div>' +
    '</div>' +
    '<div class="team-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId10 + '" data-ai-gallery-item="1">' +
      '<img src="' + _img + '" alt="Olivia Peterson" class="block-ai-img" data-ai-field="image">' +
      '<div class="team-text-overlay">' +
        '<h4 data-ai-field="title">' + lt('Olivia Peterson') + '</h4>' +
        '<div class="m-extra" data-ai-field="text">' + lt('[ CEO of Company ]') + '</div>' +
      '</div>' +
    '</div>' +
    '<div class="team-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId10 + '" data-ai-gallery-item="2">' +
      '<img src="' + _img + '" alt="Amalia Bruno" class="block-ai-img" data-ai-field="image">' +
      '<div class="team-text-overlay">' +
        '<h4 data-ai-field="title">' + lt('Amalia Bruno') + '</h4>' +
        '<div class="m-extra" data-ai-field="text">' + lt('[ Interior Designer ]') + '</div>' +
      '</div>' +
    '</div>' +
    '<div class="team-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId10 + '" data-ai-gallery-item="3">' +
      '<img src="' + _img + '" alt="Katie Doyle" class="block-ai-img" data-ai-field="image">' +
      '<div class="team-text-overlay">' +
        '<h4 data-ai-field="title">' + lt('Katie Doyle') + '</h4>' +
        '<div class="m-extra" data-ai-field="text">' + lt('[ Interior Designer ]') + '</div>' +
      '</div>' +
    '</div>' +
    '<div class="team-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId10 + '" data-ai-gallery-item="4">' +
      '<img src="' + _img + '" alt="Andrew Kinzer" class="block-ai-img" data-ai-field="image">' +
      '<div class="team-text-overlay">' +
        '<h4 data-ai-field="title">' + lt('Andrew Kinzer') + '</h4>' +
        '<div class="m-extra" data-ai-field="text">' + lt('[ CEO of Company ]') + '</div>' +
      '</div>' +
    '</div>' +
  '</div>' +
  '<div class="team-dots-container"></div>' +
  '</div></div></div>';

var css10 =
  '.section-team{background-color:var(--color-bg-light);background-image:url(\'' + _img + '\');background-size:cover;background-position:center;background-blend-mode:overlay;padding:105px 0 86px;position:relative}' +
  '.section-team::before{content:"";position:absolute;top:0;left:0;width:100%;height:100%;background:rgba(244,244,244,0.92)}' +
  '.section-team .ot-heading,.section-team .team-track{position:relative;z-index:1}' +
  '.team-track{margin-top:40px}' +
  '.team-card{position:relative;overflow:hidden}' +
  '.team-card img{width:100%;height:420px;object-fit:cover;transition:transform 0.5s}' +
  '.team-card:hover img{transform:scale(1.05)}' +
  '.team-text-overlay{position:absolute;bottom:0;left:0;right:0;top:0;background:rgba(26,26,26,0.8);opacity:0;transition:0.4s;display:flex;align-items:center;justify-content:center;text-align:center;flex-direction:column}' +
  '.team-card:hover .team-text-overlay{opacity:1}' +
  '.team-text-overlay h4{font-family:var(--font-heading);font-size:30px;font-weight:400;line-height:36px;letter-spacing:0.5px;text-transform:uppercase;color:var(--color-text-white);margin-bottom:10px}' +
  '.team-text-overlay .m-extra{font-family:var(--font-body);font-size:14px;color:var(--color-text-light)}' +
  '.team-dots-container{text-align:center;margin-top:60px;position:relative;z-index:1}' +
  '.team-dots-container .slick-dots{display:inline-flex !important;gap:0;list-style:none;padding:0;margin:0}' +
  '.team-dots-container .slick-dots li{display:inline-block;margin:0 2px}' +
  '.team-dots-container .slick-dots li button{width:30px;height:30px;border-radius:50%;border:1px solid transparent;background:transparent;cursor:pointer;font-size:0;padding:0;position:relative}' +
  '.team-dots-container .slick-dots li button::before{content:"";position:absolute;top:50%;left:50%;width:4px;height:4px;background:rgb(50,50,50);border-radius:50%;transform:translate(-50%,-50%)}' +
  '.team-dots-container .slick-dots li.slick-active button{border-color:rgb(50,50,50)}' +
  '@media(max-width:767px){.section-team{padding:60px 0}.team-card img{height:280px}}';

var js10 =
  '(async function(){' +
  'var $=window.jQuery;' +
  'var root=window.__PHOENIX_AI_SECTION_ROOT__||document;' +
  'var lcs=window.leadComponentSite;' +
  'if(lcs&&lcs.slickSourceImport)await lcs.slickSourceImport.init({});' +
  'var $s=$(root).find(".team-track");' +
  'if(!$s.length)return;' +
  'if($s.hasClass("slick-initialized"))$s.slick("unslick");' +
  '$s.slick({' +
    'slidesToShow:3,slidesToScroll:1,dots:true,autoplay:true,' +
    'autoplaySpeed:3000,speed:1000,infinite:true,arrows:false,' +
    'appendDots:$(root).find(".team-dots-container"),' +
    'responsive:[' +
      '{breakpoint:1025,settings:{slidesToShow:3}},' +
      '{breakpoint:768,settings:{slidesToShow:2}},' +
      '{breakpoint:481,settings:{slidesToShow:1}}' +
    ']' +
  '});' +
  '})();';

/* =====================================================================
   SECTION 11 — BLOG CAROUSEL (Slick 2/view, dots, no autoplay, Gallery 3)
   ===================================================================== */
var _s11uuid = 'articlelist_' + _cloneId + '_11';
var html11 =
  '<div class="block-container"><div class="developer-component" data-gjs-type="developer-component">' +
  '<div class="backstage-blocksEditor-wrap developer-node-component developer-component-newedit block_' + _s11uuid + '"' +
    ' data-gjs-type="developer-node-component"' +
    ' data-block-type="phoenix_blocks_Articlelist"' +
    ' data-block-uuid="' + _s11uuid + '"' +
    ' data-new-auto-uuid="' + _s11uuid + '">' +
  '<div class="section-blog has-grid-lines">' +
  '<div class="grid-lines-vertical">' +
    '<span class="g-line line-left"></span>' +
    '<span class="g-line line-center"></span>' +
    '<span class="g-line line-right"></span>' +
  '</div>' +
  '<div class="container">' +
    '<div class="blog-header">' +
      '<div class="ot-heading is-dots">' +
        '<span>' + lt('[ OUR BLOG ]') + '</span>' +
        '<h2 class="main-heading">' + lt('Read Our Latest News') + '</h2>' +
      '</div>' +
      '<a href="#" class="octf-btn octf-btn-dark block-ai-link">' + lt('VIEW ALL') + '</a>' +
    '</div>' +
    '<div class="blog-track">' +
      '<div class="blog-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId11 + '" data-ai-gallery-item="0">' +
        '<div class="blog-card-thumb">' +
          '<img src="' + _img + '" alt="Top 10 Tips for Your Kitchen Interior Design" class="block-ai-img" data-ai-field="image">' +
          '<span class="category-tag">' + lt('Interior') + '</span>' +
        '</div>' +
        '<div class="blog-card-meta"><span>' + lt('MARCH 20, 2020') + '</span><span class="sep"></span><span>' + lt('TOM BLACK') + '</span></div>' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Top 10 Tips for Your Kitchen Interior Design') + '</a></h5>' +
        '<div class="blog-desc" data-ai-field="text">' + lt('A faceting effect livens up and...') + '</div>' +
      '</div>' +
      '<div class="blog-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId11 + '" data-ai-gallery-item="1">' +
        '<div class="blog-card-thumb">' +
          '<img src="' + _img + '" alt="The Golden Ratio Rule for Best 2D Sketch" class="block-ai-img" data-ai-field="image">' +
          '<span class="category-tag">' + lt('Achitecture') + '</span>' +
        '</div>' +
        '<div class="blog-card-meta"><span>' + lt('MARCH 20, 2020') + '</span><span class="sep"></span><span>' + lt('TOM BLACK') + '</span></div>' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('The Golden Ratio Rule for Best 2D Sketch') + '</a></h5>' +
        '<div class="blog-desc" data-ai-field="text">' + lt('A faceting effect livens up and...') + '</div>' +
      '</div>' +
      '<div class="blog-card" data-gjs-type="cyberPhoenixGalleryAI" data-ai-gallery-id="' + galId11 + '" data-ai-gallery-item="2">' +
        '<div class="blog-card-thumb">' +
          '<img src="' + _img + '" alt="Use Pastel Colors &amp; Natural Materials" class="block-ai-img" data-ai-field="image">' +
          '<span class="category-tag">' + lt('Interior') + '</span>' +
        '</div>' +
        '<div class="blog-card-meta"><span>' + lt('MARCH 19, 2020') + '</span><span class="sep"></span><span>' + lt('TOM BLACK') + '</span></div>' +
        '<h5 data-ai-field="title"><a href="#" class="block-ai-link">' + lt('Use Pastel Colors &amp; Natural Materials') + '</a></h5>' +
        '<div class="blog-desc" data-ai-field="text">' + lt('A faceting effect livens up and...') + '</div>' +
      '</div>' +
    '</div>' +
    '<div class="blog-dots-container"></div>' +
  '</div></div></div></div></div>';

var css11 =
  '.section-blog{padding:110px 0 120px;position:relative}' +
  '.section-blog .container{position:relative;z-index:1}' +
  '.blog-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:50px}' +
  '.blog-track .blog-card{padding:0 15px}' +
  '.blog-card{background:var(--color-bg-white)}' +
  '.blog-card-thumb{position:relative;overflow:hidden;margin-bottom:20px}' +
  '.blog-card-thumb img{width:100%;height:240px;object-fit:cover;transition:transform 0.5s}' +
  '.blog-card:hover .blog-card-thumb img{transform:scale(1.05)}' +
  '.blog-card-thumb .category-tag{position:absolute;bottom:15px;left:15px;font-family:var(--font-heading);font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:1px;color:var(--color-text-white);background:var(--color-primary);padding:6px 14px}' +
  '.blog-card-meta{display:flex;align-items:center;gap:10px;font-family:var(--font-heading);font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:1px;color:var(--color-accent);margin-bottom:12px}' +
  '.blog-card-meta .sep{width:4px;height:4px;border-radius:50%;background:var(--color-accent)}' +
  '.blog-card h5{font-family:var(--font-heading);font-size:24px;font-weight:400;line-height:33.6px;color:var(--color-primary);margin-bottom:10px}' +
  '.blog-card h5 a{color:inherit;transition:0.3s}' +
  '.blog-card h5 a:hover{color:var(--color-accent)}' +
  '.blog-card:hover h5 a{text-decoration:underline}' +
  '.blog-card .blog-desc{font-family:var(--font-body);font-size:14px;font-weight:400;line-height:26.25px;color:var(--color-text-body)}' +
  '.blog-dots-container{text-align:center;margin-top:40px}' +
  '.blog-dots-container .slick-dots{display:inline-flex !important;gap:8px;list-style:none;padding:0;margin:0}' +
  '.blog-dots-container .slick-dots li{display:inline-block;margin:0}' +
  '.blog-dots-container .slick-dots li button{width:12px;height:12px;border-radius:50%;border:1px solid #999;background:transparent;cursor:pointer;font-size:0;padding:0}' +
  '.blog-dots-container .slick-dots li.slick-active button{background:var(--color-primary);border-color:var(--color-primary)}' +
  '@media(max-width:767px){.section-blog{padding:60px 0}.blog-header{flex-direction:column;gap:20px}}';

var js11 =
  '(async function(){' +
  'var $=window.jQuery;' +
  'var root=window.__PHOENIX_AI_SECTION_ROOT__||document;' +
  'var lcs=window.leadComponentSite;' +
  'if(lcs&&lcs.slickSourceImport)await lcs.slickSourceImport.init({});' +
  'var $s=$(root).find(".blog-track");' +
  'if(!$s.length)return;' +
  'if($s.hasClass("slick-initialized"))$s.slick("unslick");' +
  '$s.slick({' +
    'slidesToShow:2,slidesToScroll:1,dots:true,autoplay:false,' +
    'infinite:false,arrows:false,' +
    'appendDots:$(root).find(".blog-dots-container"),' +
    'responsive:[{breakpoint:768,settings:{slidesToShow:1}}]' +
  '});' +
  '})();';

/* ============================= FREEMARKER TEMPLATES ============================= */
var ftl_gallerylist_placeholder =
  '<div class="blockGallery" data-gjs-type="phoenix-container" data-strong="1">\n' +
  '\t<div class="backstage-blocksEditor-wrap wra" data-block-uuid="cyber" data-gjs-type="developer-node-component"\n' +
  '\t\tdata-block-type="phoenix_blocks_galleryList"\n' +
  '\t\tdata-block-list-setting="dataSelect,loadMethod,pageNumber"\n' +
  '\t\tdata-default-setting={"pageSize":6,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{},"expandSort":[],"layoutStyle":"0","relatedTypes":"0","translationEntry":[]}>\n' +
  '\t\t<style>\n' +
  '\t\t\t[data-new-auto-uuid="${pageNodeId!\'\'}"] {\n' +
  '\t\t\t\t--color-match-setting1: var(--ld-main1, #62c6ff);\n' +
  '\t\t\t\t--color-match-setting2: var(--ld-Auxiliary1, #37383e);\n' +
  '\t\t\t}\n' +
  '\t\t</style>\n' +
  '\t\t[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!\'6\'}"\n' +
  '\t\tselectGalleryCateType="${dataType!\'0\'}" selectCateIds="${dataGroupId!\'\'}" selectGalleryIds="${dataIds!\'\'}"\n' +
  '\t\torderBy="${orderBy!\'0\'}" expandIds="${expandIds!\'\'}"\n' +
  '\t\tquery=\'{\n' +
  '\t\tgalleryList(\n' +
  '\t\tconditionDto:{\n' +
  '\t\tpage: $page\n' +
  '\t\tlimit: $limit\n' +
  '\t\toptionsParam: $optionsParam\n' +
  '\t\tselectCateIds: $selectCateIds\n' +
  '\t\tselectGalleryIds: $selectGalleryIds\n' +
  '\t\tselectGalleryCateType: "$selectGalleryCateType"\n' +
  '\t\torderBy: "$orderBy"\n' +
  '\t\t}) {\n' +
  '\t\ttotalRow\n' +
  '\t\tpageSize\n' +
  '\t\tpageNumber\n' +
  '\t\tlist{\n' +
  '\t\tencodeId\n' +
  '\t\tgalleryTitle\n' +
  '\t\tgalleryUrl\n' +
  '\t\tgallerySummary\n' +
  '\t\tphotoUrlNormal\n' +
  '\t\tphotoUrlDefine\n' +
  '\t\tcateName\n' +
  '\t\tcateUrl\n' +
  '\t\tphotoSeoList{\n' +
  '\t\t\tphotoId\n' +
  '\t\t\tphotoUrlNormal\n' +
  '\t\t\tphotoAlt\n' +
  '\t\t\tphotoTitle\n' +
  '\t\t}\n' +
  '\t\t}\n' +
  '\t\t}\n' +
  '\t\t}\']\n' +
  '\t\t<div class="cont">\n' +
  '\t\t\t<div class="Gallery_Container">\n' +
  '\t\t\t\t<div class="zh galleryWrap block-gallery-container-replace">\n' +
  '\t\t\t\t\t[#if data?? && data.galleryList?? && data.galleryList.list?? && (data.galleryList.list?size > 0)]\n' +
  '\t\t\t\t\t[#list data.galleryList.list as gallery]\n' +
  '\t\t\t\t\t<div class="galleryItem">\n' +
  '\t\t\t\t\t\t<div class="imgBox">\n' +
  '\t\t\t\t\t\t\t<a href="${gallery.galleryUrl!}">\n' +
  '\t\t\t\t\t\t\t\t<img class="lazyimg" src="${gallery.photoUrlNormal!}" alt="${gallery.photoSeoList[0].photoAlt!}" title="${gallery.photoSeoList[0].photoTitle!}">\n' +
  '\t\t\t\t\t\t\t</a>\n' +
  '\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t<div class="textBox">\n' +
  '\t\t\t\t\t\t\t<h3><a href="${gallery.galleryUrl!}" title="${gallery.galleryTitle!?html}">${gallery.galleryTitle!?html}</a></h3>\n' +
  '\t\t\t\t\t\t\t<span class="cateName">${gallery.cateName!}</span>\n' +
  '\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t[/#list]\n' +
  '\t\t\t\t\t[#else]\n' +
  '\t\t\t\t\t<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>\n' +
  '\t\t\t\t\t[/#if]\n' +
  '\t\t\t\t</div>\n' +
  '\t\t\t</div>\n' +
  '\t\t</div>\n' +
  '\t\t<script>\n' +
  '\t\t\t$(function () {\n' +
  '\t\t\t\twindow._block_namespaces_[\'blockGallery\'].init({ \'relationId\': \'${relationId}\', \'relationType\': \'${relationType}\', \'pageId\': \'${pageId}\', \'nodeId\':\'cyber_${nodeId!""}\', \'appId\': \'${appId!}\', \'appIsDev\': \'${appIsDev!"0"}\', \'appVersion\': \'${appVersion}\' });\n' +
  '\t\t\t});\n' +
  '\t\t</script>\n' +
  '\t\t[/@api]\n' +
  '\t</div>\n' +
  '</div>';

var ftl_articlelist_34134 =
  '<div class="block34134" data-gjs-type="phoenix-container" data-strong="1">\n' +
  '\t[#assign specialLanCode = ["3", "45", "42", "32", "29"] ]\n' +
  '\t[#if __current_site_lanCode__?? && specialLanCode?seq_contains(__current_site_lanCode__)]\n' +
  '\t\t<style data-collect=\'1\'>\n' +
  '\t\t\tdiv.block34134 .butn {\n' +
  '\t\t\t\tposition: absolute;\n' +
  '\t\t\t\tleft: auto;\n' +
  '\t\t\t\tright: 25px;\n' +
  '\t\t\t}\n' +
  '\t\t</style>\n' +
  '\t[/#if]\n' +
  '\t<div class="backstage-blocksEditor-wrap wra" data-block-uuid="cyber" data-gjs-type="developer-node-component"\n' +
  '\t\tdata-block-type="phoenix_blocks_Articlelist"\n' +
  '\t\tdata-block-list-setting="dataSelect,loadMethod,pageNumber,dataOrderBy,showDate"\n' +
  '\t\tdata-default-setting={"pageSize":3,"page":1,"dataType":"0","dataIds":[],"dataGroupId":[],"orderBy":"0","loadMethod":"1","refreshMethod":"0","jumpMethod":"0","expandIds":{"showField":{"label":"\\u663e\\u793a\\u5b57\\u6bb5","key":"showField","draggable":false,"data":[{"fieldName":"\\u6587\\u7ae0\\u6807\\u9898","fieldId":"articleTitle","fieldType":"0","value":"1","checked":false},{"fieldName":"\\u6587\\u7ae0\\u7b80\\u4ecb","fieldId":"articleSummary","fieldType":"0","value":"2","checked":false},{"fieldName":"\\u65e5\\u671f","fieldId":"publishTime","fieldType":"0","value":"3","checked":false},{"fieldName":"\\u6587\\u7ae0\\u5206\\u7c7b","fieldId":"cateName","fieldType":"0","value":"4","checked":false}]}},"expandSort":["showField"],"layoutStyle":"0","showDate":"1","relatedTypes":"0","translationEntry":[]}>\n' +
  '\t\t<style>\n' +
  '\t\t\t[data-new-auto-uuid="${pageNodeId!\'\'}"] {\n' +
  '\t\t\t\t--color-match-setting1: var(--ld-main1, #62c6ff);\n' +
  '\t\t\t\t--color-match-setting2: var(--ld-Auxiliary1, #37383e);\n' +
  '\t\t\t}\n' +
  '\t\t</style>\n' +
  '\t\t[@api method="post" url="/phoenix2/composite/graphql" page="${pageNum!1}" limit="${pageSize!\'10\'}"\n' +
  '\t\tselectArticleCateType="${dataType!\'0\'}" selectCateIds="${dataGroupId!\'\'}" selectArticleIds="${dataIds!\'\'}"\n' +
  '\t\torderBy="${orderBy!\'0\'}" expandIds="${expandIds!\'\'}" articleId="${infoId!-1}" articlePageId="${infoGroupId!-1}"\n' +
  '\t\tquery=\'{\n' +
  '\t\tarticleList(\n' +
  '\t\tconditionDto:{\n' +
  '\t\tpage: $page\n' +
  '\t\tlimit: $limit\n' +
  '\t\toptionsParam: $optionsParam\n' +
  '\t\tselectCateIds: $selectCateIds\n' +
  '\t\tselectArticleIds: $selectArticleIds\n' +
  '\t\tselectArticleCateType: "$selectArticleCateType"\n' +
  '\t\torderBy: "$orderBy"\n' +
  '\t\tarticleRelatedId: "$articleId"\n' +
  '\t\tarticlePageId: "$articlePageId"\n' +
  '\t\t}) {\n' +
  '\t\ttotalRow\n' +
  '\t\tpageSize\n' +
  '\t\tpageNumber\n' +
  '\t\textraData{\n' +
  '\t\tarticleStructureData\n' +
  '\t\t}\n' +
  '\t\tlist{\n' +
  '\t\tencodeId\n' +
  '\t\tarticleTitle\n' +
  '\t\tpublishTime\n' +
  '\t\tarticleUrl\n' +
  '\t\tarticleSummary\n' +
  '\t\ttopFlag\n' +
  '\t\tphotoUrlNormal\n' +
  '\t\tphotoUrlDefine\n' +
  '\t\tcateName\n' +
  '\t\tcateUrl\n' +
  '\t\tshowFieldList\n' +
  '\t\t$showField\n' +
  '\t\tphotoSeoList{\n' +
  '\t\t\tphotoId\n' +
  '\t\t\tphotoUrlNormal\n' +
  '\t\t\tphotoAlt\n' +
  '\t\t\tphotoTitle\n' +
  '\t\t}\n' +
  '\t\t}\n' +
  '\t\t}\n' +
  '\t\t}\']\n' +
  '\t\t<div class="cont">\n' +
  '\t\t\t<div class="Article_Container">\n' +
  '\t\t\t\t<div class="zh articalWrap block-article-container-replace">\n' +
  '\t\t\t\t\t[#if data?? && data.articleList?? && data.articleList.list?? && (data.articleList.list?size > 0)]\n' +
  '\t\t\t\t\t[#list data.articleList.list as article]\n' +
  '\t\t\t\t\t<article class="ArticlePicList_Item">\n' +
  '\t\t\t\t\t\t<div class="imgBtn">\n' +
  '\t\t\t\t\t\t\t<div class="imgBox">\n' +
  '\t\t\t\t\t\t\t\t<div class="img">\n' +
  '\t\t\t\t\t\t\t\t\t<a class="maskT" href="${article.articleUrl!}"></a>\n' +
  '\t\t\t\t\t\t\t\t\t<source media="(min-width: 768px)" data-srcset="${article.photoUrlNormal!}" />\n' +
  '\t\t\t\t\t\t\t\t\t<source media="(max-width: 767px)" data-srcset="${article.photoUrlNormal!}" />\n' +
  '\t\t\t\t\t\t\t\t\t<img class="headlines-content-img ArticlePicList_ItemImg lazyimg" src="${article.photoUrlNormal!}" alt="${article.photoSeoList[0].photoAlt!}" title="${article.photoSeoList[0].photoTitle!}">\n' +
  '\t\t\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t\t\t<div class="butn">\n' +
  '\t\t\t\t\t\t\t\t\t<a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl!}">\n' +
  '\t\t\t\t\t\t\t\t\t\t<span>[@s.m "phoenix_block_news" /]</span>\n' +
  '\t\t\t\t\t\t\t\t\t</a>\n' +
  '\t\t\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t<div class="ArticlePicList_ItemContent">\n' +
  '\t\t\t\t\t\t\t<div class="ArticlePicList_ItemContentInner">\n' +
  '\t\t\t\t\t\t\t\t<div class="ArticlePicList_ItemContentInnerBox">\n' +
  '\t\t\t\t\t\t\t\t\t[#if showDate?? && showDate == \'1\']\n' +
  '\t\t\t\t\t\t\t\t\t<time class="artime paragraph2">${article.publishTime!}</time>\n' +
  '\t\t\t\t\t\t\t\t\t[/#if]\n' +
  '\t\t\t\t\t\t\t\t\t<h3 class="ArticlePicList_ItemContentInnerH5">\n' +
  '\t\t\t\t\t\t\t\t\t\t<a class="heading5" href="${article.articleUrl!}" title="${article.articleTitle!?html}">${article.articleTitle!?html}</a>\n' +
  '\t\t\t\t\t\t\t\t\t</h3>\n' +
  '\t\t\t\t\t\t\t\t\t<div class="articleList-summary ArticlePicList_ItemContentInnerP paragraph2">${article.articleSummary!\'\'}</div>\n' +
  '\t\t\t\t\t\t\t\t\t<div class="butn1">\n' +
  '\t\t\t\t\t\t\t\t\t\t<a class="ArticlePicList_ItemContentInnerA paragraph2" href="${article.articleUrl!}">\n' +
  '\t\t\t\t\t\t\t\t\t\t\t<span>[@s.m "phoenix_block_news" /]</span>\n' +
  '\t\t\t\t\t\t\t\t\t\t</a>\n' +
  '\t\t\t\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t\t</div>\n' +
  '\t\t\t\t\t</article>\n' +
  '\t\t\t\t\t[/#list]\n' +
  '\t\t\t\t\t[#else]\n' +
  '\t\t\t\t\t<div class="templist-no-data">[@s.m "phoenix_no_content" /]</div>\n' +
  '\t\t\t\t\t[/#if]\n' +
  '\t\t\t\t</div>\n' +
  '\t\t\t\t<input type="hidden" name="totalRow" value="${data.articleList.totalRow!\'0\'}">\n' +
  '\t\t\t\t<input type="hidden" name="pageNumber" value="${data.articleList.pageNumber!\'1\'}">\n' +
  '\t\t\t\t<input type="hidden" name="pageSize" value="${data.articleList.pageSize!\'10\'}">\n' +
  '\t\t\t\t[#if (dataType?? && dataType != \'3\') && (!loadMethod?? || loadMethod == \'0\')]\n' +
  '\t\t\t\t<div class="artclelist-site-pagination-34134 [#if data.articleList.pageSize?? && data.articleList.totalRow?? && data.articleList.totalRow <= data.articleList.pageSize]hide[/#if]">\n' +
  '\t\t\t\t\t<div class="artclelist-laypage-normal" id=\'artclelist-laypage-normal\'></div>\n' +
  '\t\t\t\t</div>\n' +
  '\t\t\t\t[/#if]\n' +
  '\t\t\t</div>\n' +
  '\t\t</div>\n' +
  '\t\t<script>\n' +
  '\t\t\t$(function () {\n' +
  '\t\t\t\twindow._block_namespaces_[\'block34134\'].init({ \'relationId\': \'${relationId}\', \'relationType\': \'${relationType}\', \'pageId\': \'${pageId}\', \'nodeId\':\'cyber_${nodeId!""}\', \'appId\': \'${appId!}\', \'appIsDev\': \'${appIsDev!"0"}\', \'appVersion\': \'${appVersion}\' });\n' +
  '\t\t\t});\n' +
  '\t\t</script>\n' +
  '\t\t<script type="application/ld+json">\n' +
  '\t\t\t${data.articleList.extraData.articleStructureData!""}\n' +
  '\t\t</script>\n' +
  '\t\t[/@api]\n' +
  '\t</div>\n' +
  '</div>';

/* ============================= INJECT ALL SECTIONS ============================= */
addSection(html1,  css1,  js1,  1,  GLOBAL_CSS);
addSection(html2,  css2,  '',   2,  GLOBAL_CSS);
addSection(html3,  css3,  '',   3,  GLOBAL_CSS);
addSection(html4,  css4,  js4,  4,  GLOBAL_CSS);
addSection(html5,  css5,  '',   5,  GLOBAL_CSS);
addSection(html6,  css6,  js6,  6,  GLOBAL_CSS);
addDynamicSection(html7, css7, js7, ftl_gallerylist_placeholder, 'phoenix_blocks_galleryList', _s7uuid, '', 7, GLOBAL_CSS);
addSection(html8,  css8,  '',   8,  GLOBAL_CSS);
addSection(html9,  css9,  js9,  9,  GLOBAL_CSS);
addSection(html10, css10, js10, 10, GLOBAL_CSS);
addDynamicSection(html11, css11, js11, ftl_articlelist_34134, 'phoenix_blocks_Articlelist', _s11uuid, 'eRKfUApi34134', 11, GLOBAL_CSS);

console.log('[Clone-Inject] All 11 sections injected (9 static + 2 dynamic: S7=galleryList, S11=Articlelist).');
})();
