[[ $- != *i* ]] && return

if grep -q pinentry-curses ~/.config/gnupg/gpg-agent.conf; then
    export GPG_TTY=$(tty)
fi

export BAT_STYLE=plain
export BAT_THEME="OneHalfDark"
# export BAT_THEME="gruvbox-light"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export HISTIGNORE='?:??:???:history:sensors:uptime:uptime -?:uname:uname -?'
export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=9999
export LESS=-Ri
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_so=$'\E[40;32m'    # begin reverse video
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export NNN_CONTEXT_COLORS="1234"
export NNN_FCOLORS='c1e22729006033f7c6d6abc4'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_OPENER="$HOME/.config/nnn/plugins/launch"
export NNN_OPTS='cEA'
export NNN_PLUG='t:lstar;T:trash;m:mediainf;i:imgview;c:cpb;C:cpp;v:video;e:extract;p:spv;h:crc32check'
export NNN_SSHFS_OPTS='sshfs -o allow_other,follow_symlinks,reconnect'
export PAGER=less
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export TERM=${TERM:-xterm-256color}
export TODOFILE="$XDG_CACHE_HOME"/.todo
export FZF_DEFAULT_OPTS='--no-border --no-separator --color=dark'
export PROMPT_DIRTRIM=2
export COLORTERM=truecolor

