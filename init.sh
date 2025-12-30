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
  cat > .gitignore << 'EOF'
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
Desktop.ini

.vscode/
.idea/
*.swp
*.swo
*~
.project
.classpath
.settings/
*.sublime-project
*.sublime-workspace
.history/

.env
.env.local
.env.development.local
.env.test.local
.env.production.local
*.env

logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules/
npm-debug.log
yarn.lock
package-lock.json
.pnp
.pnp.js
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz

build/
dist/
.next/
out/
.cache/
.parcel-cache/
.vite/

coverage/
.nyc_output/
*.test.js.snap
.jest/

__pycache__/
*.py[cod]
*$py.class
*.so
.Python
pip-log.txt
pip-delete-this-directory.txt
.venv/
venv/
ENV/
env/
.env
pythonenv*

*.log
local_settings.py
db.sqlite3
db.sqlite3-journal
media/
staticfiles/
static_root/
/static/
*.pot

celerybeat-schedule
celerybeat.pid

build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

*.manifest
*.spec

htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

.ipynb_checkpoints
*.ipynb

.python-version

poetry.lock

tailwind.config.js.backup

*.tmp
*.temp
*.bak
*.swp
*.swo
*~

*.com
*.class
*.dll
*.exe
*.o
*.so

*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

*.sql
*.sqlite
*.db

secrets.json
*.pem
*.key
*.cert
*.crt
id_rsa*
*.ppk

.aws/

docker-compose.override.yml
.dockerignore

.cache/
*.pid
*.seed
*.log
EOF
  echo "Created .gitignore file"
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
