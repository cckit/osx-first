#!/bin/bash

# Uninstall existing Homebrew
function removeHomebrew() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
    which -s brew

    if [ $? -ne 0 ]; then
        echo 'Pre-installed Homebrew uninstalled!'
    else
        echo 'Pre-installed Homebrew still exists...'
        exit 1
    fi
}

function installTools() {
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew install caskroom/cask/brew-cask
}

removeHomebrew || installBasic;
