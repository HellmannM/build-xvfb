#!/bin/bash

module load tools/bzip2/1.0.8-GCCcore-12.3.0

export XKBFILE=$PWD/libxkbfile/install/lib64
export XFONT2=$PWD/libxfont/install/lib

export XKBDIR=$PWD/xkbdata/xkb
export XKB_BINDIR=$PWD/xkbcomp

LD_LIBRARY_PATH=$XKBFILE:$XFONT2:$LD_LIBRARY_PATH $PWD/xserver/install/bin/Xvfb :99 -nolisten tcp

