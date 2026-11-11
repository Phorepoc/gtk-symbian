#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
# build.sh -- the drawing stack (pixman, freetype, harfbuzz, fontconfig, cairo, pango, gdk-pixbuf), ATK, GDK + the Symbian backend, GTK 2.24.33 and the booted self tests (needs glib-symbian built into the same VOL). Host side, Git Bash, Docker Desktop up.
#
#   REPO=<Symbian-ReverseEngineered checkout>  bash recipes/build.sh [steps]
# steps (default: all, in order): fetch freetype pixman hb zlibpng fontconfig cairo pango pixbuf atk gdk gdkbackend gtk archives defs images boot
# The sibling repositories (glib-symbian, gtk-symbian, dbus-symbian, hildon-ui) are expected next to this one; they are mounted at /glib /gtk /dbus (read-only) in every container,
# this repository at /h. The docker volume (VOL) is the shared build tree of the whole stack; OUTD (the archives) is $REPO/.phorepoc-x86-build/hildon.
set -eu
HERE=$(cd "$(dirname "$0")/.." && pwd -W); REPO=${REPO:-C:/Users/memph/Git/Symbian-ReverseEngineered}; VOL=${VOL:-hildon-wk}; PARENT=${HERE%/*}; SIB="-v $PARENT/glib-symbian:/glib:ro -v $PARENT/gtk-symbian:/gtk:ro -v $PARENT/dbus-symbian:/dbus:ro"
STEPS=${*:-fetch freetype pixman hb zlibpng fontconfig cairo pango pixbuf atk gdk gdkbackend gtk archives defs images boot}
OUTD=$REPO/.phorepoc-x86-build/hildon; mkdir -p "$OUTD"
IMG=phorepoc-x86
dr() { MSYS_NO_PATHCONV=1 docker.exe run --rm --name "hildon-$1" -e JOBS="${JOBS:-8}" -v "$HERE":/h $SIB -v "$REPO":/repo:ro -v "$OUTD":/o -v "$VOL":/wk $IMG "${@:2}"; }
has() { case " $STEPS " in *" $1 "*) return 0;; esac; return 1; }
[ "${CLEAN:-0}" = 1 ] && { docker.exe volume rm "$VOL" >/dev/null 2>&1 || true; }
docker.exe volume create "$VOL" >/dev/null
has fetch    && { echo "== fetch";    bash "$HERE/recipes/fetch.sh"; }
has freetype && { echo "== freetype"; dr f1 bash /h/recipes/build_freetype_x32.sh | tail -3; }
has pixman   && { echo "== pixman";   dr p1 bash /h/recipes/build_pixman_x32.sh | tail -8; }
has hb       && { echo "== harfbuzz"; dr h1 bash /h/recipes/build_harfbuzz_x32.sh | tail -3; }
has zlibpng  && { echo "== zlib+png"; dr z1 bash /h/recipes/build_zlib_png_x32.sh | tail -3; }
has fontconfig && { echo "== fontconfig"; dr fc1 bash /h/recipes/build_fontconfig_x32.sh | tail -4; }
has cairo    && { echo "== cairo";    dr c2 bash /h/recipes/build_cairo_x32.sh | tail -8; }
has pango    && { echo "== pango";    dr pg1 bash /h/recipes/build_pango_x32.sh | tail -6; }
has pixbuf   && { echo "== pixbuf";   dr px1 bash /h/recipes/build_pixbuf_x32.sh | tail -4; }
has atk       && { echo "== atk";        dr atk bash /h/recipes/build_atk_x32.sh | tail -25; }
has gdk      && { echo "== gdk core";  dr gd1 bash /h/recipes/build_gdk_x32.sh | tail -3; }
has gdkbackend && { echo "== gdk backend"; dr gd2 bash /h/recipes/build_gdk_backend_x32.sh | tail -4; }
has gtk       && { echo "== gtk";        dr gtk bash /h/recipes/build_gtk_x32.sh | tail -12; }
has archives && { echo "== archives"; dr a1 bash /h/recipes/package_x32.sh; }
has defs     && { echo "== defs";     dr d1 python3 /h/recipes/gen_defs.py /o /h/os/src; }
has boot     && { echo "== boot";     ( cd "$REPO" && bash "$HERE/recipes/iterate.sh" ); }
has images   && { echo "== images";   ( cd "$REPO" && ./ph build phepng phepixman phefreetype phehb phefontconfig phecairo phepango phepixbuf pheatk phegdk phegtk phecairowin phegdkwin phegtkwin pheglibtest ) | tail -3; }
echo "build.sh: done ($STEPS)"