source /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/completions/man
source ~/.config/dircolors
source ~/.config/bash_aliases
source ~/.scripts/python/a2cli/completion/*
source ~/.scripts/python/mal_completion
source ~/.scripts/shell/functions.sh
source ~/.scripts/shell/mediainfo.sh
source ~/.scripts/shell/aria2.sh
source ~/.scripts/shell/fzf.sh
complete -F _man man apropos whatis fzman

umask 0077

set -o vi
set -o noclobber
shopt -s autocd
shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -s histappend

[ -f ~/.python_history ] && command rm ~/.python_history

expand_files() {
    # Example:
    #  ls ~/.bashrc file -> ls /home/<user>/.bashrc /home/<user>/file
    local cmd=
    for arg in $READLINE_LINE;do
        if test -e "${arg/\~/$HOME}";then
            path=$(realpath "${arg/\~/$HOME}")
            cmd="$cmd '$path'"
        else
            cmd="$cmd $arg"
        fi
    done
    READLINE_LINE="${cmd:1}"
    READLINE_POINT=${#cmd}
}
fzfhist() {
    cmd=$(
        history | sed 's/^ *\?[0-9]* *//' | awk 'length($0) > 2' |
        fzf --info=hidden --layout=reverse \
            --height 20 --no-sort --tac --bind 'tab:accept'
    )
    READLINE_LINE="$cmd"
    READLINE_POINT=${#cmd}
}
fzfgov() {
    current=$(</sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    awk '{for (i=1;i<=NF;++i) print $i}' \
        /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors |
        fzf --header "current: $current" --height 8 | xargs -ro sudo cpupower frequency-set -g 
}
undomv() {
    READLINE_LINE="mv -vni !mv:2 !mv:1 "
    READLINE_POINT=${#READLINE_LINE}
}
fzcd() {
    local p
    p=$(find . -mindepth 2 -maxdepth 4 -type d \! -name '\.*'  | sort -rV | fzf \
        --info=hidden --layout=reverse --height 20 --bind 'tab:accept')
    [ -e "$p" ] && cd "$p"
}

if ! [[ "$TERM" =~ xterm* ]];then
    # Ctrl-V + key  to find any keycode
    # https://sparky.rice.edu//~hartigan/del.html
    bind -x '"\em": undomv'
    bind -x '"\C-x": expand_files'
    bind -x '"\C-h": fzfhist'
    bind -x '"\C-g": fzfgov' 
    bind -x '"\C-f": fzcd'
fi

cd() {
    # if autocd is enabled
    if [ "$1" = "--" ];then
        command cd "$@"
    else
        command cd -- "$@"
    fi || return $?
    timeout 1 ls --color=always -Nhltr 2>/dev/null || true
}
gb() { cd - ; }
n() {
    if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"; return
    fi
    export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        command rm -f "$NNN_TMPFILE"
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
    if [ "${timer_show:-0}" -lt 2 ];then
        timer_show=""
    elif [ "$timer_show" -ge 60 ];then
        mm=$((timer_show / 60))
        if [ "$mm" -gt 60 ];then
            hh=$((mm / 60))
            mm=$((mm % 60))
            timer_show="took ${hh}h ${mm}m ${ss}s "
        else
            timer_show="took ${mm}m ${ss}s "
        fi
    else
        timer_show="took ${timer_show}s "
    fi
    unset timer
}
trap 'timer_start' DEBUG

prompt() {
    out=$?
    PS1=""
    local blk="\[\033[1;30m\]"
    local red="\[\033[1;31m\]"
    local grn="\[\033[1;32m\]"
    local ylw="\[\033[1;33m\]"
    local blu="\[\033[1;34m\]"
    local mgn="\[\033[1;35m\]"
    local cyn="\[\033[1;36m\]"
    local whi="\[\033[1;37m\]"
    local rst="\[\033[00m\]"
    local bar="$cyn"
    # local file_count=$(find -L . -xdev -mindepth 1 -maxdepth 1 -printf '%y\n' | sort | uniq -c | sed 's/[ \t]*\([0-9]*\) \(.*\)/\1 \2,/' | tr \\n ' ') 
    # local hidden_count=$(find . -mindepth 1 -maxdepth 1 -name '.*' | wc -l)
    # local hidden_count=$(ls --color=none -N1A | grep -c '^\.')
    # local files=$(find . -xdev -mindepth 1 -maxdepth 1 | wc -l)
    # local exts=$(find . -xdev -maxdepth 1 -type f -printf '%f\n' | awk '{
    #     split($0, a, ".");
    #     if ($0 ~ /^\./ && length(a) == 2 || !($0 ~ /\./) ) next
    #     ext = a[length(a)];
    #     if (length(ext) < 8 && !(ext ~ /^[0-9]$/) ) print tolower(ext)
    # }' | sort | uniq -c | sed 's/[ \t]*\([0-9]*\) \(.*\)/\1 \2,/' | tr \\n ' ')
    # local fsize=$(find . -maxdepth 1 -type f -print0 | xargs -r0 du -ch | awk '/\ttotal$/{print $1}')
    # local last_mod=$(stat -c '%Z' "$PWD" | xargs -rI{} date --date='@{}' '+%b %d %H:%M')
    # local lavg=$(uptime | grep -oP '(?<=load average: ).*')
    # local cpu_usage=$(ps axch -o %cpu | awk '{x+=$1}END{ printf("%.1f%%\n", x)}')
    # local ram_usage=$(command free -m | awk '/Mem:/{printf("%s\n", $2 - $7)}')
    # local fsize=$(command ls -lhA | awk 'NR == 1 {print $2}')
    # local last_mod=$(last_modified)
    # local perm=$(stat -c '%a' .)
    local git_branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1) /')
    
    # PS1="${bar}[${red}\V${bar}]"
    # PS1+="${bar}[${cyn}${ram_usage}${bar}]"
    # PS1+="${bar}[${grn}${perm}${bar}]"
    # test -n "$fsize" && PS1+="[${red}${fsize}${rst}${bar}]"
    # PS1+="(${file_count::-2}, "
    # PS1+="${hidden_count:-0} ., "
    # PS1+="${files:-0}${bar})-"
    # test -n "$exts"      && PS1+="-(${rst}${exts::-2}${rst}${bar})$rst"
    # test -n "$last_mod"  && PS1+="${bar}[$rst$last_mod${bar}]"
    # test -n "$(jobs -p)" && PS1+="${bar}(${rst}\j${bar})-"
    PS1+="${blu}\w${rst}\n"
    PS1+="\${timer_show}"
    PS1+="$VIRTUAL_ENV_PROMPT"
    PS1+="$git_branch"
    if test "${out:-0}" -eq 0;then
        PS1+="${grn}>${rst} "  # λ π β ω μ
    else
        # local beep=~/Music/Yuu_windows_theme/you_hmm?.wav
        # [ -f "$beep" ] && mpv --no-config --no-video --really-quiet "$beep" &
        # [ -f "$beep" ] && aplay -q "$beep" &
        PS1+="${red}${out}!$rst "
    fi

    # set title
    echo -ne "\033]0;${PWD/$HOME/\~}\007"
}
ms_prompt() {
    msdos_pwd() { pwd | tr '/' '\\'; }
    PS1='C:$(msdos_pwd)> '
}
PROMPT_COMMAND="prompt; timer_stop"

if [ -n "$DISPLAY" ];then
    # printf '\e[1;31m'; cat ~/Documents/ASCII/Nerv; printf '\e[m\n'
    # shuf -n1 ~/.cache/quotes.csv | sed 's/|/\n\t- /'
    # random_color
    # random_anime_quote
    # bfetch
    # xmodmap -e "keycode 134 =" # disable SUPER_R
    # printf 'Microsoft Windows XP [Version 5.1.2600]\n(C) Copyright 1985-2004 Microsoft Corp.\n\n'
    todo ls 2>/dev/null
fi
function bye {
    echo "bye ^-^"
    [ -n "$SSH_CLIENT" ] && cat ~/.local/src/seeyouspacecowboy.txt
}
trap bye EXIT

fixkbd() {
    # localectl list-x11-keymap-options
    # xmodmap -e "keycode 108 = Alt_L" # Alt_Gr
    xmodmap -e "keycode 97 = Alt_L" # backslash
    xmodmap -e "keycode 34 = dead_grave backslash" # dead_acute 
    xmodmap -e "keycode 47 = asciitilde bar" # ccedilla
    xmodmap -e "keycode 87 = g" # KP_End
    xmodmap -e "keycode 89 = h" # KP_Next (3)
    # xmodmap -e "keycode 73 = g" # F7
    # xmodmap -e "keycode 74 = h" # F8
    # xmodmap -e "keycode 15 = 6 backslash"  # dead_diaeresis
    # xmodmap -e "keycode 81 = bar backslash " # KP_Prior (9)
    # xmodmap -e "keycode 91 = asciitilde"  # KP_Delete
}
