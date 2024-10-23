#######################################################
# SHELL
#######################################################

# Source common shell configurations
for config_file in ~/.config/shell/*; do
    [ -f "$config_file" ] && source "$config_file"
done