---
name: browser-history
description: Search the user's browsing history (Firefox or any Chromium-based browser — Chrome, Vivaldi, Brave, Edge, Arc, Chromium) by keyword, URL, or time. Auto-detects default browser. Use when the user wants to find something they looked at, recall a link, or see what they were browsing around a specific time.
argument-hint: [search term or question] [--browser=firefox|chrome|vivaldi|brave|edge|arc|chromium]
allowed-tools: Bash, Read
---

# Browser History Search

Help the user find pages from their browsing history. Auto-detect the default browser and query the right database. If the user explicitly names a browser (`--browser=firefox`, "search Firefox for…"), honour that override — useful when they're not sure which browser they were in.

## Step 1: Detect the default browser

Run this once at the start to get the engine and DB path. macOS reads LaunchServices; Linux uses xdg-settings.

```bash
detect_browser() {
  case "$OSTYPE" in
    darwin*)
      # Avoid $N references — the skill loader strips them when rendering into context.
      BUNDLE=$(defaults read ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure 2>/dev/null \
        | grep -B1 'LSHandlerURLScheme = https;' \
        | head -n 1 \
        | sed -E 's/.*"([^"]+)".*/\1/')
      APPSUP="$HOME/Library/Application Support"
      case "$BUNDLE" in
        org.mozilla.firefox)               ENGINE=firefox;  DB="$APPSUP/Firefox/Profiles/*.default-release/places.sqlite" ;;
        org.mozilla.firefoxdeveloperedition) ENGINE=firefox; DB="$APPSUP/Firefox/Profiles/*.dev-edition-default/places.sqlite" ;;
        com.google.chrome)                 ENGINE=chromium; DB="$APPSUP/Google/Chrome/Default/History" ;;
        com.vivaldi.vivaldi)               ENGINE=chromium; DB="$APPSUP/Vivaldi/Default/History" ;;
        com.brave.browser)                 ENGINE=chromium; DB="$APPSUP/BraveSoftware/Brave-Browser/Default/History" ;;
        com.microsoft.edgemac)             ENGINE=chromium; DB="$APPSUP/Microsoft Edge/Default/History" ;;
        company.thebrowser.browser)        ENGINE=chromium; DB="$APPSUP/Arc/User Data/Default/History" ;;
        org.chromium.Chromium)             ENGINE=chromium; DB="$APPSUP/Chromium/Default/History" ;;
        *) echo "Unknown bundle ID: $BUNDLE" >&2; return 1 ;;
      esac
      ;;
    *)
      DESKTOP=$(xdg-settings get default-web-browser 2>/dev/null)
      case "$DESKTOP" in
        firefox.desktop)                       ENGINE=firefox;  DB="$HOME/.mozilla/firefox/*.default-release/places.sqlite" ;;
        firefox-developer-edition.desktop)     ENGINE=firefox;  DB="$HOME/.mozilla/firefox/*.dev-edition-default/places.sqlite" ;;
        google-chrome.desktop)                 ENGINE=chromium; DB="$HOME/.config/google-chrome/Default/History" ;;
        vivaldi-stable.desktop|vivaldi.desktop) ENGINE=chromium; DB="$HOME/.config/vivaldi/Default/History" ;;
        brave-browser.desktop)                 ENGINE=chromium; DB="$HOME/.config/BraveSoftware/Brave-Browser/Default/History" ;;
        microsoft-edge.desktop)                ENGINE=chromium; DB="$HOME/.config/microsoft-edge/Default/History" ;;
        chromium.desktop|chromium-browser.desktop) ENGINE=chromium; DB="$HOME/.config/chromium/Default/History" ;;
        *) echo "Unknown default browser: $DESKTOP" >&2; return 1 ;;
      esac
      ;;
  esac
  # Resolve any glob in DB (Firefox profile dirs)
  DB=$(ls $DB 2>/dev/null | head -1)
  echo "engine=$ENGINE db=$DB"
}
detect_browser
```

If the user passed `--browser=NAME`, skip detection and set `ENGINE`/`DB` from the same table.

## Step 2: Copy the DB

The history DB is locked while the browser runs. Always copy first:

```bash
cp "$DB" /tmp/history_copy.sqlite
```

## Step 3: Query — branch on engine

### Firefox (`moz_places` + `moz_historyvisits`, unix-epoch µs)

