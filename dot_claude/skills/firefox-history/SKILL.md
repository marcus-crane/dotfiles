---
name: firefox-history
description: Search Firefox browsing history by keyword, URL, or time. Use when the user wants to find something they looked at in Firefox, recall a link, or see what they were browsing around a specific time.
argument-hint: [search term or question]
allowed-tools: Bash, Read
---

# Firefox History Search

Help the user find pages from their Firefox browsing history. The user will describe what they're looking for — a topic, a URL fragment, a time range, or a vague recollection. Your job is to query the history database and find it.

## Setup

Firefox stores history in a SQLite database that is locked while Firefox is running. Always start by copying it:

```bash
cp ~/.mozilla/firefox/uq4slia4.default-release/places.sqlite /tmp/places_copy.sqlite
```

## Database Schema

- `moz_places`: URLs and titles (`id`, `url`, `title`)
- `moz_historyvisits`: visit timestamps (`place_id`, `visit_date`)
- `visit_date` is in **microseconds** since epoch — divide by 1,000,000 for unix time

## Query Patterns

### Search by keyword (title or URL)

```sql
sqlite3 -header -column /tmp/places_copy.sqlite "
  SELECT datetime(v.visit_date/1000000,'unixepoch','localtime') as time,
         p.title, p.url
  FROM moz_historyvisits v JOIN moz_places p ON v.place_id=p.id
  WHERE p.title LIKE '%KEYWORD%' OR p.url LIKE '%KEYWORD%'
  ORDER BY v.visit_date DESC LIMIT 20;"
```

### Show activity around a timestamp (context window)

Once you find an approximate time, show surrounding browsing activity (default ±30 minutes):

```sql
sqlite3 -header -column /tmp/places_copy.sqlite "
  SELECT datetime(v.visit_date/1000000,'unixepoch','localtime') as time,
         p.title, p.url
  FROM moz_historyvisits v JOIN moz_places p ON v.place_id=p.id
  WHERE datetime(v.visit_date/1000000,'unixepoch','localtime')
        BETWEEN 'YYYY-MM-DD HH:MM' AND 'YYYY-MM-DD HH:MM'
  ORDER BY v.visit_date;"
```

### Browse a specific date

```sql
sqlite3 -header -column /tmp/places_copy.sqlite "
  SELECT datetime(v.visit_date/1000000,'unixepoch','localtime') as time,
         p.title, p.url
  FROM moz_historyvisits v JOIN moz_places p ON v.place_id=p.id
  WHERE date(v.visit_date/1000000,'unixepoch','localtime') = 'YYYY-MM-DD'
  ORDER BY v.visit_date;"
```

## Workflow

1. Copy the database to `/tmp`
2. Based on the user's description, search by keyword, URL fragment, domain, or date
3. If the user is looking for something they found *near* another page, first find the anchor page, note its timestamp, then query a time window around it
4. Present results concisely — show time, title, and URL
5. If there are too many results, narrow with additional filters or tighter time windows
6. Clean up: `rm /tmp/places_copy.sqlite` when done

## Tips

- Users often remember vaguely. Try multiple LIKE patterns if the first doesn't hit.
- Twitter/X links often appear as both `twitter.com` and `x.com` — search for both.
- `t.co` short URLs in history indicate a click-through from Twitter.
- The `from_visit` column in `moz_historyvisits` links to the referring page, useful for tracing navigation chains.

## User's Request

$ARGUMENTS
