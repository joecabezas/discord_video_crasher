#!/bin/sh

# change pix_fmt of input video
#ffmpeg -i $1 -pix_fmt yuv444p yuv444p.mp4
cp $1 yuv444p.mp4

#generate crash video
ffmpeg -y -f lavfi -i color="size=15000x15000:duration=0.44:rate=25:color=red" -pix_fmt yuv420p crash.mp4

# concatenate the 2 videos
echo "file yuv444p.mp4" > file_list.txt
echo "file crash.mp4" >> file_list.txt
ffmpeg -y -f concat -safe 0 -i file_list.txt -codec copy output.mp4

rm file_list.txt
rm yuv444p.mp4
