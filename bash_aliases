### default
alias DIR='dir -lak --color=never'

alias ls='ls -vNh --color' \
    btm='btm -C ~/.config/bottom/config.toml' \
    dir='dir --color' \
    vdir='vdir --color' \
    diff='diff --color --unified=0' \
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
    xclip='xclip -sel clip' \
    ncdu='ncdu -x --color off --graph-style hash' \
    dosbox='dosbox -conf "$XDG_CONFIG_HOME"/dosbox/dosbox.conf' \
    top='top -u $USER' \
    yay='yay --removemake'

### sudo
alias mount='sudo mount' \
    umount='sudo umount' \
    fdisk='sudo fdisk' \
    iotop='sudo /sbin/iotop -e -o -d 5' \
    iftop='sudo iftop -nNP' \
    ptop='sudo /sbin/powertop' \
    neth='sudo nethogs -d 3 wlan0' \
    sss='sudo ss -tupln' \
    cpu='sudo cpupower frequency-set' \
    gputop='sudo intel_gpu_top'

### devour
alias dv='devour' dsx='devour sxiv'

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
    ll='ls -ltr --time-style "+%Y.%m.%d %H:%M"' \
    lm='ll |less' \
    lr='ll -R' \
    sl='ls' \
    loh='ls -d .[A-z]*'

### cd
alias cdg='cd ~/.local/src/b1337xyz'

### shortcuts
alias :w='echo ?' clock='tty-clock -cC 7 -f %d.%m.%y' \
    doit='git add -Av --chmod=-x && git commit -m "$(date +%Y.%m.%d)" && git push' \
    update_readme='git add README.md ; git commit -m "Update README.md"; git push' \
    reloadagent='gpg-connect-agent reloadagent /bye' \
    gb='cd -' \
    F='less +F' \
    cmd='command' \
    +x='chmod u+x' \
    -x='chmod a-x' \
    so='source' \
    v='vim' \
    vi='vim' \
    :q=exit \
    :x=exit \
    linuxlogo='linux_logo -c -u -y -L 13' \
    mpipe='mpv --playlist=- --no-resume-playback' \
    h='history | tail -n ' \
    atom='mount -o rw,async,noatime,noacl 192.168.1.10:/home/atom /mnt/anon/atom' \
    termux='sshfs termux:/data/data/com.termux/files/home ~/mnt/termux -o port=8022,allow_other,no_check_root,follow_symlinks,reconnect' \
    kcat='kitty icat' \
    jmtp='jmtpfs -o allow_other,noatime' \
    edi3='vim ~/.config/i3/config' \
    mdlnad='/sbin/minidlnad -f ~/.config/minidlna/minidlna.conf' \
    za='zathura' \
    py='python3' \
    mi='mediainfo' \
    fe='find . -maxdepth 1 -empty' \
    fwin='find . -type f -iregex ".*\.\(ini\|exe\|nfo\|bat\|url\)"' \
    gov='cat /sys/devices/system/cpu/cpu?/cpufreq/scaling_governor' \
    syncdir='rsync -a -f"+ */" -f"- *"' \
    psmem='ps axch -o cmd:15,%mem --sort=-%mem | head -10' \
    pscpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head -10' \
    grepinbrackets='grep -oP "\[\K[^\]]+"' \
    gpuinfo='lspci -nnk | grep -i VGA -A2' \
    soundcardinfo='lspci -nnk | grep -i audio -A2' \
    enabledservices='systemctl list-unit-files --state=enabled --no-pager' \
    yta='yt-dlp -x -f ba' \
    scrk='screenkey -t 0.4 -s medium -g 500x400-20-20' \
    nld='nload -i 192000 -o 80000 -u K wlan0' \
    fumnt='fusermount3 -u' \
    dff='df -Th -t fuse.rclone -t ext4 -t btrfs -t nfs4 --total' \
    tmux_defaults='tmux -f /dev/null -L temp start-server \; show-options -g' \
    update_gdl='python3 -m pip install --user -U -I --no-deps --no-cache-dir https://github.com/mikf/gallery-dl/archive/master.tar.gz' \
    update_ytdl='python3 -m pip install --user --force-reinstall https://github.com/yt-dlp/yt-dlp/archive/master.tar.gz' \
    tsxiv='find . -maxdepth 3 -type f -iregex ".*\.\(jpe?g\|png\)" -printf "%C@ %p\n" | sort -rn | cut -d" " -f2- | sxiv -qi' \
    tmpv='find . -maxdepth 3 -type f -iregex ".*\.\(mkv\|mp4\|webm\|avi\|m4v\|gif\)" -printf "%C@ %p\n" | sort -rn | cut -d" " -f2- | mpv --playlist=-' \
    pfa='pgrep -fa'
    

### pacman
alias pSs='pacman -Ss' \
    pSi='pacman -Si' \
    pSg='pacman -Sg' \
    pQe='pacman -Qe' \
    pQm='pacman -Qm' \
    pQs='pacman -Qs' \
    pQi='pacman -Qi' \
    pQu='pacman -Qu' \
    pQen='pacman -Qent' \
    pQtd='pacman -Qttdq' \
    pS='sudo pacman -S' \
    pSyu='sudo pacman -Syu' \
    pRns='pacman -Qtdq | sudo pacman -Rns -' \
    yScc='yay -Scc' \
    ySyu='yay -Syu'
