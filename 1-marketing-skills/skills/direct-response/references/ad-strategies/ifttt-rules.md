# If This, Then That Rules for Advertising

Source: Jeremy Haynes / Megalodon Marketing
Type: Standard Operating Procedure for common ad problems
Application: Any ad platform. Decision framework for media buyers when specific data patterns emerge.

---

## Overview

These are decision rules for different problems you come across in ads manager. Given a specific set of data, here is the action to take.

**Tools Needed:**
- Ads manager access
- Login to analytics tools
- Login to funnel builder / website editor

---

## Problem: Low Conversions

### Diagnosis Process
1. Find the bottleneck in the funnel
2. Look at ad data (CTR, click volume) then each funnel step
3. Good CTR: above 2%
4. Calculate conversion rate at each step

### Example Funnel Analysis
- 1,000 people hit opt-in page, 100 opt in = 10% conversion
- 98 hit webinar page, 12 reach order page = 12.2% of opt-ins
- 12 on order page, 2 purchase = 16.6% order-to-purchase rate
- Factor in upsells and their conversion rates

### Action
- Identify the choke point
- Put attention on that specific step
- Increase conversion at that step
- Repeat until desired KPIs are met throughout entire funnel

---

## Problem: CTR Below 2%

### Action
1. Rotate in new creatives every 72 hours until CTR exceeds 2%
2. Test: new headlines, body copy, images/videos, dynamic creative vs static

**Critical Caveat:** If ads are profitable but below 2% CTR, do NOT change those creatives. Instead:
- Duplicate the campaign
- Test new audiences with same creative
- See if it is also profitable or hits 2%+ CTR elsewhere

**Never turn something off that is profitable.**

Tools for limited creative: Shakr.com or Canva.com for quick video/image variations.

---

## Problem: Learning Limited

### What It Means
Facebook/Adwords indicates insufficient conversions for what you are optimizing for. Algorithm cannot confidently find who to target.

### Solutions (Simple to Complex)

**Solution 1: Relaunch ad set**
- If you got CLOSE to needed conversions, simply relaunch
- High probability you exit learning next time

**Solution 2: Fix the funnel**
- If way short of needed conversions, go back to Problem 1 (find bottleneck)
- Fix the funnel, then relaunch as another test

**Solution 3: Test new audiences**
- Keep best performing creatives, test new audience segments
- Determines if the issue is audience not responding vs creative/funnel problem

**Solution 4: Run Cyclic Campaigns** (see cyclic-campaigns.md)
- Optimize for each step of funnel with different standard events
- E-commerce: optimize for purchase, then dupe for add-to-cart, then dupe for initiate-checkout
- Application funnel: optimize for complete-registration, then dupe for submit-application, then dupe for lead
- Gets more data throughout all funnel steps
- Helps exit learning phase faster

**Pro tip:** Understand machine learning and WHY the platform is indicating this. Understanding the mechanics helps you apply these fixes properly.

---

## Problem: CPA Too High

### Cause 1: Audiences Too Small
- Happens with audiences under 1,000,000 people
- Fix: widen the audience
- If not possible: drop daily budget 20% until CPA lowers, then scale back up 10-20% daily
- Alternative: run manual bid campaign to test if desired CPA is even achievable with small audience

### Cause 2: Hyper Competitive Demographics

**Manual bid strategy for competitive periods:**
1. Switch to manual bid campaigns
2. Run at $200/day with $50 bid cap
3. Monitor reach every 2 hours
4. If not getting reach (throttling): bump bid cap $10 every 2 hours
5. Increase daily spend by each conversion cost (e.g., first conversion at $40 -> budget becomes $240)
6. When reach stops again, bump bid cap another $10 to clear next range
7. This clears out everyone available at each price point

**Q4 2020 example:** Election targeting swing states + COVID e-commerce surge = brutally competitive. Manual bidding solved it.

