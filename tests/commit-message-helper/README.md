# commit-message-helper tests

Tests `skills/commit-message-helper/scripts/check_message.py`. Written in Python using the
standard-library `unittest` (no extra install required — `pytest` isn't assumed to be present).

## Running

```
python test_check_message.py
```

Or via unittest's discovery/runner from the repo root:

```
python -m unittest tests/commit-message-helper/test_check_message.py -v
```

## What's covered

- valid summary lines (plain, and with scope + `!` breaking-change marker) print `OK`, exit 0
- empty message, missing `type: summary` shape, unknown `type`, overlong summary, trailing
  period, non-imperative mood, and a non-blank second line each print `FAIL` with the specific
  problem, exit 1
- a valid multi-line message (blank line before the body) passes
- wrong argument count exits 2 with a usage message

Tests run the script as a subprocess (`subprocess.run`) rather than importing it, exercising the
same CLI interface the skill actually invokes.
