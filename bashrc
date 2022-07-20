[[ $- != *i* ]] && return

umask 0077
eval "$(dircolors -b)"

[ -n "$TMUX" ] && export TERM=screen-256color

# set -o vi
set -o noclobber
shopt -s autocd
shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -s histappend

# source ~/.local/src/ble.sh/out/ble.sh
# source ~/.scripts/shell/functions.sh
# source ~/.scripts/shell/mediainfo.sh
# source ~/.scripts/shell/aria2.sh
# source ~/.scripts/shell/fzf.sh
# source ~/.config/bash_aliases
source /usr/share/bash-completion/bash_completion

export NNN_OPTS='cE'
export NNN_SSHFS_OPTS='sshfs -o allow_other,follow_symlinks,reconnect'
export NNN_PLUG='m:mediainf;f:fzf_mal;o:fzopen;i:imgview;c:cbcp:C:cbcp -p;b:bcat;v:video;l:pager;r:launch;e:extract;p:sxpv'
export NNN_CONTEXT_COLORS="1234"
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_OPENER="$HOME/.config/nnn/plugins/launch"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

n() {
    if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"; return
    fi
    export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
r() {
    local cache=~/.cache/.rangedir
    ranger --choosedir="$cache" "$@"
    cd -- "$(cat "$cache")" || return 1
}
timer_start() {
    timer=${timer:-$SECONDS}
}
timer_stop() {
    local hh mm ss
    timer_show=$((SECONDS - timer))
    ss=$((timer_show % 60))
    if [ "$timer_show" -lt 1 ];then
        timer_show=""
    elif [ "$timer_show" -ge 60 ];then
        mm=$((timer_show / 60))
        if [ "$mm" -gt 60 ];then
            hh=$((mm / 60))
            mm=$((mm % 60))
            timer_show="(${hh}h ${mm}m ${ss}s)-"
        else
            timer_show="(${mm}m ${ss}s)-"
        fi
    else
        timer_show="(${timer_show}s)-"
    fi
    unset timer
}
trap 'timer_start' DEBUG

prompt() {
    out=$?
    blk="\[\033[1;30m\]"
    red="\[\033[1;31m\]"
    grn="\[\033[1;32m\]"
    ylw="\[\033[1;33m\]"
    blu="\[\033[1;34m\]"
    mgn="\[\033[1;35m\]"
    cyn="\[\033[1;36m\]"
    whi="\[\033[1;37m\]"
    rst="\[\033[00m\]"
    bar="$cyn"
    local git_branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1) /')
    local fsize=$(find -L . -xdev -maxdepth 1 -type f -print0 | xargs -r0 du -ch | awk '/\ttotal$/{print $1}')
    local file_count=$(find -L . -xdev -mindepth 1 -maxdepth 1 -printf '%y\n' | sort | uniq -c |
        sed 's/[ \t]*\([0-9]*\) \(.*\)/\1 \2,/' | tr \\n ' ') 
    # local hidden_count=$(find . -mindepth 1 -maxdepth 1 -name '.*' | wc -l)
    local hidden_count=$(ls --color=none -1A | grep -c '^\.')
    local files=$(find . -xdev -mindepth 1 -maxdepth 1 | wc -l)
    local exts=$(find . -xdev -maxdepth 1 -type f -printf '%f\n' | awk '{
        split($0, a, ".");
        if ($0 ~ /^\./ && length(a) == 2 || !($0 ~ /\./) ) next
        ext = a[length(a)];
        if (length(ext) < 8 && !(ext ~ /^[0-9]$/) ) print tolower(ext)
    }' | sort | uniq -c | sed 's/[ \t]*\([0-9]*\) \(.*\)/\1 \2,/' | tr \\n ' ')
    local last_mod=$(stat -c '%Z' "$PWD" | xargs -rI{} date --date='@{}' '+%b %d %H:%M')
    # local last_mod=$(last_modified)
    # local lavg=$(uptime | grep -oP '(?<=load average: ).*')
    # local cpu_usage=$(ps axch -o %cpu | awk '{x+=$1}END{ printf("%.1f%%\n", x)}')
    # local ram_usage=$(free -h | awk '/Mem:/{print $3"/"$2}')
    local perm=$(stat -c '%A' . | cut -c 2-)
    PS1="\${timer_show}${bar}(${grn}${perm}${bar})-"
    test -n "$fsize" && PS1+="(${red}${fsize}${rst}${bar})-"
    PS1+="(${rst}"
    test -n "$file_count" && PS1+="${file_count::-2}, "
    test "$hidden_count" -gt 0 && PS1+="$hidden_count ., "
    PS1+="${files:-0}${bar})"
    test -n "$exts" && PS1+="-(${rst}${exts::-2}${rst}${bar})$rst"
    test -n "$last_mod" && PS1+="${bar}-(${rst}${last_mod}${bar})$rst"
    test -n "$(jobs -p)" && PS1+="${bar}-(${rst}\j${bar})"
    PS1+="\n${blu}\w${rst}"
    PS1+="$git_branch"
    if test "$out" -eq 0;then
        PS1+="${grn}>$rst "
    else
        PS1+=" (${red}${out}${rst}) ${red}>$rst "
    fi
}
PROMPT_COMMAND="prompt; timer_stop"

# if [ -n "$DISPLAY" ];then
#     # https://github.com/FlorianHeydrich/ColorScripts
#     find ~/.scripts/playground/shell/Colors -maxdepth 1 -type f -print0 | shuf -zn 1 | xargs -r0 bash 
# fi
# function bye {
#     [ -n "$SSH_CLIENT" ] && bash ~/.local/src/seeyouspacecowboy.sh
# }
# trap bye EXIT
