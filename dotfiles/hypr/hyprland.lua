---@diagnostic disable: undefined-global

-- To evade the warning : Undefined global `hl`.

-- ==========================================================
-- VARIABLES ET DÉPENDANCES
-- ==========================================================
local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "kitty -- bash -c yazi"
local menu = "wofi --show drun"

-- ==========================================================
-- MONITEURS
-- ==========================================================
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

-- ==========================================================
-- AUTOSTART (Remplace les 'exec-once')
-- ==========================================================
hl.on("hyprland.start", function()
	-- Environnement Systemd/DBus vital pour Wayland et Sunshine
	hl.exec_cmd(
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP LIBVA_DRIVER_NAME GBM_BACKEND __GLX_VENDOR_LIBRARY_NAME"
	)
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP LIBVA_DRIVER_NAME GBM_BACKEND __GLX_VENDOR_LIBRARY_NAME"
	)

	-- Services d'arrière-plan
  hl.exec_cmd("sunshine &")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	-- Lancement des applications de ta forge
	hl.exec_cmd("qs -c ~/.config/quickshell/forge/")
	hl.exec_cmd("~/Documents/bluetuith_0.2.6_Linux_x86_64/bluetuith")
	-- hl.exec_cmd("hyprpaper")
	-- hl.exec_cmd("awww-daemon &")
	-- hl.exec_cmd("~/.config/hypr/scripts/awww_slideshow.sh &")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("kbuildsycoca6")
	hl.exec_cmd("mako")
end)

-- ==========================================================
-- CONFIGURATION GLOBALE
-- ==========================================================
hl.config({
	-- Variables d'environnement
	env = {
		"XDG_CURRENT_DESKTOP,Hyprland",
		"XDG_SESSION_TYPE,wayland",
		"XDG_SESSION_DESKTOP,Hyprland",
		"LIBVA_DRIVER_NAME,nvidia",
		"GBM_BACKEND,nvidia-drm",
		"__GLX_VENDOR_LIBRARY_NAME,nvidia",
		"QT_QPA_PLATFORMTHEME,qt6ct",
	},

	general = {
		gaps_in = 3,
		gaps_out = 5,
		border_size = 2,
		["col.active_border"] = {
			colors = { "rgba(900048ff)", "rgba(ff00ffff)", "rgba(8a2be2ff)" },
			angle = 45,
		},
		["col.inactive_border"] = "rgba(313244aa)",
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 15,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
		bezier = {
			"easeOutQuint, 0.23, 1, 0.32, 1",
			"easeInOutCubic, 0.65, 0.05, 0.36, 1",
			"linear, 0, 0, 1, 1",
			"almostLinear, 0.5, 0.5, 0.75, 1",
			"quick, 0.15, 0, 0.1, 1",
		},
		animation = {
			"global, 1, 10, default",
			"border, 1, 5.39, easeOutQuint",
			"windows, 1, 4.79, easeOutQuint",
			"windowsIn, 1, 4.1, easeOutQuint, popin 87%",
			"windowsOut, 1, 1.49, linear, popin 87%",
			"fadeIn, 1, 1.73, almostLinear",
			"fadeOut, 1, 1.46, almostLinear",
			"fade, 1, 3.03, quick",
			"layers, 1, 3.81, easeOutQuint",
			"layersIn, 1, 4, easeOutQuint, fade",
			"layersOut, 1, 1.5, linear, fade",
			"fadeLayersIn, 1, 1.79, almostLinear",
			"fadeLayersOut, 1, 1.39, almostLinear",
			"workspaces, 1, 1.94, almostLinear, fade",
			"workspacesIn, 1, 1.21, almostLinear, fade",
			"workspacesOut, 1, 1.94, almostLinear, fade",
			"zoomFactor, 1, 7, quick",
		},
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},

	input = {
		kb_layout = "fr",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},

	cursor = {
		no_hardware_cursors = true,
	},

	device = {
		{
			name = "epic-mouse-v1",
			sensitivity = -0.5,
		},
	},
})

-- ==========================================================
-- KEYBINDINGS (Raccourcis Clavier)
-- ==========================================================

-- Applications et Actions de base
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.layout("pseudo"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen({ "fullscreen", "toggle" }))

-- Capture d'écran
hl.bind("F10", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Déplacement du focus (Flèches)
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Espaces de travail : AZERTY (Boucle Lua optimisée)
local azerty_workspaces = {
	["ampersand"] = "1",
	["eacute"] = "2",
	["quotedbl"] = "3",
	["apostrophe"] = "4",
	["parenleft"] = "5",
	["minus"] = "6",
	["egrave"] = "7",
	["underscore"] = "8",
	["ccedilla"] = "9",
	["agrave"] = "10",
}
for key, ws in pairs(azerty_workspaces) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- Espaces de travail : Pavé Numérique (Boucle Lua optimisée)
for i = 0, 9 do
	local ws = i == 0 and "10" or tostring(i)
	hl.bind(mainMod .. " + KP_" .. i, hl.dsp.focus({ workspace = ws }))
end

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Navigation des workspaces à la souris
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Redimensionnement/Déplacement des fenêtres à la souris
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Touches Multimédia & Luminosité (Remplacement de bindel et bindl avec les tables d'options Lua)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { repeating = true, locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- ==========================================================
-- RÈGLES DE FENÊTRES (Window Rules)
-- ==========================================================
hl.window_rule({
	"suppress_event maximize",
	match = { class = ".*" },
})

hl.window_rule({
	"no_focus true",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
})

hl.window_rule({
	"move 20 monitor_h-120",
	"float true",
	match = { class = "hyprland-run" },
})
