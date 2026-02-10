#!/bin/bash

# --- 1. Define Master Colors ---
export CLR_BG="1a1b26" 
export CLR_LBG="383e5a" 
export CLR_FG="9aa5ce" 
export CLR_RED="f7768e"
export CLR_MAGENTA="bb9af7"
export CLR_GREEN="73daca"
export CLR_BLUE="7aa2f7"
export CLR_ACCENT="7dcfff"
export CLR_YELLOW="e0af68"
export CLR_WHITE="cfc9c2"

# --- 2. Generate Hyprland colors.conf ---
cat <<EOF > ~/.config/hypr/colors.conf
\$c_bg      = rgba(${CLR_BG}ff)
\$c_lbg     = rgba(${CLR_LBG}ff)
\$c_fg      = rgba(${CLR_FG}ff)
\$c_red     = rgba(${CLR_RED}ff)
\$c_magenta = rgba(${CLR_MAGENTA}ff)
\$c_green   = rgba(${CLR_GREEN}ff)
\$c_blue    = rgba(${CLR_BLUE}ff)
\$c_accent  = rgba(${CLR_ACCENT}ff)
EOF

# --- 3. Generate Eww colors.scss ---
cat <<EOF > ~/.config/eww/_colors.scss
\$bg: #$CLR_BG;
\$lbg: #$CLR_LBG;
\$fg: #$CLR_FG;
\$red: #$CLR_RED;
\$magenta: #$CLR_MAGENTA;
\$green: #$CLR_GREEN;
\$blue: #$CLR_BLUE;
\$accent: #$CLR_ACCENT;
\$yellow: #$CLR_YELLOW;
\$white: #$CLR_WHITE;
EOF

# --- 4. Generate Rofi colors.rasi ---
cat <<EOF > ~/.config/rofi/colors.rasi
* {
    bg: #$CLR_BG;
    lbg: #$CLR_LBG;
    fg: #$CLR_FG;
    accent: #$CLR_ACCENT;
    red: #$CLR_RED;
}
EOF

# --- 6. Generate Kitty Colors ---
cat <<EOF > ~/.config/kitty/theme.conf
# Basic Colors
background            #$CLR_BG
foreground            #$CLR_FG
cursor                #$CLR_ACCENT
selection_background  #$CLR_LBG

# Terminal Colors (ANSI)
# Black
color0                #$CLR_BG
color8                #$CLR_LBG

# Red
color1                #$CLR_RED
color9                #$CLR_RED

# Green
color2                #$CLR_GREEN
color10               #$CLR_GREEN

# Yellow
color3                #$CLR_YELLOW
color11               #$CLR_YELLOW

# Blue
color4                #$CLR_BLUE
color12               #$CLR_BLUE

# Magenta
color5                #$CLR_MAGENTA
color13               #$CLR_MAGENTA

# Cyan
color6                #$CLR_ACCENT
color14               #$CLR_ACCENT

# White
color7                #$CLR_FG
color15               #$CLR_FG
EOF

kitty @ set-colors -a "~/.config/kitty/theme.conf"

# --- 7. Generate Fish Colors ---
mkdir -p ~/.config/fish/conf.d
cat <<EOF > ~/.config/fish/conf.d/colors.fish
# Set syntax highlighting colors to match Everblush
set -g fish_color_normal ffffff
set -g fish_color_command $CLR_ACCENT
set -g fish_color_quote $CLR_FG
set -g fish_color_redirection $CLR_FG
set -g fish_color_end $CLR_FG
set -g fish_color_error $CLR_RED
set -g fish_color_param $CLR_FG
set -g fish_color_comment 676E95
set -g fish_color_selection --background=$CLR_LBG
set -g fish_color_search_match --background=$CLR_LBG
set -g fish_color_operator $CLR_ACCENT
set -g fish_color_escape $CLR_ACCENT
set -g fish_color_autosuggestion 676E95
EOF

# --- 9. Generate VS Code / Code-OSS Colors ---
cat <<EOF > ~/.config/Code\ -\ OSS/User/global_colors.css
/* Variables for Code - OSS UI */
:root {
    --bg: #$CLR_BG;
    --lbg: #$CLR_LBG;
    --fg: #$CLR_FG;
    --accent: #$CLR_ACCENT;
    --white: #$CLR_WHITE;
}

