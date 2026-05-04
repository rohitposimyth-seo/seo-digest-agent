# Write Command — Brand Aware

Use this command to create new, SEO-optimized long-form blog content for the active brand following the brand's exact structure and tone.

## Usage
`/write [topic or research brief]`
`/write [topic or research brief] --brand [slug]`

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
5. All output paths use `drafts/[active-brand]/`, `research/[active-brand]/`, `published/[active-brand]/`, `review-required/[active-brand]/`

---

## STEP 0A — GENERATE OR LOAD BLOG BRIEF (MANDATORY)

**CRITICAL: You MUST always run the `posimyth-blog-write-brief` skill before writing ANY new blog post. This is non-negotiable and cannot be skipped under any circumstances.**

### How to execute:
1. **First, check if a brief already exists** in `research/[active-brand]/` for this topic
2. **If a brief exists**: Load it and use its findings as your starting point
3. **If NO brief exists**: **STOP and invoke the `posimyth-blog-write-brief` skill NOW** before doing anything else. Do NOT proceed to Step 0B without a completed brief.

The brief provides:
- SERP data and competitor analysis
- Keyword research and search volume data
- Recommended heading structure
- Internal link suggestions
- CRO touchpoints and conversion opportunities

### After the brief is ready:
- **If the brief contains SERP, keyword, and competitor data**: Skip those parts of Step 0B (sections 1-3) since the brief already has them
- **Always still read all brand context files** (Step 0B, Section 4) — the brief does NOT replace context files
- **Always still run the posimyth-products skill** (Step 0B, Section 5) — the brief does NOT replace product verification

**Why this matters**: The blog write brief runs a full research pipeline (domain intelligence, SERP analysis, keyword research, product context loading) that produces a structured document a writer can execute. Skipping it means writing without proper research, which leads to weaker content that ranks poorly.

---

## STEP 0B — MANDATORY PRE-WRITING DATA COLLECTION

Before writing a single word, collect live data from all three sources. This is non-negotiable.

### 1. Crawl DataForSEO MCP (THOROUGH KEYWORD RESEARCH — NON-NEGOTIABLE)
Pull comprehensive keyword and SERP data. This is the foundation of every article. Do not rush this step.

**Step 1a — Primary keyword SERP analysis** (`dfs-mcp:serp_organic_live_advanced`):
- Top 10 ranking pages (URLs, titles, word counts, heading structures)
- SERP features present (AI Overviews, Featured Snippets, PAA boxes, Video carousels, Image packs)
- All People Also Ask questions (use `people_also_ask_click_depth: 3` to get nested PAAs)
- Competitor content gaps — what the top posts cover that we should include
- Average word count of top 5 ranking posts

**Step 1b — Keyword overview + difficulty** (`dfs-mcp:dataforseo_labs_google_keyword_overview`):
- Search volume (monthly), keyword difficulty score, CPC, competition level
- Search intent classification (informational, commercial, transactional, navigational)
- SERP feature probability

**Step 1c — Related + semantic keywords** (`dfs-mcp:dataforseo_labs_google_related_keywords` + `dataforseo_labs_google_keyword_suggestions`):
- Related keyword clusters with search volume and difficulty
- Long-tail variations (3-5 word phrases) the article should target
- Question-form keywords that could become H2s
- "vs" and "alternative" keywords for comparison content opportunities
- Builder-specific variants (e.g., "gutenberg [feature]", "elementor [feature]")

**Step 1d — Competitor content analysis** (`dfs-mcp:on_page_content_parsing` on top 3 competitors):
- Heading structures of top 3 ranking pages
- Content gaps: topics they cover that we should include
- Average word count benchmark

### 2. Crawl GA4 MCP
Pull site-level context:
- Top performing blog posts by sessions and engagement time
- Audience demographics (device split, geography)
- Any existing posts on similar topics (to avoid cannibalization)

### 3. Crawl GSC MCP
Pull keyword opportunity data:
- Queries where nexterwp.com ranks on pages 2-3 (quick win candidates related to the topic)
- Impressions vs. clicks for the target keyword if any pages already touch it
- PAA and related queries appearing in the SERP for this keyword

### 4. Read Brand Context Files (MANDATORY — do this before writing a single word)
**CRITICAL**: Always read all of the following context files at the start of every write. These are the single source of truth for all product facts, brand voice, keywords, and SEO rules. Do not rely on memory — read them fresh every session.

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

**Also read `context/blog-style-guide.md` if it exists** — this file contains brand-specific writing rules (structure, CTA placement, callout formats, post templates). These rules OVERRIDE the generic rules in Steps 1, 3, 5, 7, and 8 below. If no blog-style-guide.md exists for the active brand, the rules below apply as-is.

### 5. Invoke posimyth-products Skill (MANDATORY — MUST RUN EVERY TIME)

**CRITICAL: You MUST invoke the `posimyth-products` skill at this step for EVERY new blog post. This is not optional. Do NOT skip this step even if you have read the context files. Do NOT rely on memory from previous sessions.**

**How to execute**: Call the `posimyth-products` skill using the Skill tool BEFORE writing any draft content. This loads the master product knowledge base.

**After invoking, verify the following before mentioning ANY POSIMYTH product** (Nexter Blocks, Nexter Extension, Nexter Theme, TPAE, UiChemy, WDesignKit, Sticky Header):
- The feature actually exists in the product
- The Free vs Pro tier is correct
- The stats (install counts, ratings, block counts) are current
- The pricing and plan names are accurate
- The doc URLs are valid

