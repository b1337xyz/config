#!/usr/bin/env python3
from os import getenv
import subprocess as sp
import i3ipc
con = i3ipc.Connection()

btn = getenv('BLOCK_BUTTON')
if btn in [1, 2]:
    sp.run(['i3-scratchpad-dmenu.py'])

#print(len([i for i in scratchpad.find_named('.')]))
tree = con.get_tree()
scratchpad = [i.name for i in tree.scratchpad().find_named('.')]
if scratchpad:
    print(''.join(' [{}] '.format(
        i[:20] + '...' if len(i) > 17 else i
    ) for i in scratchpad), flush=True)
else:
    print()
