#! /bin/bash

# ==================================================================================================
# CONFIGURATION
# ==================================================================================================

# Your SoundCloud application key goes here
CONSUMER_KEY="7Eo3B0odlpK5FvOVUKDnQ"

# Latest JSON file URLs
BASE_URL="http://donmez.apex-net.it/imortacci/api/v1/json"

DOWNLOAD_DIR=./tracks/

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# !!! DON'T TOUCH BELOW HERE !!!
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DEBUG=false
FILE_EXTENSION="mp3"
LATEST_FILE=../latest.json
ALBUMS_FILE=../albums.json
COUNTS_FILE=../counters.json

cd $DOWNLOAD_DIR

# Delete all previously downloaded files
find . -iname '*.$FILE_EXTENSION' -delete

curl --silent $BASE_URL"/latest" > $LATEST_FILE
cat $LATEST_FILE | grep -oP 'http.*\.json' | sed s/\\\\//g > .albums~.tmp
curl --silent $(cat .albums~.tmp) > $ALBUMS_FILE

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

curl --silent $BASE_URL"/counters" > $COUNTS_FILE

if [ $DEBUG == false ]; then
    rm .*~.tmp
fi

echo
echo "+--------------------------------------------------------------------+"
echo "|               >>> Everything is up-to-date now! <<<                |"
echo "|  Don't forget to update Xcode project file to reflect the changes  |"
echo "+--------------------------------------------------------------------+"
echo
echo "Here's what to do:"
echo "  * Delete references for 'tracks/*.mp3' files"
echo "  * Drag and drop new 'tracks/*.mp3' files into the Xcode project"
echo "  * Take a deep breath and build! ;-)"
echo

# End of file
