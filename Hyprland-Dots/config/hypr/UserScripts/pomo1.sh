#!/bin/bash

# Hybrid Pomodoro Timer
# Works as both interactive terminal app AND background daemon for Waybar

# Configuration
WORK_TIME=50   # minutes
SHORT_BREAK=10 # minutes
LONG_BREAK=30  # minutes
TOTAL_SESSIONS=4

# File locations
POMO_DIR="$HOME/.local/share/pomo"
SESSION_FILE="$POMO_DIR/session"
STATE_FILE="$POMO_DIR/state"
TIME_FILE="$POMO_DIR/time"
START_FILE="$POMO_DIR/start"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Initialize
mkdir -p "$POMO_DIR"

#==============================================================================
# HELPER FUNCTIONS
#==============================================================================

play_sound() {
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
}

play_warning() {
  paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
}

send_notification() {
  notify-send -a "Pomodoro" -u critical -t 5000 "$1" "$2"
}

get_session() {
  [[ -f "$SESSION_FILE" ]] && cat "$SESSION_FILE" || echo "0"
}

set_session() {
  echo "$1" >"$SESSION_FILE"
}

get_state() {
  [[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "stopped"
}

set_state() {
  echo "$1" >"$STATE_FILE"
}

get_start_time() {
  [[ -f "$START_FILE" ]] && cat "$START_FILE" || echo "0"
}

set_start_time() {
  echo "$1" >"$START_FILE"
}

get_duration() {
  [[ -f "$TIME_FILE" ]] && cat "$TIME_FILE" || echo "0"
}

set_duration() {
  echo "$1" >"$TIME_FILE"
}

clear_all() {
  rm -f "$SESSION_FILE" "$STATE_FILE" "$TIME_FILE" "$START_FILE"
}

is_running() {
  local state=$(get_state)
  [[ "$state" == "work" || "$state" == "break" ]]
}

#==============================================================================
# CLOCK FUNCTION (For Waybar/status bars)
#==============================================================================

clock() {
  local state=$(get_state)

  if [[ "$state" == "stopped" ]]; then
    echo "  --:--"
    return
  fi

  local start=$(get_start_time)
  local duration=$(get_duration)
  local now=$(date +%s)
  local elapsed=$((now - start))
  local remaining=$((duration - elapsed))

  if [[ $remaining -lt 0 ]]; then
    echo "  00:00"
    return
  fi

  local mins=$((remaining / 60))
  local secs=$((remaining % 60))

  if [[ "$state" == "work" ]]; then
    printf "🍅%02d:%02d" $mins $secs
  else
    printf "☕%02d:%02d" $mins $secs
  fi
}

#==============================================================================
# BACKGROUND DAEMON MODE
#==============================================================================

start_daemon() {
  if is_running; then
    echo "Pomodoro already running!"
    return
  fi

  # Start background daemon
  nohup "$0" _daemon_loop >/dev/null 2>&1 &
  echo "Pomodoro started in background (PID: $!)"
  echo "Use 'pomo clock' in Waybar or 'pomo status' to check progress"
}

daemon_loop() {
  for session in {1..4}; do
    set_session $session
    set_state "work"

    # Work period
    local work_seconds=$((WORK_TIME * 60))
    set_duration $work_seconds
    set_start_time $(date +%s)

    sleep $work_seconds

    play_sound
    send_notification "✅ Work Complete!" "Session $session done! Time for a break."

    # Check if last session
    if [[ $session -eq $TOTAL_SESSIONS ]]; then
      send_notification "🎉 All Sessions Complete!" "You finished all 4 Pomodoro sessions!"
      play_sound
      sleep 1
      play_sound
      clear_all
      return
    fi

    # Determine break
    if [[ $session -eq 3 ]]; then
      break_time=$LONG_BREAK
    else
      break_time=$SHORT_BREAK
    fi

    set_state "break"
    local break_seconds=$((break_time * 60))
    set_duration $break_seconds
    set_start_time $(date +%s)

    # 1-min warning for work (in background)
    (sleep $((work_seconds - 60)) && play_warning && send_notification "⏰ Pomodoro" "1 minute remaining!") &

    sleep $break_seconds

    play_sound
    send_notification "✅ Break Over!" "Ready for session $((session + 1))?"
  done

  clear_all
}

#==============================================================================
# INTERACTIVE TERMINAL MODE
#==============================================================================

interactive_countdown() {
  local minutes=$1
  local mode=$2
  local total_seconds=$((minutes * 60))
  local paused=false

  # Save terminal settings
  stty_orig=$(stty -g)
  stty -echo -icanon time 0 min 0

  for ((i = total_seconds; i > 0; i--)); do
    local mins=$((i / 60))
    local secs=$((i % 60))

    if [[ "$mode" == "work" ]]; then
      color=$RED
      prefix="🍅 WORK"
    else
      color=$GREEN
      prefix="☕ BREAK"
    fi

    if $paused; then
      printf "\r${YELLOW}${BOLD}⏸  PAUSED: %02d:%02d  ${RESET}[SPACE=Resume | S=Skip | Q=Quit]  " $mins $secs
    else
      printf "\r${color}${BOLD}${prefix}: %02d:%02d${RESET}  [SPACE=Pause | S=Skip | Q=Quit]  " $mins $secs
    fi

    # Check for keypress
    key=""
    read -r -n 1 key

    case "$key" in
    " ")
      if $paused; then
        paused=false
      else
        paused=true
      fi
      ;;
    s | S)
      stty "$stty_orig"
      echo ""
      echo -e "${YELLOW}Skipped!${RESET}"
      return 1
      ;;
    q | Q)
      stty "$stty_orig"
      echo ""
      echo -e "${RED}Quit!${RESET}"
      exit 0
      ;;
    esac

    # 1 minute warning
    if [[ $i -eq 60 ]] && ! $paused; then
      play_warning
      if [[ "$mode" == "work" ]]; then
        send_notification "⏰ Pomodoro" "1 minute remaining! Wrap up."
      else
        send_notification "⏰ Break" "1 minute remaining! Break almost over."
      fi
    fi

    if ! $paused; then
      sleep 1
    else
      sleep 0.1
      ((i++))
    fi
  done

  stty "$stty_orig"
  echo ""
}

