#!/bin/sh

TIMESTAMP=2.6
MID_DURATION=0.3
INPUT=input_edit.mp4

DURATION=$(ffprobe -i $INPUT -show_entries format=duration -v quiet -of csv="p=0")
MID_END=$(echo "$TIMESTAMP + $MID_DURATION" | bc)

ffmpeg -i $INPUT -ss 0 -t $TIMESTAMP part1.mp4
ffmpeg -i $INPUT -ss $TIMESTAMP -t $MID_END part2.mp4
ffmpeg -i $INPUT -ss $MID_END -t $DURATION part3.mp4

ffmpeg -i part1.mp4 -pix_fmt yuv444p part1_new.mp4
ffmpeg -i part2.mp4 -pix_fmt d3d11va_vld part2_new.mp4
ffmpeg -i part3.mp4 -pix_fmt yuv444p part3_new.mp4

echo "file part1_new.mp4" > file_list.txt
echo "file part2_new.mp4" >> file_list.txt

ffmpeg -y -f concat -safe 0 -i file_list.txt -codec copy part1_2.mp4

echo "file part1_2.mp4" > file_list.txt
echo "file part3_new.mp4" >> file_list.txt

ffmpeg -y -f concat -safe 0 -i file_list.txt -codec copy output.mp4

rm part1.mp4
rm part1_new.mp4
rm part2.mp4
rm part2_new.mp4
rm part1_2.mp4
rm part3.mp4
rm part3_new.mp4
rm file_list.txt
