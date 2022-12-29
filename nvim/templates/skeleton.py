#!/usr/bin/env python3
# import logging
from bs4 import BeautifulSoup as BS
from urllib.request import Request, urlopen
# from urllib.request import urlretrieve
# from optparse import OptionParser
# from time import sleep
# from selenium import webdriver
# from selenium.common.exceptions import NoSuchElementException

# logging.basicConfig(
#     filename=logpath,
#     encoding='utf-8',
#     filemode='w',
#     level=logging.INFO,
#     format='%(asctime)s:%(levelname)s: %(message)s',
#     datefmt='%d-%m-%Y %H:%M:%S',
# )

# usage = 'Usage: %prog [options]'
# parser = OptionParser(usage=usage)
# parser.add_option(
#   '-v', '--verbose', action='store_true',
#   dest='verbose', default=True
# )
# parser.add_option(
#   '-f', '--file', type='string',
#   dest='filename', metavar='FILE'
# )
# opts, args = parser.parse_args()

# profile_path = ''
# profile = webdriver.FirefoxProfile(profile_path)
# opts = webdriver.FirefoxOptions()
# opts.add_argument('-headless')
# driver = webdriver.Firefox(
#     executable_path='/usr/bin/geckodriver',
#     firefox_profile=profile, options=opts,
#     service_log_path="/dev/null"
# )

UA = "Mozilla/5.0 (X11; U; Linux i686) Gecko/20071127 Firefox/2.0.0.11"


def get_soup(url):
    r = Request(url, headers={'User-Agent': UA})
    with urlopen(r) as data:
        return BS(data.read().decode(), 'html.parser')


def main():
    pass


if __name__ == '__main__':
    main()
