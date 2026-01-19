if status is-interactive
    fastfetch
end

set -gx EDITOR nvim
set -gx TERMINAL kitty

set -g fish_greeting ""

#load configs
if test -f ~/.config/fish/conf.d/aliases.fish
    source ~/.config/fish/conf.d/aliases.fish
end

# abbreviations
abbr -a '!!' --position anywhere --function last_history_item
abbr -a '%%' --position anywhere --function last_job_id

# helper functions
function last_history_item
	echo $history[1]
end

function last_job_id
	set -l last_job (jobs -p | tail -n 1)
	if test -n "$last_job"
		echo $last_job
	else
		echo ""
	end
end
