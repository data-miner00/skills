# Skills Index

| Skill | Trigger | Description |
|---|---|---|
| [`code-review`](code-review/) | Auto (or `/code-review`) | Two-axis review (Standards + Spec) of the diff since a fixed point, via parallel sub-agents. |
| [`commit-message-helper`](commit-message-helper/) | Auto (or `/commit-message-helper`) | Drafts/validates a git commit message in Conventional Commits style. |
| [`domain-modeling`](domain-modeling/) | Auto (or `/domain-modeling`) | Builds and sharpens the project's domain model — glossary terms and ADRs. |
| [`grilling`](grilling/) | Auto (or `/grilling`) | Interviews the user relentlessly to stress-test a plan or decision, round by round. |
| [`hello-world`](hello-world/) | User-only (`/hello-world`) | Onboarding greeting; explains this library. |
| [`implement`](implement/) | User-only (`/implement`) | Implements a spec or set of tickets, using `/tdd` and `/code-review` along the way. |
| [`pr-description`](pr-description/) | Auto (or `/pr-description`) | Drafts or updates a PR title/body from the branch's commits, diff, and originating spec/ticket. |
| [`research`](research/) | Auto (or `/research`) | Background-agent research against primary sources, written up as a Markdown file. |
| [`setup-repo-skills`](setup-repo-skills/) | User-only (`/setup-repo-skills`) | Scaffolds a repo's issue tracker and domain-doc conventions for the other skills. |
| [`tdd`](tdd/) | Auto (or `/tdd`) | Red-green-refactor loop discipline: seams, good tests, and anti-patterns to avoid. |
| [`to-spec`](to-spec/) | User-only (`/to-spec`) | Synthesizes the current conversation into a spec and publishes it to the issue tracker. |
| [`to-tickets`](to-tickets/) | User-only (`/to-tickets`) | Breaks a plan or spec into tracer-bullet tickets with blocking edges, published to the issue tracker. |
| [`wayfinder`](wayfinder/) | User-only (`/wayfinder`) | Plans large, foggy efforts as a shared map of decision tickets on the issue tracker. |

Keep this table in sync with the folders in this directory — update it in the same commit you add,
rename, or remove a skill. See [`../docs/06-folder-structure-reference.md`](../docs/06-folder-structure-reference.md)
for the conventions each skill folder should follow.