#!/bin/bash

FOLDER_NAME="./raw-data"
FILE_NAME="$FOLDER_NAME/taiwan-latest.osm.pbf"
DOWNLOAD_FROM_SOURCE="TRUE"

mkdir -p "$FOLDER_NAME"

if [ -f "$FILE_NAME" ]; then
  echo "$FILE_NAME exists, checking checksum"
  if [ "$(md5sum $FILE_NAME | cut -d " " -f 1)" = "$(curl -s https://download.geofabrik.de/asia/taiwan-latest.osm.pbf.md5 | cut -d " " -f 1)" ]; then
    echo "checksum match, skip downloading"
    DOWNLOAD_FROM_SOURCE="FALSE"
  fi
fi

if [ $DOWNLOAD_FROM_SOURCE = "TRUE" ]; then
  echo "Downloading OSM data..."
  wget -O ./raw-data/taiwan-latest.osm.pbf https://download.geofabrik.de/asia/taiwan-latest.osm.pbf
fi

# Create hstore extension.
psql -p 5432 -h localhost -U postgres -c 'CREATE EXTENSION IF NOT EXISTS hstore;'
psql -p 5432 -h localhost -U postgres -f "./scripts/bbox.sql"

# Import data
osm2pgsql -G --hstore -d postgres -U postgres -H 127.0.0.1 -P 5432 -S ./scripts/01_default.style $FILE_NAME