#!/bin/bash
maxRam="4G"
if [ -z "$1" ]
then
    echo "usage: \"bash convert.sh bsp.osm.pbf (bounder.poly)\""
    exit
fi

rootdir=$(pwd)
osmFile="$rootdir/$1"
rm -rf "$rootdir/temp/"
mkdir "$rootdir/temp/"

if [ -z "$2" ]
then
    echo "keine boundary-file angegeben"
else
    echo "schneide Bereich aus der Karte aus"
    boundary="$rootdir/$2"
    cp "$rootdir/tools/osmconvert/osmconvert" "$rootdir/temp/osmconvert"
    chmod +x "$rootdir/temp/osmconvert"
    cd "$rootdir/temp/"
    ./osmconvert $osmFile -B=$boundary --complete-ways --complete-multipolygons -o="$rootdir/temp/osm_cuted.osm.pbf"
    osmFile="$rootdir/temp/osm_cuted.osm.pbf"
    echo "zuschneiden der Karte abgeschlossen"
fi

echo "splitte map in kleinere tiles"
mkdir "$rootdir/temp/splitter/"
cd "$rootdir/temp/splitter/"
java -jar -Xmx$maxRam ../../tools/splitter/splitter.jar --max-nodes=1000000 $osmFile
echo "splitte der map abgeschlossen"

echo "konvertiere in gmapsupp.img"
cd $rootdir
mkdir "$rootdir/temp/mkgmap/"
cd "$rootdir/temp/mkgmap/"
unzip "$rootdir/tools/aiostyles-master.zip" -d .
java -jar -Xmx$maxRam ../../tools/mkgmap/mkgmap.jar \
    --max-jobs=5 \
    --latin1 \
    --route \
    --add-pois-to-areas \
    --generate-sea \
    --housenumbers \
    --remove-short-arcs \
    --index \
    --style-file=aiostyles-master --style=basemap_style \
    --gmapsupp \
    ../splitter/6324*.osm.pbf
echo "konvertieren abgeschlossen"

echo "verschiebe generierte Karte"
cd $rootdir
mv "$rootdir/temp/mkgmap/gmapsupp.img" "$rootdir/gmapsupp.img"
echo "verschieben abgeschlossen"

echo "erstelle .zip datei"
poly="$2"
laenge=${#poly}
datei=${poly:0:$laenge-5}.zip
zip -r "$datei/$datei" "gmapsupp.img"
