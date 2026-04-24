# Full Multi-Platform Ads Audit Framework
**Source: Merged from ads-audit skill**

---

## Process
1. Collect account data (exports, screenshots, API access)
2. Detect business type from account signals
3. Identify active platforms
4. Run platform-specific audits (inline or via subagents)
5. Calculate per-platform and aggregate health scores (0-100)
6. Generate prioritized action plan with Quick Wins

## Per-Platform Scoring Weights

| Platform | Categories |
|----------|-----------|
| Google | Conversion 25%, Waste 20%, Structure 15%, Keywords 15%, Ads 15%, Settings 10% |
| Meta | Pixel/CAPI 30%, Creative 30%, Structure 20%, Audience 20% |
| TikTok | Creative 30%, Tech 25%, Bidding 20%, Structure 15%, Performance 10% |

## Aggregate Score
```
Aggregate = Sum(Platform_Score x Platform_Budget_Share)
Grade: A (90-100), B (75-89), C (60-74), D (40-59), F (<40)
```

## Cross-Platform Analysis
- Budget allocation: actual vs recommended
- Tracking consistency: all platforms tracking same events?
- Creative consistency: messaging aligned across platforms?
- Attribution overlap: platforms double-counting conversions?

## Priority Definitions
- **Critical**: Revenue/data loss risk (fix immediately)
- **High**: Significant performance drag (fix within 7 days)
- **Medium**: Optimization opportunity (fix within 30 days)
- **Low**: Best practice, minor impact (backlog)

## Quick Wins Criteria
- Severity = Critical or High
- Fix time < 15 minutes
- Sort by: severity_multiplier x estimated_impact DESC

## Output
- Full findings report with pass/warning/fail per check
- Prioritized action plan (Critical > High > Medium > Low)
- Quick Wins list (high impact, <15 min to fix)
