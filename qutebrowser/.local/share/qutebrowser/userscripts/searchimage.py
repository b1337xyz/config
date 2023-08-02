#!/usr/bin/env python3
import os
from sys import argv

target = argv[1]
FIFO = os.getenv('QUTE_FIFO')
URL = os.getenv('QUTE_URL')

url = {
    'yandex': f'https://yandex.com/images/search?rpt=imageview&url={URL}',
    'saucenao': f'https://saucenao.com/search.php?url={URL}'
}[target]

open(FIFO, 'w').write('open -t {}'.format(url))
