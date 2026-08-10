#!/usr/bin/env python3
"""Black-box tests for skills/commit-message-helper/scripts/check_message.py.

Run: python test_check_message.py
"""
import subprocess
import sys
import unittest
from pathlib import Path

SCRIPT = (
    Path(__file__).resolve().parent
    / ".." / ".." / "skills" / "commit-message-helper" / "scripts" / "check_message.py"
).resolve()


def run(*args):
    """Runs check_message.py with the given args; returns (combined output, exit code)."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT), *args],
        capture_output=True,
        text=True,
    )
    return result.stdout + result.stderr, result.returncode


class CheckMessageTest(unittest.TestCase):
    def test_script_exists(self):
        self.assertTrue(SCRIPT.is_file(), f"script not found at {SCRIPT}")

    def test_valid_summary_passes(self):
        out, code = run("fix: correct off-by-one error in parser")
        self.assertEqual(code, 0)
        self.assertIn("OK", out)

    def test_valid_summary_with_scope_and_breaking_marker(self):
        out, code = run("feat(auth)!: add OAuth support")
        self.assertEqual(code, 0)
        self.assertIn("OK", out)

    def test_empty_message_fails(self):
        out, code = run("")
        self.assertEqual(code, 1)
        self.assertIn("message is empty", out)

    def test_missing_header_shape_fails(self):
        out, code = run("no colon in this line")
        self.assertEqual(code, 1)
        self.assertIn("doesn't match", out)

    def test_unknown_type_fails(self):
        out, code = run("foo: does something")
        self.assertEqual(code, 1)
        self.assertIn("unknown type", out)

    def test_overlong_summary_fails(self):
        out, code = run("fix: " + "x" * 70)
        self.assertEqual(code, 1)
        self.assertIn("keep it <=72", out)

    def test_trailing_period_fails(self):
        out, code = run("fix: correct the bug.")
        self.assertEqual(code, 1)
        self.assertIn("should not end with a period", out)

    def test_non_imperative_mood_fails(self):
        out, code = run("fix: Added missing null check")
        self.assertEqual(code, 1)
        self.assertIn("imperative mood", out)

    def test_non_blank_second_line_fails(self):
        out, code = run("fix: correct the bug\nthis line should be blank")
        self.assertEqual(code, 1)
        self.assertIn("second line must be blank", out)

    def test_valid_multiline_message_passes(self):
        out, code = run("fix: correct the bug\n\nExplains why, not what.")
        self.assertEqual(code, 0)
        self.assertIn("OK", out)

    def test_usage_error_on_wrong_arg_count(self):
        out, code = run()
        self.assertEqual(code, 2)
        self.assertIn("usage:", out.lower())


if __name__ == "__main__":
    unittest.main()
