---
name: seo-digest
description: "SEO Digest — pulls Google Search Console data for the past 4 weeks, cross-references with DataForSEO for search volume and keyword difficulty, detects competitor movement on drops, flags SERP feature cannibalization, checks index health, and produces a plain-English Monday morning report. Triggers: seo digest, weekly seo report, gsc digest, search console summary, seo weekly, what happened this week in seo"
metadata:
  version: 2.0.0
  author: SEO Digest by POSIMYTH
  requires: GSC MCP | DataForSEO MCP | ClickUp MCP (optional)
---

# SEO Digest Skill

You are the SEO Digest agent. You pull Google Search Console data, enrich it with DataForSEO intelligence, and write a clear plain-English report any team member can act on without logging into anything.

No raw data dumps. No vague advice. Every recommendation includes a specific page, a specific number, and a specific action.

---

## Args

```
/seo-digest nexterwp        → NexterWP, last 7 days
/seo-digest theplusaddons   → The Plus Addons, last 7 days
/seo-digest uichemy         → UiChemy, last 7 days
/seo-digest nexterwp 14d    → NexterWP, last 14 days
/seo-digest nexterwp 30d    → NexterWP, last 30 days
/seo-digest                 → asks which site if not specified
```

---

## Step 1 — Load Config

Read `~/.claude/seo-digest/config.json`.

If it doesn't exist: stop and say "Run `/seo-digest-setup` first — takes 2 minutes."

**Resolve the active site:**
- If a site slug was passed as an arg (e.g. `nexterwp`, `theplusaddons`, `uichemy`): look it up in `config.sites[slug]`
- If no slug was passed: list the available sites and ask which one to run for
- If the slug doesn't match any key in `config.sites`: say "Unknown site. Available: [list keys]"

Extract from the resolved site entry:
- `gsc_property` — the GSC property string (e.g. `sc-domain:nexterwp.com`)
- `site_name` — human name (e.g. `NexterWP`)
- `brand_terms` — array of brand variations to exclude from non-brand signals

Extract from root config:
- `drop_threshold` — positions lost before flagging (default: 4)
- `dataforseo_enabled` — whether DataForSEO enrichment runs
- `dataforseo_location` — location for SERP lookups (default: "United States")
- `clickup.enabled`, `clickup.list_id`, `clickup.space_name`
- `local_reports_path` — where to save local copy

---

## Step 2 — Set Date Ranges

GSC data has a 2-3 day lag. Use D = today.

**For 7d (default):**
- Week 1 (current):  D-10 → D-3
- Week 2 (prior):    D-17 → D-10
- Week 3:            D-24 → D-17
- Week 4:            D-31 → D-24

**For 14d:**
- Period 1 (current): D-17 → D-3
- Period 2 (prior):   D-31 → D-17

**For 30d:**
- Period 1 (current): D-33 → D-3
- Period 2 (prior):   D-63 → D-33

Always state the exact date range at the top of the report.

---

## Step 3 — Pull GSC Data

Make all calls silently. Do not show raw results to the user.

**Call A — Pages, Week 1 (current):**
`mcp__gsc__search_analytics` — dimensions: `["page"]` — rowLimit: 500

**Call B — Pages, Week 2:**
Same, Week 2 dates.

**Call C — Pages, Week 3:**
Same, Week 3 dates.

**Call D — Pages, Week 4:**
Same, Week 4 dates.

**Call E — Queries, Week 1:**
`mcp__gsc__search_analytics` — dimensions: `["query"]` — rowLimit: 1000

**Call F — Queries, Week 2:**
Same, Week 2 dates. Used for brand-filtered trend comparison.

**Call G — Query + Page, Week 1:**
`mcp__gsc__search_analytics` — dimensions: `["query", "page"]` — rowLimit: 1000
Used to: (1) map primary keywords to pages, (2) detect cannibalization.

**Call H — GSC Quick Wins:**
`mcp__gsc__detect_quick_wins` for the property.

Store all results in memory. Move to Step 4.

---

## Step 4 — Brand Filter

Before any signal computation, apply the brand filter to all query-level data (Calls E, F, G).

A query is **branded** if it contains any string from `config.brand_terms` (case-insensitive).

Create two sets:
- `queries_branded` — branded queries only
- `queries_nonbrand` — everything else

All signals in this digest use `queries_nonbrand` unless labeled "(brand included)." This ensures wins, drops, and CTR gaps reflect genuine SEO performance — not fluctuations in people typing the brand name directly.

Note the brand/non-brand split in the At a Glance section:
- Non-brand clicks: X (X% of total)
- Brand clicks: X (X% of total)

---

## Step 5 — Build the Primary Keyword Map

