#!/usr/bin/env bash

# 1. تحديث قاعدة البيانات لضمان رؤية الملفات الجديدة
mpc update --wait

# 2. مسح القائمة الحالية (التي تظهر في صورتك)
mpc clear

# 3. إضافة مجلد Relaxing فقط
# ملاحظة: تأكد أن الاسم مطابق تماماً لما يظهر في 'mpc ls'
mpc add Relaxing

# 4. تشغيل الموسيقى
mpc play

# 5. إرسال إشعار للنظام
notify-send "MPD Mode" "Switched to Relaxing Music"
