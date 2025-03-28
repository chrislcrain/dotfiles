# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  poetry
  zsh-autosuggestions
  zsh-completions
  direnv
)

source $HOME/.profile
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Setup fuzzyfinder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setup  pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$PATH:/opt/nvim-linux64/bin:/Applications/WezTerm.app/Contents/MacOS"
export CODER_SSH_FORWARD_AGENT=TRUE

source $XDG_CONFIG_HOME/ohmyzsh/.zsh_custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Apply MacOS configs
if [[ "$(uname)" == "Darwin" ]]; then
    # Configure minikube alias
    # export kubectl="minikube kubectl --"

    # Point SSH agent to 1Password
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    export PATH="$PATH:/Library/PostgreSQL/17/bin"

    # Automatically start tmux if not already inside a session
    # if [[ -z "$TMUX" ]] && [[ -z "$SSH_TTY" ]] && [[ -n "$PS1" ]]; then
    #     tmux attach-session -t default || tmux new-session -s default
    # fi

    # Force tmp permissions
    # chmod 177 /tmp
    export PATH="$PATH:$HOME/.config/lua/lua-5.1/src"
fi

# direnv hook into shell (not necessary because it is a core plugin)
eval "$(direnv hook zsh)"

export VAULT_ADDR="https://vault.stoneridgeam.com"

##### DEVOPS MARKER START #####
source /Users/chriscrain/.dotty/latest/lib/aws-common.zsh
source /Users/chriscrain/.dotty/latest/lib/utils.zsh
export PATH=${HOME}/.dotty/latest/bin:${PATH}
##### DEVOPS MARKER END #####
