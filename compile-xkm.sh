#!/bin/bash
./xkbcomp/xkbcomp -I/usr/share/X11/xkb -xkm default.xkb
cp default.xkm xkbdata/xkb/default.xkm
