#!/bin/bash

GREEN=$'\e[0;32m'
YELLOW=$'\e[0;33m'
RED=$'\e[0;31m'
NC=$'\e[0m'

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

echo "${GREEN}Your available disks are: ${NC}"
diskutil list

echo "--> ${GREEN}Please provide the name of the disk you want to clone (ex. /dev/disk2), then press [ENTER]: ${NC}"
read disk_to_clone

echo "--> ${GREEN}Please provide a name for the image file, then press [ENTER]: ${NC}"
read image_name

echo "--> ${YELLOW}Unmounting selected disk...${NC}"
if [! diskutil unmountDisk $disk_to_clone ] ; then
    exit
fi

echo "--> ${YELLOW}Creating image, this will take some" time ${NC}
echo "--> ${YELLOW}Press Ctl+T to show your current progress. Interruts progress bar, but does not affect duplication progress.${NC}"
time sudo dd if=$disk_to_clone of=$image_name.img bs=1m & PID=$!
printf "["
# While process is running...
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 5
done
printf "] done!"

exit