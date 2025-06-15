#!/bin/bash

minecraft_directory=$1
backup_directory=$2
world_name=$3

if [[ -z "$minecraft_directory" || -z "$backup_directory" || -z "$world_name" ]]; then
    echo 'PROPER USAGE - ./minecraft-backup.sh minecraft_directory backup_directory world_name'
    exit 1
fi

world_backup_directory=$backup_directory/$world_name
world_directory=$minecraft_directory/$world_name

echo $world_backup_directory
echo $world_directory

#Ensure directories are all good and ready
mkdir -p $world_backup_directory

current_time=$(date +%Y-%m-%d_%H-%M-%S)

file_name=$world_backup_directory/$current_time.zip

echo $current_time
echo $file_name
zip $file_name $world_directory

exit 0
