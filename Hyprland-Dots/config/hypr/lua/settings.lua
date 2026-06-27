-- ------------------------
-- CORE SETTINGS
-- ------------------------
hl.config({
	dwindle = {
		preserve_split = true,
		special_scale_factor = 0.8,
	},
	master = {
		new_status = "master",
		new_on_top = 1,
		mfact = 0.5,
	},
	general = {
		resize_on_border = true,
		layout = "dwindle",
		border_size = 2,
		gaps_in = 4,
		gaps_out = 6,
		col = {
			active_border = { colors = { color15, color14 }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		allow_tearing = false,
	},
	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 0.8,
		inactive_opacity = 0.7,
		fullscreen_opacity = 1.0,
		dim_inactive = true,
		dim_strength = 0.1,
		dim_special = 0.8,
		shadow = {
			enabled = true,
			range = 3,
			render_power = 1,
			color = "rgba(1a1a1aee)",
			color_inactive = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			ignore_opacity = true,
			new_optimizations = true,
			special = true,
			popups = true,
			vibrancy = 0.1696,
		},
	},
	group = {
		col = {
			border_active = color15,
		},
		groupbar = {
			col = {
				active = color0,
			},
		},
	},
	input = {
		kb_layout = "us,es",
		kb_options = "altwin:menu_win",
		kb_variant = "",
		kb_model = "",
		kb_rules = "",
		repeat_rate = 50,
		repeat_delay = 300,
		sensitivity = 0.35,
		numlock_by_default = false,
		left_handed = false,
		follow_mouse = 1,
		float_switch_override_focus = false,
		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			clickfinger_behavior = true,
			scroll_factor = 0.2,
			middle_button_emulation = false,
			tap_to_click = true,
			drag_lock = false,
		},
		touchdevice = {
			enabled = true,
		},
		tablet = {
			transform = 0,
			left_handed = 0,
		},
	},
	gestures = {
		workspace_swipe_distance = 500,
		workspace_swipe_invert = true,
		workspace_swipe_min_speed_to_force = 30,
		workspace_swipe_cancel_ratio = 0.5,
		workspace_swipe_create_new = true,
		workspace_swipe_forever = true,
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0, -- 0=off (fixes MPV/VLC fullscreen issues)
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		enable_swallow = false,
		swallow_regex = "^(kitty)$",
		focus_on_activate = false,
		initial_workspace_tracking = 0,
		middle_click_paste = false,
		enable_anr_dialog = true,
		anr_missed_pings = 15,
		allow_session_lock_restore = true,
	},
	binds = {
		workspace_back_and_forth = true,
		allow_workspace_cycles = true,
		pass_mouse_when_bound = false,
	},
	xwayland = {
		enabled = true,
		force_zero_scaling = true,
	},
	render = {
		direct_scanout = 0,
	},
	cursor = {
		sync_gsettings_theme = true,
		no_hardware_cursors = 2,
		enable_hyprcursor = false,
		warp_on_change_workspace = 2,
		no_warps = false,
	},
	debug = {
		vfr = true,
	},
	animations = {
		enabled = true,
	},
})

-- ------------------------
-- DEVICE CONFIGS
-- ------------------------
local touchpad = "asue1209:00-04f3:319f-touchpad"
hl.device({
	name = touchpad,
	enabled = true,
})

hl.device({
	name = "logitech-wireless-mouse-mx-master-1",
	scroll_factor = 0.8,
})

-- ------------------------
-- ANIMATION CURVES
-- ------------------------
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } })
hl.curve("crazyshot", { type = "bezier", points = { { 0.1, 1.5 }, { 0.76, 0.92 } } })
hl.curve("hyprnostretch", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.38, 0.04 }, { 1, 0.07 } } })
hl.curve("easeInOutCirc", { type = "bezier", points = { { 0.85, 0 }, { 0.15, 1 } } })
hl.curve("easeOutCirc", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("softAcDecel", { type = "bezier", points = { { 0.26, 0.26 }, { 0.15, 1 } } })
hl.curve("md2", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } })

-- ------------------------
-- ANIMATIONS
-- ------------------------
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "md3_accel", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "md3_decel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.6, bezier = "menu_accel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 4.5, bezier = "menu_accel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "md3_decel", style = "slidevert" })
