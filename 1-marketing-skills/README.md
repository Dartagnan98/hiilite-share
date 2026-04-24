# Marketing Skills Pack

57 Claude Code skills covering ads, SEO, CRO, copy, strategy.

## Install

```bash
cp -R skills/* ~/.claude/skills/
```

Restart Claude Code. Each skill is invokable via `/<skill-name>` or auto-triggered when context matches.

## What's inside

### Paid Ads (~25 skills)
Full suite for Meta, Google, LinkedIn, TikTok, Microsoft, Apple Search, YouTube.
- `ads-audit` — full account audit (structure, budgets, learning phase, creative diversity)
- `ads-meta` `ads-google` `ads-linkedin` `ads-tiktok` `ads-microsoft` `ads-apple` `ads-youtube` — platform-specific
- `ads-budget` `ads-math` `ads-test` — budget allocation, math, A/B framework
- `ads-create` `ads-creative` `ads-photoshoot` `ads-landing` — creative + landing
- `ads-plan` `ads-dna` `ads-competitor` `ads-generate` — strategy + ideation
- `ad-creative` `ad-image-gen` `paid-ads` — generic helpers

### SEO (5 skills)
- `ai-seo` — AI-search-era SEO (Google AI Overviews, Perplexity, ChatGPT)
- `seo-audit` — full technical + content audit
- `schema-markup` — JSON-LD generation (LocalBusiness, Product, Article, FAQ)
- `programmatic-seo` — programmatic page generation patterns
- `site-architecture` — IA + internal linking strategy

### CRO (7 skills)
- `form-cro` `page-cro` `popup-cro` `signup-flow-cro` `onboarding-cro` `paywall-upgrade-cro`
- `churn-prevention`

### Copywriting + Email (5 skills)
- `copywriting` `copy-editing` `cold-email` `email-sequence` `direct-response`

### Strategy / Hormozi (5 skills)
- `hormozi-brain` — full Hormozi knowledge base (56 files: leads, offers, sales, money models, management). 720K of structured reference.
- `launch-strategy` `pricing-strategy` `lead-magnets` `marketing-psychology` `customer-research`

### Analytics / Testing (3 skills)
- `analytics-tracking` — GA4 / GTM / pixel setup + auditing
- `ab-test-setup`
- `audit` — generic audit framework

### Social / Content (4 skills)
- `content-strategy` `social-content` `competitor-alternatives` `community-marketing`
- `figma-to-code` `create-viral-content` `free-tool-strategy` `referral-program`

## Setup

No external credentials required for the skills themselves — they're prompt + reference packs.

The skills will reference platform APIs when you actually run them (e.g., `ads-meta` will want a Meta access token). See top-level `SETUP.md` for the credential list.

## Dependencies between skills

Most skills are standalone. A few cross-reference:
- `ads-*` skills sometimes reference `hormozi-brain` for offer math (Value Equation, payback period)
- `ad-image-gen` references your knowledge base for client visual style — adjust path in `ad-image-gen/SKILL.md` to match your setup

## Customizing

Each skill is a folder with `SKILL.md` (the prompt) + `references/` (knowledge files). Edit the `SKILL.md` to inject your own brand voice, agency-specific frameworks, or override defaults.
