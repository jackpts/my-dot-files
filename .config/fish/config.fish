if status is-interactive
    # Commands to run in interactive sessions can go here
end


### For fisher plugins build
set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
# for file in $XDG_CONFIG_HOME/fish/conf.d/*.fish
#   buildin source $file 2>/dev/null
# end

if not functions -q fisher
    echo "Installing fisher for the first time..." >&2
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fisher
end

# theme
set -g theme_display_git yes
set -g theme_display_git_untracked yes
set -g theme_display_git_master_branch yes
set -g theme_title_use_abbreviated_path no
set -g fish_prompt_pwd_dir_length 0
set -g theme_project_dir_length 0
set -g theme_newline_cursor yes


### NVM
# bash /usr/share/nvm/init-nvm.sh
# export NVM_DIR="$(printf %s "$HOME/.nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

### BASE ALIASES
alias cp="cp -i"
alias df='df -h'
alias free='free -m'
alias qq='notepadqq $1 --allow-root'
alias cls='clear'
alias la='ls -A'
alias l='ls -CF'
alias cd..='cd ..'
alias z..='z ..'
alias logmeout='sudo pkill -u jacky'
alias pacman_clean='pacman -Rsn $(pacman -Qdtq)'
alias pacman_clear_cache='sudo paccache -r'
alias gnome_startup='gnome-session-properties'
alias rel_info='cat /etc/*rel*'

### Errors
abbr logs 'journalctl -xe'
abbr syslog 'sudo dmesg --level=emerg,alert,crit'
abbr sys_acpi 'sudo dmesg | grep ACPI'

### Gnome shell
abbr gnome_errors 'journalctl /usr/bin/gnome-shell -f -o cat'
abbr gnome_ver 'gnome-shell --version'
abbr ext_create 'gnome-extensions create --interactive'
abbr ext_list 'gnome-extensions list | grep jack'
abbr ext_edit 'nvim ~/github/gnome.ext.song.title/extension.js'
abbr ext_install 'gnome-extensions install ./gnome.ext.song.title.zip --force'
abbr ext_remove 'gnome-extensions uninstall gnome.ext.song.title@jackpts.github.com'
abbr ext_pack 'z ~/github && rm gnome.ext.song.title.zip && zip -r gnome.ext.song.title.zip ./gnome.ext.song.title -x "*.git*"'
abbr ext_enable 'gnome-extensions enable gnome.ext.song.title@jackpts.github.com'
abbr ext_disable 'gnome-extensions disable gnome.extsong.title@jackpts.github.com'
abbr ext_go 'cd /home/jacky/.local/share/gnome-shell/extensions/'
abbr ext_reload 'gnome-extensions disable gnome.extsong.title@jackpts.github.com && \
    gnome-extensions uninstall gnome.ext.song.title@jackpts.github.com && \
    z ~/github && rm gnome.ext.song.title.zip && zip -r gnome.ext.song.title.zip ./gnome.ext.song.title -x "*.git*" && \
    gnome-extensions install ./gnome.ext.song.title.zip --force
'

### EXPORTS
export EDITOR='nvim'
export VISUAL='nvim'
set HISTFILESIZE 2000
set -U -x TERMINAL alacritty
export PATH="$PATH:/opt/nvim-linux64/bin"


### MY CUSTOM ALIASES
alias bashedit='nvim ~/.bashrc --allow-root'
alias fishedit='nvim ~/.config/fish/config.fish'
alias neofetch_edit='sudo nano ~/.config/neofetch/config.conf'
alias catnap_edit='nvim ~/.config/catnap/config.toml'
alias alac_edit='nvim ~/.config/alacritty/alacritty.toml'
abbr u1 'sudo pacman -Suyy'
abbr u2 'yay -Suyy --noconfirm'
alias mirrors_list='cat /etc/pacman.d/mirrorlist'
alias mirrors_find='reflector --latest 20 --sort rate --protocol https'
alias mirrors_update='sudo reflector --latest 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist'
alias list_gnome_extensions='ls -1 ~/.local/share/gnome-shell/extensions/'
alias show_opened_ports='lsof -i -P -n | grep LISTEN'
alias pogoda_minsk='curl -4 https://wttr.in/Minsk'
alias ventoy_update='sudo ~/soft/ventoy-1.0.74/Ventoy2Disk.sh -u /dev/sda'
alias refind_conf_edit1='sudo nano /boot/refind_linux.conf'
alias refind_conf_edit2='sudo nano /boot/EFI/refind/refind.conf'
alias resolution_back='xrandr -s 2560x1600'
alias ssid_level='iwconfig wlan0 | gnmcli dev wifi'
alias change_shell_to_bash='chsh -s /bin/bash'
alias change_shell_to_fish='chsh -s /usr/bin/fish'
alias docker_mem_usage='docker stats --no-stream'
alias established='netstat -anp | grep ESTABLISHED'
alias cat bat
abbr list_x_sessions 'ls /usr/share/xsessions/'
abbr list_w_sessions 'ls /usr/share/wayland-sessions/'

