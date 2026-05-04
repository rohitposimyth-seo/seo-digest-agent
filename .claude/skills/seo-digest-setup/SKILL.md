---
name: seo-digest-setup
description: "First-time setup for SEO Digest — configures GSC property, ClickUp delivery, and weekly schedule. Run once before using /seo-digest. Triggers: seo digest setup, setup seo digest, configure seo digest, seo digest first time"
metadata:
  version: 1.0.0
  author: SEO Digest by POSIMYTH
---

# SEO Digest Setup

Walk through setup conversationally. Be fast — the whole thing takes 2 minutes. Ask one question at a time. Don't dump all questions at once.

---

## Step 1 — Check GSC Connection

Call `mcp__gsc__list_sites`.

**If it works:** List the properties found. Move to Step 2.

**If it fails or returns empty:**
Tell the user:

> "Google Search Console isn't connected yet. Here's how to connect it:
> 1. Go to claude.ai → Settings → Connectors
> 2. Find Google Search Console → click Connect
> 3. Authorize your Google account
> 4. Quit Claude Code (Cmd+Q on Mac / Alt+F4 on Windows) and reopen it
> 5. Run `/seo-digest-setup` again
>
> Takes about 60 seconds."

Stop here. Do not continue setup until GSC is connected.

---

## Step 2 — Select GSC Property

If only one GSC property exists: confirm it with the user ("I found one site: [url]. Is this the one you want to track? Yes / No").

If multiple properties exist: show them numbered and ask which to use.

Wait for the answer. Store as `gsc_property`.

Derive `site_name`:
- `https://nexterwp.com/` → `NexterWP`
- `https://uichemy.com/` → `UiChemy`
- `https://theplusaddons.com/` → `The Plus Addons`
- For anything else: take the domain name, remove www., capitalize first letter.

---

## Step 3 — Brand Terms

Ask:

> "What's your brand name? I'll use this to separate branded searches (people typing your company name) from real SEO traffic in the digest.
>
> Example: for NexterWP you'd enter: nexterwp, nexter wp, nexter blocks
> Enter your brand variations separated by commas:"

Wait for input. Store as `brand_terms` array (lowercase, trimmed).

If they skip or say "not sure": default to deriving from the domain name (e.g., `nexterwp.com` → `["nexterwp"]`) and tell them they can update it later by re-running `/seo-digest-setup`.

---

## Step 4 — DataForSEO Enrichment

Ask:

> "DataForSEO enrichment adds real search volume and keyword difficulty to your quick-win opportunities, and detects which competitor took your ranking when a page drops. Do you want this enabled?
> Yes / No
>
> (Requires DataForSEO MCP to be connected. It uses a small number of API credits per digest run.)"

Store as `dataforseo_enabled` (true/false).

If yes: try calling `mcp__dfs-mcp__serp_locations` as a connectivity check.
- If it works: "DataForSEO is connected. Enrichment enabled."
- If it fails: "DataForSEO MCP isn't connected yet. I'll set it to disabled for now — you can enable it later by re-running setup after connecting DataForSEO in your Claude settings." Set `dataforseo_enabled = false`.

---

## Step 5 — ClickUp Delivery

Ask:

> "Where should I send your weekly SEO digest?
> 1. ClickUp doc (creates a new doc in your workspace each Monday)
> 2. Local file only (saved to ~/seo-digest/reports/ on your machine)
> 3. Both (ClickUp doc + local file)"

Wait for their choice.

**If they chose ClickUp (1 or 3):**

Try to call `mcp__clickup__clickup_get_workspace_hierarchy`.

If it works: list the top-level spaces and ask "Which ClickUp space should the digest go into?" Store the selected space's list_id.

If ClickUp MCP fails or isn't connected: say:
> "ClickUp isn't connected yet. You can connect it at: claude.ai → Settings → Connectors → ClickUp → Connect.
> For now I'll set you up with local file delivery. You can re-run `/seo-digest-setup` to add ClickUp later."
Set `clickup.enabled = false`.

**If they chose local only (2):**
Set `clickup.enabled = false`. Continue.

---

## Step 6 — ClickUp DM Notification

Only ask this if ClickUp is connected (step 5 succeeded).

Ask:

> "Want me to send you a personal ClickUp DM each time the digest runs? It'll be a short summary — clicks, impressions, and your 3 focus actions for the week.
> Yes / No"

**If yes:**

Ask:
> "What's your full name in ClickUp? (e.g. Rohit Bansode)"

Call `mcp__clickup__clickup_find_member_by_name` with their name.

