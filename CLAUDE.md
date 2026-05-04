# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Operational Rules & Guardrails

These rules are set by the site owner and must be followed at all times, **without exception**. These are hard stops — do not proceed if any rule would be violated.

---

### Rule 1 — Scope of Work (HARD LIMIT)
- Claude may **only** read or write **Blog posts** (`post` CPT) and **Docs pages** (`docs` CPT) on the live site via MCP
- **All other page types are strictly off-limits via MCP**, including but not limited to:
  - Homepage
  - Product pages / feature pages
  - Pricing pages
  - About / team pages
  - Landing pages
  - Any page that is not `post` or `docs` CPT
- **Exception:** Local content creation commands (`/landing-write`, `/landing-audit`, etc.) work on local files only — this restriction applies exclusively to live site access via MCP
- **Exception — `/copy-audit` command:** Landing pages, product pages, and pricing pages may be **read** (via `.md` fetch) for copy auditing purposes. Fixes may be **suggested** but never applied to these page types until the user gives **explicit confirmation** for each fix. This is read-only by default; write only on confirmed instruction.
- If unsure of a page's CPT, check before touching it. When in doubt, do nothing and ask.

---

### Rule 2 — Content Rules (NO REWRITING)
- **Never rewrite or alter the substance** of existing live content
- Only optimize: meta title, meta description, headings, keyword placement, internal links, structure
- Never generate or insert new body content directly onto the live site
- Never change the meaning, tone, or flow of any existing content

---

### Rule 3 — How to Fetch Site Content (MCP ONLY)
- **Always** use MCP to fetch live site content — use the correct server per site:
  - `nexterwp.com` → use MCP server `wp-nexterwp`
  - `uichemy.com` → use MCP server `wp-uichemy`
  - `theplusaddons.com` → use MCP server `wp-theplusaddons`
- **Never** use `curl`, `WebFetch`, `WebSearch`, or any direct HTTP scraping against production URLs as a substitute for MCP
- MCP is the only authorized, controlled access method for live site data

---

### Rule 4 — PHP & Server-Side Code (STRICT LIMITS)
- **Never write, create, or deploy `.php` files** to any server — no plugins, themes, mu-plugins, or custom scripts
- **Never run PHP that could crash the site** — no `$wpdb` queries, no `DELETE`, no schema changes, no option updates, no plugin/theme activation/deactivation
- **Never touch anything outside `post` and `docs` CPT** via PHP — no pages, no products, no menus, no widgets, no site settings
- **Only allowed PHP execution**: `novamira/execute-php` may be used **exclusively** for:
  - Reading posts/docs: `get_post`, `get_posts`, `get_post_meta`, `WP_Query` (for `post` and `docs` CPT only)
  - Creating posts/docs: `wp_insert_post` (for `post` and `docs` CPT only)
  - Updating posts/docs: `wp_update_post`, `update_post_meta` (for `post` and `docs` CPT only)
- **Only allowed changes on blog/docs posts** — content-level fields only:
  - **Allowed**: post title, post content (headings, text, paragraphs, internal links, keyword placement), meta title, meta description, categories, tags, post excerpt
  - **Never change**: post slug/URL, post author, post date, post status (unless publishing a new draft), post template, page attributes, custom post type, permalink structure
  - **Never change site-level settings** via any post update — no options, no menus, no theme settings, no redirects
- **Rewrite rule — preserve all images**: When rewriting/updating an existing post, **never remove, replace, or modify image blocks, image URLs, or media attachments**. All `<!-- wp:image -->` blocks, `<img>` tags, and featured images must remain exactly as they are in the original post.
- **Never operate on a site unless specifically asked** — do not proactively push content to any live site
- Rule 5 (confirm before updating) still applies to all PHP execution

---

### Rule 5 — Write Carefully, Confirm Before Updating
- Before writing anything to the live site via MCP, state clearly what will change and get confirmation
- Treat every MCP write operation as irreversible — double-check post ID, content type, and fields before saving
- Never bulk-update multiple posts in a single unconfirmed action
- If a command could affect more than one post, list all affected posts and confirm each

---

### Rule 6 — Always Fetch `.md` URLs, Never HTML (TOKEN EFFICIENCY)

