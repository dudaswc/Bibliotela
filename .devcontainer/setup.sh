#!/usr/bin/env bash
# Instala o Flutter (canal stable) uma vez, quando o Codespace é criado.
set -e

sudo apt-get update -y
sudo apt-get install -y unzip xz-utils zip curl git

if [ ! -d "$HOME/flutter" ]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$HOME/flutter"
fi

export PATH="$PATH:$HOME/flutter/bin"
flutter config --no-analytics || true
flutter precache --web
flutter --version
flutter pub get
