#!/usr/bin/env bash
# Installs the video toolchain used for editing, captions and motion graphics.
# Safe to run many times: anything already installed is skipped.
#   bash .claude/setup-video-tools.sh
set -u

TOOLS_DIR="${TOOLS_DIR:-/opt/tools}"
WHISPER_DIR="$TOOLS_DIR/whisper.cpp"
WHISPER_MODEL="large-v3-turbo-q5_0"   # good Spanish accuracy, ~550 MB
ok()   { printf '  [ok] %s\n' "$1"; }
warn() { printf '  [!!] %s\n' "$1"; }

echo "== Video tools setup"

# 1. FFmpeg (usually preinstalled)
if command -v ffmpeg >/dev/null 2>&1; then ok "ffmpeg"; else
  (apt-get update -qq && apt-get install -y -qq ffmpeg >/dev/null 2>&1) && ok "ffmpeg installed" || warn "ffmpeg missing and could not be installed"
fi

# 2. yt-dlp + Python helpers (image cutouts, logo vectorizing)
pip3 install -q -U yt-dlp numpy scipy opencv-python-headless potracer pillow >/dev/null 2>&1 \
  && ok "yt-dlp + python helpers" || warn "pip install failed"

# 3. gifsicle (GIF optimizer for email signatures)
if command -v gifsicle >/dev/null 2>&1; then ok "gifsicle"; else
  npm i -g --silent gifsicle@5 >/dev/null 2>&1
  G="$(npm root -g)/gifsicle/vendor/gifsicle"
  [ -x "$G" ] && ln -sf "$G" /usr/local/bin/gifsicle && ok "gifsicle installed" || warn "gifsicle could not be installed"
fi

# 4. whisper.cpp (speech-to-text for captions)
mkdir -p "$TOOLS_DIR"
if [ ! -x "$WHISPER_DIR/build/bin/whisper-cli" ]; then
  [ -d "$WHISPER_DIR" ] || git clone -q --depth 1 https://github.com/ggml-org/whisper.cpp.git "$WHISPER_DIR"
  (cd "$WHISPER_DIR" && cmake -B build -DCMAKE_BUILD_TYPE=Release -DWHISPER_BUILD_TESTS=OFF >/dev/null \
    && cmake --build build -j"$(nproc)" --config Release >/dev/null 2>&1) \
    && ok "whisper.cpp built" || warn "whisper.cpp build failed"
else ok "whisper.cpp"; fi
[ -x "$WHISPER_DIR/build/bin/whisper-cli" ] && ln -sf "$WHISPER_DIR/build/bin/whisper-cli" /usr/local/bin/whisper-cli

# 5. Whisper model (needs huggingface.co and *.hf.co allowed in the network settings)
MODEL_FILE="$WHISPER_DIR/models/ggml-$WHISPER_MODEL.bin"
if [ -s "$MODEL_FILE" ]; then ok "whisper model ($WHISPER_MODEL)"; else
  (cd "$WHISPER_DIR" && sh ./models/download-ggml-model.sh "$WHISPER_MODEL" >/dev/null 2>&1) \
    && [ -s "$MODEL_FILE" ] && ok "whisper model downloaded" \
    || warn "whisper model not downloaded (allow huggingface.co and us.aws.cdn.hf.co in network settings)"
fi

echo "== Done"
