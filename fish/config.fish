source ~/.bash_aliases
#moved PATs/secrets/work specific env outside of dotfiles
source ~/.secrets
set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

set -x -g TERM "xterm-256color"

set -x SSL_CERT_FILE "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"
set -x REQUESTS_CA_BUNDLE "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"


# fish presets
set -g theme_newline_cursor yes
set -g theme_nerd_fonts yes

#rust
set -Ua fish_user_paths $HOME/.cargo/bin

#fzf.fish presets
fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp
set -gx EDITOR "nvim"
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

# >>> conda initialize >>>
# Don't start base automatically
set -Ux CONDA_AUTO_ACTIVATE_BASE false
# !! Contents within this block are managed by 'conda init' !!
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/moa37394/google-cloud-sdk/path.fish.inc' ]; . '/Users/moa37394/google-cloud-sdk/path.fish.inc'; end
