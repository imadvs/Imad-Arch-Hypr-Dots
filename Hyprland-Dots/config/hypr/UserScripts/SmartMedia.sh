#!/bin/bash

# 1. فحص حالة MPD (rmpc)
# نستخدم -f للبحث عن كلمة playing في السطر الثاني من مخرجات mpc
MPD_PLAYING=$(mpc status | grep -c "\[playing\]")
MPD_PAUSED=$(mpc status | grep -c "\[paused\]")

# 2. فحص حالة المتصفح (playerctl)
BROWSER_STATUS=$(playerctl status 2>/dev/null)

# --- منطق الأولوية ---

# أ. إذا كان rmpc يشتغل حالياً -> أوقفه
if [ "$MPD_PLAYING" -eq 1 ]; then
  mpc pause
  notify-send -t 1000 "rmpc" "Paused ⏸️"

# ب. إذا كان المتصفح يشتغل حالياً -> أوقفه
elif [ "$BROWSER_STATUS" = "Playing" ]; then
  playerctl pause
  notify-send -t 1000 "Browser" "Paused ⏸️"

# ج. إذا كان rmpc متوقفاً مؤقتاً (Paused) ولديه أغنية جاهزة -> شغله
elif [ "$MPD_PAUSED" -eq 1 ]; then
  mpc play
  notify-send -t 1000 "rmpc" "Playing ▶️"

# د. في أي حالة أخرى (إذا كان المتصفح لديه فيديو جاهز) -> شغله
elif [ "$BROWSER_STATUS" = "Paused" ]; then
  playerctl play
  notify-send -t 1000 "Browser" "Playing ▶️"

# هـ. إذا كان كل شيء فارغاً -> حاول تشغيل rmpc كخيار افتراضي
else
  mpc play || notify-send "Media" "No music in queue"
fi
