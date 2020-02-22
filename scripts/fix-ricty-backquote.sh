#!/usr/bin/env bash

set -uex

if [ "$(uname)" != 'Darwin' ]; then
  echo "Aborted: This script for macOS, your platform seems not."
  exit 1
fi

type fontforge >/dev/null || (echo "Aborted: fontforge is not on PATH"; exit 1)

for fontfile in $(ls ~/Library/Fonts/Ricty*.ttf); do
  fontforge -lang=ff -c 'Open($1); Select(0u0060); SetGlyphClass("base"); Generate($1)' $fontfile
done

# ref: https://qiita.com/uKLEina/items/ff0877871fc425952b92#comment-74375ba083e256f6c787
