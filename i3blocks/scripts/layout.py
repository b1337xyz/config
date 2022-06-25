#!/usr/bin/env python3
import i3ipc
con = i3ipc.Connection()
tree = con.get_tree()
layout = tree.find_focused().parent.layout
x = {
    'splith': 'h',
    'splitv': 'v',
    'stacked': 's',
    'tabbed': 't'
}
print('[{}]'.format(x[layout]))
