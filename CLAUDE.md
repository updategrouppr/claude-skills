# Notes for Claude

## Video, motion graphics and animated assets

Use these tools by default for any video, reel, animation, caption or GIF work. The user should not have to ask for them.

**Before starting video work**, check the toolchain and install what is missing:

```bash
command -v whisper-cli gifsicle yt-dlp ffmpeg || bash .claude/setup-video-tools.sh
```

### Which tool for what

- **Remotion** (default for edited and motion-graphics videos). Load the `remotion-best-practices` skill first; it routes to the other `remotion-*` skills (captions, render, studio...).
- **HyperFrames** (`hyperframes`, `hyperframes-cli`, `hyperframes-registry`, `media-use` skills). Use it when the user asks for it, or when a ready-made HyperFrames block fits better than building by hand.
- **/brag** and **/brag-slim**: short launch videos of a website or project.
- **whisper.cpp**: transcribe speech for captions. Spanish works well:
  `whisper-cli -m /opt/tools/whisper.cpp/models/ggml-large-v3-turbo-q5_0.bin -f audio.wav -l es -ml 1 -sow -oj -dtw large.v3.turbo`
  (extract audio first: `ffmpeg -i clip.mp4 -ar 16000 -ac 1 audio.wav`). Proofread Puerto Rican slang (e.g. "maones" = jeans).
- **FFmpeg**: trimming, scaling, loudness (`loudnorm`), splitting scenes, GIF palettes.
- **gifsicle**: shrink GIFs (`gifsicle -O3 --lossy=60`).
- **yt-dlp**: download reference videos when the user provides a link.

### Rendering in this cloud environment

- Remotion cannot download its own browser here. In `remotion.config.ts` use the preinstalled one:
  `Config.setBrowserExecutable("/opt/pw-browsers/chromium_headless_shell-1243/chrome-linux64/chrome-headless-shell")`
  (check the folder name with `ls /opt/pw-browsers`).
- Google Fonts may be blocked; load fonts from `@fontsource/*` npm packages instead.
- Keep project files and renders in the session scratchpad, not in this repo. Send finished files to the user.

### Defaults for social video

- Vertical 1080x1920 at 30 fps for Reels/TikTok; offer a 1920x1080 YouTube version and a 1280x720 thumbnail.
- Keep captions and stickers out of the bottom ~20% (platform UI covers it).
- Music from the `brag` skill assets is CC BY 4.0: tell the user to credit "Music: Sascha Ende, ende.app (CC BY 4.0)".
- Avoid medical or health promises in ad copy (Meta ads policy).

### Email signatures (GIF)

- Classic Outlook for Windows shows only the first frame: make frame 0 a complete design.
- Keep the background static so the GIF stays under ~500 KB; display at 600 px wide.
- Deliver an HTML version too, with clickable links under the image.

### Network

If a download fails with a 403 from the proxy, the host is not allowed. Tell the user which domain to add in the environment's network settings; do not try to work around it.
