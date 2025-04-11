#!/bin/bash

CLONE_MACROS=1
CLONE_XORGPROTO=1
CLONE_LIBXKBFILE=1
CLONE_XKBCOMP=1
CLONE_UTIL=1
CLONE_LIBFONTENC=1
CLONE_LIBXTRANS=1
CLONE_LIBXFONT=1
CLONE_LIBXCVT=1
CLONE_LIBXDMCP=1
CLONE_XSERVER=1

APPLY_XSERVER_PATCH=1

BUILD_MACROS=1
BUILD_XORGPROTO=1
BUILD_LIBXKBFILE=1
BUILD_XKBCOMP=1
BUILD_UTIL=1
BUILD_LIBFONTENC=1
BUILD_LIBXTRANS=1
BUILD_LIBXFONT=1
BUILD_LIBXCVT=1
BUILD_LIBXDMCP=1
BUILD_XSERVER=1

##############################

[ "$CLONE_MACROS"       -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/util/macros.git
[ "$CLONE_XORGPROTO"    -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/proto/xorgproto.git
[ "$CLONE_LIBXKBFILE"   -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/lib/libxkbfile.git
[ "$CLONE_XKBCOMP"      -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/app/xkbcomp.git
[ "$CLONE_UTIL"         -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/font/util.git
[ "$CLONE_LIBFONTENC"   -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/lib/libfontenc.git
[ "$CLONE_LIBXTRANS"    -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/lib/libxtrans.git
[ "$CLONE_LIBXFONT"     -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/lib/libxfont.git
[ "$CLONE_LIBXCVT"      -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/lib/libxcvt.git
[ "$CLONE_LIBXDMCP"     -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/lib/libxdmcp.git
[ "$CLONE_XSERVER"      -eq 1 ] && git clone https://gitlab.freedesktop.org/xorg/xserver.git

pushd macros
if [ "$BUILD_MACROS" -eq 1 ]; then
    ./autogen.sh
    ./configure --prefix=$PWD/install
    make -j10
    make install
fi
export MACROS=$PWD/install/share/pkgconfig:$PWD/install/share/aclocal
popd

pushd xorgproto
if [ "$BUILD_XORGPROTO" -eq 1 ]; then
    meson setup build --prefix=$PWD/install
    pushd build
    ninja
    ninja install
    popd
fi
export XORGPROTO=$PWD/install/share/pkgconfig
popd

pushd libxkbfile
if [ "$BUILD_LIBXKBFILE" -eq 1 ]; then
    meson setup build --prefix=$PWD/install
    pushd build
    ninja
    ninja install
    popd
fi
export LIBXKBFILE=$PWD/install/lib64/pkgconfig
popd

pushd xkbcomp
if [ "$BUILD_XKBCOMP" -eq 1 ]; then
    DEPS="$MACROS:$LIBXKBFILE:$XORGPROTO"
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./autogen.sh
    ./configure --prefix=$PWD/install
    make -j10
    make install
fi
export XKBCOMP=$PWD/install/lib/pkgconfig
popd

pushd util
if [ "$BUILD_UTIL" -eq 1 ]; then
    DEPS="$MACROS"
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./autogen.sh
    ./configure --prefix=$PWD/install
    make -j10
    make install
fi
export UTIL=$PWD/install/lib/pkgconfig:$PWD/install/share/aclocal
popd

pushd libfontenc
if [ "$BUILD_LIBFONTENC" -eq 1 ]; then
    DEPS="$MACROS:$UTIL"
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./autogen.sh
    ./configure --prefix=$PWD/install
    make -j10
    make install
fi
export LIBFONTENC=$PWD/install/lib/pkgconfig:$PWD/install/share/aclocal
popd

pushd libxtrans
if [ "$BUILD_LIBXTRANS" -eq 1 ]; then
    DEPS="$MACROS"
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./autogen.sh
    ./configure --prefix=$PWD/install
    make -j10
    make install
fi
export LIBXTRANS=$PWD/install/share/pkgconfig:$PWD/install/share/aclocal:$PWD
popd

pushd libxfont
if [ "$BUILD_LIBXFONT" -eq 1 ]; then
    DEPS="$MACROS:$LIBFONTENC:$LIBXTRANS:$UTIL"
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./autogen.sh
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./configure --prefix=$PWD/install
    make -j10
    make install
fi
export LIBXFONT=$PWD/install/lib/pkgconfig
popd

pushd libxcvt
if [ "$BUILD_LIBXCVT" -eq 1 ]; then
    meson setup build --prefix="$PWD/install"
    pushd build
    ninja
    ninja install
    popd
fi
export LIBXCVT=$PWD/install/lib64/pkgconfig
popd

pushd libxdmcp
if [ "$BUILD_LIBXDMCP" -eq 1 ]; then
    DEPS="$MACROS:$LIBFONTENC:$LIBXKBFILE:$LIBXFONT:$LIBXCVT:$UTIL"
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./autogen.sh
    ACLOCAL_PATH="$DEPS:$ACLOCAL_PATH" PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" ./configure --prefix=$PWD/install
    make -j10
    make install
    popd
fi
export LIBXDMCP=$PWD/install/lib/pkgconfig
popd

pushd xserver
if [ "$APPLY_XSERVER_PATCH" -eq 1 ]; then
    cp ../default_xkb.patch ./default_xkb.patch
    git apply default_xkb.patch
fi
if [ "$BUILD_XSERVER" -eq 1 ]; then
    DEPS="$XORGPROTO:$LIBXKBFILE:$LIBXFONT:$LIBFONTENC:$LIBXCVT:$LIBXTRANS:$XKBCOMP:$LIBXDMCP"
    PKG_CONFIG_PATH="$DEPS:$PKG_CONFIG_PATH" meson setup build -Dudev=false -Dudev_kms=false -Dglx=true --prefix="$PWD/install"
    pushd build
    ninja
    ninja install
    popd
fi
popd

