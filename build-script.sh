#!/bin/bash


git clone https://gitlab.freedesktop.org/xorg/util/macros.git
git clone https://gitlab.freedesktop.org/xorg/app/xkbcomp.git
git clone https://gitlab.freedesktop.org/xorg/proto/xorgproto.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxkbfile.git
git clone https://gitlab.freedesktop.org/xorg/font/util.git
git clone https://gitlab.freedesktop.org/xorg/lib/libfontenc.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxfont.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxcvt.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxtrans.git
git clone https://gitlab.freedesktop.org/xorg/xserver.git

pushd macros
./autogen.sh
./configure --prefix=$PWD/install
make -j10
make install
export MACROS=$PWD/install/share/pkgconfig:$PWD/install/share/aclocal
popd

pushd xorgproto
meson setup build --prefix=$PWD/install
pushd build
ninja
ninja install
popd
export XORGPROTO=$PWD/install/share/pkgconfig
popd

pushd libxkbfile
meson setup build --prefix=$PWD/install
pushd build
ninja
ninja install
popd
export LIBXKBFILE=$PWD/install/share/pkgconfig:$PWD/build
popd

pushd xkbcomp
ACLOCAL_PATH=$MACROS:$LIBXKBFILE:$XORGPROTO:$ACLOCAL_PATH PKG_CONFIG_PATH=$MACROS:$LIBXKBFILE:$XORGPROTO:PKG_CONFIG_PATH ./autogen.sh
./configure --prefix=$PWD/install
make -j10
make install
export XKBCOMP=$PWD/install/lib/pkgconfig
popd

pushd util
./autogen.sh
./configure --prefix=$PWD/install
make -j10
make install
export UTIL=$PWD/install/lib/pkgconfig:$PWD/install/share/aclocal
popd

pushd libfontenc
ACLOCAL_PATH=$MACROS:$UTIL:$ACLOCAL_PATH PKG_CONFIG_PATH=$MACROS:$UTIL:$PKG_CONFIG_PATH ./autogen.sh
./configure --prefix=$PWD/install
make -j10
make install
export LIBFONTENC=$PWD/install/lib/pkgconfig:$PWD/install/share/aclocal
popd

pushd libxtrans
ACLOCAL_PATH=$MACROS:$ACLOCAL_PATH PKG_CONFIG_PATH=$MACROS:$PKG_CONFIG_PATH ./autogen.sh
./configure --prefix=$PWD/install
make -j10
make install
export LIBXTRANS=$PWD/install/share/pkgconfig:$PWD/install/share/aclocal:$PWD
popd

pushd libxfont
ACLOCAL_PATH=$MACROS:$LIBFONTENC:$LIBXTRANS:$UTIL:$ACLOCAL_PATH PKG_CONFIG_PATH=$MACROS:$LIBFONTENC:$LIBXTRANS:$UTIL:$PKG_CONFIG_PATH ./autogen.sh
./configure --prefix=$PWD/install
make -j10
make install
export LIBXFONT=$PWD/install/lib/pkgconfig
popd

pushd libxcvt
meson setup build --prefix="$PWD/install"
pushd build
ninja
ninja install
popd
export LIBXCVT=$PWD/install/lib64/pkgconfig
popd

#cp default_xkb.patch ./xserver/default_xkb.patch
pushd xserver
#git apply default_xkb.patch
PKG_CONFIG_PATH="$XORGPROTO:$LIBXKBFILE:$LIBXFONT:$LIBFONTENC:$LIBXCVT:$LIBXTRANS:$XKBCOMP:$PKG_CONFIG_PATH" meson setup build --reconfigure -Dudev=false -Dudev_kms=false --prefix=$PWD/install
pushd build
ninja
ninja install
popd
popd

