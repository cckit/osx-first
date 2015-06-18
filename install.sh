#!/bin/sh

function askForPassword {
    echo -n Password:
    read -s password
    echo
}

function sudoWithPassword {
    # sudo from stdin before Homebrew install script need it
    sudo -k
    echo $password | sudo -S echo
}

function installXCodeTools {
    # Unattended installation of Xcode Command Line Tools
    bash <(curl -s https://raw.githubusercontent.com/timsutton/osx-vm-templates/master/scripts/xcode-cli-tools.sh)
}

function installHomebrewAndCask {
    sudoWithPassword
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
    brew doctor
    brew install caskroom/cask/brew-cask

    # Set application symlinks to /Applications
    (echo && echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"') >> ~/.bash_profile
    . ~/.bash_profile
}

function installGNUUtils {
    sudoWithPassword
    brew tap homebrew/dupes
    
    # Command line tools
    brew install coreutils
    brew install gnu-which --with-default-names
    brew install screen
    brew install watch
    brew install wget
    
    # Tools for data handling
    brew install diffutils
    brew install gawk
    brew install gnu-sed --with-default-names
    brew install grep --with-default-names
    brew install wdiff --with-gettext
    
    # Tools for files
    brew install findutils --with-default-names
    brew install gnu-tar --with-default-names
    brew install gzip

    # C libraries or tools
    brew install gnu-getopt --with-default-names
    brew install gnu-indent --with-default-names
    brew install gnutls --with-default-names
    
    (
        echo "# Use GNU utilities without prefix 'g'" \
        && echo 'PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"' \
        && echo 'PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"' \
        && echo 'MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"' \
        && echo 'MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"'
    ) >> ~/.bash_profile
    . ~/.bash_profile
}

function installNode {
    brew install nvm
    mkdir ~/.nvm
    cp $(brew --prefix nvm)/nvm-exec ~/.nvm/
    (echo && echo 'export NVM_DIR=~/.nvm') >> ~/.bash_profile
    . $(brew --prefix nvm)/nvm.sh

    nvm install node
    nvm install iojs
    nvm alias default iojs
    nvm use default

    # Let nvm create symlink for node directory (/usr/local/opt/nvm/current) after switching between different versions
    # Useful for some IDE which need a static node directory
    (echo 'export NVM_SYMLINK_CURRENT=true' && echo '. $(brew --prefix nvm)/nvm.sh') >> ~/.bash_profile
    . ~/.bash_profile
}

function installSystemUtils {
    brew cask install appcleaner
    brew cask install disk-inventory-x
    brew cask install gfxcardstatus
    brew cask install osxfuse
    brew cask install the-unarchiver
}

function installDevelopmentTools {
    brew cask install jd-gui
    brew cask install p4merge
    brew cask install sourcetree
    brew cask install sqlitestudio
    brew cask install sublime-text
    brew install wireshark --with-qt
}

function installLanguages {
    brew install java
    brew install mongodb
    brew install python
}

function installIDEs {
    brew cask install eclipse-java
}

function installWebTools {
    brew cask install filezilla
    brew cask install firefox
    brew cask install google-chrome
    brew cask install teamviewer
}

function installMultimedia {
    brew cask install flash-player
    brew cask install google-hangouts
    brew cask install skype
    brew cask install vlc
}

function installOther {
    brew cask install mactex
    brew cask install sony-ericsson-bridge
}

password=''
# askForPassword
installXCodeTools
installHomebrewAndCask
installGNUUtils
installNode
installSystemUtils
installDevelopmentTools
installLanguages
installIDEs
installWebTools
installMultimedia
installOther
