#!/bin/bash

# ************************* #
# 🛠 HELPER FUNCTIONS
# ************************* #
# PROGRESS ECHO
# e.g. pecho "my message"
pecho () {
    # set progressEchoNumber variable to 1 if not existing
    if [ -z "$progressEchoNumber" ]; then
        progressEchoNumber=1
    fi

    # return the progress echo
    echo -en "\e[38;5;245m[$progressEchoNumber/X]\e[0m $1 "

    # increment progressEchoNumber variable
    ((progressEchoNumber++))
}


# STATUS ECHO
# e.g. secho ok|not
secho () {
    # echo ok or not ok depending on $1
    if [ $1 == "ok" ]; then
        echo -e "\e[38;5;76m✔\e[39m ok $2"
    fi

    if [ $1 == "not" ]; then
        echo -e "\e[38;5;160m✘\e[39m not ok $2"
    fi
}



# ************************* #
# 🔐 GET SUDO PRIVILEGES
# ************************* #
if ! sudo -n true &>/dev/null
then
    echo "🔐 To run this bash script properly you need sudo rights at some points. Please enter it now so you can lie back and will not be asked again for it."
    sudo -v || exit 1
fi



# ************************* #
# 🔍 CHECKING ENVIRONMENT
# ************************* #
# 💽 INSTALL XCODE
pecho "💽 Checking if Xcode is installed..."
if ! pkgutil --pkg-info=com.apple.pkg.CLTools_Executables &>/dev/null
then
    secho not
    xcode-select --install
    echo "Please install now! Follow the Xcode guide and hit enter after installing it."
    read
else
    secho ok
fi


# 🍺 INSTALL HOMEBREW
pecho "🍺 Checking if Homebrew is installed..."
if ! which brew &>/dev/null
then
    secho not
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    secho ok
fi


# # UPDATE HOMEBREW
# # @todo: commented because it needs a lot of time, uncomment when ready to commit :)
# pecho "🔄 Update and cleanup Homebrew..."
# brew update &>/dev/null
# brew cleanup &>/dev/null
# secho ok



# **************************************************************************** #



# ************************* #
# 🦅 INSTALL APACHE
# ************************* #
pecho "🦅 Setting up Apache (httpd)..."

# Shutdown and stop system delivered apache from auto-start
sudo apachectl stop 2>/dev/null
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

# Install apache
if ! [ "$(brew ls --versions httpd)" ];
then
    brew install httpd &>/dev/null
else
    brew reinstall httpd &>/dev/null
fi

# Add to launchd start
brew services start httpd &>/dev/null

# Apache installed
secho ok



# ************************* #
# 🐘 INSTALL PHP
# ************************* #
pecho "🐘 Setting up PHP (56, 70, 71, 72)..."

# Unlink all possibly installed php versions
brew unlink php53 2>/dev/null
brew unlink php54 2>/dev/null
brew unlink php55 2>/dev/null
brew unlink php@5.6 2>/dev/null
brew unlink php@7.0 2>/dev/null
brew unlink php@7.1 2>/dev/null
brew unlink php@7.2 2>/dev/null

# Install all php versions from the phpVersions array
phpVersions=("5.6" "7.0" "7.1" "7.2")

for i in "${phpVersions[@]}"
do
    # Install php
	if ! [ "$(brew ls --versions php@$i)" ];
	then
        brew install php@$i &>/dev/null
    else
        brew reinstall php@$i &>/dev/null
	fi

    # @TODO: If you need to have php@7.0 first in your PATH run:
    # echo 'export PATH="/usr/local/opt/php@7.0/bin:$PATH"' >> ~/.zshrc
    # echo 'export PATH="/usr/local/opt/php@7.0/sbin:$PATH"' >> ~/.zshrc

    # For compilers
    # @TODO: Test if it works with the $i variable
    export LDFLAGS="-L/usr/local/opt/php@$i/lib"
    export CPPFLAGS="-I/usr/local/opt/php@$i/include"

    # Add to launchd start
    brew services start php@$i &>/dev/null

    # Unlink
    brew unlink php@$i &>/dev/null
done

# PHP installed
secho ok



# ************************* #
# 🐬 INSTALL MYSQL
# ************************* #
pecho "🐬 Setting up MySQL (5.7)..."

# Install mysql
if ! [ "$(brew ls --versions mysql@5.7)" ];
then
    brew install mysql@5.7 &>/dev/null
else
    brew reinstall mysql@5.7 &>/dev/null
fi

# @TODO: If you need to have mysql@5.7 first in your PATH run:
# echo 'export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"' >> ~/.zshrc

# For compilers
export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"

# For pkg-config
export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"

# Add to launchd start
brew services start mysql@5.7 &>/dev/null

# MySQL installed
secho ok



# **************************************************************************** #



# ************************* #
# 📦 CONFIGURATE LAMP STACK
# ************************* #
# Configurate apache
pecho "🦅 Configuring Apache (httpd)..."
mkdir -p /Users/$(whoami)/Sites/AMP/httpd
cp /usr/local/etc/httpd/httpd.conf /Users/$(whoami)/Sites/AMP/httpd/httpd.conf
secho ok
# @todo: config it

# Configurate php

# Configurate mysql
