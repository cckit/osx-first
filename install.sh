#!/bin/bash

# Uninstall existing Homebrew
function removeHomebrew() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)" -- -f -q || exit $?
    which -s brew && echo 'Pre-installed Homebrew still exists...' && exit 1 || (echo 'Pre-installed Homebrew uninstalled!' && exit 0)
}

function installTools() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install caskroom/cask/brew-cask
}

removeHomebrew || installBasic;
