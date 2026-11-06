#!/usr/bin/env bash
# Instala o Flutter (canal stable) uma vez, quando o Codespace e criado, e
# baixa as dependencias de cada projeto do repositorio.
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

# Dart puro: o servidor e o core. Flutter: o design system e os dois apps.
for dir in server packages/core; do
  [ -f "$dir/pubspec.yaml" ] && (cd "$dir" && dart pub get) || true
done
for dir in packages/design_system apps/catalog apps/mobile; do
  [ -f "$dir/pubspec.yaml" ] && (cd "$dir" && flutter pub get) || true
done
