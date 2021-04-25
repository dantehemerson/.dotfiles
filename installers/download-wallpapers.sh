#!/bin/bash

OUTPUT_FOLDER=~/Pictures/Wallpapers1
mkdir -p $OUTPUT_FOLDER

for i in {1..7};
do
  echo $i
  wget "https://raw.githubusercontent.com/dantehemerson/resources/master/wallpapers/wallpaper$i.jpg" -P $OUTPUT_FOLDER 
done