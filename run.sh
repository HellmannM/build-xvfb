#!/bin/bash

module load tools/bzip2/1.0.8-GCCcore-12.3.0
module load vis/Mesa/23.1.4-GCCcore-12.3.0

export XKBFILE=$PWD/libxkbfile/install/lib64
export XFONT2=$PWD/libxfont/install/lib

export XKBDIR=$PWD/xkbdata/xkb
export XKB_BINDIR=$PWD/xkbcomp

LIBGL_ALWAYS_INDIRECT=1 LD_LIBRARY_PATH=$XKBFILE:$XFONT2:$LD_LIBRARY_PATH $PWD/xserver/install/bin/Xvfb :99 -nolisten tcp +extension GLX +extension RENDER +extension DOUBLE-BUFFER

#env DISPLAY=:99 vglrun glxinfo
