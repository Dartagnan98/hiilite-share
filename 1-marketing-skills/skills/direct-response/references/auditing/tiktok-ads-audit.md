# TikTok Ads Audit (25 Checks)
**Source: Merged from ads-tiktok skill**

---

## Creative Quality (30% weight)
- ≥6 creatives per ad group (T05)
- All video 9:16 vertical 1080x1920 (T06)
- Native-looking content, not corporate/polished (T07)
- Hook in first 1-2 seconds (T08)
- No creative active >7 days with declining CTR (T09)
- Spark Ads tested: ~3% CTR vs ~2% standard (T10)
- TikTok Shop integration for e-commerce (T20)
- Caption SEO with high-intent keywords (T22)
- Trending audio used (sound-on platform) (T23)
- Custom CTA button (T24)
- Safe zone compliance: X:40-940, Y:150-1470 (T25)

## Technical Setup (25% weight)
- TikTok Pixel installed and firing (T01)
- Events API + ttclid passback active (T02)
- Standard events configured (ViewContent, AddToCart, Purchase, CompleteRegistration)
- Advanced matching parameters configured

## Bidding & Budget (20% weight)
- Lowest Cost for volume, Cost Cap for efficiency (T11)
- Daily budget ≥50x target CPA per ad group (T12)
- Learning phase: ≥50 conversions per 7 days per ad group (T13)
- No edits during learning phase (resets learning)

## Structure & Settings (15% weight)
- Separate campaigns for prospecting vs retargeting (T03)
- Smart+ campaigns tested: 42% adoption, 1.41-1.67 ROAS (T04)
- Search Ads Toggle enabled (T14)

## Creative-First Strategy
TikTok success depends primarily on creative quality, not targeting/bidding.

### What Works
- Native feel: looks like organic content, not a polished ad
- Sound-on: 93% consumed with sound
- Fast hooks: 1-2 seconds or lose the viewer
- UGC style outperforms studio content
- Vertical only: 9:16 non-negotiable

### Creative Testing
1. Test 3-5 hooks per winning concept
2. Rotate creatives every 5-7 days
3. Kill underperformers after 3 days if CTR <0.5%
4. Scale winners by duplicating (not increasing budget)

## Safe Zone
```
X: 40-940px, Y: 150-1470px (safe area: 900x1320px)
Right 140px: like/comment/share icons
Top 150px: status bar
Bottom 450px: caption area
```

## Key Thresholds

| Metric | Pass | Warning | Fail |
|--------|------|---------|------|
| CTR (in-feed) | ≥1.0% | 0.5-1.0% | <0.5% |
| Creatives/ad group | ≥6 | 3-5 | <3 |
| Video watch time | ≥6s | 3-6s | <3s |
| Learning conversions | ≥50/week | 30-50/week | <30/week |

## Context
- CPM 40-60% cheaper than Meta
- Spark Ads CTR ~3% vs ~2% standard
- Smart+ ROAS 1.41-1.67
- Shop CVR >10%
