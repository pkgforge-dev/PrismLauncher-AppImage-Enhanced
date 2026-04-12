#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q prismlauncher | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg
export DESKTOP=/usr/share/applications/org.prismlauncher.PrismLauncher.desktop
export DEPLOY_QT=1
export QT_DIR=qt6
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun /usr/bin/prismlauncher /usr/bin/env

# Additional changes can be done in between here
# this app has problems with other locales breaking physics
echo 'LC_ALL=C.UTF-8' >> ./AppDir/.env

cc -shared -fPIC -O2 -o ./AppDir/lib/execve-sharun-hack.so execve-sharun-hack.c -ldl
echo 'execve-sharun-hack.so' >> ./AppDir/.preload
echo 'export ANYLINUX_EXECVE_WRAP_PATHS="$DATADIR"' >> ./AppDir/bin/execve-wrap-path.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