- If found: confirm "Found you — [username]. Got it."
- If not found: "Couldn't find that name in the workspace. Check it matches exactly what's in ClickUp and re-run setup." Set `clickup_notify.enabled = false` and continue.

Then call `mcp__clickup__clickup_get_chat_channels` with `include_hidden: true`.
- Filter to type `DM`
- Find the most recently active DM channel where `creator` matches the user's ID
- Store that channel's `id` as `clickup_notify.channel_id`

Store:
```json
"clickup_notify": {
  "enabled": true,
  "username": "[their ClickUp username]",
  "user_id": [their numeric user ID],
  "channel_id": "[DM channel id]"
}
```

**If no:**
```json
"clickup_notify": {
  "enabled": false
}
```

---

## Step 7 — Drop Threshold

Ask:

> "How many positions does a page need to drop before I flag it as a concern?
> Default is 5 — so a page that falls from #8 to #13 gets flagged. Want to keep that, or change it? (Enter a number or press Enter for 5)"

Store as `drop_threshold`. Default: 5.

---

## Step 7 — Save Config

If `~/.claude/seo-digest/config.json` already exists, read it first and merge — add the new site into the existing `sites` dict rather than overwriting the whole file.

Write to `~/.claude/seo-digest/config.json`:

```json
{
  "sites": {
    "[site-slug]": {
      "gsc_property": "[selected property URL]",
      "site_name": "[derived site name]",
      "brand_terms": ["[term1]", "[term2]"]
    }
  },
  "drop_threshold": 5,
  "dataforseo_enabled": true,
  "dataforseo_location": "United States",
  "clickup": {
    "enabled": true_or_false,
    "list_id": "[list id or null]",
    "space_name": "[space name or null]"
  },
  "clickup_notify": {
    "enabled": true_or_false,
    "username": "[ClickUp username or null]",
    "user_id": null_or_numeric_id,
    "channel_id": "[DM channel id or null]"
  },
  "email": {
    "enabled": false,
    "address": null
  },
  "local_reports_path": "~/seo-digest/reports/",
  "version": "2.0.0",
  "setup_date": "[today YYYY-MM-DD]"
}
```

The site-slug is derived from the domain: `nexterwp.com` → `nexterwp`, `theplusaddons.com` → `theplusaddons`, `uichemy.com` → `uichemy`. For other domains: lowercase the domain name, remove www. and .com/.net etc.

To add a second site later, the user just runs `/seo-digest-setup` again — it adds the new site to the existing `sites` dict without touching the other settings.

Also create the directory `~/seo-digest/reports/`.

---

## Step 7b — Windows Path Fix (Windows only)

Run: `python3 -c "import sys; print(sys.platform)"` to detect the OS.

**Only if result is `win32`:**

Run: `python3 -c "import pathlib; print(pathlib.Path.home())"` to get the absolute home directory (e.g. `C:/Users/Username`).

Then update two files to replace `~` with the absolute home path — this is required because Windows does not expand `~` in scheduled remote agent sessions:

1. **`~/.claude/skills/seo-digest/SKILL.md`** — replace every occurrence of `~/seomachine/` with `[home]/seomachine/`
2. **`~/.claude/seo-digest/config.json`** — replace `~/seo-digest/reports/` with `[home]/seo-digest/reports/`

Confirm silently. Do not mention this to the user unless the file edits fail.

**If not `win32`:** skip this step entirely.

---

## Step 8 — Schedule

Ask:

> "Want me to run this automatically every Monday morning so it's waiting for you when you start work?
> Yes / No"

**If yes:**

Use `mcp__scheduled-tasks__create_scheduled_task` to create a weekly recurring task:
- Schedule: every Monday at 9:00 AM (in the user's local timezone if known)
- Prompt: `/seo-digest`
- Label: `Weekly SEO Digest — [site_name]`

Confirm: "Done. You'll get an SEO digest every Monday morning. Run `/seo-digest` anytime for an on-demand report."

**If no:**

"No problem. Just run `/seo-digest` whenever you want a report."

---

## Step 9 — Done

Print a confirmation summary:

```
✅ SEO Digest is ready.

Site:         [site_name] · /seo-digest [site-slug]
Brand filter: [brand_terms joined by ", "]
Drop alert:   [drop_threshold]+ positions
DataForSEO:   [Enabled / Disabled]
Delivery:     [ClickUp — space_name / Local only / ClickUp + Local]
DM notify:    [ClickUp DM → username / Disabled]
Schedule:     [Every Monday 9am / Manual only]

Run /seo-digest now to get your first report.
Run /seo-digest-setup anytime to change these settings.
```
