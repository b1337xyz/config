// ==UserScript==
// @name        Improve redgifs UX
// @match       https://*.redgifs.com/watch/*
// @run-at      document-idle
// ==/UserScript==

function wait_for(target) {
    return new Promise(resolve => {
        if (document.querySelector(target)) {
            return resolve(document.querySelector(target));
        }

        const observer = new MutationObserver(mutations => {
            if (document.querySelector(target)) {
                resolve(document.querySelector(target));
                observer.disconnect();
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    });
}
wait_for(".isLoaded").then((e) => {
    window.open(e.src, "_self");
});
