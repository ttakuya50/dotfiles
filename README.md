# dotfiles

## Installation
```bash
bash -c "$(curl -L raw.github.com/TsujiTakuya55/dotfiles/master/install.sh)" -s init
```

## Test＆Debug
```bash
docker build -t dotfiles:latest --build-arg USERNAME=$(whoami) .
docker run -it -v $(pwd)/install.sh:/home/$(whoami)/dotfiles/install.sh:ro dotfiles
sh dotfiles/install.sh init
```
