#!/usr/bin/env python3
import time
import sys
import os
from datetime import datetime

class PomodoroTimer:
    def __init__(self):
        self.pomodoro_time = 50 * 60  # 50 minutes
        self.short_break = 10 * 60      # 10 minutes
        self.long_break = 30 * 60      # 30 minutes
        self.pomodoro_count = 0
        self.mode = "pomodoro"
        
    def clear_screen(self):
        os.system('clear' if os.name != 'nt' else 'cls')
    
    def format_time(self, seconds):
        mins = seconds // 60
        secs = seconds % 60
        return f"{mins:02d}:{secs:02d}"
    
    def print_banner(self, mode, time_left):
        self.clear_screen()
        
        # Banner
        print("=" * 50)
        print(" " * 15 + "POMODORO TIMER")
        print("=" * 50)
        print()
        
        # Mode indicator
        if mode == "pomodoro":
            print("🍅 POMODORO - Time to focus!")
        elif mode == "short_break":
            print("☕ SHORT BREAK - Take a breather")
        else:
            print("🌴 LONG BREAK - Relax and recharge")
        
        print()
        print(f"Session: #{self.pomodoro_count + 1}")
        print()
        
        # Timer display
        time_str = self.format_time(time_left)
        print(" " * 18 + "┌─────────┐")
        print(f" " * 18 + f"│ {time_str} │")
        print(" " * 18 + "└─────────┘")
        print()
        
        # Progress bar
        total = self.get_total_time(mode)
        progress = 1 - (time_left / total)
        bar_length = 40
        filled = int(bar_length * progress)
        bar = "█" * filled + "░" * (bar_length - filled)
        print(f"     [{bar}] {int(progress * 100)}%")
        print()
        
        # Controls
        print("─" * 50)
        print("Controls: [SPACE] Pause/Resume | [R] Reset | [S] Skip | [Q] Quit")
        print("─" * 50)
    
    def get_total_time(self, mode):
        if mode == "pomodoro":
            return self.pomodoro_time
        elif mode == "short_break":
            return self.short_break
        else:
            return self.long_break
    
    def play_notification(self):
        # Terminal bell
        print("\a" * 3)
        # System notification sound (works on most Linux systems)
        try:
            os.system('paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || '
                     'paplay /usr/share/sounds/freedesktop/stereo/bell.oga 2>/dev/null || '
                     'aplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || '
                     'mpg123 -q /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &')
        except:
            pass
    
    def send_notification(self, title, message):
        # Send desktop notification
        try:
            os.system(f'notify-send "{title}" "{message}" -u critical -t 5000 2>/dev/null &')
        except:
            pass
    
    def run_timer(self, mode):
        total_time = self.get_total_time(mode)
        time_left = total_time
        paused = False
        one_min_warning_sent = False
        
        # Set up non-blocking input
        if os.name != 'nt':
            import termios
            import tty
            old_settings = termios.tcgetattr(sys.stdin)
            tty.setcbreak(sys.stdin.fileno())
        
        try:
            while time_left > 0:
                self.print_banner(mode, time_left)
                
                if paused:
                    print("\n⏸  PAUSED - Press SPACE to continue")
                
                # Send 1-minute warning
                if time_left == 60 and not one_min_warning_sent and not paused:
                    one_min_warning_sent = True
                    if mode == "pomodoro":
                        self.send_notification("⏰ Pomodoro Timer", "1 minute remaining! Finish up your task.")
                    else:
                        self.send_notification("⏰ Break Timer", "1 minute remaining! Break almost over.")
                    # Warning sound
                    os.system('paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &')
                
                # Check for input (non-blocking)
                if os.name != 'nt':
                    import select
                    if select.select([sys.stdin], [], [], 0.1)[0]:
                        key = sys.stdin.read(1).lower()
                        if key == ' ':
                            paused = not paused
                        elif key == 'r':
                            return 'reset'
                        elif key == 's':
                            return 'skip'
                        elif key == 'q':
                            return 'quit'
                else:
                    import msvcrt
                    if msvcrt.kbhit():
                        key = msvcrt.getch().decode('utf-8').lower()
                        if key == ' ':
                            paused = not paused
                        elif key == 'r':
                            return 'reset'
                        elif key == 's':
                            return 'skip'
                        elif key == 'q':
                            return 'quit'
                
                if not paused:
                    time.sleep(1)
                    time_left -= 1
                else:
                    time.sleep(0.1)
            
            # Timer completed - play notification sound and send notification
            self.play_notification()
            if mode == "pomodoro":
                self.send_notification("✅ Pomodoro Complete!", "Great work! Time for a break.")
            elif mode == "short_break":
                self.send_notification("✅ Break Complete!", "Ready to focus again?")
            else:
                self.send_notification("✅ Long Break Complete!", "Recharged! Ready for another round?")
            
            return 'complete'
            
        finally:
            if os.name != 'nt':
                termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)
    
    def show_completion(self, mode):
        self.clear_screen()
        print("\n" * 5)
        print("=" * 50)
        if mode == "pomodoro":
            print(" " * 10 + "✅ POMODORO COMPLETE!")
            print()
            print(" " * 8 + "Great work! Time for a break.")
        else:
            print(" " * 10 + "✅ BREAK COMPLETE!")
            print()
            print(" " * 8 + "Ready to focus again?")
        print("=" * 50)
        print("\n" * 2)
        input("Press ENTER to continue...")
    
    def run(self):
        self.clear_screen()
        print("\n" * 5)
        print("=" * 50)
        print(" " * 12 + "🍅 POMODORO TIMER 🍅")
        print("=" * 50)
        print()
        print("  Press ENTER to start your first Pomodoro session!")
        print()
        print("  Default settings:")
        print("  • Pomodoro: 50 minutes")
        print("  • Short break: 10 minutes")
        print("  • Long break: 30 minutes (every 4 pomodoros)")
        print()
        print("=" * 50)
        input()
        
        while True:
            # Pomodoro session
            result = self.run_timer("pomodoro")
            
            if result == 'quit':
                break
            elif result == 'reset':
                self.pomodoro_count = 0
                continue
            elif result == 'complete':
                self.show_completion("pomodoro")
                self.pomodoro_count += 1
            
            # Determine break type
            if self.pomodoro_count % 4 == 0 and self.pomodoro_count > 0:
                break_mode = "long_break"
            else:
                break_mode = "short_break"
            
            # Break session
            result = self.run_timer(break_mode)
            
            if result == 'quit':
                break
            elif result == 'reset':
                self.pomodoro_count = 0
                continue
            elif result == 'complete':
                self.show_completion(break_mode)
        
        self.clear_screen()
        print("\n" * 5)
        print("Thanks for using Pomodoro Timer! Stay productive! 🍅")
        print("\n" * 5)

if __name__ == "__main__":
    timer = PomodoroTimer()
    try:
        timer.run()
    except KeyboardInterrupt:
        timer.clear_screen()
        print("\n\nPomodoro timer stopped. See you next time! 🍅\n")
        sys.exit(0)
