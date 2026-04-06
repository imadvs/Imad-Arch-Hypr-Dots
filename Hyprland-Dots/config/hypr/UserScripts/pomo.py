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
        self.long_break_interval = 4   # Long break after every N sessions
        self.total_sessions = 4        # Total number of sessions
        self.pomodoro_count = 0
        self.mode = "pomodoro"
        
        # State file location
        self.state_dir = os.path.expanduser("~/.local/share/pomo")
        self.state_file = os.path.join(self.state_dir, "state.json")
        
        # Color codes - adjusted for better visibility on dark/green backgrounds
        self.RESET = '\033[0m'
        self.BOLD = '\033[1m'
        self.RED = '\033[91m'
        self.GREEN = '\033[92m'
        self.YELLOW = '\033[93m'
        self.BLUE = '\033[94m'
        self.MAGENTA = '\033[95m'
        self.CYAN = '\033[96m'
        self.WHITE = '\033[97m'
        self.ORANGE = '\033[38;5;208m'  # Bright orange for better visibility
        
        # Create state directory if it doesn't exist
        os.makedirs(self.state_dir, exist_ok=True)
        
        # Load previous state
        self.load_state()
        
    def save_state(self, time_left=None, current_mode=None):
        """Save current state to file including timer position and settings"""
        state = {
            'pomodoro_count': self.pomodoro_count,
            'mode': self.mode,
            'timestamp': datetime.now().isoformat(),
            'time_left': time_left,
            'current_mode': current_mode,
            'paused': True if time_left is not None else False,
            # Save settings
            'pomodoro_time': self.pomodoro_time,
            'short_break': self.short_break,
            'long_break': self.long_break,
            'long_break_interval': self.long_break_interval,
            'total_sessions': self.total_sessions
        }
        try:
            with open(self.state_file, 'w') as f:
                json.dump(state, f)
        except:
            pass
    
    def load_state(self):
        """Load previous state from file including settings"""
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
                    # Load settings if they exist
                    self.pomodoro_time = state.get('pomodoro_time', self.pomodoro_time)
                    self.short_break = state.get('short_break', self.short_break)
                    self.long_break = state.get('long_break', self.long_break)
                    self.long_break_interval = state.get('long_break_interval', self.long_break_interval)
                    self.total_sessions = state.get('total_sessions', self.total_sessions)
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
    
    def configure_times(self):
        """Configure work and break times"""
        self.clear_screen()
        print("\n" * 3)
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print(f"{self.CYAN}{self.BOLD}{' ' * 15}⚙️  CONFIGURATION{self.RESET}")
        print(f"{self.CYAN}{self.BOLD}{'=' * 50}{self.RESET}")
        print()
        
        # Configure total sessions
        print(f"{self.YELLOW}Total number of sessions:{self.RESET}")
        print(f"{self.WHITE}Current: {self.total_sessions} sessions{self.RESET}")
        print(f"{self.CYAN}Enter new value (1-10) or press ENTER to keep:{self.RESET} ", end='')
        try:
            response = input().strip()
            if response:
                value = int(response)
                if 1 <= value <= 10:
                    self.total_sessions = value
                    print(f"{self.GREEN}✓ Set to {value} sessions{self.RESET}")
                else:
                    print(f"{self.RED}Invalid! Keeping {self.total_sessions} sessions{self.RESET}")
        except:
            print(f"{self.RED}Invalid input! Keeping {self.total_sessions} sessions{self.RESET}")
        
        time.sleep(1)
        print()
        
        # Configure Pomodoro time
        print(f"{self.YELLOW}Pomodoro work time (minutes):{self.RESET}")
        print(f"{self.WHITE}Current: {self.pomodoro_time // 60} minutes{self.RESET}")
        print(f"{self.CYAN}Enter new value (1-240) or press ENTER to keep:{self.RESET} ", end='')
        try:
            response = input().strip()
            if response:
                value = int(response)
                if 1 <= value <= 240:
                    self.pomodoro_time = value * 60
                    print(f"{self.GREEN}✓ Set to {value} minutes{self.RESET}")
                else:
                    print(f"{self.RED}Invalid! Keeping {self.pomodoro_time // 60} minutes{self.RESET}")
        except:
            print(f"{self.RED}Invalid input! Keeping {self.pomodoro_time // 60} minutes{self.RESET}")
        
        time.sleep(1)
        print()
        
        # Configure short break time
        print(f"{self.YELLOW}Short break time (minutes):{self.RESET}")
        print(f"{self.WHITE}Current: {self.short_break // 60} minutes{self.RESET}")
        print(f"{self.CYAN}Enter new value (1-60) or press ENTER to keep:{self.RESET} ", end='')
        try:
            response = input().strip()
            if response:
                value = int(response)
                if 1 <= value <= 60:
                    self.short_break = value * 60
                    print(f"{self.GREEN}✓ Set to {value} minutes{self.RESET}")
                else:
                    print(f"{self.RED}Invalid! Keeping {self.short_break // 60} minutes{self.RESET}")
        except:
            print(f"{self.RED}Invalid input! Keeping {self.short_break // 60} minutes{self.RESET}")
        
        time.sleep(1)
        print()
        
        # Configure long break time
        print(f"{self.YELLOW}Long break time (minutes):{self.RESET}")
        print(f"{self.WHITE}Current: {self.long_break // 60} minutes{self.RESET}")
        print(f"{self.CYAN}Enter new value (1-120) or press ENTER to keep:{self.RESET} ", end='')
        try:
            response = input().strip()
            if response:
                value = int(response)
                if 1 <= value <= 120:
                    self.long_break = value * 60
                    print(f"{self.GREEN}✓ Set to {value} minutes{self.RESET}")
                else:
                    print(f"{self.RED}Invalid! Keeping {self.long_break // 60} minutes{self.RESET}")
        except:
            print(f"{self.RED}Invalid input! Keeping {self.long_break // 60} minutes{self.RESET}")
        
        time.sleep(1)
        print()
        
        # Configure long break interval
        print(f"{self.YELLOW}Long break after how many sessions?{self.RESET}")
        print(f"{self.WHITE}Current: Every {self.long_break_interval} sessions{self.RESET}")
        print(f"{self.CYAN}Enter new value (2-{self.total_sessions}) or press ENTER to keep:{self.RESET} ", end='')
        try:
            response = input().strip()
            if response:
                value = int(response)
                if 2 <= value <= self.total_sessions:
                    self.long_break_interval = value
                    print(f"{self.GREEN}✓ Long break every {value} sessions{self.RESET}")
                else:
                    print(f"{self.RED}Invalid! Keeping every {self.long_break_interval} sessions{self.RESET}")
        except:
            print(f"{self.RED}Invalid input! Keeping every {self.long_break_interval} sessions{self.RESET}")
        
        time.sleep(1)
        print()
        print(f"{self.GREEN}{self.BOLD}Configuration saved!{self.RESET}")
        # Save configuration immediately
        self.save_state()
        time.sleep(2)
        
    def clear_screen(self):
        os.system('clear' if os.name != 'nt' else 'cls')
    
    def format_time(self, seconds):
        mins = seconds // 60
        secs = seconds % 60
        return f"{mins:02d}:{secs:02d}"
    
    def print_banner(self, mode, time_left):
        self.clear_screen()
        
        # Banner with colors - make it brighter
        print(f"{self.WHITE}{self.BOLD}{'=' * 50}{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}{' ' * 15}POMODORO TIMER{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}{'=' * 50}{self.RESET}")
        print()
        
        # Mode indicator with different colors (bold white for visibility)
        if mode == "pomodoro":
            print(f"{self.RED}{self.BOLD}🍅 POMODORO - Time to focus!{self.RESET}")
        elif mode == "short_break":
            print(f"{self.CYAN}{self.BOLD}☕ SHORT BREAK - Take a breather{self.RESET}")
        else:
            print(f"{self.BLUE}{self.BOLD}🌴 LONG BREAK - Relax and recharge{self.RESET}")
        
        print()
        print(f"{self.WHITE}{self.BOLD}Session: #{self.pomodoro_count + 1}{self.RESET}")
        print()
        
        # Timer display with color - BRIGHT and BOLD
        time_str = self.format_time(time_left)
        # Use bright white for timer regardless of mode
        print(f"{self.WHITE}{self.BOLD}{' ' * 18}┌─────────┐{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}{' ' * 18}│ {time_str} │{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}{' ' * 18}└─────────┘{self.RESET}")
        print()
        
        # Progress bar with color
        total = self.get_total_time(mode)
        progress = 1 - (time_left / total)
        bar_length = 40
        filled = int(bar_length * progress)
        bar_color = self.RED if mode == "pomodoro" else self.CYAN
        bar = f"{bar_color}{'█' * filled}{self.RESET}{'░' * (bar_length - filled)}"
        print(f"     [{bar}] {self.WHITE}{self.BOLD}{int(progress * 100)}%{self.RESET}")
        print()
        
        # Controls - make them brighter
        print(f"{self.WHITE}{self.BOLD}{'─' * 50}{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}Controls: {self.YELLOW}[SPACE]{self.WHITE} Pause/Resume | {self.YELLOW}[R]{self.WHITE} Reset | {self.YELLOW}[S]{self.WHITE} Skip | {self.YELLOW}[Q]{self.WHITE} Quit{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}{'─' * 50}{self.RESET}")
    
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
        # Send desktop notification using normal urgency (not critical)
        # This respects the 5-second timeout in SwayNC
        try:
            os.system(f'notify-send -a "Pomodoro" -u normal -t 5000 "{title}" "{message}" 2>/dev/null &')
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
                    print(f"\n{self.YELLOW}{self.BOLD}⏸  PAUSED - Press SPACE to continue{self.RESET}")
                
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
        print(f"{self.WHITE}{self.BOLD}{'=' * 50}{self.RESET}")
        print(f"{self.RED}{self.BOLD}{' ' * 12}🍅 POMODORO TIMER 🍅{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}{'=' * 50}{self.RESET}")
        print()
        
        # Show progress if sessions are in progress
        if self.was_paused and self.saved_time_left is not None:
            mins = self.saved_time_left // 60
            secs = self.saved_time_left % 60
            mode_name = "WORK" if self.saved_current_mode == "pomodoro" else "BREAK"
            
            print(f"{self.YELLOW}{self.BOLD}  ⏸  Paused Timer Detected!{self.RESET}")
            print()
            print(f"{self.WHITE}{self.BOLD}  Sessions completed: {self.pomodoro_count}/{self.total_sessions}{self.RESET}")
            print(f"{self.WHITE}{self.BOLD}  {mode_name} timer paused at: {mins:02d}:{secs:02d}{self.RESET}")
            print()
            print(f"{self.CYAN}  Press ENTER to resume from where you left off{self.RESET}")
            print(f"{self.CYAN}  Press 'R' + ENTER to start fresh{self.RESET}")
            print()
        elif self.pomodoro_count > 0:
            print(f"{self.YELLOW}{self.BOLD}  Welcome back!{self.RESET}")
            print()
            print(f"{self.WHITE}{self.BOLD}  Sessions completed: {self.pomodoro_count}/{self.total_sessions}{self.RESET}")
            print()
            print(f"{self.CYAN}  Press ENTER to continue from Session {self.pomodoro_count + 1}{self.RESET}")
            print(f"{self.CYAN}  Press 'R' + ENTER to start fresh{self.RESET}")
            print(f"{self.CYAN}  Press 'C' + ENTER to configure times{self.RESET}")
            print()
        else:
            print(f"{self.YELLOW}  Press ENTER to start your first Pomodoro session!{self.RESET}")
            print(f"{self.CYAN}  Press 'C' + ENTER to configure times{self.RESET}")
            print()
        
        print(f"{self.WHITE}{self.BOLD}  Current Settings:{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}  • Total sessions: {self.total_sessions}{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}  • Pomodoro: {self.pomodoro_time // 60} minutes{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}  • Short break: {self.short_break // 60} minutes{self.RESET}")
        print(f"{self.WHITE}{self.BOLD}  • Long break: {self.long_break // 60} minutes (every {self.long_break_interval} sessions){self.RESET}")
        print()
        print(f"{self.WHITE}{self.BOLD}{'=' * 50}{self.RESET}")
        
        response = input().strip().lower()
        if response == 'r':
            self.reset_state()
            self.saved_time_left = None
            self.saved_current_mode = None
            self.was_paused = False
            print(f"{self.GREEN}Starting fresh!{self.RESET}")
            time.sleep(1)
        elif response == 'c':
            self.configure_times()
            self.show_welcome()  # Show welcome again after config
    
    def run(self):
        self.show_welcome()
        
        # Check if we should resume a paused timer
        should_resume = self.was_paused and self.saved_time_left is not None and self.saved_current_mode is not None
        
        while True:
            # Check if we've completed all sessions
            if self.pomodoro_count >= self.total_sessions:
                self.clear_screen()
                print("\n" * 5)
                print(f"{self.GREEN}{self.BOLD}{'=' * 50}{self.RESET}")
                print(f"{self.GREEN}{self.BOLD}{' ' * 8}🎉 ALL {self.total_sessions} SESSIONS COMPLETE! 🎉{self.RESET}")
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
                        # Skip work, count session and go to break
                        self.pomodoro_count += 1
                        self.save_state()
                    # If was in break, just continue to next work session
                    continue
                elif result == 'complete':
                    if self.saved_current_mode == "pomodoro":
                        self.show_completion("pomodoro")
                        self.pomodoro_count += 1
                        self.save_state()
                        # DON'T continue here - fall through to break
                    else:
                        self.show_completion(self.saved_current_mode)
                        self.save_state()
                        # Continue to next work session
                        continue
            
            # Pomodoro work session
            result, time_left = self.run_timer("pomodoro")
            
            if result == 'quit':
                self.save_state(time_left, "pomodoro")
                break
            elif result == 'reset':
                self.reset_state()
                continue
            elif result == 'skip':
                # Skip work, but count it and go to break
                self.pomodoro_count += 1
                self.save_state()
                # DON'T continue - fall through to break
            elif result == 'complete':
                self.show_completion("pomodoro")
                self.pomodoro_count += 1
                self.save_state()
                # DON'T continue - fall through to break
            
            # Determine break type
            if self.pomodoro_count % self.long_break_interval == 0 and self.pomodoro_count > 0:
                break_mode = "long_break"
            else:
                break_mode = "short_break"
            
            # Show break message
            print()
            if break_mode == "long_break":
                print(f"{self.BLUE}{self.BOLD}Starting Long Break (30m)...{self.RESET}")
            else:
                print(f"{self.CYAN}{self.BOLD}Starting Short Break (10m)...{self.RESET}")
            time.sleep(2)
            
            # Break session
            result, time_left = self.run_timer(break_mode)
            
            if result == 'quit':
                self.save_state(time_left, break_mode)
                break
            elif result == 'reset':
                self.reset_state()
                continue
            elif result == 'skip':
                # Skip break, continue to next work session
                self.save_state()
                continue
            elif result == 'complete':
                self.show_completion(break_mode)
                self.save_state()
                # Continue to next work session
                continue
        
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
