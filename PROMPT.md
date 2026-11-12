# Recreate this site as a single HTML file: Coca-Cola (fan concept)

You are an expert creative front-end developer. Produce a **single self-contained `index.html`**
that reproduces the project below **exactly**: same layout, visuals, motion, and interaction.
Pure HTML/CSS/JS in one file: no build step, no framework, no bundler. Use CDN `<script>` tags for
the libraries actually used (GSAP, Google `<model-viewer>` web component). Hardcode every value
given here as a fixed constant. The CSS lives in one `<style>` block in `<head>`; the script in one
`<script>` block before `</body>`.

## What it is

A full-viewport (no-scroll) hero landing page: a **Coca-Cola fan concept** showing three products,
the **Coca-Cola Classic can** (red), the **Coca-Cola Zero Sugar can** (black) and the **glass
contour bottle**. A dark radial gradient fills the screen: deep red for Classic, black with an
ember-red glow for Zero Sugar, warm cola-amber for the bottle. A large 3D product floats in the
centre, rendered with Google's `<model-viewer>`, and **tilts toward the cursor in real time**.
Around it, 3D cherry/leaf models float and drift with parallax and are **repelled by the pointer**
like a force field. Translucent PNG bubbles rise endlessly from the bottom. A glass header sits on
top with a `Coca-Cola` script wordmark. A left column has a giant cursive headline ("Ice Cold"), a
CTA and a badge. A right column has a three-card product carousel and a second headline
("Deliciously Bubbly").

Clicking a product card (or the ← → arrows) triggers a choreographed transition. The background
colour morphs. The product spins 720° with a motion blur and, at the peak of the spin, swaps to the
new model (can ↔ can ↔ bottle). All berry models implode toward the centre, swap their model
(cherries for Classic and the bottle, blueberries for Zero Sugar), then explode back out to new
random positions. Palette: Coca-Cola red `#e41e2b`, white, black, amber; the accent is white with
red text (`#c4111f`).

At the bottom centre, a small glass pill reads **"Created by EMMANUEL OMIRIN"** with a second line
"Fan concept · Not affiliated with The Coca-Cola Company".

## The Coca-Cola can and bottle (generated in the page)

No external model files are used for the products. On load, the script **builds each product as a
real glTF (GLB) model in JavaScript** and hands it to `<model-viewer>` as a `blob:` URL:

- **Lathe geometry:** each product is an `[r, y]` profile in metres (Catmull-Rom smoothed) spun
  around Y. UV `u` wraps the circumference with `u = 0.5` facing the camera; `v` runs top → bottom.
  Normals are computed from the surface (wrapping the seam); pole rows point straight up/down.
- **Can** (12 fl oz proportions: radius 0.033, height 0.1225): a straight label body from
  y 0.012 to 0.103 (material `label`, metallic 0.4, roughness 0.28) plus an aluminium bottom dome and
  necked top with rim and lid (metallic 1, roughness 0.25).
- **Can label texture:** a 2048-px-wide canvas drawn at the body's true aspect ratio. It has a
  vertical edge-to-base gradient, a seamless white wave ribbon (one sine period), a `Coca-Cola`
  wordmark in **Yellowtail** (front, plus a second copy split across the seam for the back), a
  tagline in **Outfit 900** (`ORIGINAL TASTE` / `ZERO SUGAR`) and `12 FL OZ (355 mL)`.
  Classic: red `#e41e2b` with white type and ribbon. Zero Sugar: black `#171717` with a red wordmark
  and ribbon and a white tagline.
- **Contour bottle** (height 0.1944): the fluted glass (12 vertical flutes above and below the label
  panel) uses `KHR_materials_transmission` / `ior` / `volume`; the cola liquid inside is dark brown
  and filled to y 0.183; a painted white `Coca-Cola` script band sits on the belly (alpha-blended
  PNG); and a red crimped crown cap (21 crimps) tops it.
- **Card art:** the three carousel images are drawn on 280×520 canvases from the same labels and
  profiles. The cans get the label wrapped with `asin` cylinder mapping and metal shading; the
  bottle gets its silhouette, cola, flutes, highlights, white script and cap.
- The labels wait for the Yellowtail/Outfit fonts (`document.fonts.load`, 3 s timeout).
- The centre `<model-viewer>` starts at `opacity: 0` and fades in (`0.8s`) on its first `load`.

## Buttons, nav and panels (everything is clickable)

Every nav item and button opens a glass **panel** that slides in from the right and floats just
below the header (`top: 7rem`, `right: 4%`, `440px` wide, rounded `28px`; full width under the
header on phones). A dim backdrop covers the hero; clicking it, the × button or pressing Esc closes
the panel. While a panel is open the header stays above the backdrop, so the nav can switch panels
directly. The active nav pill follows the open panel (Home closes it). The URL hash follows too
(`#flavors`, `#shop` …), and opening the page with one of those hashes opens that panel. Focus moves
into the panel and Tab stays inside it.

- **Flavors:** the three products with their card art, size, blurb, price and a "View in 3D" button
  that closes the panel and switches the 3D product.
- **Taste:** product chips, plus animated 0–5 meters for Sweetness, Fizz, Caramel and Spice. "Best
  served" tips: chilled to 3–4 °C, over ice, with lemon or lime.
- **Eco:** recycling facts (cans, glass bottles, rinse and check local rules), plus an "I recycled
  one" counter saved in `localStorage`.
- **Reviews:** a form with product chips, a 1–5 star picker, an optional name and a review of up to
  280 characters. Reviews are saved in `localStorage` (newest first, max 20) and rendered with
  `textContent`.
- **Shop Now:** a cart with −/+ steppers per product (0–24), a live subtotal, a count badge on the
  Shop Now button (persisted in `localStorage`), and a Checkout button. Checkout only shows "Thanks!
  This is a fan concept, so no real order was placed." It never asks for payment details.
- **Contact Us:** name, email and message with validation (valid email, message ≥ 10 characters).
  If `CONTACT_EMAIL` is set, submitting opens the visitor's email app with a `mailto:` link;
  otherwise it shows a thank-you note saying the demo form isn't connected to an inbox yet.

## Responsive

- **≤ 1200px:** the original tablet rules (smaller headlines, centred right column).
- **≤ 900px (phones and portrait tablets):** the layout stacks.
  - The nav and Contact Us fold into a round **menu button** that opens a dropdown (it gains a
    "Contact Us" item).
  - The headline is `clamp(3.4rem, 15vw, 5.5rem)`; the award badge, side title and carousel
    arrows are hidden.
  - The cards shrink to 104px; the berries scale down to about 55%; the product is `100vw × 56vh`.
  - Height uses `100dvh`; `html` and `.hero` clip overflow so the page never drags sideways.
- Pointer events (`pointermove`) drive the tilt and repulsion, so touch works too.

## Page shell & libraries

In `<head>`:

```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Coca-Cola</title>
<meta name="description" content="A Coca-Cola fan concept: the classic can, Zero Sugar and the glass contour bottle in interactive 3D.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;700;900&family=Inter:wght@400;500&family=Manrope:wght@400;700&family=Galada&family=Yellowtail&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
<script type="module" src="https://unpkg.com/@google/model-viewer@4.4.0/dist/model-viewer.min.js"></script>
```

Fonts: body `'Inter'`; headings `'Galada'` (cursive); nav and credit `'Manrope'`; the Coca-Cola
wordmark (header logo and all labels) `'Yellowtail'`; label taglines `'Outfit'`. The page does
**not** scroll: `body { overflow: hidden; height: 100vh; }`.

## Layout & sections (in order)

1. `#bubbles-container`: fixed, full screen, rising `bubble.png` images.
2. `.header`: bottle-cap SVG + `Coca-Cola` wordmark, a glass pill nav (Home · Flavors · Taste ·
   Eco · Reviews; the active/hover item is white with red text), a dark "Contact Us" button, and a
   menu button that only shows on phones.
3. `main.hero > .hero-content`, in this DOM order:
   - `.leaves-container`: four floating leaf models (far background, `z-index: -1`).
   - `.hero-left`: "Ice / Cold" headline, description, "Shop Now +" button, and a badge reading
     "DESIGN CONCEPT / 3D PRODUCT SHOWCASE 2026" pushed to the bottom.
   - `.berries-container-bg`: three small cherries behind the product.
   - `.hero-center > #product-model`: the generated can/bottle, `80vw × 80vh`, fixed and
     centred, rotated 25°, gently floating ±20px.
   - `.berries-container`: six cherries in the foreground (`z-index: 110`).
   - `.hero-right`: the carousel (Coca-Cola Classic $2.99 · Zero Sugar $2.99 · Glass Bottle $3.49,
     plus ← → arrows) and the "Deliciously / Bubbly" headline.
4. `footer.credit`: "Created by **EMMANUEL OMIRIN**" + the fan-concept disclaimer.
5. `.sheet-layer`: the backdrop plus six panels (flavors, taste, eco, reviews, shop, contact).
6. The hidden `#frosted` SVG filter and a hidden block that preloads the cherry/blueberry models.

## Fixed parameters (bake these in)

- Classic can: `--bg-inner #c4111f`, `--bg-mid #6a0811`, `--bg-outer #160103`; cherries.
- Zero Sugar can: `#58121a`, `#1a0608`, `#020101`; blueberries.
- Glass bottle: `#8a3a12`, `#3b1206`, `#0c0302`; cherries.
- Background morph: `gsap.to(body, { '--bg-*', duration: 1.5, ease: 'power2.inOut' })`.
- Product `<model-viewer>`: `camera-orbit="0deg 90deg 380%"`, `field-of-view="30deg"`,
  `exposure="1.5"`, `environment-image="neutral"`, `camera-controls disable-zoom shadow-intensity="0"`.
- Cursor tilt per frame: `cameraOrbit = (mouse.x*40 + switchSpin)deg (90 + mouse.y*20)deg 380%`,
  mouse smoothing lerp `0.05`.
- Spin: phase 1 → `360°`, blur `15px`, `0.6s power2.in`; swap the model at the peak; phase 2 →
  `720°`, blur `0`, `1.5s back.out(0.7)`.
- Parallax: foreground berries `×60`, background berries `×-30`, leaves `×-15`.
- Berry repulsion: radius `400px`, strength `-80`, lerp `0.1`, spin `0.2 × (1 + force×5)`; float
  `15px` / `6deg` with durations `[5,7,6,8,5.5,6.5,9,11,10]`.
- Berry implode/explode: `0.5s power2.in` to the centre at scale 0.1 / opacity 0, hold `0.3s`, then
  explode to a random `±100px` in `0.9s back.out(1.5)`.
- Bubbles: every `400ms`, `10–30px`, opacity `0.2–0.6`, rising `4–10s`.
- Breakpoint: `max-width: 1200px`.

## Full stylesheet

