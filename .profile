# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state

# export GDK_BACKEND=x11
# export QT_QPA_PLATFORMTHEME=qt5ct
export XKB_DEFAULT_LAYOUT=br
export AMD_VULKAN_ICD=RADV
export BROWSER=/usr/bin/firefox
export EDITOR=/usr/bin/vim
export RANGER_LOAD_DEFAULT_RC=FALSE
export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9\-_.?@:&*'
export PASSWORD_STORE_CLIP_TIME=25

export NNN_OPENER=${XDG_CONFIG_HOME}/nnn/plugins/launch
export NNN_CONTEXT_COLORS="1234"
export NNN_FCOLORS='c1e22729006033f7c6d6abc4'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_OPTS='cEA'
export NNN_PLUG='t:lstar;T:trash;m:mediainf;i:imgview;c:cpb;C:cpp;v:video;e:extract;p:spv;h:crc32check'
export NNN_SSHFS_OPTS='sshfs -o allow_other,follow_symlinks,reconnect'

export ADB_VENDOR_KEYS=~/.config/android/adbkeys
export DOTNET_CLI_HOME=${XDG_DATA_HOME}/dotnet
export PARALLEL_HOME=${XDG_CONFIG_HOME}/parallel
export SQLITE_HISTORY=${XDG_DATA_HOME}/sqlite_history
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx"
export PASSWORD_STORE_DIR=${XDG_DATA_HOME}/pass
export LESSHISTFILE=${XDG_DATA_HOME}/lesshst  # LESSHISTFILE=-  to disable
export LESSKEY=${XDG_CONFIG_HOME}/less/lesskey
export CARGO_HOME=${XDG_DATA_HOME}/cargo
export GDRIVE_CONFIG_DIR=${XDG_CONFIG_HOME}/gdrive
export GNUPGHOME=${XDG_CONFIG_HOME}/gnupg
export GOPATH=${XDG_DATA_HOME}/go
export GTK_RC_FILES=${XDG_CONFIG_HOME}/gtk-1.0/gtkrc
export HISTFILE=${XDG_CACHE_HOME}/bash_history
export I3SOCK=${XDG_RUNTIME_DIR}/i3/ipc.sock
export SWAYSOCK=${XDG_RUNTIME_DIR}/sway-ipc.sock
export ICEAUTHORITY=${XDG_CACHE_HOME}/ICEauthority
export INPUTRC=${XDG_CONFIG_HOME}/readline/inputrc
export IPYTHONDIR=${XDG_CONFIG_HOME}/ipython
export JUPYTER_CONFIG_DIR=${XDG_CONFIG_HOME}/jupyter
export MYVIFMRC=${XDG_CONFIG_HOME}/vifm/vifmrc
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME}/npm/npmrc
export NODE_REPL_HISTORY=${XDG_DATA_HOME}/node_repl_history
export NVM_DIR=${XDG_CONFIG_HOME}/nvm
export PYTHONHISTFILE=${XDG_CACHE_HOME}/python/history
export RUSTUP_HOME=${XDG_DATA_HOME}/rustup
export WGETRC=${XDG_CONFIG_HOME}/wgetrc
export WINEPREFIX=${XDG_DATA_HOME}/wine
export XINITRC=${XDG_CONFIG_HOME}/X11/xinitrc
export NUGET_PACKAGES=${XDG_CACHE_HOME}/NuGetPackages
export RENPY_PATH_TO_SAVES=${XDG_DATA_HOME}/renpy
#export GTK2_RC_FILES=${XDG_CONFIG_HOME}/gtk-2.0/gtkrc
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=Adwaita-Dark
export PYTHONSTARTUP=~/.scripts/python/.startup.py

[ -f "$PYTHONSTARTUP" ] || unset PYTHONSTARTUP

append_path() {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="${PATH:+$PATH:}$1"
    esac
}

if [ -n "$WSLENV" ];then
    unset PATH
    append_path '/usr/lib/wsl/lib'
    append_path '/mnt/c/mpv'
    append_path '/usr/local/sbin'
    append_path '/usr/local/bin'
    append_path '/usr/bin'

    export XDG_RUNTIME_DIR=/run/user/1000
    export PULSE_SERVER=unix:/mnt/wslg/PulseServer
    BROWSER='/mnt/c/Program Files/Mozilla Firefox/firefox.exe'
fi

append_path "${CARGO_HOME}/bin"
append_path "${HOME}/.local/bin"

export PATH

# fix font problem
export _JAVA_OPTIONS="${_JAVA_OPTIONS} -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"
# -Dawt.useSystemAAFontSettings=lcd_hrgb
# -Dawt.useSystemAAFontSettings=gasp


if [ ! -d "${XDG_CONFIG_HOME}" ] || [ ! -d "${XDG_DATA_HOME}" ]
then
    mkdir -vp ~/.local/bin "$XDG_STATE_HOME" "$GNUPGHOME" "${PYTHONHISTFILE%/*}" \
             "${INPUTRC%/*}" "${ADB_VENDOR_KEYS%/*}"    \
             "$XDG_CONFIG_HOME"/{git,java,gtk-2.0,gtk-1.0} \
             "$XDG_CACHE_HOME"/{aria2,openjfx} \
             "$NUGET_PACKAGES" "${NPM_CONFIG_USERCONFIG%/*}"

    if ! [ -f "$WGETRC" ]
    then
        echo "hsts-file = ${XDG_CACHE_HOME}/wget-hsts" > "$WGETRC"
    fi

    if ! [ -f "$NPM_CONFIG_USERCONFIG" ]
    then
        printf '%s\n%s\n' \
            'cache=${XDG_CACHE_HOME}/npm' \
            'init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js' \
            > "${NPM_CONFIG_USERCONFIG}"
    fi
fi

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "${XDG_VTNR:-0}" -eq 1 ];then
    export TERMINAL=/usr/bin/foot
    export QT_QPA_PLATFORM=wayland
    export SDL_VIDEODRIVER=wayland,x11
    export XDG_SESSION_TYPE=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    # export ASAN_OPTIONS=abort_on_error=1:disable_coredump=0:unmap_shadow_on_exit=1
    # cp ~/.cache/sway.log ~/.cache/sway.log.old >/dev/null 2>&1 || true
    exec sway >/dev/null 2>&1 # >~/.cache/sway.log 2>&1
fi

# if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "${XDG_VTNR:-0}" -eq 1 ]
# then
#     export TERMINAL=/usr/bin/alacritty
#     export XAUTHORITY=${XDG_RUNTIME_DIR}/Xauthority
#     exec startx "$XINITRC" -- /etc/X11/xinit/xserverrc vt1 >/dev/null 2>&1
# fi

if test "$BASH" && test "$PS1" && test -z "$POSIXLY_CORRECT" && test "${0#-}" != sh && test -r ~/.bashrc
then
    . ~/.bashrc
fi
