#!/bin/bash

# Wrapper script to make DD a bit friendlier
# Copyright (C) 2021 Michael Wood (me@mwood.dev)
# Permission to copy and modify is granted under the MIT License
# Last revised 12/10/2021

green=$'\e[0;32m'
yellow=$'\e[0;33m'
red=$'\e[0;31m'
nc=$'\e[0m'

cat << "EOF"
___  ____                ___________       _             _ _           _             
|  \/  (_)              /  ___|  _  \     | |           | (_)         | |            
| .  . |_  ___ _ __ ___ \ `--.| | | |   __| |_   _ _ __ | |_  ___ __ _| |_ ___  _ __ 
| |\/| | |/ __| '__/ _ \ `--. \ | | |  / _` | | | | '_ \| | |/ __/ _` | __/ _ \| '__|
| |  | | | (__| | | (_) /\__/ / |/ /  | (_| | |_| | |_) | | | (_| (_| | || (_) | |   
\_|  |_/_|\___|_|  \___/\____/|___/    \__,_|\__,_| .__/|_|_|\___\__,_|\__\___/|_|   
                                                  | |                                
                                                  |_|                                
EOF

echo "${green}What do you want to do? Enter a number followed by [ENTER]:${nc}"
options=(
    "Create an image of an SD Card"
    "Copy an existing image onto an SD Card"
    "Quit"
)
select opt in "${options[@]}"
do
    case $opt in
        *"Create"*)
            echo "${yellow}--> Create an image <--${nc}"
            break
            ;;
        *"Copy"*)
            echo "${yellow}--> Copy an existing image <--${nc}"
            break
            ;;
        *"Quit"*)
            echo "${yellow}--> Quitting <--${nc}"
            exit
            ;;
        *) echo "${red}Invalid entry, try again${nc}"
    esac
done

echo "${green}Your available disks are: ${nc}"
diskutil list

echo "--> ${green}Please provide the name of the disk you want to clone (ex. /dev/disk2), then press [ENTER]: ${nc}"
read disk_to_clone

unmount () {
    echo "--> ${yellow}Unmounting selected disk $1...${nc}"
    diskutil unmountDisk $1
}

dd () {
    echo "--> ${yellow}Creating image, this will take some" time ${nc}
    echo "--> ${red}Press Ctl+T to show your current progress, or press Ctl+C to cancel${nc} <--"
    time sudo dd if=$1 of=$2 bs=1m
}

create_image () {
    echo "--> ${green}Please provide a name for the image file, then press [ENTER]: ${nc}"
    read image_name
    unmount $disk_to_clone
    dd $disk_to_clone $image_name.img status=progress
}

# untested
copy_existing () {
    echo "--> ${green}Please provide the name of the existing the image file, then press [ENTER]: ${nc}"
    read image_name
    unmount $disk_to_clone
    dd $image_name.img $disk_to_clone status=progress
}

case $REPLY in
    1)
        create_image;
        break
        ;;
    2)
        copy_existing;
        break
        ;;
esac

exit