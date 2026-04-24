# WordPress Helpers

Patterns and scripts for driving WordPress sites from Claude Code. Useful when you're managing client sites with Yoast/Elementor/Gravity Forms.

## What's inside

The `skills/` subfolder is empty in this share — these are recipes more than packaged skills. The patterns below are the playbook we use.

## What you need

| Thing | Where to get it |
|---|---|
| WP-CLI | `brew install wp-cli` (macOS) or `curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar` |
| SSH access to the WordPress server | Required for WP-CLI to do most useful things |
| WordPress REST API enabled | Default in WP 4.7+ — verify by hitting `https://yoursite.com/wp-json/` |
| WP application password | User → Profile → Application Passwords. Used for REST API auth without exposing the real password. |
| Yoast SEO Premium (optional) | For schema control via REST. Free version exposes less. |
| Gravity Forms + Gravity Forms API key (optional) | For pulling form submissions, creating forms programmatically |

## Patterns

### Pattern 1 — Bulk content edits via WP-CLI

```bash
# SSH to server, then:
wp post list --post_type=post --format=csv --fields=ID,post_title
wp post update 123 --post_content="$(cat new-content.html)"
wp post meta update 123 _yoast_wpseo_metadesc "Better meta description"
```

Claude Code skill pattern: write a SKILL.md that knows your client's WP host, takes a CSV of post IDs + new content, and SSHes in to apply.

### Pattern 2 — REST API for remote edits

```bash
# Create a post remotely
curl -X POST https://yoursite.com/wp-json/wp/v2/posts \
  -u "username:application_password_here" \
  -H "Content-Type: application/json" \
  -d '{"title":"My post","content":"Body","status":"publish"}'
```

Use this for routine "post a blog from a markdown file" tasks. Combine with the `programmatic-seo` skill in bundle 1.

### Pattern 3 — Yoast schema injection

Yoast stores schema as post meta. To override Article schema with FAQ schema for a specific post:

```bash
wp post meta update 123 _yoast_wpseo_schema_page_type "FAQPage"
```

For programmatic schema (LocalBusiness, Product, Article), pair with the `schema-markup` skill in bundle 1 — it generates valid JSON-LD that you can drop into a Yoast custom field or a `wp_head` hook.

### Pattern 4 — Gravity Forms

```bash
# List entries from form 5
curl https://yoursite.com/wp-json/gf/v2/forms/5/entries \
  -u "ck_xxx:cs_yyy"
```

API keys are at Forms → Settings → REST API → Add Key. Useful for syncing form submissions into your CRM.

### Pattern 5 — Elementor cache

After programmatic edits to a page, Elementor caches CSS. Force regen:

```bash
wp elementor flush-css
wp cache flush
```

If the change still doesn't appear, also check WP Rocket / W3 Total Cache / Cloudflare APO.

## Setting up your own WP skill

```bash
mkdir -p ~/.claude/skills/wp-deploy
cat > ~/.claude/skills/wp-deploy/SKILL.md <<'EOF'
---
name: wp-deploy
description: Push markdown content to a WordPress site as a post via REST API. Reads brand voice from knowledge/ if available.
---

# WP Deploy

When user asks to "publish this post" or "push to WordPress":

1. Read the markdown file they reference
2. Use REST API at $WP_SITE/wp-json/wp/v2/posts with $WP_USER + $WP_APP_PASSWORD
3. Convert markdown to HTML before posting (pandoc or marked)
4. Set Yoast meta description from frontmatter `description:` field
5. Confirm post URL once published
EOF
```

Set the env vars in your shell rc:

```bash
export WP_SITE="https://yourclient.com"
export WP_USER="your-wp-user"
export WP_APP_PASSWORD="xxxx xxxx xxxx xxxx"  # generate in WP admin
```

## Caveats

- **Application passwords don't work over plain HTTP** — site must be HTTPS. WP refuses the auth otherwise.
- **WP-CLI vs REST** — WP-CLI is faster + more powerful but needs SSH. REST works from anywhere but is slower for bulk ops.
- **Yoast Premium gates a lot of schema control** — free version means you'll need a custom plugin or `wp_head` hook to inject custom schema.
- **Elementor pages are JSON blobs in `_elementor_data` post meta** — don't edit them as plain HTML. Use the Elementor editor or the `Elementor\Plugin` PHP API.