/* Apply colors to the Activity Bar and Sidebar */
.part.activitybar, .part.sidebar {
    background-color: var(--bg) !important;
}

/* Apply colors to the Editor Tabs */
.tabs-container {
    background-color: var(--bg) !important;
}

.tab.active {
    background-color: var(--accent) !important;
    color: var(--bg) !important;
}

/* Set the general text color to white */
.monaco-workbench {
    color: var(--fg) !important;
}
EOF

python3 -c "
import json, os, re

path = os.path.expanduser('~/.config/Code - OSS/User/settings.json')
bg = '#$CLR_BG'
lbg = '#$CLR_LBG'
fg = '#$CLR_FG'
accent = '#$CLR_ACCENT'
white = '#$CLR_WHITE'

if os.path.exists(path):
    with open(path, 'r') as f:
        content = f.read()
        content = re.sub(r',(\s*[\]}])', r'\1', content) # Fix trailing commas
        data = json.loads(content)
else:
    data = {}

# Apply colors directly to the UI without external CSS
data['workbench.colorCustomizations'] = {
    'editor.background': bg,
    'sideBar.background': bg,
    'activityBar.background': bg,
    'editorGroupHeader.tabsBackground': bg,
    'tab.activeBackground': lbg,
    'tab.activeForeground': white,
    'tab.inactiveBackground': bg,
    'tab.inactiveForeground': fg,
    'statusBar.background': lbg,
    'statusBar.foreground': white,
    'titleBar.activeBackground': bg,
    'titleBar.activeForeground': fg
}

with open(path, 'w') as f:
    json.dump(data, f, indent=4)
"
# --- 10. Generate Firefox Colors ---
FF_THEME_DIR="$HOME/.config/firefox-theme-dynamic"
mkdir -p "$FF_THEME_DIR"

cat <<EOF > "$FF_THEME_DIR/manifest.json"
{
  "manifest_version": 2,
  "version": "1.0",
  "name": "Dynamic Script Theme",
  "theme": {
    "colors": {
      "frame": "#$CLR_BG",
      "frame_inactive": "#$CLR_BG",
      "toolbar": "#$CLR_BG",
      "toolbar_field": "#$CLR_LBG",
      "toolbar_field_text": "#$CLR_FG",
      "toolbar_field_border": "#$CLR_LBG",
      "toolbar_field_focus": "#$CLR_LBG",
      "toolbar_field_text_focus": "#$CLR_WHITE",
      "toolbar_top_separator": "#$CLR_LBG",
      "toolbar_bottom_separator": "#$CLR_LBG",
      "tab_line": "#$CLR_ACCENT",
      "tab_selected": "#$CLR_LBG",
      "tab_text": "#$CLR_WHITE",
      "tab_background_text": "#$CLR_FG",
      "tab_loading": "#$CLR_BLUE",
      "icons": "#$CLR_ACCENT",
      "icons_attention": "#$CLR_RED",
      "popup": "#$CLR_BG",
      "popup_text": "#$CLR_FG",
      "popup_highlight": "#$CLR_ACCENT",
      "popup_highlight_text": "#$CLR_BG",
      "ntp_background": "#$CLR_BG",
      "ntp_text": "#$CLR_FG",
      "sidebar": "#$CLR_BG",
      "sidebar_text": "#$CLR_FG",
      "sidebar_border": "#$CLR_LBG",
      "sidebar_highlight": "#$CLR_ACCENT",
      "sidebar_highlight_text": "#$CLR_BG"
    }
  }
}
EOF

cd "$FF_THEME_DIR" && zip -r ../firefox_theme.zip . > /dev/null
echo "Dynamic Firefox theme generated at ~/.config/firefox_theme.zip. To apply go to about:debugging#/runtime/this-firefox and select the generated file."

# --- 11. Vesktop quickCss ---
# TBD

# --- 12. Spotatui theme ---
# TBD
#
# --- 13. CAVA gradient ---

CAVA_CONF="$HOME/.config/cava/config"
sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '#$CLR_BLUE'/" "$CAVA_CONF"
sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '#$CLR_ACCENT'/" "$CAVA_CONF"

# --- 12. Reload Components ---
hyprctl reload
eww reload
pkill -USR1 kitty
