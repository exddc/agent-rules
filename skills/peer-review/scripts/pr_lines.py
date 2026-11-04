#!/usr/bin/env python3
"""Turn PR diff locations into GitHub links you can comment on.

Reads a unified diff from stdin, as printed by `gh pr diff <N>`.

    gh pr diff 12 --repo o/r | pr_lines.py https://github.com/o/r/pull/12
        Lists every file with the new-side line ranges that can take an inline comment.

    gh pr diff 12 --repo o/r | pr_lines.py https://github.com/o/r/pull/12 src/a.py:40 src/b.py:L7
        Prints a link per location. `path:N` is line N of the new file, `path:LN` line N of the
        old file (a deleted line). A line outside every hunk gets the nearest line that is in one.
"""

import hashlib
import re
import sys

HUNK = re.compile(r"^@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@")
PR_URL = re.compile(r"^(https://github\.com/[^/]+/[^/]+/pull/\d+)")
LOCATION = re.compile(r"^(.+):(L?)(\d+)$")


def unquote(path: str) -> str:
    if path.startswith('"') and path.endswith('"'):
        return path[1:-1].encode("latin-1").decode("unicode_escape").encode("latin-1").decode("utf-8")
    return path


def strip_prefix(path: str) -> str | None:
    path = unquote(path.split("\t")[0])
    if path == "/dev/null":
        return None
    return path[2:] if path[:2] in ("a/", "b/") else path


def parse(diff: str) -> dict[str, dict[str, list[int]]]:
    files: dict[str, dict[str, list[int]]] = {}
    old_path: str | None = None
    current: dict[str, list[int]] | None = None
    old = new = 0
    for line in diff.splitlines():
        if line.startswith("diff --git "):
            current, old_path = None, None
        elif current is None and line.startswith("--- "):
            old_path = strip_prefix(line[4:])
        elif current is None and line.startswith("+++ "):
            path = strip_prefix(line[4:]) or old_path
            if path is None:
                continue
            current = files.setdefault(path, {"R": [], "L": [], "added": []})
        elif current is not None and (match := HUNK.match(line)):
            old, new = int(match[1]), int(match[2])
        elif current is not None and old + new > 0:
            tag = line[:1]
            if tag == "+":
                current["R"].append(new)
                current["added"].append(new)
                new += 1
            elif tag == "-":
                current["L"].append(old)
                old += 1
            elif tag == " " or line == "":
                current["R"].append(new)
                current["L"].append(old)
                old, new = old + 1, new + 1
    return files


def ranges(lines: list[int]) -> str:
    if not lines:
        return "-"
    spans: list[list[int]] = []
    for n in lines:
        if spans and n == spans[-1][1] + 1:
            spans[-1][1] = n
        else:
            spans.append([n, n])
    return ",".join(str(a) if a == b else f"{a}-{b}" for a, b in spans)


def link(base: str, path: str, side: str, line: int) -> str:
    anchor = hashlib.sha256(path.encode()).hexdigest()
    return f"{base}/changes#diff-{anchor}{side}{line}"


def main() -> int:
    if len(sys.argv) < 2 or not (url := PR_URL.match(sys.argv[1])):
        print(__doc__, file=sys.stderr)
        return 2
    base = url[1]
    files = parse(sys.stdin.read())
    if not files:
        print("No diff on stdin. Pipe `gh pr diff <N> --repo <owner>/<repo>` into this script.", file=sys.stderr)
        return 2

    if len(sys.argv) == 2:
        for path, sides in files.items():
            print(f"{path}\n  added: {ranges(sides['added'])}\n  commentable: {ranges(sides['R'])}")
        return 0

    status = 0
    for arg in sys.argv[2:]:
        match = LOCATION.match(arg)
        if not match:
            print(f"{arg}\tbad location, use path:N or path:LN")
            status = 1
            continue
        path, side, line = match[1], "L" if match[2] else "R", int(match[3])
        if path not in files:
            print(f"{arg}\tfile not in this PR's diff")
            status = 1
            continue
        lines = files[path][side]
        if line in lines:
            print(f"{arg}\t{link(base, path, side, line)}")
            continue
        if not lines:
            print(f"{arg}\tno commentable line on this side")
            status = 1
            continue
        nearest = min(lines, key=lambda n: abs(n - line))
        prefix = "L" if side == "L" else ""
        print(f"{arg}\toutside the diff; nearest is {path}:{prefix}{nearest}\t{link(base, path, side, nearest)}")
    return status


if __name__ == "__main__":
    sys.exit(main())
