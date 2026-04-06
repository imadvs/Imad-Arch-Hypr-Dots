#!/bin/bash

# مسار الموسيقى الخاص بك
MUSIC_DIR="/home/imad/Music"
mkdir -p "$MUSIC_DIR"

# طلب الرابط
echo "Please paste the YouTube Music link below:"
read -r URL

# التأكد أن الرابط ليس فارغاً
if [ -z "$URL" ]; then
  echo "Error: No link provided!"
  sleep 2
  exit 1
fi

echo "Downloading: $URL"

# استخدام الكوتس حول \$URL ضروري جداً لمنع الـ Crash
# وإضافة --no-playlist إذا كنت تريد أغنية واحدة فقط
yt-dlp -x --audio-format mp3 --audio-quality 0 \
  --embed-thumbnail --add-metadata \
  --no-playlist \
  -o "$MUSIC_DIR/%(title)s.%(ext)s" \
  "$URL"

# فحص إذا كان التحميل نجح
if [ $? -eq 0 ]; then
  echo "-------------------------------"
  echo "Download finished successfully!"
  mpc update
  echo "Library updated in rmpc."
  sleep 2
else
  echo "-------------------------------"
  echo "Download FAILED!"
  echo "Make sure yt-dlp is up to date: 'pip install -U yt-dlp' or 'sudo pacman -Syu yt-dlp'"
  sleep 5
fi
