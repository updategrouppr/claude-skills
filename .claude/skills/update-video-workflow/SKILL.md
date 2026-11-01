---
name: update-video-workflow
description: Default toolchain and house rules for any video, reel, TikTok, YouTube video, caption/subtitle, motion graphics, brand video, animated logo or animated GIF / email signature request. Use it before starting that work so the right tools (Remotion, HyperFrames, /brag, whisper.cpp, FFmpeg, gifsicle) are installed and used without the user asking. Also triggers when the user uploads raw clips to edit, asks for subtitles in Spanish, or asks for a promo video from a brand kit or website.
---

# Video workflow (Update Group)

Use these tools by default. The user should not have to name them.

## 1. Check the toolchain first

```bash
command -v whisper-cli gifsicle yt-dlp ffmpeg >/dev/null || bash "<this skill folder>/scripts/setup-video-tools.sh"
```

The script is idempotent (about 4 s when everything is present). The first run builds whisper.cpp and downloads a ~550 MB model.

## 2. Pick the tool

- **Remotion**: default for edited videos and motion graphics. Load the `remotion-best-practices` skill first; it routes to the other `remotion-*` skills.
- **HyperFrames** (`hyperframes`, `hyperframes-cli`, `hyperframes-registry`, `media-use`): when the user asks for it, or when a ready-made HyperFrames block fits better than building by hand.
- **/brag** and **/brag-slim**: short launch videos of a website or project.
- **whisper.cpp**: speech to text for captions. Extract audio, then transcribe with word timings:
  ```bash
  ffmpeg -i clip.mp4 -ar 16000 -ac 1 audio.wav
  whisper-cli -m /opt/tools/whisper.cpp/models/ggml-large-v3-turbo-q5_0.bin -f audio.wav -l es -ml 1 -sow -oj -dtw large.v3.turbo
  ```
  Proofread Puerto Rican Spanish (e.g. "maones" = jeans, "un chin" = a little).
- **FFmpeg**: trimming, 1080x1920 scaling, `loudnorm`, splitting scenes, GIF palettes.
- **gifsicle**: shrink GIFs with `gifsicle -O3 --lossy=60`.
- **yt-dlp**: download reference videos from links the user provides.

## 3. Rendering in cloud sessions

- Remotion cannot download its own browser there. In `remotion.config.ts` use the preinstalled one (check the folder with `ls /opt/pw-browsers`):
  `Config.setBrowserExecutable("/opt/pw-browsers/chromium_headless_shell-1243/chrome-linux64/chrome-headless-shell")`
- Google Fonts may be blocked; load fonts from `@fontsource/*` npm packages.
- Keep projects and renders in the scratchpad, not in the user's repo. Send finished files to the user.

## 4. Defaults for social video

- Vertical 1080x1920, 30 fps for Reels/TikTok. Offer a 1920x1080 YouTube cut and a 1280x720 thumbnail.
- Keep captions and stickers out of the bottom ~20% (platform UI).
- TikTok-style captions: 2-3 words per page, active word highlighted, keywords in a brand accent color.
- Music bundled with `/brag` is CC BY 4.0. Tell the user to credit: "Music: Sascha Ende, ende.app (CC BY 4.0)".
- No medical or health promises in ad copy (Meta ads policy).
- Check stills of key frames before the full render; fix overflow and text overlaps first.

## 5. Animated email signatures

- Classic Outlook for Windows shows only frame 0: make frame 0 a complete design with nothing covering text.
- Keep the background static so the GIF stays under ~500 KB. Display at 600 px wide.
- Deliver a GIF, a static PNG and an HTML version with clickable links under the image.

## 6. Network

If a download fails with a 403 from the proxy, the host is not allowed in that session. Tell the user which domain to add in the environment's network settings. Do not work around it.
