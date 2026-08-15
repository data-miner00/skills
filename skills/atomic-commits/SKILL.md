---
name: atomic-commits
description: Splits the working tree's pending changes into a sequence of small, atomic git commits — one logical change per commit, hunk-split when a single file's changes belong to more than one commit. Use when the user asks to commit changes as atomic/logical commits, split a diff into multiple commits, or organize a large pending change into a clean commit history.
---

Turn the working tree's pending changes into a sequence of atomic commits — each
one a single logical change, standing on its own, in dependency order.

1. **Survey.** Run `git status`, then read the full `git diff` and
   `git diff --staged` — every hunk, not just the file list. Grouping in the next
   step needs to know what each hunk actually does, not just which file it's in.

2. **Partition into atomic commits.** Group hunks by logical concern — one
   feature, one fix, one rename, one formatting pass per commit — and order the
   groups so a commit never depends on one that comes after it. A file whose
   hunks split across more than one group is a **shared file**; note, for each
   shared file, which hunks belong to which group and in what order — that list
   drives the shared-file handling in step 5.

3. **Draft messages.** For each group, invoke the `commit-message-helper` skill,
   handing it the group's diff from step 1 directly — nothing is staged yet, so
   its own `git diff --staged` fallback would see nothing (or everything,
   unsplit) rather than this one group. Draft and validate a Conventional
   Commits message for every group before moving on.

4. **Present the plan.** Show a table — columns `#`, `Commit Message`, `Files` —
   covering every group, and get the user's go-ahead before touching git. This
   plan is committing to a sequence of destructive-ish steps (temporary reverts
   on shared files), so confirm before executing rather than after.

5. **Execute in order.** For each group *i*, in plan order:
   - **Plain files** (no later group touches them): `git add` the file as-is.
   - **Shared files**: edit the file to remove the hunks belonging to *later*
     groups, so only group *i*'s portion (plus anything already committed)
     remains. Stage and commit. Then edit the file again to restore the
     removed hunks exactly as they were — diff the file against its
     pre-removal content to confirm the restore is exact before moving to the
     next group. This is direct file editing, not `git add -p`: an agent can't
     drive an interactive hunk-picker, but it can add and remove known lines
     with confidence.
   - Commit with the message drafted in step 3.

6. **Verify.** `git status` is clean (or shows only files intentionally left
   out), and `git log` shows one commit per row of the table, in order.
