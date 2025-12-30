#!/bin/bash

PORT="${1:-8000}"

BIND="127.0.0.1"

python3 -m http.server "$PORT" --bind "$BIND" > /dev/null 2>&1 &

SERVER_PID=$!

URL="http://localhost:$PORT"

echo "Serving on $URL"
echo "  Press 'o' to open in browser"
echo "  Press 'q' or Ctrl+C to quit"

trap 'echo -e "\nStopping server..."; kill $SERVER_PID 2>/dev/null; exit' INT

while true; do
    read -n 1 -s key

    case "$key" in
        o|O)
            echo "Opening $URL in default browser..."
            if command -v xdg-open >/dev/null; then
                xdg-open "$URL" &
            elif command -v open >/dev/null; then
                open "$URL" &
            elif command -v start >/dev/null; then
                start "$URL" &
            else
                echo "Couldn't detect browser opener. Open $URL manually."
            fi
            ;;
        q|Q)
            echo "Quitting..."
            kill $SERVER_PID 2>/dev/null
            exit 0
            ;;
        *)
            ;;
    esac
done
