#!/bin/bash
CUR=`pwd`
FONT_DIR=~/.local/share/fonts/
mkdir -p $FONT_DIR
cp $CUR/*.ttf $FONT_DIR/
fc-cache -f -v
fc-list | grep "Hack"