```css
:root {
    --bg-color: #0a0a0a;
    --text-color: #ffffff;
    --accent-color: #ffffff;
    --accent-ink: #c4111f;
    --muted-color: rgba(255, 255, 255, 0.72);
    --glass-bg: rgba(255, 255, 255, 0.06);
    --glass-border: rgba(255, 255, 255, 0.14);
    --font-main: 'Inter', sans-serif;
    --font-heading: 'Galada', cursive;

    /* Dynamic Background Variables (Classic Cola red) */
    --bg-inner: #c4111f;
    --bg-mid: #6a0811;
    --bg-outer: #160103;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html { overflow: hidden; } /* no sideways drag on phones */

body {
    background: radial-gradient(circle at center, var(--bg-inner) 0%, var(--bg-mid) 50%, var(--bg-outer) 100%);
    color: var(--text-color);
    font-family: var(--font-main);
    overflow: hidden; /* Remove scroll */
    height: 100vh;
    transition: background 1.2s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Zero Sugar: black can, ember-red glow */
body[data-flavor="zero"] {
    --bg-inner: #58121a;
    --bg-mid: #1a0608;
    --bg-outer: #020101;
}

/* Glass bottle: warm cola amber */
body[data-flavor="bottle"] {
    --bg-inner: #8a3a12;
    --bg-mid: #3b1206;
    --bg-outer: #0c0302;
}

/* ---------- Bubbles ---------- */
#bubbles-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 0;
    overflow: hidden;
}

.bubble-img {
    position: absolute;
    pointer-events: none;
}

@keyframes floatUpImg {
    0% {
        transform: translateY(0) translateX(0) rotate(0deg);
        opacity: 0;
    }
    10% { opacity: 0.4; }
    90% { opacity: 0.4; }
    100% {
        transform: translateY(-110vh) translateX(30px) rotate(360deg);
        opacity: 0;
    }
}

/* ---------- Header ---------- */
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem 4%;
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 100;
}

.logo {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-weight: 700;
    font-size: 2.1rem;
    font-family: 'Yellowtail', cursive;
    font-weight: 400;
    line-height: 1;
}

.nav {
    display: flex;
    gap: 0.5rem;
    background: var(--glass-bg);
    padding: 0.4rem;
    border-radius: 100px;
    border: 1px solid var(--glass-border);
}

.nav.glass {
    position: relative;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1), inset 0 0 0 1px rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
}

.nav-item {
    font-family: 'Manrope', sans-serif;
    color: var(--muted-color);
    text-decoration: none;
    font-size: 0.85rem;
    font-weight: 500;
    padding: 0.5rem 1.2rem;
    border-radius: 100px;
    transition: all 0.3s ease;
}

.nav-item:hover,
.nav-item.active {
    background: var(--accent-color);
    color: var(--accent-ink);
}

.contact-btn {
    background: rgba(0, 0, 0, 0.5);
    color: white;
    border: none;
    padding: 0.9rem 2rem;
    border-radius: 100px;
    font-weight: 600;
    font-size: 0.85rem;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: none;
}

.contact-btn:hover {
    background: rgba(0, 0, 0, 0.7);
    transform: translateY(-2px);
    box-shadow: none;
}

/* ---------- Hero ---------- */
.hero {
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 4%;
    padding-top: 5rem;
}

.hero-content {
    display: flex;
    justify-content: space-between;
    align-items: stretch; /* Stretch columns to full height */
    width: 100%;
    max-width: 100%;
    padding: 0;
    height: 100%;
    position: relative;
}

/* Typography */
.main-title,
.side-title {
    font-family: var(--font-heading);
    font-size: clamp(5rem, 10vw, 12rem);
    line-height: 0.8;
    font-weight: 400;
    text-transform: none;
    white-space: nowrap;
    color: white;
    letter-spacing: normal;
}

.outline {
    color: var(--text-color);
}

/* Floating leaves (far background) */
.leaves-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: -1; /* Even further behind */
    transition: transform 0.1s ease-out;
}

.leaf {
    position: absolute;
    width: 60px;
    height: 60px;
    pointer-events: none;
    z-index: -1;
    filter: drop-shadow(0 5px 15px rgba(0, 0, 0, 0.2));
}

.l1 { top: 10%; left: 15%; }
.l2 { top: 40%; left: 80%; width: 140px; height: 140px; opacity: 0.4; }
.l3 { top: 70%; left: 75%; width: 80px; height: 80px; }
.l4 { top: 85%; left: 20%; width: 120px; height: 120px; opacity: 0.3; }

/* Left column */
.hero-left {
    display: flex;
    flex-direction: column;
    height: 100%;
    padding: 6rem 0;
    gap: 2rem;
    z-index: 100;
}

@keyframes fadeInEntry {
    to { opacity: 1; transform: none; }
}

.description {
    color: var(--muted-color);
    font-size: 1.1rem;
    line-height: 1.6;
    max-width: 400px;
}

.primary-btn {
    display: flex;
    align-items: center;
    gap: 1.5rem;
    background: rgba(0, 0, 0, 0.5);
    color: white;
    border: none;
    padding: 0.4rem 0.4rem 0.4rem 1.5rem;
    border-radius: 100px;
    font-weight: 700;
    cursor: pointer;
    width: fit-content;
    transition: all 0.3s ease;
    box-shadow: none;
    position: relative;
}

.primary-btn:hover {
    background: rgba(0, 0, 0, 0.7);
    transform: translateY(-3px);
    box-shadow: none;
}

.plus-icon {
    background: var(--accent-color);
    color: var(--accent-ink);
    width: 38px;
    height: 38px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    font-size: 1.4rem;
    font-weight: 900;
    line-height: 1;
    padding-bottom: 2px; /* Compensate for baseline shift */
    border: none;
}

.award-badge {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-top: auto; /* Push to bottom */
}

.award-icon {
    width: 48px;
    height: 48px;
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.award-text { display: flex; flex-direction: column; }
.award-title { font-size: 0.7rem; letter-spacing: 0.1em; color: var(--muted-color); }
.award-subtitle { font-size: 0.85rem; font-weight: 600; }

/* Center product (the 3D can) */
.hero-center {
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    opacity: 0;
    animation: fadeIn 1.5s ease-out 0.3s forwards, float 6s ease-in-out infinite;
    pointer-events: none;
    background: radial-gradient(circle at center, rgba(255, 255, 255, 0.08) 0%, transparent 70%);
}

@keyframes fadeIn { to { opacity: 1; } }

@keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-20px); }
}

.main-product-3d {
    width: 80vw;
    height: 80vh;
    outline: none;
    --progress-bar-color: transparent;
    --poster-color: transparent;
    z-index: 1;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(25deg);
    pointer-events: none;
    /* Fades in once the generated can has loaded */
    opacity: 0;
    transition: opacity 0.8s ease;
}

.main-product-3d.is-ready { opacity: 1; }

.main-product-3d[camera-controls] { pointer-events: auto; }

/* Berries */
.berries-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 110; /* Above text (100) and can (50) */
    transition: transform 0.1s ease-out;
}

.berries-container-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 0; /* Behind everything */
    transition: transform 0.1s ease-out;
}

.berry {
    position: absolute;
    width: 120px;
    height: 120px;
    outline: none;
    --progress-bar-color: transparent;
    filter: drop-shadow(0 10px 20px rgba(0, 0, 0, 0.3));
    transition: transform 0.8s cubic-bezier(0.2, 0.8, 0.2, 1);
}

.berry.no-animation { animation: none !important; }

.b1 { top: 25%; left: 30%; width: 220px; height: 220px; }
.b2 { top: 60%; left: 42%; width: 100px; height: 100px; }
.b3 { top: 30%; left: 62%; width: 250px; height: 250px; }
.b4 { top: 15%; left: 48%; width: 140px; height: 140px; }
.b5 { top: 75%; left: 20%; width: 120px; height: 120px; }
.b6 { top: 45%; left: 75%; width: 180px; height: 180px; }
.b7 { top: 15%; left: 40%; width: 80px; height: 80px; opacity: 0.7; }
.b8 { top: 50%; left: 55%; width: 70px; height: 70px; opacity: 0.6; }
.b9 { top: 80%; left: 35%; width: 75px; height: 75px; opacity: 0.7; }

/* Right column */
.hero-right {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: flex-end;
    text-align: right;
    height: 100%;
    padding: 6rem 0;
    z-index: 100;
    width: 450px;
    pointer-events: none;
}

@keyframes fadeInLeft {
    to { opacity: 1; transform: translateX(0); }
}

.product-carousel {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
    align-items: flex-end;
    pointer-events: auto; /* Enable interaction */
}

.carousel-cards { display: flex; gap: 1rem; }

.card {
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    padding: 1rem;
    padding-top: 5rem;
    border-radius: 28px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    width: 135px;
    position: relative;
    backdrop-filter: blur(10px);
    text-align: center;
}

.card:hover {
    background: rgba(255, 255, 255, 0.12);
    border-color: rgba(255, 255, 255, 0.4);
}

.card.active {
    border-color: var(--accent-color);
    border-width: 1px;
    background: var(--glass-bg);
    box-shadow: none;
}

.card img {
    width: 140px;
    height: auto;
    margin-top: -8rem;
    filter: drop-shadow(0 20px 35px rgba(0, 0, 0, 0.5));
    transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1), opacity 0.4s ease !important;
    display: block;
    will-change: transform;
    pointer-events: none; /* Mouse passes through image to trigger card hover */
    opacity: 0; /* Revealed once the card art is drawn */
}

.card img.is-ready { opacity: 1; }

.card:hover img {
    transform: translateY(-30px) rotate(-12deg) scale(1.15) !important;
}

.card-info {
    display: flex;
    flex-direction: column;
    font-size: 0.7rem;
    width: 100%;
    word-wrap: break-word;
}

.card-info span:first-child { font-weight: 600; }
.card-info span:last-child { color: var(--muted-color); }

.carousel-nav { display: flex; gap: 1rem; }

.nav-arrow {
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    color: white;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.3s;
}

.nav-arrow:hover { background: rgba(255, 255, 255, 0.1); }

.side-title { align-self: flex-end; text-align: right; }

/* ---------- Panels (nav sections, shop, contact) ---------- */
.sheet-layer {
    position: fixed;
    inset: 0;
    z-index: 300;
    pointer-events: none;
}

.sheet-layer.open { pointer-events: auto; }

.sheet-backdrop {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.4);
    opacity: 0;
    transition: opacity 0.4s ease;
}

.sheet-layer.open .sheet-backdrop { opacity: 1; }

/* While a panel is open the header stays above the backdrop, so the
   nav can switch panels; the panel floats just below the header. */
body.sheet-open .header { z-index: 310; }
.header.menu-open { z-index: 320; }

.sheet {
    position: absolute;
    top: 7rem;
    right: 4%;
    height: calc(100% - 8.5rem);
    width: min(440px, 92vw);
    border-radius: 28px;
    display: flex;
    flex-direction: column;
    gap: 1.25rem;
    padding: 2rem 2rem 2.5rem;
    overflow-y: auto;
    overscroll-behavior: contain;
    background: rgba(16, 4, 6, 0.8);
    border: 1px solid var(--glass-border);
    backdrop-filter: blur(24px) saturate(1.3);
    -webkit-backdrop-filter: blur(24px) saturate(1.3);
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.45);
    transform: translateX(calc(100% + 8vw));
    visibility: hidden;
    transition: transform 0.55s cubic-bezier(0.2, 0.8, 0.2, 1), visibility 0s linear 0.55s;
}

.sheet.open {
    transform: none;
    visibility: visible;
    transition: transform 0.55s cubic-bezier(0.2, 0.8, 0.2, 1), visibility 0s;
}

.sheet-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 1rem;
}

.sheet-kicker {
    font-family: 'Manrope', sans-serif;
    font-size: 0.72rem;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--muted-color);
}

.sheet h2 {
    font-family: var(--font-heading);
    font-weight: 400;
    font-size: 3rem;
    line-height: 1;
    margin-top: 0.35rem;
}

.sheet h3 {
    font-family: 'Manrope', sans-serif;
    font-size: 0.78rem;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--muted-color);
    margin-top: 0.5rem;
}

.sheet-lede { color: var(--muted-color); line-height: 1.6; font-size: 0.95rem; }

.sheet-close {
    flex: none;
    width: 42px;
    height: 42px;
    border-radius: 50%;
    border: 1px solid var(--glass-border);
    background: var(--glass-bg);
    color: white;
    font-size: 1.4rem;
    line-height: 1;
    cursor: pointer;
    transition: background 0.3s;
}

.sheet-close:hover { background: rgba(255, 255, 255, 0.14); }

.product-list { display: flex; flex-direction: column; gap: 0.75rem; }

.product-row {
    display: grid;
    grid-template-columns: 56px minmax(0, 1fr) auto;
    align-items: center;
    gap: 1rem;
    padding: 0.75rem 1rem 0.75rem 0.75rem;
    border-radius: 20px;
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
}

.product-row img {
    width: 56px;
    height: 104px;
    object-fit: contain;
    filter: drop-shadow(0 8px 12px rgba(0, 0, 0, 0.4));
}

.product-row h4 { font-size: 0.95rem; font-weight: 600; }
.product-row p { font-size: 0.8rem; color: var(--muted-color); line-height: 1.45; margin-top: 0.2rem; }
.product-row .price { display: block; font-weight: 600; font-size: 0.9rem; margin-top: 0.35rem; }

.pill-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    border: none;
    border-radius: 100px;
    padding: 0.85rem 1.5rem;
    font: 700 0.85rem var(--font-main);
    background: var(--accent-color);
    color: var(--accent-ink);
    cursor: pointer;
    transition: transform 0.2s ease, opacity 0.2s ease;
}

.pill-btn:hover { transform: translateY(-2px); }
.pill-btn:disabled { opacity: 0.45; cursor: not-allowed; transform: none; }
.pill-btn.ghost { background: var(--glass-bg); color: white; border: 1px solid var(--glass-border); }
.pill-btn.small { padding: 0.55rem 1rem; font-size: 0.75rem; white-space: nowrap; }

.stepper { display: flex; align-items: center; gap: 0.4rem; }

.stepper button {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid var(--glass-border);
    background: var(--glass-bg);
    color: white;
    font-size: 1.1rem;
    cursor: pointer;
}

.stepper button:hover { background: rgba(255, 255, 255, 0.14); }
.stepper output { min-width: 1.5rem; text-align: center; font-weight: 600; }

.cart-summary {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    padding-top: 1rem;
    border-top: 1px solid var(--glass-border);
}

.cart-summary strong { font-size: 1.4rem; }

.form-status { font-size: 0.85rem; color: var(--muted-color); min-height: 1.2em; line-height: 1.5; }
.form-status.ok { color: #c8f7d4; }
.form-status.error { color: #ffc2c2; }

.chip-row { display: flex; flex-wrap: wrap; gap: 0.5rem; }

.chip {
    padding: 0.5rem 1rem;
    border-radius: 100px;
    border: 1px solid var(--glass-border);
    background: var(--glass-bg);
    color: var(--muted-color);
    font: 500 0.8rem 'Manrope', sans-serif;
    cursor: pointer;
    transition: background 0.2s, color 0.2s;
}

.chip[aria-checked="true"] { background: var(--accent-color); color: var(--accent-ink); border-color: var(--accent-color); }

.meters { display: flex; flex-direction: column; gap: 1rem; }
.meter { display: grid; gap: 0.45rem; }
.meter-label { display: flex; justify-content: space-between; font-size: 0.85rem; }
.meter-track { height: 8px; border-radius: 8px; background: rgba(255, 255, 255, 0.1); overflow: hidden; }

.meter-fill {
    width: 0;
    height: 100%;
    border-radius: inherit;
    background: linear-gradient(90deg, #ffffff, #ffd0d4);
    transition: width 0.7s cubic-bezier(0.2, 0.8, 0.2, 1);
}

.tips, .eco-list { list-style: none; display: flex; flex-direction: column; gap: 0.75rem; }

.tips li, .eco-list li {
    padding: 0.9rem 1rem;
    border-radius: 16px;
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    font-size: 0.9rem;
    line-height: 1.5;
    color: var(--muted-color);
}

.eco-list strong { display: block; color: white; margin-bottom: 0.2rem; }

.eco-counter {
    display: grid;
    gap: 0.75rem;
    justify-items: start;
    padding: 1.25rem;
    border-radius: 20px;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid var(--glass-border);
}

.eco-counter .count { display: inline-block; font-family: var(--font-heading); font-size: 3rem; line-height: 1; }

.sheet form { display: flex; flex-direction: column; gap: 1rem; }
.field { display: grid; gap: 0.4rem; font-size: 0.8rem; color: var(--muted-color); }

.field input,
.field textarea {
    width: 100%;
    padding: 0.85rem 1rem;
    border-radius: 14px;
    border: 1px solid var(--glass-border);
    background: rgba(255, 255, 255, 0.06);
    color: white;
    font: 400 0.95rem var(--font-main);
    resize: vertical;
}

.field input:focus,
.field textarea:focus { outline: none; border-color: rgba(255, 255, 255, 0.6); background: rgba(255, 255, 255, 0.1); }

.stars { display: flex; gap: 0.25rem; }

.star {
    background: none;
    border: none;
    padding: 0 0.1rem;
    font-size: 1.8rem;
    line-height: 1;
    color: rgba(255, 255, 255, 0.25);
    cursor: pointer;
    transition: transform 0.15s, color 0.2s;
}

.star.on { color: #ffcc4d; }
.star:hover { transform: scale(1.15); }

.review-list { display: flex; flex-direction: column; gap: 0.75rem; }
.review { padding: 1rem; border-radius: 16px; background: var(--glass-bg); border: 1px solid var(--glass-border); }
.review-top { display: flex; justify-content: space-between; gap: 0.5rem; font-size: 0.8rem; color: var(--muted-color); }
.review-stars { color: #ffcc4d; letter-spacing: 0.1em; }
.review p { margin-top: 0.5rem; font-size: 0.9rem; line-height: 1.5; }
.empty { font-size: 0.85rem; color: var(--muted-color); }
.fine { font-size: 0.72rem; color: var(--muted-color); opacity: 0.85; }

.cart-badge {
    position: absolute;
    top: -6px;
    right: -6px;
    min-width: 20px;
    height: 20px;
    padding: 0 6px;
    border-radius: 10px;
    background: #ffffff;
    color: var(--accent-ink);
    font-size: 0.7rem;
    font-weight: 800;
    display: grid;
    place-items: center;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.cart-badge[hidden] { display: none; }

/* Phone menu button (hidden on desktop) */
.menu-btn {
    display: none;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    border: 1px solid var(--glass-border);
    background: rgba(0, 0, 0, 0.35);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    color: white;
    cursor: pointer;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 5px;
}

.menu-btn span { width: 18px; height: 2px; border-radius: 2px; background: currentColor; transition: transform 0.3s, opacity 0.3s; }
.header.menu-open .menu-btn span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.header.menu-open .menu-btn span:nth-child(2) { opacity: 0; }
.header.menu-open .menu-btn span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
.nav-contact { display: none; }

button:focus-visible,
a:focus-visible,
.card:focus-visible { outline: 2px solid #ffffff; outline-offset: 3px; }

/* ---------- Credit ---------- */
.credit {
    position: fixed;
    left: 50%;
    bottom: 1.25rem;
    transform: translateX(-50%);
    z-index: 200;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.2rem;
    padding: 0.55rem 1.4rem;
    border-radius: 18px;
    background: rgba(0, 0, 0, 0.35);
    border: 1px solid var(--glass-border);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    font-family: 'Manrope', sans-serif;
    font-size: 0.72rem;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    white-space: nowrap;
    color: var(--muted-color);
}

.credit strong {
    color: var(--text-color);
    font-weight: 700;
}

.credit small {
    font-size: 0.58rem;
    letter-spacing: 0.04em;
    text-transform: none;
    opacity: 0.75;
}

@keyframes shine {
    from { transform: translateX(-100%) rotate(45deg); }
    to { transform: translateX(200%) rotate(45deg); }
}

/* ---------- Responsive ---------- */
@media (max-width: 1200px) {
    .main-product-3d { width: 100vw; height: 60vh; top: 40%; }
}

@media (max-width: 1200px) {
    .hero-content { grid-template-columns: 1fr; padding-top: 8rem; }
    .hero-center { order: -1; }
    .main-title, .side-title { font-size: 5rem; }
    .hero-right { align-items: center; text-align: center; }
    .side-title { align-self: center; text-align: center; }
}

/* Tablets in portrait and phones: stacked layout + menu button */
@media (max-width: 900px) {
    body, .hero { height: 100vh; height: 100dvh; }

    .header { padding: 1rem 16px; }
    .logo { font-size: 1.7rem; }
    .logo svg { width: 26px; height: 26px; }
    .contact-btn { display: none; }
    .menu-btn { display: flex; }

    .nav.glass {
        display: none;
        position: absolute;
        top: calc(100% - 0.25rem);
        right: 16px;
        flex-direction: column;
        min-width: 210px;
        padding: 0.5rem;
        border-radius: 22px;
        background: rgba(20, 5, 7, 0.82);
    }

    .header.menu-open .nav.glass { display: flex; }
    .nav-item { padding: 0.8rem 1.1rem; font-size: 0.95rem; }
    .nav-contact { display: block; }

    .hero { padding: 4.75rem 16px 0; overflow: hidden; }
    .hero-content { flex-direction: column; justify-content: space-between; padding-top: 0; }
    .hero-left { height: auto; padding: 1rem 0 0; gap: 1rem; }
    .main-title { font-size: clamp(3.4rem, 15vw, 5.5rem); }
    .description { font-size: 0.95rem; max-width: 30ch; }
    .description br { display: none; }
    .award-badge { display: none; }

    .hero-right { width: 100%; height: auto; padding: 0 0 5.5rem; align-items: center; }
    .side-title { display: none; }
    .product-carousel { width: 100%; align-items: center; }
    .carousel-nav { display: none; }
    .carousel-cards { gap: 0.6rem; }
    .card { width: 104px; padding: 0.75rem; padding-top: 3.5rem; gap: 0.9rem; border-radius: 22px; }
    .card img { width: 96px; margin-top: -5.5rem; }
    .card-info { font-size: 0.66rem; }

    .main-product-3d { width: 100vw; height: 56vh; top: 47%; }

    .b1 { width: 120px; height: 120px; }
    .b2 { width: 60px; height: 60px; }
    .b3 { width: 130px; height: 130px; }
    .b4 { width: 80px; height: 80px; }
    .b5 { width: 70px; height: 70px; }
    .b6 { width: 100px; height: 100px; }
    .b7 { width: 50px; height: 50px; }
    .b8 { width: 44px; height: 44px; }
    .b9 { width: 46px; height: 46px; }

    .sheet {
        top: 4.75rem;
        left: 8px;
        right: 8px;
        width: auto;
        height: calc(100% - 5.25rem);
        border-radius: 24px;
        padding: 1.5rem 16px 2rem;
    }
    .sheet h2 { font-size: 2.5rem; }
}

@media (max-width: 600px) {
    .credit { font-size: 0.62rem; letter-spacing: 0.12em; bottom: 0.75rem; }
    .credit small { font-size: 0.5rem; }
}

@media (prefers-reduced-motion: reduce) {
    .sheet, .sheet-backdrop, .meter-fill { transition-duration: 0s !important; }
}
```

