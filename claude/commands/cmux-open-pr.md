Open the current branch's pull request in cmux's built-in browser.

Steps:
1. Run `gh pr view --json url -q .url` to get the PR URL for the current branch
2. If no PR exists, tell the user
3. If cmux is available (CMUX_SOCKET_PATH env var is set and socket exists), run `cmux browser open <PR_URL>`
4. If cmux is not available, just show the URL to the user
