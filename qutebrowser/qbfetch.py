#!/usr/bin/env python3
from qutebrowser.api import cmdutils, message
from qutebrowser.utils import objreg, version as vs
# from qutebrowser import __file__ as qtfile
from qutebrowser import __version__ as qtver
from qutebrowser.qt.core import QUrl
# import traceback
# import os

HTML = '/tmp/qbfetch.html'
html_head = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Qutefetch</title>
  <style>
    body {
      background: #1a1b26;
      color: #a9b1d6;
      font-family: Arial, sans-serif;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      margin: 0px;
    }
    body > * {
      margin: 15px;
    }
    #sysinfo div span:nth-child(1) {
        color: #9ece6a
    }
    #sysinfo div span:nth-child(2) {
        color: #f7768e
    }
  </style>
</head>
<body><pre>''' + vs._LOGO + '</pre><div id="sysinfo" style="float: right">'
html_tail = '</div></body></html>'


@cmdutils.register()
@cmdutils.argument('win_id', value=cmdutils.Value.win_id)
def qbfetch(win_id: int) -> None:
    """
        Display information from qute://version in a "pleasant" way
    """

    try:
        lines = [('qutebrowser v', qtver)]
        gitver = vs._git_str()
        if gitver is not None:
            lines.append(("Git commit", gitver))

        lines.append(('Backend', vs._backend()))
        # lines.append(('Qt', vs.earlyinit.qt_version()))
        lines.append((vs.platform.python_implementation(),
                      vs.platform.python_version()))
        # lines.append(('PyQt', vs.PYQT_VERSION_STR))
        # m = str(vs.machinery.INFO).split('\n')
        # lines += [(m[0].replace(':', ''), '<br>'.join(m[1:]))]
        lines += [s.split(': ') for s in vs._module_versions()]
        lines.append(('pdf.js', vs._pdfjs_version()))
        lines.append(('sqlite', vs.sql.version()))
        lines.append(('QtNetwork SSL', vs.QSslSocket.sslLibraryVersionString()
                      if vs.QSslSocket.supportsSsl() else 'no'))

        if vs.objects.qapp:
            style = vs.objects.qapp.style()
            metaobj = style.metaObject()
            if metaobj:
                lines.append(('Style', metaobj.className()))
            # lines.append(('Platform plugin', vs.objects.qapp.platformName()))
            lines.append(('OpenGL', vs.opengl_info()))

        lines.append(('Platform', '{}, {}'.format(
            vs.platform.platform(),
            vs.platform.architecture()[0])))
        dist = vs.distribution()
        if dist is not None:
            lines.append(('Linux distribution',
                          '{} ({})'.format(dist.pretty, dist.parsed.name)))

        # importpath = os.path.dirname(os.path.abspath(qtfile))
        # lines.append(('Frozen', hasattr(sys, 'frozen')))
        # lines.append(("Imported from", importpath))
        # lines.append(("Using Python from", sys.executable))
        # lines += [(name, path)
        #           for name, path in sorted(vs._path_info().items())]

        lines += [
            ('Autoconfig loaded', vs._autoconfig_loaded()),
            ('Config.py', vs._config_py_loaded()),
            ('Uptime', vs._uptime())
        ]

        out = ''
        for k, v in lines:
            out += f'<div><span>{k}</span><span>:</span> <span>{v}</span></div>\n'  # noqa: E501

        with open(HTML, 'w') as f:
            f.write(html_head + out + html_tail)

        url = QUrl(f'file://{HTML}')
        tabbed_browser = objreg.get('tabbed-browser',
                                    scope='window',
                                    window=win_id)
        tabbed_browser.load_url(url, newtab=False)
    except Exception:
        # with open('qterr', 'w') as f:
        #     traceback.print_exc(file=f)
        message.error('Failed')