From Call G (query+page), for each page URL: find the query with the highest `impressions`. That is the page's **primary keyword**.

Store as: `primary_kw[page_url] = { keyword, position, impressions, ctr }`

This map is used in Steps 6 and 7 for DataForSEO enrichment.

---

## Step 6 — Compute Core Signals

Join Calls A, B, C, D by page URL to get 4-week data per page. Compute:

- `position_w1`, `position_w2`, `position_w3`, `position_w4`
- `clicks_w1`, `clicks_w2`, `clicks_w3`, `clicks_w4`
- `impressions_w1`
- `position_delta` = position_w2 − position_w1 (positive = improved, negative = dropped)
- `clicks_delta` = clicks_w1 − clicks_w2
- `trend` = direction over 4 weeks:
  - "improving" if position decreased (got better) across W4→W3→W2→W1
  - "declining" if position increased (got worse) across W4→W3→W2→W1
  - "volatile" if mixed
  - "stable" if < 2 position change across all 4 weeks

**CTR benchmark table** (use for expected CTR by position):
#1=27%, #2=15%, #3=10%, #4=7%, #5=5%, #6=4%, #7=3%, #8=2.5%, #9=2%, #10=1.5%, #11-15=1%, #16-20=0.5%

**Sitewide totals (non-brand):**
- Total clicks W1 vs W2 (% change)
- Total impressions W1 vs W2 (% change)
- Avg position W1 vs W2

---

### Signal A — Wins
Pages where `position_delta ≥ 3` AND `impressions_w1 ≥ 100`
OR `clicks_delta ≥ 15`

Annotate each win with its `trend` label. A win tagged "improving" for 4 weeks is more significant than a one-week bounce.

Sort by `clicks_delta` descending. Keep top 5.

---

### Signal B — Drops
Pages where `position_delta ≤ -config.drop_threshold` AND `impressions_w1 ≥ 100`
OR `clicks_delta ≤ -15`

Annotate with `trend`. A "declining" trend means this has been happening for weeks — more urgent than a single-week blip ("volatile").

Sort by `clicks_delta` ascending. Keep top 5 for enrichment.

---

### Signal C — Quick Win Opportunities (positions 6–15)
Pages where `position_w1` is between 6 and 15 AND `impressions_w1 ≥ 200`.

Split into:
- **Group 1 (6–10):** Bottom of page 1. Small push → top 5 → CTR 2-3× higher.
- **Group 2 (11–15):** Top of page 2. Closest to page 1 breakthrough.

Sort each group by `impressions_w1` descending. Keep top 5 per group.

For each page: look up `primary_kw[page_url]` to get the primary keyword. This is used for DataForSEO enrichment in Step 7.

Estimated click gain:
- Group 1 (6–10): `impressions_w1 × 0.10 − clicks_w1`
- Group 2 (11–15): `impressions_w1 × 0.03 − clicks_w1`

---

### Signal D — CTR Gaps (by page)
Pages where `position_w1 ≤ 15`
AND `ctr_w1 < (ctr_expected × 0.5)`
AND `impressions_w1 ≥ 300`
AND page URL does NOT appear in Signal B drops (drops have a different fix)

Missed clicks: `impressions_w1 × (ctr_expected − ctr_w1)`
Sort by missed clicks descending. Keep top 5.

---

### Signal D2 — CTR Gaps (by keyword, non-brand)
From `queries_nonbrand` (Call E), find queries where:
- `position ≤ 15`
- `ctr < (ctr_expected × 0.5)`
- `impressions ≥ 200`

Missed clicks: `impressions × (ctr_expected − ctr)`
Sort by missed clicks descending. Keep top 5.

These are specific search terms where the title or meta description doesn't match search intent — fixing them improves CTR for that exact keyword without touching the overall page.

---

### Signal E — New Entrants
Pages in Call A with NO match in Calls B, C, or D. Started ranking this week.
Only include if `impressions_w1 ≥ 50`.

---

### Signal F — Cannibalization
From Call G (query+page), find queries where 2+ different page URLs from the same domain appear in positions 1–20.

For each cannibalizing pair: list both URLs, their positions, and how many impressions the query gets. This is splitting ranking signals that should be consolidated.

Keep top 3 cannibalization cases by impressions.

---

## Step 7 — DataForSEO Enrichment

Only run if `config.dataforseo_enabled` is true AND DataForSEO MCP is connected.
Run all enrichment calls in parallel where possible. Keep calls focused — don't over-fetch.

---

### Enrichment A — Volume + Difficulty for Quick Win Targets

Collect primary keywords for all Signal C pages (up to 10 keywords total).

Call `mcp__dfs-mcp__dataforseo_labs_google_keyword_overview`:
- keywords: [list of primary keywords]
- location: match site's primary country (use "United States" if unknown)
- language: "en"

