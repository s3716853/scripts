#!/bin/bash

minecraft_directory=$1

if [[ -z "$minecraft_directory" ]]; then
    echo 'PROPER USAGE - ./minecraft-update.sh minecraft/directory'
    exit 1
fi

# Extract Version Number from current server.jar
old_jar_version=$(unzip -p $minecraft_directory/server.jar version.json | jq ".name")
old_jar_version="${old_jar_version//\"/}" #remove ""

versions_manifest=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json)

# Get Newest Minecraft Version Number
latest_jar_version=$(echo "$versions_manifest" | jq '.latest.release')
latest_jar_version="${latest_jar_version//\"/}" #remove ""

# If our server is behind, time to upgrade
echo "Current Version: $old_jar_version"
echo "Latest Version: $latest_jar_version"
if [ "$old_jar_version" != "$latest_jar_version"  ]; then
    # Get the URL for the latest minecrat server version
    latest_jar_manifest_url=$(echo $versions_manifest | jq -r --arg id "$latest_jar_version" '.versions[] | select(.id == $id) | .url')
    latest_jar_url=$(curl -s $latest_jar_manifest_url -s | jq '.downloads.server.url')
    latest_jar_url="${latest_jar_url//\"/}" #remove ""

    mkdir -p $minecraft_directory/server_jar_backup
    mv $minecraft_directory/server.jar $minecraft_directory/server_jar_backup/server_$old_jar_version.jar

    curl $latest_jar_url --output $minecraft_directory/server.jar

    echo "Upgrade from $old_jar_version to $latest_jar_version complete"
else
    echo "Versions match. No update needed." 
fi