#! /bin/bash

# ==================================================================================================
# CONFIGURATION
# ==================================================================================================

# Your SoundCloud application key goes here
CONSUMER_KEY="7Eo3B0odlpK5FvOVUKDnQ"

# Latest JSON file URLs
LATEST_URL="http://donmez.apex-net.it/imortacci/api/v1/json/latest"
#!TODO: 'ALBUMS_URL' _should_ be recovered by 'LATEST_URL's response
ALBUMS_URL="http://donmez.apex-net.it/imortacci/download/8f6702c14658add1a892a5f2608387af.json"

DOWNLOAD_DIR=./tracks/

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# !!! DON'T TOUCH BELOW HERE !!!
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DEBUG=false
FILE_EXTENSION="mp3"
LATEST_FILE=../latest.json
ALBUMS_FILE=../albums.json

cd $DOWNLOAD_DIR

curl --silent $LATEST_URL > $LATEST_FILE
curl --silent $ALBUMS_URL > $ALBUMS_FILE

# Delete all previously downloaded files
find . -iname '*.$FILE_EXTENSION' -delete

# Download all music from SoundCloud
cat $ALBUMS_FILE | grep -oP '"download_url":".*?"' | grep -oP 'http://.*download' > .download_list~.tmp
for i in $(cat .download_list~.tmp); do
    echo $i | grep -oP '[0-9]+' > .track_id~.tmp
    track_id=$(cat .track_id~.tmp)
    if [ $DEBUG == true ]; then
        echo $track_id
        echo $i
        echo "$i?consumer_key=$CONSUMER_KEY > $track_id.$FILE_EXTENSION"
    fi
    curl -L $i?consumer_key=$CONSUMER_KEY > $track_id.$FILE_EXTENSION
done

if [ $DEBUG == false ]; then
    rm .download_list~.tmp .track_id~.tmp
fi

echo
echo "+--------------------------------------------------------------------+"
echo "|                   Everything is up-to-date now.                    |"
echo "| Don't forget to update Xcode project file to reflect the changes!  |"
echo "+--------------------------------------------------------------------+"

# End of file
