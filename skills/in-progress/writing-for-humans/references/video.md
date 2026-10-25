# Video explainer

A 3Blue1Brown-style video: calm narration over shapes that move, appear, and transform to show the idea. Output goes to `.scratch/explain/<slug>/video/`.

- **Format:** 16:9, 1080p, 2 to 4 minutes.
- **Captions:** an `.srt` file next to the `.mp4`.
- **Engine:** Manim Community through `uvx`, with `manim-voiceover` for narration synced to animation.

## 1. Pick the voice

Check whether `ELEVENLABS_API_KEY` is set. Report only set or unset, never the value.

- **Set:** use `ElevenLabsService` from `manim-voiceover[elevenlabs]`.
- **Unset:** ask the user to choose. Suggest the options in this order:
  1. Give an ElevenLabs key.
  2. Kokoro (Apache 2.0, best open-source quality). `manim-voiceover` has no built-in Kokoro service, so write a small `SpeechService` subclass that calls `kokoro` and returns the audio path.
  3. macOS `say` through `PyttsxService`. Works with no setup, lower quality.

**Done when:** one speech service produces a short test clip the user approves.

## 2. Write the script

Turn `draft.md` into `video/script.md`: one scene per draft section, one narration paragraph per scene, and one line per scene describing what moves on screen. The narration keeps the draft's words and project nouns. Spoken sentences run shorter than written ones, so split any sentence over 20 words.

Show the script to the user before rendering.

## 3. Build the scenes

Write `video/scene.py` with one `VoiceoverScene` class named `Explainer` and one method per draft section, called in order from `construct`. One class gives one video and one caption file. Wrap each animation in `with self.voiceover(text=...) as tracker:` and size `run_time` from `tracker.duration`.

- Use `Text`, `Rectangle`, `Arrow`, and `VGroup`. Use `MathTex` only when the topic has formulas, because it needs a LaTeX install.
- Show change with `Transform` and `ReplacementTransform`, not with cuts. The same shape that means one thing early should become the next thing later.
- Use a dark background, one accent colour, and the project nouns as labels.

## 4. Render

```bash
uvx --with "manim-voiceover[<service>]" manim -qh video/scene.py Explainer
```

Manim writes the `.mp4` and, from the voiceover subcaptions, a matching `.srt`. Copy both to `video/<slug>.mp4` and `video/<slug>.srt`.

When `uvx manim` fails on cairo or pango, tell the user to run `! brew install cairo pango pkg-config` and retry.

**Done when:** the user has watched a preview render (`-ql`) and approved it, and the final `-qh` render plus captions exist.
