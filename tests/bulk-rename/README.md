# bulk-rename tests

Tests `skills/bulk-rename/scripts/bulk_rename.pl`. Written in Perl using `Test::More`.

## Running

```
perl bulk_rename.t
```

Or, with `prove`, if your Perl install has `TAP::Harness::Env` (some minimal installs — e.g.
msys — don't ship it, in which case plain `perl` above is the reliable fallback):

```
prove bulk_rename.t
```

## What's covered

- dry-run plan output, without touching disk
- collision detection: target already exists, and two sources mapping to the same target
- `--apply` actually renaming files
- no-op reporting when nothing matches the pattern
- usage errors (missing args, an expression that isn't a valid `s///`) exiting 2

Shared test helpers live in `../lib/SkillTestUtil.pm` — it runs the script as a subprocess via
`IPC::Open3` rather than through a shell, so regex substitutions with `$`, quotes, or backslashes
never need shell-escaping.
