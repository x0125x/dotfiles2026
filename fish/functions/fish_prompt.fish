function fish_prompt
    set -l last_status $status
    
    # Everblush Colors
    set -l cyan (set_color 6cbfbf)
    set -l green (set_color 8ccf7e)
    set -l normal (set_color normal)
    set -l blue (set_color 67b0e8)
    set -l red (set_color e57474)
    set -l yellow (set_color e5c76b)

    # Line 1: Directory
    echo -n -s $blue (prompt_pwd) $normal " "

    # Line 2: The "❯" symbol (Red if last command failed)
    if test $last_status -ne 0
        # If the last command failed, make them all shades of Red/Orange
        echo -n -s $red " ❯❯❯ "
    else
        # Success: Green -> Cyan -> Blue gradient
        echo -n -s $green " ❯" $yellow "❯" $red "❯ "
    end
    set_color normal
end
