---
name: commit-message-helper
description: Drafts or checks a git commit message against Conventional Commits style. Use when the user asks for help writing a commit message, wants a commit message reviewed, or asks "what should I use for this commit message".
---

Draft or validate a git commit message in Conventional Commits style
(`type(scope): summary`).

1. If the user hasn't shown you the change, run `git diff --staged` (or
   `git diff` if nothing is staged) to see what's actually changing — don't
   guess the type/scope from conversation alone.
2. Pick a `type` from: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`. For
   the full list of types and when each applies, see
   [references/conventional-commits.md](references/conventional-commits.md).
3. Draft a one-line summary: imperative mood, no trailing period, ideally
   under 72 characters.
4. Validate the draft by running:
   ```
   python scripts/check_message.py "<candidate message>"
   ```
   Fix anything it flags before presenting the message to the user.
5. Present the final message. If the change is large enough to need a body,
   add it after a blank line, wrapped at ~72 columns, explaining *why* not
   *what*.
