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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$PATH:/opt/nvim-linux64/bin:/Applications/WezTerm.app/Contents/MacOS"
export CODER_SSH_FORWARD_AGENT=TRUE

source $XDG_CONFIG_HOME/ohmyzsh/.zsh_custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Apply MacOS configs
if [[ "$(uname)" == "Darwin" ]]; then
    export kubectl="minikube kubectl --"
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    export PATH="$PATH:/Library/PostgreSQL/17/bin"
    export PATH=${HOME}/.dotty/latest/bin:${PATH}
fi
##### DEVOPS MARKER START #####
source ~/.dotty/latest/lib/aws-common.zsh
source ~/.dotty/latest/lib/utils.zsh
##### DEVOPS MARKER END #####

# direnv hook into shell (not necessary because it is a core plugin)
eval "$(direnv hook zsh)"
