#!/bin/bash
if [ -z "$1" ] || [ -z "$2"]
then
    echo "usage: \"bash update.sh bsp.osm.pbf bsp.poly\""
    exit
fi

rootdir=$(pwd)
osmFile="$rootdir/$1"
boundary="$rootdir/$2"

rm -rf ./temp/
mkdir ./temp/
cp ./tools/osmconvert/osmconvert ./temp/osmconvert
cp ./tools/osmupdate/osmupdate ./temp/osmupdate
chmod +x ./temp/osmupdate
chmod +x ./temp/osmconvert

cd ./temp/
filename=$(basename "$osmFile")
newFile="$rootdir/new-$filename"
./osmupdate -v --day -B="$boundary" "$osmFile" "$newFile"

if [ -e "$newFile" ]
then
rm "$osmFile"
mv "$newFile"  "$osmFile"
else
    echo "Error updated file not found"
fi
