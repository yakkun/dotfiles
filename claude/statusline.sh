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
    if [ "$1" -lt 50 ]; then   printf '%b' "$GREEN"
    elif [ "$1" -lt 80 ]; then printf '%b' "$YELLOW"
    else                       printf '%b' "$RED"
    fi
}

# Format seconds until an epoch time: "3d", "1h20m", "40m"
fmt_until() {
    local s=$(( $1 - $(date +%s) ))
    [ "$s" -lt 0 ] && s=0
    if   [ "$s" -ge 86400 ]; then printf '%dd' $(( s / 86400 ))
    elif [ "$s" -ge 3600 ];  then printf '%dh%02dm' $(( s / 3600 )) $(( s % 3600 / 60 ))
    else                          printf '%dm' $(( s / 60 ))
    fi
}

# Rate limit segment: "5h 72% ↻1h20m"
fmt_rate() {
    local label=$1 pct=$2 resets=$3
    [ -z "$pct" ] && return
    pct=$(printf '%.0f' "$pct")
    printf '  %s %b%d%%%b' "$label" "$(pct_color "$pct")" "$pct" "$RESET"
    [ -n "$resets" ] && printf ' %b↻%s%b' "$DIM" "$(fmt_until "$resets")" "$RESET"
    return 0
}

# ---------------------------------------------------------------------------
# Extract all values from JSON in one jq call
# ---------------------------------------------------------------------------
eval "$(echo "$input" | jq -r '
    @sh "DIR=\(.workspace.current_dir)",
    @sh "MODEL=\(.model.display_name // .model.id // "???")",
    @sh "EFFORT=\(.effort.level // "")",
    @sh "CTX_PCT=\(.context_window.used_percentage // "")",
    @sh "PR_NUM=\(.pr.number // "")",
    @sh "PR_URL=\(.pr.url // "")",
    @sh "PR_STATE=\(.pr.review_state // "")",
    @sh "RATE_5H=\(.rate_limits.five_hour.used_percentage // "")",
    @sh "RESET_5H=\(.rate_limits.five_hour.resets_at // "")",
    @sh "RATE_7D=\(.rate_limits.seven_day.used_percentage // "")",
    @sh "RESET_7D=\(.rate_limits.seven_day.resets_at // "")"
')"

# ---------------------------------------------------------------------------
# Directory + Git branch + PR
# ---------------------------------------------------------------------------
location="${BOLD}${BLUE}${DIR##*/}${RESET}"

branch=$(git -C "$DIR" branch --show-current 2>/dev/null || true)
[ -n "$branch" ] && location+="${DIM}@${RESET}${BLUE}${branch}${RESET}"

if [ -n "$PR_NUM" ]; then
    case "$PR_STATE" in
        approved)          pr_mark="${GREEN}✓" ;;
        changes_requested) pr_mark="${RED}✗" ;;
        pending)           pr_mark="${YELLOW}●" ;;
        draft)             pr_mark="${DIM}◌" ;;
        *)                 pr_mark="" ;;
    esac
    # OSC 8 hyperlink so the PR number is clickable
    location+=" \033]8;;${PR_URL}\a${CYAN}#${PR_NUM}${RESET}\033]8;;\a${pr_mark}${RESET}"
fi

# ---------------------------------------------------------------------------
# Model (+ effort)
# ---------------------------------------------------------------------------
model="${CYAN}${MODEL}${RESET}"
[ -n "$EFFORT" ] && model+=" ${DIM}(${EFFORT})${RESET}"

# ---------------------------------------------------------------------------
# Context window usage
# ---------------------------------------------------------------------------
if [ -n "$CTX_PCT" ]; then
    CTX_PCT=$(printf '%.0f' "$CTX_PCT")
    ctx="ctx $(pct_color "$CTX_PCT")${CTX_PCT}%${RESET}"
else
    ctx="${DIM}ctx --%${RESET}"
fi

# ---------------------------------------------------------------------------
# Rate limits (5h / 7d); absent on API billing or before the first response
# ---------------------------------------------------------------------------
rate="$(fmt_rate 5h "$RATE_5H" "$RESET_5H")$(fmt_rate 7d "$RATE_7D" "$RESET_7D")"

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
echo -e "${location}  ${model}  ${ctx}${rate}"
