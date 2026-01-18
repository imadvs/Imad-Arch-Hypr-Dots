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
        
        # Color codes
        self.RESET = '\033[0m'
        self.BOLD = '\033[1m'
        self.RED = '\033[91m'
        self.GREEN = '\033[92m'
        self.YELLOW = '\033[93m'
        self.BLUE = '\033[94m'
        self.MAGENTA = '\033[95m'
        self.CYAN = '\033[96m'
        self.WHITE = '\033[97m'
        
    def clear_screen(self):
        os.system('clear' if os.name != 'nt' else 'cls')
    
    def format_time(self, seconds):
        mins = seconds // 60
        secs = seconds % 60
        return f"{mins:02d}:{secs:02d}"
    
    def print_banner(self, mode, time_left):
        self.clear_screen()
        
        # Banner with colors
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print(f"{self.CYAN}{self.BOLD}{' ' * 15}POMODORO TIMER{self.RESET}")
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print()
        
        # Mode indicator with different colors
        if mode == "pomodoro":
            print(f"{self.RED}{self.BOLD}🍅 POMODORO - Time to focus!{self.RESET}")
        elif mode == "short_break":
            print(f"{self.GREEN}{self.BOLD}☕ SHORT BREAK - Take a breather{self.RESET}")
        else:
            print(f"{self.BLUE}{self.BOLD}🌴 LONG BREAK - Relax and recharge{self.RESET}")
        
        print()
        print(f"{self.YELLOW}Session: #{self.pomodoro_count + 1}{self.RESET}")
        print()
        
        # Timer display with color
        time_str = self.format_time(time_left)
        timer_color = self.RED if mode == "pomodoro" else self.GREEN
        print(f"{timer_color}{' ' * 18}┌─────────┐{self.RESET}")
        print(f"{timer_color}{' ' * 18}│ {self.BOLD}{time_str}{self.RESET}{timer_color} │{self.RESET}")
        print(f"{timer_color}{' ' * 18}└─────────┘{self.RESET}")
        print()
        
        # Progress bar with color
        total = self.get_total_time(mode)
        progress = 1 - (time_left / total)
        bar_length = 40
        filled = int(bar_length * progress)
        bar_color = self.RED if mode == "pomodoro" else self.GREEN
        bar = f"{bar_color}{'█' * filled}{self.RESET}{'░' * (bar_length - filled)}"
        print(f"     [{bar}] {self.YELLOW}{int(progress * 100)}%{self.RESET}")
        print()
        
        # Controls
        print(f"{self.CYAN}{'─' * 50}{self.RESET}")
        print(f"{self.WHITE}Controls: {self.MAGENTA}[SPACE]{self.WHITE} Pause/Resume | {self.MAGENTA}[R]{self.WHITE} Reset | {self.MAGENTA}[S]{self.WHITE} Skip | {self.MAGENTA}[Q]{self.WHITE} Quit{self.RESET}")
        print(f"{self.CYAN}{'─' * 50}{self.RESET}")
    
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
                    print(f"\n{self.YELLOW}⏸  PAUSED - Press SPACE to continue{self.RESET}")
                
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
        print(f"{self.GREEN}{self.BOLD}{'=' * 50}{self.RESET}")
        if mode == "pomodoro":
            print(f"{self.GREEN}{self.BOLD}{' ' * 10}✅ POMODORO COMPLETE!{self.RESET}")
            print()
            print(f"{self.YELLOW}{' ' * 8}Great work! Time for a break.{self.RESET}")
        else:
            print(f"{self.GREEN}{self.BOLD}{' ' * 10}✅ BREAK COMPLETE!{self.RESET}")
            print()
            print(f"{self.YELLOW}{' ' * 8}Ready to focus again?{self.RESET}")
        print(f"{self.GREEN}{self.BOLD}{'=' * 50}{self.RESET}")
        print("\n" * 2)
        print(f"{self.CYAN}Press ENTER to continue...{self.RESET}", end='')
        input()
    
    def run(self):
        self.clear_screen()
        print("\n" * 5)
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print(f"{self.RED}{self.BOLD}{' ' * 12}🍅 POMODORO TIMER 🍅{self.RESET}")
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print()
        print(f"{self.YELLOW}  Press ENTER to start your first Pomodoro session!{self.RESET}")
        print()
        print(f"{self.WHITE}  Default settings:{self.RESET}")
        print(f"{self.GREEN}  • Pomodoro: 50 minutes{self.RESET}")
        print(f"{self.GREEN}  • Short break: 10 minutes{self.RESET}")
        print(f"{self.GREEN}  • Long break: 30 minutes (every 4 pomodoros){self.RESET}")
        print()
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
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
        print(f"{self.GREEN}{self.BOLD}Thanks for using Pomodoro Timer! Stay productive! 🍅{self.RESET}")
        print("\n" * 5)

if __name__ == "__main__":
    timer = PomodoroTimer()
    try:
        timer.run()
    except KeyboardInterrupt:
        timer.clear_screen()
        print(f"\n\n{timer.YELLOW}Pomodoro timer stopped. See you next time! 🍅{timer.RESET}\n")
        sys.exit(0)
