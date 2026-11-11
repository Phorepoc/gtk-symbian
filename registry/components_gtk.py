# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause

"""components_gtk -- gtk-symbian's components (merged into core's registry when this repository is a layer:
PHOREPOC_ADAPTATIONS=...:<glib-symbian>:<gtk-symbian>). ".hildon/..." resolves to $PHOREPOC_BUILD/hildon/ (the archives
recipes/ builds). Nothing here is in an OS image: GTK is a Catalogue download (recipes/sis.sh).
"""
import os

from paths import OS_ROOT

_COMMON = dict(cdriver=True, allow_wsd=True, static_ctors=True, rtti=False, defs=["__SOFTFP="])
_RT = [f"thirdparty/x86/cxxrt/{a}.a" for a in ("libphcompat", "libgcc")]


def _dll(name, src=None, archive=None):
    src = src or name
    return dict(mmp=os.path.join(OS_ROOT, f"src/{src}/{name}.mmp"), rom=f"{name}.dll",
                x32_archives=[f".hildon/{archive or 'lib' + name}.a"] + _RT,
                **{"def": os.path.join(OS_ROOT, f"src/{src}/{name}.def")}, **_COMMON)


COMPONENTS = {n: _dll(n) for n in ("phepixman", "phefreetype", "phecairo", "phehb", "phepng", "phefontconfig", "phepango",
                                   "phepixbuf", "pheatk", "phegdk", "phegtk")}
# the GTK "pixmap" theme engine (GTK's modules/engines/pixbuf), loaded through GModule by name
COMPONENTS["pixmap"] = dict(_dll("pixmap", src="pheengpixmap"), rom_data=["resource\\gmodule\\pixmap.sym=.hildon/gmodule/pixmap.sym"])

# installed, not in a ROM
for _c in COMPONENTS.values():
    _c.setdefault("sis", True)
