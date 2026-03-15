---
name: predict-content
description: Predict what an article will say, then score how much it exceeded the prediction. Use when the user wants to evaluate whether an article is worth reading.
argument-hint: <url>
allowed-tools: WebFetch
---

# Score Article

Evaluate the article at the URL provided in `$ARGUMENTS`.

## Step 1 — Fetch

Use `WebFetch` to retrieve the article content from the URL.

## Step 2 — Predict

Based only on the title and source domain, write what you would tell someone who asked you about this topic. This represents what someone could learn without reading the article — the "LLM baseline."

In your thinking, exhaust your knowledge of this topic before writing your prediction — cover the standard explanations, common misconceptions, and typical expert takes. The more complete your prediction, the more honest the scoring.

## Step 3 — Score the delta

After reading the full content, rate how much the article exceeds your prediction:

- **`-`** Your prediction covered it. This is a restatement of common knowledge.
- **`.`** Your prediction got the gist but missed useful nuance. A good read, but the ideas are findable elsewhere with effort.
- **`+`** Your prediction was wrong or incomplete in a way that matters. The article contains signal you'd lose if you never read it.

A `+` means one of:
- **Novel information**: primary experience, insider context, non-public knowledge, or historical detail that isn't in the common record.
- **Novel connection**: links ideas you'd know separately in a way that changes how you'd reason or act. Not just "A relates to B" but "A causes B, which means you should do C differently."

Most articles are well-written restatements of accessible knowledge. Default to `.`. Expect ~70% `.`, ~20% `-`, ~10% `+`.

## Step 4 — Present results

Show the user:

1. The score (`-`, `.`, or `+`) with a one-line summary
2. Your **prediction** (what you'd have said without reading the article)
3. If scored `.` or `+`: the **delta** (what was new beyond your prediction)
4. If scored `+`: the **delta type** (novel information or novel connection)
5. Brief reasoning for the score
6. **Tags**: 3-5 short topic tags (e.g. "distributed-systems", "privacy", "nz-politics")
7. **The jury**:
   - **Case for reading**: The strongest argument for why this is worth the reader's time
   - **Case for skimming**: If the reader only has 5 minutes, what sections or passages contain the real value? Be specific — cite sections, arguments, or examples worth slowing down for
   - **Case for skipping**: The strongest honest argument for deleting this from a reading backlog — consider: is the core insight summarisable in a sentence? Has the topic moved on since publication? Would asking an LLM get you 90% of the value?
8. **Follow up**: 3-5 specific search queries or keywords for someone who wants to go deeper on the most interesting threads
