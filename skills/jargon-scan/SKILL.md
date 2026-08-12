---
name: jargon-scan
description: Scan the repo for technical jargon (protocols, acronyms, library/pattern-specific terms) that could confuse a newcomer, let the user pick which to have explained via a checklist, then append plain-language definitions to docs/tech-jargons.md.
disable-model-invocation: true
---

Scan the repo for technical jargon a newcomer to this stack might stumble on — protocol names,
acronyms, library- or pattern-specific terms (OAuth, OIDC, ThreadPool, ETag, and the like). This
is purely a human learning aid, not a domain glossary: skip business/domain terminology entirely
(that's [[domain-modeling]]'s territory — CONTEXT.md). `docs/tech-jargons.md` is for the user to
read back later; an agent need not consult it in the ordinary course of work.

## 1. Check what's already documented

Read `docs/tech-jargons.md` if it exists and collect every term already covered (its `##`
headings). These are off the table — never re-propose a term that's already documented.

## 2. Scan

Look through code, comments, config, dependency manifests, and docs for technical terms likely to
confuse someone new to this specific stack — acronyms, protocol names, library- or
pattern-specific vocabulary. Skip:

- Terms already documented (from step 1)
- General-programming vocabulary unlikely to confuse anyone (e.g. "function", "variable")
- Business/domain terminology — that belongs in a domain glossary, not here

For each remaining candidate, note the term and where it shows up (file path(s)).

If every candidate found is already documented, or nothing confusing turns up, say so and stop —
don't force a checklist out of nothing.

## 3. Checklist

Present the candidates with `AskUserQuestion` as a multiSelect checklist — one option per term,
label the term itself, description a one-line pointer to where/how it's used in this repo. Only
terms the user selects move to the next step. If the user selects none, stop here without writing
anything.

## 4. Distill (per selected term)

For each selected term, write a short, plain-language definition — the kind of explanation that
would help someone unfamiliar with it understand why it's here and what it does. 1-3 sentences.
Note which file(s) in this repo use it.

## 5. Write

Append to `docs/tech-jargons.md`, don't overwrite — one block per selected term:

```markdown
## <TERM> — YYYY-MM-DD

<1-3 sentence plain-language definition.>

Seen in: `path/to/file`, `path/to/other-file`
```

Create the file with just these entries if it doesn't exist yet.

## 6. Confirm

Show the user the path and the full entry text for each term written.
