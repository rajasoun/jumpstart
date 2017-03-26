#!/usr/bin/env sh

# Set colors
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

printf "${GREEN}----${NC}"

echo

# Set user email
read -p "Set your email adress: " email
git config --local user.email $email
printf "${CYAN}User email was set.${NC}"


echo
echo

# Connect .gitconfig
git config --local include.path '../.gitconfig'
printf "${GREEN}Git config was successfully set.${NC}"
echo
printf "${GREEN}----${NC}"
