#!/usr/bin/env bash
# patch_leste.sh -- IN phorepoc-x86 (volume at /wk, this repo at /h): the Maemo ("hildonize") patches of Maemo Leste's GTK+ 2 (github.com/maemo-leste/gtk, debian/patches/hildonize-*.diff, GTK 2.24.25 based, kept as files in
# patches/leste/) applied to the GTK+ 2.24.33 tree: HildonMode, hildon_gtk_widget_set_theme_size, the touch-friendly tree view / menu / dialog / entry / text view / icon view, tap-and-hold, the
# 'hildon-row-tapped' signal ... Two hunks do not apply to 2.24.33 as they are; patches/leste/fixup_leste.py is the same change written against it. Idempotent (marker file); the gdk and gtk
# trees are extracted afresh first so a patch is never applied twice.
set -eu
. /gtk/recipes/pins.sh 2>/dev/null || . /h/recipes/pins.sh
G=/wk/gtk+-$GTK_VER
[ -f $G/.leste-patched ] && exit 0
cd /wk; tar xf /h/dl/gtk+-$GTK_VER.tar.xz gtk+-$GTK_VER/gdk gtk+-$GTK_VER/gtk gtk+-$GTK_VER/COPYING gtk+-$GTK_VER/config.h.win32 gtk+-$GTK_VER/configure.ac 2>/dev/null || tar xf /h/dl/gtk+-$GTK_VER.tar.xz gtk+-$GTK_VER/gdk gtk+-$GTK_VER/gtk
cd $G
for p in enums gdk-window gtk-container gtk-window gtk-menu gtk-widget gtk-imcontext gtk-entry gtk-dialog gtk-textview gtk-rbtree gtk-treeview gtk-iconview; do
  f=$(ls /h/patches/leste/hildonize-*$p*.diff | head -1); patch -p1 -s --no-backup-if-mismatch < $f || true
done
python3 /h/patches/leste/fixup_leste.py $G
python3 /h/patches/leste/regen_typebuiltins.py $G
find . -name "*.rej" -o -name "*.orig" | xargs rm -f
touch .leste-patched; echo "leste patches applied to $G"