### Cause 3: Scaling Campaign Wrong
- Any automated bidding campaign scaled more than 10-30% daily is susceptible to CPA spikes
- **Fix:** To go from $200/day to $1,000/day, duplicate the $200 campaign and set new one to $1,000. Once approved, shut off the $200 campaign (avoids audience overlap).

### Cause 4: Wrong Audience
- Test new audiences to see if a different audience yields lower CPA
- Take successful ads and run alongside new campaigns targeting different audiences

---

## Problem: High No-Show Rate on Scheduled Calls

### Benchmarks
- 20% or less: good
- 30%: ok
- Above 35%: unacceptable, costing big money

### Actions to Decrease No-Shows

**1. Audit marketing automation**
- Generic reminders are not enough
- Pepper in testimonials in pre-call sequence
- Treat each reminder email as a resell on why they need to show up

**2. Text-based reminders**
- Collect phone number in scheduler
- Send SMS reminders

**3. Video text IMMEDIATELY after application/booking**
- Real, custom video text from the closer
- "Excited to chat, wanted to face-to-face, send questions between now and call"
- Send from iPhone (no quality reduction) or via social DMs

**4. Retargeting campaign**
- Contextual content: "excited to help, here is what to expect"
- $5-$10/day budget
- Needs 100+ people in audience to work

**5. Confirmation step**
- Final funnel page with VSL explaining what to expect
- Congratulate them on getting closer to solving X
- Add testimonials for further framing

All combined typically keeps no-shows below 20%.

---

## Problem: Many Add-to-Carts, Few Sales

### CRO Actions

1. **Dynamic product retargeting** -- catalog feed showing products they viewed/carted
2. **Green CTA buttons** -- higher conversion on order forms
3. **Support info on page** -- email, phone, physical address increases trust
4. **Short testimonials** -- formatted like tweets, easy to read
5. **FAQ section** -- digital objection handling
6. **Product visualization** -- unboxing videos, influencer/customer content
7. **Live chat** -- bottom right corner
8. **Clear shipping info** -- times, free shipping
9. **Social proof tools** -- UseProof.com, "digital table rush" on ClickFunnels
10. **Trust icons** -- "Guaranteed SAFE Checkout" with Stripe, Visa, MC, Amex logos

Each adds single-digit conversion increases. Combined, they are hyper effective.

---

## Problem: Many Calls, Few Closes

### Root Causes
1. **Framing** -- leads not properly framed before call (see next problem)
2. **Lead quality** -- wrong hook + right audience, or right hook + wrong audience
   - If right audience: test new hooks, gauge quality again
   - If unsure about audience: test new audiences with same hooks
3. **Lead quantity** -- increase spend on successful campaigns for larger data sample
4. **Closer quality** -- sales training and best practices

---

## Problem: Leads Not Framed Properly

### Audit Process
1. Go through campaign as if you are the customer
2. Start with ads, work through funnel, watch videos, schedule a call
3. Find what is off in marketing automation
4. Note everything

### Common Issues
- No VSLs on pages (huge difference)
- Generic reminder automation vs well-written copy in follow-up
- Missing framing content in ad campaigns

### Fix: Incorporate Framing Content
- Use Venus Fly Trap or Harvester approaches
- Content at ALL stages of the ad strategy
- Content before prospects see direct response creatives
- Content throughout all funnel stages for contextual framing

---

## Decision Tree Summary

| Symptom | First Check | Primary Fix |
|---------|------------|-------------|
| Low conversions | Find funnel bottleneck | Fix weakest step |
| CTR < 2% | Creative quality | Rotate new creatives every 72h |
| Learning limited | Conversion volume | Cyclic campaigns or fix funnel |
| CPA too high | Audience size | Widen audience or manual bid |
| High no-shows | Marketing automation | Video text + retargeting + testimonials |
| Add-to-carts no sales | Order page CRO | Trust icons + FAQ + dynamic retargeting |
| Calls not closing | Lead framing | Content-first strategy (VFT/Harvester) |
| Leads unframed | Full funnel audit | Add content at every stage |
