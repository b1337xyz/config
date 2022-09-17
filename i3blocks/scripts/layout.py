#!/usr/bin/env python3
import i3ipc
con = i3ipc.Connection()
tree = con.get_tree()
layout = tree.find_focused().parent.layout
x = {
    'splith': '',
    'splitv': '',
    'stacked': '',
    'tabbed': '裡'
}
print('<span size="20pt"><tt>{}</tt></span>'.format(x[layout]))
