---
name: capturing-learnings
description: Distill a reusable tool, command, or reasoning approach from this session into a learning note, appended to the active feature folder's learnings.md or docs/learnings.md.
disable-model-invocation: true
---

Distill one reusable thing from this session into a short, standing note — a personal knowledge
base entry, not a session recap. Capture the generalizable point (a flag, a trick, a way of
reasoning about a problem), not what got done on this task.

## 1. Distill

Use what the user pointed at, or scan the recent conversation for what was genuinely novel to
them. Skip anything that's just "what we did" — that belongs in the commit or PR, not here. One
entry per distinct learning, each self-contained enough to reuse without the original
conversation. If you inferred the entry rather than being told it directly, confirm it with the
user before writing.

## 2. Place it

- **Feature work** — a `.scratch/<feature-slug>/` folder was read or written this session: append
  to that feature's `.scratch/<feature-slug>/learnings.md`. Multiple feature folders touched this
  session → use whichever the current discussion belongs to.
- **Casual session** — no feature folder in play: append to `docs/learnings.md` at the repo root.
- **Unsure which** — ask; don't default silently.

Either way it's one running file, append-only — never split into per-topic files.

## 3. Write

Append, don't overwrite:

```markdown
## <short title> — YYYY-MM-DD

<1-3 sentences: what it is, why it's useful, and the exact command/flag/reasoning shape —
specific enough to reuse verbatim later.>
```

Create the file with just this entry if it doesn't exist yet.

## 4. Confirm

Show the user the path and the entry text.
