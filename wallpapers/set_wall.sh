#! /bin/bash
#
feh --bg-fill $1
wal -i $1 &
cp $1 /usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png &