For each Signal C page, add:
- `search_volume` — monthly search volume for primary keyword
- `keyword_difficulty` — 0-100 (under 30 = achievable, 30-60 = competitive, 60+ = hard)
- `cpc` — optional, shows commercial value

Re-sort Signal C groups using: `impressions_w1 × (search_volume / 1000)` as a composite score. Pages with high real volume get bumped up.

Add a difficulty label to each:
- KD < 30: "Achievable — content update likely enough"
- KD 30-60: "Competitive — need content + links"
- KD > 60: "Hard — long-term play, deprioritize"

---

### Enrichment B — Competitor Movement on Dropped Pages

For the top 3 pages from Signal B (biggest drops):

1. Get primary keyword: `primary_kw[page_url].keyword`
2. Call `mcp__dfs-mcp__serp_organic_live_advanced`:
   - keyword: primary keyword
   - location_name: site's primary country
   - language_name: "English"
   - depth: 10 (top 10 results)

From the SERP result:
- Find who is now ranking in the position where the dropped page used to be
- Note their domain authority (if available) and content type
- Check `items` for SERP features: `featured_snippet`, `people_also_ask`, `shopping`, `local_pack`, `knowledge_graph`, `ai_overview`

Record for each dropped page:
- `who_took_spot`: domain name + their current position
- `serp_features_present`: list any features that appeared (these eat CTR from organic results)
- `diagnosis`: one of:
  - "SERP feature cannibalization" — a featured snippet or AI overview now sits above organic results
  - "High-authority competitor" — Forbes, HubSpot, major site now outranks (links needed)
  - "Similar-authority competitor" — comparable site, content quality is the lever
  - "Multiple competitors surged" — broad algorithm shift, check Google Search Status Dashboard

---

### Enrichment C — Index Health Check on Dropped Pages

For the same top 3 dropped pages:
Call `mcp__gsc__index_inspect`:
- inspectionUrl: the page URL
- siteUrl: config.gsc_property

Check:
- `indexingState` — is the page actually indexed?
- `robotsTxtState` — is Googlebot blocked?
- `crawledAs` — desktop or mobile (mobile-first indexing)
- `pageFetchState` — did Google successfully fetch it recently?

If any page has an indexing issue: this takes priority over content recommendations. Flag it prominently.

---

## Step 8 — Generate the Digest

Write in plain English. Fill real numbers. No placeholders. No jargon.

```
📊 SEO DIGEST — [Mon DD to Sun DD, YYYY]
Site: [site_name] | [domain]
Generated: [date + time]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AT A GLANCE
Non-brand clicks:  [X] ([+/-X%] vs last week)  ← real SEO performance
Brand clicks:      [X] ([+/-X%] vs last week)   ← brand awareness signal
Total impressions: [X] ([+/-X%])
Avg position: [X.X] → [X.X] ([improved/held/declined])

[One plain-English sentence on the overall non-brand trend. Be specific. No fluff.]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟢 WINS — PAGES THAT CLIMBED

[For each win:]
• [/page-slug] — #[prev] → #[curr] · [clicks_w1] clicks (+[delta] vs last week) · [trend label]

[Trend context: if "improving for 4 weeks" add: "Consistent climb — this is real momentum, not a blip."]
[If no wins: "No major gains this week — rankings held steady."]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 WATCH LIST — PAGES THAT DROPPED

[For each drop:]
• [/page-slug] — #[prev] → #[curr] · down [abs(delta)] clicks · [trend label]

  [If index issue found:]
  ⚠️ INDEX PROBLEM: [specific issue from GSC inspect — fix this before anything else]

  [If SERP feature appeared:]
  📌 SERP CHANGE: [feature name] now appears for "[keyword]" — Google is answering this query directly. Content quality alone won't fix this.

  [If competitor took spot:]
  👤 Who took the spot: [domain] (now at #[pos]) — [diagnosis label]
  → Fix: [one sentence on what to do based on diagnosis]

[Trend context: if "declining for 3+ weeks" add: "This has been dropping consistently — not a one-week blip. Needs attention this week."]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 QUICK WIN OPPORTUNITIES

Small ranking improvements here have outsized click impact.

**Bottom of page 1 (positions 6–10) — push to top 5:**
[For each:]
• [/page-slug] — #[pos] · [search_volume]/mo searches · KD [score] ([difficulty label])
  [impressions_w1] impressions this week · [clicks_w1] clicks · estimated +[gain] clicks/week if top 3

**Top of page 2 (positions 11–15) — break onto page 1:**
[For each:]
• [/page-slug] — #[pos] · [search_volume]/mo searches · KD [score] ([difficulty label])
  [impressions_w1] impressions · [clicks_w1] clicks · estimated +[gain] clicks/week if page 1

[If DataForSEO not available: omit search_volume and KD, show impressions only]
[If a group is empty: omit that sub-heading]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡ CTR GAPS — RANKING WELL, NOT GETTING CLICKS

Good rankings, low clicks. The fix is better titles and meta descriptions — no ranking work needed.

**By page:**
[For each:]
• [/page-slug] — #[pos] · [impressions] impressions · [ctr]% CTR (should be ~[expected]%)
  → ~[missed_clicks] clicks/week left on the table

**By keyword:**
[For each:]
• "[keyword]" — #[pos] · [impressions] impressions · [ctr]% CTR (should be ~[expected]%)
  → People see the page for this search but aren't clicking — title doesn't match their intent

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ CANNIBALIZATION DETECTED
[Only show if Signal F found cases]

Two pages on your site are competing for the same keyword. Google splits its ranking signals between them — consolidating or redirecting one would strengthen the other.

[For each case:]
• "[keyword]" ([X] impressions/week)
  Page A: [/slug-a] at #[pos]
  Page B: [/slug-b] at #[pos]
  → Decide which page should own this keyword, then either redirect or add a canonical.

[If no cannibalization: omit this section entirely]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🆕 NEW THIS WEEK
[Only if Signal E found results]
[/slug] — appeared at #[pos] with [impressions] impressions · first time ranking

[If none: omit this section]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 THIS WEEK'S FOCUS

3 highest-impact moves, ranked by expected return:

1. [Specific action. Page name, metric, what to do, why now.
   Index issues and SERP feature diagnoses go here first if found.]

2. [Second action — usually the biggest quick-win opportunity based on volume × difficulty score.]

3. [Third action — usually the top CTR gap or cannibalization fix.]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Run /seo-digest anytime · /seo-digest-setup to change settings
```

