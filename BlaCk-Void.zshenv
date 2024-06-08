# Unused vars don't check
# shellcheck disable=SC2034,1090

## == Custom Values ============================================================
## -- Performance Related ------------------------------------------------------
## Avoid loading global configuration
# https://unix.stackexchange.com/questions/497050/case-insensitve-tab-completion-zsh-without-increasing-startup-time-significantly
unsetopt GLOBAL_RCS

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

# 10ms for key sequences (Decrease key input delay)
# https://www.johnhawthorn.com/2012/09/vi-escape-delays/
export KEYTIMEOUT=1

## -- Reserved Variables -------------------------------------------------------
## XDG  Base Directory
# https://specifications.freedesktop.org/basedir-spec/latest/
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
## (( ${+*} )) = if variable is set don't set it anymore. or use [[ -z ${*} ]]
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_CACHE_HOME}  )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_DATA_HOME}   )) || export XDG_DATA_HOME="$HOME/.local/share"

## Other System
(( ${+USER}     )) || export USER="$USERNAME"
(( ${+HOSTNAME} )) || export HOSTNAME="$HOST"
(( ${+LANG}     )) || export LANG="en_US.UTF-8"
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+LC_ALL}   )) || export LC_ALL="$LANG"

## Common Apps
# https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08_01
export EDITOR="nvim"
export VISUAL=$EDITOR
export FCEDIT=$EDITOR
export SYSTEMD_EDITOR=$EDITOR # for systemctl
export PAGER=bat
export MANPAGER="$PAGER"

## == Set Path =================================================================
## -- CDPATH ---------------------------------------------------------------------
# on cd command offer dirs in home and one dir up.
cdpath+=("$HOME" "..")
export cdpath

## -- FPATH ---------------------------------------------------------------------

## -- MANPATH ---------------------------------------------------------------------
manpath+=(/usr/local/man /usr/share/man)
export manpath

## -- PATH ---------------------------------------------------------------------
export PATH="/Users/wylde/.luarocks/bin:/opt/local/bin:/Users/wylde/.local/bin:/Users/wylde/go/bin:/Users/wylde/bin:/usr/local/opt/llvm/bin:/Users/wylde/.opam/default/bin:/Users/wylde/.local/share/bob/nvim-bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/wylde/.hishtory:/usr/local/opt/ccache/libexec:/usr/local/games:$PATH"
## -- Cleanup --------------------------------------------------------------------
# remove empty components to avoid '::' ending up + resulting in './' being in $PATH
path=( "${path[@]:#}" )

## eliminates duplicates in *paths
typeset -gU cdpath fpath path

## == Zprofile =================================================================
# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
export ZDOTDIR=${ZDOTDIR:-$HOME}
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "$ZDOTDIR/.zprofile" ]]; then
  source "$ZDOTDIR/.zprofile"
fi