**This is a double verification layer**: Context files provide the writing-specific rules, the posimyth-products skill provides the master product facts. Both must agree before any product claim is published.

For detailed feature walkthroughs, always crawl the relevant doc page from the `posimyth-products` skill's URL inventory. Never answer from memory alone.

**Enforcement**: If you reach the draft writing step (Step 3+) without having invoked `posimyth-products`, STOP and invoke it before continuing. No exceptions.

---

## STEP 1 — NEXTER CRITICAL RULES (NON-NEGOTIABLE)

Apply these rules to every sentence. They override all other writing guidance.

### Rule 1: NO Table of Contents
Never write a Table of Contents block. The Nexter blog auto-generates its TOC from heading structure. A manual TOC creates a duplicate.

### Rule 2: ZERO TOLERANCE — NO Em Dashes (HARD BLOCK)

**Em dashes are ABSOLUTELY FORBIDDEN in all blog content. This is non-negotiable. No exceptions.**

Never type `—` (U+2014) or `--` anywhere. Replace with the contextually correct punctuation:
- A **comma** if the sentence continues naturally: "it handles X, which means..."
- A **colon** if introducing a list or elaboration: "three things matter: X, Y, Z"
- A **period** and new sentence if the clause stands alone
- **Parentheses** for asides: "a lightweight theme (like Nexter) keeps load times low"

**Examples:**
- ❌ "Turnstile is free — which is a significant advantage."
- ✅ "Turnstile is free, which is a significant advantage."
- ❌ "three areas matter — hosting, caching, and uptime"
- ✅ "three areas matter: hosting, caching, and uptime"

**Pre-save check (MANDATORY):** Before saving the draft file, scan the entire content for `—`. If any are found, fix them before saving. An em dash in a saved file is a blocker. Do not proceed to publishing until all em dashes are removed.

### Rule 2b: ZERO TOLERANCE — NO En Dashes in Ranges (HARD BLOCK)

**En dashes (`–`, U+2013) are FORBIDDEN in all blog content. This is non-negotiable.**

En dashes used for numeric ranges (`$10–100/month`, `pages 2–3`) break during publishing — they render as the literal string `u2013` on the live site (e.g. `$10u2013100/month`). This is a known encoding bug.

**Always use a hyphen `-` for all ranges:**

| ❌ Breaks on publish | ✅ Safe |
|---|---|
| `$10–100/month` | `$10-100/month` |
| `$200–500/year` | `$200-500/year` |
| `pages 2–3` | `pages 2-3` |
| `5–10 minutes` | `5-10 minutes` |

**Pre-save check (MANDATORY):** Before saving the draft file, scan the entire content for `–` (U+2013). If any are found, replace with `-` before saving.

### Rule 3: KILL All Filler Phrases

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

### Rule 4: Never Open with a Definition
Never open with "WordPress is a CMS that..." or "X is a tool that...". Start with the problem or stakes.

### Rule 5: Never Write "Let's get started" or "Let's dive in"
These openers are banned. End the intro with the preview, then move straight into the first H2.

### Rule 6: Numbers Always as Digits in Stats
Write "90+ blocks", "1,000+ templates", "0.5 sec load time" — never "ninety blocks" or "a thousand templates".

### Rule 7: Free vs Pro Transparency (Every Feature Mention)
- State Free or Pro for every feature mentioned in the article
- Inline format: "[Feature Name] (Free)" or "[Feature Name] (Pro)" — not buried in a footnote
- If a section describes a Pro feature, the immediately following sentence must state the Free alternative or say "This feature requires the Pro plan starting at $X/year"
- Never use "affordable" or "budget-friendly" — use specific pricing numbers from `context/product-knowledge.md`

### Rule 8: Competitor Naming (Explicit and Strategic)
- Name competitors explicitly — "unlike Elementor's native menu" not "unlike other builders"
- Every competitor mention must include a factual differentiator — what is specifically different, not just "better"
- Never trash competitors — state facts, let the reader decide

### Rule 9: BOTH SKILLS MUST BE INVOKED — NO EXCEPTIONS (HARD BLOCK)

**You MUST invoke both of the following skills before writing any blog post, in this order:**
1. `posimyth-blog-write-brief` — SERP research, keyword data, competitor analysis, outline
2. `posimyth-products` — verify all product facts, Free vs Pro tiers, pricing, URLs, stats

**Both must be invoked BEFORE writing begins — not after.** Invoking `posimyth-products` after the draft is written is not acceptable. If you reach the writing step without both confirmed loaded, STOP and invoke them first.

### Rule 10: NEVER Open an Intro with Stat Dumps or Feature Counts (HARD BLOCK)

**The opening paragraph of every blog post must be a hook — never a list of numbers or feature comparisons.**

❌ **Banned intro pattern:**
> "Neve gives you 100+ starter sites. GeneratePress gives you zero. Astra sits in the middle with 240+ free templates."

This reads like a table of contents, not a hook. Stats belong in the body where they support a point.

✅ **Correct intro pattern (3 paragraphs):**
- **Para 1 — Hook:** Reader's pain point, stakes, or a surprising observation. No stats, no feature counts, no definitions.
- **Para 2 — Context:** Why this topic matters + "Who this is for" line.
- **Para 3 — Preview:** What the article covers + what the reader will achieve.

