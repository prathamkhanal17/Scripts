#!/bin/bash

# Default values
user_address="Guest@guest.com.np"
source_dir="./"
target_dir="~/"
verbose=false

# Help function
show_help() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

A wrapper script for rsync to simplify remote file synchronization.

OPTIONS:
  -a USER@ADDRESS    Specify username and address (default: Guest@guest.com.np)
  -s SOURCE_DIR      Source directory to sync from (default: ./)
  -t TARGET_DIR      Target directory to sync to (default: ~/)
  -v                 Enable verbose mode with progress display
  -h                 Show this help message

EXAMPLES:
  $(basename "$0") -a john@example.com -s ./myfiles -t ~/backup
  $(basename "$0") -a admin@192.168.1.100 -v
  $(basename "$0") -a user@server.com -s /var/www -t /backup -v

NOTES:
  - If .rsyncignore file exists in current directory, it will be used to exclude files
  - Verbose mode (-v) adds progress display and detailed output
  - Command will be printed before execution

EOF
}

# Parse command line options
while getopts "a:s:t:vh" flag; do
  case "${flag}" in
    a) user_address="${OPTARG}" ;;
    s) source_dir="${OPTARG}" ;;
    t) target_dir="${OPTARG}" ;;
    v) verbose=true ;;
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

# Display configuration
echo "Configuration:"
echo "  User@Address: $user_address"
echo "  Source Directory: $source_dir"
echo "  Target Directory: $target_dir"
echo "  Verbose: $verbose"
echo ""

# Build rsync command
if [ "$verbose" = true ]; then
  if [[ -f .rsyncignore ]]; then
    echo "Note: .rsyncignore file found and will be used"
    cmd="rsync -avz --progress --exclude-from=.rsyncignore $source_dir $user_address:$target_dir"
  else
    cmd="rsync -avz --progress $source_dir $user_address:$target_dir"
  fi
else
  if [[ -f .rsyncignore ]]; then
    echo "Note: .rsyncignore file found and will be used"
    cmd="rsync -avz --exclude-from=.rsyncignore $source_dir $user_address:$target_dir"
  else
    cmd="rsync -avz $source_dir $user_address:$target_dir"
  fi
fi

# Print and execute command
echo "Executing command:"
echo "$cmd"
echo ""
eval "$cmd"
