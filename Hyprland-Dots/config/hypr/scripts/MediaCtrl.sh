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
  notify-send -e -u low -i $music_icon " Playback:" " Stopped"
}

# Notification logic
show_music_notification() {
  local target=$(get_state)
  if [ "$target" = "mpd" ]; then
    status=$(mpc status | grep -o '\[playing\]' || echo "Paused")
    if [[ "$status" == "[playing]" ]]; then
      song_title=$(mpc -f %title% current)
      song_artist=$(mpc -f %artist% current)
      notify-send -e -u low -i $music_icon "MPD Playing:" "$song_title by $song_artist"
    else
      notify-send -e -u low -i $music_icon "MPD:" "Paused"
    fi
  else
    status=$($PCTL status 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
      song_title=$($PCTL metadata title)
      song_artist=$($PCTL metadata artist)
      notify-send -e -u low -i $music_icon "Browser Playing:" "$song_title by $song_artist"
    elif [[ "$status" == "Paused" ]]; then
      notify-send -e -u low -i $music_icon "Browser:" "Paused"
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
