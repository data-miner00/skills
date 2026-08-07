# 05 — Source Control & Distribution

## This repo's model

`D:\Workspace\projects\skills` is a normal git repository. There's nothing skill-specific about how
git treats it — `SKILL.md` files, scripts, and references are just text/code files like any other.
What makes it *work* as a live skills library is the junction described in
[01-locations-and-discovery.md](01-locations-and-discovery.md): git only ever sees and commits the
real files under `D:\...\skills\skills\`; the link at `~/.claude/skills` is a filesystem detail that
never gets committed (it's a marker on your machine, not part of the repo).

### Day-to-day workflow

1. Edit/add a skill under `skills/<name>/`.
2. Test it live — since the junction is in place, changes are visible to Claude Code immediately,
   no reload step needed for the file contents themselves (only `/help`'s cached list may need a
   new session to reflect a *new* skill appearing).
3. `git add`, commit, as you would for any project. Suggested commit style: `skills: add
   <name> — <one line on what it does>` for new skills, `docs: ...` for documentation-only changes.
4. Push to a remote (GitHub, etc.) if you want this backed up / synced across machines — that's a
   separate, later step and entirely your call on visibility (private repo recommended, since
   skills you write may embed private workflow details).

### Setting this repo up on a new machine

Cloning the repo alone is *not* enough — `~/.claude/skills` also needs to exist and point at the
freshly cloned `skills/` folder. Re-run [`scripts/link-skills.ps1`](../scripts/link-skills.ps1)
after cloning. See that script's comments for what it checks before creating the junction.

## When to go further: Plugins

Everything above covers a **personal** library. If you later want to *distribute* a skill to other
people — coworkers, the community — Claude Code has a separate **plugin** system:

- A plugin is a directory with a `.claude-plugin/plugin.json` manifest plus its own `skills/`
  (and optionally `commands/`, `agents/`) folders.
- Installed skills from a plugin are namespaced: `/plugin-name:skill-name`, avoiding collisions
  with your personal skills of the same short name.
- Plugins can be tested locally with `claude --plugin-dir ./my-plugin` before publishing, and
  validated with `claude plugin validate ./plugin`.
- Distribution happens via a marketplace or a plain git repository others point their plugin config
  at — versioning is optional, and a marketplace entry can pin a specific commit.

**This repo does not do this yet** — it's a personal library, not a plugin. If a skill you write
here matures into something worth sharing, the migration path is: copy that one skill's folder into
a new plugin repo, add the manifest, and validate — you don't need to restructure this whole repo
to do it.

## Next

[06-folder-structure-reference.md](06-folder-structure-reference.md) is a quick-reference cheat
sheet for this repo's actual layout and naming conventions.
