#!/bin/bash

EVENT=$(cat)
MSG=$(echo "$EVENT" | jq -r '.last_assistant_message // "Agent finished."' | sed 's/[\\"/]/ /g')
PROJECT=$(echo "$EVENT" | jq -r '.cwd // ""' | xargs basename)
TOOL=$(echo "$EVENT" | jq -r '.tool_name // ""')

TITLE="Claude Code"
if [ -n "$PROJECT" ]; then
  TITLE="Claude Code ($PROJECT)"
fi

# Cmux
if [ -n "$CMUX_SOCKET_PATH" ] && [ -S "$CMUX_SOCKET_PATH" ]; then
  [ "$TOOL" = "Task" ] && cmux notify --title "$TITLE" --body "$MSG"
fi
