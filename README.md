# gtk-symbian

GTK 2.24.33 for Phorepoc (PC image, x86-64 / x32 ABI) with its GDK Symbian backend (WSERV windows, taps, window-manager filters, occlusion-clipped drawing), ATK, and the drawing stack
GTK sits on: pixman 0.42.2, freetype 2.13.3, harfbuzz, fontconfig 2.14.2 + expat, cairo 1.16.0, pango 1.40.14, gdk-pixbuf 2.36.12, libpng + zlib.
Each is an app-private DLL (phepixman, phefreetype, phehb, phefontconfig, phecairo, phepango, phepixbuf, phepng, pheatk, phegdk, phegtk) with a frozen-ordinal .def.
Tests and demos: `pheglibtest` (the stack self test, still the GLib test too: follow-up, split the GLib half into glib-symbian), `phecairowin`, `phegdkwin`, `phegtkwin`.
Requires: glib-symbian built into the same volume.

Nothing here is in an OS image; it is a Catalogue download (SIS with licences and the source offer). Recipes are BSD-2-Clause, the libraries LGPL (see NOTICE).
Build: `REPO=<Symbian-ReverseEngineered checkout> bash recipes/build.sh [steps]` (Git Bash, Docker up). The four repositories sit side by side and share one docker
volume (`VOL`, default hildon-wk) as the build tree and `$REPO/.phorepoc-x86-build/hildon/` as the archive directory; the sibling repositories are mounted read-only at
/glib /gtk /dbus in every container. Plan and findings: `docs/phorepoc/hildon-port.md` in Symbian-ReverseEngineered.

Dependency graph:  glib-symbian  <-  gtk-symbian  <-  hildon-ui  ->  dbus-symbian  ->  glib-symbian
