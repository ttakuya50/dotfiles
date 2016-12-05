# zsh が起動した際に必ず読み込まれる設定ファイル
# 主に環境変数を記載
GOPATH="$HOME/.go"

PATH="$GOPATH/bin:$PATH"
export PATH

alias s="source ~/.zshrc"
