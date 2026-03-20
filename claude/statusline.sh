#!/usr/bin/env bash

set -euo pipefail

input=$(cat)

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Color a percentage value: green < 50, yellow 50-79, red >= 80
pct_color() {
    local pct=${1:-0}
    if [ "$pct" -lt 50 ]; then   printf '%b' "$GREEN"
    elif [ "$pct" -lt 80 ]; then printf '%b' "$YELLOW"
    else                         printf '%b' "$RED"
    fi
}

# Format token counts: 1234567 -> "1.2m", 45000 -> "45.0k", 800 -> "800"
fmt_tokens() {
    local n=$1
    if   [ "$n" -ge 1000000 ]; then printf "%.1fm" "$(echo "scale=1; $n / 1000000" | bc)"
    elif [ "$n" -ge 1000 ];    then printf "%.1fk" "$(echo "scale=1; $n / 1000" | bc)"
    else                             printf "%d" "$n"
    fi
}

# ---------------------------------------------------------------------------
# Extract all values from JSON in one jq call
# ---------------------------------------------------------------------------
eval "$(echo "$input" | jq -r '
    @sh "DIR=\(.workspace.current_dir)",
    @sh "MODEL=\(.model.display_name // .model.id // "???")",
    @sh "CTX_SIZE=\(.context_window.context_window_size // 0)",
    @sh "IN_TOKENS=\(.context_window.total_input_tokens // 0)",
    @sh "OUT_TOKENS=\(.context_window.total_output_tokens // 0)",
    @sh "USAGE_INPUT=\(.context_window.current_usage.input_tokens // 0)",
    @sh "USAGE_CACHE_W=\(.context_window.current_usage.cache_creation_input_tokens // 0)",
    @sh "USAGE_CACHE_R=\(.context_window.current_usage.cache_read_input_tokens // 0)",
    @sh "RATE_5H=\(.rate_limits.five_hour.used_percentage // "")",
    @sh "RATE_7D=\(.rate_limits.seven_day.used_percentage // "")",
    @sh "COST=\(.cost.total_cost_usd // 0)"
')"

# ---------------------------------------------------------------------------
# Directory + Git branch
# ---------------------------------------------------------------------------
dir_name="${BOLD}${BLUE}${DIR##*/}${RESET}"

git_branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    [[ -n "$branch" ]] && git_branch="${DIM}@${RESET}${BLUE}${branch}${RESET}"
fi

# ---------------------------------------------------------------------------
# Model
# ---------------------------------------------------------------------------
model_display="${CYAN}${MODEL}${RESET}"

# ---------------------------------------------------------------------------
# Context window usage
# ---------------------------------------------------------------------------
if [ "$CTX_SIZE" -gt 0 ]; then
    current=$((USAGE_INPUT + USAGE_CACHE_W + USAGE_CACHE_R))
    pct=$((current * 100 / CTX_SIZE))
    ctx_display="$(pct_color "$pct")${pct}%${RESET}"
else
    ctx_display="${DIM}--%${RESET}"
fi

# ---------------------------------------------------------------------------
# Tokens (in / out)
# ---------------------------------------------------------------------------
if [ "$IN_TOKENS" != "0" ] || [ "$OUT_TOKENS" != "0" ]; then
    tokens_display="${YELLOW}in:$(fmt_tokens "$IN_TOKENS") out:$(fmt_tokens "$OUT_TOKENS")${RESET}"
else
    tokens_display="${DIM}in:--- out:---${RESET}"
fi

# ---------------------------------------------------------------------------
# Rate limits (5h / 7d)
# ---------------------------------------------------------------------------
if [ -n "$RATE_5H" ] && [ -n "$RATE_7D" ]; then
    rate_display="5h:$(pct_color "$RATE_5H")${RATE_5H}%${RESET} 7d:$(pct_color "$RATE_7D")${RATE_7D}%${RESET}"
else
    rate_display="${DIM}5h:--% 7d:--%${RESET}"
fi

# ---------------------------------------------------------------------------
# Cost
# ---------------------------------------------------------------------------
if [ "$COST" != "0" ] && [ "$COST" != "null" ]; then
    cost_display="${GREEN}$(printf '$%.2f' "$COST")${RESET}"
else
    cost_display="${DIM}\$--${RESET}"
fi

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
echo -e "${dir_name}${git_branch} ${model_display} ${ctx_display} ${tokens_display} ${rate_display} ${cost_display}"
