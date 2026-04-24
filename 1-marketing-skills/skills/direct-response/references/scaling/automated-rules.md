# Leveraging Automated Rules to Scale
**Source: Jeremy Haynes / Megalodon Marketing -- Week 3 Lesson 26 + IFTTT SOP**

---

## Why Automated Rules

- Much more efficient than manual management
- Free up your time as an advertiser
- Enable handling more accounts simultaneously
- Decisions made autonomously on schedule = faster results
- Anything you do manually consistently should be automated

> "Automated rules will be much more efficient than you."

---

## How to Access

- Ads Manager > Top Left (three lines) > All Tools > Automated Rules
- OR: Select specific campaigns/ad sets/ads > Create a Rule
- Most rules are done on the ad set level (but can apply to campaigns or ads)

---

## Available Actions

1. **Turn things off** -- kill underperformers automatically
2. **Turn things on** -- reactivate previously paused items
3. **Send notifications** -- alert you to come in and act manually
4. **Adjust bids and budgets** -- scale or descale spending
5. **Adjust manual bids** -- for manual bidding strategies

---

## Rule Structure: If/Then Logic

### Example Scaling Rule
- **Action:** Increase daily budget by 30%
- **Max budget cap:** $5,000/day
- **Condition 1:** Cost per result < $10 (Great CPA range)
- **Condition 2:** Impressions > 8,000 (ensure sufficient data)
- **Condition 3:** Purchase quantity > 25 (ensure actual customer acquisition)
- **Lookback window:** 72 hours
- **Frequency:** Once daily (midnight in account timezone)

### Layered Conditions
Don't just scale based on lead cost. Add a customer acquisition condition:
- "Only scale if cost per lead < $10 AND purchases > 25"
- This ensures you're scaling campaigns that generate actual customers, not just cheap leads

---

## Rule Scheduling Best Practices

### Frequency
- **Once daily** is more than enough for most advertisers
- Set to run at midnight for your account's timezone
- At aggressive scaling: could do multiple times per day, but rarely needed

### Rule Firing Order
Rules fire in sequence. Structure them intelligently:
1. **Scaling rules** -- fire first (midnight)
2. **Descaling/kill rules** -- fire around the same time
3. **Cleanup rules** -- fire AFTER scaling/killing rules (e.g., 1 AM)
   - "Any ad set turned off where cost per result < X and purchases > Y: turn back on"
   - Catches things that were prematurely killed

---

## Common Rule Templates

### Scale Winners (Great CPA)
- IF cost per result < [Great CPA] AND impressions > [minimum threshold]
- THEN increase budget 30%
- Max cap: [your max daily budget]
- Window: last 72 hours
- Frequency: once daily

### Moderate Scale (Good CPA)
- IF cost per result < [Good CPA] AND cost per result > [Great CPA]
- THEN increase budget 10%
- Window: last 72 hours
- Frequency: once daily

### Kill Losers (Poor CPA)
- IF cost per result > [Poor CPA] AND impressions > [minimum]
- THEN turn off ad set
- Window: last 72 hours
- Frequency: once daily

### Fatigue Alert
- IF frequency > 3 AND cost per result increasing
- THEN send notification
- Window: last 72 hours

### Cleanup Rule (runs after kill rules)
- IF ad set is off AND cost per result < [Great CPA] AND purchases > [threshold]
- THEN turn back on
- Schedule: 1-2 hours after kill rules fire

---

## CPA Tier Setup

Define three tiers before creating rules:

| Tier | Example (Lead Gen) | Example (E-com) | Action |
|------|-------------------|------------------|--------|
| Great | < $10/lead | < $15/purchase | Scale 30%/day |
| Good | $10-25/lead | $15-40/purchase | Scale 10%/day |
| Poor | > $50/lead | > $80/purchase | Kill or descale |

**Remember:** Factor in CAC, not just CPA. A $200 lead for a $3,000 product might be very profitable.

---

## Scaling vs Third-Party Tools

Jeremy's position on RevealBot, TrustAds, etc.:

- Everything RevealBot does can be done in Facebook's built-in automated rules
- RevealBot charges a percentage of ad spend (thousands to tens of thousands at scale)
- Small advantages (15-minute rule frequency, additional lookalike creation) don't justify the cost
- Built-in rules in Ads Manager work great, are free, and handle everything needed

> "If you're managing literally hundreds of thousands to millions of dollars, half a percent ends up being thousands to tens of thousands of dollars."

---

## Manual Decision Framework (When Not Automated)

### What Works Best (from Week 3 Lesson 25)

Calculate your ideal CPA and give yourself ranges:

1. **Great CPA range** -- scale 20-30% per day until costs get volatile
2. **Good CPA range** -- scale 10% per day until costs change
3. **Poor CPA range** -- cut immediately

### Quality Indicators (3 Columns)
- **Quality Ranking** -- perceived quality vs competitors for same audience
- **Engagement Rate Ranking** -- expected engagement vs competitors
- **Conversion Rate Ranking** -- expected conversion rate vs competitors

All three low + high CPA + low reach = update creatives or try new audiences

### CTR Thresholds
- Above 2%: Good
- Above 5%: Great
- Below 2%: Creative/copy not resonating -- focus on that area

**If CTR is good but conversions are bad:** Problem is on the landing page/funnel side, not the ad side.

---

## Key Principles

1. If you do it manually and consistently, automate it
2. Use 72-hour lookback windows for decisions
3. Layer conditions (CPA + volume + customer acquisition)
4. Schedule cleanup rules after kill rules
5. Define Great/Good/Poor CPA ranges before creating any rules
6. Don't pay for third-party tools when built-in rules cover everything
7. Always consider CAC alongside CPA
