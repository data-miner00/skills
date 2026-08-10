# Skills Index

| Skill | Trigger | Description |
|---|---|---|
| [`bulk-rename`](bulk-rename/) | Auto (or `/bulk-rename`) | Batch-renames files by a regex substitution, with a dry-run plan and collision detection. |
| [`code-review`](code-review/) | Auto (or `/code-review`) | Two-axis review (Standards + Spec) of the diff since a fixed point, via parallel sub-agents. |
| [`codebase-design`](codebase-design/) | Auto (or `/codebase-design`) | Shared vocabulary for designing deep modules — module, interface, seam, adapter, depth, leverage, locality. |
| [`commit-message-helper`](commit-message-helper/) | Auto (or `/commit-message-helper`) | Drafts/validates a git commit message in Conventional Commits style. |
| [`domain-modeling`](domain-modeling/) | Auto (or `/domain-modeling`) | Builds and sharpens the project's domain model — glossary terms and ADRs. |
| [`feature-pipeline`](feature-pipeline/) | User-only (`/feature-pipeline`) | Index of the build-a-feature skills — which one to reach for at each stage from idea to shipped code. |
| [`grilling`](grilling/) | Auto (or `/grilling`) | Interviews the user relentlessly to stress-test a plan or decision, round by round. |
| [`hello-world`](hello-world/) | User-only (`/hello-world`) | Onboarding greeting; explains this library. |
| [`implement`](implement/) | User-only (`/implement`) | Implements a spec or set of tickets, using `/tdd` and `/code-review` along the way. |
| [`improve-codebase-architecture`](improve-codebase-architecture/) | User-only (`/improve-codebase-architecture`) | Scans a codebase for deepening opportunities, presents them as a visual HTML report, then grills through whichever one you pick. |
| [`pr-description`](pr-description/) | Auto (or `/pr-description`) | Drafts or updates a PR title/body from the branch's commits, diff, and originating spec/ticket. |
| [`research`](research/) | Auto (or `/research`) | Background-agent research against primary sources, written up as a Markdown file. |
| [`setup-repo-skills`](setup-repo-skills/) | User-only (`/setup-repo-skills`) | Scaffolds a repo's issue tracker and domain-doc conventions for the other skills. |
| [`tdd`](tdd/) | Auto (or `/tdd`) | Red-green-refactor loop discipline: seams, good tests, and anti-patterns to avoid. |
| [`to-spec`](to-spec/) | User-only (`/to-spec`) | Synthesizes the current conversation into a spec and publishes it to the issue tracker. |
| [`to-tickets`](to-tickets/) | User-only (`/to-tickets`) | Breaks a plan or spec into tracer-bullet tickets with blocking edges, published to the issue tracker. |
| [`wayfinder`](wayfinder/) | User-only (`/wayfinder`) | Plans large, foggy efforts as a shared map of decision issues on the issue tracker. |
| [`whitespace-sweep`](whitespace-sweep/) | Auto (or `/whitespace-sweep`) | Sweeps text files for trailing whitespace and EOF-newline issues, check/apply style. |
| [`writing-for-agents`](writing-for-agents/) | Auto (or `/writing-for-agents`) | Reference for writing documents an agent consumes — skills, AGENTS.md, CLAUDE.md — via context pointers and information hierarchy. |

Keep this table in sync with the folders in this directory — update it in the same commit you add,
rename, or remove a skill. See [`../docs/06-folder-structure-reference.md`](../docs/06-folder-structure-reference.md)
for the conventions each skill folder should follow.