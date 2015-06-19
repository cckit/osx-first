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
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    (echo && echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"') >> ~/.bash_profile
    . ~/.bash_profile
}


# Tap formula repositories
function tapRepositories {
    brew tap homebrew/dupes
    brew tap caskroom/versions
}

function installGNUUtils {
    sudoWithPassword
    
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

function replaceDefaultTools {
    brew install bash
    brew install git
    brew install less
    brew install python
    brew install rsync
    brew install svn
    brew install vim --override-system-vi
}

function installNode {
    brew install nvm
    . $(brew --prefix nvm)/nvm.sh

    nvm install node
    nvm install iojs
    nvm alias default iojs
    nvm use default

    # Let nvm create symlink for node directory (/usr/local/opt/nvm/current) after switching between different versions
    # Useful for some IDE which need a static node directory
    (echo && echo 'export NVM_SYMLINK_CURRENT=true' && echo '. $(brew --prefix nvm)/nvm.sh') >> ~/.bash_profile
    . ~/.bash_profile
}

function installLanguages {
    sudoWithPassword
    
    brew cask install java
}

function installSystemUtils {
    sudoWithPassword
    
    brew cask install appcleaner
    brew cask install cocktail
    brew cask install disk-inventory-x
    brew cask install gfxcardstatus
    brew cask install osxfuse
    brew cask install the-unarchiver
}

function installDevelopmentTools {
    brew cask install jd-gui
    brew cask install sourcetree
    brew cask install sqlitestudio

    # Install p4merge and set it to be Git diff and merge tool
    brew cask install p4merge
    curl -SL# --retry 5 --retry-delay 5 -o /usr/local/bin/p4merge http://pempek.net/files/git-p4merge/mac/p4merge
    chmod +x /usr/local/bin/p4merge
    git config --global merge.tool p4merge
    git config --global mergetool.p4mergetool.cmd "/Applications/p4merge.app/Contents/Resources/launchp4merge \$BASE \$LOCAL \$REMOTE \$MERGED"
    git config --global mergetool.p4mergetool.trustExitCode false
    git config --global mergetool.keepBackup false
    git config --global mergetool.keepTemporaries false
    git config --global mergetool.prompt false
    git config --global diff.tool p4mergetool
    git config --global difftool.p4mergetool.cmd "/Applications/p4merge.app/Contents/Resources/launchp4merge \$LOCAL \$REMOTE"
    
    # Install Sublime Text with Package Control
    brew cask install sublime-text
    curl -SL# --retry 5 --retry-delay 5 --create-dirs -o "$HOME/Library/Application Support/Sublime Text 2/Packages/Package Control.sublime-package" https://packagecontrol.io/Package%20Control.sublime-package

    sudoWithPassword
    brew cask install wireshark-dev
}

function installIDEs {
    brew cask install eclipse-java
}

function installWebTools {
    brew cask install filezilla
    brew cask install firefox
    brew cask install google-chrome
    brew cask install teamviewer
    brew cask install tunnelblick
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

askForPassword
installXCodeTools
installHomebrewAndCask
tapRepositories
installGNUUtils
replaceDefaultTools
installNode
installLanguages
installSystemUtils
installDevelopmentTools
# installIDEs
# installWebTools
# installMultimedia
# installOther
