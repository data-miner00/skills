# 06 — Folder Structure Reference

Cheat sheet for this repo. See earlier docs for the reasoning behind each piece.

```
D:\Workspace\projects\skills\             ← this repo (git root)
├── README.md                             ← start here; quick start + doc links
├── .gitignore
├── docs/                                 ← everything you're reading now
│   ├── 00-overview.md
│   ├── 01-locations-and-discovery.md
│   ├── 02-anatomy-of-a-skill.md
│   ├── 03-writing-your-first-skill.md
│   ├── 04-best-practices.md
│   ├── 05-source-control.md
│   └── 06-folder-structure-reference.md ← you are here
├── skills/                               ← linked to ~/.claude/skills (junction)
│   ├── README.md                         ← index of every skill in this library
│   ├── hello-world/
│   │   └── SKILL.md
│   └── commit-message-helper/
│       ├── SKILL.md
│       ├── references/
│       │   └── conventional-commits.md
│       └── scripts/
│           └── check_message.py
└── scripts/                              ← repo tooling, NOT skill tooling
    └── link-skills.ps1                   ← (re)creates the ~/.claude/skills junction
```

## Conventions

- **Every skill is a folder under `skills/`, named exactly like its `name:` frontmatter field**
  (lowercase, hyphens, gerund-first for process skills — see
  [04-best-practices.md](04-best-practices.md#naming)).
- **`skills/README.md` stays in sync** with whatever skills actually exist — update it in the same
  commit you add or remove a skill.
- **`scripts/` at the repo root** is for tooling *about this repo* (the linker). **`scripts/` inside
  a skill folder** is tooling *for that skill*, executed by Claude when the skill runs. Don't
  confuse the two.
- **Numbered docs** (`00-`, `01-`, ...) are meant to be read in order for a first pass, then used as
  reference afterward — each links forward to the next at the bottom.
- Adding a new skill never requires touching `docs/` — the docs describe the *system*, not the
  inventory. Only `skills/README.md` needs the new entry.

## When this repo will need to change shape

- **A skill needs project-specific behavior** → don't force it in here; put it in that project's own
  `.claude/skills/` instead (see
  [01-locations-and-discovery.md](01-locations-and-discovery.md#project-local-skills-the-other-option)).
- **You want to share one skill publicly** → don't restructure this repo; spin the single skill out
  into its own plugin repo (see
  [05-source-control.md](05-source-control.md#when-to-go-further-plugins)).
- **The library grows large enough that flat `skills/` gets unwieldy** → consider subcategories
  (e.g. `skills/git/`, `skills/writing/`) only once you actually feel the pain; premature
  categorization for two skills isn't worth it.
