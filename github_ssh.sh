#!/bin/bash

# Read .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Prompt user for GitHub username and personal access token if not set
if [ -z "$GITHUB_USER" ]; then
    echo "Enter your GitHub username: "
    read GITHUB_USER
fi

if [ -z "$GITHUB_TOKEN" ]; then
    # Open GitHub personal access tokens page
    xdg-open "https://github.com/settings/tokens/new"
    echo "Enter your GitHub personal access token: "
    read GITHUB_TOKEN
fi

KEY_PATH="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY_PATH" ]; then
    # Generate a new SSH key
    ssh-keygen -t ed25519 -C "$GITHUB_USER@$(hostname)" -f "$KEY_PATH" -N ""
    
    # Start ssh-agent and add SSH key
    eval "$(ssh-agent -s)"
    ssh-add "$KEY_PATH"
fi

# Get public key
publicKey=$(cat "$KEY_PATH.pub")

# Use GitHub API to upload public key
payload="{\"title\": \"$(hostname)-WSL\", \"key\": \"$publicKey\"}"
echo $payload

curl -u "$GITHUB_USER:$GITHUB_TOKEN" -X POST -d "$payload" -H "User-Agent: Bash" -H "Content-type: application/json" https://api.github.com/user/keys

read -p "Press Enter to exit"
