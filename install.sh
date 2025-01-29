#!/bin/zsh

mac_config=(nvim zsh ghostty aerospace)

for config in $mac_config; do 
  stow -Dv $config && stow -v $config 
done
