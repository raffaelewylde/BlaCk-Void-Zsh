## == Common Function ==========================================================
## -- Echo Function ------------------------------------------------------------
evalenv() {
  local ENVNAME="$1"
  local ENVEXPORT="$2"
  local ENVEVAL="$3"
  local ENVPRE="$4"

  # Setup Variables
  local ENVDIR
  local ENVPATH="\${${ENVEXPORT}}"
  if [[ "${ENVNAME}" == *"/"* ]]; then
    ENVDIR="${ENVNAME#*/}"
    ENVNAME="${ENVNAME%/*}"
  else
    ENVDIR="${ENVNAME}"
  fi

  # Try to find ${ENVNAME}, if it's not on the path
  local path_command="export ${ENVEXPORT}=\"\${${ENVEXPORT}:=${HOME}/.${ENVDIR}}\""
  eval "${path_command}"
  echo "${path_command}"
  if (( ! ${+commands[${ENVNAME}]} )) && [[ -f ${ENVPATH}/bin/${ENVNAME} ]]; then
    echo "export PATH=\"${ENVPATH}/bin:\${PATH}\""
  fi
  if [[ ! -z "${ENVPRE}" ]]; then
    eval "${ENVPRE}"
  fi

  # Set PATH & Load
  if (( ${+commands[${ENVNAME}]} )); then
    echo "$(eval ${ENVEVAL})"
  fi
}

evalfn() {
  local FNNAME="$1"
  local FNEVAL="$2"

  if (( ${+commands[${FNNAME}]} )); then
    echo "$(eval ${FNEVAL})"
  fi
}

## -- Lazy Commands ------------------------------------------------------------
LAZYENV_COMMANDS=""
lazyenv-add() {
  LAZYENV_COMMANDS="${LAZYENV_COMMANDS=};evalenv $1 $2 \"$3\""
}
lazyfn-add() {
  LAZYENV_COMMANDS="${LAZYENV_COMMANDS=};evalfn $1 \"$2\""
}

lazyenv-apply() {
  zinit ice wait"2" id-as"_local/lazyenv" lucid \
          eval"${LAZYENV_COMMANDS}" run-atpull
  zinit light zdharma-continuum/null
  typeset -U path
}

## == Target of Environments ===================================================
ifF() {
  ((eval "$1") && echo "$2") || echo "$3"
}

# https://nick-tomlin.com/2018/03/10/speeding-up-zsh-loading-times-by-lazily-loading-nvm/
# @shihyuho/zsh-jenv-lazy

lazyenv-add nvm    NVM_DIR "
ifF '[[ \$OSTYPE == \"darwin\"* ]]' \
'[[ -s \\\$(brew --prefix nvm)/nvm.sh ]] && source \\\$(brew --prefix nvm)/nvm.sh --no-use' \
'[[ -s \"\${NVM_DIR}/nvm.sh\" ]] && . \"\${NVM_DIR}/nvm.sh\" --no-use
 [[ -s \"\${NVM_DIR}/bash_completion\" ]] && \. \"\${NVM_DIR}/bash_completion\"'
"
lazyenv-add rvm    RVM_ROOT "
ifF '[[ -s \"\$RVM_ROOT/scripts/rvm\" ]]' '. \"\$RVM_ROOT/scripts/rvm\"'"
lazyenv-add jenv   JENV_ROOT   "command jenv   init -"
lazyenv-add goenv  GOENV_ROOT  "command goenv  init -"
lazyenv-add plenv  PLENV_ROOT  "command plenv  init -"
lazyenv-add pyenv  PYENV_ROOT  "command pyenv  init -;
ifF '[[ -n \"\${ZSH_PYENV_LAZY_VIRTUALENV}\" ]]' '\$(command pyenv virtualenv-init -)'"
lazyenv-add rbenv  RBENV_ROOT  "command rbenv  init -"
lazyenv-add nodenv NODENV_ROOT "command nodenv init -"
lazyenv-add phpenv PHPENV_ROOT "command phpenv init -"
# lazyenv-add sdk/sdkman SDKMAN_DIR  "
# ifF '[[ -s \"\${SDKMAN_DIR}/bin/sdkman-init.sh\" ]]' 'source \"\${SDKMAN_DIR}/bin/sdkman-init.sh\"'" "
# [[ -s \"\${SDKMAN_DIR}/bin/sdkman-init.sh\" ]] && source \"\${SDKMAN_DIR}/bin/sdkman-init.sh\""

lazyfn-add hub     "hub alias -s"
lazyfn-add thefuck "thefuck --alias"
lazyfn-add scmpuff "scmpuff init -s"
lazyfn-add kubectl "kubectl completion zsh"
lazyfn-add brew    "echo 'FPATH=\\\$(brew --prefix)/share/zsh/site-functions:\$FPATH'"
lazyfn-add pip     "pip completion --zsh"

lazyenv-apply