**This is a hard rule for all WebFetch calls. HTML pages waste 70–80% of tokens on markup, scripts, and styles. Markdown is clean content only.**

#### For POSIMYTH-owned sites (nexterwp.com, uichemy.com, theplusaddons.com, posimyth.com, wdesignkit.com):
- **ALWAYS** append `.md` to the URL before fetching — no exceptions
- Pattern: `https://nexterwp.com/blog/post-slug/` → `https://nexterwp.com/blog/post-slug.md`
- These sites run a Markdown endpoint plugin — `.md` URLs are guaranteed to work
- Never fetch the HTML version of any POSIMYTH-owned URL

#### For competitor and external sites:
- **Always try `.md` first** — many modern sites (Ghost, Notion, GitHub, docs sites) support it
- If `.md` returns HTML or a 404, fall back to HTML fetch as a last resort
- Document in your notes when you fell back and why

#### Examples:
```
# WRONG — never do this for our sites
WebFetch: https://nexterwp.com/blog/best-wordpress-themes/

# CORRECT — always do this
WebFetch: https://nexterwp.com/blog/best-wordpress-themes.md
```

#### Scope:
- Applies to all commands that call WebFetch: `/article`, `/research`, `/cluster`, `/analyze-existing`, `/landing-research`, `/landing-competitor`, `/rewrite` (SERP analysis step), and any ad-hoc fetches
- Does NOT apply to MCP reads — MCP already returns clean structured data

---

## Project Overview

SEO Machine is an open-source Claude Code workspace for creating SEO-optimized blog content. It combines custom commands, specialized agents, and Python-based analytics to research, write, optimize, and publish articles for any business.

## Setup

```bash
pip install -r data_sources/requirements.txt
```

API credentials are configured in `data_sources/config/.env` (GA4, GSC, DataForSEO, WordPress). GA4 service account credentials go in `credentials/ga4-credentials.json`.

## Commands

All commands are defined in `.claude/commands/` and invoked as slash commands:

- `/research [topic]` - Keyword/competitor research, generates brief in `research/`
- `/write [topic]` - Create full article in `drafts/`, auto-triggers optimization agents
- `/rewrite [topic]` - Update existing content, saves to `rewrites/`
- `/optimize [file]` - Final SEO polish pass
- `/analyze-existing [URL or file]` - Content health audit
- `/performance-review` - Analytics-driven content priorities
- `/publish-draft [file]` - Publish to WordPress via REST API
- `/article [topic]` - Simplified article creation
- `/cluster [topic]` - Build complete topic cluster strategy with pillar + supporting articles + linking map
- `/priorities` - Content prioritization matrix
- `/research-serp`, `/research-gaps`, `/research-trending`, `/research-performance`, `/research-topics` - Specialized research commands
- `/landing-write`, `/landing-audit`, `/landing-research`, `/landing-publish`, `/landing-competitor` - Landing page commands

## Architecture

### Command-Agent Model

**Commands** (`.claude/commands/`) orchestrate workflows. **Agents** (`.claude/agents/`) are specialized roles invoked by commands. After `/write`, these agents auto-run: SEO Optimizer, Meta Creator, Internal Linker, Keyword Mapper.

Key agents: `content-analyzer.md`, `seo-optimizer.md`, `meta-creator.md`, `internal-linker.md`, `keyword-mapper.md`, `editor.md`, `headline-generator.md`, `cro-analyst.md`, `performance.md`, `cluster-strategist.md`.

### Python Analysis Pipeline

Located in `data_sources/modules/`. The Content Analyzer chains:
1. `search_intent_analyzer.py` - Query intent classification
2. `keyword_analyzer.py` - Density, distribution, stuffing detection
3. `content_length_comparator.py` - Benchmarks against top 10 SERP results
4. `readability_scorer.py` - Flesch Reading Ease, grade level
5. `seo_quality_rater.py` - Comprehensive 0-100 SEO score

### Data Integrations

- `google_analytics.py` - GA4 traffic/engagement data
- `google_search_console.py` - Rankings and impressions
- `dataforseo.py` - SERP positions, keyword metrics
- `data_aggregator.py` - Combines all sources into unified analytics
- `wordpress_publisher.py` - Publishes to WordPress with Yoast SEO metadata

