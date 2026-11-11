# Copyright The Phorepoc Authors
# SPDX-License-Identifier: LGPL-2.1-or-later
# fixup_leste.py TREE -- the two hunks of Leste's hildonize patches (maemo-leste/gtk, GTK 2.24.25) that do not apply to GTK 2.24.33 as they are (the code around them changed upstream
# between 2.24.25 and 2.24.33); the same change, written against 2.24.33. Run after the hildonize-*.diff files (build_gtk_x32.sh does).
import sys

d = sys.argv[1]

p = d + '/gtk/gtkcontainer.c'
s = open(p).read()
a = s.index('  /* Check for h/v adjustments and scroll to show the focus child if possible */')
b = s.index('static GList*\nget_focus_chain', a)
new = '''  container_scroll_focus_adjustments (container, FALSE);
}

static void
container_scroll_focus_adjustments (GtkContainer *container, gboolean resize_update)
{
  /* Check for h/v adjustments and scroll to show the focus child if possible */
  if (container->focus_child)
    {
      GtkAdjustment *hadj;
      GtkAdjustment *vadj;
      GtkWidget *focus_child;
      gint x, y;

      hadj = g_object_get_qdata (G_OBJECT (container), hadjustment_key_id);
      vadj = g_object_get_qdata (G_OBJECT (container), vadjustment_key_id);
      if (hadj || vadj)
	{
	  gboolean valid_coordinates = FALSE;

	  focus_child = container->focus_child;
	  while (GTK_IS_CONTAINER (focus_child) &&
		 GTK_CONTAINER (focus_child)->focus_child)
	    {
	      focus_child = GTK_CONTAINER (focus_child)->focus_child;
	    }

	  valid_coordinates = gtk_widget_translate_coordinates (focus_child, container->focus_child, 0, 0, &x, &y);

	  x += container->focus_child->allocation.x;
	  y += container->focus_child->allocation.y;

	  if (vadj)
	    {
	      /* When updating the adjustments as a result of container resize (resize_update=TRUE) force the focused widget visible only if
	       * it is smaller than the viewport. Otherwise the updates start to oscillate between two values. */
	      if ((valid_coordinates && !resize_update) || focus_child->allocation.height < vadj->page_size)
		gtk_adjustment_clamp_page (vadj, y, y + focus_child->allocation.height);
	    }

	  if (hadj)
	    {
	      if ((valid_coordinates && !resize_update) || focus_child->allocation.width < hadj->page_size)
		gtk_adjustment_clamp_page (hadj, x, x + focus_child->allocation.width);
	    }
	}
    }
}

'''
s = s[:a] + new + s[b:]
open(p, 'w').write(s)

p = d + '/gtk/gtktreeview.c'
s = open(p).read()
old = '''	  if (tree_view->priv->selection->type == GTK_SELECTION_MULTIPLE)
	    gtk_tree_view_real_set_cursor (tree_view, cursor_path, FALSE, FALSE);
	  else
	    gtk_tree_view_real_set_cursor (tree_view, cursor_path, TRUE, FALSE);'''
new = '''	  if ((tree_view->priv->selection->type == GTK_SELECTION_MULTIPLE ||
	       tree_view->priv->selection->type == GTK_SELECTION_SINGLE)
	      && tree_view->priv->hildon_mode == HILDON_DIABLO)
	    {
	      gtk_tree_view_real_set_cursor (tree_view, cursor_path, FALSE, FALSE);
	    }
	  else
	    gtk_tree_view_real_set_cursor (tree_view, cursor_path, TRUE, FALSE);'''
assert old in s
s = s.replace(old, new, 1)
open(p, 'w').write(s)
print('leste fixups applied')

# --- the X11 parts of the patches (this system has no X server): the window manager hint the dialog reads, and the server time of a tap and hold ---
p = d + '/gtk/gtkdialog.c'
s = open(p).read()
for inc in ('#include <X11/Xlib.h>\n', '#include <X11/Xatom.h>\n', '#include "x11/gdkx.h"\n'):
    assert inc in s, inc
    s = s.replace(inc, '', 1)
a = s.index('static gboolean\ngtk_dialog_get_disable_portrait(GtkDialog *dialog)')
b = s.index('static void\ngtk_dialog_screen_size_changed_cb', a)
s = s[:a] + '''/* Whether the window manager is told that this dialog must not turn portrait: the dialog's application (its window group leader) sets the window property
 * _HILDON_PORTRAIT_MODE_TASKNAV_DISABLE (a cardinal) -- what the original read from the X server, read here through the GDK window properties. No property: not disabled. */
static gboolean
gtk_dialog_get_disable_portrait(GtkDialog *dialog)
{
  GdkWindow *window = GTK_WIDGET (dialog)->window;
  GdkAtom actual_type; gint actual_format, actual_length; guchar *data = NULL;
  gboolean disable_portrait = FALSE;

  if (!window)
    return FALSE;
  if (gdk_property_get (gdk_window_get_toplevel (window), gdk_atom_intern_static_string ("_HILDON_PORTRAIT_MODE_TASKNAV_DISABLE"),
                        GDK_NONE, 0, 1, FALSE, &actual_type, &actual_format, &actual_length, &data) && data)
    {
      disable_portrait = actual_length >= 4 && *((guint32 *) data) != 0;
      g_free (data);
    }
  return disable_portrait;
}

''' + s[b:]
open(p, 'w').write(s)

p = d + '/gtk/gtkwidget.c'
s = open(p).read()
assert '#include <x11/gdkx.h>\n' in s
s = s.replace('#include <x11/gdkx.h>\n', '', 1)
s = s.replace('gdk_x11_get_server_time (widget->window)', 'gtk_get_current_event_time ()')
open(p, 'w').write(s)
print('leste X11 fixups applied')

# --- _gtk_window_is_on_client_data / gtk_window_close_other_temporaries are compiled for the X11 backend only and compare X window ids carried in a client message; this backend's window id is the
# GdkWindow pointer (the message goes to the windows of this process, delivered by gdk_event_send_clientmessage_toall) ---
p = d + '/gtk/gtkwindow.c'
s = open(p).read()
a = s.index('#if defined(GDK_WINDOWING_X11)\ngboolean\n_gtk_window_is_on_client_data')
b = s.index('#endif /* GDK_WINDOWING_X11 */', a)
blk = s[a:b]
blk = blk.replace('#if defined(GDK_WINDOWING_X11)\n', '#if 1   /* the window id of this backend: the GdkWindow pointer, as a gulong */\n', 1)
blk = blk.replace('GDK_WINDOW_XID (GTK_WIDGET (window)->window)', '((gulong) (GTK_WIDGET (window)->window))').replace('(XID*)', '(gulong*)').replace('sizeof(XID)', 'sizeof(gulong)').replace('XID xid', 'gulong xid')
assert 'XID' not in blk.replace('GDK_WINDOWING_X11', '')
s = s[:a] + blk + s[b:]
open(p, 'w').write(s)
print('leste client-data fixup applied')
