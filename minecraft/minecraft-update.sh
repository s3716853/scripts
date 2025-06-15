#!/bin/bash

eppoch_time=$(date +%s)

# Example value='    "name": "1.21.5",' (excluding the ' ')
old_jar_version_string=$(unzip -p server.jar version.json | grep "name")

manifest=#(curl https://launchermeta.mojang.com/mc/game/version_manifest.json)

latest_jar_version=$($manifest | jq '.latest.release')
latest_jar_url=$(curl https://piston-meta.mojang.com/v1/packages/3ca944c82c5e058dda4749eb6d871e4962cc886a/1.21.5.json | jq '.downloads.server.url')


minecraft_down_url="https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar"

mkdir -p server_jar_backup

mv server.jar server_jar_backup/server_$old_jar_suffix.jar

curl $minecraft_down_url --output server.jar

[[ "$latest_jar_version" ]]