---
name: capturing-learnings
description: Scan this session's tool calls, scripts, and commands for reusable learnings, let the user pick which ones are worth keeping via a checklist, then distill the selected ones into notes appended to the active feature folder's learnings.md or docs/learnings.md.
disable-model-invocation: true
---

Scan this session for reusable things — commands, scripts, flags, reasoning approaches — and let
the user choose which are worth keeping before writing anything. Never distill or write an entry
the user didn't select. This is a personal knowledge base, not a session recap.

## 1. Scan

Look back through this session's tool calls, script creations, and command executions (e.g. a
`git log --oneline` trick, an unusual flag combo, a one-off script, a debugging approach that
paid off) for ones that were genuinely novel or reusable — the kind of thing a future session
would want to reach for again. Skip routine housekeeping (ordinary Read/Edit/Grep calls, routine
edits) and anything that's just "what we did" — that belongs in the commit or PR, not here.

Compile a candidate list, one line each: what it was and why it might be worth keeping. If the
user already pointed at something specific, include it as a candidate too rather than skipping
straight to writing it. If nothing stands out, say so and stop — don't force a checklist out of
routine work.

## 2. Checklist

Present the candidates with `AskUserQuestion` as a multiSelect checklist — one option per
candidate, label a short title, description the one-line "what and why". Only candidates the user
selects move to the next step. If the user selects none, stop here without writing anything.

## 3. Distill (per selected entry)

For each selected candidate, write a short, self-contained note — specific enough to reuse
without the original conversation. Capture the generalizable point (a flag, a trick, a way of
reasoning about a problem), not what got done on this task.

- **Command or script** — pull the exact invocation as it was actually run this session (not a
  cleaned-up generic form) into a code block, then add a brief elaboration underneath explaining
  what it does and when to reach for it again.
- **Reasoning approach** — no code block; give a short worked example of how to apply it instead.

## 4. Place it

- **Feature work** — a `.scratch/<feature-slug>/` folder was read or written this session: append
  to that feature's `.scratch/<feature-slug>/learnings.md`. Multiple feature folders touched this
  session → use whichever the current discussion belongs to.
- **Casual session** — no feature folder in play: append to `docs/learnings.md` at the repo root.
- **Unsure which** — ask; don't default silently.

Either way it's one running file, append-only — never split into per-topic files.

## 5. Write

Append, don't overwrite — one block per selected entry, in the order they were selected.

For a command or script:

````markdown
## <short title> — YYYY-MM-DD

<1-2 sentences: what it is and why it's useful.>

```<language-or-shell>
<the exact command/script as applied this session>
```

<1-2 sentence elaboration: what that code block does and when to reach for it again.>
````

For a reasoning approach (no code block):

```markdown
## <short title> — YYYY-MM-DD

<1-3 sentences: what it is, why it's useful, and a worked example of applying it —
specific enough to reuse without the original conversation.>
```

Create the file with just these entries if it doesn't exist yet.

## 6. Confirm

Show the user the path and the full entry text for each note written.
