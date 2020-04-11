#!/usr/bin/env zsh

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Setting up Github SSH key pairs."
echo "Please enter your github email."
read github_email
ssh-keygen -t rsa -b 4096 -C $github_email

fancy_echo "Starting ssh-agent in the background."
eval "$(ssh-agent -s)"

fancy_echo "Adding your SSH key to ssh-agent."
ssh-add ~/.ssh/id_rsa

fancy_echo "Copying SSH key to your clipboard."
pbcopy < ~/.ssh/id_rsa.pub

fancy_echo "Add key to github to finish setup."
echo "Press enter to open instructions."
read throwaway_input
open https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
open https://github.com/settings/keys