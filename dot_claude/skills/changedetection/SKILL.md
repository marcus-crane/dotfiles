---
name: changedetection
description: Read what changed on the pages tracked by changedetection.io at changes.home.utf9k.net. Use when asked what a watched page did, which watches have moved recently, or to pull the diff or snapshot for a tracked URL.
argument-hint: [watch name, URL, or question]
allowed-tools: Bash
---

# Read changedetection.io watches

`cdio` handles the base URL and API key. It is GET-only, so nothing here can disturb a
running watch. Mutations belong in the web UI.

```bash
cdio watches                  # one line per watch, most recently changed first
cdio search "<query>"         # same table, filtered by URL or title
cdio diff <uuid>              # previous -> latest, plain text, changed lines only
cdio history <uuid>           # snapshot timestamps to feed to diff or snapshot
cdio snapshot <uuid> [ts]     # full body of one snapshot, defaults to latest
cdio systeminfo               # queue depth, uptime, watch count
```

Start from `cdio watches` (or `cdio search` when the user names a specific site) to turn
whatever they said into a uuid. Then `cdio diff <uuid>` for what actually moved.

Diffs prefix removed lines with `(removed)` and added lines with `(added)`. They arrive
unfiltered, so a page with a rotating ad slot or a timestamp in the footer produces real
diffs full of noise. Read the diff and report the substantive change, not every line of it.

Two flags to know: `P` in the watches table means the watch is paused and its
`last_checked` is stale, `M` means notifications are muted so a change there fired no alert.

If `cdio` exits non-zero, report the error. A 403 means the API key is wrong or missing, a
404 on a diff usually means the watch has only one snapshot so there is nothing to compare
yet, and a credentials error names the `chezmoi apply` to run.
