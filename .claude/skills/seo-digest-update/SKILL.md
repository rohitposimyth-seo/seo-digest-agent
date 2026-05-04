---
name: seo-digest-update
description: "Update SEO Digest to the latest version. Downloads updated skill files, preserves your config. Triggers: update seo digest, seo digest update, upgrade seo digest"
metadata:
  version: 1.0.0
  author: SEO Digest by POSIMYTH
---

# SEO Digest Update

You are the SEO Digest updater. Pull the latest skill files without touching the user's config.

---

## Step 1 — Check Current Version

Read `~/.claude/seo-digest/config.json`.
Get the `version` field. If the file doesn't exist: "SEO Digest isn't set up yet. Run `/seo-digest-setup` first."

---

## Step 2 — Check Latest Version

Fetch: `https://raw.githubusercontent.com/YOURUSERNAME/seo-digest/main/VERSION`

This file contains a single version string like `1.2.0`.

If fetch fails: "Couldn't reach the update server. Check your internet connection and try again."

---

## Step 3 — Compare

If current version == latest version:
> "SEO Digest is already up to date (v[version]). Nothing to do."
Stop.

If update available: proceed.

---

## Step 4 — Download Updated Skills

Download these files and overwrite the local copies:

```
https://raw.githubusercontent.com/YOURUSERNAME/seo-digest/main/skills/seo-digest/SKILL.md
→ ~/.claude/skills/seo-digest/SKILL.md

https://raw.githubusercontent.com/YOURUSERNAME/seo-digest/main/skills/seo-digest-setup/SKILL.md
→ ~/.claude/skills/seo-digest-setup/SKILL.md

https://raw.githubusercontent.com/YOURUSERNAME/seo-digest/main/skills/seo-digest-update/SKILL.md
→ ~/.claude/skills/seo-digest-update/SKILL.md
```

**Never touch** `~/.claude/seo-digest/config.json` — this is the user's settings, not ours to overwrite.

---

## Step 5 — Update Version in Config

Read `~/.claude/seo-digest/config.json`, update only the `version` field to the new version, write it back.

---

## Step 6 — Done

```
✅ SEO Digest updated: v[old] → v[new]

Quit Claude Code (Cmd+Q on Mac / Alt+F4 on Windows) and reopen it to activate the new version.

Your config and reports are untouched.
```