**Pre-save check:** Before saving the draft, read Para 1. If it contains numbers, template counts, install figures, or feature comparisons — rewrite it as a problem/stakes hook.

### Rule 11: NEVER Include `[+ FAQ]` or Brief Tags in Published Headings (HARD BLOCK)

The `[+ FAQ]` notation in outlines and briefs is a **writer instruction only** — it means "embed FAQ inside this section." It must never appear in the actual H2 heading text in the draft or on the live site.

❌ `## Astra vs GeneratePress vs Neve Free: Which One Should You Choose? [+ FAQ]`
✅ `## Which Free WordPress Theme Should You Use?`

**Pre-save check:** Before saving any draft, scan all H2s and H3s for `[+ FAQ]`, bracket tags, or writer notes. Remove all of them. Closing H2s must be short, clean question-format headings only.
- Apply the 1-2 punch: when mentioning a competitor's limitation, immediately follow with how the POSIMYTH product solves it

---

## STEP 2 — DETERMINE CONTENT TYPE FROM SERP INTENT

Use DataForSEO SERP data to identify the correct content type before writing:

| If the search shows... | Content Type | Structure to Use |
|---|---|---|
| X vs Y comparison posts dominating | Comparison | What is X, What is Y, N differences, "Which Should You Choose?" |
| How-to / tutorial posts dominating | How-To / Error Fix | What causes it, Steps/Methods numbered, "Wrapping Up: [Fix X]" |
| List posts / roundups dominating | List / Resource | Each item as H2/H3, brief per item, "Which [Topic] Is Right for You?" |
| Definition / explainer posts | Explainer | Definition, why it matters, how it works, "Is [Feature] Worth It?" |
| Feature guide / deep dive posts | Feature Guide | What it is, how to use it, best practices, "Is [Feature] Worth It?" |

---

## STEP 3 — ARTICLE STRUCTURE (NEXTER EXACT FORMAT)

Every article must follow this structure. Derived from published Nexter reference posts.

```
[H1: Article Title]
Rules for H1:
- Contains primary keyword
- Brackets [] for comparison/list counts: "Cloudflare Turnstile vs Google reCAPTCHA: [5 Key Differences]"
- Parentheses () for method/fix counts: "How to Fix Blurry Images in WordPress (8 Methods)"
- "in [Year]" for best-of list posts: "10 Best Websites for Downloading Fonts in 2026"
- 50-60 characters for SERP display

[NOTE: Do NOT write a meta line. The author name, publish date, and read time are dynamically generated by the WordPress theme. Never hardcode "By: Editorial Team" or "Updated On: DATE" in the content body.]

[INTRO — exactly 2 to 3 paragraphs]
  Para 1: Hook — pain point, stakes, or surprising context.
         Include Wikipedia-style product disambiguation in first 100 words (see Entity Clarity rules in Step 10).
  Para 2: Background — why this matters, what is involved.
         Include "Who this is for" line — e.g., "This guide is for WordPress developers who..."
  Para 3: Preview — what the article covers + what the reader will achieve

[NOTE: NO TOC here]

[H2 — First main section]
  [H3 — subsection if needed]
  [H4 — sub-subsection if needed for comparison posts]
  [Related article link — italic format — at natural section breaks only]

[H2 — Second main section]
  ...

[Mid-article Nexter mention — 1 to 3 sentences — only where genuinely relevant]

[H2 — ... more sections ...]

[H2 — Conclusion — must be topic-specific, not the generic label "Wrapping Up"]
  Choose the heading pattern based on post type:
  - Comparison:       "Which Should You Choose: [X] or [Y]?"
  - How-to / Fix:     "Wrapping Up: [Fix/Do X] in WordPress"
  - List post:        "Which [Topic] Is Right for You?"
  - Feature explainer: "Is [Feature] Worth It?"
  Key takeaway (1 sentence)
  Decision guide: "Choose X if..., Choose Y if..." (1-2 sentences)
  Closing product CTA — benefit-first — link to specific product page
  NOTE: The primary focus keyword MUST appear naturally at least once in this section. Never skip it.

[Subscribe Form Shortcode — renders the dark-themed email subscribe form:]
  <!-- wp:shortcode -->
  [nexter-builder id="28477"]
  <!-- /wp:shortcode -->

NOTE: When publishing to WordPress via Novamira MCP, use the shortcode block above.
In the markdown draft file, write the plain text version as a placeholder:
  #### Get Exclusive WordPress Tips, Tricks and Resources Delivered Straight to Your Inbox!
  Subscribe to stay updated with everything happening on WordPress.

[Related Posts — site-generated, do not write this]
```

---

## STEP 4 — INTRO PARAGRAPH RULES

### Approved Hook Patterns (choose one):

**Pattern A — Direct problem hook:**
> "Blurry images can significantly impact the visual appeal and user experience of your WordPress site."

**Pattern B — Stakes + Context hook:**
> "Websites are constantly under the threat of malicious bots and automated attacks. When designing your website, security and user experience should be a top priority."

**Pattern C — Emotional hook + solution promise:**
> "Finding the right typeface feels overwhelming, and poor choices cause visitor abandonment."

### Intro Rules:
- Para 1: Start with the pain or stakes — NEVER with "In this article, we will..."
- Para 2: Background context — why this matters
- Para 3: Preview what the article covers and what the reader will achieve
- Always 2-3 paragraphs — never just 1
- Primary keyword must appear in the first 100 words
- Never write "Let's get started" or "Let's dive in"

