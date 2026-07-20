#!/usr/bin/env python3
"""
Claude Code statusline helper.

Reads the per-session JSON from stdin, maintains a monthly usage ledger at
~/.claude/usage-ledger.json, and prints a concise status line showing the
current session's token usage.

Usage:
  # Normal (invoked by Claude Code via statusLine.command):
  echo '<json>' | python3 statusline.py

  # Bootstrap historical sessions from CC transcripts:
  python3 statusline.py --bootstrap
  python3 statusline.py --bootstrap /path/to/transcripts/root
"""

import json
import os
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone

LEDGER_PATH = os.path.expanduser("~/.claude/usage-ledger.json")
SCHEMA_VERSION = 1

# Pricing per million tokens (claude-opus-4 / claude-sonnet-4 range)
# These are used only as a fallback estimate when no cost field is present.
PRICE_INPUT_PER_M = 3.00
PRICE_OUTPUT_PER_M = 15.00
PRICE_CACHE_READ_PER_M = 0.30
PRICE_CACHE_WRITE_PER_M = 3.75

# ---------------------------------------------------------------------------
# ANSI color helpers — degrade gracefully on TERM=dumb or non-TTY
# ---------------------------------------------------------------------------
_USE_COLOR = (
    os.environ.get("TERM", "xterm") != "dumb"
    and os.environ.get("NO_COLOR") is None
)

def _c(code: str, text: str) -> str:
    """Wrap text in an ANSI escape if color is enabled."""
    if not _USE_COLOR:
        return text
    return f"\x1b[{code}m{text}\x1b[0m"

def cyan(t):    return _c("36", t)
def bold(t):    return _c("1", t)
def dim(t):     return _c("2", t)
def green(t):   return _c("32", t)
def yellow(t):  return _c("33", t)
def red(t):     return _c("31", t)
def magenta(t): return _c("35", t)
def blue(t):    return _c("34", t)


# ---------------------------------------------------------------------------
# Ledger helpers
# ---------------------------------------------------------------------------

def load_ledger():
    try:
        with open(LEDGER_PATH, "r") as f:
            data = json.load(f)
        if data.get("schema_version") != SCHEMA_VERSION:
            return {"schema_version": SCHEMA_VERSION, "sessions": {}}
        return data
    except (FileNotFoundError, json.JSONDecodeError, KeyError):
        return {"schema_version": SCHEMA_VERSION, "sessions": {}}


def save_ledger(ledger):
    """Atomic write: write to temp file in same directory, then rename."""
    dir_path = os.path.dirname(LEDGER_PATH)
    os.makedirs(dir_path, exist_ok=True)
    fd, tmp_path = tempfile.mkstemp(dir=dir_path, prefix=".ledger-", suffix=".tmp")
    try:
        with os.fdopen(fd, "w") as f:
            json.dump(ledger, f, separators=(",", ":"))
        os.replace(tmp_path, LEDGER_PATH)
    except Exception:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass
        raise


# ---------------------------------------------------------------------------
# Formatting helpers
# ---------------------------------------------------------------------------

def fmt_tokens(n):
    if n >= 1_000_000:
        return f"{n/1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n/1_000:.1f}k"
    return str(n)


def fmt_cost(usd):
    if usd < 0.01:
        return "$0.00"
    if usd < 1.0:
        return f"${usd:.3f}"
    return f"${usd:.2f}"


def estimate_cost(input_tok, output_tok, cache_read_tok, cache_write_tok):
    cost = (
        input_tok * PRICE_INPUT_PER_M / 1_000_000
        + output_tok * PRICE_OUTPUT_PER_M / 1_000_000
        + cache_read_tok * PRICE_CACHE_READ_PER_M / 1_000_000
        + cache_write_tok * PRICE_CACHE_WRITE_PER_M / 1_000_000
    )
    return max(0.0, cost)


def current_ym():
    now = datetime.now(timezone.utc)
    return now.strftime("%Y-%m")


# ---------------------------------------------------------------------------
# Bootstrap: scan CC transcript JSONL files and backfill the ledger
# ---------------------------------------------------------------------------

def _find_transcript_roots(hint_path=None):  # hint_path: str | None
    """Return candidate transcript root directories to scan."""
    candidates = []
    if hint_path:
        # hint_path is e.g. ~/.claude/projects/SLUG/SESSION.jsonl
        # root = two levels up (the "projects" directory)
        p = os.path.abspath(hint_path)
        parent = os.path.dirname(p)          # project slug dir
        root = os.path.dirname(parent)       # "projects" dir
        candidates.append(root)
        candidates.append(parent)            # also check the single project dir
    # Common default location regardless of hint
    home = os.path.expanduser("~")
    candidates.append(os.path.join(home, ".claude", "projects"))
    return candidates


