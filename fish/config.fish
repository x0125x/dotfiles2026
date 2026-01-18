if status is-interactive
    # Start Fastfetch instead of Starship as requested
    fastfetch
end

# Set environment variables (matching the repo's style)
set -gx EDITOR nvim
set -gx TERMINAL kitty

# Disable the default greeting
set -g fish_greeting ""

# Load aliases (we will create this file next)
if test -f ~/.config/fish/conf.d/aliases.fish
    source ~/.config/fish/conf.d/aliases.fish
end
