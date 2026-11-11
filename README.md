# Maison Vela

A demo fashion storefront with 60 real product photos (20 clothes, 20 shoes, 20 bags) and three carousel mechanics, each built with plain HTML, CSS and JavaScript. It uses no canvas, no WebGL and no animation library.

| Department | Mechanic | How it works |
| --- | --- | --- |
| Clothing | Drag-to-orbit wheel | Each piece has an angle on a circle. While you drag, that angle is turned into `sin`/`cos` and written into one CSS `matrix()` transform per card, every frame. |
| Shoes | Curved hover rail | Pairs sit on an SVG curve, placed with `getPointAtLength()`. Hovering (or tapping) a pair scales and spotlights it while the rest dim. |
| Bags | Shuffle grid | The Shuffle button reorders the array and re-appends the cards in the new order. You can also sort by price or name. |

There is also a basket that remembers its contents in your browser. Checkout is turned off because this is a demo.

## Run it

Open `index.html` in a browser. If your browser blocks local files, serve the folder:

```bash
python3 -m http.server 8000
```

Then visit http://localhost:8000.

## Photos

All product photos are real photographs from [Unsplash](https://unsplash.com), used under the [Unsplash License](https://unsplash.com/license). The source of each file is listed in [`images/CREDITS.md`](images/CREDITS.md). Product names, prices and sizes are made up for the demo.
