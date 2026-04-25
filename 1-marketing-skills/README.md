# Marketing Skills Pack

59 Claude Code skills for paid ads, SEO, CRO, copywriting, strategy, and frontend polish. Drop them into `~/.claude/skills/` and they're invokable via `/<skill-name>` or auto-trigger when context matches.

## Install

```bash
cp -R skills/* ~/.claude/skills/
```

Restart Claude Code. That's it.

---

## Organized by use case

### Google Ads
Everything Google: Search, Performance Max, YouTube, Display, Demand Gen.

| Skill | What it does |
|---|---|
| `ads-google` | Full Google Ads deep analysis — 80 checks across conversion tracking, wasted spend, account structure, keywords, ads, settings. Triggers on "Google Ads / PPC / search ads / PMax." |
| `ads-youtube` | YouTube ads strategy — video ad formats, targeting, audience layering, view-through measurement. |

### Facebook / Meta Ads
Everything Meta: Facebook + Instagram, Advantage+, CAPI, fatigue tracking.

| Skill | What it does |
|---|---|
| `ads-meta` | Meta Ads deep analysis — 50 checks across Pixel/CAPI health, creative diversity & fatigue, account structure, audience targeting, Advantage+ assessment. Triggers on "Meta / Facebook / Instagram Ads / Advantage+." |

### Other Ad Platforms

| Skill | What it does |
|---|---|
| `ads-tiktok` | TikTok Ads — Spark Ads, native creative spec, audience targeting, attribution. |
| `ads-linkedin` | LinkedIn Ads — Sponsored Content, Message Ads, ABM, B2B audience patterns. |
| `ads-microsoft` | Microsoft (Bing) Ads — Search + Audience network, import-from-Google patterns. |
| `ads-apple` | Apple Search Ads — App Store campaigns, keyword discovery, CPI optimization. |

### Cross-Platform Ad Strategy + Ops

| Skill | What it does |
|---|---|
| `ads-audit` | Full multi-platform audit. Parallel subagent delegation across Google + Meta + LinkedIn + TikTok + Microsoft. Per-platform + aggregate health score. |
| `paid-ads` | Generic paid-ads orchestration — picks the right platform skill for the question. |
| `ads-plan` | Build a paid acquisition plan from scratch. Channel mix, budget split, test calendar. |
| `ads-budget` | Budget allocation math — how much per channel, per campaign, scaling rules. |
| `ads-math` | CPL → CAC → LTV → payback period math. ROAS targets. Hormozi-style economics. |
| `ads-test` | A/B and multi-variant test design. Sample size, statistical significance, sequential testing. |
| `ads-create` | End-to-end ad creation workflow. Brief → creative → copy → launch. |
| `ads-creative` | Creative strategy — angles, hooks, hero shots, fatigue mitigation. |
| `ads-photoshoot` | Photoshoot brief — shot list, locations, props, talent direction for ad creative. |
| `ads-landing` | Landing page strategy for paid traffic — message match, above-fold, conversion path. |
| `ads-dna` | Deconstruct competitor / winning ads. Extract the angle, hook, structure, offer. |
| `ads-competitor` | Competitor ad teardown via Meta Ad Library and similar. |
| `ads-generate` | Generate ad concepts at volume. |
| `ad-creative` | Generic creative-direction helper. |
| `ad-image-gen` | Generate ad images — prompts + image-model integration. |

### Copywriting

| Skill | What it does |
|---|---|
| `copywriting` | Marketing copy for any page — homepage, landing, pricing, feature, about, product. Headlines, value props, CTAs, hero sections. |
| `copy-editing` | Edit existing copy — tighten, sharpen, fix voice, kill weak phrases. |
| `direct-response` | Jeremy Haynes MIM execution engine. Ad strategy, funnels, scaling, copy, email sequences, psychology, CRO. Pairs with `hormozi-brain`. |
| `cold-email` | Cold outbound email sequences — subject lines, opens, deliverability patterns. |
| `email-sequence` | Lifecycle email — welcome series, nurture, re-engagement, post-purchase. |

