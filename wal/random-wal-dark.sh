#!/bin/bash

# Set the path to your images
image_path="/home/min/wallpapers/"

# Get a random image file from the specified path
random_image=$(find "$image_path" -type f -name "*.jpg" -o -name "*.png" | shuf -n 1)

# Check if a random image is found
if [ -n "$random_image" ]; then
	# Set the wallpaper using 'wal'
	wal -i "$random_image"
	echo "Wallpaper set from: $random_image"
else
	echo "No image files found in the specified path."
fi
