# Rewrite Command — Brand Aware

Use this command to update and improve existing blog posts based on analysis findings, live SEO data, and brand-specific structure rules.

## Usage
`/rewrite [topic, URL, or analysis file]`
`/rewrite [topic, URL, or analysis file] --brand [slug]`

---

## BRAND DETECTION (RUNS FIRST — BEFORE ANYTHING ELSE)

1. If `--brand [slug]` was passed in the arguments, use that slug as the active brand
2. Otherwise, read `config/active-brand.md` to get the active brand slug
3. Confirm at the top of your response:

```
Writing for brand: [slug]
Domain: [domain]
MCP Server: [mcp-server]
Context: context/ (loaded from brands/[slug]/)
```

4. All file paths below use `context/` root — this is always the active brand's files
5. All output paths use `rewrites/[active-brand]/`, `research/[active-brand]/`, `published/[active-brand]/`

---

## STEP 0A — GENERATE OR LOAD BLOG UPDATE BRIEF (MANDATORY)

**CRITICAL: You MUST always run the `posimyth-blog-update-brief` skill before rewriting ANY existing blog post. This is non-negotiable and cannot be skipped under any circumstances.**

### How to execute:
1. **First, check if an update brief already exists** in `research/[active-brand]/` for this URL/topic
2. **If an update brief exists**: Load it and use its findings as your starting point
3. **If NO brief exists**: **STOP and invoke the `posimyth-blog-update-brief` skill NOW** before doing anything else. Do NOT proceed to Step 0B without a completed brief.

The update brief provides:
- GSC performance data and ranking decay analysis
- Keyword gaps and SERP analysis
- Heading structure changes needed
- Internal link audit
- CRO touchpoints and priority execution order

### After the brief is ready:
- **If the brief contains SERP, keyword, and performance data**: Skip those parts of Step 0B (sections 1 and 3) since the brief already has them. **Section 2 (GA4) must always be pulled separately — the brief does not cover GA4.**
- **Always still read all brand context files** (Step 0B, Section 4) — the brief does NOT replace context files
- **Always still run the posimyth-products skill** (Step 0B, Section 5) — the brief does NOT replace product verification

### Brief output → Rewrite step mapping

Once the brief is loaded, use its sections as follows:

| Brief Section | Use In |
|---|---|
| Section 2 — Title/Meta Update | Step 9 meta elements |
| Section 3 — Product Accuracy Fixes | Step 0C (what to change) + Step 6 (product mentions) |
| Section 4 — Structural Changes Required | Step 2 (scope + what to add/remove/rewrite) |
| Section 6 — Updated Outline | Step 3 (use as starting heading structure) |
| Section 9 — CRO Touchpoints | Step 6 product mentions |
| Section 10 — Priority Execution Order | **Follow this as your rewrite task sequence** |

**Section 10 takes precedence over Step 2's scope matrix.** The light/moderate/major/complete framework is a fallback when no brief exists.

**Why this matters**: The blog update brief crawls the live page, pulls GSC performance data, runs keyword gap + SERP analysis, and identifies ranking decay. Skipping it means rewriting blind without understanding what's actually wrong with the current content.

---

## STEP 0B — MANDATORY PRE-REWRITE DATA COLLECTION

Before touching any content, collect live data from all three sources. This is non-negotiable.

### 1. Crawl DataForSEO MCP (THOROUGH KEYWORD RESEARCH — NON-NEGOTIABLE)
Pull comprehensive keyword and SERP data. This is the foundation of every rewrite decision. Do not rush this step.

**Step 1a — Primary keyword SERP analysis** (`dfs-mcp:serp_organic_live_advanced`):
- Top 10 ranking pages (URLs, titles, word counts, heading structures)
- SERP features present (AI Overviews, Featured Snippets, PAA boxes, Video carousels, Image packs)
- All People Also Ask questions (use `people_also_ask_click_depth: 3` to get nested PAAs)
- Competitor content gaps vs. the existing article

**Step 1b — Keyword overview + difficulty** (`dfs-mcp:dataforseo_labs_google_keyword_overview`):
- Search volume (monthly), keyword difficulty score, CPC, competition level
- Search intent classification (informational, commercial, transactional, navigational)
- SERP feature probability

**Step 1c — Ranked keywords for this URL** (`dfs-mcp:dataforseo_labs_google_ranked_keywords`):
- All keywords this specific URL currently ranks for (limit: 100, order by search_volume desc)
- Identify keywords ranking position 4-10 (Featured Snippet opportunity)
- Identify keywords ranking position 11-20 (page 2 push candidates)
- Cross-reference with GSC data to find keywords with impressions but no clicks

**Step 1d — Related + semantic keywords** (`dfs-mcp:dataforseo_labs_google_related_keywords` + `dataforseo_labs_google_keyword_suggestions`):
- Related keyword clusters with search volume and difficulty
- Long-tail variations (3-5 word phrases) the post should target
- Question-form keywords that could become new H2s or FAQ entries
- "vs" and "alternative" keywords for comparison content opportunities
- Builder-specific variants (e.g., "gutenberg [feature]", "elementor [feature]")

**Step 1e — Competitor content analysis** (`dfs-mcp:on_page_content_parsing` on top 3 competitors):
- Heading structures of top 3 ranking pages
- Content gaps: topics they cover that the current post doesn't
- Content advantages: topics the current post covers that competitors don't
- Average word count of top 5 ranking posts vs. current post

### 2. Crawl GA4 MCP
Pull performance data for the existing article:
- Sessions and page views (last 90 days)
- Average engagement time
- Bounce / scroll depth if available
- Traffic trend (growing, declining, flat)
- Top landing page sources

### 3. Crawl GSC MCP
Pull search performance for the existing article URL:
- Total impressions and clicks (last 90 days)
- Average position for primary keyword
- All queries the page currently ranks for
- CTR by query (identify low-CTR high-impression queries to target)
- Pages that have overtaken this post since original publication

### 4. Read Brand Context Files (MANDATORY — do this before writing a single word)
**CRITICAL**: Always read all of the following context files at the start of every rewrite. These are the single source of truth for all product facts, brand voice, keywords, and SEO rules. Do not rely on memory — read them fresh every session.

**Always read these two first — no exceptions:**
- `context/product-knowledge.md` — install counts, ratings, pricing, USPs, bundle details. Read this before writing a single sentence about the product.
- `context/writing-examples.md` — reference posts and ideal style guide. Read this to match tone, structure, and voice before drafting.

**Then read all remaining context files:**
- `context/features.md` — full feature list for Nexter Blocks, Extension, and Theme
- `context/brand-voice.md` — tone, audience types, messaging pillars
- `context/target-keywords.md` — keyword clusters and content pillars to reinforce
- `context/internal-links-map.md` — all approved internal link URLs and anchor texts
- `context/seo-guidelines.md` — SEO rules and pre-publish checklist
- `context/style-guide.md` — post lengths, article template, CTA rules

**Do NOT mention any product feature or capability that is not listed in the context files above. No exceptions.**

**Also read `context/blog-style-guide.md` if it exists** — this file contains brand-specific writing rules (structure, CTA placement, callout formats, post templates). These rules OVERRIDE the generic rules in Steps 0C, 0D, 1, 3, and 6 below. If no blog-style-guide.md exists for the active brand, the rules below apply as-is.

**Also read `context/blog-rewrite-rules.md` if it exists** — this file contains brand-specific rewrite rules (what to preserve, what to change, rewrite-specific formatting). These rules OVERRIDE the generic rewrite rules in Steps 0C, 0D, 2, and 3. If no blog-rewrite-rules.md exists for the active brand, the rules below apply as-is.

### 5. Invoke posimyth-products Skill (MANDATORY — MUST RUN EVERY TIME)

**CRITICAL: You MUST invoke the `posimyth-products` skill at this step for EVERY rewrite. This is not optional. Do NOT skip this step even if you have read the context files. Do NOT rely on memory from previous sessions.**

**Note on the blog update brief**: The `posimyth-blog-update-brief` skill also runs `posimyth-products` internally. If the brief was run in this same session and its product data is still in context, re-invocation is still recommended to ensure no context was cleared — but use your judgment. If context is clearly intact, the double-invoke is a safety check, not required duplication.

