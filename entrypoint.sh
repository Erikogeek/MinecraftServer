#!/bin/sh
set -eu

if [ "${EULA:-false}" != "true" ]; then
echo "EULA not accepted. Set EULA=true (https://aka.ms/MinecraftEULA)." >&2
exit 1

fi 
echo="eula=true" > /data/eula.txt

exec java -jar /app/mcserver.jar