start_interactive() {
  clear
  echo -e "${CYAN}${BOLD}╔════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}${BOLD}║     🍅 POMODORO TIMER 🍅           ║${RESET}"
  echo -e "${CYAN}${BOLD}╚════════════════════════════════════╝${RESET}"
  echo ""
  echo -e "${YELLOW}Starting 4 Pomodoro sessions (INTERACTIVE MODE)${RESET}"
  echo -e "${CYAN}Use SPACE to pause, S to skip, Q to quit${RESET}"
  echo ""
  sleep 2

  for session in {1..4}; do
    clear
    echo -e "${CYAN}${BOLD}╔════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}${BOLD}║     🍅 POMODORO TIMER 🍅           ║${RESET}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${YELLOW}${BOLD}Session $session of $TOTAL_SESSIONS${RESET}"
    echo ""

    interactive_countdown $WORK_TIME "work"
    skip_status=$?

    if [[ $skip_status -eq 1 ]]; then
      echo -e "${YELLOW}Work session skipped.${RESET}"
    fi

    play_sound
    send_notification "✅ Work Complete!" "Session $session done! Time for a break."

    if [[ $session -eq $TOTAL_SESSIONS ]]; then
      echo ""
      echo -e "${GREEN}${BOLD}╔════════════════════════════════════╗${RESET}"
      echo -e "${GREEN}${BOLD}║   🎉 ALL SESSIONS COMPLETE! 🎉    ║${RESET}"
      echo -e "${GREEN}${BOLD}╚════════════════════════════════════╝${RESET}"
      echo ""
      send_notification "🎉 Pomodoro Complete!" "You finished all 4 sessions!"
      play_sound
      sleep 1
      play_sound
      return
    fi

    if [[ $session -eq 3 ]]; then
      break_time=$LONG_BREAK
      break_msg="Long Break"
    else
      break_time=$SHORT_BREAK
      break_msg="Short Break"
    fi

    echo ""
    echo -e "${GREEN}${BOLD}Starting $break_msg (${break_time}m)...${RESET}"
    sleep 2

    interactive_countdown $break_time "break"
    skip_status=$?

    if [[ $skip_status -eq 1 ]]; then
      echo -e "${YELLOW}Break skipped.${RESET}"
    fi

    play_sound
    send_notification "✅ Break Over!" "Ready for session $((session + 1))?"

    echo ""
    echo -e "${YELLOW}Next session starts in 3 seconds...${RESET}"
    sleep 3
  done
}

