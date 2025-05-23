#!/bin/zsh

#### Install all apps from Brew 
brew bundle install


#### Install sdkman 
curl -s "https://get.sdkman.io" | bash

#### Install and init config
mac_config=(nvim zsh ghostty aerospace)

for config in $mac_config; do 
  echo "Initializing $config"
  if [[ -f "$config-install.sh" && -x "$config-install.sh" ]]; then
    echo "Found $config-install.sh. Executing..."
    ./$config-install.sh
  fi
  stow -Dv $config && stow -v $config --adopt --target $HOME 
done
