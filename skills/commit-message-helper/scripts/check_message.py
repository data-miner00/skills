#!/usr/bin/env python3
"""Validate a git commit summary line against Conventional Commits style.

Usage: python check_message.py "<candidate commit message>"
Exits 0 and prints OK if valid, exits 1 and lists problems otherwise.
"""
import re
import sys

VALID_TYPES = {"feat", "fix", "docs", "refactor", "test", "chore"}
HEADER_RE = re.compile(r"^(?P<type>[a-z]+)(\((?P<scope>[^)]+)\))?(?P<breaking>!)?: (?P<summary>.+)$")


def check(message: str) -> list[str]:
    problems = []
    lines = message.splitlines()
    if not lines:
        return ["message is empty"]

    summary_line = lines[0]
    match = HEADER_RE.match(summary_line)
    if not match:
        problems.append(
            "summary line doesn't match 'type(scope): summary' — got: "
            f"{summary_line!r}"
        )
        return problems

    if match.group("type") not in VALID_TYPES:
        problems.append(
            f"unknown type '{match.group('type')}', expected one of "
            f"{sorted(VALID_TYPES)}"
        )

    if len(summary_line) > 72:
        problems.append(f"summary line is {len(summary_line)} chars, keep it <=72")

    if summary_line.rstrip().endswith("."):
        problems.append("summary line should not end with a period")

    summary = match.group("summary")
    if summary and summary[0].isupper() and summary.split()[0].lower() in {
        "added", "fixed", "removed", "updated", "changed",
    }:
        problems.append("use imperative mood ('add' not 'added')")

    if len(lines) > 1 and lines[1].strip():
        problems.append("second line must be blank if a body follows")

    return problems


def main() -> None:
    if len(sys.argv) != 2:
        print("usage: check_message.py \"<candidate commit message>\"", file=sys.stderr)
        sys.exit(2)

    problems = check(sys.argv[1])
    if problems:
        print("FAIL")
        for p in problems:
            print(f"- {p}")
        sys.exit(1)

    print("OK")


if __name__ == "__main__":
    main()
