#######################################################
# SHELL
#######################################################

eval $(/opt/homebrew/bin/brew shellenv)

# Source common shell configurations
for config_file in "$HOME/.config/shell/"*; do
    [ -f "$config_file" ] && source "$config_file"
done
