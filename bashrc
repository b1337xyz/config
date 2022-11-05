[[ $- != *i* ]] && return
# export GPG_TTY=$(tty)
export BAT_STYLE=plain
export BAT_THEME="Sublime Snazzy"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export HISTCONTROL=ignoreboth
export HISTSIZE=9000
export LESS=-Ri
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_so=$'\E[40;32m'    # begin reverse video
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export NNN_CONTEXT_COLORS="1234"
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_OPENER="$HOME/.config/nnn/plugins/launch"
export NNN_OPTS='cEA'
export NNN_PLUG='t:lstar;T:trash;m:mediainf;o:fzopen;i:imgview;c:cbcp:C:cbcp -p;b:bcat;v:video;l:pager;r:launch;e:extract;p:spv'
export NNN_SSHFS_OPTS='sshfs -o allow_other,follow_symlinks,reconnect'
export PAGER=less
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export RANGER_LOAD_DEFAULT_RC=FALSE
export TERM=${TERM:-xterm-256color}
export TODOFILE="$XDG_CACHE_HOME"/.todo

source ~/.config/dircolors
source ~/.config/bash_aliases
source ~/.scripts/shell/functions.sh
source ~/.scripts/shell/mediainfo.sh
source ~/.scripts/shell/aria2.sh
source ~/.scripts/shell/fzf.sh
source /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/completions/man
complete -F _man man apropos whatis fzman

umask 0077

set -o vi
set -o noclobber
shopt -s autocd
shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -s histappend

expand_files() {
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
bind -x '"\C-x": expand_files'
fzfhist() {
    cmd=$(
        history | sed 's/^ *\?[0-9]* *//' | awk 'length($0) > 2' |
        fzf --info=hidden --border=none --layout=reverse \
            --height 20 --no-sort --tac --bind 'tab:accept'
    )
    READLINE_LINE="$cmd"
    READLINE_POINT=${#cmd}
}
bind -x '"\C-h": fzfhist'
fzfgov() {
    current=$(</sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    awk '{for (i=1;i<=NF;++i) print $i}' \
        /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors |
        fzf --header "current: $current" --height 8 | xargs -ro sudo cpupower frequency-set -g 
}
bind -x '"\C-g": fzfgov' 

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
    local git_branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1) /')
    # local fsize=$(find -L . -xdev -maxdepth 1 -type f -print0 | xargs -r0 du -ch | awk '/\ttotal$/{print $1}')
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
    # local last_mod=$(stat -c '%Z' "$PWD" | xargs -rI{} date --date='@{}' '+%b %d %H:%M')
    local last_mod=$(last_modified)
    # local lavg=$(uptime | grep -oP '(?<=load average: ).*')
    # local cpu_usage=$(ps axch -o %cpu | awk '{x+=$1}END{ printf("%.1f%%\n", x)}')
    # local ram_usage=$(free -h | awk '/Mem:/{print $3"/"$2}')
    local perm=$(stat -c '%a' .)
    PS1=""
    # PS1="${bar}(${red}\V${bar})-"
    PS1="${bar}(${grn}${perm}${bar})-"
    # test -n "$fsize" && PS1+="(${red}${fsize}${rst}${bar})-"
    # PS1+="($rst"
    # test -n "$file_count" && PS1+="${file_count::-2}, "
    # test "${hidden_count:-0}" -gt 0 && PS1+="$hidden_count ., "
    # PS1+="${files:-0}${bar})-"
    # test -n "$exts"      && PS1+="-(${rst}${exts::-2}${rst}${bar})$rst"
    test -n "$last_mod"  && PS1+="${bar}($rst$last_mod${bar})$rst"
    # test -n "$(jobs -p)" && PS1+="${bar}(${rst}\j${bar})"
    PS1+="\n"
    test -n "$VIRTUAL_ENV" && PS1+="$VIRTUAL_ENV_PROMPT "
    PS1+="\${timer_show}${blu}\w${rst}"
    PS1+="$git_branch"
    if test "${out:-0}" -eq 0;then

        PS1+="${grn}>$rst "
    else
        local beep=~/Music/Yuu_windows_theme/you_hmm?.wav
        [ -f "$beep" ] && { mpv --no-config --no-video --really-quiet "$beep" & disown; }
        PS1+=" (${red}${out}${rst}) ${red}!$rst "
        # PS1+="${red}>$rst "
    fi

    # set title
    echo -ne "\033]0;${PWD/$HOME/\~}\007"
}
PROMPT_COMMAND="prompt; timer_stop"

[ -f "${HOME}/.python_history" ] && command rm "${HOME}/.python_history"

if [ -n "$DISPLAY" ];then
    # printf '\e[1;31m'; cat ~/Documents/ASCII/Nerv; printf '\e[m\n'
    # shuf -n1 ~/.cache/quotes.csv | sed 's/|/\n\t- /'
    # random_color
    # random_anime_quote
    # bfetch
    todo ls 2>/dev/null
fi
function bye {
    echo "bye ^-^"
    [ -n "$SSH_CLIENT" ] && cat ~/.local/src/seeyouspacecowboy.txt
}
trap bye EXIT

fixkbd() {
    setxkbmap br
    setxkbmap -option caps:escape
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
