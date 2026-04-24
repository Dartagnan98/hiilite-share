# Bidding Strategy Decision Trees
**Source: Merged from ads-budget skill into DR scaling domain**

---

## Google Ads Bidding Decision Tree

```
Start
├─ <30 conversions/month?
│  └─ Use Maximize Clicks (cap CPC at benchmark)
│     └─ When >30 conv/month → Maximize Conversions
├─ 30-50 conversions/month?
│  └─ Use Maximize Conversions
│     └─ When stable CPA → Target CPA
├─ >50 conversions/month?
│  └─ Use Target CPA
│     └─ When revenue tracking → Target ROAS
└─ Revenue tracking active + >50 conv/month?
   └─ Use Target ROAS
```

## Meta Ads Bidding
- **Lowest Cost (default)**: best for volume, may have CPA variance
- **Cost Cap**: sets CPA ceiling, may reduce volume
- **Bid Cap**: maximum bid per auction, most control
- **ROAS Goal**: target return on ad spend
- **CBO vs ABO**: CBO for proven campaigns, ABO for testing

## TikTok Bidding
- **Lowest Cost**: maximize conversions within budget (volume)
- **Cost Cap**: set maximum CPA (efficiency)
- **Bid Cap**: maximum bid per impression
- Budget ≥50x CPA per ad group for learning phase exit

## Budget Sufficiency Minimums

| Platform | Minimum Daily | Learning Phase Budget |
|----------|--------------|----------------------|
| Google Search | $20/day | Sufficient for 15+ conv/month |
| Google PMax | $50/day | Sufficient for algorithm optimization |
| Meta | $20/day per ad set | ≥5x target CPA per ad set |
| TikTok | $50/day campaign, $20/day ad group | ≥50x target CPA per ad group |
