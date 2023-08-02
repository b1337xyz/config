// ==UserScript==
// @name        Remove annoying simpcity iframes
// @match       https://simpcity.su/*
// @run-at      document-idle
// ==/UserScript==

document.querySelectorAll('iframe').forEach(e => e.remove());
