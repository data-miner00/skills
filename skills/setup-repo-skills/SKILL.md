---
name: setup-repo-skills
description: "Set up a new repository with the required structure and configuration."
disable-model-invocation: true
---

# Setup Skills for a New Repo

Scaffold the structure and files required for the repo to be used with the engineering skills. This includes:

- **Issue tracker** — local markdown files where issues live
- **Domain docs** — where `CONTEXT.md` and ADRs live, and the consumer rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` at the repo root
- `docs/adr/` dirctory — are there any ADRs? Are they system-wide or context-specific?
- `docs/agents/` — does this skill's prior output already exist?
- `.scratch/` — sign that a local-markdown issue tracker convention is already in use

### 2. Present findings and ask

Summarise what's present and what's missing. Then take the sections in order — one section, one answer, then the next.

Lead each section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it.

**Section A — Issue tracker.** Local markdown files. Write it without asking.

The issue tracker is a markdown-oriented files & structured folder where issues are kept in this repo. Skills like `to-tickets` and `to-spec` read from and write to it — they need to write a markdown file under `.scratch/`. The issues live as files under `.scratch/<feature>/` in this repo.

**Section B — Domain docs.** — one `CONTEXT.md` + `docs/adr/` at the repo root. Write it without asking.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md` and `docs/agents/domain.md`.

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one that's already there.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Domain docs

[one-line summary of the domain]. See `docs/agents/domain.md`.
```

Then write the docs files using the seed templates in this skill folder as a starting point:

- [templates/issue-tracker.md](./templates/issue-tracker.md) — local-markdown issue tracker
- [templates/domain.md](./templates/domain.md) — domain doc consumer rules + layout

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary if they want to restart from scratch.