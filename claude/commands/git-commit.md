# Commit Changes

Please create a git commit for the current changes.

## Arguments

- `$ARGUMENTS`: Optional. Specify `ja` or `japanese` to write the commit message in Japanese. Default is English.

## Instructions

1. Run `git status` and `git diff --staged` to understand staged changes
2. If there are no staged changes, run `git diff` to see unstaged changes and ask the user which files to stage
3. Run `git log --oneline -5` to understand the commit message style used in this repository
4. Analyze all changes and draft a concise, descriptive commit message (in Japanese if `$ARGUMENTS` is `ja` or `japanese`, otherwise in English) that:
   - Summarizes the nature of the changes (new feature, bug fix, refactoring, etc.)
   - **Must include the reason "why" this change is being made** - this is more important than "what" changed
   - If the reason is unclear from the code or context, **ask the user** why this change is needed before creating the commit
   - Follows the repository's existing commit message conventions
5. Create the commit with the message ending with the standard Claude Code footer:

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

6. Show the result of `git log -1` to confirm the commit was created successfully

## Important

- Do NOT push to remote unless explicitly asked
- Write commit messages in English by default, or in Japanese if `$ARGUMENTS` is `ja` or `japanese`
- If pre-commit hooks modify files, amend the commit appropriately
