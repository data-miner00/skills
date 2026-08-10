---
name: bulk-rename
description: Batch-renames files by a regex substitution, with a dry-run plan and collision detection before anything touches disk. Use when the user wants to rename many files at once by pattern (extension changes, prefix/suffix rewrites, numbering fixes) instead of one at a time.
---

Rename a set of files by pattern using `scripts/bulk_rename.pl`. The script
applies a Perl `s/PATTERN/REPLACEMENT/FLAGS` substitution to each file's
basename (never its directory), and refuses to touch the filesystem until
the whole batch validates clean.

1. Pin down the pattern and the file set with the user if either is
   ambiguous — don't guess a regex against files you haven't listed.
2. Always run without `--apply` first:
   ```
   perl scripts/bulk_rename.pl 's/PATTERN/REPLACEMENT/FLAGS' FILE...
   ```
   This prints the full rename plan (`WOULD RENAME: old -> new`) and exits
   non-zero if there's a collision (two sources mapping to the same target,
   or a target that already exists) — fix those before proceeding, don't
   force through them.
3. Renaming many files at once is hard to reverse by hand — show the dry-run
   plan to the user and get explicit confirmation before applying, same as
   any other batch edit with wide blast radius.
4. Once confirmed, re-run with `--apply` to perform the renames.
5. If the files are tracked in git, suggest `git status` afterward so the
   user can see the renames registered as such (not delete+add).

Don't use the `/r` flag in the substitution — it returns a new string
instead of mutating in place, so the script would report every file as
unchanged. The expression is evaluated as Perl, so only pass one the user
has reviewed, the same trust model as running `perl -e` directly.
