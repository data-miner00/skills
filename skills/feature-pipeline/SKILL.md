---
name: feature-pipeline
description: Index of the build-a-feature skills — which one to reach for at each stage from idea to shipped code.
disable-model-invocation: true
---

Points at the user-invoked skills that take a feature from idea to implementation. Each is invoked by name; this skill only tells you which one and when — it never fires them itself.

- **New repo, never run these skills here before** → `/setup-repo-skills`. Scaffolds the issue tracker and domain docs the others read from.
- **Idea too big for one session, still foggy** → `/wayfinder`. Charts it as a map of decision issues, resolved one at a time.
- **Idea already clear, just needs writing up** → `/to-spec`. Synthesizes the current conversation into a spec, no interview.
- **Spec (or plan) exists, needs breaking into buildable slices** → `/to-tickets`. Produces tracer-bullet tickets with blocking edges.
- **Spec or tickets exist, ready to build** → `/implement`. Does the work, using `/tdd` and `/code-review` at agreed seams.

Unsure which stage you're at? Default to `/to-spec` if you can already describe the feature in a paragraph; default to `/wayfinder` if you can't.
