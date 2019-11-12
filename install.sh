#!/bin/bash

DOTPATH=~/.dotfiles

initialize() {
    echo "init"
    # 使えない場合は curl か wget を使用する
if [ `which curl` ] || [ `which wget` ]; then
    tarball="https://github.com/TsujiTakuya55/dotfiles/archive/master.tar.gz"

    # どっちかでダウンロードして，tar に流す
    if [ `which curl` ]; then
        curl -L "$tarball"

    elif [ `which wget` ]; then
        wget -O - "$tarball"

    fi | tar zxv

    # 解凍したら，DOTPATH に置く
    mv -f dotfiles-master "$DOTPATH"

else
    die "curl or wget required"
fi

cd ~/.dotfiles
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

# zshがインストールされていなければインストール実行
if !(type "zsh" > /dev/null 2>&1); then
    # 対象のコマンドをインストールするような処理
    echo "zsh install・・・"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install zsh
fi

# zplugがインストールされていなければインストール実行
if !(type "zplug" > /dev/null 2>&1); then
    # 対象のコマンドをインストールするような処理
    echo "zplug install・・・"
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# 移動できたらシンボリックリンクを実行する
for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done
}

deploy() {
    #...
    echo "deploy"
}

if [ "$1" = "deploy" -o "$1" = "d" ]; then
    deploy
elif [ "$1" = "init" -o "$1" = "i" ]; then
    initialize
fi