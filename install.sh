#!/bin/bash

DOTPATH=~/.dotfiles
GITHUB="https://github.com/ttakuya50/dotfiles.git";

# 環境構築
initialize() {
    echo "init"

    # brewがインストールされていなければインストール実行
    if !(type "brew" > /dev/null 2>&1); then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # zshがインストールされていなければインストール実行
    if !(type "zsh" > /dev/null 2>&1); then
        # 対象のコマンドをインストールするような処理
        echo "zsh install・・・"
        brew install zsh
    fi

    # zplugがインストールされていなければインストール実行
    if !(type "zplug" > /dev/null 2>&1); then
        # 対象のコマンドをインストールするような処理
        echo "zplug install・・・"
        brew install zplug
    fi
}

# ファイルをダウンロード
download() {
    echo "download"

    if [ -d "$DOTPATH" ]; then
        log_fail "$DOTPATH: already exists"
        exit 1
    fi

    # gitが使用できる場合はgitを使用
    if  [ `which git` ]; then
        git clone --recursive "$GITHUB" "$DOTPATH"
    # 使えない場合は curl か wget を使用する
    elif [ `which curl` ] || [ `which wget` ]; then
        tarball="https://github.com/ttakuya50/dotfiles/archive/master.tar.gz"

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
}

# dotfilesをリンク
deploy() {
    echo "deploy"

    cd ~/.dotfiles
    if [ $? -ne 0 ]; then
        die "not found: $DOTPATH"
    fi

    # 移動できたらシンボリックリンクを実行する
    for f in .??*
    do
        [ "$f" = ".git" ] && continue

        ln -snfv "$DOTPATH/$f" "$HOME/$f"
    done
}

if [ "$1" = "deploy" -o "$1" = "d" ]; then
    deploy
elif [ "$1" = "install" -o "$1" = "i" ]; then
    initialize &&
    download &&
    deploy
fi