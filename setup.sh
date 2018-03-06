#!/bin/bash
sudo apt-get install gcc zlib1g-dev

mkdir -p tools
mkdir -p tools/osmconvert
mkdir -p tools/osmupdate

cd tools
wget https://github.com/berndw1960/aiostyles/archive/master.zip -O aiostyles-master.zip

cd osmconvert
wget -O - http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o osmconvert
cd ../osmupdate
wget -O - http://m.m.i24.cc/osmupdate.c | cc -x c - -o osmupdate

cd ../

wget http://www.mkgmap.org.uk/download/mkgmap-r4129.zip -O mkgmap.zip
unzip mkgmap.zip
mv mkgmap-r*/ mkgmap/

wget http://www.mkgmap.org.uk/download/splitter-r590.zip -O splitter.zip
unzip splitter.zip
mv splitter-r*/ splitter/

