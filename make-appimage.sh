#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q prismlauncher | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg
export DESKTOP=/usr/share/applications/org.prismlauncher.PrismLauncher.desktop
export DEPLOY_VULKAN=1
export DEPLOY_PULSE=1

# Deploy dependencies
quick-sharun /usr/bin/prismlauncher /usr/lib/libglfw.so* /usr/lib/libopenal.so* /usr/lib/libSDL3.so* /usr/bin/env

# this app has problems with other locales breaking physics
echo 'LC_ALL=C.UTF-8' >> ./AppDir/.env

cc -shared -fPIC -O2 -o ./AppDir/lib/execve-sharun-hack.so execve-sharun-hack.c -ldl
echo 'execve-sharun-hack.so' >> ./AppDir/.preload
echo 'export ANYLINUX_EXECVE_WRAP_PATHS="$DATADIR"' >> ./AppDir/bin/execve-wrap-path.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
