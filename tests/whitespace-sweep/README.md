# whitespace-sweep tests

Tests `skills/whitespace-sweep/scripts/whitespace_sweep.pl`. Written in Perl using `Test::More`.

## Running

```
perl whitespace_sweep.t
```

Or, with `prove`, if your Perl install has `TAP::Harness::Env` (some minimal installs — e.g.
msys — don't ship it, in which case plain `perl` above is the reliable fallback):

```
prove whitespace_sweep.t
```

## What's covered

- check mode (default): reports issues, leaves files untouched, exits 1 if dirty / 0 if clean
- `--apply`: strips trailing whitespace and collapses trailing blank lines to one final newline
- line endings: CRLF preserved by default, converted only with `--eol=lf`/`--eol=crlf`
- `--tabs=N` expanding tabs to spaces
- binary files skipped untouched
- idempotency: a second run after `--apply` reports clean
- usage errors (missing args, invalid `--eol` value) exiting 2

Shared test helpers live in `../lib/SkillTestUtil.pm` — it runs the script as a subprocess via
`IPC::Open3` rather than through a shell, so no argument needs shell-escaping.