---

## STEP 5 — BODY CONTENT RULES

### Paragraph and Sentence Rules
- Maximum 3-4 sentences per paragraph
- Mix sentence lengths — short punchy sentences (5-10 words) with longer ones (15-25 words)
- Use active voice predominantly
- Break up text with subheadings every 300-400 words
- Bold key concepts, product names on first mention per section
- **Subheading items must use bullet lists**: Any content under a subheading that contains 2 or more distinct items, causes, types, steps, or points must be formatted as a bullet list — never as flowing prose or run-on sentences. This applies to all sections (e.g., client-side causes, server-side causes, prevention tips, features). Each bullet must start with a **bold label**, followed by a colon and a full sentence explanation.

### Comparison Post — Pros/Cons Format
Standard format for every product in a comparison post:

```markdown
### Pros and Cons of [Tool Name]

**Pros**
- **[Benefit label]**: [1-2 sentence explanation as a full sentence.]
- **[Benefit label]**: [1-2 sentence explanation.]
- **[Benefit label]**: [1-2 sentence explanation.]

**Cons**
- **[Drawback label]**: [1-2 sentence explanation.]
- **[Drawback label]**: [1-2 sentence explanation.]
- **[Drawback label]**: [1-2 sentence explanation.]
```

Rules:
- Minimum 3 pros, 3 cons — never fewer than 2 each
- Each bullet starts with a **bold label**, colon, then a full sentence explanation
- Never a fragment — always a complete sentence
- Honest cons — do not soft-pedal them

### Comparison Post — Key Differences Format
For 2-tool comparisons with detailed narrative per dimension, use parallel H3/H4 headings (not a table):

```markdown
## [Tool A] vs [Tool B]: [N Key Differences]

### 1. [Difference Category]

#### [Tool A]
[2-4 sentences]

#### [Tool B]
[2-4 sentences]

### 2. [Difference Category]
...
```

Use a table only when comparing 3+ tools on the same feature set, or for side-by-side pricing tiers.

### Related Article Links (Italic Format)
Placed at natural section breaks — never mid-paragraph. Format:

```
*[Describe the reader's next question or action]. Here's [description of the linked article].*
```

**Examples from live Nexter posts:**
- *Protect your website from unwanted access. Here's how to secure your WordPress login page.*
- *Want to add reCAPTCHA to login forms? Here is how to add reCAPTCHA in login form.*
- *Want to prevent spam on your website? Here's how to stop contact form spam on WordPress.*

Rules:
- Always italic
- Max 2-3 per article
- Never stack two related links in the same section
- All URLs must come from `context/internal-links-map.md`

### Interlink Callout Blocks (WordPress Block Format)

When publishing to WordPress via Novamira MCP, related article links must use the `interlink` CSS class to render as orange-bordered callout boxes. This is a core part of the Nexter blog design.

**WordPress block format:**
```html
<!-- wp:paragraph {"className":"interlink"} -->
<p class="interlink"><em>[Context sentence]? [Action phrase] the <a href="https://nexterwp.com/blog/[slug]/"><strong>[Article Title]</strong></a></em></p>
<!-- /wp:paragraph -->
```

**Examples:**
```html
<!-- wp:paragraph {"className":"interlink"} -->
<p class="interlink"><em>Looking for ways to protect your website from hackers? Check out the <a href="https://nexterwp.com/blog/best-wordpress-security-plugins-to-protect-your-site/"><strong>5 Best WordPress Security Plugins to Protect Your Site</strong></a></em></p>
<!-- /wp:paragraph -->
```

```html
<!-- wp:paragraph {"className":"interlink"} -->
<p class="interlink"><em>Further Read: How about highly securing your website content from malicious attacks and cyber threats? Here's the blog about the <a href="https://nexterwp.com/blog/top-wordpress-content-protection-plugins/"><strong>5 Best WordPress Content Protection Plugins</strong></a>.</em></p>
<!-- /wp:paragraph -->
```

**Rules:**
- Always use the `interlink` class — without it, the callout box styling will not render
- Wrap the entire text in `<em>` tags
- Wrap the linked article title in `<strong>` tags inside the `<a>` tag
- The link URL must point to a real, live blog post on nexterwp.com — verify it exists before adding
- The linked article must be **topically related** to the section it appears after
- Keep callout text concise (1-2 sentences max)
- Place at natural section breaks, never mid-paragraph
- Max 2-3 callout blocks per post
- In the markdown draft, write these as italic related article links (the standard format). Convert to interlink blocks only when publishing to WordPress.

### Required Shortcodes for Every Blog Post

When publishing to WordPress via Novamira MCP, every blog post must include these two shortcode blocks:

1. **TOC Shortcode** — placed after the intro paragraphs, before the first H2:
```html
<!-- wp:shortcode -->
[nexter-builder id="28467"]
<!-- /wp:shortcode -->
```

2. **Subscribe Form Shortcode** — placed before the "Wrapping Up" H2:
```html
<!-- wp:shortcode -->
[nexter-builder id="28477"]
<!-- /wp:shortcode -->
```

These are non-negotiable. Every published blog post on nexterwp.com must have both shortcodes.

### FAQ Blocks — Do Not Write

