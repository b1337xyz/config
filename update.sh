#!/usr/bin/env bash

set -eo pipefail

find ~/.local/src/config -type f \! -path '.git*' | while read -r old
do
    new=${old/local\/src\//}
    [ -e "$new" ] || continue
    diff --color "$old" "$new" || cp -vi "$new" "$old" </dev/tty
done

old=~/.local/src/config/bashrc
new=~/.bashrc
diff --color "$old" "$new" || cp -vi "$new" "$old"

printf "push changes? (y/N) "
read ask
if [ "$ask" = y ];then
    git add -Av
    git commit -m "$(date +%Y.%m.%d)"
    git push
fi

exit 0
