#!/usr/bin/env python3
from qutebrowser.api import cmdutils
from qutebrowser.browser.qutescheme import add_handler
from qutebrowser.utils import objreg, version as vs
from qutebrowser import __file__ as qtfile
from qutebrowser import __version__ as qtver
from typing import Union, Tuple
try:
    from qutebrowser.qt.core import QUrl
except ImportError:
    from PyQt5.QtCore import QUrl

import os
import sys

root = os.path.dirname(os.path.realpath(__file__))
js = os.path.join(root, 'qbfetch.js')
# if not os.path.exists(js):
#     open(js, 'w').close()

css = os.path.join(root, 'qbfetch.css')
if not os.path.exists(css):
    with open(css, 'w') as f:
        f.write('''
body {
  background: #1a1b26;
  color: #a9b1d6;
  font-family: Arial, sans-serif;
  height: 100vh;
  display: flex;
  align-items: start;
  margin: 0px;
}
body > * {
  margin: 15px;
}
#info div span:nth-child(1) {
    color: #9ece6a
}
#info div span:nth-child(2) {
    color: #f7768e
}'''.strip())


html_head = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>qbfetch</title>
  <link rel="stylesheet" href="file://{}">
</head>
<body>
<pre id="logo">{}</pre>
<div id="info" style="float: right">
'''.format(css, vs._LOGO)
html_tail = f'</div><script src="file://{js}"></script></body></html>'



def memory_info():
    # KB -> MB
    memtotal, memavail = None, None
    with open('/proc/meminfo') as f:
        for line in f:
            if line.startswith('MemTotal:'):
                memtotal = int(line.split()[1]) // 1024
            elif line.startswith('MemAvailable:'):
                memavail = int(line.split()[1]) // 1024

            if memavail is not None and memtotal is not None:
                break
        else:
            return
    return f'{(memtotal - memavail)} MiB / {memtotal} MiB'



@add_handler('qbfetch')
def qbfetch_handler(_url: QUrl) -> Tuple[str, Union[str, bytes]]:
    """ Handler for qute://qbfetch. """
    lines = []
    dist = vs.distribution()
    if dist is not None:
        lines += [('OS', f'{dist.pretty} ({dist.parsed.name})')]

    lines += [('Kernel', '{}, {}'.format(vs.platform.platform(),
                                         vs.platform.architecture()[0]
                                         ))]

    lines += [('Memory', memory_info())]
    lines += [('---' * 20, None)]

    lines += [('qutebrowser v', qtver)]
    gitver = vs._git_str()
    if gitver is not None:
        lines.append(("Git commit", gitver))

    lines.append(('Backend', vs._backend()))
    lines.append(('Qt', vs.earlyinit.qt_version()))
    lines.append((vs.platform.python_implementation(),
                  vs.platform.python_version()))
    lines.append(('PyQt', vs.PYQT_VERSION_STR))

    # m = str(vs.machinery.INFO).split('\n')
    # lines += [(m[0].replace(':', ''), '<br>'.join(m[1:]))]
    # lines += [s.split(': ') for s in vs._module_versions()]

    lines.append(('pdf.js', vs._pdfjs_version()))
    lines.append(('sqlite', vs.sql.version()))
    lines.append(('QtNetwork SSL', vs.QSslSocket.sslLibraryVersionString()
                  if vs.QSslSocket.supportsSsl() else 'no'))

    if vs.objects.qapp:
        style = vs.objects.qapp.style()
        metaobj = style.metaObject()
        if metaobj:
            lines.append(('Style', metaobj.className()))

    lines.append(('Platform plugin', vs.objects.qapp.platformName()))
    lines.append(('OpenGL', vs.opengl_info()))

    importpath = os.path.dirname(os.path.abspath(qtfile))
    # lines.append(('Frozen', hasattr(sys, 'frozen')))
    lines.append(("Imported from", importpath))
    lines.append(("Using Python from", sys.executable))
    lines += [(name, path)
              for name, path in sorted(vs._path_info().items())]

    lines += [
        ('Autoconfig loaded', vs._autoconfig_loaded()),
        # ('Config.py', vs._config_py_loaded()),
        ('Uptime', vs._uptime())
    ]

    out = ''
    for k, v in lines:
        if v is None:
            out += f'{k}\n'
            continue
        out += f'<div><span>{k}</span><span>:</span> <span>{v}</span></div>\n'

    return 'text/html', html_head + out + html_tail


@cmdutils.register()
@cmdutils.argument('win_id', value=cmdutils.Value.win_id)
def qbfetch(win_id: int) -> None:
    """ Show version information in a "pleasant" way. """
    url = QUrl('qute://qbfetch')
    tabbed_browser = objreg.get('tabbed-browser',
                                scope='window',
                                window=win_id)
    tabbed_browser.load_url(url, newtab=False)