## Full body markup

```html
<div id="bubbles-container"></div>

<header class="header">
    <div class="logo">
        <!-- Bottle cap -->
        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12.00 1.00 L13.43 2.51 L15.24 1.49 L16.17 3.35 L18.20 2.91 L18.53 4.96 L20.60 5.14 L20.31 7.20 L22.24 7.98 L21.36 9.86 L22.97 11.18 L21.57 12.72 L22.72 14.45 L20.94 15.51 L21.53 17.50 L19.51 17.99 L19.48 20.06 L17.41 19.93 L16.77 21.91 L14.83 21.17 L13.64 22.88 L12.00 21.60 L10.36 22.88 L9.17 21.17 L7.23 21.91 L6.59 19.93 L4.52 20.06 L4.49 17.99 L2.47 17.50 L3.06 15.51 L1.28 14.45 L2.43 12.72 L1.03 11.18 L2.64 9.86 L1.76 7.98 L3.69 7.20 L3.40 5.14 L5.47 4.96 L5.80 2.91 L7.83 3.35 L8.76 1.49 L10.57 2.51Z" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round" />
            <circle cx="12" cy="12" r="5.5" stroke="currentColor" stroke-width="1.6" />
        </svg>
        <span>Coca-Cola</span>
    </div>
    <nav class="nav glass" id="site-nav" aria-label="Main">
        <a href="#" class="nav-item active" data-open="home">Home</a>
        <a href="#flavors" class="nav-item" data-open="flavors">Flavors</a>
        <a href="#taste" class="nav-item" data-open="taste">Taste</a>
        <a href="#eco" class="nav-item" data-open="eco">Eco</a>
        <a href="#reviews" class="nav-item" data-open="reviews">Reviews</a>
        <a href="#contact" class="nav-item nav-contact" data-open="contact">Contact Us</a>
    </nav>
    <button class="contact-btn" data-open="contact">Contact Us</button>
    <button class="menu-btn" type="button" aria-label="Open menu" aria-expanded="false" aria-controls="site-nav">
        <span></span><span></span><span></span>
    </button>
</header>

<main class="hero">
    <div class="hero-content">
        <!-- Floating leaves (far background) -->
        <div class="leaves-container">
            <model-viewer class="leaf l1" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/leaves.glb" environment-image="neutral" exposure="1.0" interaction-prompt="none" camera-orbit="45deg 75deg 105%"></model-viewer>
            <model-viewer class="leaf l2" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/leaves.glb" environment-image="neutral" exposure="1.0" interaction-prompt="none" camera-orbit="-30deg 60deg 105%"></model-viewer>
            <model-viewer class="leaf l3" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/leaves.glb" environment-image="neutral" exposure="1.0" interaction-prompt="none" camera-orbit="120deg 85deg 105%"></model-viewer>
            <model-viewer class="leaf l4" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/leaves.glb" environment-image="neutral" exposure="1.0" interaction-prompt="none" camera-orbit="10deg 45deg 105%"></model-viewer>
        </div>

        <!-- Left column -->
        <div class="hero-left">
            <h1 class="main-title large-animation-1">
                <span class="outline">Ice</span><br>
                Cold
            </h1>
            <p class="description">
                Unleash the bold taste of Coca-Cola. <br>
                Caramel warmth &amp; crisp fizz in every sip — <br>
                best served ice-cold.
            </p>
            <div class="cta-group">
                <button class="primary-btn" data-open="shop">
                    Shop Now
                    <span class="plus-icon">+</span>
                    <span class="cart-badge" hidden>0</span>
                </button>
            </div>
            <div class="award-badge">
                <div class="award-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 15L15 18L19 14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                        <path d="M7 10L12 15L17 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                    </svg>
                </div>
                <div class="award-text">
                    <span class="award-title">DESIGN CONCEPT</span>
                    <span class="award-subtitle">3D PRODUCT SHOWCASE 2026</span>
                </div>
            </div>
        </div>

        <!-- Background berries (behind the can) -->
        <div class="berries-container-bg">
            <model-viewer class="berry b7" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.0" interaction-prompt="none" camera-orbit="-20deg 110deg 105%"></model-viewer>
            <model-viewer class="berry b8" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.0" interaction-prompt="none" camera-orbit="160deg 45deg 105%"></model-viewer>
            <model-viewer class="berry b9" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.0" interaction-prompt="none" camera-orbit="45deg 20deg 105%"></model-viewer>
        </div>

        <!-- Center product (the 3D can) -->
        <div class="hero-center">
            <!-- src is set from script: the can and bottle are generated at load -->
            <model-viewer id="product-model" alt="Coca-Cola 3D can" camera-controls
                disable-zoom shadow-intensity="0" environment-image="neutral" exposure="1.5"
                interaction-prompt="none" camera-orbit="0deg 90deg 380%" field-of-view="30deg"
                class="main-product-3d">
            </model-viewer>
        </div>

        <!-- Foreground berries (above text and can) -->
        <div class="berries-container">
            <model-viewer class="berry b1" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.2" interaction-prompt="none" camera-orbit="45deg 120deg 105%"></model-viewer>
            <model-viewer class="berry b2" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.2" interaction-prompt="none" camera-orbit="-120deg 45deg 105%"></model-viewer>
            <model-viewer class="berry b3" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.2" interaction-prompt="none" camera-orbit="200deg 90deg 105%"></model-viewer>
            <model-viewer class="berry b4" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.2" interaction-prompt="none" camera-orbit="10deg 20deg 105%"></model-viewer>
            <model-viewer class="berry b5" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.2" interaction-prompt="none" camera-orbit="-45deg 160deg 105%"></model-viewer>
            <model-viewer class="berry b6" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb" environment-image="neutral" exposure="1.2" interaction-prompt="none" camera-orbit="80deg 75deg 105%"></model-viewer>
        </div>

        <!-- Right column: flavor carousel + side title -->
        <div class="hero-right">
            <div class="product-carousel">
                <div class="carousel-cards">
                    <div class="card active" data-flavor="classic">
                        <img alt="Coca-Cola Classic can">
                        <div class="card-info">
                            <span>Coca-Cola Classic</span>
                            <span>$2.99</span>
                        </div>
                    </div>
                    <div class="card" data-flavor="zero">
                        <img alt="Coca-Cola Zero Sugar can">
                        <div class="card-info">
                            <span>Zero Sugar</span>
                            <span>$2.99</span>
                        </div>
                    </div>
                    <div class="card" data-flavor="bottle">
                        <img alt="Coca-Cola glass contour bottle">
                        <div class="card-info">
                            <span>Glass Bottle</span>
                            <span>$3.49</span>
                        </div>
                    </div>
                </div>
                <div class="carousel-nav">
                    <button class="nav-arrow" aria-label="Previous flavor">←</button>
                    <button class="nav-arrow" aria-label="Next flavor">→</button>
                </div>
            </div>
            <h2 class="side-title large-animation-1">
                <span class="outline">Deliciously</span><br>
                Bubbly
            </h2>
        </div>
    </div>
</main>

<footer class="credit">
    <span>Created by <strong>EMMANUEL OMIRIN</strong></span>
    <small>Fan concept · Not affiliated with The Coca-Cola Company</small>
</footer>

<!-- Slide-in panels opened from the nav, Shop Now and Contact Us -->
<div class="sheet-layer">
    <div class="sheet-backdrop" data-close></div>

    <section class="sheet" data-sheet="flavors" role="dialog" aria-modal="true" aria-labelledby="flavors-title" aria-hidden="true">
        <div class="sheet-head">
            <div>
                <p class="sheet-kicker">The lineup</p>
                <h2 id="flavors-title">Flavors</h2>
            </div>
            <button class="sheet-close" type="button" data-close aria-label="Close">×</button>
        </div>
        <p class="sheet-lede">Three ways to enjoy it. Pick one to see it in 3D.</p>
        <div class="product-list" data-list="flavors"></div>
    </section>

    <section class="sheet" data-sheet="taste" role="dialog" aria-modal="true" aria-labelledby="taste-title" aria-hidden="true">
        <div class="sheet-head">
            <div>
                <p class="sheet-kicker">Taste</p>
                <h2 id="taste-title">Tasting notes</h2>
            </div>
            <button class="sheet-close" type="button" data-close aria-label="Close">×</button>
        </div>
        <div class="chip-row" data-chips="taste" aria-label="Product"></div>
        <div class="meters" data-meters></div>
        <h3>Best served</h3>
        <ul class="tips">
            <li>Chilled to 3–4 °C, straight from the fridge</li>
            <li>Poured over ice in a tall glass</li>
            <li>With a slice of lemon or lime</li>
        </ul>
        <p class="fine">Fan tasting notes, scored out of 5.</p>
    </section>

    <section class="sheet" data-sheet="eco" role="dialog" aria-modal="true" aria-labelledby="eco-title" aria-hidden="true">
        <div class="sheet-head">
            <div>
                <p class="sheet-kicker">Eco</p>
                <h2 id="eco-title">Rinse &amp; recycle</h2>
            </div>
            <button class="sheet-close" type="button" data-close aria-label="Close">×</button>
        </div>
        <ul class="eco-list">
            <li><strong>Cans</strong>Aluminium can be recycled again and again without losing quality.</li>
            <li><strong>Glass bottles</strong>Glass can be refilled, or melted down into new bottles.</li>
            <li><strong>Before you bin it</strong>Empty and rinse it, then check your local recycling rules.</li>
        </ul>
        <div class="eco-counter">
            <span class="sheet-kicker">Your tally</span>
            <span><span class="count" data-recycled>0</span> cans &amp; bottles recycled</span>
            <button class="pill-btn small" type="button" data-recycle>I recycled one</button>
            <span class="fine">Saved in this browser only.</span>
        </div>
    </section>

    <section class="sheet" data-sheet="reviews" role="dialog" aria-modal="true" aria-labelledby="reviews-title" aria-hidden="true">
        <div class="sheet-head">
            <div>
                <p class="sheet-kicker">Reviews</p>
                <h2 id="reviews-title">Rate it</h2>
            </div>
            <button class="sheet-close" type="button" data-close aria-label="Close">×</button>
        </div>
        <form class="review-form" novalidate>
            <div class="chip-row" data-chips="review" aria-label="Product"></div>
            <div class="stars" role="radiogroup" aria-label="Rating">
                <button class="star" type="button" role="radio" aria-checked="false" data-value="1" aria-label="1 star">★</button>
                <button class="star" type="button" role="radio" aria-checked="false" data-value="2" aria-label="2 stars">★</button>
                <button class="star" type="button" role="radio" aria-checked="false" data-value="3" aria-label="3 stars">★</button>
                <button class="star" type="button" role="radio" aria-checked="false" data-value="4" aria-label="4 stars">★</button>
                <button class="star" type="button" role="radio" aria-checked="false" data-value="5" aria-label="5 stars">★</button>
            </div>
            <label class="field">Your name (optional)
                <input name="name" maxlength="40" autocomplete="nickname">
            </label>
            <label class="field">Your review
                <textarea name="text" rows="3" maxlength="280" placeholder="What did you think?"></textarea>
            </label>
            <button class="pill-btn" type="submit">Post review</button>
            <p class="form-status" role="status"></p>
        </form>
        <h3>Your reviews</h3>
        <div class="review-list" data-reviews></div>
        <p class="fine">Reviews are saved in this browser only.</p>
    </section>

    <section class="sheet" data-sheet="shop" role="dialog" aria-modal="true" aria-labelledby="shop-title" aria-hidden="true">
        <div class="sheet-head">
            <div>
                <p class="sheet-kicker">Shop</p>
                <h2 id="shop-title">Your order</h2>
            </div>
            <button class="sheet-close" type="button" data-close aria-label="Close">×</button>
        </div>
        <div class="product-list" data-list="shop"></div>
        <div class="cart-summary">
            <span>Subtotal</span>
            <strong data-subtotal>$0.00</strong>
        </div>
        <button class="pill-btn" type="button" data-checkout disabled>Checkout</button>
        <p class="form-status" role="status" data-shop-status></p>
    </section>

    <section class="sheet" data-sheet="contact" role="dialog" aria-modal="true" aria-labelledby="contact-title" aria-hidden="true">
        <div class="sheet-head">
            <div>
                <p class="sheet-kicker">Contact</p>
                <h2 id="contact-title">Say hello</h2>
            </div>
            <button class="sheet-close" type="button" data-close aria-label="Close">×</button>
        </div>
        <p class="sheet-lede">Questions, feedback or a project idea? Send a message.</p>
        <form class="contact-form" novalidate>
            <label class="field">Name
                <input name="name" autocomplete="name" required>
            </label>
            <label class="field">Email
                <input name="email" type="email" autocomplete="email" required>
            </label>
            <label class="field">Message
                <textarea name="message" rows="5" required></textarea>
            </label>
            <button class="pill-btn" type="submit">Send message</button>
            <p class="form-status" role="status"></p>
        </form>
    </section>
</div>

<svg style="position: absolute; width: 0; height: 0; opacity: 0; pointer-events: none;">
    <filter id="frosted">
        <feTurbulence type="fractalNoise" baseFrequency="0.0125" numOctaves="3" result="noise" />
        <feDisplacementMap in="SourceGraphic" in2="noise" scale="80" xChannelSelector="R" yChannelSelector="G" />
    </filter>
</svg>
<div style="display: none;">
    <!-- Preload berry models to avoid lag during switch -->
    <model-viewer loading="eager" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/blueberry.glb"></model-viewer>
    <model-viewer loading="eager" src="https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d/cherry.glb"></model-viewer>
</div>
```

