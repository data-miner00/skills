---
name: whitespace-sweep
description: Sweeps text files for trailing whitespace and missing/duplicate end-of-file newlines, with optional line-ending or tab normalization, defaulting to a check-only dry run. Use when the user wants to clean up whitespace issues, fix "no newline at end of file" warnings, or add a whitespace lint check across changed or tracked files.
---

Sweep files for whitespace issues using `scripts/whitespace_sweep.pl`. It
always strips trailing whitespace per line and collapses trailing blank
lines to exactly one final newline; line-ending and tab normalization are
opt-in via flags.

1. Decide scope with the user if it's not obvious:
   - a specific change → `git diff --name-only` (or `--staged`)
   - the whole repo → `git ls-files` (respects `.gitignore`, tracked files only)
   Avoid walking the raw filesystem — always source the file list from git so
   generated/ignored files aren't touched.
2. Run in default (check) mode first:
   ```
   perl scripts/whitespace_sweep.pl $(git diff --name-only)
   ```
   Exit `0` means clean; exit `1` lists the files that would change and why
   (trailing whitespace, eol, tabs, or final-newline fixes). Exit `2` is a
   usage error.
3. Show the findings to the user. This mode alone is also useful standalone
   as a lint-style check — you don't need to apply anything if the user just
   wants to know what's dirty.
4. If the user wants fixes applied, confirm first if the working tree isn't
   already clean (recommend committing or stashing so the sweep's diff is
   easy to review), then re-run with `--apply`.
5. Pass `--eol=lf` or `--eol=crlf` only if the user explicitly wants line
   endings normalized — by default the script preserves whichever ending is
   already dominant in each file, so untouched files are never re-encoded.
   Pass `--tabs=N` only if the user wants tabs expanded to spaces.
6. After applying, run `git diff --stat` so the user can see the blast
   radius before committing.

Binary files are auto-detected and skipped untouched.
