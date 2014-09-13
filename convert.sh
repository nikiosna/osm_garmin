#!/bin/bash
maxRam="1G"
if [ -z "$1" ]
then
    echo "usage: \"sh convert bsp.osm.pbf (bounder.poly)\""
    exit
else
    osmFile=$(pwd)
    osmFile="$osmFile/$1"
fi

rm -rf ./temp/*

if [ -z "$2" ]
then
    echo "keine boundary-file angegeben"
else
    echo "schneide Bereich aus der Karte heraus"
    boundary="$2"
    ./tools/osmconvert64/osmconvert $osmFile -B=$boundary --complex-ways -o=./temp/osm_cuted.osm.pbf
    osmFile=$(pwd)
    osmFile="$osmFile/temp/osm_cuted.osm.pbf"
    echo "zuschneiden der Karte abgeschlossen"
fi

echo "splitte map in kleinere tiles"
mkdir ./temp/splitter/
cd ./temp/splitter/
java -jar -Xmx$maxRam ../../tools/splitter/splitter.jar --max-nodes=1000000 $osmFile
echo "splitte der map abgeschlossen"

echo "konvertiere in gmapsupp.img"
cd ../../
mkdir ./temp/mkgmap/
cd ./temp/mkgmap/
java -jar -Xmx$maxRam ../../tools/mkgmap/mkgmap.jar \
    --latin1 \
    --route \
    --add-pois-to-areas \
    --index \
    --gmapsupp \
    ../splitter/6324*.osm.pbf \
    ../../tools/style/basemap.TYP
echo "konvertieren abgeschlossen"

echo "verschiebe generierte Karte"
mv ./gmapsupp.img ../../gmapsupp.img
echo "verschieben abgeschlossen"