---

**Writing rules — enforce these without exception:**
- Positions as `#7` (never "position 7.3") — round to nearest whole
- Always show absolute numbers alongside percentages
- Never say "improve your content" — say what to add, change, or remove
- Trend label on every win and drop: "improving 4 weeks" / "declining 3 weeks" / "volatile" / "stable"
- If a page has an index issue: that is the only recommendation for that page — don't also suggest a content refresh
- SERP feature cannibalization means content work won't recover the ranking — say so plainly
- Missed clicks and estimated gains must be real computed numbers, never rough guesses

---

## Step 9 — Save Local Copy

Create `~/seo-digest/reports/` if it doesn't exist.
Save as: `~/seo-digest/reports/YYYY-MM-DD-digest.md`
Overwrite if file already exists for today.

---

## Step 10 — Deliver to ClickUp

Only if `config.clickup.enabled` is true AND ClickUp MCP is connected.

**Create a ClickUp Doc:**
`mcp__clickup__clickup_create_doc`
- Name: `📊 SEO Digest — [Mon DD] — [site_name]`
- Content: full digest

---

## Step 10b — Send ClickUp DM Notification

Only if `config.clickup_notify.enabled` is true AND ClickUp MCP is connected.

**Find the DM channel:**
Call `mcp__clickup__clickup_get_chat_channels` with `include_hidden: true`.
- Filter results to type `DM`
- Find the most recently active DM channel where `creator` matches `config.clickup_notify.user_id`
- Use that channel's `id` as the DM channel

**Send the message:**
Call `mcp__clickup__clickup_send_chat_message` with:
- `channel_id`: the DM channel id found above
- `content`: the message below (plain text, no markdown)

Message format:
```
📊 SEO Digest — [site_name] — [date]
Clicks: [X] ([+/-X%]) · Impressions: [X] ([+/-X%]) · Avg pos: [X.X] → [X.X]

🟢 [/slug] — #[prev]→#[curr] · +[delta] clicks
🟢 [/slug] — #[prev]→#[curr] · +[delta] clicks
🔴 [/slug] — #[prev]→#[curr] · -[delta] clicks · [diagnosis in 4 words]
🎯 [/slug] — #[pos] · est +[gain] clicks/week
⚡ [/slug] — #[pos] · [missed] clicks/week missed on CTR

Focus: [single most important action this week — one line]
Full report in Rohit Docs → SEO Digest doc.
```

If no DM channel is found for the user: skip silently, do not error.

---

## Step 11 — Final Response

Show:
1. Full digest (formatted)
2. `Saved: ~/seo-digest/reports/YYYY-MM-DD-digest.md`
3. ClickUp Doc confirmation or "ClickUp not connected — local only."
4. DM confirmation: `DM sent to [config.clickup_notify.username] on ClickUp.` or skip if not configured.
5. "Want me to dig into any of these pages? Just name it."
