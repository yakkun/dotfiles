Open the current repository's GitHub page in cmux's built-in browser.

Steps:
1. Run `gh repo view --json url -q .url` to get the repository URL
2. If not a git repo or no remote, tell the user
3. If cmux is available (CMUX_SOCKET_PATH env var is set and socket exists), run `cmux browser open <REPO_URL>`
4. If cmux is not available, just show the URL to the user
