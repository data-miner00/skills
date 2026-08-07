# 01 — Where Skills Live, and How This Repo Plugs In

## Discovery locations

Claude Code looks for skills in a fixed set of places — there is no setting to point discovery at
an arbitrary path:

| Location | Scope | Notes |
|---|---|---|
| `~/.claude/skills/<name>/SKILL.md` | **Personal** — every project, every session | This is your global toolbox |
| `.claude/skills/<name>/SKILL.md` | **Project** — only inside that repo | Committed to the project's own git history, shared with collaborators on that repo |
| A parent directory's `.claude/skills/` up to the git root | Hierarchical project scope | Useful in monorepos |
| A plugin's bundled `skills/` directory | Plugin scope | Namespaced as `/plugin-name:skill-name` |

Directory-scoped/monorepo skills can be referenced with a path prefix, e.g. `apps/web:deploy`, when
more than one skill shares a name across different scopes — Claude Code disambiguates by showing
the more specific one for files under that path.

## The problem this repo solves

You want your skills:
- **version controlled**, with real git history, on a drive/path of your choosing (`D:\Workspace\projects\skills`)
- **usable from every project**, i.e. discovered from `~/.claude/skills/`

Those two requirements don't both point at the same folder by default — `~/.claude/skills/` is
fixed by Claude Code, but your repo lives on `D:`. The fix is a **directory link**: make
`~/.claude/skills/` *be* this repo's `skills/` folder, without physically moving anything.

## Why a junction, not a symlink

Windows has two relevant link types for directories:

- **Symbolic link** (`New-Item -ItemType SymbolicLink`) — needs Administrator rights or Developer
  Mode enabled.
- **Directory junction** (`New-Item -ItemType Junction`, or `mklink /J` in `cmd`) — works for any
  user, no special privileges, and — importantly — **works across drives** (`C:` → `D:`), which a
  plain NTFS symlink also technically supports but junctions are the conventional, permission-free
  choice for this exact "link a folder on another drive into place" use case.

This repo uses a junction: `C:\Users\User\.claude\skills` → `D:\Workspace\projects\skills\skills`.
The script that creates it lives at [`scripts/link-skills.ps1`](../scripts/link-skills.ps1) — see
[05-source-control.md](05-source-control.md) for when you'd re-run it (e.g., setting this repo up
on a new machine).

Once the junction exists, Claude Code sees `~/.claude/skills/hello-world/SKILL.md` exactly as if it
were a real file there — it has no idea it's reading through a junction. Editing files under
`D:\Workspace\projects\skills\skills\` immediately changes what Claude Code sees, live.

## Verifying the link

```powershell
Get-Item "$HOME\.claude\skills" | Select-Object LinkType, Target
```

Should print `LinkType: Junction` and a `Target` pointing at this repo's `skills` folder.

## Project-local skills (the other option)

If a skill only makes sense for one specific codebase — e.g., "how to run this repo's flaky
integration test suite" — put it in that project's own `.claude/skills/` instead of here. This
repo (`D:\Workspace\projects\skills`) is specifically for skills you want *everywhere*.

## Next

[02-anatomy-of-a-skill.md](02-anatomy-of-a-skill.md) covers exactly what has to be inside a skill folder.
