#!/usr/bin/env python3
from urllib.request import Request, urlopen
from optparse import OptionParser

usage = 'Usage: %prog [options]'
parser = OptionParser(usage=usage)
opts, args = parser.parse_args()

UA = "Mozilla/5.0 (X11; U; Linux i686) Gecko/20071127 Firefox/2.0.0.11"


def main():
    r = Request(url, headers={'user-agent': UA})
    with urlopen(r) as data:
        data = data.read().decode()


if __name__ == '__main__':
    main()
