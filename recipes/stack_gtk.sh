# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
#
# stack_gtk.sh -- sourced after glib-symbian's recipes/stack_env.sh (and stack_glib): the GTK layer of the Hildon stack.
#   stack_gtk            everything: the drawing stack, ATK, GDK + the Symbian backend, GTK, the pixmap engine -> the archives in /o
#   stack_gtk STEP...    only those steps (dbus-symbian needs "fetch fontconfig": the daemon links expat)
stack_gtk() {
  local steps=${*:-fetch freetype pixman hb zlibpng fontconfig cairo pango pixbuf atk gdk gdkbackend gtk pixmap archives} s
  stack_use gtk-symbian
  for s in $steps; do
    case $s in
      fetch)      stack_step gtk fetch "bash /h/recipes/fetch.sh" ;;
      zlibpng)    stack_step gtk zlibpng "bash /h/recipes/build_zlib_png_x32.sh" ;;
      hb)         stack_step gtk hb "bash /h/recipes/build_harfbuzz_x32.sh" ;;
      gdkbackend) stack_step gtk gdkbackend "bash /h/recipes/build_gdk_backend_x32.sh" ;;
      pixmap)     stack_step gtk pixmap "bash /h/recipes/build_pixmap_engine_x32.sh" ;;
      archives)   stack_step gtk archives "bash /h/recipes/package_x32.sh && cp /wk/out/libpixmap.a /o/libpixmap.a && mkdir -p /o/gmodule && python3 /glib/recipes/gen_symtab.py /h/os/src/pheengpixmap/pixmap.def /o/gmodule/pixmap.sym" ;;
      *)          stack_step gtk "$s" "bash /h/recipes/build_${s}_x32.sh" ;;
    esac
  done
  if [ -z "${*:-}" ]; then
    stack_need libphepixman.a libphefreetype.a libphehb.a libphepng.a libphefontconfig.a libphecairo.a libphepango.a libphepixbuf.a \
      libpheatk.a libphegdk.a libphegtk.a libpixmap.a gmodule/pixmap.sym
  fi
}
