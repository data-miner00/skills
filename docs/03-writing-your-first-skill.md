# 03 — Writing Your First Skill: `hello-world`

This walks through the actual `hello-world` skill in this repo (`skills/hello-world/SKILL.md`), so
you can follow along against a real file instead of a toy snippet.

## Step 1 — decide the trigger

`hello-world` is deliberately boring: a skill you only want to run when *you* explicitly ask for
it, never automatically. That maps to `disable-model-invocation: true`.

## Step 2 — create the folder

```
skills/hello-world/SKILL.md
```

The folder name (`hello-world`) becomes the command name (`/hello-world`) — they must match.

## Step 3 — write the frontmatter

```yaml
---
name: hello-world
description: Greet the user and briefly explain what this skills library is, for onboarding.
disable-model-invocation: true
---
```

Even though this skill is user-only, the `description` still matters — it's what shows up in
`/help` so future-you remembers what it does.

## Step 4 — write the body

Keep it short; this is a teaching example, not a real workflow:

```markdown
Greet the user warmly. Briefly explain that this is their personal Claude Code
skills library, point them at `docs/00-overview.md` if they want the full
picture, and ask what they'd like to build next.
```

## Step 5 — try it

Once `~/.claude/skills` is linked to this repo (see
[01-locations-and-discovery.md](01-locations-and-discovery.md)) and you start a fresh session,
`/hello-world` should appear in `/help`, and typing it should run the body above.

## What to change for a *real* skill

`hello-world` skips the parts that matter for anything you'd actually use daily:

1. **A trigger-worthy description.** If you want auto-invocation, the description needs concrete
   keywords and scenarios — "greet the user" would never fire on its own; nothing in a normal
   conversation matches it. Compare against `commit-message-helper`
   (`skills/commit-message-helper/SKILL.md`) which lists specific situations.
2. **A real procedure**, not one sentence — the actual steps Claude should take, in order,
   including what to check and what "done" looks like.
3. **Supporting files**, if the procedure needs deep reference material or deterministic scripts —
   see [02-anatomy-of-a-skill.md](02-anatomy-of-a-skill.md#progressive-disclosure-supporting-files)
   and the worked example in `skills/commit-message-helper/`.

## Next

[04-best-practices.md](04-best-practices.md) covers the authoring guidance that separates a skill
Claude reliably uses correctly from one it ignores or misuses.