### Strategy & Frameworks

| Skill | What it does |
|---|---|
| `hormozi-brain` | Full Hormozi knowledge base. See breakdown below. |
| `marketing-psychology` | Behavioral psych applied to marketing — bias, persuasion, decision architecture. |
| `pricing-strategy` | Pricing models, anchoring, tiering, payment plans, deal structure. |
| `launch-strategy` | Product / offer launch playbooks — pre-launch, launch week, post-launch. |
| `customer-research` | Voice-of-customer extraction — interview questions, review mining, JTBD. |
| `content-strategy` | Content pillar, distribution, repurposing, editorial calendar. |
| `lead-magnets` | Lead magnet ideation + design — what converts, formats, delivery. |
| `free-tool-strategy` | Free tools as a growth channel — what to build, distribution, conversion path. |
| `referral-program` | Referral program design — incentive structures, virality math, tracking. |
| `community-marketing` | Community as a growth channel — Slack/Discord/forum strategy, engagement loops. |
| `competitor-alternatives` | "Best alternatives to X" content + landing page strategy. |
| `churn-prevention` | Reduce churn — cohort analysis, intervention triggers, win-back. |

### CRO (Conversion Rate Optimization)

| Skill | What it does |
|---|---|
| `page-cro` | Optimize any marketing page — homepage, landing, pricing, feature, blog. Diagnoses why a page isn't converting. |
| `popup-cro` | Popups + modals — exit intent, scroll triggers, copy, dismissal patterns. |
| `form-cro` | Form optimization — fields, layout, validation, multi-step. |
| `signup-flow-cro` | Registration flow — friction reduction, progressive disclosure, social auth. |
| `onboarding-cro` | Post-signup activation — first-value, aha moments, drop-off recovery. |
| `paywall-upgrade-cro` | Paywall + upgrade screen optimization. Free → paid conversion. |

### SEO

| Skill | What it does |
|---|---|
| `ai-seo` | AI-search-era SEO — AEO/GEO/LLMO. Get cited by ChatGPT, Perplexity, Google AI Overviews, Claude, Gemini. |
| `seo-audit` | Full technical + content SEO audit. |
| `schema-markup` | JSON-LD generation — LocalBusiness, Product, Article, FAQ, etc. |
| `programmatic-seo` | Programmatic page generation — patterns, taxonomy, indexability. |
| `site-architecture` | IA + internal linking + URL structure. |

### Audit & Analytics

| Skill | What it does |
|---|---|
| `audit` | Generic audit framework — apply to anything (page, account, funnel). |
| `analytics-tracking` | GA4 / GTM / pixel setup + auditing. Conversion event taxonomy. |
| `ab-test-setup` | Set up A/B tests — experiment design, sample size, instrumentation. |

### Social & Content

| Skill | What it does |
|---|---|
| `social-content` | Organic social content — formats, hooks, posting cadence. |
| `create-viral-content` | Viral content patterns — pattern interrupts, watch-time engineering, hook stacks. |

### Frontend / Build

| Skill | What it does |
|---|---|
| **`impeccable`** | **Production-grade frontend with high design quality.** Avoids generic AI aesthetics. Call with `craft` (shape-then-build), `teach` (design context setup), or `extract` (pull reusable components into design system). Use this when building any page, component, artifact, or app. |
| **`polish`** | **Final pre-ship quality pass.** Fixes alignment, spacing, consistency, micro-details. Run before shipping anything visual. "From good to great." |
| `figma-to-code` | Figma design → working code. |

### Meta-skill: `ads`

`ads` is an aggregator that routes to the right `ads-*` skill based on context. Use `/ads` if you don't know which platform skill to invoke.

---

## Inside `hormozi-brain` (the strategy spine)

This isn't a prompt — it's a structured library Claude reads when you ask offer / pricing / sales / ops questions. ~720K of organized reference broken into 6 domains:

**Leads** — `core-4-methods`, `paid-ads`, `cold-outreach`, `warm-outreach`, `content-method`, `email-marketing`, `referrals`, `lead-magnets`, `copy-hacks`, `benchmarks`

