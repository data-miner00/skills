---
name: pr-description
description: Drafts or updates a pull request title and description from the current branch's commits, diff, and originating spec/ticket. Use when the user asks to write a PR description, draft a PR title, open a PR, or asks what a PR should say.
---

Draft (or update) a PR title and body for the current branch. Drafting is always safe to do
automatically; **never run `gh pr create` or `gh pr edit` without the user first confirming the
exact title and body** — that's the same visible/shared-state bar as any other PR-creation action.

## Process

### 1. Pin base and head

`head` is the current branch (`git branch --show-current`). `base` is whatever the user says,
otherwise the repo's default branch (`gh repo view --json defaultBranchRef -q .defaultBranchRef.name`,
falling back to `main`/`master` via `git symbolic-ref refs/remotes/origin/HEAD` if `gh` isn't
available).

### 2. Check for an existing PR

Run `gh pr view --json number,title,body,url 2>/dev/null`. If one exists for this branch, this is
an **update**: show the current title/body before drafting revisions, and later use `gh pr edit`
instead of `gh pr create`. If `gh` isn't installed or authenticated, skip straight to drafting —
present the text and stop; don't ask the user to install anything.

### 3. Gather the change

- Commits: `git log <base>..HEAD --oneline`
- Diff: `git diff <base>...HEAD --stat` (three-dot, against the merge-base — same convention as
  `/code-review`)

Read enough of the actual diff to describe the change accurately — the stat alone isn't enough to
write the Summary.

### 4. Find the spec or ticket

Same lookup `/code-review` does: a spec file under `docs/`, `specs/`, or `.scratch/` matching the
branch name or feature; otherwise consult `docs/agents/issue-tracker.md` if present (run
`/setup-repo-skills` if it's missing and the user wants one). If nothing turns up, ask the user
once — if they say there isn't one, draft from the diff alone and omit the Related section.

### 5. Draft

**Title** — Conventional-Commits style (`type(scope): summary`), imperative mood, no trailing
period, under ~70 characters. See `/commit-message-helper` for the type list if it's not obvious
from the diff.

**Body**:

<pr-body-template>

## Summary

1-3 bullets on *why* this change, from the reader's perspective — not a restatement of the diff.

## Changes

Bulleted list of what actually changed, grouped by area if the diff touches several.

## Test plan

Checklist of how this was or should be verified (tests added/run, manual steps, edge cases).

## Related

Link or reference to the spec/ticket found in step 4, formatted per this repo's issue-tracker
convention (a path for local-markdown tracking, `Closes #N` for GitHub Issues, etc). Omit this
section entirely if step 4 found nothing.

</pr-body-template>

### 6. Present, then act only on confirmation

Show the drafted title and body and ask if it's ready. Once the user confirms:

- If the branch has no upstream or is behind, push it (`git push -u origin <branch>`).
- Create (`gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"`) or update
  (`gh pr edit <number> --title "..." --body "..."`) accordingly, using a heredoc for the body so
  formatting survives.
- Return the PR URL.

If the user only wanted the text (no `gh` action requested), stop after presenting the draft.