**How to execute**: Call the `posimyth-products` skill using the Skill tool BEFORE writing any rewrite content. This loads the master product knowledge base.

**After invoking, verify the following before mentioning ANY POSIMYTH product** (Nexter Blocks, Nexter Extension, Nexter Theme, TPAE, UiChemy, WDesignKit, Sticky Header):
- The feature actually exists in the product
- The Free vs Pro tier is correct
- The stats (install counts, ratings, block counts) are current
- The pricing and plan names are accurate
- The doc URLs are valid

**This is a double verification layer**: Context files provide the writing-specific rules, the posimyth-products skill provides the master product facts. Both must agree before any product claim is published.

For detailed feature walkthroughs, always crawl the relevant doc page from the `posimyth-products` skill's URL inventory. Never answer from memory alone.

**Enforcement**: If you reach the rewrite drafting step without having invoked `posimyth-products`, STOP and invoke it before continuing. No exceptions.

---

## STEP 0C — STRICT CONTENT SCOPE (NON-NEGOTIABLE)

**CRITICAL: A rewrite ONLY updates blog CPT content. Nothing else. Follow these rules with zero exceptions.**

### What You CAN Change
- **Text blocks** (paragraphs) — rewrite, improve, update with fresh data
- **Heading blocks** (H2, H3, H4) — update heading text for better SEO and clarity
- **Blog title** (H1) — update for keyword optimization and CTR
- **Internal links and interlink callout blocks** — update, add, or improve
- **Meta title and meta description** — optimize for current keywords

### What You MUST NOT Change
- **Page structure and layout** — do NOT rearrange sections, move blocks around, or change the overall content flow unless the brief specifically calls for it
- **Product titles** — do NOT modify any product name, plugin name, or tool name displayed in the post
- **Feature lists and feature descriptions** — do NOT alter feature names, feature descriptions, or feature comparisons. Only update if factually outdated.
- **Buy Now links, CTA buttons, and pricing links** — do NOT touch any purchase links, affiliate links, or CTA button URLs/text
- **Image blocks** — do NOT delete, replace, or reposition images
- **Shortcode blocks** — do NOT modify shortcode IDs or shortcode placement
- **Custom blocks and widgets** — do NOT touch any Nexter blocks, embeds, or custom elements

### The Golden Rule
**If it's not a text block, heading block, or blog title, leave it alone.** When in doubt, preserve the existing element exactly as it is.

---

## STEP 0D — PRESERVE EXISTING BLOCKS FROM LIVE POST (NON-NEGOTIABLE)

**CRITICAL**: When rewriting an existing published post, you MUST extract and preserve ALL existing WordPress blocks from the live post before writing new content. Never replace the entire post content with new content only. The rewrite must merge new content WITH existing blocks.

### What to Extract and Preserve

Before writing a single word, use the correct MCP server for the active brand to read the existing post content and extract:

- **nexterwp** → `wp-nexterwp` MCP server
- **theplusaddons** → `wp-theplusaddons` MCP server
- **uichemy** → `wp-uichemy` MCP server

Extract:

1. **Image blocks** (`<!-- wp:image -->`) — Every image block with its ID, URL, alt text, and position in the content. These are custom-designed images that cannot be recreated.
2. **Interlink callout blocks** (`<!-- wp:paragraph {"className":"interlink"} -->`) — **NexterWP only.** The orange-bordered callout boxes used for related article links. These use the CSS class `interlink`. Skip this for theplusaddons and uichemy — those brands do not use this callout format.
3. **Shortcode blocks** (`<!-- wp:shortcode -->`) — TOC shortcodes, email subscribe form shortcodes, embed shortcodes, and any other shortcodes. Preserve all shortcodes at their original positions from the source post.
   - **ONE EXCEPTION — NexterWP email subscribe (ID 28477):** This shortcode MUST be placed immediately before the Wrapping Up H2 heading. Do NOT preserve it at its original position. Remove from wherever it was in the source post and re-insert fresh before Wrapping Up. All other shortcodes keep their original positions.
4. **Custom plugin blocks** — Any non-standard blocks (e.g., `<!-- wp:nstarter/...` for Nexter, Elementor data for TPAE).
5. **Group/column blocks** — Any styled container blocks that wrap content.
6. **Any other non-standard blocks** — Anything that is not a plain paragraph, heading, or list.

### How to Preserve Blocks

```
1. Read the existing post content via MCP (use the correct server for the active brand)
2. Extract all image blocks and map them to their section
3. Extract all shortcode blocks and note their position
4. If active brand is nexterwp: also extract interlink callout blocks
5. When building the new WordPress block HTML, re-insert these blocks at their correct positions
6. For images: place each image block directly after its corresponding H3 heading
7. For shortcodes: place in the exact same structural position as original
```

### Rules

- **NEVER delete existing image blocks** — even if the image seems unrelated to the new content. The images were specifically designed for the post.
- **NEVER delete shortcode blocks.**
- **If a section is removed**, its image block should also be removed. But if the section is kept or renamed, keep the image.
- **For new sections** (e.g., new items added to a list), note that they will not have image blocks. Flag this in the change summary so images can be created later.
- **NEVER include or touch FAQ blocks (NON-NEGOTIABLE HARD STOP)** — FAQ blocks (`<!-- wp:rank-math/faq-block -->` or any other FAQ block format) are automatically handled by the RankReady plugin on the live site. Do not include the FAQ block in the rewrite content at all — no preserving, no rewriting, no adding new questions. Simply omit it. RankReady handles it. If you include a FAQ block, it will conflict with what RankReady generates on publish.
- **NEVER include or touch Key Takeaways blocks (NON-NEGOTIABLE HARD STOP)** — Key Takeaways are automatically generated by the RankReady plugin on the live site. Do not include any Key Takeaways heading or bullet list in the rewrite content. Simply omit it entirely. RankReady handles it on publish. If you include a Key Takeaways block, it will appear as duplicate body content on the live page.

---

## STEP 0E — CALLOUT BLOCK PLACEMENT RULES (NEXTERWP ONLY)

**This step applies ONLY to the `nexterwp` brand. Skip entirely for `theplusaddons` and `uichemy` — those brands do not use callout blocks. Their `blog-style-guide.md` defines their own related-article link format (italic inline links).**

When writing or rewriting a NexterWP post, add interlink callout blocks at natural section breaks to link to related content on the site. These callout blocks render as orange-bordered boxes and are a key part of the Nexter blog design.

### When to Add Callout Blocks

- Place 2-3 interlink callout blocks per post at natural section breaks
- The linked article must be **topically related** to the section it appears after
- Check `context/internal-links-map.md` and the live site's blog index for available related articles
- Never place two callout blocks in the same section or back-to-back

### Callout Block Format (WordPress Block HTML)

```html
<!-- wp:paragraph {"className":"interlink"} -->
<p class="interlink"><em>[Context sentence]? [Action phrase] the <a href="https://nexterwp.com/blog/[slug]/"><strong>[Article Title]</strong></a></em></p>
<!-- /wp:paragraph -->
```

### Examples

```html
<!-- wp:paragraph {"className":"interlink"} -->
<p class="interlink"><em>Looking for ways to protect your website from hackers? Check out the <a href="https://nexterwp.com/blog/best-wordpress-security-plugins-to-protect-your-site/"><strong>5 Best WordPress Security Plugins to Protect Your Site</strong></a></em></p>
<!-- /wp:paragraph -->
```

### Rules

- Always use the `interlink` class — without it, the callout box styling will not render
- Wrap the entire text in `<em>` tags
- Wrap the linked article title in `<strong>` tags inside the `<a>` tag
- The link URL must point to a real, live page — verify it exists before adding
- Keep callout text concise (1-2 sentences max)
- **Spacing rule:** If an interlink callout appears directly after a `wp:list` block, add a 24px spacer between them. WordPress themes apply smaller bottom margins to lists than paragraphs, which collapses the gap. Use: `<!-- wp:spacer {"height":"24px"} --><div style="height:24px" aria-hidden="true" class="wp-block-spacer"></div><!-- /wp:spacer -->`

