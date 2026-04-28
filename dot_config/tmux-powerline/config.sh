export TMUX_POWERLINE_SEG_WEATHER_UNIT="f"

# Match the transparent middle (status-style bg=default in tmux.conf) so the
# trailing/leading arrows don't render with a colour235 rectangle behind them.
export TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR="default"
export TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR="default"

TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
	"tmux_session_info 148 234"
	"hostname 33 0"
	"lan_ip 24 255 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}"
	"wan_ip 24 255"
	"vcs_branch 29 88"
)

TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
	"pwd 89 211"
	"weather 37 255"
)
