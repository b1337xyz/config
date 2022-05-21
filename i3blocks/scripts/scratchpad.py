#!/usr/bin/env python3
import i3ipc
con = i3ipc.Connection()

#print(len([i for i in scratchpad.find_named('.')]))
tree = con.get_tree()
scratchpad = [i.name for i in tree.scratchpad().find_named('.')]
if scratchpad:
    print(''.join('[{}]'.format(
        i[:10] + '...' if len(i) > 7 else i
    ) for i in scratchpad)) # flush=True isn't working
else:
    print()
