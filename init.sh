#!/bin/bash 

TEMP_PATH="temp"
BUILDS_PATH="builds"
SITES_PATH="nginx/sites-enabled"

if [ ! -d "$TEMP_PATH" ]; then
  mkdir $TEMP_PATH
fi

if [ ! -d "$BUILDS_PATH" ]; then
  mkdir $BUILDS_PATH
fi

if [ ! -d "$SITES_PATH" ]; then
  mkdir $SITES_PATH
fi

docker-compose up -d