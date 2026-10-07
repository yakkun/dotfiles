#!/bin/bash

EVENT=$(cat)

# Cursor Agent は ~/.claude の hooks を読み込む（claude-user 互換）。
# この通知は Claude Code 専用なので、Cursor 経由では何もしない。
if [ -n "${CURSOR_VERSION:-}" ] || [ -n "${CURSOR_PROJECT_DIR:-}" ]; then
  exit 0
fi

MSG=$(echo "$EVENT" | jq -r '.last_assistant_message // "Done."' | sed 's/[\\"/]//g')
PROJECT=$(echo "$EVENT" | jq -r '.cwd // ""' | xargs basename)

TITLE="Claude Code"
if [ -n "$PROJECT" ]; then
  TITLE="Claude Code ($PROJECT)"
fi

# Cmux
if [ -n "$CMUX_SOCKET_PATH" ] && [ -S "$CMUX_SOCKET_PATH" ]; then
  cmux notify --title "$TITLE" --body "$MSG"
else
  osascript <<EOF
display notification "$MSG" with title "$TITLE" sound name "Pop"
EOF
fi
