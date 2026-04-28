export TMUX_POWERLINE_SEG_WEATHER_UNIT="f"

# Match the transparent middle (status-style bg=default in tmux.conf) so the
# trailing/leading arrows don't render with a colour235 rectangle behind them.
export TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR="default"
export TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR="default"

export TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL_COLOUR="21"
export TMUX_POWERLINE_SEG_LAN_IP_SYMBOL="Ⓛ "

TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
	"hostname 33 231"
	"lan_ip 24 231 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}"
	"wan_ip 24 231"
	"vcs_branch 220 21"
)

TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
	"pwd 89 211"
	"weather 37 255"
)
