#!/usr/bin/env bash

main() {
  setup_completions() {
    autoload -U compinit
    compinit
    autoload -U bashcompinit
    bashcompinit
  }
  setup_aliases() {
    alias vim=nvim
    alias vi=nvim
    alias ll="ls -al"
  }
  setup_env() {
    export EDITOR=nvim
    export CLICOLOR=1
    export LSCOLORS exfxcxdxbxegedabagacad
  }
  setup_base16() {
    # Base16 Shell
    BASE16_SHELL="$HOME/.config/base16-shell/"
    [ -n "$PS1" ] && \
        [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
            eval "$("$BASE16_SHELL/profile_helper.sh")"
    THEME=base16-gruvbox-dark-hard
    _base16 "$BASE16_SHELL/scripts/$THEME.sh"
  }
  setup_chruby() {
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
    chruby $(chruby | tail -n 1 | tr -d ' *')
  }

  setup_completions
  setup_aliases
  setup_env
  setup_base16
  setup_chruby
}

main
unset -f main

# functions

git_author() {
  if [ -z "$1" ]; then
    echo "user.name: $(git config --local user.name)"
    echo "user.email: $(git config --local user.email)"
    echo ""
    echo "set email with:"
    echo "git_author <email address>"
  else 
    git config --local user.name "David McClure"
    git config --local user.email "$1"
  fi
}

