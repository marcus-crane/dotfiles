---
name: browserless-fetch
description: Fetch a webpage via Browserless. Use when you need to retrieve content from a URL that WebFetch can't access (403s, JS-rendered pages, etc.).
argument-hint: <url>
allowed-tools: Bash
---

# Fetch a URL via Browserless

Run `bfetch` with the target URL. It handles credentials internally.

```bash
bfetch "$ARGUMENTS" | python3 -c "
import sys
from html.parser import HTMLParser

class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.text = []
        self.skip = False
    def handle_starttag(self, tag, attrs):
        if tag in ('script', 'style', 'nav', 'header'):
            self.skip = True
    def handle_endtag(self, tag):
        if tag in ('script', 'style', 'nav', 'header'):
            self.skip = False
    def handle_data(self, data):
        if not self.skip and data.strip():
            self.text.append(data.strip())

p = TextExtractor()
p.feed(sys.stdin.read())
print('\n'.join(p.text))
"
```

Present the extracted text to the user. If `bfetch` exits non-zero, report the error — it means either credentials aren't configured (`/browserless:auth`) or the URL is unreachable.
