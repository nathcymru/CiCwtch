#!/usr/bin/env bash
# Cloudflare Pages build script for CiCwtch Flutter web app.
# Installs the Flutter SDK and builds the web release.
#
# Cloudflare Pages project settings:
#   Root directory    : flutter
#   Build command     : bash scripts/cloudflare-pages-build.sh
#   Build output dir  : build/web

set -euo pipefail

FLUTTER_BRANCH="stable"
FLUTTER_DIR="$HOME/flutter_sdk"

echo "==> Installing Flutter SDK ($FLUTTER_BRANCH)..."
git clone --depth 1 --branch "$FLUTTER_BRANCH" \
  https://github.com/flutter/flutter.git "$FLUTTER_DIR"
export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --no-analytics

echo "==> Installing dependencies..."
flutter pub get

echo "==> Building web release..."
BUILD_ARGS=(--release)
if [ -n "${API_BASE_URL:-}" ]; then
  echo "    API_BASE_URL=$API_BASE_URL"
  BUILD_ARGS+=(--dart-define="API_BASE_URL=$API_BASE_URL")
fi
flutter build web "${BUILD_ARGS[@]}"

echo "==> Build complete. Output in build/web"
