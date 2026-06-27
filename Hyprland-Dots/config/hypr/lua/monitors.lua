-- ------------------------
-- MONITOR CONFIG
-- ------------------------
hl.monitor({ output = "eDP-1", mode = "3840x2160@60", position = "0x0", scale = 2.4 })
hl.monitor({ output = "HDMI-A-1", mode = "1024x768@60", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "highrr", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "highres", position = "auto", scale = 1 })

-- ------------------------
-- WORKSPACE RULES
-- ------------------------
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })
