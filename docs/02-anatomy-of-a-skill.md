# 02 — Anatomy of a Skill

## Minimal shape

```
skills/
└── my-skill/
    └── SKILL.md          # the only required file
```

A skill is a **folder** whose name is the skill's identifier (lowercase, hyphens — this becomes
`/my-skill`). Inside, `SKILL.md` is required; everything else is optional and only loaded on demand.

## `SKILL.md` frontmatter

```yaml
---
name: my-skill
description: >
  Does X for Y. Use when the user asks to Z, mentions <keywords>, or the task
  involves <situation>.
disable-model-invocation: false   # optional, default false
user-invocable: true              # optional, default true
allowed-tools: ["Read", "Bash"]   # optional — restricts what this skill may use
---

The body: instructions Claude follows once this skill is triggered.
```

| Field | Required | Purpose |
|---|---|---|
| `name` | Yes | ≤64 chars, lowercase + hyphens, no reserved words. Must match the folder name. |
| `description` | Yes | ≤1024 chars. **This is the single most important field** — it's what Claude reads at startup to decide relevance, before the body is ever loaded. Write it in third person, and be specific about *when* to use the skill, not just *what* it does. |
| `disable-model-invocation` | No | `true` = Claude will never auto-trigger this skill; it only runs via explicit `/my-skill`. Good for skills with side effects you always want to consciously invoke. |
| `user-invocable` | No | `false` = hides it from `/help` and manual invocation; Claude can still use it automatically. Rare — mainly for internal building-block skills. |
| `allowed-tools` | No | Restricts the tool set available while this skill is active. Use for skills that should never, say, run Bash. |

## The body

The body is plain markdown instructions — the "playbook" Claude follows. Conventions:

- Keep it **under ~500 lines**. If it's growing past that, you're not writing a skill anymore,
  you're writing a manual — split the excess into a linked reference file instead.
- Write it as instructions *to Claude*, not documentation *about* the skill. Imperative, not
  descriptive ("Run the linter, then...", not "This skill runs the linter...").
- Assume Claude is capable — don't over-explain basic reasoning, just give the specific procedure,
  constraints, and gotchas that aren't obvious.

## Progressive disclosure: supporting files

```
skills/
└── my-skill/
    ├── SKILL.md
    ├── references/
    │   └── api-format.md      # linked from SKILL.md, loaded only if needed
    ├── templates/
    │   └── config.md          # seed content copied into the target repo, then edited
    └── scripts/
        └── validate.py        # executed by Claude via Bash, never loaded into context
```

- **Reference files** (`references/*.md`, or a flat `REFERENCE.md`) hold detail that's only needed
  sometimes — a full API spec, an exhaustive list of edge cases, a style guide. `SKILL.md` should
  link to them explicitly ("see `references/api-format.md` for the full field list") so Claude
  knows to read them *only* when it actually needs that detail.
- Keep references **one level deep** from `SKILL.md`. Don't chain references-that-link-to-references
  — Claude may not follow the chain, and it defeats the purpose of keeping context cost predictable.
- **Template files** (`templates/*`) are seed content meant to be copied into the *target* repo and
  adapted, not read by Claude for its own guidance. Use this when the skill's job is to scaffold
  files elsewhere (docs, config, boilerplate) rather than to inform Claude's behavior in the moment.
- **Scripts** are for anything deterministic — parsing, validation, transformation. Claude runs them
  with the Bash tool and reads only their *output*, not their source, which is far cheaper than
  asking Claude to reimplement the logic in-context every time. Put them in `scripts/`.

## Passing arguments

If a skill is invoked as `/my-skill some args here`, use `$ARGUMENTS` in the body as a placeholder —
Claude will see the literal text substituted in. For auto-invoked skills, there's no explicit
argument passing; Claude infers what it needs from the conversation itself.

## Next

[03-writing-your-first-skill.md](03-writing-your-first-skill.md) builds `hello-world` from scratch,
step by step.
