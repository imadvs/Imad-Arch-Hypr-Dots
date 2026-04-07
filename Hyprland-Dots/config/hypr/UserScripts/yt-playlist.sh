#!/usr/bin/env bash

# 1. طلب رابط القائمة من المستخدم
read -p "Enter YouTube Playlist URL: " URL

# 2. طلب اسم المجلد (مثلاً: Relaxing أو Workout)
read -p "Enter folder name (inside ~/Music/): " FOLDER

# 3. تحديد المسار الكامل
SAVE_PATH="$HOME/Music/$FOLDER"
mkdir -p "$SAVE_PATH"

echo "🚀 Starting download to $SAVE_PATH..."

# 4. تشغيل yt-dlp مع إعدادات الجودة وفصل القائمة
yt-dlp -x --audio-format mp3 \
  --yes-playlist \
  --add-metadata \
  --embed-thumbnail \
  -o "$SAVE_PATH/%(title)s.%(ext)s" \
  "$URL"

# 5. تحديث قاعدة بيانات MPD لكي تظهر في rmpc فوراً
echo "🔄 Updating MPD database..."
mpc update "$FOLDER"

echo "✅ Done! You can find it in rmpc under Directories > $FOLDER"

# إنشاء ملف Playlist بصيغة m3u داخل مجلد playlists الخاص بـ MPD
# ملاحظة: تأكد من مسار مجلد البلايليست عندك، غالباً يكون ~/Music/playlists
PLAYLIST_DIR="$HOME/Music/playlists"
mkdir -p "$PLAYLIST_DIR"

# إضافة كل ملفات المجلد الجديد للقائمة
ls "$SAVE_PATH" | grep ".mp3" >"$PLAYLIST_DIR/$FOLDER.m3u"

# تحديث MPD مرة أخرى ليرى القائمة الجديدة
mpc update
