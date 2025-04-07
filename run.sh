#!/bin/bash

export XFONT2=$PWD/libxfont/install/lib
export XKBDIR=$PWD
export XKB_BINDIR=$PWD/xkbcomp
LD_LIBRARY_PATH=$XFONT2:$LD_LIBRARY_PATH $PWD/xserver/install/bin/Xvfb :99

