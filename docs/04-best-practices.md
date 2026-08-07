# 04 — Best Practices

Distilled from Anthropic's own skill-authoring guidance.

## Writing the `description`

This is the highest-leverage field in the whole system — it's the only thing loaded into every
session by default, and it's the sole basis for whether Claude ever discovers your skill exists.

- **Third person, not first person.** "Extracts tables from PDF files" — not "I can help you with PDFs."
- **Name the trigger conditions explicitly.** Don't just say what it does; say *when to use it*:
  "Use when the user mentions PDF files, asks to extract data from a document, or needs to parse
  a form." Concrete nouns and verbs the user is likely to actually type beat vague phrasing.
- **Be specific, not generic.** "Helps with documents" will never out-compete Claude's own general
  reasoning for a match. "Extracts text and tables from PDF files, fills PDF form fields" will.

## Conciseness

- Every paragraph in `SKILL.md` has a token cost paid on every use. Before adding a paragraph, ask
  whether Claude — which is already a capable, general-purpose model — actually needs it spelled
  out, or whether it's obvious enough to omit.
- Treat `SKILL.md` as a **table of contents**, not an encyclopedia. Deep detail belongs in a linked
  reference file that only loads when actually needed (see
  [02-anatomy-of-a-skill.md](02-anatomy-of-a-skill.md)).

## Structure

- **One level of references, max.** `SKILL.md` → `references/foo.md` is fine. `SKILL.md` →
  `references/foo.md` → `references/bar.md` is not — Claude isn't guaranteed to follow a chain, and
  it defeats predictable context cost.
- **Scripts for anything deterministic.** Parsing, validation, format conversion — write it as a
  script Claude executes and reads the *output* of, rather than logic embedded in prose that Claude
  has to "perform" via reasoning each time. Cheaper and more reliable.
- **Consistent terminology.** If the skill calls something a "workspace" in one paragraph and a
  "project" in the next, Claude (and future-you) will misread it as two different things.

## Avoiding overlap between skills

- Two skills with overlapping descriptions create ambiguity about which should trigger — Claude may
  pick the wrong one, or both, or neither. Before adding a new skill, skim existing ones'
  descriptions ([skills/README.md](../skills/README.md)) for collision.
- Prefer one skill that handles a family of related requests over several near-duplicate skills.

## Testing a skill

- Actually invoke it (both by slash command and, for auto-invoked skills, via a natural prompt that
  should trigger it) rather than just reading it and assuming it's right.
- Test with an ambiguous prompt that's *close* to the trigger conditions but shouldn't fire it —
  helps catch an overly broad description.
- If you have access to multiple models, sanity-check that the instructions are clear enough that a
  smaller/faster model follows them correctly too, not just the most capable one.

## Time-sensitive content

- Avoid writing content that will silently go stale ("the current version is X", specific dates,
  "as of now"). If a skill legitimately needs to note that something changed, use an explicit
  "legacy/old pattern" callout rather than presenting stale info as current fact.

## Naming

- Use **gerund phrases** for skill names describing a process: `processing-pdfs`,
  `analyzing-spreadsheets`, not `pdf-processor` or `pdfs`. Reads naturally as "the skill for
  ___-ing."
- Lowercase, hyphen-separated, no reserved words, matching the folder name exactly.

## Next

[05-source-control.md](05-source-control.md) — how this repo is versioned, and what changes when
you want to share a skill beyond just yourself.