### Opportunity Scoring

`opportunity_scorer.py` uses 8 weighted factors: Volume (25%), Position (20%), Intent (20%), Competition (15%), Cluster (10%), CTR (5%), Freshness (5%), Trend (5%).

## Running Python Scripts

```bash
# Research & analysis scripts (run from repo root)
python3 research_quick_wins.py
python3 research_competitor_gaps.py
python3 research_performance_matrix.py
python3 research_priorities_comprehensive.py
python3 research_serp_analysis.py
python3 research_topic_clusters.py
python3 research_trending.py
python3 seo_baseline_analysis.py
python3 seo_bofu_rankings.py
python3 seo_competitor_analysis.py

# Test API connectivity
python3 test_dataforseo.py
```

## Content Pipeline

`topics/` (ideas) → `research/` (briefs) → `drafts/` (articles) → `review-required/` (pending review) → `published/` (final)

Rewrites go to `rewrites/`. Landing pages go to `landing-pages/`. Audits go to `audits/`.

## Multi-Brand Architecture

This workspace manages **multiple brands**. Each brand has its own context folder inside `brands/`. The active brand's files are mirrored into `context/` so all commands (`/write`, `/rewrite`, etc.) automatically use the right brand.

### How It Works

```
brands/
  _template/          ← Copy when adding any new brand/client
  theplusaddons/      ← TPAE context (needs team to fill in)
  nexterwp/           ← NexterWP context (fully populated)
  uichemy/            ← UiChemy context (fully populated)
  posimyth/           ← POSIMYTH/WDesignKit context (needs team to fill in)
  TEAM-BRAND-SETUP.md ← Guide for team members filling in brand context
config/
  active-brand.md     ← Tracks current active brand
context/              ← Always mirrors the active brand (commands read from here)
context/shared/       ← Cross-product reference files (never overwritten by brand switch)
```

### Switching Brands

Use the `/brand` command:

```
/brand theplusaddons   → switch to TPAE context
/brand nexterwp        → switch to NexterWP context
/brand uichemy         → switch to UiChemy context
/brand posimyth        → switch to POSIMYTH context
/brand list            → see all brands
/brand status          → see what's active
```

### Per-Article Override (no global switch)

```
/write "topic" --brand nexterwp
/rewrite "file" --brand uichemy
/publish-draft "file" --brand theplusaddons
```

### Active Brands & MCP Servers

| Brand Slug | Domain | MCP Server | Status |
|---|---|---|---|
| `nexterwp` | nexterwp.com | `wp-nexterwp` | Fully populated |
| `uichemy` | uichemy.com | `wp-uichemy` | Fully populated |
| `theplusaddons` | theplusaddons.com | `wp-theplusaddons` | Needs context filled in |
| `posimyth` | posimyth.com / wdesignkit.com | — | Needs context filled in |

**Always use the correct MCP server for the site you're working on. Never mix servers.**

### Key Rules

- `context/` is **read-only output** — it mirrors whatever brand is active
- Always edit brand files inside `brands/[slug]/`, not in `context/`
- `context/shared/` is never overwritten by brand switches — it contains cross-product reference files
- `/write` and `/rewrite` show "Writing for brand: X" at the top so you always know which context is active

### What Changes Per Brand

When you switch brands, `context/` automatically loads the correct:
- Brand voice and tone (`brand-voice.md`)
- Product features and data points (`features.md`)
- Full product knowledge, facts & figures (`product-knowledge.md`)
- Complete URL inventory (`url-inventory.md`)
- Internal links and anchor texts (`internal-links-map.md`)
- Competitor positioning (`competitor-analysis.md`)
- SEO rules and keyword clusters (`seo-guidelines.md`, `target-keywords.md`)
- Article structure and CTA rules (`style-guide.md`)
- Writing style and examples (`writing-examples.md`)
- WordPress publishing config (`wordpress-config.md`)

### Content Pipeline Per Brand

Each brand uses **separate output folders** to avoid mixing drafts:

| Folder | Pattern |
|---|---|
| Research | `research/[brand-slug]/` |
| Drafts | `drafts/[brand-slug]/` |
| Published | `published/[brand-slug]/` |
| Rewrites | `rewrites/[brand-slug]/` |