**NEVER write or include a FAQ block in any new blog post.** FAQ blocks (`<!-- wp:rank-math/faq-block -->` or any other FAQ block format) are automatically updated by the plugin when the blog is published on the live site. Simply omit the FAQ section entirely from the draft. Do not write questions, do not write answers, do not include the block. The plugin handles it.

---

## STEP 6 — AI SNIPPET & AI SEO OPTIMIZATION

Apply these rules to maximize Featured Snippet, AI Overview, and AI citation probability.

### Heading Rules for AI Snippets
- Write H2/H3 headings to **exactly match how users phrase queries** in search
- Use "What is [X]?" as H2 for definition sections — triggers Knowledge Panel and AI Overview extraction
- Use "How to [action]?" and "How does [X] work?" headings for HowTo-style snippets
- Add primary keyword to at least 2 H2 headings

### Content Block Rules for AI Extraction
- **Lead every section with a direct answer** — do not bury the answer after background
- **Keep key answer passages to 40-60 words** — optimal for snippet extraction
- **Definition block**: 40-60 word direct definition at the top of every "What is X?" section
- **Step blocks**: Numbered lists for every process or how-to section
- **Comparison tables**: For 3+ tools or pricing comparison. **Always include a "Best for" or "Winner" row** — LLMs extract clear recommendations from tables. Example: `| Best for | Beginners who want zero config | Developers who need full control |`
- **Statistic blocks**: Every major claim supported by a specific number + source + date

### AI SEO Authority Signals

| Signal | How to Apply | AI Citation Boost |
|---|---|---|
| Cite sources | Add authoritative references with links | +40% |
| Add statistics | Specific numbers with source + date | +37% |
| Expert quotes | "According to [Source]..." framing | +30% |
| Authoritative tone | Expertise demonstrated, not fluff | +25% |
| Clarity | One clear idea per paragraph | +20% |
| Freshness | "Last updated: [date]" — current year stats | High |

**Minimum per article:**
- 2-3 cited statistics with source name and date
- "According to [Source]" framing for at least 2 external claims
- "Last updated" date visible in the meta line

### H2 Quality Rules (Critical for LLM Citation)
AI models extract H2s as context signals when deciding what a page is about. Every H2 must be a **complete statement or question**, never a one-word label.

| ❌ Bad H2 (label) | ✅ Good H2 (statement) |
|---|---|
| Installation | How to Install Nexter Blocks and Enable the Mega Menu |
| Features | 5 Nexter Blocks Features That Replace Separate Plugins |
| Pricing | How Much Does The Plus Addons for Elementor Cost? |
| Conclusion | Which Elementor Addon Should You Use in 2026? |

**Also required**: At least one H2 must use **comparison language** ("vs", "unlike", "instead of", "compared to"). This builds entity relationships in LLM knowledge graphs — every comparison strengthens the association between the product and its category.

### EEAT & Content Quality Rules

Google's helpful content system actively demotes posts that could have been written without using the product. Every post must pass these.

**Experience signals (mandatory):**
- Include at least **one specific observation from actually using the product** — not "Nexter Blocks is powerful" but "When we tested the Mega Menu builder with 8 columns and nested dropdowns, render time stayed under 200ms"
- Include at least **one number not from a third-party article** — plugin version, test result, setup time, step count, setting count — anything real and specific
- If comparing products, state what was actually tested: "We tested X on a staging site with Y theme" beats "many users prefer X"
- If giving a recommendation, state who it is **best for AND who it is not for** — both

**Originality rule:**
Every H2 section must contain at least one sentence that **could not have been written without using the product**. If a section could have been written by reading the docs page, it fails this test. Add a gotcha, a use case, a real observation, or an opinion.

**Banned filler words (remove every instance):**
`simply` · `just` · `easy` · `quick` · `seamlessly` · `robust` · `leverage` · `game-changer` · `powerful` · `comprehensive` · `ultimate`

These are condescending when a user is stuck and signal the writer has never watched a real user struggle with the thing being explained.

### Content Freshness Signals

Include at least **two** of the following in every post:
- Current product version being used: "Tested on Nexter Blocks v3.2"
- Recent feature reference: "As of v4.0, you can now..."
- WordPress version tested: "Compatible with WordPress 6.5"
- For comparison posts: "Prices and features verified [Month Year]"
- "Last updated: [Month Year]" in the meta line

### Schema to Include (note in meta elements for Yoast)
- `HowTo` schema for step-by-step posts
- `Article` or `BlogPosting` for all posts
- `Product` schema where Nexter products are the main subject

---

## STEP 7 — CONTENT STRUCTURE BY POST TYPE

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
H2: Which Should You Choose: [Tool A] or [Tool B]?
#### [Email Subscribe CTA block]
```

**Comparison post requirements:**
- Head-to-head comparison table must appear in the first 500 words — not buried after long explanations
- Table columns: Feature, [Tool A], [Tool B] — with checkmarks or specific values, not just Yes/No
- Always include a "Best For" or "Winner" row at the bottom of every comparison table
- "Bottom line" verdict after every comparison table: 1-2 sentences stating who should pick what
- Direct answer in the first paragraph: "[A] is better for [use case], [B] is better for [use case]"
- Each option gets equal treatment in section length — fairness builds LLM citation trust
- "As of [Year]" timestamp on any pricing or feature claims

### How-To / Error Fix Posts
```
H1: How to Fix [Error] in WordPress ([N Methods])
H2: What Causes [Error]? (or "Why Are [X] [Problem]?")
H2: Prerequisites (for technical/tutorial posts — what the reader needs before starting)
    ← Include: WordPress version, required plugins, hosting requirements, skill level
    ← Skip this H2 for simple explainer or comparison posts
