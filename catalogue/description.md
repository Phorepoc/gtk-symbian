> GTK+ 2.24 with Cairo, Pango, GdkPixbuf and ATK, drawing straight into the window server: the toolkit under the Hildon UI.

GTK+ 2.24.33 for Phorepoc OS with its drawing stack (pixman, FreeType, HarfBuzz, fontconfig, Cairo, Pango, GdkPixbuf, ATK) and a GDK backend for the Symbian window server, including windows with per-pixel alpha and input shapes. It needs the GLib package; install that first.

The libraries are LGPL and the like, kept in DLLs of their own that you can replace. The package installs every licence text and the source offer in `\resource\gtk-symbian\licences\`. Needs: GLib (glib-symbian).
