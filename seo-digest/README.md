# 🔍 SEO Digest

> **Monday morning. Open Claude. Your weekly SEO report is already there.**
>
> SEO Digest pulls your Google Search Console data every week, finds what climbed, what dropped, and what's sitting on page 2 waiting to break through — then writes it in plain English so anyone on the team can act on it without logging into anything.

Built by POSIMYTH. MIT licensed. Free forever. **v1.0.0**

---

## The problem

Every Monday someone has to log into Search Console, dig through the data, figure out what moved, what dropped, what deserves attention — and then either remember it or explain it to the team. That takes 30-45 minutes and often just doesn't happen consistently.

Two weeks pass. Rankings drop. Nobody noticed.

## What SEO Digest does

Every Monday morning, SEO Digest automatically pulls your GSC data and delivers a plain-English report like this:

> *"This week 3 pages gained rankings — your post on Gutenberg blocks broke into the top 5. Your WordPress page builder article slipped from #7 to #14 and needs attention. You have 5 pages sitting on page 2 with over 1,000 impressions each — pushing even one of them to page 1 could add 100+ clicks per week."*

Then it tells you exactly which 3 things to do this week to get the most SEO impact.

---

## Commands

| Command | What it does | Delivery |
|---------|-------------|----------|
| `/seo-digest` | Weekly digest — last 7 days vs prior 7 days | ClickUp doc + local file |
| `/seo-digest 14d` | Same, but 14-day window | ClickUp doc + local file |
| `/seo-digest 30d` | Monthly view | ClickUp doc + local file |
| `/seo-digest-setup` | First-time setup — site, delivery, schedule | — |
| `/seo-digest-update` | Update to latest version | — |

---

## What the digest covers

### 🟢 Wins — pages that climbed
Pages that moved up 3+ positions this week, sorted by click gain. Specific numbers: moved from #8 to #5, gained 42 clicks.

### 🔴 Watch list — pages that dropped
Pages that lost 3+ positions or significant clicks. What fell, by how much, so you can investigate before it gets worse.

### 🎯 Page 2 targets — push these to page 1
Pages ranking 11-20 with high impressions. These are your highest-ROI content investments — a small ranking bump multiplies clicks 3-5×. Digest shows estimated click gain for each.

### ⚡ CTR gaps — good rankings, low clicks
Pages ranking on page 1 but with below-average click-through rates. No ranking work needed — just better title tags or meta descriptions. Digest shows exactly how many clicks you're leaving on the table per week.

### 🆕 New entrants
Pages that started showing in GSC this week for the first time.

### 🎯 This week's focus
3 specific, numbered actions — with exact page names, exact metrics, and exactly what to do. Not "improve your content." Something like: *"Update the title on /gutenberg-blocks/ — ranking #5, 3,200 impressions, 1.6% CTR. A better title could add 50 clicks/week without any ranking work."*

---

## Install

Open Claude Code and paste this into chat:

```
Install SEO Digest by running: curl -fsSL https://raw.githubusercontent.com/rohitposimyth-seo/seo-digest/main/install.sh | bash
```

Claude will show what the script does — click **Yes** to confirm. Then run `/seo-digest-setup` to configure your site in 2 minutes.

Quit Claude Code fully (**Cmd+Q** on Mac, **Alt+F4** on Windows) and reopen after install.

---

## How it connects

### 🔵 Google Search Console (required)

Connect via claude.ai → Settings → Connectors → **Google Search Console** → Connect.

Two clicks. Free. No API keys. Your data is read-only and stays on your machine — SEO Digest only reads your GSC data, never writes to it.

### 📋 ClickUp (optional — for doc delivery)

Connect via claude.ai → Settings → Connectors → **ClickUp** → Connect.

If connected, each weekly digest creates a new ClickUp doc in your chosen space and a task notification. If not connected, digest saves to a local file only.

---

## Daily usage

```
/seo-digest              # this week vs last week (default)
/seo-digest 14d          # 14-day view
/seo-digest 30d          # monthly view
```

Run it anytime for an on-demand report. If you scheduled Monday delivery during setup, it runs automatically and the report is waiting when you open Claude on Monday morning.

---

## Scheduling

During `/seo-digest-setup`, you can opt into automatic Monday delivery. SEO Digest uses Claude Code's built-in scheduler — no cron jobs, no external services, nothing running on a server.

The digest fires every Monday at 9 AM. The ClickUp doc is created, the local file is saved, and a task appears in your board.

---

## What SEO Digest will never do

- ❌ Make any changes to your site or Search Console account
- ❌ Send messages to any channel or group without your confirmation
- ❌ Upload your search data anywhere — everything stays on your machine
- ❌ Mix data from multiple sites in one report
- ❌ Give vague advice — every recommendation includes a specific page, a specific metric, and a specific action

---

## Local file location

Reports are saved to: `~/seo-digest/reports/YYYY-MM-DD-digest.md`

One file per run. Re-running the same day overwrites the file. All historical reports stay on your machine indefinitely.

---

## Update

```
/seo-digest-update
```

Downloads the latest skill files. Your config and all saved reports are never touched. Quit and reopen Claude Code after updating.

---

## Uninstall

```bash
rm -rf \
  ~/.claude/skills/seo-digest \
  ~/.claude/skills/seo-digest-setup \
  ~/.claude/skills/seo-digest-update \
  ~/.claude/seo-digest
```

Your `~/seo-digest/reports/` folder stays — it's just files, keep or delete as you like.

---

## Credits

Built by POSIMYTH. MIT licensed. Contributions welcome.

> **Repo:** [github.com/YOURUSERNAME/seo-digest](https://github.com/YOURUSERNAME/seo-digest)
