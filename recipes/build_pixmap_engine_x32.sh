#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
# build_pixmap_engine_x32.sh -- IN phorepoc-x86 (volume at /wk, this repo at /h, siblings at /glib): the GTK "pixmap" theme engine = modules/engines/pixbuf of GTK+ 2.24.33 (libpixmap.so there; LGPL-2.1+),
# compiled from the pinned tarball as libpixmap.a -> pixmap.dll (os/src/pheengpixmap). Theme rc files (hildon-theme-alpha) use engine "pixmap" for the widgets sapwood does not draw.
# Out: /wk/pixmap-x32/*.o, /wk/out/libpixmap.a
set -eu
. /glib/recipes/pins.sh; . /h/recipes/pins.sh
CC=/wk/lsc/bin/pp-gcc; G=/wk/gtk+-$GTK_VER; O=/wk/pixmap-x32; mkdir -p $O /wk/out
[ -d $G/modules/engines/pixbuf ] || (cd /wk && tar xf /h/dl/gtk+-$GTK_VER.tar.xz gtk+-$GTK_VER/modules/engines/pixbuf)
S=$G/modules/engines/pixbuf
echo '#define GETTEXT_PACKAGE "gtk20"' > $O/config.h
X32="-I/wk/x32 -I/wk/x32/glib -I/wk/glib-2.56.4 -I/wk/glib-2.56.4/glib -I/wk/glib-2.56.4/gobject -I/wk/glib-2.56.4/gmodule -I/wk/glib-2.56.4/gio -I/wk/ffi-x32/include"
FF="-O2 -g0 -w -fno-pic -I/glib/overlay -include /glib/overlay/phe_glib_compat.h -include /wk/gdk-x32/gtkcompat.h -DHAVE_CONFIG_H -I$O -I$S -I$G -I$G/gtk -I$G/gdk -I/wk/gdk-x32 -I/wk/atk-$ATK_VER -I/wk/gtk-x32 -I/wk/gtk-x32/inc $X32 \
 -I/wk/cairo-1.16.0/src -I/wk/cairo-x32/src -I/wk/pixman-0.42.2/pixman -I/wk/pango-1.40.14 -I/wk/pango-x32 -I/wk/harfbuzz-$HARFBUZZ_VER/src -I/wk/fontconfig-2.14.2 -I/wk/freetype-2.13.3/include -I/wk/gdk-pixbuf-2.36.12 -I/wk/pixbuf-x32"
rm -f $O/*.o $O/errs.*
for f in pixbuf-draw pixbuf-main pixbuf-rc-style pixbuf-render; do $CC $FF -c $S/$f.c -o $O/$f.o 2> $O/errs.$f || echo "FAIL $f"; done
cat $O/errs.* > $O/errors.txt 2>/dev/null || true; grep -a "error" $O/errors.txt | cut -c1-200 | head -20
rm -f /wk/out/libpixmap.a; ar rcs /wk/out/libpixmap.a $O/*.o; echo "libpixmap.a: $(ar t /wk/out/libpixmap.a | wc -l) members"
