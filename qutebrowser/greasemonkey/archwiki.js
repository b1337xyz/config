// ==UserScript==
// @name        Expand table of contents - archlinux.org
// @match       https://wiki.archlinux.org/title/*
// @run-at      document-idle
// ==/UserScript==

document.querySelectorAll('.sidebar-toc-list-item').forEach(e => e.classList.add('sidebar-toc-list-item-expanded'))
