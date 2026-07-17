-- ------------------------
-- KEYBINDS
-- ------------------------
local HOME = os.getenv("HOME")
local scripts = HOME .. "/.config/hypr/scripts"
local uscripts = HOME .. "/.config/hypr/UserScripts"
local terminal = "kitty"
local term = "kitty"
local files = "kitty -e yazi"
local browser = "google-chrome-stable"
local mainMod = "SUPER"
local webapp = uscripts .. "/launch_chrome_webapp.sh"

hl.bind(
	mainMod .. " + SPACE",
	hl.dsp.exec_cmd("pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window")
)
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("uwsm-app -- " .. browser .. " --new-window --password-store=basic"))
hl.bind(
	mainMod .. " + SHIFT + CTRL + B",
	hl.dsp.exec_cmd("uwsm-app -- " .. browser .. " --incognito --password-store=basic")
)
hl.bind(mainMod .. " + ALT + A", hl.dsp.exec_cmd(scripts .. "/OverviewToggle.sh"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd(scripts .. "/KeyHints.sh"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(scripts .. "/Refresh.sh"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(scripts .. "/RofiEmoji.sh"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(scripts .. "/RofiSearch.sh"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("rofi -show window"))
hl.bind(mainMod .. " + ALT + O", hl.dsp.exec_cmd(scripts .. "/ChangeBlur.sh"))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.exec_cmd(scripts .. "/GameMode.sh"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(scripts .. "/ChangeLayout.sh"))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd(scripts .. "/ClipManager.sh"))
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd(scripts .. "/RofiThemeSelector.sh"))
hl.bind(
	mainMod .. " + CTRL + SHIFT + R",
	hl.dsp.exec_cmd("pkill rofi || true && " .. scripts .. "/RofiThemeSelector-modified.sh")
)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen(1))
hl.bind(
	mainMod .. " + SHIFT + Return",
	hl.dsp.exec_cmd(scripts .. "/Dropterminal.sh '" .. terminal .. " --class dropterm'")
)
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(scripts .. "/KillActiveProcess.sh"))
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.close())
hl.bind(
	mainMod .. " + ALT + mouse_down",
	hl.dsp.exec_cmd(
		"hyprctl eval \"hl.config({ cursor = { zoom_factor = $(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {print $2 * 2.0}') } })\""
	)
)
hl.bind(
	mainMod .. " + ALT + mouse_up",
	hl.dsp.exec_cmd(
		"hyprctl eval \"hl.config({ cursor = { zoom_factor = $(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {if ($2 < 1) {print 1} else {print $2 / 2.0}}') } })\""
	)
)
hl.bind(mainMod .. " + CTRL + ALT + B", hl.dsp.exec_cmd(uscripts .. "/ToggleWaybar.sh"))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(scripts .. "/WaybarStyles.sh"))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(scripts .. "/WaybarLayout.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(scripts .. "/Hyprsunset.sh toggle"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(uscripts .. "/WallpaperSelect.sh"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(uscripts .. "/WallpaperEffects.sh"))
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.exec_cmd(uscripts .. "/WallpaperRandom.sh"))
hl.bind(mainMod .. " + CTRL + O", hl.dsp.exec_cmd(uscripts .. "/ZshChangeTheme.sh"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd(scripts .. "/KeyBinds.sh"))
hl.bind(mainMod .. " + CTRL + A", hl.dsp.exec_cmd(scripts .. "/Animations.sh"))
hl.bind(mainMod .. " + ALT + M", hl.dsp.exec_cmd(uscripts .. "/RofiBeats.sh"))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(uscripts .. "/RofiCalc.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(uscripts .. "/ScreenRecord.sh"))
hl.bind(mainMod .. " + SLASH", hl.dsp.exec_cmd(scripts .. "/AirplaneMode.sh"))
hl.bind(mainMod .. " + CTRL + F9", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + F10", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mainMod .. " + CTRL + F11", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + F12", hl.dsp.workspace.move({ monitor = "d" }))
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(scripts .. "/LockScreen.sh"))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(scripts .. "/Wlogout.sh"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd(scripts .. "/Kool_Quick_Settings.sh"))
hl.bind(mainMod .. " + CTRL + D", hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + I", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + CTRL + I", hl.dsp.exec_cmd(uscripts .. "/ToggleOpacity.sh"))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + M", hl.dsp.layout("splitratio 0.3"))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top())
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scripts .. "/Volume.sh --inc"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scripts .. "/Volume.sh --dec"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scripts .. "/Volume.sh --toggle-mic"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scripts .. "/Volume.sh --toggle"), { locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind("XF86Rfkill", hl.dsp.exec_cmd(scripts .. "/AirplaneMode.sh"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --nxt"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --prv"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --stop"), { locked = true })
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --pause"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --nxt"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(scripts .. "/MediaCtrl.sh --prv"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + Print", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --in5"))
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --in10"))
hl.bind("ALT + Print", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --active"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --swappy"))
hl.bind(
	"XF86KbdBrightnessDown",
	hl.dsp.exec_cmd(scripts .. "/BrightnessKbd.sh --dec"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86KbdBrightnessUp",
	hl.dsp.exec_cmd(scripts .. "/BrightnessKbd.sh --inc"),
	{ locked = true, repeating = true }
)
hl.bind("XF86Launch1", hl.dsp.exec_cmd("rog-control-center"), { locked = true })
hl.bind("XF86Launch3", hl.dsp.exec_cmd("asusctl led-mode -n"), { locked = true })
hl.bind("XF86Launch4", hl.dsp.exec_cmd("asusctl profile -n"), { locked = true })
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(scripts .. "/Brightness.sh --dec"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scripts .. "/Brightness.sh --inc"), { locked = true, repeating = true })
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd(scripts .. "/TouchPad.sh"), { locked = true })
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + Tab", hl.dsp.group.next())
hl.bind(mainMod .. " + CTRL + Tab", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.prev())
hl.bind(mainMod .. " + ALT + left", hl.dsp.group.move_window({ direction = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.group.move_window({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + G", hl.dsp.group.move_window({ direction = "out" }))
hl.bind("CTRL + SHIFT + 1", hl.dsp.group.active({ index = 1 }))
hl.bind("CTRL + SHIFT + 2", hl.dsp.group.active({ index = 2 }))
hl.bind("CTRL + SHIFT + 3", hl.dsp.group.active({ index = 3 }))
hl.bind("CTRL + SHIFT + 4", hl.dsp.group.active({ index = 4 }))
hl.bind("CTRL + SHIFT + 5", hl.dsp.group.active({ index = 5 }))
hl.bind("CTRL + SHIFT + 6", hl.dsp.group.active({ index = 6 }))
hl.bind("CTRL + SHIFT + 7", hl.dsp.group.active({ index = 7 }))
hl.bind("CTRL + SHIFT + 8", hl.dsp.group.active({ index = 8 }))
hl.bind("CTRL + SHIFT + 9", hl.dsp.group.active({ index = 9 }))
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CTRL + U", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special(""))
hl.bind(mainMod .. " + PERIOD", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + COMMA", hl.dsp.focus({ workspace = "e-1" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = -1 }))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = -1, follow = false }))
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("uwsm-app -- " .. terminal .. " -e nvim"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("uwsm-app -- " .. term .. " -e btop"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("uwsm-app -- " .. terminal .. " -e lazydocker"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("uwsm-app -- obsidian --disable-gpu --enable-wayland-ime"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("uwsm-app -- code"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("uwsm-app -- " .. terminal .. " -e opencode"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("kitty --class cava -e cava"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("kitty --class rmpc -e rmpc"))
hl.bind(mainMod .. " + SHIFT + ALT + M", hl.dsp.exec_cmd(uscripts .. "/switch_to_relax.sh"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("kitty --class cliplayer -e " .. uscripts .. "/ytdl-music.sh"))
hl.bind(mainMod .. " + ALT + M", hl.dsp.exec_cmd('kitty --class "ytdl_playlist" -e ' .. uscripts .. "/yt-playlist.sh"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("env LUTRIS_SKIP_INIT=1 lutris lutris:rungameid/2"))
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd(uscripts .. "/SetOpacity.sh"))
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd("guvcview"))
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd(HOME .. "/.config/hypr/scripts/kill_workspace.sh"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(scripts .. "/Brightness.sh --dec"), { repeating = true })
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(scripts .. "/Brightness.sh --inc"), { repeating = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd(scripts .. "/Brightness.sh --inc"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd(scripts .. "/Brightness.sh --dec"))
hl.bind(mainMod .. " + mouse_left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.exec_cmd("uwsm-app -- " .. term .. " -e btop"), { mouse = true })
hl.bind(
	"ALT + SHIFT_L",
	hl.dsp.exec_cmd(scripts .. "/SwitchKeyboardLayout.sh"),
	{ locked = true, non_consuming = true }
)
hl.bind(
	"SHIFT + ALT_L",
	hl.dsp.exec_cmd(scripts .. "/SwitchKeyboardLayout.sh"),
	{ locked = true, non_consuming = true }
)
hl.bind(mainMod .. " + CTRL + ALT + Tab", hl.dsp.exec_cmd(scripts .. "/OverviewToggle.sh"))
hl.bind("CTRL + ALT + Tab", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + CTRL + X", hl.dsp.exec_cmd(scripts .. "/close-all-windows.sh"))
hl.bind(mainMod .. " + mouse:275", hl.dsp.focus({ window = "obsidian" }))
hl.bind(mainMod .. " + mouse:276", hl.dsp.focus({ window = "jetbrains-clion" }))
hl.bind(mainMod .. " + SHIFT + CTRL + C", hl.dsp.exec_cmd(webapp .. ' "https://calendar.google.com"'))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(webapp .. ' "https://programmingadvices.com/l/dashboard"'))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(webapp .. ' "https://mail.google.com"'))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(webapp .. ' "https://web.whatsapp.com/"'))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("kitty -e python3 " .. HOME .. "/.config/hypr/UserScripts/pomo.py"))
hl.bind(mainMod .. " + SHIFT + CTRL + P", hl.dsp.exec_cmd(webapp .. ' "https://photos.google.com/"'))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(webapp .. ' "https://github.com"'))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(webapp .. ' "https://claude.ai/new"'))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd(webapp .. ' "https://chat.z.ai/"'))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(webapp .. ' "https://www.kimi.com/"'))
hl.bind(mainMod .. " + SHIFT + CTRL + A", hl.dsp.exec_cmd(webapp .. ' "https://aistudio.google.com"'))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("kitty --class yt-x -e yt-x"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd(webapp .. ' "https://x.com/"'))
hl.bind(mainMod .. " + SHIFT + CTRL + X", hl.dsp.exec_cmd(webapp .. ' "https://x.com/compose/post"'))
hl.bind(mainMod .. " + SHIFT + CTRL + M", hl.dsp.exec_cmd(webapp .. ' "https://managementdose.com/l/dashboard"'))
hl.bind(mainMod .. " + SHIFT + CTRL + B", hl.dsp.exec_cmd(webapp .. ' "https://www.busuu.com"'))
hl.bind(mainMod .. " + SHIFT + CTRL + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind(mainMod .. " + SHIFT + CTRL + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + F6", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + F6", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --in5"))
hl.bind(mainMod .. " + ALT + F6", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --in10"))
hl.bind("ALT + F6", hl.dsp.exec_cmd(scripts .. "/ScreenShot.sh --active"))