```sql
-- Search by keyword (title or URL)
sqlite3 -header -column /tmp/history_copy.sqlite "
  SELECT datetime(v.visit_date/1000000,'unixepoch','localtime') as time,
         p.title, p.url
  FROM moz_historyvisits v JOIN moz_places p ON v.place_id=p.id
  WHERE p.title LIKE '%KEYWORD%' OR p.url LIKE '%KEYWORD%'
  ORDER BY v.visit_date DESC LIMIT 20;"

-- Activity around a timestamp (±30 min context window)
sqlite3 -header -column /tmp/history_copy.sqlite "
  SELECT datetime(v.visit_date/1000000,'unixepoch','localtime') as time,
         p.title, p.url
  FROM moz_historyvisits v JOIN moz_places p ON v.place_id=p.id
  WHERE datetime(v.visit_date/1000000,'unixepoch','localtime')
        BETWEEN 'YYYY-MM-DD HH:MM' AND 'YYYY-MM-DD HH:MM'
  ORDER BY v.visit_date;"

-- Browse a specific date
sqlite3 -header -column /tmp/history_copy.sqlite "
  SELECT datetime(v.visit_date/1000000,'unixepoch','localtime') as time,
         p.title, p.url
  FROM moz_historyvisits v JOIN moz_places p ON v.place_id=p.id
  WHERE date(v.visit_date/1000000,'unixepoch','localtime') = 'YYYY-MM-DD'
  ORDER BY v.visit_date;"
```

### Chromium (`urls` + `visits`, WebKit-epoch µs — offset 11644473600000000)

```sql
-- Search by keyword (title or URL)
sqlite3 -header -column /tmp/history_copy.sqlite "
  SELECT datetime((v.visit_time - 11644473600000000)/1000000,'unixepoch','localtime') as time,
         u.title, u.url
  FROM visits v JOIN urls u ON v.url = u.id
  WHERE u.title LIKE '%KEYWORD%' OR u.url LIKE '%KEYWORD%'
  ORDER BY v.visit_time DESC LIMIT 20;"

-- Activity around a timestamp
sqlite3 -header -column /tmp/history_copy.sqlite "
  SELECT datetime((v.visit_time - 11644473600000000)/1000000,'unixepoch','localtime') as time,
         u.title, u.url
  FROM visits v JOIN urls u ON v.url = u.id
  WHERE datetime((v.visit_time - 11644473600000000)/1000000,'unixepoch','localtime')
        BETWEEN 'YYYY-MM-DD HH:MM' AND 'YYYY-MM-DD HH:MM'
  ORDER BY v.visit_time;"

-- Browse a specific date
sqlite3 -header -column /tmp/history_copy.sqlite "
  SELECT datetime((v.visit_time - 11644473600000000)/1000000,'unixepoch','localtime') as time,
         u.title, u.url
  FROM visits v JOIN urls u ON v.url = u.id
  WHERE date((v.visit_time - 11644473600000000)/1000000,'unixepoch','localtime') = 'YYYY-MM-DD'
  ORDER BY v.visit_time;"
```

## Workflow

1. Detect default browser (or honour `--browser=` override). Tell the user which engine + browser you resolved to.
2. Copy the DB to `/tmp/history_copy.sqlite`
3. Pick the query block matching `$ENGINE`. Substitute keyword / date / time window.
4. If the user is looking for something they found *near* another page, find the anchor first, note its timestamp, then query a window around it.
5. Present results concisely — time, title, URL.
6. If too many results, narrow with extra filters or a tighter window.
7. Clean up: `rm /tmp/history_copy.sqlite`

## Tips

- Users often remember vaguely. Try multiple LIKE patterns if the first doesn't hit.
- Twitter/X links often appear as both `twitter.com` and `x.com` — search both. `t.co` short URLs indicate a click-through from Twitter.
- For navigation chains: Firefox has `moz_historyvisits.from_visit` → another visit row. Chromium has `visits.from_visit` → another visit row. Both join back to themselves.
- If the user can't remember which browser they were in, run the query against the other engine too — pass `--browser=` to force.
- Chromium profiles other than `Default` (e.g. `Profile 1`, `Profile 2`) live alongside `Default`. Firefox dev-edition uses `*.dev-edition-default` instead of `*.default-release`.

## User's Request

$ARGUMENTS
