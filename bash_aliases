### DEFAULT
alias ls='ls -vNh --color' \
    dir='dir --color' \
    vdir='vdir --color' \
    diff='diff --color' \
    tree='tree -C' \
    ip='ip -c' \
    ln='ln -v' \
    df='df -h' \
    free='free -h' \
    cp='cp -v' \
    mv='mv -iv' \
    rm='rm -Iv' \
    ffmpeg='ffmpeg -hide_banner' \
    rsync='rsync -hP' \
    shutdown='/sbin/shutdown' \
    suspend='systemctl suspend' \
    reboot='/sbin/reboot' \
    mount='sudo mount' \
    umount='sudo umount' \
    xclip='xclip -sel clip' \
    iftop='sudo iftop -nN' \
    iotop='sudo /sbin/iotop -e -o -d 5' \
    ncdu='ncdu -x --color off --graph-style hash' \
    dosbox='dosbox -conf "$XDG_CONFIG_HOME"/dosbox/dosbox.conf' \
    top='top -u $USER'

### cd
alias dow='cd ~/Downloads' \
    vid='cd ~/Videos' \
    doc='cd ~/Documents' \
    pic='cd ~/Pictures' \
    wal='cd ~/Pictures/wallpapers'

### devour
alias dsx='devour sxiv'

### exa
alias exl='exa -l' \
    ext='exa -T' \
    exm='exa -m' \
    exc='exa -u' \
    exh='exa -a'

### ls
alias lx='ls -X' \
    lk='ls -lSr' \
    l1='ls -1v' \
    lt='ls -ltr' \
    lc='ls -ltcr' \
    lu='ls -ltur' \
    la='ls -A' \
    l='command ls -vN1hl' \
    ll='ls -ltr --time-style "+%Y.%m.%d %H:%M"'   \
    lm='ll |less' \
    lr='ll -R'    \
    loh='ls -d .[A-z]*'


### shortcuts
alias clock='tty-clock -scC 7' \
    +x='chmod u+x' \
    -x='chmod a-x' \
    ytdl='yt-dlp -o "%(title)s.%(ext)s"' \
    mnt='sudo mount -o noatime,users' \
    umnt='sudo umount' \
    so='source' \
    v='nvim' \
    vi='nvim' \
    :q=exit \
    :x=exit \
    linuxlogo='linux_logo -c -u -y -L 13' \
    mpipe='mpv --playlist=- --no-resume-playback --loop-file=inf' \
    h='history | tail -n ' \
    artix='sshfs atom:mnt ~/mnt/artix -o Compression=no,reconnect,allow_other' \
    termux='sshfs termux:/data/data/com.termux/files/home ~/mnt/termux -o port=8022,allow_other,no_check_root,follow_symlinks,reconnect' \
    kcat='kitty icat' \
    sl='ls' \
    jmtp='jmtpfs -o allow_other,noatime' \
    ptop='sudo /sbin/powertop' \
    neth='sudo nethogs -d 3 wlan0' \
    edi3='vim ~/.config/i3/config' \
    mdlnad='/sbin/minidlnad -f ~/.config/minidlna/minidlna.conf' \
    py='python3' \
    mi='mediainfo' \
    sss='sudo ss -tupln' \
    fe='find . -maxdepth 1 -empty' \
    fwin='find . -type f -iregex ".*\.\(ini\|exe\|nfo\|bat\)"' \
    sx='startx &>/dev/null' \
    gov='cat /sys/devices/system/cpu/cpu?/cpufreq/scaling_governor' \
    cpu='sudo cpupower frequency-set' \
    mal='mal.py' \
    syncdir='rsync -a -f"+ */" -f"- *"' \
    psmem='ps axch -o cmd:15,%mem --sort=-%mem | head -10' \
    pscpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head -10' \
    grepinbrackets='grep -oP "\[\K[^\]]+"' \
    gpuinfo='lspci -nnk | grep -i VGA -A2' \
    soundcardinfo='lspci -nnk | grep -i audio -A2' \
    enabledservices='systemctl list-unit-files --state=enabled --no-pager' \
    yta='yt-dlp -x --audio-format mp3' \
    gputop='sudo intel_gpu_top' \
    scrk='screenkey -t 0.4 -s medium -g 500x400-20-20' \
    nld='nload -i 192000 -o 80000 -u K wlan0' \
    fumnt='fusermount3 -u' \
    dft='df -Th -x tmpfs -x devtmpfs --total' \
    dff='df -ht ext4 -t btrfs --total' \
    tmux_defaults='tmux -f /dev/null -L temp start-server \; show-options -g'


### pacman
alias pSs='pacman -Ss' \
    pSi='pacman -Si' \
    pSg='pacman -Sg' \
    pQe='pacman -Qe' \
    pQm='pacman -Qm' \
    pQs='pacman -Qs' \
    pQent='pacman -Qent' \
    pS='sudo pacman -S' \
    pSyu='sudo pacman -Syu' \
    ySyu='yay -Syu' \
    pRns='pacman -Qtdq | sudo pacman -Rns -' \
    pQttd='pacman -Qttdq'