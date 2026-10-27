#!/usr/bin/env python3
"""Validate, preview, and post inline-only GitHub PR reviews via gh."""

import argparse
import json
import re
import subprocess
import sys

HUNK = re.compile(r"^@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@")


def gh(*args, stdin=None):
    result = subprocess.run(
        ["gh", *args], input=stdin, capture_output=True, text=True
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip())
    return result.stdout


def gh_lines(path):
    out = gh("api", "--paginate", path, "--jq", ".[] | @json")
    return [json.loads(line) for line in out.splitlines() if line.strip()]


def commentable_lines(patch):
    lines = {"RIGHT": {}, "LEFT": {}}
    if not patch:
        return lines
    hunk = -1
    old = new = 0
    for raw in patch.split("\n"):
        header = HUNK.match(raw)
        if header:
            hunk += 1
            old, new = int(header.group(1)), int(header.group(2))
            continue
        if raw.startswith("\\"):
            continue
        if raw.startswith("+"):
            lines["RIGHT"][new] = hunk
            new += 1
        elif raw.startswith("-"):
            lines["LEFT"][old] = hunk
            old += 1
        else:
            lines["RIGHT"][new] = hunk
            lines["LEFT"][old] = hunk
            old += 1
            new += 1
    return lines


def load_draft(path):
    with open(path) as handle:
        draft = json.load(handle)
    for key in ("repo", "pr", "commit_id", "comments"):
        if key not in draft:
            raise ValueError(f"draft missing '{key}'")
    return draft


def anchor_errors(draft):
    repo, pr = draft["repo"], draft["pr"]
    files = {
        f["filename"]: commentable_lines(f.get("patch"))
        for f in gh_lines(f"repos/{repo}/pulls/{pr}/files")
    }
    errors = []
    for index, comment in enumerate(draft["comments"], 1):
        path = comment.get("path")
        side = comment.get("side", "RIGHT")
        end = comment.get("line")
        start = comment.get("start_line") or end
        where = f"#{index} {path}:{start}-{end}"
        if path not in files:
            errors.append(f"{where}: file not in PR diff")
            continue
        if not isinstance(end, int) or start > end:
            errors.append(f"{where}: bad line range")
            continue
        valid = files[path][side]
        missing = [n for n in range(start, end + 1) if n not in valid]
        if missing:
            errors.append(f"{where}: lines {missing} not in diff ({side})")
        elif valid[start] != valid[end]:
            errors.append(f"{where}: range spans two hunks")
        if not comment.get("body", "").strip():
            errors.append(f"{where}: empty body")
    return errors


def head_sha(repo, pr):
    return gh("api", f"repos/{repo}/pulls/{pr}", "--jq", ".head.sha").strip()


def cmd_existing(args):
    repo, pr = args.repo, args.pr
    for c in gh_lines(f"repos/{repo}/pulls/{pr}/comments"):
        line = c.get("line") or c.get("original_line")
        title = next(
            (ln for ln in c["body"].splitlines() if ln.strip().startswith("**")),
            c["body"].strip().splitlines()[0] if c["body"].strip() else "",
        )
        print(f"{c['path']}:{line} [{c['user']['login']}] {title.strip()[:120]}")


def cmd_validate(args):
    draft = load_draft(args.draft)
    errors = anchor_errors(draft)
    current = head_sha(draft["repo"], draft["pr"])
    if current != draft["commit_id"]:
        errors.append(
            f"PR head moved: draft {draft['commit_id'][:8]}, now {current[:8]}"
        )
    for error in errors:
        print(error)
    print("ok" if not errors else f"{len(errors)} problem(s)")
    return 1 if errors else 0


def cmd_render(args):
    draft = load_draft(args.draft)
    url = f"https://github.com/{draft['repo']}/pull/{draft['pr']}"
    print(f"# Draft review: {url}\n")
    print(f"{len(draft['comments'])} inline comment(s), no summary.\n")
    for index, c in enumerate(draft["comments"], 1):
        start = c.get("start_line")
        span = f"{start}-{c['line']}" if start else str(c["line"])
        print(f"---\n\n### {index}. `{c['path']}:{span}`\n")
        print(c["body"].strip() + "\n")
    held = draft.get("held_back") or []
    if held:
        print("---\n\n## Held back (not posted)\n")
        for item in held:
            print(f"- {item}")
    return 0


def cmd_post(args):
    if cmd_validate(args):
        print("refusing to post: fix the draft first", file=sys.stderr)
        return 1
    draft = load_draft(args.draft)
    comments = []
    for c in draft["comments"]:
        entry = {
            "path": c["path"],
            "line": c["line"],
            "side": c.get("side", "RIGHT"),
            "body": c["body"],
        }
        if c.get("start_line") and c["start_line"] != c["line"]:
            entry["start_line"] = c["start_line"]
            entry["start_side"] = entry["side"]
        comments.append(entry)
    payload = {
        "commit_id": draft["commit_id"],
        "event": "COMMENT",
        "comments": comments,
    }
    base = f"repos/{draft['repo']}/pulls/{draft['pr']}"
    try:
        out = gh(
            "api", "--method", "POST", f"{base}/reviews", "--input", "-",
            stdin=json.dumps(payload),
        )
        review = json.loads(out)
        print(f"posted {len(comments)} comment(s): {review.get('html_url')}")
        return 0
    except RuntimeError as error:
        if "body" not in str(error).lower():
            raise
    for entry in comments:
        entry["commit_id"] = draft["commit_id"]
        out = gh(
            "api", "--method", "POST", f"{base}/comments", "--input", "-",
            stdin=json.dumps(entry),
        )
        print(f"posted: {json.loads(out).get('html_url')}")
    return 0


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    existing = sub.add_parser("existing")
    existing.add_argument("repo")
    existing.add_argument("pr", type=int)
    for name in ("validate", "render", "post"):
        sub.add_parser(name).add_argument("draft")
    args = parser.parse_args()
    handlers = {
        "existing": cmd_existing,
        "validate": cmd_validate,
        "render": cmd_render,
        "post": cmd_post,
    }
    try:
        return handlers[args.command](args) or 0
    except (RuntimeError, ValueError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
