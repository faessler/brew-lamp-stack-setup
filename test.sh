#!/bin/bash

# mkdir -p /Users/$(whoami)/Sites/AMP


# # ************************* #
# # 🔐 GET SUDO RIGHTS
# # ************************* #
# if ! sudo -n true &>/dev/null
# then
#     echo "To run this bash script properly you need sudo rights at some points. Please enter it now so you can lie back and will not be asked again for it."
#     sudo -v || exit 1
# fi
#
# sudo echo and here we go


# # ************************* #
# # PROGRESS ECHO
# # ************************* #
# pecho () {
#     # set progressEchoNumber variable to 1 if not existing
#     if [ -z "$progressEchoNumber" ]; then
#         progressEchoNumber=1
#     fi
#
#     # return the progress echo
#     echo -e "\e[38;5;245m[$progressEchoNumber/X]\e[0m $1"
#
#     # increment progressEchoNumber variable
#     ((progressEchoNumber++))
# }
# pecho test1 von hier
#
# pecho test2
#
# pecho "test 3"





# echo "Do you wish to install this program?"
# select yn in "Yes" "No"; do
#     case $yn in
#         Yes ) make install; break;;
#         No ) exit;;
#     esac
# done
#

# while true; do
#     read -p "Do you wish to install this program?" yn
#     case $yn in
#         [Yy]* ) make install; break;;
#         [Nn]* ) exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done



# Shutdown and stop system delivered apache from auto-start
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

# Installing apache
if ! [ "$(brew ls --versions httpd)" ];
then
    brew install httpd
else
    brew reinstall httpd
fi

# Add apache to autostart
brew services start httpd
