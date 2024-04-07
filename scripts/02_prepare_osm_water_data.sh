#!/bin/bash

FILE_NAME="water-polygons-split-3857.zip"
FOLDER_NAME="./raw-data"
FILE_PATH=$FOLDER_NAME/$FILE_NAME

if [ -f "$FILE_PATH" ]; then
  echo "$FILE_PATH exists, skip download."
else
  echo "Downloading OSM water data..."
  wget -O $FILE_PATH https://osmdata.openstreetmap.de/download/water-polygons-split-3857.zip
fi

unzip $FILE_PATH -d $FOLDER_NAME

echo "Start import"
ogr2ogr -f PostgreSQL PG:"dbname='postgres' host='127.0.0.1' port='5432' user='postgres' password=''" $FOLDER_NAME/water-polygons-split-3857/water_polygons.shp -lco GEOMETRY_NAME=way -lco SPATIAL_INDEX=NONE -lco EXTRACT_SCHEMA_FROM_LAYER_NAME=YES -nln water -lco FID=osm_id -overwrite

# Create index
psql -p 5432 -h localhost -U postgres -c 'CREATE INDEX water_way ON water USING GIST (way);'

rm -rf $FOLDER_NAME/water-polygons-split-3857
echo "Done"