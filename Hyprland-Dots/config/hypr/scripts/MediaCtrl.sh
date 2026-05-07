#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Optimized Stateful Media Controller (MPD & Playerctl)
echo "$(date): $1" >> /tmp/media_ctrl_log

music_icon="$HOME/.config/swaync/icons/music.png"
STATE_FILE="/tmp/last_media_player"
# Exclude MPD from playerctl to avoid feedback loops with mpd-mpris
PCTL="playerctl --ignore-player=mpd"

# Internal player state getters
is_mpd_playing() { mpc status | grep -q '\[playing\]'; }
is_browser_playing() { [ "$($PCTL status 2>/dev/null)" = "Playing" ]; }

# State persistence
save_state() { echo "$1" > "$STATE_FILE"; }
get_state() { [ -f "$STATE_FILE" ] && cat "$STATE_FILE" || echo "mpd"; }

# Play the next track
play_next() {
  if [ "$(get_state)" = "mpd" ]; then
    mpc next
  else
    $PCTL next
  fi
  show_music_notification
}

# Play the previous track
play_previous() {
  if [ "$(get_state)" = "mpd" ]; then
    mpc prev
  else
    $PCTL previous
  fi
  show_music_notification
}

# Toggle play/pause - Explicitly separated to avoid conflicts
toggle_play_pause() {
  if is_mpd_playing; then
    mpc pause
    save_state "mpd"
  elif is_browser_playing; then
    $PCTL pause
    save_state "browser"
  else
    # Nothing active, resume most recent source
    local target=$(get_state)
    if [ "$target" = "mpd" ]; then
      mpc play
    else
      $PCTL play
    fi
  fi
  # Tiny delay to let MPD/Player update status before notification
  (sleep 0.5 && show_music_notification) &
}

# Stop all playback
stop_playback() {
  mpc stop
  $PCTL stop 2>/dev/null
  notify-send -e -h string:x-canonical-private-synchronous:music_notif -h boolean:SWAYNC_BYPASS_DND:true -u low "󰓛  Playback:" " Stopped"
}

# Get playback progress
get_progress() {
  local target=$(get_state)
  if [ "$target" = "mpd" ]; then
    mpc status | grep -oP '\(\d+%\)' | tr -d '()%'
  else
    local pos=$($PCTL metadata --format "{{position}}" 2>/dev/null)
    local len=$($PCTL metadata --format "{{mpris:length}}" 2>/dev/null)
    if [ -n "$pos" ] && [ -n "$len" ] && [ "$len" -gt 0 ]; then
      echo $(( pos * 100 / len ))
    else
      echo 0
    fi
  fi
}

# Notification logic
show_music_notification() {
  local target=$(get_state)
  local progress=$(get_progress)
  local icon="󰎆"
  local pause_icon="󰏤"
  local sync_hint="-h string:x-canonical-private-synchronous:music_notif"
  local bypass_hint="-h boolean:SWAYNC_BYPASS_DND:true"
  local value_hint="-h int:value:$progress"

  if [ "$target" = "mpd" ]; then
    status=$(mpc status | grep -o '\[playing\]' || echo "Paused")
    song_title=$(mpc -f %title% current)
    song_artist=$(mpc -f %artist% current)
    if [[ "$status" == "[playing]" ]]; then
      notify-send -e $sync_hint $value_hint $bypass_hint -u low "$icon  Playing: $song_title" "$song_artist"
    else
      notify-send -e $sync_hint $value_hint $bypass_hint -u low "$pause_icon  Paused: $song_title" "$song_artist"
    fi
  else
    status=$($PCTL status 2>/dev/null)
    song_title=$($PCTL metadata title 2>/dev/null)
    song_artist=$($PCTL metadata artist 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
      notify-send -e $sync_hint $value_hint $bypass_hint -u low "$icon  Playing: $song_title" "$song_artist"
    elif [[ "$status" == "Paused" ]]; then
      notify-send -e $sync_hint $value_hint $bypass_hint -u low "$pause_icon  Paused: $song_title" "$song_artist"
    fi
  fi
}

# Dispatcher
case "$1" in
"--nxt") play_next ;;
"--prv") play_previous ;;
"--pause") toggle_play_pause ;;
"--stop") stop_playback ;;
*) echo "Usage: $0 [--nxt|--prv|--pause|--stop]"; exit 1 ;;
esac
