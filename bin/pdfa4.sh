#!/usr/bin/env zsh
out="${2:-$1}"
out="${out%.*}.pdf"

exec convert "$1" \
  -compress jpeg -quality 75 \
  -resize 1240x1754 -extent 1240x1754 \
  -gravity center -units PixelsPerInch \
  -density 150x150 \
  "$out"