## Full script (copy verbatim)

```js
const ASSET_BASE_URL = 'https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d';
const ASSETS = {
    cherry: `${ASSET_BASE_URL}/cherry.glb`,
    blueberry: `${ASSET_BASE_URL}/blueberry.glb`,
    bubble: `${ASSET_BASE_URL}/bubble.png`
};

// The three products. Cans and the contour bottle are generated below
// as real glTF models (lathe geometry + canvas-drawn labels).
const PRODUCTS = {
    classic: {
        kind: 'can',
        name: 'Coca-Cola Classic', size: '355 mL can', price: 2.99,
        blurb: 'The original: crisp fizz with warm caramel and a hint of spice.',
        notes: { Sweetness: 5, Fizz: 4, Caramel: 4, Spice: 3 },
        bg: { inner: '#c4111f', mid: '#6a0811', outer: '#160103' },
        berry: ASSETS.cherry,
        label: { base: '#e41e2b', edge: '#a50d18', word: '#ffffff', ribbon: '#ffffff', tagline: 'ORIGINAL TASTE', taglineColor: '#ffffff', taglineSize: 0.07 }
    },
    zero: {
        kind: 'can',
        name: 'Zero Sugar', size: '355 mL can', price: 2.99,
        blurb: 'The classic cola taste with zero sugar.',
        notes: { Sweetness: 3, Fizz: 4, Caramel: 3, Spice: 3 },
        bg: { inner: '#58121a', mid: '#1a0608', outer: '#020101' },
        berry: ASSETS.blueberry,
        label: { base: '#171717', edge: '#050505', word: '#e41e2b', ribbon: '#e41e2b', tagline: 'ZERO SUGAR', taglineColor: '#ffffff', taglineSize: 0.1 }
    },
    bottle: {
        kind: 'bottle',
        name: 'Glass Bottle', size: '237 mL contour bottle', price: 3.49,
        blurb: 'The original in the glass contour bottle, poured ice-cold.',
        notes: { Sweetness: 5, Fizz: 5, Caramel: 4, Spice: 3 },
        bg: { inner: '#8a3a12', mid: '#3b1206', outer: '#0c0302' },
        berry: ASSETS.cherry
    }
};

const modelViewer = document.querySelector('#product-model');
const berriesFG = document.querySelector('.berries-container');
const berriesBG = document.querySelector('.berries-container-bg');
const leavesBG = document.querySelector('.leaves-container');
const allBerries = document.querySelectorAll('.berry');
const cards = document.querySelectorAll('.card');
let isSwitching = false;
let switchSpin = 0;
let currentFlavor = 'classic';

// ---------- Geometry helpers ----------
const TAU = Math.PI * 2;
const smoothstep = (a, b, x) => {
    const t = Math.min(Math.max((x - a) / (b - a), 0), 1);
    return t * t * (3 - 2 * t);
};

// Catmull-Rom resample of an [r, y] profile so lathed surfaces are smooth
function smoothProfile(points, steps = 6) {
    const out = [];
    const last = points.length - 1;
    for (let k = 0; k < last; k++) {
        const p0 = points[Math.max(k - 1, 0)], p1 = points[k], p2 = points[k + 1], p3 = points[Math.min(k + 2, last)];
        for (let s = 0; s < steps; s++) {
            const t = s / steps, t2 = t * t, t3 = t2 * t;
            const pt = [0, 1].map(c => 0.5 * ((2 * p1[c]) + (-p0[c] + p2[c]) * t +
                (2 * p0[c] - 5 * p1[c] + 4 * p2[c] - p3[c]) * t2 + (-p0[c] + 3 * p1[c] - 3 * p2[c] + p3[c]) * t3));
            pt[0] = Math.max(pt[0], 0);
            out.push(pt);
        }
    }
    out.push(points[last]);
    return out;
}

// Spin an [r, y] profile around Y. u wraps the circumference with
// u = 0.5 facing the camera; v runs top (0) to bottom (1) of the profile.
function lathe(profile, material, { segments = 96, radial = null, scale = 1 } = {}) {
    const rows = profile.length, cols = segments + 1;
    const position = new Float32Array(rows * cols * 3);
    const normal = new Float32Array(rows * cols * 3);
    const uv = new Float32Array(rows * cols * 2);

    const len = [0];
    for (let j = 1; j < rows; j++) {
        len[j] = len[j - 1] + Math.hypot(profile[j][0] - profile[j - 1][0], profile[j][1] - profile[j - 1][1]);
    }
    const total = len[rows - 1] || 1;

    for (let j = 0; j < rows; j++) {
        const [r0, y] = profile[j];
        for (let i = 0; i < cols; i++) {
            const t = i / segments;
            const a = t * TAU - Math.PI / 2;
            const r = r0 * scale * (radial ? radial(a, y) : 1);
            const k = j * cols + i;
            position[k * 3] = r * Math.cos(a);
            position[k * 3 + 1] = y;
            position[k * 3 + 2] = r * Math.sin(a);
            uv[k * 2] = 1 - t;
            uv[k * 2 + 1] = 1 - len[j] / total;
        }
    }

    // Normals from the surface itself (wraps around the seam)
    const P = (j, i) => (j * cols + i) * 3;
    for (let j = 0; j < rows; j++) {
        for (let i = 0; i < cols; i++) {
            const a0 = P(j, i === 0 ? segments - 1 : i - 1), a1 = P(j, i === segments ? 1 : i + 1);
            const p0 = P(Math.max(j - 1, 0), i), p1 = P(Math.min(j + 1, rows - 1), i);
            const ax = position[a1] - position[a0], ay = position[a1 + 1] - position[a0 + 1], az = position[a1 + 2] - position[a0 + 2];
            const px = position[p1] - position[p0], py = position[p1 + 1] - position[p0 + 1], pz = position[p1 + 2] - position[p0 + 2];
            const nx = py * az - pz * ay, ny = pz * ax - px * az, nz = px * ay - py * ax;
            const l = Math.hypot(nx, ny, nz) || 1;
            const k = P(j, i);
            normal[k] = nx / l; normal[k + 1] = ny / l; normal[k + 2] = nz / l;
        }
    }
    // Poles (r = 0) point straight up or down, like their neighbouring row
    for (let j = 0; j < rows; j++) {
        if (profile[j][0] > 1e-6) continue;
        const nb = j === 0 ? 1 : j - 1;
        const sign = Math.sign(normal[P(nb, 0) + 1]) || 1;
        for (let i = 0; i < cols; i++) {
            const k = P(j, i);
            normal[k] = 0; normal[k + 1] = sign; normal[k + 2] = 0;
        }
    }

    const index = new (rows * cols > 65535 ? Uint32Array : Uint16Array)((rows - 1) * segments * 6);
    let n = 0;
    for (let j = 0; j < rows - 1; j++) {
        for (let i = 0; i < segments; i++) {
            const a = j * cols + i, b = a + cols;
            index.set([a, b, a + 1, b, b + 1, a + 1], n);
            n += 6;
        }
    }
    return { position, normal, uv, index, material };
}

// Minimal binary glTF (GLB) writer
function createGLB(primitives, materials, images = []) {
    const parts = [], bufferViews = [], accessors = [];
    let byteLength = 0;
    const align = () => {
        const pad = (4 - (byteLength % 4)) % 4;
        if (pad) { parts.push(new Uint8Array(pad)); byteLength += pad; }
    };
    const addView = (bytes, target) => {
        align();
        const view = { buffer: 0, byteOffset: byteLength, byteLength: bytes.byteLength };
        if (target) view.target = target;
        parts.push(new Uint8Array(bytes.buffer, bytes.byteOffset, bytes.byteLength));
        byteLength += bytes.byteLength;
        bufferViews.push(view);
        return bufferViews.length - 1;
    };
    const addAccessor = (array, type, size, target, bounds) => {
        const componentType = array instanceof Float32Array ? 5126 : array instanceof Uint32Array ? 5125 : 5123;
        const accessor = { bufferView: addView(array, target), componentType, count: array.length / size, type };
        if (bounds) {
            accessor.min = Array(size).fill(Infinity);
            accessor.max = Array(size).fill(-Infinity);
            for (let i = 0; i < array.length; i++) {
                const c = i % size;
                if (array[i] < accessor.min[c]) accessor.min[c] = array[i];
                if (array[i] > accessor.max[c]) accessor.max[c] = array[i];
            }
        }
        accessors.push(accessor);
        return accessors.length - 1;
    };

    const json = {
        asset: { version: '2.0', generator: 'Coca-Cola fan concept' },
        scene: 0,
        scenes: [{ nodes: [0] }],
        nodes: [{ mesh: 0 }],
        meshes: [{
            primitives: primitives.map(p => ({
                attributes: {
                    POSITION: addAccessor(p.position, 'VEC3', 3, 34962, true),
                    NORMAL: addAccessor(p.normal, 'VEC3', 3, 34962),
                    TEXCOORD_0: addAccessor(p.uv, 'VEC2', 2, 34962)
                },
                indices: addAccessor(p.index, 'SCALAR', 1, 34963),
                material: p.material
            }))
        }],
        materials,
        accessors,
        bufferViews
    };
    if (images.length) {
        json.images = images.map(img => ({ bufferView: addView(img.bytes), mimeType: img.mimeType }));
        json.samplers = [{ magFilter: 9729, minFilter: 9987, wrapS: 10497, wrapT: 33071 }];
        json.textures = images.map((_, i) => ({ source: i, sampler: 0 }));
    }
    const used = new Set();
    materials.forEach(m => Object.keys(m.extensions || {}).forEach(e => used.add(e)));
    if (used.size) json.extensionsUsed = [...used];
    align();
    json.buffers = [{ byteLength }];

    const jsonBytes = new TextEncoder().encode(JSON.stringify(json));
    const jsonChunk = new Uint8Array(Math.ceil(jsonBytes.length / 4) * 4).fill(0x20);
    jsonChunk.set(jsonBytes);
    const total = 12 + 8 + jsonChunk.length + 8 + byteLength;
    const out = new Uint8Array(total);
    const dv = new DataView(out.buffer);
    dv.setUint32(0, 0x46546C67, true); // 'glTF'
    dv.setUint32(4, 2, true);
    dv.setUint32(8, total, true);
    dv.setUint32(12, jsonChunk.length, true);
    dv.setUint32(16, 0x4E4F534A, true); // 'JSON'
    out.set(jsonChunk, 20);
    let o = 20 + jsonChunk.length;
    dv.setUint32(o, byteLength, true);
    dv.setUint32(o + 4, 0x004E4942, true); // 'BIN'
    o += 8;
    parts.forEach(part => { out.set(part, o); o += part.byteLength; });
    return out;
}

const canvasBytes = (canvas, mimeType) => new Promise((resolve, reject) =>
    canvas.toBlob(blob => blob ? blob.arrayBuffer().then(b => resolve(new Uint8Array(b)), reject) : reject(new Error('toBlob failed')), mimeType, 0.92));

// ---------- Can ----------
// Real 12 fl oz proportions, in metres
const CAN = { r: 0.033, labelBottom: 0.012, labelTop: 0.103, height: 0.1225 };
const CAN_BOTTOM = smoothProfile([[0, 0.009], [0.012, 0.0075], [0.021, 0.0035], [0.0265, 0.0], [0.0295, 0.002], [0.0322, 0.007], [0.033, 0.012]], 5);
const CAN_TOP = smoothProfile([[0.033, 0.103], [0.0328, 0.106], [0.0305, 0.1125], [0.0285, 0.117], [0.0278, 0.1195], [0.0281, 0.1215],
    [0.0274, 0.1225], [0.0266, 0.1215], [0.0264, 0.118], [0.0256, 0.1172], [0.015, 0.1172], [0, 0.1176]], 4);

function fitFont(g, text, weight, family, maxWidth, maxSize) {
    g.font = `${weight} ${maxSize}px ${family}`;
    const size = Math.min(maxSize, maxSize * maxWidth / g.measureText(text).width);
    g.font = `${weight} ${size}px ${family}`;
    return size;
}

// Label texture wraps the straight body; drawn at true aspect so the
// script isn't stretched on the can.
function drawCanLabel(scheme) {
    const W = 2048;
    const H = Math.round(W * (CAN.labelTop - CAN.labelBottom) / (TAU * CAN.r));
    const c = document.createElement('canvas');
    c.width = W; c.height = H;
    const g = c.getContext('2d');

    const bg = g.createLinearGradient(0, 0, 0, H);
    bg.addColorStop(0, scheme.edge);
    bg.addColorStop(0.18, scheme.base);
    bg.addColorStop(0.82, scheme.base);
    bg.addColorStop(1, scheme.edge);
    g.fillStyle = bg;
    g.fillRect(0, 0, W, H);

    // Ribbon wave: one full period, so it wraps seamlessly
    g.fillStyle = scheme.ribbon;
    g.beginPath();
    for (let x = 0; x <= W; x += 8) g.lineTo(x, H * (0.66 + 0.07 * Math.sin(x / W * TAU + 0.9)));
    for (let x = W; x >= 0; x -= 8) g.lineTo(x, H * (0.735 + 0.05 * Math.sin(x / W * TAU + 1.5)));
    g.closePath();
    g.fill();

    g.textAlign = 'center';
    g.textBaseline = 'middle';
    // Front (x = W/2) and back (split across the seam at 0 and W)
    const both = draw => [W / 2, 0, W].forEach(draw);

    g.fillStyle = scheme.word;
    fitFont(g, 'Coca-Cola', '400', 'Yellowtail, cursive', W * 0.34, H * 0.4);
    both(x => g.fillText('Coca-Cola', x, H * 0.42));

    g.fillStyle = scheme.taglineColor;
    if ('letterSpacing' in g) g.letterSpacing = `${Math.round(H * 0.012)}px`;
    fitFont(g, scheme.tagline, '900', 'Outfit, sans-serif', W * 0.22, H * scheme.taglineSize);
    both(x => g.fillText(scheme.tagline, x, H * 0.16));

    g.fillStyle = scheme.word;
    g.font = `700 ${H * 0.04}px Outfit, sans-serif`;
    both(x => g.fillText('12 FL OZ (355 mL)', x, H * 0.885));
    if ('letterSpacing' in g) g.letterSpacing = '0px';
    return c;
}

async function buildCan(label) {
    const materials = [
        { name: 'label', pbrMetallicRoughness: { baseColorTexture: { index: 0 }, metallicFactor: 0.4, roughnessFactor: 0.28 } },
        { name: 'aluminium', pbrMetallicRoughness: { baseColorFactor: [0.82, 0.82, 0.84, 1], metallicFactor: 1, roughnessFactor: 0.25 } }
    ];
    const primitives = [
        lathe([[CAN.r, CAN.labelBottom], [CAN.r, CAN.labelTop]], 0, { segments: 128 }),
        lathe(CAN_BOTTOM, 1, { segments: 128 }),
        lathe(CAN_TOP, 1, { segments: 128 })
    ];
    const images = [{ bytes: await canvasBytes(label, 'image/jpeg'), mimeType: 'image/jpeg' }];
    return createGLB(primitives, materials, images);
}

// ---------- Contour bottle ----------
const BOTTLE_GLASS = smoothProfile([
    [0, 0.005], [0.014, 0.0035], [0.022, 0.0008], [0.0262, 0.0], [0.0285, 0.003], [0.0292, 0.012],
    [0.0288, 0.024], [0.0272, 0.036], [0.0258, 0.048], [0.0266, 0.060], [0.0288, 0.074],
    [0.0302, 0.088], [0.0304, 0.098], [0.0294, 0.110], [0.0266, 0.122], [0.0222, 0.134],
    [0.0180, 0.146], [0.0150, 0.158], [0.0134, 0.170], [0.0127, 0.180], [0.0131, 0.1845],
    [0.0136, 0.1875], [0.0131, 0.191]
]);
// Cola fills the glass up to just under the cap, a wall's thickness inside
const LIQUID_LINE = 0.183;
const BOTTLE_LIQUID = [
    [0, 0.0062], [0.018, 0.0048], [0.0245, 0.004],
    ...BOTTLE_GLASS.filter(([, y]) => y >= 0.008 && y < LIQUID_LINE).map(([r, y]) => [r * 0.93, y]),
    [0.0127 * 0.93, LIQUID_LINE], [0, LIQUID_LINE + 0.0002]
];
const BOTTLE_CAP = smoothProfile([[0.0142, 0.1855], [0.0146, 0.1885], [0.0145, 0.1915], [0.0138, 0.1935], [0.010, 0.1942], [0, 0.1944]], 4);
const BOTTLE_LABEL = BOTTLE_GLASS.filter(([, y]) => y >= 0.068 && y <= 0.11);
const BOTTLE_HEIGHT = 0.1944;

const bottleRadiusAt = y => {
    const pts = BOTTLE_GLASS.filter(p => p[0] > 0.02 || p[1] > 0.01);
    for (let k = 1; k < pts.length; k++) {
        if (pts[k][1] >= y) {
            const [r0, y0] = pts[k - 1], [r1, y1] = pts[k];
            return r0 + (r1 - r0) * ((y - y0) / ((y1 - y0) || 1));
        }
    }
    return pts[pts.length - 1][0];
};

// Vertical flutes above and below the label panel
const fluteBand = y => smoothstep(0.008, 0.018, y) * (1 - smoothstep(0.052, 0.062, y)) +
    smoothstep(0.112, 0.122, y) * (1 - smoothstep(0.142, 0.152, y));
const flutes = (a, y) => 1 + 0.022 * fluteBand(y) * Math.cos(a * 12);
// Crimped edge on the crown cap
const crimp = (a, y) => 1 + 0.035 * (1 - smoothstep(0.189, 0.1915, y)) * Math.cos(a * 21);

function drawBottleLabel() {
    let arc = 0;
    for (let k = 1; k < BOTTLE_LABEL.length; k++) {
        arc += Math.hypot(BOTTLE_LABEL[k][0] - BOTTLE_LABEL[k - 1][0], BOTTLE_LABEL[k][1] - BOTTLE_LABEL[k - 1][1]);
    }
    const W = 2048;
    const H = Math.round(W * arc / (TAU * 0.0302));
    const c = document.createElement('canvas');
    c.width = W; c.height = H;
    const g = c.getContext('2d');
    g.textAlign = 'center';
    g.textBaseline = 'middle';
    g.fillStyle = '#ffffff';
    fitFont(g, 'Coca-Cola', '400', 'Yellowtail, cursive', W * 0.3, H * 0.62);
    [W / 2, 0, W].forEach(x => g.fillText('Coca-Cola', x, H * 0.5));
    return c;
}

async function buildBottle(label) {
    const materials = [
        {
            name: 'glass',
            pbrMetallicRoughness: { baseColorFactor: [0.82, 0.95, 0.88, 1], metallicFactor: 0, roughnessFactor: 0.04 },
            extensions: {
                KHR_materials_transmission: { transmissionFactor: 1 },
                KHR_materials_ior: { ior: 1.5 },
                KHR_materials_volume: { thicknessFactor: 0.004, attenuationDistance: 0.05, attenuationColor: [0.75, 0.92, 0.82] }
            }
        },
        { name: 'cola', pbrMetallicRoughness: { baseColorFactor: [0.09, 0.028, 0.012, 1], metallicFactor: 0, roughnessFactor: 0.15 } },
        { name: 'print', alphaMode: 'BLEND', pbrMetallicRoughness: { baseColorTexture: { index: 0 }, metallicFactor: 0, roughnessFactor: 0.45 } },
        { name: 'cap', pbrMetallicRoughness: { baseColorFactor: [0.75, 0.04, 0.06, 1], metallicFactor: 0.6, roughnessFactor: 0.32 } }
    ];
    const primitives = [
        lathe(BOTTLE_GLASS, 0, { segments: 96, radial: flutes }),
        lathe(BOTTLE_LIQUID, 1, { segments: 64 }),
        lathe(BOTTLE_LABEL, 2, { segments: 128, scale: 1.004 }),
        lathe(BOTTLE_CAP, 3, { segments: 84, radial: crimp })
    ];
    const images = [{ bytes: await canvasBytes(label, 'image/png'), mimeType: 'image/png' }];
    return createGLB(primitives, materials, images);
}

// ---------- Card art (2D, drawn from the same labels/profiles) ----------
const CARD_W = 280, CARD_H = 520, CARD_BASE = 505;

function drawCanCard(label) {
    const c = document.createElement('canvas');
    c.width = CARD_W; c.height = CARD_H;
    const g = c.getContext('2d');
    const k = 240 / (CAN.r * 2);
    const cx = CARD_W / 2, half = CAN.r * k, x0 = cx - half, x1 = cx + half;
    const Y = y => CARD_BASE - y * k;
    const bodyTop = Y(CAN.labelTop), bodyBottom = Y(CAN.labelBottom);
    const lidY = Y(0.1215), lidR = 0.0275 * k, baseY = Y(0.0015), baseR = 0.0265 * k;

    const can = new Path2D();
    can.moveTo(x0, bodyTop);
    can.bezierCurveTo(x0, bodyTop - 26, cx - lidR - 6, lidY + 28, cx - lidR, lidY);
    can.ellipse(cx, lidY, lidR, 10, 0, Math.PI, 0);
    can.bezierCurveTo(cx + lidR + 6, lidY + 28, x1, bodyTop - 26, x1, bodyTop);
    can.lineTo(x1, bodyBottom);
    can.bezierCurveTo(x1, bodyBottom + 18, cx + baseR + 8, baseY - 10, cx + baseR, baseY);
    can.ellipse(cx, baseY, baseR, 8, 0, 0, Math.PI);
    can.bezierCurveTo(cx - baseR - 8, baseY - 10, x0, bodyBottom + 18, x0, bodyBottom);
    can.closePath();

    const metal = g.createLinearGradient(x0, 0, x1, 0);
    metal.addColorStop(0, '#8d9096');
    metal.addColorStop(0.3, '#eceef1');
    metal.addColorStop(0.55, '#b9bcc2');
    metal.addColorStop(1, '#6f7278');
    g.fillStyle = metal;
    g.fill(can);

    // Wrap the front half of the label onto the cylinder
    for (let x = Math.floor(x0); x < x1; x++) {
        const nx = Math.min(Math.max((x + 0.5 - cx) / half, -1), 1);
        const u = 0.5 + Math.asin(nx) / TAU;
        g.drawImage(label, u * label.width, 0, 1, label.height, x, bodyTop, 1, bodyBottom - bodyTop);
    }

    // Cylinder shading over everything drawn so far
    const shade = g.createLinearGradient(x0, 0, x1, 0);
    shade.addColorStop(0, 'rgba(0,0,0,0.55)');
    shade.addColorStop(0.1, 'rgba(0,0,0,0.18)');
    shade.addColorStop(0.27, 'rgba(255,255,255,0.32)');
    shade.addColorStop(0.36, 'rgba(255,255,255,0.05)');
    shade.addColorStop(0.65, 'rgba(0,0,0,0.04)');
    shade.addColorStop(0.88, 'rgba(0,0,0,0.3)');
    shade.addColorStop(1, 'rgba(0,0,0,0.6)');
    g.globalCompositeOperation = 'source-atop';
    g.fillStyle = shade;
    g.fillRect(0, 0, CARD_W, CARD_H);
    g.globalCompositeOperation = 'source-over';

    // Lid
    const lid = g.createLinearGradient(0, lidY - 10, 0, lidY + 10);
    lid.addColorStop(0, '#f2f3f5');
    lid.addColorStop(1, '#9ea2a8');
    g.fillStyle = lid;
    g.beginPath();
    g.ellipse(cx, lidY, lidR, 10, 0, 0, TAU);
    g.fill();
    g.strokeStyle = 'rgba(0,0,0,0.25)';
    g.lineWidth = 1.5;
    g.beginPath();
    g.ellipse(cx, lidY + 1, lidR * 0.88, 7, 0, 0, TAU);
    g.stroke();
    g.fillStyle = '#c9ccd1';
    g.beginPath();
    g.roundRect(cx - 14, lidY - 3, 28, 8, 4);
    g.fill();
    return c;
}

function drawBottleCard() {
    const c = document.createElement('canvas');
    c.width = CARD_W; c.height = CARD_H;
    const g = c.getContext('2d');
    const k = 470 / BOTTLE_HEIGHT;
    const cx = CARD_W / 2;
    const Y = y => CARD_BASE - y * k;
    const pts = BOTTLE_GLASS.filter(p => p[0] > 0.02 || p[1] > 0.01);

    const glass = new Path2D();
    pts.forEach(([r, y], i) => i ? glass.lineTo(cx - r * k, Y(y)) : glass.moveTo(cx - r * k, Y(y)));
    for (let i = pts.length - 1; i >= 0; i--) glass.lineTo(cx + pts[i][0] * k, Y(pts[i][1]));
    glass.closePath();

    g.fillStyle = 'rgba(175, 215, 195, 0.28)';
    g.fill(glass);

    g.save();
    g.clip(glass);
    const halfW = 0.0305 * k;
    const cola = g.createLinearGradient(cx - halfW, 0, cx + halfW, 0);
    cola.addColorStop(0, '#0d0302');
    cola.addColorStop(0.24, '#3a1408');
    cola.addColorStop(0.32, '#5c230e');
    cola.addColorStop(0.55, '#2a0d05');
    cola.addColorStop(1, '#070101');
    g.fillStyle = cola;
    g.fillRect(0, Y(LIQUID_LINE), CARD_W, CARD_H);

    // Flutes and highlights follow the contour
    const contour = (f, y0, y1) => {
        g.beginPath();
        for (let y = y0; y <= y1; y += 0.001) g.lineTo(cx + f * bottleRadiusAt(y) * k, Y(y));
        g.stroke();
    };
    g.strokeStyle = 'rgba(255,255,255,0.1)';
    g.lineWidth = 1.5;
    [-0.7, -0.35, 0, 0.35, 0.7].forEach(f => { contour(f, 0.01, 0.06); contour(f, 0.114, 0.15); });
    g.strokeStyle = 'rgba(255,255,255,0.38)';
    g.lineWidth = 5;
    contour(-0.58, 0.012, 0.186);
    g.strokeStyle = 'rgba(255,255,255,0.18)';
    g.lineWidth = 2;
    contour(0.72, 0.015, 0.18);
    g.restore();

    g.strokeStyle = 'rgba(255,255,255,0.3)';
    g.lineWidth = 1.5;
    g.stroke(glass);

    // Painted white script on the label panel
    g.fillStyle = '#ffffff';
    g.textAlign = 'center';
    g.textBaseline = 'middle';
    fitFont(g, 'Coca-Cola', '400', 'Yellowtail, cursive', bottleRadiusAt(0.09) * k * 1.3, 60);
    g.fillText('Coca-Cola', cx, Y(0.09));

    // Crown cap
    const capR = 0.0146 * k, capTop = Y(0.1944), capBottom = Y(0.1855);
    const cap = g.createLinearGradient(cx - capR, 0, cx + capR, 0);
    cap.addColorStop(0, '#7d0a12');
    cap.addColorStop(0.35, '#f03a45');
    cap.addColorStop(1, '#6a070e');
    g.fillStyle = cap;
    g.beginPath();
    g.roundRect(cx - capR, capTop, capR * 2, capBottom - capTop, 3);
    g.fill();
    g.strokeStyle = 'rgba(0,0,0,0.25)';
    g.lineWidth = 1;
    for (let x = cx - capR + 4; x < cx + capR; x += 5) {
        g.beginPath();
        g.moveTo(x, capTop + 8);
        g.lineTo(x, capBottom);
        g.stroke();
    }
    return c;
}

// ---------- Build everything ----------
function revealCan() {
    modelViewer.classList.add('is-ready');
}
modelViewer.addEventListener('load', revealCan);

async function buildProducts() {
    // Labels need the script font; don't wait forever if it's blocked
    await Promise.race([
        Promise.all([
            document.fonts.load('100px "Yellowtail"'),
            document.fonts.load('900 40px "Outfit"'),
            document.fonts.load('700 40px "Outfit"')
        ]),
        new Promise(r => setTimeout(r, 3000))
    ]).catch(() => {});

    for (const [key, product] of Object.entries(PRODUCTS)) {
        try {
            const label = product.kind === 'can' ? drawCanLabel(product.label) : drawBottleLabel();
            const glb = product.kind === 'can' ? await buildCan(label) : await buildBottle(label);
            product.modelUrl = URL.createObjectURL(new Blob([glb], { type: 'model/gltf-binary' }));

            const img = document.querySelector(`.card[data-flavor="${key}"] img`);
            img.addEventListener('load', () => img.classList.add('is-ready'), { once: true });
            product.art = (product.kind === 'can' ? drawCanCard(label) : drawBottleCard()).toDataURL('image/png');
            img.src = product.art;
        } catch (e) {
            console.error(`Building ${key} failed`, e);
        }
        if (key === currentFlavor && product.modelUrl) {
            modelViewer.setAttribute('src', product.modelUrl);
        }
    }
    // A panel opened before the art was ready gets its thumbnails now
    if (openSheetName && renderers[openSheetName]) renderers[openSheetName]();
}
buildProducts();

cards.forEach(card => {
    card.addEventListener('click', () => {
        if (isSwitching) return;
        if (card.dataset.flavor === currentFlavor) return;
        cards.forEach(c => c.classList.remove('active'));
        card.classList.add('active');
        const flavor = card.dataset.flavor;
        switchFlavor(flavor);
    });
});

// Arrows step through the products
document.querySelectorAll('.nav-arrow').forEach((arrow, dir) => {
    arrow.addEventListener('click', () => {
        if (isSwitching) return;
        const list = [...cards];
        const i = list.findIndex(c => c.classList.contains('active'));
        const next = list[(i + (dir === 0 ? -1 : 1) + list.length) % list.length];
        next.click();
    });
});

async function switchFlavor(flavor) {
    if (isSwitching) return;
    isSwitching = true;
    const body = document.body;
    const berries = document.querySelectorAll('.berry');
    const heroCenter = document.querySelector('.hero-center');

    // 1. Background Animation
    const targetColors = PRODUCTS[flavor].bg;

    gsap.to(body, {
        '--bg-inner': targetColors.inner,
        '--bg-mid': targetColors.mid,
        '--bg-outer': targetColors.outer,
        duration: 1.5,
        ease: 'power2.inOut'
    });

    // 2. Can Spin Animation (Simple 360 spin + blur with back settle)
    const spinObj = { val: 0, blur: 0 };
    gsap.to(spinObj, {
        val: 360,
        blur: 15,
        duration: 0.6,
        ease: "power2.in",
        onUpdate: () => {
            switchSpin = spinObj.val;
            modelViewer.style.filter = `blur(${spinObj.blur}px)`;
        },
        onComplete: () => {
            // SWAP at peak: new product model
            currentFlavor = flavor;
            body.dataset.flavor = flavor;
            if (PRODUCTS[flavor].modelUrl) {
                modelViewer.setAttribute('src', PRODUCTS[flavor].modelUrl);
                modelViewer.setAttribute('alt', PRODUCTS[flavor].kind === 'can' ? 'Coca-Cola 3D can' : 'Coca-Cola 3D glass bottle');
            }

            gsap.to(spinObj, {
                val: 720,
                blur: 0,
                duration: 1.5,
                ease: "back.out(0.7)",
                onUpdate: () => {
                    switchSpin = spinObj.val;
                    modelViewer.style.filter = `blur(${spinObj.blur}px)`;
                },
                onComplete: () => {
                    switchSpin = 0;
                    modelViewer.style.filter = 'none';
                }
            });
        }
    });

    // 3. Berries "Hide & Reveal" with Dynamic Positioning
    let completedBerries = 0;
    berries.forEach((berry, i) => {
        const bW = berry.offsetWidth / 2;
        const bH = berry.offsetHeight / 2;
        const centerX = (window.innerWidth / 2 - berry.offsetLeft - bW);
        const centerY = (window.innerHeight / 2 - berry.offsetTop - bH);

        const startAngle = parseFloat(berry.dataset.angle) || 0;
        const currentBaseX = parseFloat(berry.dataset.baseX) || 0;
        const currentBaseY = parseFloat(berry.dataset.baseY) || 0;

        // New random target position - Increased range for visibility
        const nextBaseX = (Math.random() - 0.5) * 200;
        const nextBaseY = (Math.random() - 0.5) * 200;

        gsap.set(berry, {
            rotation: startAngle,
            x: currentBaseX,
            y: currentBaseY
        });

        const berryTl = gsap.timeline();

        berryTl.to(berry, {
            x: centerX,
            y: centerY,
            rotation: startAngle + 45,
            scale: 0.1,
            opacity: 0,
            duration: 0.5,
            ease: "power2.in",
            onComplete: () => {
                const nextSrc = PRODUCTS[flavor].berry;
                if (berry.src !== nextSrc) berry.src = nextSrc;
                heroCenter.style.zIndex = 50;
            }
        })
        .to(berry, {
            duration: 0.3
        })
        .to(berry, {
            onStart: () => {
                heroCenter.style.zIndex = 1;
            },
            x: nextBaseX,
            y: nextBaseY,
            rotation: startAngle + 90,
            scale: 1,
            opacity: 1,
            duration: 0.9,
            ease: "back.out(1.5)",
            onComplete: () => {
                berry.dataset.angle = startAngle + 90;
                berry.dataset.baseX = nextBaseX;
                berry.dataset.baseY = nextBaseY;
                berry.dataset.rx = 0;
                berry.dataset.ry = 0;

                completedBerries++;
                if (completedBerries === berries.length) {
                    isSwitching = false;
                }
            }
        });
    });
}


// ---------- Panels: nav sections, Shop Now and Contact Us ----------
// Put an address here to have the contact form open the visitor's email app.
const CONTACT_EMAIL = '';

const headerEl = document.querySelector('.header');
const menuBtn = document.querySelector('.menu-btn');
const sheetLayer = document.querySelector('.sheet-layer');
const renderers = {};
let openSheetName = null;
let lastFocus = null;

const store = {
    get(key, fallback) {
        try { const v = localStorage.getItem(key); return v ? JSON.parse(v) : fallback; } catch (e) { return fallback; }
    },
    set(key, value) {
        try { localStorage.setItem(key, JSON.stringify(value)); } catch (e) { /* storage unavailable */ }
    }
};
const money = n => `$${n.toFixed(2)}`;

function el(tag, props = {}, ...children) {
    const node = document.createElement(tag);
    Object.entries(props).forEach(([k, v]) => {
        if (k === 'class') node.className = v;
        else if (k === 'text') node.textContent = v;
        else if (k.startsWith('on')) node.addEventListener(k.slice(2), v);
        else node.setAttribute(k, v);
    });
    children.flat().forEach(c => c != null && node.append(c));
    return node;
}

function setStatus(node, text, kind = '', focusField = null) {
    node.textContent = text;
    node.className = `form-status ${kind}`.trim();
    if (focusField) focusField.focus();
}

// Phone menu
function setMenu(open) {
    headerEl.classList.toggle('menu-open', open);
    menuBtn.setAttribute('aria-expanded', String(open));
    menuBtn.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
}
menuBtn.addEventListener('click', e => {
    e.stopPropagation();
    setMenu(!headerEl.classList.contains('menu-open'));
});
document.addEventListener('click', e => {
    if (!headerEl.contains(e.target)) setMenu(false);
});

function setActiveNav(name) {
    document.querySelectorAll('.nav-item').forEach(a => a.classList.toggle('active', a.dataset.open === (name || 'home')));
}

function openSheet(name, opener) {
    const sheet = document.querySelector(`.sheet[data-sheet="${name}"]`);
    if (!sheet) return;
    document.querySelectorAll('.sheet.open').forEach(s => { s.classList.remove('open'); s.setAttribute('aria-hidden', 'true'); });
    if (!openSheetName) lastFocus = opener || document.activeElement;
    if (renderers[name]) renderers[name]();
    sheetLayer.classList.add('open');
    document.body.classList.add('sheet-open');
    sheet.classList.add('open');
    sheet.setAttribute('aria-hidden', 'false');
    sheet.scrollTop = 0;
    openSheetName = name;
    setActiveNav(name);
    history.replaceState(null, '', `#${name}`);
    setTimeout(() => sheet.querySelector('.sheet-close').focus({ preventScroll: true }), 60);
}

function closeSheet() {
    if (!openSheetName) return;
    document.querySelectorAll('.sheet.open').forEach(s => { s.classList.remove('open'); s.setAttribute('aria-hidden', 'true'); });
    sheetLayer.classList.remove('open');
    document.body.classList.remove('sheet-open');
    openSheetName = null;
    setActiveNav('home');
    history.replaceState(null, '', location.pathname + location.search);
    if (lastFocus && document.contains(lastFocus)) lastFocus.focus({ preventScroll: true });
}

document.querySelectorAll('[data-open]').forEach(trigger => {
    trigger.addEventListener('click', e => {
        e.preventDefault();
        setMenu(false);
        const name = trigger.dataset.open;
        if (name === 'home') closeSheet();
        else openSheet(name, trigger);
    });
});
sheetLayer.querySelectorAll('[data-close]').forEach(b => b.addEventListener('click', closeSheet));

document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
        if (openSheetName) closeSheet();
        else setMenu(false);
        return;
    }
    // Keep keyboard focus inside an open panel
    if (e.key !== 'Tab' || !openSheetName) return;
    const sheet = document.querySelector('.sheet.open');
    const items = [...sheet.querySelectorAll('button:not([disabled]), input, textarea, a[href]')];
    if (!items.length) return;
    const first = items[0], last = items[items.length - 1];
    if (!sheet.contains(document.activeElement)) { e.preventDefault(); first.focus(); }
    else if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
    else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
});

