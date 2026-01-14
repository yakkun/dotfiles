#!/usr/bin/env bash

set -euo pipefail

input=$(cat)

# ANSI color codes
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'

CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Model name
MODEL=$(echo "$input" | jq -r '.model.display_name // .model.id // "???"')

# Total tokens (in/out) - format as "15k/4k"
format_tokens() {
    local tokens=$1
    if [ "$tokens" -ge 1000000 ]; then
        printf "%.1fm" "$(echo "scale=1; $tokens / 1000000" | bc)"
    elif [ "$tokens" -ge 1000 ]; then
        printf "%.1fk" "$(echo "scale=1; $tokens / 1000" | bc)"
    else
        printf "%d" "$tokens"
    fi
}

TOTAL_INPUT=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
TOTAL_OUTPUT=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
if [ "$TOTAL_INPUT" != "0" ] || [ "$TOTAL_OUTPUT" != "0" ]; then
    TOKENS_INFO="in:$(format_tokens "$TOTAL_INPUT") out:$(format_tokens "$TOTAL_OUTPUT")"
else
    TOKENS_INFO="in:--- out:---"
fi

# Context window usage (with dynamic color based on usage)
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
USAGE=$(echo "$input" | jq -r '.context_window.current_usage // empty')

if [ -n "$USAGE" ] && [ "$CONTEXT_SIZE" -gt 0 ]; then
    CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
    # Dynamic color: green < 50%, yellow 50-80%, red > 80%
    if [ "$PERCENT_USED" -lt 50 ]; then
        CONTEXT_COLOR="$GREEN"
    elif [ "$PERCENT_USED" -lt 80 ]; then
        CONTEXT_COLOR="$YELLOW"
    else
        CONTEXT_COLOR="$RED"
    fi
    CONTEXT_INFO="${CONTEXT_COLOR}${PERCENT_USED}%${RESET}"
else
    CONTEXT_INFO='--%'
fi

# Cost
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
if [ "$COST" != "0" ] && [ "$COST" != "null" ]; then
    COST_INFO=$(printf '$%.2f' "$COST")
else
    COST_INFO='$--'
fi

# Git branch
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH="${BLUE}@$BRANCH${RESET}"
    fi
fi

# Output with colors and emojis
DIR_NAME="${BOLD}${BLUE}${CURRENT_DIR##*/}${RESET}"
MODEL_INFO="${CYAN}${MODEL}${RESET}"
CONTEXT_DISPLAY="🧠${CONTEXT_INFO}"
TOKENS_DISPLAY="${YELLOW}${TOKENS_INFO}${RESET}"
COST_DISPLAY="${GREEN}${COST_INFO}${RESET}"

echo -e "${DIR_NAME}${GIT_BRANCH} ${MODEL_INFO} ${CONTEXT_DISPLAY} ${TOKENS_DISPLAY} ${COST_DISPLAY}"
