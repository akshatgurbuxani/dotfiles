# Architecture-agnostic brew (Apple Silicon / Intel / Linux)
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -f "$_brew" ]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
