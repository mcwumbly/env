#!/bin/bash

set -euo pipefail

setup_keyboard() {
  defaults write -g ApplePressAndHoldEnabled -bool false
  defaults write -g InitialKeyRepeat -int 10
  defaults write -g KeyRepeat -int 1
}

setup_brew() {
  echo "Installing homebrew..."
  if [[ -z "$(which brew)" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

run_brew() {
  echo "Running the Brewfile..."
  /usr/local/bin/brew update
  /usr/local/bin/brew tap Homebrew/bundle
  ln -sf $(pwd)/Brewfile ${HOME}/.Brewfile
  /usr/local/bin/brew bundle --global
  /usr/local/bin/brew bundle cleanup --force
}

clone_once() {
  local remote=$1
  local dst_dir="$2"
  local branch_name="${3:-master}"
  echo "Cloning $remote into $dst_dir"
  if [[ ! -d $dst_dir ]]; then
    if [[ -n $branch_name ]]
      then
	git clone --branch "$branch_name" "$remote" "$dst_dir"
      else
        git clone "$remote" "$dst_dir"
    fi
  fi
}

setup_ruby() {
  ruby-install ruby --latest --no-reinstall
}

setup_zshrc() {
  ln -sf $(pwd)/zshrc ${HOME}/.zshrc
}

setup_ruby_gems() {
  gem install aws-sdk-s3 concurrent-ruby unix-crypt
}

setup_python_pkgs() {
  pip3 install awscli boto3 pyaml tabulate
}

clone_once "https://github.com/chriskempson/base16-shell" "${HOME}/.config/base16-shell"

setup_keyboard
setup_brew
run_brew
setup_ruby
setup_zshrc
setup_ruby_gems
setup_python_pkgs