### HARD RULE — Never Use Italic Markdown for Related Article Links (NON-NEGOTIABLE)

**Related article links must ALWAYS use the interlink callout block format. Never write them as plain italic markdown or plain italic paragraphs.**

This is the most common format mistake in NexterWP rewrites. The rewrite `.md` file must use the full WordPress block HTML format — not markdown shortcuts.

| ❌ Wrong — plain italic markdown | ✅ Correct — interlink callout block |
|---|---|
| `*Want a full breakdown? Here is our [Astra Theme Review](url)*` | `<!-- wp:paragraph {"className":"interlink"} -->` |
| `<em>Read our full <a href="url">Astra Theme Review</a></em>` wrapped in plain `<!-- wp:paragraph -->` | `<p class="interlink"><em>...<strong>Astra Theme Review</strong>...</em></p>` |

**Pre-save check (MANDATORY):** Before saving the rewrite `.md` file, scan for any italic-only related article links (`*...[link]...*` or plain `<em>` paragraphs linking to internal articles). If found, convert them to the interlink callout block format before saving. Do not save a file that has italic inline links where interlink callout blocks should be.

---

## STEP 1 — UNIVERSAL WRITING RULES (NON-NEGOTIABLE)

These rules apply to all brands. Brand-specific structure rules come from `context/blog-style-guide.md` (loaded in Step 0B) and override the structure in Steps 3 and 6 below.

### Rule 1: NO Table of Contents
Never write a Table of Contents block. The Nexter blog auto-generates its TOC from heading structure. A manual TOC creates a duplicate. Delete any TOC from drafts before saving.

### Rule 2: ZERO TOLERANCE — NO Em Dashes (HARD BLOCK)

**Em dashes are ABSOLUTELY FORBIDDEN in all rewrite content. This is non-negotiable. No exceptions.**

This means:
- Never type `—` (U+2014) anywhere in the rewrite
- Never type `--` as a substitute
- Never let the AI model insert em dashes in generated prose

Replace every em dash with the contextually correct punctuation:
- A **comma** if the sentence continues naturally: "it handles X, which means..."
- A **colon** if introducing a list or elaboration: "three areas matter: hosting, caching, and uptime"
- A **period** and new sentence if the clause stands alone: "WooCommerce is self-hosted. You own everything."
- **Parentheses** for asides: "a lightweight theme (like Nexter) keeps load times low"

**Examples:**
- ❌ "Turnstile is free — which is a significant advantage."
- ✅ "Turnstile is free, which is a significant advantage."
- ❌ "reCAPTCHA v3 runs in the background — no user interaction needed."
- ✅ "reCAPTCHA v3 runs in the background. No user interaction needed."
- ❌ "three areas matter — hosting, caching, and uptime"
- ✅ "three areas matter: hosting, caching, and uptime"

**Em dashes around numbers and pricing (COMMON FAILURE POINT):**
A very common mistake is using em dashes inside pricing or feature list bullets to separate a plan name/price from its description:
- ❌ `$59/year (up to 500 sites) — all features included`
- ❌ `$119/year (3 sites) — adds premium starter templates`
- ❌ `Starter: $49/year (1 site) — includes Nexter Theme + 90+ blocks`

Always replace with a colon:
- ✅ `$59/year (up to 500 sites): all features included`
- ✅ `$119/year (3 sites): adds premium starter templates`
- ✅ `Starter: $49/year (1 site): includes Nexter Theme + 90+ blocks`

**Pre-save em dash check (MANDATORY):**
Before saving the rewrite file, search the entire draft for `—` (U+2014). If any are found, fix them before saving. Do not save a file that contains an em dash. Do not push a file that contains an em dash. If you find an em dash after writing, treat it as a blocker and fix it immediately.

### Rule 2b: ZERO TOLERANCE — NO En Dashes in Ranges (HARD BLOCK)

**En dashes (`–`, U+2013) are FORBIDDEN in all rewrite content. This is non-negotiable.**

En dashes used for numeric ranges (`$10–100/month`, `pages 2–3`) break during publishing — they render as the literal string `u2013` on the live site (e.g. `$10u2013100/month`). This is a known encoding bug.

**Always use a hyphen `-` for all ranges:**

| ❌ Breaks on publish | ✅ Safe |
|---|---|
| `$10–100/month` | `$10-100/month` |
| `$200–500/year` | `$200-500/year` |
| `pages 2–3` | `pages 2-3` |
| `5–10 minutes` | `5-10 minutes` |

**Pre-save en dash check (MANDATORY):**
Before saving the rewrite file, search the entire draft for `–` (U+2013). If any are found, replace with `-` before saving. An en dash in a saved file is a publishing blocker.

### Rule 3: KILL All Filler Phrases
These phrases must never appear:

| ❌ Never Use | ✅ Replace With |
|---|---|
| "It is worth noting that..." | State the fact directly |
| "In the realm of..." | "In WordPress...", "For SEO..." |
| "When it comes to..." | Rewrite the sentence |
| "It goes without saying..." | Delete entirely |
| "Needless to say..." | Delete or just say it |
| "At the end of the day..." | Delete or rewrite |
| "In today's digital world..." | Delete, start with the point |
| "As we all know..." | Delete entirely |
| "Without further ado..." | Delete entirely |
| "Having said that..." | Use "However" or rewrite |
| "With that being said..." | Delete entirely |
| "In order to..." | Replace with "to" |
| "Due to the fact that..." | Replace with "because" |
| "Has the ability to..." | Replace with "can" |

### Rule 4: Preserve the URL Slug
Never change the existing URL slug. Changing it destroys any rankings the page has earned.

### Rule 5: Free vs Pro Transparency (Every Feature Mention)
- State Free or Pro for every feature mentioned in the post
- Inline format: "[Feature Name] (Free)" or "[Feature Name] (Pro)" — not buried in a footnote
- If a section describes a Pro feature, the immediately following sentence must state the Free alternative or say "This feature requires the Pro plan starting at $X/year"
- Never use "affordable" or "budget-friendly" — use specific pricing numbers from `context/product-knowledge.md`

### Rule 6: Competitor Naming (Explicit and Strategic)
- Name competitors explicitly — "unlike Elementor's native menu" not "unlike other builders"
- Every competitor mention must include a factual differentiator — what is specifically different, not just "better"
- Never trash competitors — state facts, let the reader decide
- Apply the 1-2 punch: when mentioning a competitor's limitation, immediately follow with how the POSIMYTH product solves it

---

## STEP 2 — REWRITE STRATEGY

### Determine Scope from Data
**If a blog update brief was loaded in Step 0A, use its Section 10 Priority Execution Order as your rewrite task list and follow it in sequence.** The scope matrix below is a fallback for when no brief exists.

Use GA4 + GSC data to classify the rewrite level:

| Scope | Trigger | Changes |
|---|---|---|
| **Light Update (20-30%)** | Rankings stable, small content gaps | Fix stats, add keywords, improve meta |
| **Moderate Refresh (40-60%)** | Declining CTR, missing SERP features | Restructure sections, expand content, update examples |
| **Major Rewrite (70-90%)** | Significant ranking drop, competitors have overtaken | New outline, major expansion, fresh angle |
| **Complete Overhaul (90%+)** | No rankings, completely outdated | Essentially a new article on the same topic and slug |

### What to Keep
- Sections that are accurate, comprehensive, and still ranking
- Unique Nexter insights or comparisons that remain valid
- Internal links that still point to live, relevant pages
- Existing image references (after verifying with image-manifest.md)

