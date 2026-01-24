#!/usr/bin/env python3
import time
import sys
import os
import json
from datetime import datetime

class PomodoroTimer:
    def __init__(self):
        self.pomodoro_time = 50 * 60  # 50 minutes
        self.short_break = 10 * 60      # 10 minutes
        self.long_break = 30 * 60      # 30 minutes
        self.pomodoro_count = 0
        self.mode = "pomodoro"
        
        # State file location
        self.state_dir = os.path.expanduser("~/.local/share/pomo")
        self.state_file = os.path.join(self.state_dir, "state.json")
        
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
        
        # Create state directory if it doesn't exist
        os.makedirs(self.state_dir, exist_ok=True)
        
        # Load previous state
        self.load_state()
        
    def save_state(self, time_left=None, current_mode=None):
        """Save current state to file including timer position"""
        state = {
            'pomodoro_count': self.pomodoro_count,
            'mode': self.mode,
            'timestamp': datetime.now().isoformat(),
            'time_left': time_left,
            'current_mode': current_mode,
            'paused': True if time_left is not None else False
        }
        try:
            with open(self.state_file, 'w') as f:
                json.dump(state, f)
        except:
            pass
    
    def load_state(self):
        """Load previous state from file"""
        self.saved_time_left = None
        self.saved_current_mode = None
        self.was_paused = False
        
        try:
            if os.path.exists(self.state_file):
                with open(self.state_file, 'r') as f:
                    state = json.load(f)
                    self.pomodoro_count = state.get('pomodoro_count', 0)
                    self.mode = state.get('mode', 'pomodoro')
                    self.saved_time_left = state.get('time_left')
                    self.saved_current_mode = state.get('current_mode')
                    self.was_paused = state.get('paused', False)
        except:
            pass
    
    def reset_state(self):
        """Clear saved state"""
        self.pomodoro_count = 0
        self.mode = "pomodoro"
        try:
            if os.path.exists(self.state_file):
                os.remove(self.state_file)
        except:
            pass
        
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
        # Terminal bell - ring 3 times with delay
        for i in range(3):
            print("\a", flush=True)
            time.sleep(0.5)
        
        # System notification sound (works on most Linux systems)
        try:
            # Play sound 3 times
            for _ in range(3):
                os.system('paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &')
                time.sleep(0.5)
        except:
            pass
    
    def send_notification(self, title, message):
        # Send desktop notification using standard notify-send for SwayNC
        # JaKooLit config uses SwayNC which handles notify-send properly
        try:
            os.system(f'notify-send -a "Pomodoro" -u critical -t 5000 "{title}" "{message}" 2>/dev/null &')
            # Force close after 5 seconds if SwayNC ignores timeout
            os.system('(sleep 5 && swaync-client -C 2>/dev/null) &')
        except:
            pass
    
    def run_timer(self, mode, resume_time=None):
        total_time = self.get_total_time(mode)
        time_left = resume_time if resume_time is not None else total_time
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
                            return 'reset', time_left
                        elif key == 's':
                            return 'skip', time_left
                        elif key == 'q':
                            return 'quit', time_left
                else:
                    import msvcrt
                    if msvcrt.kbhit():
                        key = msvcrt.getch().decode('utf-8').lower()
                        if key == ' ':
                            paused = not paused
                        elif key == 'r':
                            return 'reset', time_left
                        elif key == 's':
                            return 'skip', time_left
                        elif key == 'q':
                            return 'quit', time_left
                
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
            
            return 'complete', 0
            
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
    
    def show_welcome(self):
        """Show welcome screen with current progress"""
        self.clear_screen()
        print("\n" * 5)
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print(f"{self.RED}{self.BOLD}{' ' * 12}🍅 POMODORO TIMER 🍅{self.RESET}")
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print()
        
        # Show progress if sessions are in progress
        if self.was_paused and self.saved_time_left is not None:
            mins = self.saved_time_left // 60
            secs = self.saved_time_left % 60
            mode_name = "WORK" if self.saved_current_mode == "pomodoro" else "BREAK"
            
            print(f"{self.YELLOW}{self.BOLD}  ⏸  Paused Timer Detected!{self.RESET}")
            print()
            print(f"{self.GREEN}  Sessions completed: {self.pomodoro_count}/4{self.RESET}")
            print(f"{self.CYAN}  {mode_name} timer paused at: {mins:02d}:{secs:02d}{self.RESET}")
            print()
            print(f"{self.CYAN}  Press ENTER to resume from where you left off{self.RESET}")
            print(f"{self.CYAN}  Press 'R' + ENTER to start fresh{self.RESET}")
            print()
        elif self.pomodoro_count > 0:
            print(f"{self.YELLOW}{self.BOLD}  Welcome back!{self.RESET}")
            print()
            print(f"{self.GREEN}  Sessions completed: {self.pomodoro_count}/4{self.RESET}")
            print()
            print(f"{self.CYAN}  Press ENTER to continue from Session {self.pomodoro_count + 1}{self.RESET}")
            print(f"{self.CYAN}  Press 'R' + ENTER to start fresh{self.RESET}")
            print()
        else:
            print(f"{self.YELLOW}  Press ENTER to start your first Pomodoro session!{self.RESET}")
            print()
        
        print(f"{self.WHITE}  Settings:{self.RESET}")
        print(f"{self.GREEN}  • Pomodoro: 50 minutes{self.RESET}")
        print(f"{self.GREEN}  • Short break: 10 minutes{self.RESET}")
        print(f"{self.GREEN}  • Long break: 30 minutes (every 4 pomodoros){self.RESET}")
        print()
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        
        response = input().strip().lower()
        if response == 'r':
            self.reset_state()
            self.saved_time_left = None
            self.saved_current_mode = None
            self.was_paused = False
            print(f"{self.GREEN}Starting fresh!{self.RESET}")
            time.sleep(1)
    
    def run(self):
        self.show_welcome()
        
        # Check if we should resume a paused timer
        should_resume = self.was_paused and self.saved_time_left is not None and self.saved_current_mode is not None
        
        while True:
            # Check if we've completed all sessions
            if self.pomodoro_count >= 4:
                self.clear_screen()
                print("\n" * 5)
                print(f"{self.GREEN}{self.BOLD}{'=' * 50}{self.RESET}")
                print(f"{self.GREEN}{self.BOLD}{' ' * 8}🎉 ALL 4 SESSIONS COMPLETE! 🎉{self.RESET}")
                print(f"{self.GREEN}{self.BOLD}{'=' * 50}{self.RESET}")
                print()
                print(f"{self.YELLOW}  You finished all Pomodoro sessions!{self.RESET}")
                print()
                print(f"{self.CYAN}  Press ENTER to start a new cycle{self.RESET}")
                print(f"{self.CYAN}  Press 'Q' + ENTER to quit{self.RESET}")
                print()
                response = input().strip().lower()
                if response == 'q':
                    break
                else:
                    self.reset_state()
                    should_resume = False
                    continue
            
            # Resume from saved state if applicable
            if should_resume:
                result, time_left = self.run_timer(self.saved_current_mode, self.saved_time_left)
                should_resume = False  # Only resume once
                
                if result == 'quit':
                    self.save_state(time_left, self.saved_current_mode)
                    break
                elif result == 'reset':
                    self.reset_state()
                    continue
                elif result == 'skip':
                    # Determine what comes next based on saved mode
                    if self.saved_current_mode == "pomodoro":
                        # Skip work, go to break
                        self.pomodoro_count += 1
                        self.save_state()
                    # Continue to next phase
                    continue
                elif result == 'complete':
                    if self.saved_current_mode == "pomodoro":
                        self.show_completion("pomodoro")
                        self.pomodoro_count += 1
                        self.save_state()
                    else:
                        self.show_completion(self.saved_current_mode)
                        self.save_state()
                    # Continue to next session
                    continue
            
            # Pomodoro session
            result, time_left = self.run_timer("pomodoro")
            
            if result == 'quit':
                self.save_state(time_left, "pomodoro")
                break
            elif result == 'reset':
                self.reset_state()
                continue
            elif result == 'skip':
                # Skip work, but count it
                self.pomodoro_count += 1
                self.save_state()
                continue
            elif result == 'complete':
                self.show_completion("pomodoro")
                self.pomodoro_count += 1
                self.save_state()
            
            # Determine break type
            if self.pomodoro_count % 4 == 0 and self.pomodoro_count > 0:
                break_mode = "long_break"
            else:
                break_mode = "short_break"
            
            # Break session
            result, time_left = self.run_timer(break_mode)
            
            if result == 'quit':
                self.save_state(time_left, break_mode)
                break
            elif result == 'reset':
                self.reset_state()
                continue
            elif result == 'skip':
                # Skip break, continue to next session
                self.save_state()
                continue
            elif result == 'complete':
                self.show_completion(break_mode)
                self.save_state()
        
        self.clear_screen()
        print("\n" * 5)
        print(f"{self.GREEN}{self.BOLD}Thanks for using Pomodoro Timer! Stay productive! 🍅{self.RESET}")
        print("\n" * 5)

if __name__ == "__main__":
    # Check for test argument first
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        print("Testing notification and sound...")
        timer = PomodoroTimer()
        
        print("\n🔔 Testing 3 rings + sound...")
        timer.play_notification()
        
        print("\n📬 Testing notification (should appear for 5 seconds)...")
        timer.send_notification("🍅 Test Notification", "This should disappear in 5 seconds!")
        
        print("\n✅ Test complete! Check if you:")
        print("   1. Heard 3 distinct rings")
        print("   2. Saw a notification")
        print("   3. Notification disappeared after 5 seconds")
        
        sys.exit(0)
    
    # Normal program
    timer = PomodoroTimer()
    try:
        timer.run()
    except KeyboardInterrupt:
        timer.clear_screen()
        timer.save_state()
        print(f"\n\n{timer.YELLOW}Pomodoro timer stopped. Progress saved! See you next time! 🍅{timer.RESET}\n")
        sys.exit(0)
