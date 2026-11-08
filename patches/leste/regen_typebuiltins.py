# regen_typebuiltins.py TREE -- gtk/gtktypebuiltins.[ch] ship generated in the GTK tarball; the Maemo patches add enums (HildonUIMode, HildonGtkInputMode, GtkInvalidInputType, ...) that need their GTypes, so the
# two files are generated again, as gtk/Makefile.am does: glib-mkenums (the native build of glib-symbian's tree, /wk/nat) over gtk_public_h_sources with the two templates.
import re
import subprocess
import sys

d = sys.argv[1] + '/gtk'
mk = open(d + '/Makefile.am').read().replace('\\\n', ' ')
m = re.search(r'^gtk_public_h_sources\s*\+?=\s*(.*)$', mk, re.M)
hdrs = [h for h in m.group(1).split() if h.endswith('.h')]
# a second '+=' block of the same variable, if any
for m2 in re.finditer(r'^gtk_public_h_sources\s*\+=\s*(.*)$', mk, re.M):
    hdrs += [h for h in m2.group(1).split() if h.endswith('.h') and h not in hdrs]
for kind in ('h', 'c'):
    out = subprocess.run(['/wk/nat/gobject/glib-mkenums', '--template', 'gtktypebuiltins.%s.template' % kind] + hdrs, cwd=d, capture_output=True, text=True, check=True).stdout
    open(d + '/gtktypebuiltins.' + kind, 'w').write(out)
print('gtktypebuiltins regenerated from %d headers' % len(hdrs))