> If sub-folders don't exist yet, create them before running `/write` or `/research`.

### Adding a New Client Brand

```
cp -r brands/_template brands/clientname
# Fill in their brand-voice.md, features.md, internal-links-map.md, etc.
/brand clientname
```

See `brands/TEAM-BRAND-SETUP.md` for the complete guide on filling in context files.

---

## Brand Context Files

### NexterWP — `brands/nexterwp/` (fully populated)
- `product-knowledge.md` - Full product facts: installs, ratings, pricing, features, USPs
- `url-inventory.md` - Complete URL inventory (550+ pages, crawled March 2026)
- `brand-voice.md` - Tone, 3 audience types, messaging pillars
- `features.md` - 3 core products, features, trust signals
- `internal-links-map.md` - All page URLs + anchor texts + linking rules
- `competitor-analysis.md` - Astra, Kadence, OceanWP, GeneratePress
- `seo-guidelines.md` - 20 SEO rules, pre-publish checklist, schema guide
- `target-keywords.md` - 8 keyword clusters, 5 content pillars
- `style-guide.md` - Post lengths, article template, CTA rules, formatting
- `writing-examples.md` - 3 reference posts + combined ideal style guide
- `blog-rewrite-rules.md` - Rules for rewriting existing blog posts
- `cro-best-practices.md` - Conversion rate optimization guidelines
- `wordpress-knowledge-base.md` - WordPress-specific knowledge
- `wordpress-config.md` - WP API config, MCP server, analytics IDs

### UiChemy — `brands/uichemy/` (fully populated)
- `product-knowledge.md` - Full product facts: installs, ratings, pricing, features, USPs
- `url-inventory.md` - Complete URL inventory
- `brand-voice.md` - Tone, 3 audience types (Figma designers, WP devs, agencies)
- `features.md` - 3 converters, core features, pricing, trust signals
- `internal-links-map.md` - All page URLs + anchor texts + linking rules
- `competitor-analysis.md` - Anima, Locofy, Figmentor, Essential Addons, Figma Dev Mode
- `seo-guidelines.md` - SEO rules, schema library (VideoObject, SoftwareApplication, etc.)
- `target-keywords.md` - 7 keyword clusters, 5 content pillars
- `style-guide.md` - Post lengths, article template, before/after pattern, CTA rules
- `writing-examples.md` - 2 UiChemy posts + Designlab style analysis + combined style guide
- `wordpress-config.md` - WP API config, MCP server, analytics IDs

### The Plus Addons — `brands/theplusaddons/` (needs team to fill in)
- `product-knowledge.md` - Pre-populated from shared TPAE data
- `url-inventory.md` - Pre-populated from shared TPAE URLs
- Template files for: `brand-voice.md`, `features.md`, `internal-links-map.md`, `target-keywords.md`, `competitor-analysis.md`, `blog-style-guide.md`, `writing-examples.md`
- `wordpress-config.md` - MCP server set to `wp-theplusaddons`

### POSIMYTH — `brands/posimyth/` (needs team to fill in)
- `product-knowledge.md` - Pre-populated from shared WDesignKit data
- `url-inventory.md` - Pre-populated from shared WDesignKit URLs
- `sticky-header-knowledge.md` + `sticky-header-urls.md` - Sticky Header product data
- Template files for: `brand-voice.md`, `features.md`, `internal-links-map.md`, `target-keywords.md`, `competitor-analysis.md`, `blog-style-guide.md`, `writing-examples.md`
- `wordpress-config.md` - No MCP server configured yet

### Cross-Product References — `context/shared/`
Product knowledge and URL inventories for cross-referencing in content:
- `tpae.md` + `tpae-urls.md` - The Plus Addons for Elementor
- `wdesignkit.md` + `wdesignkit-urls.md` - WDesignKit
- `sticky-header.md` + `sticky-header-urls.md` - Sticky Header Effects for Elementor

## WordPress Integration

Publishing uses the WordPress REST API with a custom MU-plugin (`wordpress/seo-machine-yoast-rest.php`) that exposes Yoast SEO fields. Articles are published in WordPress block format (HTML comments in Markdown files).
