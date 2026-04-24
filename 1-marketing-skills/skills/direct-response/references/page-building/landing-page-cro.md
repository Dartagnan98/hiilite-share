# Landing Page CRO for Ad Campaigns
**Source: Merged from ads-landing skill into DR page-building domain**

---

## Message Match

The #1 landing page issue in ad campaigns -- does the page match the ad?

### What to Check
- **Headline match**: landing page H1 reflects ad copy headline/keyword
- **Offer match**: promoted offer (price, discount, trial) is visible above fold
- **CTA match**: landing page CTA matches ad's promised action
- **Visual match**: consistent imagery between ad creative and page
- **Keyword match**: search keyword appears naturally in page content

### Message Match Scoring
| Level | Description | Score |
|-------|-------------|-------|
| Exact match | Headline, offer, CTA all align perfectly | 100% |
| Partial match | Headline matches but offer/CTA differs | 60% |
| Weak match | Generic page, loosely related to ad | 30% |
| Mismatch | Page content doesn't reflect ad promise | 0% |

---

## Page Speed Thresholds

For every 1s delay, CVR drops ~7%.

| Metric | Pass | Warning | Fail |
|--------|------|---------|------|
| LCP | <2.5s | 2.5-4.0s | >4.0s |
| FID/INP | <100ms | 100-200ms | >200ms |
| CLS | <0.1 | 0.1-0.25 | >0.25 |
| Time to Interactive | <3.0s | 3.0-5.0s | >5.0s |
| Page weight | <2MB | 2-5MB | >5MB |

### Common Speed Killers
- Hero images not compressed (use WebP/AVIF)
- Too many third-party scripts (chat widgets, analytics, heatmaps)
- Render-blocking CSS/JS above fold
- No lazy loading for below-fold content
- Font files not preloaded

---

## Mobile Checklist

75%+ of ad clicks come from mobile.

- Tap targets: ≥48x48px with ≥8px spacing
- Font size: ≥16px body text (no pinch-to-zoom needed)
- Form fields: properly sized, keyboard type matches input (email, phone, number)
- CTA button: full-width on mobile, visible without scrolling
- No horizontal scroll
- Images responsive and properly sized
- Phone number clickable (tel: link)
- No interstitials or popups blocking content on load

---

## Trust Signals

### Above the Fold
- Company logo visible
- Social proof (customer count, reviews, ratings)
- Security badges (SSL, payment security, guarantees)
- Star ratings or testimonial snippet

### Below the Fold
- Full testimonials with names, photos, companies
- Case study highlights with specific metrics
- Certifications, awards, accreditations
- Privacy policy link
- Physical address/phone number (local service businesses)

---

## Form Optimization

### Field Count vs CVR
| Fields | Expected CVR Impact | Use Case |
|--------|-------------------|----------|
| 1-3 fields | Highest CVR | Top-of-funnel, free offer |
| 4-5 fields | Moderate CVR | Mid-funnel, qualified leads |
| 6-8 fields | Lower CVR | Bottom-funnel, sales-ready |
| 9+ fields | Lowest CVR | Only for high-value offers |

### Best Practices
- Pre-fill fields where possible (UTM data, known info)
- Multi-step forms for 5+ fields (progressive disclosure)
- Progress indicator on multi-step forms
- Inline validation (don't wait until submit)
- Submit button text is specific ("Get My Free Quote" not "Submit")
- Thank you page has clear next steps

---

## UTM & Click ID Handling

- UTM parameters captured and stored for attribution
- Click IDs preserved: gclid (Google), fbclid (Meta), ttclid (TikTok)
- Parameters passed to form submissions or CRM
- Dynamic keyword insertion in headline (Google Ads feature)
- Location-specific content for geo-targeted campaigns

---

## Conversion Tracking Checklist

- Thank you page/event fires correctly for all platforms
- Form submission triggers conversion event
- Phone call tracking configured (if applicable)
- Chat/live agent triggers tracked as micro-conversions

---

## Platform-Specific Notes

| Platform | Key Requirement |
|----------|----------------|
| Google | Landing page experience directly affects ad rank and CPC |
| Meta | Slow pages = Meta penalizes delivery |
| TikTok | 95%+ traffic is mobile, mobile-first mandatory |