const productThumb = product => product.art ? el('img', { src: product.art, alt: '' }) : el('span');

// Product chips (built once per row, then only their state changes)
function chips(container, selected, onPick) {
    if (!container.children.length) {
        container.setAttribute('role', 'radiogroup');
        Object.entries(PRODUCTS).forEach(([key, p]) => container.append(el('button', {
            class: 'chip', type: 'button', role: 'radio', 'data-key': key, text: p.name,
            onclick: () => container.onPick && container.onPick(key)
        })));
    }
    container.onPick = onPick;
    container.querySelectorAll('.chip').forEach(c => c.setAttribute('aria-checked', String(c.dataset.key === selected)));
}

function selectProduct(key) {
    closeSheet();
    if (key === currentFlavor) return;
    setTimeout(() => document.querySelector(`.card[data-flavor="${key}"]`).click(), 350);
}

// Flavors
renderers.flavors = () => {
    document.querySelector('[data-list="flavors"]').replaceChildren(...Object.entries(PRODUCTS).map(([key, p]) => {
        const showing = key === currentFlavor;
        return el('div', { class: 'product-row' },
            productThumb(p),
            el('div', {},
                el('h4', { text: p.name }),
                el('p', { text: `${p.size} · ${p.blurb}` }),
                el('span', { class: 'price', text: money(p.price) })),
            el('button', {
                class: `pill-btn small${showing ? ' ghost' : ''}`, type: 'button',
                text: showing ? 'Showing' : 'View in 3D', onclick: () => selectProduct(key)
            }));
    }));
};

