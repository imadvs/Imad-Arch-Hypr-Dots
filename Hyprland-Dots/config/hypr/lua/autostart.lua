-- ------------------------
-- AUTOSTART (exec-once)
-- ------------------------
local HOME = os.getenv("HOME")
local scripts = HOME .. "/.config/hypr/scripts"
local uscripts = HOME .. "/.config/hypr/UserScripts"

hl.on("hyprland.start", function()
	hl.exec_cmd(HOME .. "/.config/hypr/initial-boot.sh")
	hl.exec_cmd("sh -c 'sleep 2; " .. scripts .. "/WallpaperDaemon.sh'")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd(scripts .. "/KeybindsLayoutInit.sh")
	hl.exec_cmd(scripts .. "/Dropterminal.sh kitty &")
	hl.exec_cmd(scripts .. "/Polkit.sh")
	hl.exec_cmd(scripts .. "/PortalHyprland.sh")
	hl.exec_cmd("swaync")
	hl.exec_cmd(uscripts .. "/WaybarStartup.sh")
	hl.exec_cmd("qs -c overview")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("hypridle")
	hl.exec_cmd(scripts .. "/LuaAutoReload.sh")
	hl.exec_cmd(scripts .. "/Hyprsunset.sh init")
	hl.exec_cmd(uscripts .. "/startup_apps.sh")
	hl.exec_cmd("uwsm app -- hyprsunset")
	hl.exec_cmd("uwsm app -- playerctld daemon")
	hl.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ 45% 50%")
end)
