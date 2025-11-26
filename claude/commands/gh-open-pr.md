# Open Pull Request

Please create a GitHub Pull Request for the current branch.

## Arguments

- `$ARGUMENTS`: Optional. Specify `ja` or `japanese` to write the PR title and description in Japanese. Default is English.

## Instructions

1. Run `git status` to check if the current branch has uncommitted changes
   - If there are uncommitted changes, ask the user whether to commit them first or proceed without them
2. Run `git branch --show-current` to get the current branch name
3. Check if the current branch tracks a remote branch and if it's up to date:
   - Run `git status -sb` to check tracking status
   - If not pushed to remote or behind, push with `git push -u origin <branch-name>`
4. Run `git log main..HEAD --oneline` (or appropriate base branch) to understand all commits in this branch
5. Run `git diff main...HEAD` to see all changes that will be included in the PR
6. Analyze all changes and commits, then draft a PR title and description (in Japanese if `$ARGUMENTS` is `ja` or `japanese`, otherwise in English) that:
   - **Title**: Concise summary of the changes
   - **Problem / User Story**: The problem this PR solves or the user story (2-3 bullet points)
   - **Changes**: Bullet points explaining what was changed
   - **Test plan**: Bullet points for verification steps
   - Keep all sections simple and use bullet points extensively
   - For Japanese, use noun endings (体言止め) for conciseness
   - If the reason for changes is unclear, **ask the user** before creating the PR
7. Create the PR using `gh pr create` with the following format:

```
gh pr create --title "PR title" --body "$(cat <<'EOF'
## Problem / User Story
- <bullet point 1>
- <bullet point 2>

## Changes
- <change 1>
- <change 2>

## Test plan
- <step 1>
- <step 2>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

8. Return the PR URL to the user

## Important

- Push to remote if not already pushed (this is required to create a PR)
- Write PR title and description in English by default, or in Japanese if `$ARGUMENTS` is `ja` or `japanese`
- Always include both Summary and Test plan sections
- If the base branch is not `main`, detect and use the appropriate base branch
