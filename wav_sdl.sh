#!/bin/bash

while getopts ":wfi" opt; do
	case $opt in
		w) #only new wav file
		ffmpeg -i "$file" -metadata title="$title" -metadata artist="$author" -metadata album="$album" -metadata track="$tracking" "$new_file.wav"
		;;
		f) #also convert to new flac file
		sox "$new_file.wav" "$new_file.flac"
		;;
		i) #inplace
		;;
		d) #delete inter wav file
		;;
	esac
done

if [ -z "$option" ]; then
	echo "No option specified, using -w as default"
	option="w"
fi

# Specify the root directory
root_dir="."
author=$(basename "$(pwd)")

# Use find to get a list of all files (including subdirectories)
files=$(find "$root_dir" -type f -name "*.wav")

# Loop through each file
IFS=$'\n'
for file in $files; do
    echo "$file"
	IFS="/"
	read -a parts <<< "$file"
    album="${parts[1]}"
    name="${parts[2]}"
    
    #echo "Author: $author"
    #echo "Album: $album"
    #echo "Name: $name"

	IFS=" "
	read -a details <<< "$name"
    
    tracking="${details[0]}"
    title="${details[1]}"
	
	IFS="."
	read -a name <<< "$title"
	title="${name[0]}"
    
    #echo "Tracking: $tracking"
    #echo "Title: $title"
    #echo

	mkdir -p "new_${author}/${album}"
	new_file="new_${author}/${album}/${title}"
	
	while getopts ":wfi" opt; do
		case $opt in
			w)
			ffmpeg -i "$file" -metadata title="$title" -metadata artist="$author" -metadata album="$album" -metadata track="$tracking" "$new_file.wav"
			;;
			f)
			sox "$new_file.wav" "$new_file.flac"
			;;
		esac
	done

	if [ -z "$option" ]; then
		echo "No option specified, using -w as default"
		option="w"
	fi

done

