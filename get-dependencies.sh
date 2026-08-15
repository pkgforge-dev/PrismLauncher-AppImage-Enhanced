#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    gamemode      \
    glfw          \
    kvantum       \
    lxqt-qtplugin \
    openal        \
    prismlauncher \
    qt6ct         \
    sdl3          \
    xorg-xrandr

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano
