#!/usr/bin/env bash

R='\033[0;31m'   #'0;31' is Red's ANSI color code
G='\033[0;32m'   #'0;32' is Green's ANSI color code
Y='\033[1;32m'   #'1;32' is Yellow's ANSI color code
B='\033[0;34m'   #'0;34' is Blue's ANSI color code
N='\033[0m'

echo "${B}$(basename $0)${N}: ${Y}Setting shell to zsh.${N}"

if ! command -v zsh > /dev/null; then
  echo "${Y}zsh not found. Installing...${N}"
  case "$(uname -s)" in
  Darwin)
    brew install zsh
    ;;
  Linux) 
    apt install zsh
    ;;
  *)
    echo "unsupported OS"
    exit 1
    ;;
  esac
else
  echo "${Y}zsh is already installed.${N}"
fi

if [ "$(basename $SHELL)" != "zsh" ]; then
  echo -e "${Y}Current shell is not zsh. Fixing.${N}"
  sudo chsh $(which zsh) $USER
else
  echo "${Y}Shell is already zsh.${N}"
fi
