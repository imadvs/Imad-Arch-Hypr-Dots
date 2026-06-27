-- ------------------------
-- WINDOW RULES
-- ------------------------
hl.window_rule({
	name = "tag-browser-firefox",
	match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-browser-chrome",
	match = { class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-browser-chrome-default",
	match = { class = "^(chrome-.+-Default)$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-browser-chromium",
	match = { class = "^([Cc]hromium)$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-browser-edge",
	match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-browser-brave",
	match = { class = "^(Brave-browser(-beta|-dev|-unstable)?)$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-browser-thorium-cachy",
	match = { class = "^([Tt]horium-browser|[Cc]achy-browser)$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-browser-zen",
	match = { class = "^(zen-alpha|zen)$" },
	tag = "+browser",
})
hl.window_rule({
	name = "tag-notif",
	match = { class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" },
	tag = "+notif",
})
hl.window_rule({
	name = "tag-kool-cheat",
	match = { title = "^(KooL Quick Cheat Sheet)$" },
	tag = "+KooL_Cheat",
})
hl.window_rule({
	name = "tag-kool-settings",
	match = { title = "^(KooL Hyprland Settings)$" },
	tag = "+KooL_Settings",
})
hl.window_rule({
	name = "tag-kool-nwg",
	match = { class = "^(nwg-displays|nwg-look)$" },
	tag = "+KooL-Settings",
})
hl.window_rule({
	name = "tag-terminal",
	match = { class = "^(Alacritty|kitty|kitty-dropterm)$" },
	tag = "+terminal",
})
hl.window_rule({
	name = "tag-email",
	match = { class = "^([Tt]hunderbird|org.gnome.Evolution)$" },
	tag = "+email",
})
hl.window_rule({
	name = "tag-email-betterbird",
	match = { class = "^(eu.betterbird.Betterbird)$" },
	tag = "+email",
})
hl.window_rule({
	name = "tag-projects-codium",
	match = { class = "^(codium|codium-url-handler|VSCodium)$" },
	tag = "+projects",
})
hl.window_rule({
	name = "tag-projects-vscode",
	match = { class = "^(VSCode|code|code-url-handler)$" },
	tag = "+projects",
})
hl.window_rule({
	name = "tag-projects-jetbrains",
	match = { class = "^(jetbrains-.+)$" },
	tag = "+projects",
})
hl.window_rule({
	name = "tag-screenshare",
	match = { class = "^(com.obsproject.Studio)$" },
	tag = "+screenshare",
})
hl.window_rule({
	name = "tag-im-discord",
	match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" },
	tag = "+im",
})
hl.window_rule({
	name = "tag-im-ferdium",
	match = { class = "^([Ff]erdium)$" },
	tag = "+im",
})
hl.window_rule({
	name = "tag-im-whatsapp",
	match = { class = "^([Ww]hatsapp-for-linux)$" },
	tag = "+im",
})
hl.window_rule({
	name = "tag-im-zapzap",
	match = { class = "^(ZapZap|com.rtosta.zapzap)$" },
	tag = "+im",
})
hl.window_rule({
	name = "tag-im-telegram",
	match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" },
	tag = "+im",
})
hl.window_rule({
	name = "tag-im-teams",
	match = { class = "^(teams-for-linux)$" },
	tag = "+im",
})
hl.window_rule({
	name = "tag-im-element",
	match = { class = "^(im.riot.Riot|Element)$" },
	tag = "+im",
})
hl.window_rule({
	name = "tag-games-gamescope",
	match = { class = "^(gamescope)$" },
	tag = "+games",
})
hl.window_rule({
	name = "tag-games-steamapp",
	match = { class = "^(steam_app_\\d+)$" },
	tag = "+games",
})
hl.window_rule({
	name = "tag-gamestore-steam",
	match = { class = "^([Ss]team)$" },
	tag = "+gamestore",
})
hl.window_rule({
	name = "tag-gamestore-lutris",
	match = { title = "^([Ll]utris)$" },
	tag = "+gamestore",
})
hl.window_rule({
	name = "tag-gamestore-heroic",
	match = { class = "^(com.heroicgameslauncher.hgl)$" },
	tag = "+gamestore",
})
hl.window_rule({
	name = "tag-fm-thunar-nautilus",
	match = { class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" },
	tag = "+file-manager",
})
hl.window_rule({
	name = "tag-fm-warp",
	match = { class = "^(app.drey.Warp)$" },
	tag = "+file-manager",
})
hl.window_rule({
	name = "tag-wallpaper",
	match = { class = "^([Ww]aytrogen)$" },
	tag = "+wallpaper",
})
hl.window_rule({
	name = "tag-multimedia-audio",
	match = { class = "^([Aa]udacious)$" },
	tag = "+multimedia",
})
hl.window_rule({
	name = "tag-multimedia-video",
	match = { class = "^([Mm]pv|vlc)$" },
	tag = "+multimedia_video",
})
hl.window_rule({
	name = "tag-settings-rog",
	match = { title = "^(ROG Control)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-wihotspot",
	match = { class = "^(wihotspot(-gui)?)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-baobab",
	match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-disks",
	match = { class = "^(gnome-disks|wihotspot(-gui)?)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-kvantum",
	match = { title = "(Kvantum Manager)" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-fileroller",
	match = { class = "^(file-roller|org.gnome.FileRoller)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-network",
	match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-pavucontrol",
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-qtct",
	match = { class = "^(qt5ct|qt6ct|[Yy]ad)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-xdg-portal",
	match = { class = "(xdg-desktop-portal-gtk)" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-polkit",
	match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-settings-rofi",
	match = { class = "^([Rr]ofi)$" },
	tag = "+settings",
})
hl.window_rule({
	name = "tag-viewer-system-monitor",
	match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" },
	tag = "+viewer",
})
hl.window_rule({
	name = "tag-viewer-evince",
	match = { class = "^(evince)$" },
	tag = "+viewer",
})
hl.window_rule({
	name = "tag-viewer-image",
	match = { class = "^(eog|org.gnome.Loupe)$" },
	tag = "+viewer",
})

hl.window_rule({ name = "opacity-browser", match = { tag = "browser" }, opacity = "0.99 0.8" })
hl.window_rule({ name = "opacity-projects", match = { tag = "projects" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-im", match = { tag = "im" }, opacity = "0.94 0.86" })
hl.window_rule({ name = "opacity-multimedia", match = { tag = "multimedia" }, opacity = "0.94 0.86" })
hl.window_rule({ name = "opacity-fm", match = { tag = "file-manager" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-terminal", match = { tag = "terminal" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-settings", match = { tag = "settings" }, opacity = "0.8 0.7" })
hl.window_rule({ name = "opacity-viewer", match = { tag = "viewer" }, opacity = "0.82 0.75" })
hl.window_rule({ name = "opacity-wallpaper", match = { tag = "wallpaper" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-pip", match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.75" })
hl.window_rule({ name = "opacity-obsidian", match = { class = "^(obsidian)$" }, opacity = "0.85 0.75" })
hl.window_rule({ name = "opacity-jetbrains", match = { class = "^(jetbrains-.*)$" }, opacity = "0.85 0.75" })
hl.window_rule({ name = "opacity-clion", match = { class = "^(jetbrains-clion)$" }, opacity = "0.95 0.85" })
hl.window_rule({
	name = "opacity-gedit",
	match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" },
	opacity = "0.8 0.7",
})
hl.window_rule({ name = "opacity-deluge", match = { class = "^(deluge)$" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-seahorse", match = { class = "^(seahorse)$" }, opacity = "0.9 0.8" })

hl.window_rule({ name = "float-kool-cheat", match = { tag = "KooL_Cheat" }, float = true })
hl.window_rule({ name = "float-wallpaper", match = { tag = "wallpaper" }, float = true })
hl.window_rule({ name = "float-settings", match = { tag = "settings" }, float = true })
hl.window_rule({ name = "float-viewer", match = { tag = "viewer" }, float = true })
hl.window_rule({ name = "float-kool-settings", match = { tag = "KooL-Settings" }, float = true })
hl.window_rule({ name = "float-zoom", match = { class = "([Zz]oom|onedriver|onedriver-launcher)" }, float = true })
hl.window_rule({
	name = "float-calculator",
	match = { class = "(org.gnome.Calculator)", title = "(Calculator)" },
	float = true,
})
hl.window_rule({ name = "float-mpv-clapper", match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ name = "float-qalculate", match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ name = "float-ferdium", match = { class = "^([Ff]erdium)$" }, float = true })
hl.window_rule({ name = "float-pip", match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ name = "float-auth-dialog", match = { title = "^(Authentication Required)$" }, float = true })
hl.window_rule({
	name = "float-codium-dialog",
	match = { class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" },
	float = true,
})
hl.window_rule({
	name = "float-heroic-dialog",
	match = { class = "^(com.heroicgameslauncher.hgl)$", title = "negative:(Heroic Games Launcher)" },
	float = true,
})
hl.window_rule({
	name = "float-steam-dialog",
	match = { class = "^([Ss]team)$", title = "negative:^([Ss]team)$" },
	float = true,
})
hl.window_rule({
	name = "float-thunar-dialog",
	match = { class = "([Tt]hunar)", title = "negative:(.*[Tt]hunar.*)" },
	float = true,
})
hl.window_rule({ name = "float-add-folder", match = { title = "^(Add Folder to Workspace)$" }, float = true })
hl.window_rule({ name = "float-save-as", match = { title = "^(Save As)$" }, float = true })
hl.window_rule({ name = "float-open-files", match = { initial_title = "(Open Files)" }, float = true })
hl.window_rule({ name = "float-sddm-bg", match = { title = "^(SDDM Background)$" }, float = true })
hl.window_rule({ name = "float-yad-dialog", match = { class = "^(yad)$", title = "^(YAD)$" }, float = true })

hl.window_rule({
	name = "size-kool-cheat",
	match = { tag = "KooL_Cheat" },
	size = { "monitor_w*0.65", "monitor_h*0.9" },
})
hl.window_rule({ name = "size-wallpaper", match = { tag = "wallpaper" }, size = { "monitor_w*0.7", "monitor_h*0.7" } })
hl.window_rule({ name = "size-settings", match = { tag = "settings" }, size = { "monitor_w*0.7", "monitor_h*0.7" } })
hl.window_rule({
	name = "size-whatsapp",
	match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" },
	size = { "monitor_w*0.6", "monitor_h*0.7" },
})
hl.window_rule({
	name = "size-ferdium",
	match = { class = "^([Ff]erdium)$" },
	size = { "monitor_w*0.6", "monitor_h*0.7" },
})
hl.window_rule({
	name = "size-add-folder",
	match = { title = "^(Add Folder to Workspace)$" },
	size = { "monitor_w*0.7", "monitor_h*0.6" },
})
hl.window_rule({
	name = "size-save-as",
	match = { title = "^(Save As)$" },
	size = { "monitor_w*0.7", "monitor_h*0.6" },
})
hl.window_rule({
	name = "size-open-files",
	match = { initial_title = "(Open Files)" },
	size = { "monitor_w*0.7", "monitor_h*0.6" },
})
hl.window_rule({
	name = "size-sddm-bg",
	match = { title = "^(SDDM Background)$" },
	size = { "monitor_w*0.16", "monitor_h*0.12" },
})
hl.window_rule({
	name = "size-yad-dialog",
	match = { class = "^(yad)$", title = "^(YAD)$" },
	size = { "monitor_w*0.2", "monitor_h*0.2" },
})

hl.window_rule({ name = "center-kool-cheat", match = { tag = "KooL_Cheat" }, center = true })
hl.window_rule({
	name = "center-thunar",
	match = { class = "([Tt]hunar)", title = "negative:(.*[Tt]hunar.*)" },
	center = true,
})
hl.window_rule({ name = "center-rog", match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ name = "center-kool-settings", match = { tag = "KooL-Settings" }, center = true })
hl.window_rule({ name = "center-keybinds", match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({
	name = "center-pavucontrol",
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
	center = true,
})
hl.window_rule({
	name = "center-whatsapp",
	match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" },
	center = true,
})
hl.window_rule({ name = "center-ferdium", match = { class = "^([Ff]erdium)$" }, center = true })
hl.window_rule({
	name = "center-auth-dialog",
	match = { title = "^(Authentication Required)$" },
	center = true,
	float = true,
})
hl.window_rule({
	name = "center-add-folder",
	match = { title = "^(Add Folder to Workspace)$" },
	center = true,
	float = true,
})
hl.window_rule({ name = "center-save-as", match = { title = "^(Save As)$" }, center = true, float = true })
hl.window_rule({ name = "center-sddm-bg", match = { title = "^(SDDM Background)$" }, center = true, float = true })
hl.window_rule({ name = "center-yad", match = { class = "^(yad)$", title = "^(YAD)$" }, center = true, float = true })

hl.window_rule({ name = "pip-move", match = { title = "^(Picture-in-Picture)$" }, move = "72% 7%" })
hl.window_rule({ name = "pip-pin", match = { title = "^(Picture-in-Picture)$" }, pin = true, keep_aspect_ratio = true })

hl.window_rule({ name = "jetbrains-workspace", match = { class = "^(jetbrains-clion)$" }, workspace = "1 silent" })
hl.window_rule({
	name = "jetbrains-no-focus-1",
	match = { class = "^(jetbrains-.*)$", title = "^$" },
	no_initial_focus = true,
})
hl.window_rule({
	name = "jetbrains-no-focus-2",
	match = { class = "^(jetbrains-.*)$", title = "^(win.*)$" },
	no_initial_focus = true,
})
hl.window_rule({
	name = "jetbrains-center-splash",
	match = { class = "^(jetbrains-.*)$", title = "^(Welcome to.*)$" },
	center = true,
})
hl.window_rule({
	name = "jetbrains-center-splash-2",
	match = { class = "^(jetbrains-.*)$", title = "^(splash)$" },
	center = true,
})

hl.window_rule({ name = "games-noblur", match = { tag = "games" }, no_blur = true })
hl.window_rule({ name = "games-full", match = { tag = "games" }, fullscreen = 0 })
hl.window_rule({ name = "video-noblur", match = { tag = "multimedia_video" }, no_blur = true })
hl.window_rule({ name = "video-opacity", match = { tag = "multimedia_video" }, opacity = "1.0 1.0" })
hl.window_rule({ name = "idle-inhibit-fullscreen", match = { fullscreen = true }, idle_inhibit = "fullscreen" })
hl.window_rule({ name = "no-focus-jetbrains", match = { class = "^(jetbrains-.*)" }, no_initial_focus = true })
hl.window_rule({ name = "no-focus-wind", match = { title = "^(wind.*)$" }, no_initial_focus = true })

hl.window_rule({ name = "edu-code", match = { class = "^(Code|code)$" }, workspace = "1 silent" })
hl.window_rule({ name = "edu-obsidian", match = { class = "^(obsidian)$" }, workspace = "2 silent" })
hl.window_rule({
	name = "edu-brave-pa",
	match = {
		class = "^(brave-programmingadvices.*)$",
		title = ".*(ProgrammingAdvices|Dashboard|programmingadvices).*",
	},
	workspace = "2 silent",
})
hl.window_rule({ name = "edu-ytmusic", match = { class = ".*youtubemusic.*" }, workspace = "4 silent" })
hl.window_rule({
	name = "edu-pomo",
	match = { title = "^(.*Pomofocus.*|.*Time to focus.*|.*Pomodoro.*)$" },
	workspace = "4 silent",
})
hl.window_rule({ name = "edu-busuu", match = { class = ".*busuu.*" }, workspace = "3 silent" })
hl.window_rule({ name = "edu-mdose", match = { class = ".*managementdose.*" }, workspace = "3 silent" })
hl.window_rule({ name = "edu-busuu-title", match = { title = ".*Busuu.*" }, workspace = "3 silent" })
hl.window_rule({ name = "edu-mdose-title", match = { title = ".*Management Dose.*" }, workspace = "3 silent" })
hl.window_rule({ name = "dash-rmpc", match = { class = "^(rmpc)$" }, workspace = "4 silent" })
hl.window_rule({ name = "dash-pomofocus", match = { class = "^(pomofocus)$" }, workspace = "4 silent" })
hl.window_rule({ name = "dash-cava", match = { class = "^(cava)$" }, workspace = "4 silent" })
hl.window_rule({ name = "dash-clock", match = { class = "^(clock-rs)$" }, workspace = "4 silent" })

-- ------------------------
-- LAYER RULES
-- ------------------------
hl.layer_rule({ name = "layer-rofi", match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ name = "layer-notifications", match = { namespace = "notifications" }, blur = true })
hl.layer_rule({ name = "layer-quickshell", match = { namespace = "quickshell:overview" }, blur = true })
hl.layer_rule({ name = "layer-quickshell-ia", match = { namespace = "quickshell:overview" }, ignore_alpha = 0.5 })
