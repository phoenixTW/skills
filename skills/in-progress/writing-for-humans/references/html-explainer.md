# HTML explainer

One self-contained `index.html` in `.scratch/explain/<slug>/`. Tailwind, Mermaid, and Scrollama come from CDNs. No build step: the user opens the file with a double-click.

The page is an **explorable**: the reader learns by moving something and watching what changes, not by reading more paragraphs. The text comes from `draft.md` unchanged. The page adds layout, motion, and interaction, never new claims.

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{{goal in plain words}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/scrollama@3"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral" });
    </script>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans leading-relaxed">
    <main class="max-w-3xl mx-auto px-6 py-12 space-y-16">
      <header>...</header>
      <section id="where-we-are">...</section>
      <section id="goal">...</section>
      <section id="steps">...</section>
      <section id="success">...</section>
      <section id="risks">...</section>
      <details id="deeper">...</details>
    </main>
  </body>
</html>
```

## Sections

Map `draft.md` one to one. Skipped draft sections stay skipped.

- **Header.** The goal as the title, the premise as a one-sentence subtitle, and the date.
- **Where we are and goal.** Short text beside a diagram. Text on the left, picture on the right on wide screens. Stacked on narrow screens.
- **How we get there.** A Scrollama step story: the diagram stays fixed while the reader scrolls, and each step highlights its node. Use this whenever the steps are a sequence.
- **How we know it worked.** A checklist of success signals, each with the observable it checks.
- **Open questions and risks.** Amber cards, one per item.
- **Deeper.** A `<details>` element, closed by default, with the technical detail and any code.
- **New terms.** A small table at the end, when the draft has one.

## Interactions

Pick the interaction that shows the idea. One strong interaction beats five decorative ones.

- **Slider** (`<input type="range">` driving inline SVG): when a quantity changes the outcome. Show the value and its effect side by side.
- **Before and after toggle**: when the change is the point. Two states of the same diagram, one button.
- **Step story** (Scrollama): when order matters.
- **Hover or tap to reveal**: when a diagram node needs a one-line definition. Use the project noun as the label and the plain definition as the reveal.

Animate with CSS transitions or the Web Animations API. Keep motion under 400 ms, and respect `prefers-reduced-motion`.

## Style

- Editorial, not dashboard. Generous whitespace, one accent colour, amber for risks.
- Body text at least 18 px, line length about 70 characters.
- Diagram labels use the project nouns exactly as `draft.md` does.

## Check

Open the page with the `/browse` skill. Read the console. Fix every error, then confirm each Mermaid block rendered and each interaction responds.
