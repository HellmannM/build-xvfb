#!/bin/bash

git clone https://gitlab.freedesktop.org/xorg/app/xkbcomp.git
git clone https://gitlab.freedesktop.org/xorg/proto/xorgproto.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxkbfile.git
git clone https://gitlab.freedesktop.org/xorg/util/macros.git
git clone https://gitlab.freedesktop.org/xorg/lib/libfontenc.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxfont.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxcvt.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxtrans.git
git clone https://gitlab.freedesktop.org/xorg/xserver.git

pushd xkbcomp
./autogen.sh
./configure
make
popd

pushd xorgproto
meson setup build --prefix=$PWD/install
pushd build
ninja
ninja install
popd
popd

pushd libxkbfile
meson setup build
pushd build
ninja
popd
popd

pushd macros
./autogen.sh
./configure
popd

pushd libfontenc
export ACLOCAL_PATH=$PWD/../macros
./autogen.sh
./configure
popd

pushd libxfont
export ACLOCAL_PATH=$PWD/../macros
export PKG_CONFIG_PATH=$PWD/../libfontenc
./autogen.sh
./configure
popd

pushd libxcvt
meson setup build --prefix="$PWD/install"
pushd build
ninja
ninja install
popd
popd

pushd libxtrans
./autogen.sh
./configure
popd

cp default_xkb.patch ./xserver/default_xkb.patch
export DEPS=$PWD/xorgproto/install/share/pkgconfig:$PWD/libxkbfile/build:$PWD/libxfont:$PWD/libfontenc:$PWD/libxcvt/install/lib64/pkgconfig:$PWD/libxtrans
pushd xserver
#git apply default_xkb.patch
PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" meson setup build --reconfigure -Dudev=false -Dudev_kms=false --prefix=$PWD/install
pushd build
ninja
ninja install
popd
popd
