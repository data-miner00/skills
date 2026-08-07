# Conventional Commits — Type Reference

Format: `type(scope): summary`. `(scope)` is optional — omit it if the change isn't
localized to one component.

| Type | When to use it |
|---|---|
| `feat` | A new capability or behavior visible to users of the code |
| `fix` | A bug fix — behavior was wrong, now it's correct |
| `docs` | Documentation only — no code behavior changes |
| `refactor` | Code restructuring with no behavior change (not a fix, not a feature) |
| `test` | Adding or correcting tests only |
| `chore` | Tooling, build config, dependency bumps — nothing shipped to users |

## Summary line rules

- Imperative mood: "add", "fix", "remove" — not "added", "fixes", "removing".
- No trailing period.
- Aim for ≤72 characters so it doesn't wrap in `git log --oneline`.
- Don't restate the diff ("change function"); say what changed in effect
  ("fix off-by-one in pagination").

## Body (optional)

Only add a body when the summary line can't carry the necessary context —
typically to explain *why* a non-obvious change was made, not to re-describe
the diff line by line. Wrap at ~72 columns. Separate from the summary with one
blank line.

## Breaking changes

Append `!` after the type/scope (`feat!:` or `feat(api)!:`) and explain the
break in the body, prefixed `BREAKING CHANGE:`.
