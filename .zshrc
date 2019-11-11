# zsh のインタラクティブシェル（ユーザーがコマンドを入力する画面）が起動した際に読み込まれる設定ファイル
# zplugを使用 → https://github.com/zplug/zplug/blob/master/doc/guide/ja/README.md

########################################
source ~/.zplug/init.zsh

# ダブルクォーテーションで囲うと良い
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"

# コマンドも管理する
# グロブを受け付ける（ブレースやワイルドカードなど）
zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"

# 読み込み順序を設定する
# 例: "zsh-syntax-highlighting" は compinit の前に読み込まれる必要がある
# （10 以上は compinit 後に読み込まれるようになる）
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose
########################################

export TMPDIR="/tmp"
export TZ="JST-09"
export MAKE_MODE="unix"
export LANG="ja_JP.UTF-8"
export JLESSCHARSET="japanese-sjis"
export C_INCLUDE_PATH="/usr/include/"
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
export GEM_HOME=$HOME/.gem
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# sourceTreeのリリースブランチマージのため
export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"

# まとめて最後にPATHをexport
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:$PATH # 基本
PATH=$GOPATH/bin:$PATH # go getしたコマンドを使用できるように
PATH=/usr/local/share/npm/bin:$PATH   # for npm apps.
PATH=$HOME/.gem/bin:$PATH   # for gems.
PATH=$HOME/.rbenv/bin:$PATH
PATH=/usr/local/opt/openssl/bin:$PATH
PATH=$HOME/.nodebrew/current/bin:$PATH
PATH=$GOROOT/bin:$PATH #godocが使用できるように
export PATH

# JAVA_VERSIONを変更することによってバージョン切り換え可能
# export JAVA_VERSION=1.8
# export JAVA_HOME=$(/usr/libexec/java_home -v $JAVA_VERSION)
# eval "$(rbenv init -)"

# 補完機能の強化.
autoload -U compinit
compinit
setopt auto_param_slash     # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える.
setopt mark_dirs            # ファイル名の展開でディレクトリにマッチした場合、末尾に / を付加.
setopt list_types           # 補完候補一覧でファイルの種別を識別マーク表示.
setopt auto_menu            # 補完キー連打で順に補完候補を自動で補完.
setopt auto_param_keys      # カッコの対応などを自動的に補完.
setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす.
setopt magic_equal_subst    # コマンドラインの引数で --prefix=/usr などの = 以降も補完.
setopt complete_in_word     # 語の途中でもカーソル位置で補完.
setopt always_last_prompt   # カーソル位置は保持したままファイル名一覧を順次その場で表示.
setopt extended_glob        # ファイル名で #, ~, ^ の 3 文字を正規表現として扱う.
setopt globdots             # 明確なドットの指定なしで.から始まるファイルをマッチ.
setopt brace_ccl            # {a-c} を a b c に展開する機能を使えるようにする.
setopt list_packed          # 補完候補を詰めて表示.
setopt auto_list            # 曖昧補完ですぐに補完候補を表示.

bindkey "^I" menu-complete                                          # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'                 # 補完時に大文字小文字を区別しない.
zstyle ':completion:*:default' menu select=1                        # 補完候補のカーソル選択を有効に.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'      # 補完候補がなければより曖昧に候補を探す.

# その他.
setopt print_eight_bit      # 日本語ファイル名等8ビットを通す.
setopt auto_resume          # サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム.
setopt equals               # =command を command のパス名に展開する.
setopt numeric_glob_sort    # ファイル名の展開で辞書順ではなく数値的にソート.
setopt auto_cd              # ディレクトリ名だけで cd.
setopt correct              # スペルチェック.
setopt NO_flow_control      # Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする.
setopt hist_no_store        # history (fc -l) コマンドをヒストリリストから取り除く.
setopt noautoremoveslash    # 最後のスラッシュを自動的に削除しない.

# プロンプト改変. (Git のブランチ情報も出力)
autoload -Uz vcs_info
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# カレントディレクトリ表示
autoload colors
colors
local p1="%F{green}[%~]%f %F{cyan}%n@%m%f"
local p2="%1(v|%F{red}%1v%f|)"
PROMPT=$p1$p2$'\n'"%% "

# 色付け
autoload -Uz colors
colors
alias ls='ls -G'
alias grep='grep -G'
alias fgrep='fgrep -G'
alias egrep='egrep -G'

#cd後自動でls
function chpwd() { ls -v -F -G }

# zshでCtrl+RとかCtrl+Aとか効かない問題の対処法
bindkey -e

# The next line updates PATH for the Google Cloud SDK.
if [ -e ~/google-cloud-sdk ]; then
  source ~/google-cloud-sdk/path.zsh.inc
  source ~/google-cloud-sdk/completion.zsh.inc
fi

# awsコマンドで補完機能が使用できるように
source /Users/a13539//Library/Python/3.6/bin/aws_zsh_completer.sh