### What to Update
- Statistics older than 12 months — replace with current data and cite the source + date
- Outdated Nexter product references — re-verify against the docs sitemap (https://nexterwp.com/doc-category-sitemap.xml)
- Missing keywords found in GSC query data
- Weak meta title/description with low CTR in GSC

### What to Add
- New H2/H3 sections covering content gaps identified in SERP analysis
- Missing AI snippet optimization (see Step 4)
- Related article links in italic format at natural section breaks
- Updated Nexter product mention if a relevant block/feature is confirmed in the docs sitemap

### ADDING NEW KEYWORDS DURING A REWRITE — WHAT IS ALLOWED VS NOT ALLOWED

Not all new keywords are treated the same. Use this test before deciding whether to add or create new.

#### ✅ Add into the existing post (related gaps within the same topic)

Keywords that fit naturally within the original post's existing subject — the post already covers the right entities, and the keyword just fills a gap in depth or angle.

**Examples for an "Astra vs GeneratePress" post:**
- "fastest free wordpress theme" → deepen the Performance section
- "astra free vs pro" → add detail to the Free vs Pro section
- "best free wordpress theme for bloggers" → add a sentence in Wrapping Up
- "astra vs generatepress speed" → no new entities, just a gap in existing coverage

**The test:** Does covering this keyword require adding a new product, tool, or subject that was never in the original post? If **no** → add it in the rewrite.

#### ❌ Create a new blog post (introduces a new entity or subject)

Keywords that require introducing something that was never part of the original post — a new product, a new tool, a new theme, a new comparison subject. Adding these changes the article's purpose and scope.

**Examples:**
- "neve theme" → Neve is a third theme not in the original post → new blog
- "kadence vs astra" → Kadence is a new entity → new blog
- "best wordpress themes list" → different content type entirely → new blog

**The test:** Does covering this keyword require adding a product, tool, or subject that was never mentioned in the original post? If **yes** → new blog, not an expansion.

**How to handle new blog opportunities in the brief:**
- Flag under a `New Content Opportunities` heading in Section 4 of the brief
- Recommend the exact command: `/article "[title targeting those keywords]"`
- Do NOT list it as a structural change for the current rewrite

### What to Remove
- Any information no longer accurate or deprecated
- Redundant sections covered better elsewhere in the article
- Filler phrases (see Rule 3)
- All em dashes (see Rule 2)
- Any TOC block (see Rule 1)

### Body Content Formatting Rule (NON-NEGOTIABLE)
**Subheading items must use bullet lists**: Any content under a subheading that contains 2 or more distinct items, causes, types, steps, or points must be formatted as a bullet list — never as flowing prose or run-on sentences. This applies to all sections (e.g., client-side causes, server-side causes, prevention tips, features). Each bullet must start with a **bold label**, followed by a colon and a full sentence explanation. If the existing post has these items written as prose, convert them to bullet lists during the rewrite.

### Cluttered Paragraph Rule (NON-NEGOTIABLE)
**Any paragraph that compares 3 or more options, plans, or products must be a bullet list — never a dense prose paragraph.** This is the most common formatting failure in product comparison posts.

**Triggers — convert to bullets if the paragraph:**
- Compares 3+ pricing plans or tiers side by side (e.g., Astra vs GP vs Nexter pricing)
- Lists 3+ "best for" or "choose X if" scenarios
- Stacks multiple product names with their prices/features in a single block of text

**Format:**
```
<!-- wp:list -->
<ul class="wp-block-list">
<li><strong>Best for [use case]:</strong> [product] at [price] — one clear sentence why.</li>
<li><strong>Best for [use case]:</strong> [product] at [price] — one clear sentence why.</li>
<li><strong>Best for [use case]:</strong> [product] at [price] — one clear sentence why.</li>
</ul>
<!-- /wp:list -->
```

**Example (wrong):**
> For a single-site user, GP Premium ($59/year) undercuts Astra Pro ($69/year) on price. For agencies, GeneratePress covers 500 sites at $59/year while Astra covers 1000 at $89/year. Astra's lifetime options make sense for users avoiding renewals, but GeneratePress no longer offers a lifetime plan. For anyone paying for a theme plus a block plugin, Nexter covers both for less.

**Example (correct):**
- **Best for single sites:** Nexter Starter at $49/year includes the theme, 90+ blocks, and 50+ extensions in one plan.
- **Best for agencies:** GP Premium at $59/year covers up to 500 sites. Better per-site value than Astra Pro at $89/year for 1000 sites.
- **Best for avoiding renewals:** Astra is the only option with lifetime pricing ($319 for 3 sites).

---

## STEP 3 — BLOG STRUCTURE

**IMPORTANT**: If `context/blog-style-guide.md` was loaded in Step 0B, that file's structure template **replaces everything in this step**. The structure below is the NexterWP default — it only applies when the active brand is `nexterwp` or when no `blog-style-guide.md` exists.

Every NexterWP rewrite must follow this exact structure:

```
[H1: Article Title — contains primary keyword]
[Title format: use brackets [] for comparison/list counts, parentheses () for method/fix counts]
Examples: "Cloudflare Turnstile vs Google reCAPTCHA: [5 Key Differences]"
          "How to Fix Blurry Images in WordPress (8 Methods)"
          "10 Best Websites for Downloading Fonts [Free & Paid]"

[Meta line: Updated On: DATE | X min read]
**CRITICAL — REWRITE FILE ONLY, NEVER PUBLISH:** The "Updated On:" line is a metadata note for the rewrite file only. It must NEVER be included as a paragraph block in the published post content. The Nexter theme renders the date and read time automatically from post meta — hardcoding it as a content block causes it to appear as body text on the live page.
**CRITICAL: Never write "By: [Author]" in post content.** Author attribution is rendered by the WordPress theme from post meta — it is not a content field. Never hardcode author names or "Editorial Team" in the body of the post.

[INTRO — 2 to 3 paragraphs only]
  Para 1: Hook — validate the pain point or establish stakes. NEVER open with a definition.
         Include Wikipedia-style product disambiguation in first 100 words (see Entity Clarity rules).
  Para 2: Background context — why this matters, what is involved.
         Include "Who this is for" line — e.g., "This guide is for WordPress developers who..."
  Para 3: Preview — what this article covers, what the reader will learn

[NOTE: NO TOC — site generates it automatically]

[H2 — First main section]
  [H3 — subsection if needed]
  [Content]
  [Related article link — italic format — at section breaks only, never mid-paragraph]

[H2 — Second main section]
  ...

[Mid-article Nexter mention — 1 to 3 sentences — only where Nexter genuinely solves the topic]

[H2 — ... more sections ...]

[H2 — Wrapping Up (topic-specific, NEVER just "Wrapping Up" or "Conclusion")]
  Sentence 1: Restate the key takeaway
  Sentence 2-3: Decision guide — "Choose X if..., Choose Y if..."
  Closing product CTA — benefit-first, link to specific product page (not homepage)
  NOTE: The primary focus keyword MUST appear naturally at least once in this section. Never skip it.

[Email Subscribe CTA Block — EXACT text, no variations:]
  #### Get Exclusive WordPress Tips, Tricks and Resources Delivered Straight to Your Inbox!
  Subscribe to stay updated with everything happening on WordPress.

[Related Posts — site-generated, do not write this]
```

---

## STEP 4 — AI SNIPPET & AI SEO OPTIMIZATION

Apply these rules to every heading and content block to maximize Featured Snippet and AI Overview capture.

**Note on the `ai-seo` skill**: The rules in this step fully cover AI/LLM optimization inline — the `ai-seo` skill is not invoked here. If you want a separate AI SEO pass after drafting, you can invoke it, but it is not required as part of this workflow.

### Heading Rules for AI Snippets
- Write H2/H3 headings to **exactly match how users phrase queries** in search
- Use question-format H3s for comparison sections: "Is Cloudflare Turnstile GDPR compliant?"
- Use "What is [X]?" as H2 for definition sections — this captures Knowledge Panel and AI Overview extractions
- Use "How to [action]?" or "How does [X] work?" headings to trigger HowTo-style snippets
- Keep primary keyword in at least 2 H2 headings

### Content Block Rules for AI Extraction
AI systems extract passages, not pages. Every key answer must work as a standalone block:

- **Definition blocks**: Lead every "What is X?" section with a direct 40-60 word definition paragraph. Do not bury the definition after background context.
- **Step-by-step blocks**: Use numbered lists for process content. Each step must be self-contained.
- **Comparison tables**: Use for 3+ tool comparisons or side-by-side pricing. For 2-tool comparisons with deep narrative, use parallel H3/H4 headings (Nexter preferred format). **Always include a "Best for" or "Winner" row** — LLMs extract clear recommendations from tables. Example: `| Best for | Beginners who want zero config | Developers who need full control |`
- **Pros/Cons blocks**: Always use the Nexter format — bold label + colon + full sentence explanation. Minimum 3 pros and 3 cons each.
- **Statistic blocks**: Include specific numbers with cited sources and dates. Statistics boost AI citation probability by +37%.

### AI SEO Authority Signals
Apply these to boost probability of being cited in AI Overviews, ChatGPT, and Perplexity:

| Signal | How to Apply | Visibility Boost |
|---|---|---|
| Cite sources | Add authoritative references with links | +40% |
| Add statistics | Include specific numbers with sources + dates | +37% |
| Expert/authority tone | Write with demonstrated expertise, not fluff | +25% |
| Improve clarity | One idea per paragraph, direct answers | +20% |
| Freshness signals | Add "Last updated: [date]" — update outdated stats | High |

- Include at least 2-3 cited statistics with source and date in every article
- Every major claim should be supported by a source or example
- Use "According to [Source]" framing for third-party claims
- Keep answer passages to 40-60 words (optimal for snippet extraction)
- **External source links must use `rel="nofollow"`** — citations and third-party references (competitor pricing pages, official docs, studies, WordPress.org stats) are references, not endorsements. Format: `<a href="URL" rel="nofollow">anchor text</a>`. Internal links and POSIMYTH sister-domain links do NOT use nofollow.

### Sources, Statistics, and Cited Facts (MANDATORY)

Every rewrite must include real, verifiable data points. Do not publish claims without backing.

**What requires a cited source:**
- Competitor pricing figures (e.g., Bricks Builder $79/year) — link to the competitor's official pricing page with `rel="nofollow"`
- Third-party statistics (e.g., "WordPress powers 43% of the web") — link to the original study or report with `rel="nofollow"`
- Plugin/product install counts or ratings — link to the WordPress.org plugin page with `rel="nofollow"`
- Performance benchmarks cited from external tests — link to the source with `rel="nofollow"`
- Any claim starting with "studies show", "research shows", "according to", or a percentage — must have a source

**What does NOT need an external source (first-party is sufficient):**
- Test data you ran yourself ("we tested X on staging, measured 0.8s LCP") — state it as first-person observation, no link needed
- POSIMYTH product facts (block counts, pricing, features) — sourced from `context/product-knowledge.md`, link to nexterwp.com/nexter-blocks/ or relevant product page
- WordPress core behaviour that is publicly documented — link to wordpress.org/documentation/ if helpful but not mandatory

**Formatting rules for cited sources:**
- Inline format: `According to [Source Name](URL){rel="nofollow"}, [stat].`
- Or: `[stat] ([Source Name](URL){rel="nofollow"}, [Year]).`
- Place the citation immediately after the stat in the same sentence — never at the bottom of the article in a references section
- Use the source's actual name, not "a study" or "research" — e.g., "According to WordPress.org" not "according to a report"

**Minimum per article:** at least 2 external cited stats with nofollow source links per rewrite.

---

## STEP 5 — CONTENT STRUCTURE BY POST TYPE

### Comparison Posts (X vs Y)
```
H1: [Tool A] vs [Tool B]: [N Key Differences] / Wondering Which One to Choose?
H2: What is [Tool A]?
  H3: Pros and Cons of [Tool A]
H2: What is [Tool B]?
  H3: Pros and Cons of [Tool B]
H2: [Tool A] vs [Tool B]: [N Key Differences]
  H3: 1. [Difference Category]
    H4: [Tool A]
    H4: [Tool B]
  H3: 2. [Difference Category]
    ...
H2: Which Should You Choose: [Tool A] or [Tool B]?   ← CONCLUSION (separate H2)
  [conclusion content + CTA]
#### [Email Subscribe CTA block]
```

**Comparison post requirements:**
- Head-to-head comparison table must appear in the first 500 words — not after long explanations
- Table columns: Feature, [Tool A], [Tool B] — with checkmarks or specific values, not just Yes/No
- Always include a "Best For" or "Winner" row at the bottom of every comparison table
- Each option gets equal treatment in section length — fairness signals citation-worthiness to LLMs
- "Bottom line" verdict after every comparison table: 1-2 sentences stating who should pick what
- Direct answer in the first paragraph: "[A] is better for [use case], [B] is better for [use case]"
- If both sides have a POSIMYTH product (e.g., Nexter Blocks for Gutenberg, TPAE for Elementor), both get mentioned with their specific strengths
- "As of [Year]" timestamp on any pricing or feature claims

### How-To / Error Fix Posts
```
H1: How to Fix [Error] in WordPress ([N Methods])
H2: What Causes [Error]? (or "Why Are [X] [Problem]?")
H2: Prerequisites (for technical/tutorial posts — what the reader needs before starting)
    ← Include: WordPress version, required plugins, hosting requirements, skill level
    ← Skip this H2 for simple explainer or comparison posts
H2: Fix 1: [Method Name]
H2: Fix 2: [Method Name]
...
H2: Wrapping Up: [Fix/Do X] in WordPress   ← CONCLUSION (separate H2)
  [conclusion content + CTA]
#### [Email Subscribe CTA block]
```

**How-To post requirements:**
- Direct answer in the first 2 sentences — what is the problem, what fixes it
- "What Causes [Problem]?" section should use a table: Cause | Type (Client/Server) | How to Identify | Fix Reference
- Each fix/method must be numbered, never bulleted (numbered = HowTo schema eligible)
- Each step format: **Action title** → Why this works (1 sentence) → How to do it (numbered sub-steps) → What to expect after
- Steps must work as standalone instructions — someone should be able to follow step 3 without reading steps 1-2
- Brand mention only where it genuinely solves part of the problem — always explain WHY it helps, not just name the product

### List / Resource Posts
```
H1: [N] Best [Topic] [Context] in [Year]
H2: What Should You Look For in [Category]? ← required section, criteria our product naturally answers
H2: 1. [Our Product Name]  ← ALWAYS position 1 — this is our blog
H2: 2. [Item Name]
H2: 3. [Item Name]
...
H2: Which [Topic] Is Right for You?   ← CONCLUSION (separate H2)
  [conclusion content + CTA]
#### [Email Subscribe CTA block]
```

**List/Listicle post requirements:**
- Our product is **always #1** in any list post — this is our blog and we earned that position
- Intro must state selection criteria: "We evaluated based on [X], [Y], [Z]" — makes the list citable as methodology
- Quick comparison table at the top (before detailed writeups) — columns: Name, Key Differentiator, Best For, Active Installs, Free Widget Count
- Our product entry is 2-3x longer than competitor entries — more features, more detail, more depth
- Each competitor entry must include: Key Features, Pricing, Link — no padding entries
- Each competitor entry needs a one-line reason why it made the list: "[Product] is best for [use case] because [reason]"
- Install counts sourced with verification note: "Install counts from WordPress.org as of [Month Year]"
- End CTA recommends our product for the broadest use case

### "What Is" / Explainer Posts
**Requirements:**
- Definition in the first 60 words — complete, standalone, no jargon
- "Why Does [X] Matter?" section within the first 300 words
- Real-world example section: "Here's what [X] looks like in practice..."
- If explaining a concept our product implements, show it: "Here's how [Product] handles [concept]..."
- Position our product as the practical next step: "Now that you understand [concept], here's how to implement it..."
- Link to the relevant docs page for hands-on implementation

---

## STEP 6 — PRODUCT MENTIONS

**IMPORTANT**: If `context/blog-style-guide.md` was loaded in Step 0B, use that file's CTA placement and product mention rules instead of the NexterWP examples below. The rules below are the NexterWP default.

For all brands: product mentions must be tied to solving a specific problem. Never generic praise. Always link to the specific product/feature page, not the homepage. Verify every feature claim against `context/product-knowledge.md` and the `posimyth-products` skill output before writing.

### NexterWP — Mid-Article CTA Format

### Mid-Article CTA Format
Insert only where a Nexter product genuinely solves the problem being discussed:
- Sentence 1: Name the specific Nexter block/feature relevant to the topic
- Sentence 2: What it does for the reader (benefit-focused)
- Sentence 3 (optional): Mention the 90+ blocks pitch

**Example (from live Nexter post):**
> "The Login/Registration for Spam Protection block from the Nexter Blocks plugin is a great way to add Google reCAPTCHA to your website's registration forms without disrupting the aesthetics of your web design. With this block you get over 90 additional blocks that add to the functionality of your website."

**Rules:**
- Only mention Nexter if a relevant block/feature is confirmed in the docs sitemap
- Never force the mention — if nothing is directly relevant, skip it
- Always link to the specific block or product page, not the homepage
- Safe links: https://nexterwp.com/nexter-blocks/ | https://nexterwp.com/nexter-extension/ | https://nexterwp.com/nexter-theme/

### Comparison Posts — Natural Nexter Bias (MANDATORY)

When rewriting a post that compares two or more third-party products (e.g. "Astra vs GeneratePress", "Elementor vs Beaver Builder"), **Nexter must be positioned as the superior alternative** throughout the post. This is not optional — we make these products and should naturally advocate for them.

**Rules for comparison rewrites:**
- Add **3–5 natural Nexter mentions** across the comparison sections — not all in one place
- **Pitch Nexter wherever it fits naturally** — scan every section and ask "does Nexter have a relevant feature, pricing advantage, or bundled value here?" If yes, add the mention. Do not force a mention where nothing genuinely fits — an awkward pitch is worse than no pitch. For sections where no product feature applies (e.g. Support/Documentation), consider whether Nexter Academy, docs, or YouTube tutorials are worth a brief mention before skipping entirely
- Each mention must follow this pattern: (1) acknowledge what the compared products offer, (2) show where Nexter does it better or goes further, (3) include a reason why — specific feature, pricing advantage, or bundled value
- Place mentions after the section's theme comparisons as a regular paragraph — **never as a labeled callout block or blockquote** — the reasoning must be woven naturally into the paragraph flow
- **Pricing section**: Always include a Nexter pricing block showing **all tiers** (Free + Starter + multi-site) at the same level of detail as competitor pricing tables. Never truncate with "Higher tiers available — see pricing." Show the multi-site tier price explicitly so readers can do a direct comparison. Show the bundled value (theme + blocks + extensions in one plan)
- **Wrapping Up CTA**: Must be topic-specific — reference the exact themes/tools being compared and explain why Nexter is the better choice in that context
- Bias must feel like an informed recommendation, not a sales pitch. Use factual differentiators (page weight, block count, plan inclusions, pricing) — never vague superlatives
- **Never claim features Nexter does not have** — verify all claims against `context/product-knowledge.md` before writing
- **Theme switching / lock-in angle** (comparison posts only): Include a paragraph addressing what happens when a user switches themes mid-project. For Nexter, Nexter Blocks travels with the user regardless of theme — the blocks are not theme-dependent. This is a real conversion angle for anyone deciding between theme-locked features (Astra Pro WooCommerce, GP Premium Site Builder) vs a theme-independent block solution

### "Why We Recommend Nexter" Section (NexterWP comparison posts)

Some NexterWP comparison posts contain a `## Why We Recommend Using Nexter Theme?` section followed by a shortcode block (e.g. `[nexter-builder id="43345"]`). This shortcode renders a pre-built visual CTA widget.

**Rule:** Never leave this as a bare heading + shortcode. Always write 2-3 sentences of context before the shortcode that bridge from the comparison into the recommendation. The shortcode may fail to render in some contexts — the written content ensures the section is never blank.

**Format:**
```
## Why We Recommend Using Nexter Theme?

[2-3 sentences: what makes Nexter the right choice in the context of the comparison being made — reference the specific themes compared, the bundled value, and the performance or pricing advantage. Topic-specific, not generic.]

<!-- wp:shortcode -->
[nexter-builder id="43345"]
<!-- /wp:shortcode -->
```

---

### Closing Nexter CTA (Wrapping Up Section)
Format: [Product name] [does what] — [benefit]. [Specific capability]. [Action verb] [link].

**Example:**
> "Nexter Blocks is a WordPress plugin that effortlessly integrates with Google reCAPTCHA to keep your website secure and protected from unwanted access. Nexter Blocks come with 90+ versatile Gutenberg blocks that enhance the functionality and aesthetics of your website. Try Nexter Blocks today to elevate your WordPress website's visual appeal and security!"

---

### H2 Quality Rules

Every H2 must be a complete statement or question — not a one-word label. AI models extract H2s as context signals. A vague label tells them nothing; a full statement tells them exactly what the section covers.

| ❌ Bad H2 (label) | ✅ Good H2 (full statement) |
|---|---|
| `Installation` | `How to Install Nexter Blocks and Enable the Mega Menu Module` |
| `Features` | `5 Nexter Blocks Features That Replace Separate Plugins` |
| `Pricing` | `Nexter Blocks Free vs Pro: What You Get at Each Tier` |
| `Conclusion` | `Wrapping Up: Which Option Should You Choose?` |

**Comparison language requirement**: At least one H2 in every post must use comparison or contrast language — "vs", "unlike", "instead of", "compared to". This builds LLM entity relationships between the product and its category.

---

### EEAT & Content Quality Rules

These separate a post that ranks from one that gets demoted by Google's helpful content system.

**Experience signals (required):**
- Include at least one specific observation from actually using the product. Not "Nexter Blocks is powerful" — instead "When we tested the Mega Menu builder with 8 columns and nested dropdowns, render time stayed under 200ms."
- Include at least one number that did not come from a third-party article: plugin version, test result, setup time, step count, setting count — anything real and specific
- If comparing products, state what was actually tested: "We tested X on a staging site with Y theme"
- If making a recommendation, state who it is best for AND who it is not for. Both.

**Originality rule**: Every H2 section must contain at least one sentence that could not have been written without using the product. If every sentence in a section could have been written by reading a spec sheet, rewrite until it can't.

**Banned filler words** — remove every instance:
`simply` / `just` / `easy` / `quick` / `seamlessly` / `robust` / `leverage` / `game-changer` / `powerful` / `comprehensive` / `ultimate`

These words are condescending to users who are stuck and signal to Google's quality rater that the writer has never used the thing they are explaining.

---

### Content Freshness Signals

Include at least two of these in every rewrite to demonstrate recency:

- Mention the specific product version being referenced: "Tested on Nexter Blocks v4.7"
- Reference a recent feature update: "As of v4.0, you can now..."
- Include WordPress version: "Tested on WordPress 6.5"
- For comparison posts: "Prices and features verified [Month Year]"
- Add or update "Last updated: [Month Year]" in the meta line at the top of the post

---

## STEP 7 — INTERNAL LINKING (MINIMUM 5-6 LINKS — NON-NEGOTIABLE)

Every rewrite MUST include a minimum of **5-6 internal links**. This is a hard minimum, not a suggestion. Aim for 7-8 where natural.

### Same-Domain Internal Links (minimum 4-5)
Source URLs from `context/internal-links-map.md` AND the brand's sitemap via DataForSEO (`dfs-mcp:dataforseo_labs_google_ranked_keywords` on the domain).

**Required link types (include at least one of each):**
- **Blog-to-blog links** (2-3): Link to related blog posts on the same domain. Use italic callout format at section breaks.
- **Blog-to-doc links** (1-2): Link to relevant documentation/help pages for features mentioned in the post.
- **Blog-to-landing/product links** (1): Link to the product page, pricing page, or feature landing page where relevant.
- **Audience page links** (1, in conclusion or relevant section): Link to the matching `/nexter-for-*` page based on who the post targets. These are hub links that increase session depth and route users to the right conversion path.
  - Beginners, non-developers, template users → `/nexter-for-beginners/`
  - Agencies, multi-site workflows → `/nexter-for-agencies/`
  - WooCommerce / store owners → `/nexter-for-e-commerce/`
  - Marketers → `/nexter-for-marketer/`
  - Freelancers → `/nexter-for-freelancers/`
  - If the post targets multiple audiences (e.g. a comparison post covers both beginners and agencies), include both audience page links in separate sections

**Deep link rule (MANDATORY):** When a specific Nexter feature is named (Header Builder, Mega Menu, Popup Builder, Blog Builder, Form Builder, Ajax Search, WooCommerce Product Grid, specific blocks), always link to that feature's specific page from `context/internal-links-map.md`. Never link to the generic `/nexter-blocks/` overview when a deep page exists. Same applies to Nexter Extension features — link to `/nexter-extension/features/` or a specific extension page, not the overview.

**Format for related article links:**
- *[Describe the reader's next question or action]. Here's [description of linked article].*
- **Example**: *Protect your website from unwanted access. Here's how to secure your WordPress login page.*

### Cross-Domain Internal Links (minimum 1-2 — MANDATORY)
POSIMYTH owns multiple domains. Every rewrite MUST include **at least 1-2 cross-domain links** to sister product sites where relevant. This builds topical authority across the POSIMYTH ecosystem and passes link equity between properties.

**Cross-domain link sources:**
| From Domain | Can Link To |
|---|---|
| nexterwp.com | theplusaddons.com, uichemy.com, wdesignkit.com, posimyth.com |
| theplusaddons.com | nexterwp.com, uichemy.com, wdesignkit.com, posimyth.com |
| uichemy.com | nexterwp.com, theplusaddons.com, wdesignkit.com, posimyth.com |
| wdesignkit.com | nexterwp.com, theplusaddons.com, uichemy.com, posimyth.com |

**How to find cross-domain link opportunities:**
1. Read `context/shared/` files for sister product knowledge and URLs
2. Identify natural connection points in the content (e.g., a NexterWP post about Gutenberg blocks can link to WDesignKit for templates, or to UiChemy for Figma-to-WordPress conversion)
3. Use anchor text that describes the sister product's value, not just its name

**Cross-domain link examples:**
- NexterWP blog → *"Need starter templates for your Gutenberg blocks? [WDesignKit](https://wdesignkit.com/) offers 1,000+ ready-made templates for Elementor and Gutenberg."*
- NexterWP blog → *"Converting Figma designs to WordPress? [UiChemy](https://uichemy.com/) converts Figma files directly into Elementor, Gutenberg, or Bricks layouts."*
- TPAE blog → *"Looking for a lightweight Gutenberg alternative? [Nexter Blocks](https://nexterwp.com/nexter-blocks/) provides 90+ native blocks with zero jQuery dependency."*

### Linking Rules
- Anchor text must be descriptive and keyword-rich — never "click here" or "read more"
- Never stack two related links in the same section
- All URLs must be verified as live before adding (check via sitemap, URL inventory, or DataForSEO)
- Distribute links naturally throughout the post — not clustered in one section

---

## STEP 8 — IMAGE WORKFLOW

### Extract Images from Existing Post

Use the MCP server for the active brand to read the existing post content and extract image blocks. Do NOT use curl or WebFetch against production URLs.

| Active Brand | MCP Server | How to Read Post |
|---|---|---|
| nexterwp | wp-nexterwp | `novamira/execute-php` → `get_post(POST_ID)->post_content` |
| theplusaddons | wp-theplusaddons | `novamira/execute-php` → `get_post(POST_ID)->post_content` |
| uichemy | wp-uichemy | `novamira/execute-php` → `get_post(POST_ID)->post_content` |

From the post content, extract all `<!-- wp:image -->` blocks. For each image note: block position, attachment ID, URL, alt text, and which section it belongs to.

### Create Image Folder and Manifest
```bash
mkdir -p "assets/images/[blog-slug]"
```
Save `image-manifest.md` with: file name, alt text, which section it belongs to, original URL, usage notes.

### Image Placement Rules
- One image per major fix/method in how-to posts
- One image per item in list posts
- One image per product in comparison posts
- Nexter product image in mid-article CTA or Wrapping Up
- Never place two images back-to-back with no text between them
- Alt text: descriptive — what is shown + context keyword if natural

### Image Reference Format in Rewrite
```markdown
![Alt text](../../assets/images/[blog-slug]/filename.webp)
*Caption if needed*
```

---

## STEP 9 — SEO ENHANCEMENT

### Entity Clarity Rules (CRITICAL FOR LLM CITATION)

LLMs need to understand exactly what your product IS, who makes it, and what category it belongs to. These rules build entity recognition in AI models.

**Rule 1 — Wikipedia-style disambiguation in intro (MANDATORY):**
The first 100 words of every post MUST include a clear, Wikipedia-style entity description of the product. This is how LLMs learn what the product is.

Format: **"[Product Name], a [category] by [Company]"**

Examples:
- "**Nexter Blocks**, a Gutenberg block plugin by POSIMYTH, provides 90+ native WordPress blocks..."
- "**The Plus Addons for Elementor**, an Elementor widget library by POSIMYTH with 120+ widgets..."
- "**UiChemy**, a Figma-to-WordPress converter by POSIMYTH that supports Elementor, Gutenberg, and Bricks..."

Place this naturally in the intro — not bolted on. It should read as helpful context, not a disclaimer.

**Rule 2 — Consistent product naming (MANDATORY):**
Pick ONE canonical name per product and use it consistently throughout the entire post. Never mix variations.

| Product | Canonical Name (use this) | Never Use |
|---|---|---|
| Nexter Blocks | **Nexter Blocks** | NB, Nexter plugin, the Nexter blocks plugin, Nexter block |
| Nexter Extension | **Nexter Extension** | NE, Nexter ext, the extension |
| Nexter Theme | **Nexter Theme** | Nexter, the theme, NT |
| The Plus Addons for Elementor | **The Plus Addons for Elementor** (always — never abbreviate) | Plus Addons, TPA, The Plus, TPAE, Plus for Elementor |
| UiChemy | **UiChemy** | UI Chemy, Ui Chemy, the converter |
| WDesignKit | **WDesignKit** | WDK, Design Kit, W Design Kit |

First mention in any post: use the full canonical name. Subsequent mentions: use the same full name. **NEVER write abbreviated forms (TPAE, NB, NE, etc.) in published content, and NEVER write a brand abbreviation in parentheses after the full name — e.g. never write "The Plus Addons for Elementor (TPAE)". Always use the full brand name only.**

**Rule 3 — Link product to official page on first mention (MANDATORY):**
The very first time the product name appears in a post, it MUST be linked to the product's official page. This is a critical entity signal for LLMs and search engines.

Examples:
- First mention: "**[Nexter Blocks](https://nexterwp.com/nexter-blocks/)** provides 90+ Gutenberg blocks..."
- All later mentions: "Nexter Blocks" (plain text, no link — linking every instance is spam)

### Keyword Optimization (from GSC + DataForSEO data)
- Primary keyword: 1-2% density
- Primary keyword in H1, first 100 words, at least 2 H2s, meta title, meta description
- Product name (full canonical form) in first 100 words with Wikipedia-style disambiguation
- Add low-CTR high-impression queries from GSC as semantic H3s or FAQ questions
- Never force keywords unnaturally

### Meta Elements
- **Meta Title**: 50-60 characters, primary keyword near front, compelling for click-through
- **Meta Description**: 150-160 characters, include primary keyword, state the value clearly
- **URL Slug**: Keep the original slug — never change it

### Schema to Add (via Rank Math or post notes)
- `HowTo` schema for step-by-step fix/tutorial posts
- `Article` or `BlogPosting` for all posts (author, date, topic)
- **FAQPage schema is handled automatically by the RankReady plugin — do not add it manually**
- **Frontmatter rule**: Never include `FAQPage` in the `Schema to Add:` field of the rewrite file frontmatter. RankReady generates it on the live site. Only list `Article/BlogPosting` (and `HowTo` if applicable). If `FAQPage` appears in frontmatter, remove it before saving.

---

## STEP 10 — MISSING CONTENT GAPS (CHECK BEFORE FINALIZING)

Before finalizing the rewrite, scan for these high-value sections that competitors often have and LLMs frequently cite. If 2 or more are missing from the post, add them.

- **Hosting-specific guidance**: Does this topic differ on SiteGround vs Kinsta vs Cloudways vs shared hosting? Even a 3-row table adds significant LLM extractability.
- **Cloudflare/CDN context**: If the post involves performance, timeouts, caching, or speed — Cloudflare is relevant. Most WordPress sites use it.
- **WP-CLI commands**: Power users search for CLI shortcuts. One command per relevant section adds depth that AI models cite.
- **Video embed or visual diagram**: Increases dwell time and makes the page more linkable. Flag for the team if a relevant video exists on the POSIMYTH YouTube channel.
- **Related topic cluster links**: "If you're seeing [related issue] instead, read our guide on..." — builds topical authority across the cluster.
- **Tool recommendations with specifics**: Not "use a caching plugin" but "WP Super Cache (free, 2M+ installs) or LiteSpeed Cache (free, 6M+ installs)".
- **Cost/time estimate**: "This fix takes approximately 5 minutes" or "Expect the Pro plan at $39/year" — specificity gets cited by LLMs.
- **Community validation**: If real WordPress users discuss this on Reddit or WP forums, reference it: "WordPress community members on r/wordpress frequently report that [X] resolves this issue" — LLMs weight community-validated solutions.

---

## STEP 11 — MANDATORY ORIGINAL ADDITIONS (NON-NEGOTIABLE)

Every rewrite must include **at least 2-3 original angles that did not exist in the source post**. A rewrite that only updates existing content is not enough. These additions are what separates a rewrite from a refresh.

This is not about adding filler. Each addition must add real value — a perspective, angle, or data point that competitors have not covered and that helps the reader make a better decision.

**How to find additions:**
- Read the existing post and ask: "What does someone reading this still not know after finishing it?"
- Check the top 3 SERP competitors (fetched in Step 0B): what angle do ALL of them miss?
- Think about the reader's next problem after this one — that gap is an addition

**Examples of strong additions:**
- A "what happens if you switch" angle for comparison posts (theme lock-in, plugin dependency, migration cost)
- A Core Web Vitals ranking impact paragraph in performance comparison sections — connecting speed specs to actual ranking signals, not just benchmark numbers
- A "Who should NOT use this" section — honesty builds trust and makes the recommendation stronger
- A cost-over-time calculation (e.g. "$59/year GP Premium vs $249 lifetime — break-even at year 5")
- A real workflow example: "If you're an agency managing 20 sites, here's what the math looks like..."

**Rule**: After finishing the rewrite draft, list the 2-3 additions explicitly in the Change Summary under a new `Original Additions` section. If you cannot name 2-3 things that were not in the source post, you have not added enough.

---

## Output

### 1. Rewritten Article
Complete markdown file following the Nexter structure template above. Saved to:
- `rewrites/[active-brand]/[topic-slug]-rewrite-[YYYY-MM-DD].md`

### 2. Change Summary
Saved to:
- `rewrites/[active-brand]/changes-[topic-slug]-[YYYY-MM-DD].md`

```
---
Original Publication Date: [if known]
Rewrite Date: [YYYY-MM-DD]
Rewrite Scope: Light / Moderate / Major / Complete
Word Count Change: [original] → [new]
Primary Keyword: [keyword]
GSC Position Before: [position]
Top GSC Queries Used: [list]

Major Changes:
- [Summary of significant updates]
- [New sections added]
- [Content removed/consolidated]

Original Additions (MANDATORY — list 2-3 angles added that did not exist in source post):
- [Addition 1: angle, section where added]
- [Addition 2: angle, section where added]
- [Addition 3: angle, section where added — if applicable]

AI Snippet Optimizations:
- [Definition blocks added]
- [Statistics cited]

SEO Improvements:
- [Keyword optimization details]
- [Internal links added/updated]
- [Meta elements updated]
- [Schema recommended]

Brand Compliance ([active-brand]):
- [ ] No TOC block
- [ ] No em dashes
- [ ] No filler phrases (including: comprehensive, ultimate)
- [ ] Product mentions verified against context/product-knowledge.md and posimyth-products skill
- [ ] Free vs Pro stated inline for every feature mentioned — format: "(Free)" or "(Pro)"
- [ ] Competitor mentions use explicit names + factual differentiators (no "other builders")
- [ ] Full product name used on first mention with "by POSIMYTH" at least once per product
- [ ] Email Subscribe CTA block present (NexterWP) or brand-equivalent CTA (other brands)
- [ ] Wrapping Up format followed
- [ ] Primary focus keyword appears naturally in Wrapping Up section
- [ ] "Last updated: [Month Year]" appears in content body (not just metadata)
- [ ] Current WordPress version mentioned in content body
- [ ] Current product version mentioned in content body
- [ ] Missing Content Gaps checked (Step 10) — 2+ gaps addressed if found
- [ ] Minimum 6 same-domain internal links
- [ ] Minimum 1-2 cross-domain internal links to sister POSIMYTH sites
- [ ] Audience page link included (`/nexter-for-*`) matched to the post's target audience
- [ ] All named features (Mega Menu, Popup Builder, Header Builder, Blog Builder, etc.) link to their specific deep page — not generic `/nexter-blocks/`
- [ ] For comparison posts: Nexter pitched in every section where a genuine feature, pricing, or bundled value angle exists — no obvious gaps left unfilled
- [ ] For comparison posts: Nexter pricing table shows all tiers at same detail level as competitor tables
- [ ] For comparison posts: "Why We Recommend Nexter" section has 2-3 written sentences before the shortcode
- [ ] `FAQPage` NOT listed in frontmatter `Schema to Add` field
- [ ] Original Additions section in Change Summary lists 2-3 new angles that did not exist in source post
---
```

### 3. Before/After Comparison
For Major and Complete rewrites:
- Original H1 vs. new H1
- Original intro vs. new intro (first 100 words)
- Sections added and removed
- Word count change
- GSC position at time of rewrite

---

## Automatic Content Scrubbing

**CRITICAL**: Immediately after saving the rewritten file, run the content scrubber.

```
1. Save rewrite → rewrites/[active-brand]/[slug]-rewrite-[YYYY-MM-DD].md
2. IMMEDIATELY run: /scrub rewrites/[active-brand]/[slug]-rewrite-[YYYY-MM-DD].md
3. Verify scrubbing stats (Unicode watermarks, em dashes, format characters)
4. THEN run optimization agents
```

**What gets cleaned:**
- Invisible Unicode watermarks (zero-width spaces, BOMs, format-control characters)
- Em dashes replaced with contextually appropriate punctuation
- Whitespace normalization

---

## Automatic Agent Execution

After scrubbing, run all five agents:

### 1. Content Analyzer Agent
- Search intent analysis, keyword density check, competitor word count comparison, readability score
- Verify internal link count meets minimum (5-6 same-domain + 1-2 cross-domain)
- Output: `rewrites/[active-brand]/content-analysis-[slug]-[YYYY-MM-DD].md`

### 2. SEO Optimizer Agent
- Compare rewritten content against SERP data from DataForSEO
- Check keyword density, heading structure, meta elements
- Output: `rewrites/[active-brand]/seo-report-[slug]-[YYYY-MM-DD].md`

### 3. Meta Creator Agent
- Generate 3 meta title options and 3 meta description options
- Score each for click-through potential
- Output: `rewrites/[active-brand]/meta-options-[slug]-[YYYY-MM-DD].md`

### 4. Internal Linker Agent
- Verify all existing internal links still point to live pages
- Check cross-domain links to sister POSIMYTH sites are present
- Suggest new linking opportunities from `context/internal-links-map.md` and `context/shared/`
- Output: `rewrites/[active-brand]/link-suggestions-[slug]-[YYYY-MM-DD].md`

### 5. Keyword Mapper Agent
- Verify primary keyword placement and density
- Map semantic keywords and GSC query coverage
- Output: `rewrites/[active-brand]/keyword-analysis-[slug]-[YYYY-MM-DD].md`

---

## Next Steps

1. Review change summary and verify all edits are intentional
2. Check Nexter compliance checklist in the change summary
3. Run `/optimize` for final polish if needed
4. Move final file to `published/[active-brand]/` when ready
5. Note the original URL and confirm no slug has changed
