#!/bin/bash

LD_LIBRARY_PATH=./libxkbfile/install/lib64:$LD_LIBRARY_PATH ./xkbcomp/xkbcomp -I./xkbdata/xkb -xkm default.xkb
cp default.xkm xkbdata/xkb/default.xkm

