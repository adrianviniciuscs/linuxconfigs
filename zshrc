# Export ZSH path (se for manter Oh My Zsh)
export ZSH="$HOME/.oh-my-zsh"

# Theme (se for manter Oh My Zsh)
ZSH_THEME="robbyrussell"

# Zinit configuration
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Apenas clona se não existe. Depois disso, essa parte é ignorada.
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Plugins Zinit
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# Se o fzf for carregado via zinit, o source do ~/.fzf.zsh pode ser redundante
# zinit light Aloxaf/fzf-tab # Exemplo, se você quiser fzf-tab com zinit

# Oh My Zsh (se for manter)
# Se você só usa o plugin git, talvez seja melhor remover o OMZ e carregar o plugin git via zinit
# ou apenas usar os aliases do git diretamente.
plugins=(git) # Se for usar, só o que realmente precisa.
source $ZSH/oh-my-zsh.sh


# FZF e Zoxide
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Se o zinit não carregar isso, mantenha.
eval "$(zoxide init zsh --cmd cd)"

# Path additions - Verificação para evitar duplicatas e ser mais robusto
PATH_ADDITIONS=(
  "$HOME/.local/scripts"
  "/root/.cargo/bin"
  "/usr/local/go/bin"
  "~/modelsim/modelsim_ase/bin/"
  "$HOME/.android_sdk/cmdline-tools/latest/bin"
  "$HOME/.android_sdk/emulator"
  "$HOME/.flutter/flutter/bin"
)

for p in "${PATH_ADDITIONS[@]}"; do
  p=$(eval echo "$p") # Expand tilde and variables
  if [[ ! -d "$p" ]]; then
    # Opcional: printar um aviso se o diretório não existe.
    # echo "Warning: Directory $p does not exist and won't be added to PATH." >&2
    continue
  fi
  [[ ":$PATH:" != *":$p:"* ]] && PATH="$PATH:$p"
done


# History configuration
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups

# Completion styling
autoload -U compinit && compinit # Isso deve vir depois dos plugins de completion.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
source /usr/share/doc/fzf/examples/key-bindings.zsh # Se ainda for necessário

# Aliases
alias ls='ls --color'
alias vim='nvim'
# alias c='clear' # Isso é opcional, eu removeria.
alias air="~/.air"
alias rpcs3="nohup ~/.local/bin/rpcs3.AppImage > /dev/null 2>&1 &" # Adicionado 2>&1 & para realmente rodar em background
alias ps2="nohup ~/pcsx2/pcsx2.AppImage > /dev/null 2>&1 &" # Adicionado 2>&1 &
alias checksize="df -h .; du -sh -- * | sort -hr"
alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'
alias wezconfig='nvim ~/.config/wezterm/'


# Environment Variables
export STRAVA_CID=115065
export STRAVA_SKEY=d4dc9510f9c7a1cb47c50ddf89e9a3dbf1caf2e2
export QSYS_ROOTDIR="/home/adrian/intelFPGA_lite/23.1std/quartus/sopc_builder/bin"
export ANDROID_SDK_ROOT="$HOME/.android_sdk"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Custom keybindings
bindkey -e
bindkey '^p' history-search-backward
# bindkey '^p' history-search-forward # Isso sobrescreve o anterior. Qual deles você quer?
bindkey -s ^f "tmux-sessionizer\n"