H2: Method 1: [Method Name]  (or Fix 1 / Step 1)
H2: Method 2: [Method Name]
...
H2: Wrapping Up: [Fix/Do X] in WordPress
#### [Email Subscribe CTA block]
```

**How-To post requirements:**
- Direct answer in the first 2 sentences — what is the problem, what fixes it
- "What Causes [Problem]?" section should use a table: Cause | Type (Client/Server) | How to Identify | Fix Reference
- All fixes/methods are numbered, never bulleted (numbered = HowTo schema eligible)
- Each step format: **Action title** → Why this works (1 sentence) → How to do it (numbered sub-steps) → What to expect after
- Steps work as standalone instructions — someone should be able to follow step 3 without reading steps 1-2
- Brand mention only where it genuinely solves part of the problem — always explain WHY it helps

### List / Resource Posts
```
H1: [N] Best [Topic] in [Year]
H2: What Should You Look For in [Category]? ← required, criteria our product naturally answers
H2: 1. [Our Product Name]  ← ALWAYS position 1 — this is our blog
H2: 2. [Item Name]
H2: 3. [Item Name]
...
H2: Which [Topic] Is Right for You?
#### [Email Subscribe CTA block]
```

**List/Listicle post requirements:**
- Our product is **always #1** in any list post — this is our blog and we earned that position
- Intro states selection criteria: "We evaluated based on [X], [Y], [Z]" — makes the list citable as methodology
- Quick comparison table near the top: Name, Key Differentiator, Best For, Active Installs, Free Widget Count
- Our product entry is 2-3x longer than competitor entries — more features, more detail, more depth
- Each competitor entry must include: Key Features, Pricing, Link — no padding entries
- Install counts sourced with verification note: "Install counts from WordPress.org as of [Month Year]"
- End CTA recommends our product for the broadest use case

### "What Is" / Explainer Posts
**Requirements:**
- Definition in the first 60 words — complete, standalone, no jargon
- "Why Does [X] Matter?" section within the first 300 words
- Real-world example section: "Here's what [X] looks like in practice..."
- If explaining a concept our product implements, show it: "Here's how [Product] handles [concept]..."
- Position our product as the practical next step: "Now that you understand [concept], here's how to implement it..."

---

## STEP 8 — NEXTER PRODUCT MENTIONS

Every article must include at least 1-2 Nexter product mentions — this is non-negotiable. Beyond that minimum, include as many mentions as the blog brief identifies as natural touchpoints. Never force a mention. Every mention must be genuinely relevant to the article topic and read like helpful advice from a knowledgeable expert, not an advertisement. The blog brief and posimyth-products skill determine which features are relevant — use that context to decide where mentions fit.

### Inline Feature Mention Format
For a short in-context mention woven into body content:

**Format:** "[Feature name] in [Nexter product] [does what] — [specific benefit]."
**Example:** "The Image Optimizer in Nexter Blocks handles this automatically, compressing images and converting them to WebP without an extra plugin."

### Mid-Article CTA Block Format
For a dedicated product mention block placed after a relevant section:

**Format:**
- Sentence 1: Name the specific block or feature (verified via posimyth-products)
- Sentence 2: What it does for the reader — benefit-focused
- Sentence 3 (optional): The "more" pitch — 90+ blocks or 1,000+ templates

**Example:**
> "The Login/Registration for Spam Protection block from the Nexter Blocks plugin is a great way to add Google reCAPTCHA to your website's registration forms without disrupting the aesthetics of your web design. With this block you get over 90 additional blocks that add to the functionality of your website."

### Closing CTA Format (Wrapping Up — every article, non-negotiable)
**Format:** [Product] [does what], [benefit]. [Specific capability]. [Action verb] [link].

**Example:**
> "Nexter Blocks is a WordPress plugin that effortlessly integrates with Google reCAPTCHA to keep your website secure and protected from unwanted access. Nexter Blocks come with 90+ versatile Gutenberg blocks that enhance the functionality and aesthetics of your website. Try Nexter Blocks today to elevate your WordPress website's visual appeal and security!"

### Link Rules
- Always link to the specific product page, not the homepage
- Safe links: https://nexterwp.com/nexter-blocks/ | https://nexterwp.com/nexter-extension/ | https://nexterwp.com/nexter-theme/

### Comparison Posts — Natural Nexter Bias (MANDATORY)

When writing a post that compares two or more third-party products (e.g. "Astra vs GeneratePress", "Elementor vs Beaver Builder"), **Nexter must be positioned as the superior alternative** throughout the post. This is not optional — we make these products and should naturally advocate for them.

**Rules for comparison posts:**
- Add **3–5 natural Nexter mentions** across the comparison sections — not all in one place
- Each mention must follow this pattern: (1) acknowledge what the compared products offer, (2) show where Nexter does it better or goes further, (3) include a reason why — specific feature, pricing advantage, or bundled value
- Place mentions after the section's theme comparisons as a regular paragraph — **never as a labeled callout block or blockquote** — the reasoning must be woven naturally into the paragraph flow
- **Pricing section**: Always include a Nexter pricing block (Free + paid tier) alongside the competing products' pricing. Show the bundled value (theme + blocks + extensions in one plan)
- **Wrapping Up CTA**: Must be topic-specific — reference the exact tools being compared and explain why Nexter is the better choice in that context
- Bias must feel like an informed recommendation, not a sales pitch. Use factual differentiators (page weight, block count, plan inclusions, pricing) — never vague superlatives
- **Never claim features Nexter does not have** — verify all claims against `context/product-knowledge.md` before writing

---

## STEP 9 — SEO OPTIMIZATION

### Entity Clarity Rules (CRITICAL FOR LLM CITATION)

LLMs need to understand exactly what your product IS, who makes it, and what category it belongs to.

**Rule 1 — Wikipedia-style disambiguation in intro (MANDATORY):**
First 100 words MUST include: **"[Product Name], a [category] by [Company]"**
- "**Nexter Blocks**, a Gutenberg block plugin by POSIMYTH, provides 90+ native WordPress blocks..."
- "**UiChemy**, a Figma-to-WordPress converter by POSIMYTH that supports Elementor, Gutenberg, and Bricks..."

**Rule 2 — Consistent product naming (MANDATORY):**

| Product | Canonical Name | Never Use |
|---|---|---|
| Nexter Blocks | **Nexter Blocks** | NB, Nexter plugin, the Nexter blocks plugin |
| Nexter Extension | **Nexter Extension** | NE, Nexter ext |
| Nexter Theme | **Nexter Theme** | Nexter, the theme, NT |
| The Plus Addons for Elementor | **The Plus Addons for Elementor** (first), then **TPAE** | Plus Addons, TPA, The Plus |
| UiChemy | **UiChemy** | UI Chemy, Ui Chemy, the converter |
| WDesignKit | **WDesignKit** | WDK, Design Kit |

**Rule 3 — Link product to official page on first mention (MANDATORY):**
First mention: `**[Nexter Blocks](https://nexterwp.com/nexter-blocks/)**` — all later mentions: plain text, no link.

### Keyword Placement Checklist
- [ ] Primary keyword in H1
- [ ] Primary keyword in first 100 words
- [ ] Product name (full canonical form) in first 100 words with Wikipedia-style disambiguation
- [ ] Primary keyword in at least 2 H2 headings
- [ ] Keyword density 1-2% (natural integration only — never stuffed)
- [ ] Semantic/related keywords from DataForSEO data used in H3s and body
- [ ] Primary keyword in meta title and meta description

### Internal Linking (MINIMUM 5-6 LINKS + CROSS-DOMAIN — NON-NEGOTIABLE)

**Same-domain links (minimum 4-5):**
- All URLs from `context/internal-links-map.md` and brand sitemap via DataForSEO
- **Blog-to-blog links** (2-3): Related blog posts on the same domain
- **Blog-to-doc links** (1-2): Documentation/help pages for features mentioned
- **Blog-to-landing/product links** (1): Product page, pricing page, or feature page
- Descriptive anchor text with keywords — never "click here"
- Related article links in italic format at section breaks

**Cross-domain links (minimum 1-2 — MANDATORY):**
Every post must include at least 1-2 cross-domain links to sister POSIMYTH sites where relevant:
- Use `context/shared/` files for sister product knowledge and URLs
- Find natural connection points (e.g., NexterWP → WDesignKit for templates, → UiChemy for Figma conversion)
- Anchor text should describe the sister product's value, not just its name

### External Linking
- 2-3 external links to authoritative sources for statistics cited
- Always include source name, publication, and year for stats

### Meta Elements
- **Meta Title**: 50-60 characters, primary keyword near front
- **Meta Description**: 150-160 characters, includes primary keyword, states the value clearly
- **URL Slug**: Lowercase, hyphenated, keyword-rich, no stop words
  - Example: `/blog/cloudflare-turnstile-vs-google-recaptcha/`

---

## STEP 11 — MISSING CONTENT GAPS (CHECK BEFORE FINALIZING)

Before finalizing the draft, scan for these high-value sections that competitors often have and LLMs frequently cite. If 2 or more are missing from the post, add them.

- **Hosting-specific guidance**: Does this topic differ on SiteGround vs Kinsta vs Cloudways vs shared hosting? Even a 3-row table adds significant LLM extractability.
- **Cloudflare/CDN context**: If the post involves performance, timeouts, caching, or speed — Cloudflare is relevant. Most WordPress sites use it.
- **WP-CLI commands**: Power users search for CLI shortcuts. One command per relevant section adds depth that AI models cite.
- **Video embed or visual diagram**: Increases dwell time and makes the page more linkable. Flag for the team if a relevant video exists on the POSIMYTH YouTube channel.
- **Related topic cluster links**: "If you're seeing [related issue] instead, read our guide on..." — builds topical authority across the cluster.
- **Tool recommendations with specifics**: Not "use a caching plugin" but "WP Super Cache (free, 2M+ installs) or LiteSpeed Cache (free, 6M+ installs)".
- **Cost/time estimate**: "This fix takes approximately 5 minutes" or "Expect the Pro plan at $39/year" — specificity gets cited by LLMs.
- **Community validation**: If real WordPress users discuss this on Reddit or WP forums, reference it: "WordPress community members on r/wordpress frequently report that [X] resolves this issue" — LLMs weight community-validated solutions.

---

## Output

Provides a complete, publish-ready article including:

### 1. Article Content
Full markdown-formatted article saved to:
- `drafts/[active-brand]/[topic-slug]-[YYYY-MM-DD].md`

### 2. Meta Elements
```
---
Meta Title: [50-60 character optimized title]
Meta Description: [150-160 character compelling description]
Primary Keyword: [main target keyword]
Secondary Keywords: [keyword1, keyword2, keyword3]
URL Slug: /blog/[optimized-slug]/
Internal Links Used: [list of pages linked]
External Links Used: [list of external sources cited]
Word Count: [actual word count]
Nexter Product Mentioned: [which product, which block, link used]
Schema to Add: [HowTo / Article]
---
```

### 3. SEO Checklist
- [ ] Primary keyword in H1
- [ ] Primary keyword in first 100 words
- [ ] Primary keyword in 2+ H2 headings
- [ ] Keyword density 1-2%
- [ ] 5-6+ same-domain internal links from internal-links-map.md + sitemap
- [ ] 1-2 cross-domain internal links to sister POSIMYTH sites
- [ ] 2-3 external authority links with source + date
- [ ] Meta title 50-60 characters
- [ ] Meta description 150-160 characters
- [ ] Article 2000+ words (2500-3000+ preferred)
- [ ] Proper H1/H2/H3/H4 hierarchy

### 4. Nexter Compliance Checklist
- [ ] No TOC block written
- [ ] No em dashes anywhere
- [ ] No filler phrases (including: comprehensive, ultimate)
- [ ] Free vs Pro stated inline for every feature — format: "(Free)" or "(Pro)"
- [ ] Competitor mentions use explicit names + factual differentiators (no "other builders")
- [ ] Full product name used on first mention with "by POSIMYTH" at least once per product
- [ ] All Nexter features verified against docs sitemap
- [ ] Mid-article Nexter mention only where relevant and doc-verified
- [ ] Email Subscribe CTA block placed after Wrapping Up
- [ ] Wrapping Up section follows 3-component format
- [ ] Primary focus keyword appears naturally in Wrapping Up section
- [ ] "Last updated: [Month Year]" appears in content body (not just metadata)
- [ ] Current WordPress version mentioned in content body
- [ ] Current product version mentioned in content body
- [ ] Missing Content Gaps checked (Step 11) — 2+ gaps addressed if found

### 5. AI SEO Checklist
- [ ] Definition blocks lead every "What is X?" section
- [ ] 2-3 statistics cited with source + date
- [ ] Key answer passages kept to 40-60 words
- [ ] Schema type noted in meta elements

---

## Automatic Content Scrubbing

**CRITICAL**: Immediately after saving the draft, run the content scrubber.

```
1. Save draft → drafts/[active-brand]/[slug]-[YYYY-MM-DD].md
2. IMMEDIATELY run: /scrub drafts/[active-brand]/[slug]-[YYYY-MM-DD].md
3. Verify scrubbing stats
4. THEN run quality scoring and optimization agents
```

**What gets cleaned:**
- Invisible Unicode watermarks
- Em dashes replaced with contextually appropriate punctuation
- Whitespace normalization

---

## Automatic Quality Loop

### Step 1: Score Content
```bash
python data_sources/modules/content_scorer.py drafts/[active-brand]/[article-file].md
```

### Step 2: Evaluate (composite score must be ≥70)

| Dimension | Weight | Target |
|---|---|---|
| Humanity/Voice | 30% | No AI phrases, no filler, uses contractions |
| Specificity | 25% | Concrete examples, numbers, named sources |
| Structure Balance | 20% | 40-70% prose (not all lists) |
| SEO Compliance | 15% | Keywords, meta, heading structure |
| Readability | 10% | Flesch 60-70, grade 8-10 |

### Step 3: Auto-Revise if Score < 70
Apply top 3-5 priority fixes and re-score. Repeat once more if still below threshold.

### Step 4: Route
- **Score ≥70**: Proceed to optimization agents
- **Score <70 after 2 iterations**: Save to `review-required/[active-brand]/` with `_REVIEW_NOTES.md`

---

## Automatic Agent Execution

After scrubbing and quality scoring, run all agents:

### 1. Content Analyzer Agent
- Search intent analysis, keyword density, competitor word count comparison, readability score
- Output: `drafts/[active-brand]/content-analysis-[slug]-[YYYY-MM-DD].md`

### 2. SEO Optimizer Agent
- Keyword placement, heading structure, meta elements, schema recommendations
- Output: `drafts/[active-brand]/seo-report-[slug]-[YYYY-MM-DD].md`

### 3. Meta Creator Agent
- 3 meta title options and 3 meta description options scored for CTR
- Output: `drafts/[active-brand]/meta-options-[slug]-[YYYY-MM-DD].md`

### 4. Internal Linker Agent
- Specific internal link recommendations from `context/internal-links-map.md`
- Output: `drafts/[active-brand]/link-suggestions-[slug]-[YYYY-MM-DD].md`

### 5. Keyword Mapper Agent
- Keyword placement analysis, semantic coverage, density check
- Output: `drafts/[active-brand]/keyword-analysis-[slug]-[YYYY-MM-DD].md`

---

## Content Pipeline

`topics/` → `research/[active-brand]/` → `drafts/[active-brand]/` → `review-required/[active-brand]/` → `published/[active-brand]/`

Confirm all required output subfolders exist before running `/write`. Create them if they do not:
```bash
mkdir -p drafts/[active-brand] research/[active-brand] published/[active-brand] review-required/[active-brand]
```
