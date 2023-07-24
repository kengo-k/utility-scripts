#!/bin/bash

# Check if the necessary tools are installed
command -v gh >/dev/null 2>&1 || { echo >&2 "gh is not installed. Aborting."; exit 1; }
command -v ghq >/dev/null 2>&1 || { echo >&2 "ghq is not installed. Aborting."; exit 1; }

# Load GitHub token from file
if [[ -f "github_token" ]]; then
    GITHUB_TOKEN=$(cat github_token)
else
    echo "File 'github_token' not found. Aborting."
    exit 1
fi

# Authenticate with GitHub
gh auth login --with-token <<< $GITHUB_TOKEN

# Get a list of all repositories for the authenticated user
repos=$(gh repo list --limit 1000 --json nameWithOwner -q '.[] | .nameWithOwner')

# Clone all the repositories with ghq
for repo in $repos; do
    ghq get "github:$repo"
done
