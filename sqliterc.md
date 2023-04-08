---
title: .sqliterc
category: sqlite
tags:
- databases
- sqlite
output: dot_sqliterc
---

# ~/.sqliterc

> Default configurations imported by sqlite3 sessions

## .headers on

By enabling headers, all queries that return data will include column names, instead of just unlabelled data.

```bash
.headers on
```

## .mode line

By defaulting to line mode, results will be returned with a newline between each result.

Without this, results will be returned squished into one long line. For large tables, this can be borderline unreadable.

```bash
.mode line
```