#==============================================================================
# CONTROL FUNCTIONS
#==============================================================================

stop_timer() {
  if ! is_running; then
    echo "No Pomodoro running."
    return
  fi

  clear_all
  echo -e "${GREEN}Pomodoro stopped.${RESET}"
}

status() {
  local state=$(get_state)
  local session=$(get_session)

  echo -e "${CYAN}${BOLD}Pomodoro Status:${RESET}"

  if [[ "$state" == "stopped" ]]; then
    echo -e "State: ${YELLOW}Stopped${RESET}"
    echo -e "Sessions completed: ${YELLOW}0${RESET}/${TOTAL_SESSIONS}"
  else
    echo -e "State: ${YELLOW}$state${RESET}"
    echo -e "Session: ${YELLOW}$session${RESET}/${TOTAL_SESSIONS}"
    echo -e "Time remaining: ${YELLOW}$(clock)${RESET}"
  fi
}

reset() {
  clear_all
  echo -e "${GREEN}Pomodoro reset!${RESET}"
}

#==============================================================================
# USAGE
#==============================================================================

usage() {
  cat <<EOF
${CYAN}${BOLD}Hybrid Pomodoro Timer${RESET}

${YELLOW}Interactive Mode (Terminal):${RESET}
  pomo            - Start interactive timer with live controls
  
${YELLOW}Background Mode (For Waybar):${RESET}
  pomo daemon     - Start background daemon
  pomo clock      - Show current time (for status bars)
  pomo stop       - Stop background daemon
  
${YELLOW}General:${RESET}
  pomo status     - Show current status
  pomo reset      - Reset timer
  pomo help       - Show this help

${YELLOW}Settings:${RESET}
  Work time:      ${WORK_TIME} minutes
  Short break:    ${SHORT_BREAK} minutes
  Long break:     ${LONG_BREAK} minutes
  Total sessions: ${TOTAL_SESSIONS}

${YELLOW}Waybar Integration:${RESET}
  Add to ~/.config/waybar/config.jsonc:
  
  "custom/pomodoro": {
      "exec": "pomo clock",
      "interval": 1,
      "format": "{}",
      "on-click": "pomo stop"
  }

${YELLOW}Interactive Controls:${RESET}
  SPACE  - Pause/Resume
  S      - Skip current session/break
  Q      - Quit
EOF
}

#==============================================================================
# MAIN
#==============================================================================

case "$1" in
daemon)
  start_daemon
  ;;
_daemon_loop)
  daemon_loop
  ;;
clock)
  clock
  ;;
stop)
  stop_timer
  ;;
status)
  status
  ;;
reset)
  reset
  ;;
help | --help | -h)
  usage
  ;;
"")
  # Default: interactive mode
  start_interactive
  ;;
*)
  echo -e "${RED}Unknown command: $1${RESET}"
  usage
  exit 1
  ;;
esac

