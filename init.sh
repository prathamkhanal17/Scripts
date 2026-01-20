#!/bin/bash

remote_url=""

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]
Initialize a git repository with optional remote.

OPTIONS:
  -r REMOTE_URL Add remote origin URL
  -h            Show this help message

EXAMPLES:
  $(basename "$0")
  $(basename "$0") -r git@github.com:user/repo.git
  $(basename "$0") -r https://github.com/user/repo.git
EOF
}

while getopts "r:h" flag; do
    case "${flag}" in
        r) remote_url="${OPTARG}" ;;
        h)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

if [[ -d .git ]]; then
    echo "Git repository already initialized in $(pwd)"
    exit 0
fi

echo "Initializing Git repository..."
git init . || { echo "Failed to initialize git repo"; exit 1; }

if [[ ! -f .gitignore ]]; then
    script_dir=$(dirname "$(readlink -f "$0")")
    cp "$script_dir/.gitignore" . || { echo "Failed to copy .gitignore"; exit 1; }
    echo "Copied .gitignore file"
fi

echo "Adding files..."
git add . || { echo "Failed to add files"; exit 1; }

echo "Creating initial commit..."
git commit -m "Initial Commit" || { echo "Failed to commit"; exit 1; }

echo "Renaming branch to main..."
git branch -M main || { echo "Failed to rename branch"; exit 1; }

if [[ -n "$remote_url" ]]; then
    echo "Adding remote origin: $remote_url"
    git remote add origin "$remote_url" || { echo "Failed to add remote"; exit 1; }
    echo "Remote added successfully!"
fi

echo "Git repository initialized successfully!"

if [[ -n "$remote_url" ]]; then
    while true; do
        read -p "Push to origin main? [Y/n] " answer
        answer=${answer:-y}

        case "$answer" in
            [Yy]* | [Yy][Ee][Ss]* )
                echo "Pushing to origin main..."
                git push -u origin main || { echo "Push failed!"; exit 1; }
                echo "Successfully pushed to origin main!"
                break
                ;;
            [Nn]* | [Nn][Oo]* )
                echo "Skipping push."
                break
                ;;
            *)
                echo "Please answer y, yes, n, or no."
                ;;
        esac
    done
else
    echo "No remote URL provided, skipping push step."
fi