def _parse_transcript_file(path: str):
    """
    Parse a single JSONL transcript file.
    Returns (session_id, last_ts_iso, input_tok, output_tok, cache_read_tok, cache_write_tok)
    or None on failure.
    """
    session_id = os.path.splitext(os.path.basename(path))[0]
    total_input = total_output = total_cache_read = total_cache_write = 0
    last_ts = None

    try:
        with open(path, "r", errors="replace") as f:
            for raw_line in f:
                raw_line = raw_line.strip()
                if not raw_line:
                    continue
                try:
                    obj = json.loads(raw_line)
                except json.JSONDecodeError:
                    continue

                # Capture timestamp from any line that has one
                ts = (
                    obj.get("timestamp")
                    or obj.get("created_at")
                    or (obj.get("message") or {}).get("timestamp")
                )
                if ts:
                    last_ts = ts

                # Usage is on assistant-role message objects
                msg = obj.get("message") or {}
                role = obj.get("role") or msg.get("role") or ""
                if role != "assistant":
                    continue

                usage = msg.get("usage") or obj.get("usage") or {}
                total_input      += usage.get("input_tokens", 0) or 0
                total_output     += usage.get("output_tokens", 0) or 0
                total_cache_read += usage.get("cache_read_input_tokens", 0) or 0
                total_cache_write += usage.get("cache_creation_input_tokens", 0) or 0

    except OSError:
        return None

    if total_input == 0 and total_output == 0:
        return None  # empty / unparseable

    # Fall back to file mtime if no timestamp found in content
    if last_ts is None:
        try:
            mtime = os.path.getmtime(path)
            last_ts = datetime.fromtimestamp(mtime, tz=timezone.utc).isoformat()
        except OSError:
            last_ts = datetime.now(timezone.utc).isoformat()

    return session_id, last_ts, total_input, total_output, total_cache_read, total_cache_write


def bootstrap(hint_path=None, verbose=True):  # hint_path: str | None
    """
    Walk CC transcript directories and backfill the ledger with historical sessions.
    Existing ledger entries are NOT overwritten (live session wins).
    """
    roots = _find_transcript_roots(hint_path)
    ledger = load_ledger()
    sessions = ledger.setdefault("sessions", {})

    scanned = 0
    added = 0
    skipped_existing = 0
    skipped_empty = 0

    for root in roots:
        if not os.path.isdir(root):
            continue
        # Walk up to 3 levels deep to find *.jsonl files
        for dirpath, dirnames, filenames in os.walk(root):
            # Limit depth to avoid runaway scanning
            depth = dirpath[len(root):].count(os.sep)
            if depth >= 3:
                dirnames.clear()
                continue
            for fname in filenames:
                if not fname.endswith(".jsonl"):
                    continue
                fpath = os.path.join(dirpath, fname)
                scanned += 1
                result = _parse_transcript_file(fpath)
                if result is None:
                    skipped_empty += 1
                    continue
                sid, last_ts, inp, out, cr, cw = result
                if sid in sessions:
                    skipped_existing += 1
                    continue
                cost = estimate_cost(inp, out, cr, cw)
                sessions[sid] = {
                    "input_tokens": inp,
                    "output_tokens": out,
                    "cache_read_tokens": cr,
                    "cache_write_tokens": cw,
                    "cost_usd": cost,
                    "updated_at": last_ts,
                    "bootstrap": True,
                }
                added += 1

    save_ledger(ledger)

    if verbose:
        ym = current_ym()
        mtd_cost = sum(
            (e.get("cost_usd") or 0.0)
            for e in sessions.values()
            if (e.get("updated_at") or "")[:7] == ym
        )
        print(
            f"Bootstrap complete. "
            f"Scanned={scanned} added={added} "
            f"skipped_existing={skipped_existing} skipped_empty={skipped_empty}\n"
            f"MTD cost for {ym}: {fmt_cost(mtd_cost)}"
        )
    return added


# ---------------------------------------------------------------------------
# Main statusline rendering
# ---------------------------------------------------------------------------