**Offers** — `grand-slam-offer`, `value-equation`, `pricing`, `bonuses-scarcity`, `guarantees`, `naming-niching`, `delivery-cube`

**Sales** — `closer-framework`, `objection-handling`, `closing-techniques`, `negotiation`, `tone-techniques`, `conviction`, `sales-multipliers`, `sales-teams`, `benchmarks-quotes`

**Money Models** — `value-equation`, `payback-period`, `client-financed-acquisition`, `gross-profit`, `core-economics`, `continuity`, `billing-retention`, `offer-types`, `money-model-structure`, `wealth-building`

**Operations** — `growth-stages`, `scaling`, `systems`, `diagnostics`, `focus`

**Management** — `hiring`, `firing`, `compensation`, `leadership`, `talent`, `partnerships`, `hr-framework`

Plus top-level: `general-wisdom`, `mistakes-and-lessons`, `decisions-and-patterns`, `business-breakdowns`, `benchmarks-by-industry`, `scripts-and-swipes`, `content-creation-system`, `portfolio-and-investing`.

## Inside `direct-response` (the execution engine)

Jeremy Haynes MIM-style execution playbook. Pairs with `hormozi-brain` — Hormozi is the *what*, direct-response is the *how*. Organized by domain:

**Ad Creation** — concepts, hooks, formats
**Ad Strategies** — campaign structure, testing, scaling logic
**Meta Ads** — `objectives`, `placements`, `retargeting`, `instagram-native`, `messaging-mastery`, `in-market-demographics`
**Google Ads** — Search, PMax, YouTube playbooks
**TikTok** — native creative, Spark Ads, attribution
**Funnels** — `vsl`, `webinar`, `book-funnel`, `challenge-funnel`, `dsl-deck-sales-letter`, `low-ticket-to-high-ticket`, `backend-selling`, `confirmation-pages`
**Scaling** — `scaling-framework`, `bidding-strategies`, `budget-rules`, `automated-rules`, `pixel-conditioning`, `cro-split-testing`
**Psychology** — `marketing-triggers`, `persuasion-frameworks`, `market-awareness`, `emotional-manipulators`
**Copywriting** — long-form, short-form, ad copy patterns
**Email** — sequences, broadcast, deliverability
**Page Building** — landing page architecture, layout patterns
**Sales** — closing, objection handling for direct-response funnels
**Auditing** — what to look at when a campaign isn't working
**Mindset** — operator-level decision making
**Agency Ops** — for running this for clients
**AI Content** — using AI for direct-response output

---

## The brain underneath

Both `hormozi-brain` and `direct-response` are static reference packs. For a *live, queryable* knowledge graph over your own files (clients, projects, sessions, decisions), the brain layer is **graphify** — a separate skill that turns any folder of markdown/code/docs into a clustered knowledge graph Claude queries before answering. Not bundled here (it's its own tool), but ask Dartagnan if you want it — that's how the full brain model works in practice.

---

## Setup notes

- **No external credentials for the skills themselves** — they're prompt + reference packs.
- The skills will reference platform APIs when you actually run them (e.g., `ads-meta` will want a Meta access token). See top-level project `SETUP.md` (or `.env.example` in motion-lite) for the credential list.
- `ad-image-gen` references a knowledge base for client visual style — adjust the path in `ad-image-gen/SKILL.md` to match your setup.

## Cross-references between skills

- `direct-response` + `hormozi-brain` — pair these for offer design, ad angles, and sales scripts.
- `ads-*` skills sometimes pull from `hormozi-brain` for offer math (Value Equation, payback period).
- `impeccable` + `polish` — `impeccable` ships the build, `polish` runs the final pass.
- `copywriting` → `copy-editing` for the second pass on existing copy.

## Customizing

Each skill is a folder with `SKILL.md` (the prompt) + sometimes `references/` (knowledge files). Edit `SKILL.md` to inject your brand voice, agency frameworks, or override defaults.