// Taste
renderers.taste = (key = currentFlavor) => {
    chips(document.querySelector('[data-chips="taste"]'), key, k => renderers.taste(k));
    const fills = [];
    document.querySelector('[data-meters]').replaceChildren(...Object.entries(PRODUCTS[key].notes).map(([note, value]) => {
        const fill = el('div', { class: 'meter-fill' });
        fills.push([fill, value]);
        return el('div', { class: 'meter' },
            el('div', { class: 'meter-label' }, el('span', { text: note }), el('span', { text: `${value}/5` })),
            el('div', { class: 'meter-track' }, fill));
    }));
    setTimeout(() => fills.forEach(([fill, value]) => { fill.style.width = `${value * 20}%`; }), 40);
};

// Eco
let recycled = store.get('coke-recycled', 0);
const recycledOut = document.querySelector('[data-recycled]');
renderers.eco = () => { recycledOut.textContent = recycled; };
document.querySelector('[data-recycle]').addEventListener('click', () => {
    recycled++;
    store.set('coke-recycled', recycled);
    renderers.eco();
    gsap.fromTo(recycledOut, { scale: 1.35 }, { scale: 1, duration: 0.45, ease: 'back.out(3)' });
});

// Reviews
const reviews = store.get('coke-reviews', []);
const reviewForm = document.querySelector('.review-form');
let reviewProduct = 'classic';
let reviewRating = 0;