### VPN
function proton_vpn
    z ~/vpn/proton/

    # regular options: nl | jp | us
    if test (count $argv) -gt 0
        set file_prefix "$argv[1]"
    else
        set file_prefix ''
    end

    set cur_vpn_file (find -name "$file_prefix*.ovpn" -type f -exec ls -lt {} + | sort -k6,7 | head -n1 | awk '{print $NF}')
    echo "VPN file used: $cur_vpn_file"
    sudo openvpn --config $cur_vpn_file --auth-user-pass pass.txt
end

### Tools
alias yt-mp3='cd ~/Downloads && yt-dlp --audio-format mp3 --embed-metadata --audio-quality 0 -x'

### FUNCTIONS

# function ll
# clear;
# tput cup 0 0;
# ls --color=auto -F --color=always -lhFrt $1;
# tput cup 40 0;
# end

function ex
    if [ -f $1 ]
        then
        switch $1
            case *.tar.bz2
                tar xjf $1
            case *.tar.gz
                tar xzf $1
            case *.bz2
                bunzip2 $1
            case *.rar
                unrar x $1
            case *.gz
                gunzip $1
            case *.tar
                tar xf $1
            case *.tbz2
                tar xjf $1
            case *.tgz
                tar xzf $1
            case *.zip
                unzip $1
            case *.Z
                uncompress $1
            case *.7z
                7z x $1
            case '*'
                echo "'$1' cannot be extracted via ex()"
        end
    else
        echo "'$1' is not a valid file"
    end
end

