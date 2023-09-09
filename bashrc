[[ $- != *i* ]] && return
# hash fish && fish && exit 0

rm ~/.python_history 2>/dev/null

export GPG_TTY=$(tty)
export BAT_STYLE=plain
export BAT_THEME="OneHalfDark"
# export BAT_THEME="gruvbox-light"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export HISTIGNORE='?:??:???:neofetch:history:sensors:uptime:uptime -?:uname:uname -?'
export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=99999
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
export COLORTERM=truecolor  # https://github.com/termstandard/colors

source /usr/share/bash-completion/bash_completion
source ~/.config/dircolors 2>/dev/null || eval "$(dircolors -b | tee ~/.config/dircolors)"
source ~/.config/bash_aliases
source ~/.scripts/shell/functions.sh
source ~/.scripts/shell/mediainfo.sh
source ~/.scripts/shell/aria2.sh
source ~/.scripts/shell/fzf.sh

umask 0077

set -o vi
set -o noclobber
shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -s histappend
shopt -s autocd
shopt -s dirspell
shopt -s cdspell
shopt -s cmdhist
shopt -s globstar

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
    local cmd=
    cmd=$(history | awk '{sub(/^ +?[0-9 ]+/, "", $0); if (length($0) > 2) print $0}' |
        fzf --info=hidden --layout=reverse --scheme=history \
        --query "$READLINE_LINE" --height 20 --tac --bind 'tab:accept')
    READLINE_LINE="$cmd"
    READLINE_POINT=${#cmd}
}
fzfgov() {
    local current=
    current=$(</sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    awk '{for (i=1;i<=NF;++i) print $i}' \
        /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors |
        fzf --header "current: $current" --height 8 | xargs -ro sudo cpupower frequency-set -g 
}
undomv() {
    # undo `mv foo bar` -> `mv bar foo`
    READLINE_LINE="mv !mv:2 !mv:1 -vn"
    READLINE_POINT=${#READLINE_LINE}
}
fzcd() {
    local p
    p=$(find . -xdev -mindepth 1 -maxdepth 4 -type d \! -path './\.*' | fzf \
        --info=hidden --layout=reverse --height 20 --bind 'tab:accept')
    [ -e "$p" ] && cd "$p"
}
cb() {
    d=$(awk '!s[$0]++' ~/.cache/.bpwd | fzf -0 --info=hidden --reverse --height 20 --bind tab:accept);
    [ -d "$d" ] && cd "$d" || return 1
}
goback() {
    d=$(awk '!s[$0]++' ~/.cache/goback | fzf --info=hidden --layout=reverse --height 20 --tac --bind 'tab:accept')
    [ -d "$d" ] && cd "$d"
}
_quote() {
    # foo bar zzz -> alt+q -> foo 'bar' zzz
    #     ^^^ cursor is here
    local right left word
    right=${READLINE_LINE:$READLINE_POINT}
    left=${READLINE_LINE::$READLINE_POINT}
    word=${left##* }${right%% *}
    [ -z "$word" ] && return
    [ "${left% *}" = "$left" ] && left= || left="${left% *} "
    [ "${right#* }" = "$right" ] && right= || right=" ${right#* }"
    READLINE_LINE="${left}'${word}'$right"
    READLINE_POINT=$(( ${#left} + ${#word} + 2 ))
}
_pager() {
    READLINE_LINE="${READLINE_LINE} | bat"
}

if ! [[ "$TERM" = xterm* ]];then
    # Ctrl-V + key  to find any keycode
    # https://sparky.rice.edu//~hartigan/del.html
    
    # bind enter
    # bind -x '"\C-\xFF": undomv'
    # bind '"\C-\xFE": accept-line'
    # bind '"\em": "\C-\xFF\C-\xFE"'
    bind -x '"\em": undomv'

    bind -x '"\eb": goback'
    bind -x '"\eq": _quote'
    bind -x '"\ep": _pager'
    bind -x '"\es": s'  # scripts
    bind -x '"\ec": c'  # config
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

    if [ -z "$VIRTUAL_ENV" ] && [ -f ./venv/bin/activate ]; then
        source ./venv/bin/activate
    elif [ -n "$VIRTUAL_ENV" ] && [ "${PWD#${VIRTUAL_ENV%/*}}" = "$PWD" ]; then
        deactivate
    fi

    local blk="\[\033[1;30m\]"
    local red="\[\033[1;31m\]"
    local grn="\[\033[1;32m\]"
    local ylw="\[\033[1;33m\]"
    local blu="\[\033[1;34m\]"
    local mgn="\[\033[1;35m\]"
    local cyn="\[\033[1;36m\]"
    local whi="\[\033[1;37m\]"
    local rst="\[\033[00m\]"
    local bar="$cyn[${rst}"
    local end="$cyn]${rst}"
    PS1="${blu}┏━${rst}" # ┌ ┍ ┎ ┏ ─ ━
    # local ip=$(command ip route get 1 | awk 'NR==1{print $7}')
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
    local last_mod=$(last_modified)
    # local lavg=$(uptime | grep -oP '(?<=load average: ).*')
    # local cpu_usage=$(ps axch -o %cpu | awk '{x+=$1}END{ printf("%.1f%%\n", x)}')
    # local ram_usage=$(command free -m | awk '/Mem:/{printf("%s\n", $2 - $7)}')
    # local fsize=$(command ls -lhA | awk 'NR == 1 {print $2}')
    # local perm=$(stat -c '%A' . | awk '{printf("\033[1;35m%s\033[1;31m%s\033[1;32m%s\033[m",
    #                                            substr($0, 2, 1), substr($0, 3, 1), substr($0, 4, 1))}')
    local perm=$(stat -c '%a' .)
    local git_branch="$(git branch --show-current 2>/dev/null | sed 's/\(.*\)/(\1) /')"
    
    # test "${out:-0}" -eq 0 && PS1+="${bar}${grn}" || PS1+="${bar}[${red}"
    # PS1+="${out}${end}"
    # PS1="${bar}${red}\V${end}"
    # PS1+="${bar}${cyn}${ram_usage}${end}"
    # test -n "$fsize" && PS1+="${bar}${red}${fsize}${end}"
    # PS1+="(${file_count::-2}, "
    # PS1+="${hidden_count:-0} ., "
    # PS1+="${files:-0}${end}"
    # test -n "$exts"      && PS1+="${bar}${exts::-2}${rst}${bar}"
    # test -n "$last_mod"  && PS1+="${bar}$rst$last_mod${end}"
    PS1+="${bar}${grn}${perm}${end}"
    # test -n "$(jobs -p)" && PS1+="${bar}(${rst}\j${bar})-"
    PS1+="${bar}${blu}\w${end}"
    PS1+="\n${blu}┗${rst}" # └ ┕ ┖ ┗
    PS1+="\${timer_show}"
    PS1+="$VIRTUAL_ENV_PROMPT"
    PS1+="$git_branch"

    [ -n "$WSLENV" ] && PS1+="(wsl) "

    if test "${out:-0}" -eq 0;then
        # PS1+="${grn}( •_•)${rst} "  # λ π β ω μ
        PS1+="\$ "
    else
        # local beep=~/Music/Yuu_windows_theme/you_hmm?.wav
        # [ -f "$beep" ] && mpv --no-config --no-video --really-quiet "$beep" &
        # [ -f "$beep" ] && aplay -q "$beep" &
        # PS1+="${red}(；☉_☉)${rst} "
        PS1+="${red}${out}!${rst} "
    fi

    if [ $COLUMNS -gt 100 ];then
        # https://wiki.archlinux.org/title/Bash/Prompt_customization#Right-justified_text
        PS1=$(printf "\n%*s\r%s" $(( COLUMNS-1 )) "< $last_mod" "$PS1")
    fi

    # set title
    echo -ne "\033]0;${PWD/$HOME/\~}\007"
    [[ "${PWD//[^\/]/}" = ////* ]] && pwd >> ~/.cache/goback
}
ms_prompt() {
    msdos_pwd() { pwd | tr '/' '\\'; }
    PS1='C:$(msdos_pwd)> '
}
PROMPT_COMMAND="prompt; timer_stop"

function bye {
    echo "bye ^-^"
    [ -n "$SSH_CLIENT" ] && cat ~/Documents/txt/seeyouspacecowboy.txt
}
trap bye EXIT

fixkbd() {
    setxkbmap br
    # localectl list-x11-keymap-options
    # xmodmap -e "keycode 108 = Alt_L" # Alt_Gr
    xmodmap -e "keycode 97 = Alt_L" # backslash
    xmodmap -e "keycode 34 = dead_grave backslash" # dead_acute 
    xmodmap -e "keycode 47 = asciitilde bar" # ccedilla
    xmodmap -e "keycode 26 = e E NoSymbol NoSymbol g"
    xmodmap -e "keycode 27 = r R NoSymbol NoSymbol h"
    xmodmap -e "keycode 28 = t T NoSymbol NoSymbol Up"
    # xmodmap -e "keycode 73 = g" # F7
    # xmodmap -e "keycode 74 = h" # F8
    # xmodmap -e "keycode 15 = 6 backslash"  # dead_diaeresis
    # xmodmap -e "keycode 81 = bar backslash " # KP_Prior (9)
    # xmodmap -e "keycode 91 = asciitilde"  # KP_Delete
}
hxsj() {
    # mappings for the hxsj keyboard
    setxkbmap -layout us -variant altgr-intl
    xmodmap -e "keycode  24 = q Q NoSymbol NoSymbol slash"
    xmodmap -e "keycode  25 = w W NoSymbol NoSymbol question"
    xmodmap -e "keycode  34 = backslash bar"
    xmodmap -e "keycode  35 = bracketleft braceleft"
    xmodmap -e "keycode  47 = asciitilde asciicircum"
    xmodmap -e "keycode  51 = bracketright braceright"
    xmodmap -e "keycode  61 = semicolon colon"
}

if [ -n "$DISPLAY" ];then
    todo ls | tail -5
fi
# printf '\e[1;31m'; cat ~/Documents/ASCII/Nerv; printf '\e[m\n'
# shuf -n1 ~/.cache/quotes.csv | sed 's/|/\n\t- /'
# printf 'Microsoft Windows XP [Version 5.1.2600]\n(C) Copyright 1985-2004 Microsoft Corp.\n\n'

nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] || { printf '%s not found, is nvm installed?' "$NVM_DIR/nvm.sh"; return 1; }
    unset nvm  # just to be sure
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
    nvm "$@"
}

# The best thing ever -> https://github.com/momo-lab/bash-abbrev-alias
if source ~/.local/src/bash-abbrev-alias/abbrev-alias.plugin.bash 2>/dev/null
then
    abbrev-alias Status="systemctl --user status"
    abbrev-alias -g -e Latest='$(command ls -1trc | tail -1)'
fi
