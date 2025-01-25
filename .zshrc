# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    web-search
    sudo
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    copyfile
    copybuffer
    dirhistory
)

source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------
# USER CONFIGURATION
# -----------------------------------------------------


# -----------------------------------------------------
# Exports
# -----------------------------------------------------

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export PATH="/usr/lib/ccache/bin/:$PATH"

# Glitch image fix
export GSK_RENDERER=ngl

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# -----------------------------------------------------
# Customizations
# -----------------------------------------------------

# Initialize zoxide and map it to cd
eval "$(zoxide init --cmd cd zsh)"

# Initialize thefuck and map it to fuck
eval $(thefuck --alias fuck)

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey -e
# End of line configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Starship prompt
# eval "$(starship init zsh)"

# oh-my-posh prompt
# Custom theme
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Shipped theme
# eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/agnoster.omp.json)"

# -----------------------------------------------------
# Aliases
# -----------------------------------------------------

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# General aliases
alias nf='neofetch'
alias ff='fastfetch'
alias pf='fastfetch'
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias tree='eza -a --tree --level=1 --icons'
alias shutdown='systemctl poweroff'
alias ts='~/.config/ml4w/scripts/snapshot.sh'
alias cleanup='~/.config/ml4w/scripts/cleanup.sh'
alias wifi='nmtui'
alias hist='history | awk '\''{print $2}'\'' | sort | uniq -c | sort -rn | head -10'

cx() {
    cd "$1" && ls
}

# ML4W app aliases
alias ml4w='~/.config/ml4w/apps/ML4W_Welcome-x86_64.AppImage'
alias ml4w-settings='~/.config/ml4w/apps/ML4W_Dotfiles_Settings-x86_64.AppImage'
alias ml4w-sidebar='ags -t sidebar'
alias ml4w-hyprland='~/.config/ml4w/apps/ML4W_Hyprland_Settings-x86_64.AppImage'
alias ml4w-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-hyprland-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-qtile-diagnosis='~/.config/qtile/scripts/diagnosis.sh'
alias ml4w-update='~/.config/ml4w/update.sh'

# Qtile aliases
alias Qtile='startx'
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
alias setkb='setxkbmap de; echo "Keyboard set back to de."'

# Git aliases
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gst='git stash'
alias gsp='git stash; git pull'
alias gcheck='git checkout'
alias gcredential='git config credential.helper store'

# System and script aliases
alias ascii='~/.config/ml4w/scripts/figlet.sh'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# Autostart
# -----------------------------------------------------

# Pywal
cat ~/.cache/wal/sequences

# Fastfetch
if [[ $(tty) == *"pts"* ]]; then
    fastfetch --config examples/13
else
    echo
    if [ -f /bin/qtile ]; then
        echo "Start Qtile X11 with command Qtile"
    fi
    if [ -f /bin/hyprctl ]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('$HOME/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
