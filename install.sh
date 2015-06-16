#!/bin/bash

# Uninstall existing Homebrew
function removeHomebrew() {
    if [[ ! $DEBUG ]]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)" -- -f -q || exit $?
        (which -s brew && echo 'Pre-installed Homebrew still exists...' && exit 1) || (echo 'Pre-installed Homebrew uninstalled!' && exit 0)
    else
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)" -- --dry-run -f -q || exit $?
    fi
}

function installHomebrewAndCask() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
    brew cleanup
    brew install caskroom/cask/brew-cask

    # Set application symlinks to /Applications
    (echo && echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"') >> ~/.bash_profile

    if [ $DEBUG ]; then
        # List applications
        echo ${apps[@]}
    fi
}

removeHomebrew && installHomebrewAndCask
brew install coreutils
brew install tree
sudo tree -a -u -g --sort=name -n --nolinks -- /
