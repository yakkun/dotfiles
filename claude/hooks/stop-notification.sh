#!/bin/bash
INPUT=$(cat)
MSG=$(echo "$INPUT" | jq -r '.last_assistant_message // "Done."' | sed 's/[\\"/]/ /g')
PROJECT=$(echo "$INPUT" | jq -r '.cwd // ""' | xargs basename)

TITLE="Claude Code"
if [ -n "$PROJECT" ]; then
  TITLE="Claude Code ($PROJECT)"
fi

osascript <<EOF
display notification "$MSG" with title "$TITLE" sound name "Pop"
EOF
exit 0
