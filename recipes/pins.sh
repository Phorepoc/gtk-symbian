# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
# pins.sh -- exact upstream versions + checksums; sourced after glib-symbian pins
PIXMAN_VER=0.42.2
PIXMAN_SHA256=ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e
PIXMAN_URL=https://cairographics.org/releases/pixman-$PIXMAN_VER.tar.gz
CAIRO_VER=1.16.0
CAIRO_SHA256=5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331
CAIRO_URL=https://cairographics.org/releases/cairo-$CAIRO_VER.tar.xz
FREETYPE_VER=2.13.3
FREETYPE_SHA256=0550350666d427c74daeb85d5ac7bb353acba5f76956395995311a9c6f063289
FREETYPE_URL=https://download.savannah.gnu.org/releases/freetype/freetype-$FREETYPE_VER.tar.xz
HARFBUZZ_VER=15.1.0
HARFBUZZ_SHA256=0fc7c565443a5f4be7da65ac5ee5bd737d9b158dc908708b7689a0a5796b0c8d
HARFBUZZ_URL=https://github.com/harfbuzz/harfbuzz/releases/download/$HARFBUZZ_VER/harfbuzz-$HARFBUZZ_VER.tar.xz
EXPAT_VER=2.5.0
EXPAT_SHA256=ef2420f0232c087801abf705e89ae65f6257df6b7931d37846a193ef2e8cdcbe
EXPAT_URL=https://github.com/libexpat/libexpat/releases/download/R_2_5_0/expat-$EXPAT_VER.tar.xz
FONTCONFIG_VER=2.14.2
FONTCONFIG_SHA256=dba695b57bce15023d2ceedef82062c2b925e51f5d4cc4aef736cf13f60a468b
FONTCONFIG_URL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-$FONTCONFIG_VER.tar.xz
PANGO_VER=1.40.14
PANGO_SHA256=90af1beaa7bf9e4c52db29ec251ec4fd0a8f2cc185d521ad1f88d01b3a6a17e3
PANGO_URL=https://download.gnome.org/sources/pango/1.40/pango-$PANGO_VER.tar.xz
ZLIB_VER=1.3.1
ZLIB_SHA256=38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32
ZLIB_URL=https://github.com/madler/zlib/releases/download/v$ZLIB_VER/zlib-$ZLIB_VER.tar.xz
LIBPNG_VER=1.6.43
LIBPNG_SHA256=6a5ca0652392a2d7c9db2ae5b40210843c0bbc081cbd410825ab00cc59f14a6c
LIBPNG_URL=https://download.sourceforge.net/libpng/libpng-$LIBPNG_VER.tar.xz
GDKPIXBUF_VER=2.36.12
GDKPIXBUF_SHA256=fff85cf48223ab60e3c3c8318e2087131b590fd6f1737e42cb3759a3b427a334
GDKPIXBUF_URL=https://download.gnome.org/sources/gdk-pixbuf/2.36/gdk-pixbuf-$GDKPIXBUF_VER.tar.xz
GTK_VER=2.24.33
GTK_SHA256=ac2ac757f5942d318a311a54b0c80b5ef295f299c2a73c632f6bfb1ff49cc6da   # = download.gnome.org gtk+-2.24.33.sha256sum (verified 2026-11-07); LGPL 2.1+
GTK_URL=https://download.gnome.org/sources/gtk+/2.24/gtk+-$GTK_VER.tar.xz
ATK_VER=2.38.0
ATK_SHA256=ac4de2a4ef4bd5665052952fe169657e65e895c5057dffb3c2a810f6191a0c36   # = download.gnome.org atk-2.38.0.sha256sum; SHA512 dffd0a08...2c77 = Gentoo Manifest (verified 2026-11-07); LGPL 2+; GTK 2.24 needs atk >= 2.10
ATK_URL=https://download.gnome.org/sources/atk/2.38/atk-$ATK_VER.tar.xz
# Verification record (2026-11-07), each against a source other than this file:
#  glib, pango, gdk-pixbuf: download.gnome.org .sha256sum files.  pixman: cairographics.org .sha512 (file matches).  cairo: cairographics.org .sha1 + Fedora sources sha512.
#  freetype, expat: upstream GPG signatures verify (Werner Lemberg, Sebastian Pipping).  libffi, libpng: Arch packaging sha256.  fontconfig: Fedora f38-f40 `sources` sha512.
#  zlib: Arch packaging sha512 for the .tar.xz (so the pin is the .tar.xz, not the .tar.gz).  harfbuzz 15.1.0: GitHub release asset digest (real release, 04 Nov).