function backup
    set cur_Date (date +"%d%b-%H")
    set outputDir /run/media/jacky/back1up/regular

    if [ ! -d "$outputDir" ]
        then
        echo -e "Directory $outputDir doesn't exist!"
        exit 1
    end

    if test (count $argv) -lt 1
        echo -e "Backing up NextCloud"
        7z a -r -p1 "$outputDir/NextCloud-$cur_Date" /home/jacky/Nextcloud/Notes/*
        cp /home/jacky/.config/fish/config.fish "$outputDir/config.fish.$cur_Date"
    else
        ls -1 ~/.local/share/gnome-shell/extensions/ >/home/jacky/soft/gnome_ext_list.txt
        pacman -Qqen >/home/jacky/soft/pkglist_pacman.txt
        pacman -Qqem >/home/jacky/soft/pkglist_aur.txt

        set backupArr "$HOME/Nextcloud" \
            /etc/hosts \
            '/etc/resolv.conf' \
            /etc/profile \
            '/etc/nsswitch.conf' \
            /etc/fstab \
            '/etc/locale.conf' \
            '/etc/vconsole.conf' \
            '/etc/pacman.conf' \
            '/etc/pacman.d/mirrorlist' \
            '/boot/refind_linux.conf' \
            '/boot/EFI/refind/refind.conf' \
            "$HOME/.config/fish" \
            "$HOME/.local/share/remmina" \
            "$HOME/Documents/pgp" \
            "$HOME/.gnupg" \
            "$HOME/.ssh" \
            "$HOME/vpn" \
            "$HOME/soft/gnome_ext_list.txt" \
            "$HOME/soft/pkglist_pacman.txt" \
            "$HOME/soft/pkglist_aur.txt" \
            "$HOME/.git*" \
            "$HOME/.config/nvim" \
            "$HOME/.vimrc" \
            "$HOME/.config/alacritty/*.toml" \
            "$HOME/.tmux.conf" \
            "$HOME/.zshrc" \
            "$HOME/.bashrc" \
            "$HOME/.config/catnap/*.toml" \
            "$HOME/.config/mpd/mpd.conf" \
            "$HOME/.config/hypr/" \
            "$HOME/.ncmpcpp/config" \
            "$HOME/scripts/" \
            "/usr/share/wayland-sessions/hyprland.desktop" \
            "/etc/lxdm/lxdm.conf"

        for b in $backupArr
            7z u -bt $outputDir/all-$cur_Date.7z -spf2 $b
        end

    end
end

function backup_git
    set cur_Date (date +"%d%b-%H")
    set outputDir /run/media/jacky/back1up/regular

    sudo 7z u -bt $outputDir/git-$cur_Date.7z -spf2 -mx7 /home/jacky/git -xr!node_modules -xr!_others -xr!wpa2-wordlists '-xr!*.7z' '-xr!*.dump' '-xr!*.pack'
end

function backup_job
    set cur_Date (date +"%d%b-%H")
    set outputDir /run/media/jacky/back1up/regular

    sudo 7z u -bt $outputDir/jobs-$cur_Date.7z -spf2 -mx7 /home/jacky/Documents/CV /home/jacky/Documents/jobs/ /home/jacky/Documents/MyCerts
end

function backup_nvim
    set cur_Date (date +"%d%b-%H")
    set outputDir /run/media/jacky/back1up/regular

    sudo 7z u -bt $outputDir/nvim-$cur_Date.7z -spf2 -mx7 /home/jacky/.config/nvim /home/jacky/.local/share/nvim /home/jacky/.local/state/nvim /home/jacky/.cache/nvim
end

function write_iso
    # sudo dd if=$1 of=/dev/sda1 bs=4M status=progress conv=fsync
    sudo dd if=$1 of=/dev/sda1 bs=100M conv=fsync
end

function _tide_item_git
    fish_git_prompt
end

function fish_prompt__ --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')

    set gitstuff (_tide_item_git)
    # do other tide stuff
    printf '%s' $gitstuff $otherstuff

    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                         and set_color $fish_color_cwd_root
                                                         or set_color $fish_color_cwd) \
            (prompt_pwd) (set_color normal)
    else
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color --bold $fish_color_status)
        set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        printf (set_color yellow)'[%s] %s%s@%s %s%s %s%s%s \n> ' (date "+%H:%M:%S") (set_color brblue) \
            $USER (prompt_hostname) (set_color $fish_color_cwd) $PWD (set_color normal)'('(set_color purple)"$git_branch"(set_color normal)')' $pipestatus_string (set_color normal)
    end
end

# K8Ns
alias k='kubectl'
alias m='minikube'

# Mining
alias mining_start='cd ~/soft/NBMiner_Linux && ./start_eth.sh'
alias edit_miner='nvim ~/soft/NBMiner_Linux/start_eth.sh'

# NVIM
abbr n nvim
alias v "nvim ."
alias vim_plugins='nvim ~/.config/nvim/lua/plugins/user.lua'
alias vim_log='nvim ~/.local/state/nvim/lsp.log'
alias vim_startify='nvim +:Startify'
alias vim-astro="NVIM_APPNAME=AstroNvim nvim"
alias vim-lazy="NVIM_APPNAME=LazyVim nvim"

function :q
    exit
end

function beep
    # paplay /home/jacky/Music/ringtones/keep-moving_ring.mp3
    play -n synth 0.1 sine 880 vol 0.2
end

### git
abbr gl 'git log --oneline --graph'
abbr gs 'clear && git log --graph --stat'
abbr gss 'clear && git log --stat --color -p'

function gcl
    set directory (echo $argv | grep -oE '[^/]+$' | sed 's/.git//')
    git clone $argv && cd $directory
end


### FZF
fzf --fish | source

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

function _fzf_compgen_path
    fd --hidden --exclude .git . $1
end

function _fzf_comprun
    local command=$1
    shift

    switch $command
        case cd
            fzf --preview 'eza --tree --color=always {} | head -200' $argv
        case ssh
            fzf --preview "eval 'echo \$' {}" $argv
        case '*'
            fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" $argv
    end
end

alias ls="eza --color=always --long --git --icons=always"
# alias lll='eza -la --git'

function cd
    # builtin cd $argv
    z $argv
    ls
end

# SQL
abbr mysql mariadb



##################
### FINAL RUN ###
#################

# neofetch --colors 3 4 5 6 2 9 &&
# duf --hide special &&
# cowfortune
# fastfetch

catnap
