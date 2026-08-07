# Skills

Personal library of Claude Code [Agent Skills](docs/00-overview.md) — version-controlled here, and
live-linked into `~/.claude/skills/` so every project on this machine can use them.

## Quick start

```powershell
git clone <this-repo-url> D:\Workspace\projects\skills
cd D:\Workspace\projects\skills
.\scripts\link-skills.ps1
```

Then start (or restart) Claude Code. Run `/help` to confirm your skills show up.

## Learn the system

Read in order:

1. [docs/00-overview.md](docs/00-overview.md) — what skills are, vs. commands/subagents/MCP/hooks
2. [docs/01-locations-and-discovery.md](docs/01-locations-and-discovery.md) — where skills live, how the link works
3. [docs/02-anatomy-of-a-skill.md](docs/02-anatomy-of-a-skill.md) — SKILL.md format, frontmatter, supporting files
4. [docs/03-writing-your-first-skill.md](docs/03-writing-your-first-skill.md) — tutorial, walks through `hello-world`
5. [docs/04-best-practices.md](docs/04-best-practices.md) — authoring guidance
6. [docs/05-source-control.md](docs/05-source-control.md) — git workflow, plugin distribution path
7. [docs/06-folder-structure-reference.md](docs/06-folder-structure-reference.md) — cheat sheet

## What's here

- [`skills/`](skills/) — the actual skills, linked into `~/.claude/skills/`. See
  [skills/README.md](skills/README.md) for the current list.
- [`docs/`](docs/) — the guide above.
- [`scripts/link-skills.ps1`](scripts/link-skills.ps1) — (re)creates the `~/.claude/skills` junction
  pointing at this repo's `skills/` folder.