def main():
    # Handle --bootstrap CLI invocation
    if len(sys.argv) > 1 and sys.argv[1] == "--bootstrap":
        hint = sys.argv[2] if len(sys.argv) > 2 else None
        bootstrap(hint_path=hint, verbose=True)
        # Mark bootstrap as done in the ledger
        ldg = load_ledger()
        ldg["bootstrapped"] = True
        save_ledger(ldg)
        return

    raw = sys.stdin.read()
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        print("statusline: invalid JSON", file=sys.stderr)
        sys.exit(0)

    session_id = data.get("session_id", "unknown")
    model_name = data.get("model", {}).get("display_name") or "Claude"

    cw = data.get("context_window", {})
    total_in = cw.get("total_input_tokens") or 0
    total_out = cw.get("total_output_tokens") or 0
    session_tokens = total_in + total_out

    cur_usage = cw.get("current_usage") or {}
    cache_read = cur_usage.get("cache_read_input_tokens") or 0
    cache_write = cur_usage.get("cache_creation_input_tokens") or 0

    # Estimate session cost from token counts (kept in the ledger for
    # historical tracking, but intentionally not shown in the statusline).
    session_cost = estimate_cost(total_in, total_out, cache_read, cache_write)

    used_pct = cw.get("used_percentage")

    # --- Bootstrap ledger on first run (if bootstrap has never been done) ---
    ledger = load_ledger()
    sessions = ledger.setdefault("sessions", {})
    has_bootstrapped = ledger.get("bootstrapped", False)

    transcript = data.get("transcript_path") or ""

    if not has_bootstrapped and transcript:
        bootstrap(hint_path=transcript, verbose=False)
        ledger = load_ledger()
        sessions = ledger.setdefault("sessions", {})
        ledger["bootstrapped"] = True
        save_ledger(ledger)
        ledger = load_ledger()
        sessions = ledger.setdefault("sessions", {})

    # --- Update ledger with current session ---
    now_iso = datetime.now(timezone.utc).isoformat()
    sessions[session_id] = {
        "input_tokens": total_in,
        "output_tokens": total_out,
        "cache_read_tokens": cache_read,
        "cache_write_tokens": cache_write,
        "cost_usd": session_cost,
        "updated_at": now_iso,
    }
    save_ledger(ledger)

    # --- Context bar ---
    if used_pct is not None:
        used_int = round(used_pct)
        filled = used_int // 10
        bar = cyan("█" * filled) + dim("░" * (10 - filled))
        ctx_str = f"🧠 {bar} {used_int}%"
    else:
        ctx_str = f"🧠 {dim('░░░░░░░░░░')} {dim('--')}"

    # --- Git info ---
    git_str = ""
    project_dir = (data.get("workspace") or {}).get("project_dir") or ""
    if project_dir and os.path.isdir(project_dir):
        try:
            repo_name = subprocess.check_output(
                ["git", "-C", project_dir, "rev-parse", "--show-toplevel"],
                stderr=subprocess.DEVNULL, timeout=1
            ).decode().strip()
            repo_name = os.path.basename(repo_name)
            branch = subprocess.check_output(
                ["git", "-C", project_dir, "symbolic-ref", "--short", "HEAD"],
                stderr=subprocess.DEVNULL, timeout=1
            ).decode().strip()
            if repo_name and branch:
                git_str = f"📁 {blue(repo_name)}  🌿 {magenta(branch)}"
        except Exception:
            pass

    # --- Session elapsed time ---
    time_str = ""
    if transcript and os.path.isfile(transcript):
        try:
            start_epoch = os.path.getmtime(transcript)
            now_epoch = datetime.now(timezone.utc).timestamp()
            elapsed = int(now_epoch - start_epoch)
            hrs = elapsed // 3600
            mins = (elapsed % 3600) // 60
            secs = elapsed % 60
            if hrs > 0:
                time_str = f"⏱ {hrs}h{mins}m"
            else:
                time_str = f"⏱ {mins}m{secs}s"
        except OSError:
            pass

    # --- Context percentage string ---
    ctx_pct_str = ""
    remaining_pct = cw.get("remaining_percentage")
    if remaining_pct is not None:
        remaining_int = round(remaining_pct)
        if remaining_int < 20:
            ctx_pct_str = red(f"{remaining_int}% left")
        elif remaining_int < 40:
            ctx_pct_str = yellow(f"{remaining_int}% left")

    # --- Effort / thinking indicator ---
    effort_str = ""
    effort = data.get("effort")
    if effort:
        lvl = effort.get("level") or ""
        effort_map = {"low": "◦", "medium": "●", "high": "◉", "xhigh": "⬡", "max": "★"}
        effort_str = dim(effort_map.get(lvl, lvl))

    # --- Assemble sections ---
    sep = dim("  │  ")

    # Model section: 🤖 Claude Opus 4
    model_section = f"🤖 {cyan(bold(model_name))}"
    if effort_str:
        model_section += f" {effort_str}"

    # Context section
    ctx_section = ctx_str
    if ctx_pct_str:
        ctx_section += f" {ctx_pct_str}"

    # Session token section: 💬 1.2M
    sess_section = f"💬 {fmt_tokens(session_tokens)}"

    parts = [model_section, ctx_section]
    if git_str:
        parts.append(git_str)
    parts.append(sess_section)
    if time_str:
        parts.append(time_str)

    line = sep.join(parts)

    # Hard cap: strip ANSI for visible length check, trim if too wide
    ansi_escape = re.compile(r'\x1b\[[0-9;]*m')
    visible = ansi_escape.sub("", line)
    if len(visible) > 220:
        # Trim by dropping the time section
        parts_notimed = [p for p in parts if not p.startswith("⏱")]
        line = sep.join(parts_notimed)

    print(line)


if __name__ == "__main__":
    main()
