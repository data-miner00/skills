# 00 — What Skills Are (and What They Aren't)

Claude Code has several extension mechanisms. If you're new to the ecosystem, it's easy to
confuse them. This doc places **Skills** on that map before you write one.

## The five mechanisms

| Mechanism | What it is | Who invokes it | Where it lives |
|---|---|---|---|
| **Skill** | A folder with a `SKILL.md` file describing a capability, optionally with scripts/reference docs | Claude (auto, based on the description) **or** you (`/skill-name`) | `~/.claude/skills/`, `.claude/skills/`, or a plugin |
| **Slash command** | A single markdown file that expands into a prompt | You, explicitly (`/command-name`) | `~/.claude/commands/`, `.claude/commands/` |
| **Subagent** | An isolated agent with its own system prompt, tools, and context window | Claude, via the `Agent` tool, or you by naming it | `.claude/agents/*.md` or built-in |
| **MCP server/tool** | An external process exposing tools over the Model Context Protocol | Claude, when a relevant tool is available | Configured in `mcp` settings, runs out-of-process |
| **Hook** | A shell command the harness runs automatically on an event (PreToolUse, Stop, etc.) | The harness, not Claude | `settings.json` |

## Where Skills fit

Skills are the mechanism for **"Claude should know how to do X, and figure out on its own when
X is relevant."** That's the key differentiator:

- A **slash command** only runs when you type it. It has no independent judgment about when to fire.
- A **skill** can be invoked the same way (`/skill-name`), but its real power is that Claude reads
  every skill's one-line `description` at the start of a session and can decide, mid-conversation,
  "this matches — I should use it," without you typing anything. (You can also force user-only
  invocation with `disable-model-invocation: true` if you don't want that.)
- A **subagent** is a whole separate Claude instance with its own context and tool access — heavier
  weight, used for isolating a big exploration or review task. A skill is closer to "a reusable
  playbook Claude follows inline," not a delegate.
- **MCP** gives Claude new *tools* (e.g., "call this API"). A skill gives Claude new *knowledge and
  procedure* for using tools it already has (e.g., "when doing X, use the Bash tool like this, then
  check for Y"). Skills can even instruct Claude to invoke specific MCP tools as part of a workflow.
- A **hook** is deterministic and invisible to Claude's reasoning — it always fires on its event,
  no judgment involved, and Claude doesn't "decide" to run it. A skill is the opposite: it's Claude
  reasoning about whether and how to apply it.

## Why skills exist: the context-cost problem

Stuffing a system prompt with every procedure you might ever need is expensive — every token is in
context on every turn, whether relevant or not. Skills solve this with **progressive disclosure**:

1. At startup, Claude only loads each skill's `name` + `description` (a line or two). Cheap, always present.
2. When a skill becomes relevant (you invoke it, or Claude's judgment matches the description to
   the conversation), the full `SKILL.md` body loads into context.
3. If the skill links to further files (`references/*.md`, `scripts/*.py`), those load only if the
   body actually needs them — scripts are *executed*, not read into context at all, unless they fail.

This is why a good `description` matters so much (see [04-best-practices.md](04-best-practices.md)) —
it's the only thing standing between "Claude found my skill" and "Claude never knew it existed."

## Next

Read [01-locations-and-discovery.md](01-locations-and-discovery.md) to see exactly where skills are
discovered from, and how this repo is wired into that discovery process.