function renderStars() {
    reviewForm.querySelectorAll('.star').forEach(star => {
        const value = Number(star.dataset.value);
        star.classList.toggle('on', value <= reviewRating);
        star.setAttribute('aria-checked', String(value === reviewRating));
    });
}
reviewForm.querySelectorAll('.star').forEach(star => star.addEventListener('click', () => {
    reviewRating = Number(star.dataset.value);
    renderStars();
}));

renderers.reviews = () => {
    chips(reviewForm.querySelector('[data-chips="review"]'), reviewProduct, k => { reviewProduct = k; renderers.reviews(); });
    renderStars();
    const list = document.querySelector('[data-reviews]');
    if (!reviews.length) {
        list.replaceChildren(el('p', { class: 'empty', text: 'No reviews yet. Be the first to rate one.' }));
        return;
    }
    list.replaceChildren(...reviews.map(r => el('article', { class: 'review' },
        el('div', { class: 'review-top' },
            el('span', { class: 'review-stars', 'aria-label': `${r.rating} out of 5 stars`, text: '★'.repeat(r.rating) + '☆'.repeat(5 - r.rating) }),
            el('span', { text: `${PRODUCTS[r.product] ? PRODUCTS[r.product].name : ''} · ${new Date(r.date).toLocaleDateString()}` })),
        r.text ? el('p', { text: r.text }) : null,
        el('p', { class: 'fine', text: `— ${r.name || 'Anonymous'}` }))));
};

reviewForm.addEventListener('submit', e => {
    e.preventDefault();
    const status = reviewForm.querySelector('.form-status');
    if (!reviewRating) return setStatus(status, 'Pick a star rating first.', 'error', reviewForm.querySelector('.star'));
    const data = new FormData(reviewForm);
    reviews.unshift({
        product: reviewProduct,
        rating: reviewRating,
        name: String(data.get('name') || '').trim().slice(0, 40),
        text: String(data.get('text') || '').trim().slice(0, 280),
        date: Date.now()
    });
    reviews.splice(20);
    store.set('coke-reviews', reviews);
    reviewForm.reset();
    reviewRating = 0;
    renderers.reviews();
    setStatus(status, 'Thanks! Your review was saved in this browser.', 'ok');
});

// Shop
const cart = store.get('coke-cart', {});
const cartBadge = document.querySelector('.cart-badge');
const shopStatus = document.querySelector('[data-shop-status]');

function updateCartBadge() {
    const count = Object.values(cart).reduce((a, b) => a + b, 0);
    cartBadge.textContent = count;
    cartBadge.hidden = count === 0;
}

function changeQty(key, delta) {
    cart[key] = Math.max(0, Math.min(24, (cart[key] || 0) + delta));
    if (!cart[key]) delete cart[key];
    store.set('coke-cart', cart);
    updateCartBadge();
    setStatus(shopStatus, '');
    renderers.shop();
    const again = document.querySelector(`[data-focus="${key}${delta > 0 ? '+' : '-'}"]`);
    if (again) again.focus();
}

renderers.shop = () => {
    document.querySelector('[data-list="shop"]').replaceChildren(...Object.entries(PRODUCTS).map(([key, p]) => el('div', { class: 'product-row' },
        productThumb(p),
        el('div', {},
            el('h4', { text: p.name }),
            el('p', { text: p.size }),
            el('span', { class: 'price', text: money(p.price) })),
        el('div', { class: 'stepper' },
            el('button', { type: 'button', 'data-focus': `${key}-`, 'aria-label': `Remove one ${p.name}`, text: '−', onclick: () => changeQty(key, -1) }),
            el('output', { 'aria-live': 'polite', text: String(cart[key] || 0) }),
            el('button', { type: 'button', 'data-focus': `${key}+`, 'aria-label': `Add one ${p.name}`, text: '+', onclick: () => changeQty(key, 1) })))));
    const subtotal = Object.entries(cart).reduce((sum, [k, q]) => sum + (PRODUCTS[k] ? PRODUCTS[k].price * q : 0), 0);
    document.querySelector('[data-subtotal]').textContent = money(subtotal);
    document.querySelector('[data-checkout]').disabled = subtotal === 0;
};

document.querySelector('[data-checkout]').addEventListener('click', () => {
    setStatus(shopStatus, 'Thanks! This is a fan concept, so no real order was placed.', 'ok');
});
updateCartBadge();

// Contact
const contactForm = document.querySelector('.contact-form');
contactForm.addEventListener('submit', e => {
    e.preventDefault();
    const status = contactForm.querySelector('.form-status');
    const fields = contactForm.elements;
    const name = fields.name.value.trim();
    const email = fields.email.value.trim();
    const message = fields.message.value.trim();
    if (!name) return setStatus(status, 'Please add your name.', 'error', fields.name);
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return setStatus(status, 'Please enter a valid email address.', 'error', fields.email);
    if (message.length < 10) return setStatus(status, 'Your message needs at least 10 characters.', 'error', fields.message);
    if (CONTACT_EMAIL) {
        location.href = `mailto:${CONTACT_EMAIL}?subject=${encodeURIComponent(`Hello from ${name}`)}&body=${encodeURIComponent(`${message}\n\n${name} <${email}>`)}`;
        setStatus(status, 'Opening your email app…', 'ok');
    } else {
        setStatus(status, `Thanks, ${name}! Your message is ready, but this demo form isn't connected to an inbox yet.`, 'ok');
    }
    contactForm.reset();
});

// Open a panel straight from a link like index.html#shop
function openFromHash() {
    const name = location.hash.slice(1);
    if (name && document.querySelector(`.sheet[data-sheet="${name}"]`)) openSheet(name);
}
window.addEventListener('hashchange', openFromHash);
openFromHash();


// Track berry states for smoothing
allBerries.forEach(b => {
    b.dataset.rx = 0; b.dataset.ry = 0; b.dataset.angle = Math.random() * 360;
    b.dataset.baseX = 0; b.dataset.baseY = 0;
    b.dataset.targetRx = 0; b.dataset.targetRy = 0;
});

let mouse = { x: 0, y: 0, px: 0, py: 0 };
let currentMouse = { x: 0, y: 0 };

// Pointer events: mouse, pen and touch all tilt the product
window.addEventListener('pointermove', (e) => {
    mouse.x = (e.clientX / window.innerWidth) - 0.5;
    mouse.y = (e.clientY / window.innerHeight) - 0.5;
    mouse.px = e.clientX;
    mouse.py = e.clientY;
});

function animate() {
    const time = Date.now() * 0.001;
    // Target camera position based on mouse
    // Smoothly interpolate current mouse to target mouse
    currentMouse.x += (mouse.x - currentMouse.x) * 0.05;
    currentMouse.y += (mouse.y - currentMouse.y) * 0.05;

    // Tilt the product can + add switch spin
    modelViewer.cameraOrbit = `${(currentMouse.x * 40) + switchSpin}deg ${90 + (currentMouse.y * 20)}deg 380%`;

    // Update parallax containers - Always
    berriesFG.style.transform = `translate(${currentMouse.x * 60}px, ${currentMouse.y * 60}px)`;
    berriesBG.style.transform = `translate(${currentMouse.x * -30}px, ${currentMouse.y * -30}px)`;
    leavesBG.style.transform = `translate(${currentMouse.x * -15}px, ${currentMouse.y * -15}px)`;

    // Update each berry with its own smoothing and float - ONLY IF NOT SWITCHING
    if (!isSwitching) {
        allBerries.forEach((berry, i) => {
            const berryRect = berry.getBoundingClientRect();
            const berryX = berryRect.left + berryRect.width / 2;
            const berryY = berryRect.top + berryRect.height / 2;

            const diffX = mouse.px - berryX;
            const diffY = mouse.py - berryY;
            const distance = Math.sqrt(diffX * diffX + diffY * diffY);

            let targetRx = 0, targetRy = 0, speedMult = 1;

            if (distance < 400) {
                const force = (400 - distance) / 400;
                targetRx = (diffX / distance) * force * -80;
                targetRy = (diffY / distance) * force * -80;
                speedMult = 1 + force * 5;
            }

            // Lerp repulsion values
            let rx = parseFloat(berry.dataset.rx) || 0;
            let ry = parseFloat(berry.dataset.ry) || 0;
            let angle = parseFloat(berry.dataset.angle) || 0;
            let baseX = parseFloat(berry.dataset.baseX) || 0;
            let baseY = parseFloat(berry.dataset.baseY) || 0;

            rx += (targetRx - rx) * 0.1;
            ry += (targetRy - ry) * 0.1;
            angle += 0.2 * speedMult;

            berry.dataset.rx = rx;
            berry.dataset.ry = ry;
            berry.dataset.angle = angle;

            // Floating effect
            const dur = [5, 7, 6, 8, 5.5, 6.5, 9, 11, 10][i % 9];
            const phase = (time + i * 0.7) * (Math.PI * 2 / dur);
            const floatY = Math.sin(phase) * 15;
            const floatAngle = Math.cos(phase) * 6;

            berry.style.transform = `translate(calc(${rx + baseX}px), calc(${ry + baseY}px + ${floatY}px)) rotate(calc(${angle}deg + ${floatAngle}deg))`;
        });
    }

    // Update leaves with float - ALWAYS
    document.querySelectorAll('.leaf').forEach((leaf, i) => {
        const dur = 10 + i * 2;
        const phase = (time + i * 1.2) * (Math.PI * 2 / dur);
        const floatY = Math.sin(phase) * 20;
        const floatX = Math.cos(phase * 0.5) * 15;
        const floatAngle = Math.sin(phase * 0.3) * 15;
        leaf.style.transform = `translate(${floatX}px, ${floatY}px) rotate(${floatAngle}deg)`;
    });

    requestAnimationFrame(animate);
}

animate();

// Bubbles Generator using bubble.png
const bubblesContainer = document.getElementById('bubbles-container');
function createBubble() {
    if (!bubblesContainer) return;
    const bubble = document.createElement('img');
    bubble.src = ASSETS.bubble;
    bubble.className = 'bubble-img';
    const size = Math.random() * 20 + 10 + 'px';
    bubble.style.width = size;
    bubble.style.height = 'auto';
    bubble.style.left = Math.random() * 100 + '%';
    bubble.style.bottom = '-50px';
    bubble.style.opacity = Math.random() * 0.4 + 0.2;

    const duration = Math.random() * 6 + 4;
    bubble.style.animation = `floatUpImg ${duration}s linear forwards`;

    bubblesContainer.appendChild(bubble);
    setTimeout(() => bubble.remove(), duration * 1000);
}
setInterval(createBubble, 400);
```

## Assets

`ASSET_BASE_URL = https://api.getlayers.ai/storage/v1/object/public/public/assets/soda-14ff8a788d`

- `leaves.glb`: floating leaves
- `cherry.glb`: berries for Classic and the bottle
- `blueberry.glb`: berries for Zero Sugar
- `bubble.png`: rising bubbles

The Coca-Cola can, the Zero Sugar can, the contour bottle and all card images are generated by the
script, so no product files are needed.
