#!/usr/bin/env bash
# Git status monitor for cockpit bottom-right pane
# Displays branch, status, and diff stats with colors

set -euo pipefail

readonly RESET='\033[0m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly GREEN='\033[32m'
readonly RED='\033[31m'
readonly YELLOW='\033[33m'
readonly CYAN='\033[36m'
readonly MAGENTA='\033[35m'
readonly EL='\033[K'

interval="${1:-1}"

# Hide cursor and ensure it's restored on exit
tput civis
trap 'tput cnorm; exit' INT TERM EXIT
tput clear

render() {
  local buf=""

  # Check if inside a git repo
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    buf+="${RED}Not a git repository${EL}${RESET}\n"
    echo -en "$buf"
    return
  fi

  # ── Branch & HEAD ──
  local branch
  branch=$(git branch --show-current 2>/dev/null)
  if [[ -z "$branch" ]]; then
    branch="(detached: $(git rev-parse --short HEAD))"
  fi
  local commit_msg
  commit_msg=$(git log -1 --format='%s' 2>/dev/null || echo '')
  buf+="${BOLD}${CYAN} ${branch}${RESET} ${DIM}${commit_msg}${EL}${RESET}\n"

  # ── Upstream status ──
  local upstream
  upstream=$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || echo '')
  if [[ -n "$upstream" ]]; then
    local ahead behind
    ahead=$(git rev-list --count '@{upstream}..HEAD' 2>/dev/null || echo 0)
    behind=$(git rev-list --count 'HEAD..@{upstream}' 2>/dev/null || echo 0)
    local sync=""
    [[ "$ahead" -gt 0 ]] && sync+="${GREEN}↑${ahead}${RESET} "
    [[ "$behind" -gt 0 ]] && sync+="${RED}↓${behind}${RESET} "
    [[ -z "$sync" ]] && sync="${DIM}in sync${RESET}"
    buf+="  ${DIM}↔ ${upstream}${RESET}  ${sync}${EL}\n"
  fi

  buf+="${EL}\n"

  # ── Diff stats (staged + unstaged) ──
  local staged_add=0 staged_del=0 unstaged_add=0 unstaged_del=0
  while IFS=$'\t' read -r add del _; do
    [[ "$add" == "-" ]] && continue
    staged_add=$((staged_add + add))
    staged_del=$((staged_del + del))
  done < <(git diff --cached --numstat 2>/dev/null)

  while IFS=$'\t' read -r add del _; do
    [[ "$add" == "-" ]] && continue
    unstaged_add=$((unstaged_add + add))
    unstaged_del=$((unstaged_del + del))
  done < <(git diff --numstat 2>/dev/null)

  local total_add=$((staged_add + unstaged_add))
  local total_del=$((staged_del + unstaged_del))

  if [[ $total_add -gt 0 || $total_del -gt 0 ]]; then
    buf+="${BOLD}Modified:${RESET} ${GREEN}+${total_add}${RESET} ${RED}-${total_del}${RESET} ${DIM}(staged ${GREEN}+${staged_add}${RESET}${DIM} ${RED}-${staged_del}${RESET}${DIM})${EL}${RESET}\n"
  fi

  buf+="${EL}\n"

  # ── File status ──
  local status_output
  status_output=$(git status -s 2>/dev/null)
  if [[ -z "$status_output" ]]; then
    buf+="${DIM}Clean working tree${EL}${RESET}\n"
  else
    while IFS= read -r line; do
      local idx="${line:0:1}"
      local wt="${line:1:1}"
      local file="${line:3}"
      local color="$RESET"
      if [[ "$idx" == "?" ]]; then
        color="$DIM"
      elif [[ "$idx" != " " ]]; then
        color="$GREEN"
      fi
      if [[ "$wt" == "M" || "$wt" == "D" ]]; then
        color="$YELLOW"
      fi
      buf+="${color}${idx}${wt}${RESET} ${file}${EL}\n"
    done <<<"$status_output"
  fi

  # Move cursor to top-left, print buffer, clear remaining lines
  tput home
  echo -en "$buf"
  tput ed
}

while true; do
  render
  sleep "$interval"
done
