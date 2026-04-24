# Cyclic Campaigns

Source: Jeremy Haynes / Master Internet Marketing, Week 3 Lesson 14
Origin: Learned directly from Facebook's Industry Ad Expert at Facebook HQ in Menlo Park, Silicon Valley.
Type: Campaign optimization strategy using standard events instead of custom conversions
Best For: Any advertiser on Facebook/Instagram. E-commerce, lead gen, application funnels, service businesses.

---

## Core Concept

Instead of optimizing one campaign for just the final conversion step, you duplicate that campaign and optimize each copy for a different step in your funnel. This leverages Facebook's massive standard event data pool (from all 7M+ advertisers) rather than your tiny custom conversion data.

---

## Why Standard Events Beat Custom Conversions

### Custom Conversions (Old Way)
- Specific to YOU as an advertiser
- Data comes only from YOUR URL traffic
- Whether spending $100/day or $100K/day, conversion data is limited to YOUR funnel
- Far fewer data points for the algorithm to work with
- Higher ad costs, higher cost per purchase, lower reach

### Standard Events (Better Way)
- ALL Facebook advertisers (7M+) have access to standard events
- Facebook accumulates massive data on standard events across all advertisers
- When you target an audience, FB already knows who is most likely to purchase, add to cart, initiate checkout, etc.
- Like a CRM -- FB knows who has taken these actions historically across all advertisers
- **Thousands of times higher probability** that FB finds people who will take your desired action

---

## Available Standard Events

- View Content
- Search
- Add to Wish List
- Add to Cart
- Initiate Checkout
- Add Payment Info
- Purchase
- Subscribe
- Start Trial
- Complete Registration
- Contact
- Find Location
- Schedule
- Customize Product
- Donate
- Lead
- Submit Application

---

## Setting Up Standard Events

### Method 1: Manual Code
- Grab the standard event code for each event
- Insert into the header section on a page-by-page level
- Example: View Content code goes on opt-in page header, Lead code goes on thank-you page header

### Method 2: Facebook Event Setup Tool
- Go to Measure & Report -> Events Manager -> click your pixel
- Top right: Setup -> Set Up New Events
- Enter a URL and Facebook will open the page
- Click on buttons to assign standard events (e.g., "Add to Cart" button = Add to Cart event)
- No code needed -- just click buttons and assign

---

## Cyclic Campaign for E-Commerce

### Funnel Steps and Events
1. **Product/Home Page** -> View Content
2. **Add to Cart Button** -> Add to Cart
3. **Cart/Checkout Page** -> Initiate Checkout
4. **Confirmation Page** -> Purchase

### Campaign Setup
1. Create campaign optimized for **Purchase** (standard event)
2. Set up audiences, create ads, publish
3. **Duplicate** the campaign -> change optimization to **Initiate Checkout**
4. Publish
5. **Duplicate** again -> change optimization to **Add to Cart**
6. Publish

**Result:** 3 separate campaigns, each optimized for a different funnel step.

### Why This Works
- Purchase campaign finds buyers (highest probability)
- Initiate Checkout campaign ALSO finds buyers (high probability, positive ROI)
- Add to Cart campaign ALSO finds buyers (still positive ROI)
- Each campaign is ROI positive
- Total buyer volume is HIGHER than just optimizing for Purchase alone
- Retargeting list grows much faster

**Skip View Content** -- that is basically running a traffic campaign optimized for landing page views. Stick to the final 2-3 steps.

---

## Cyclic Campaign for Lead Generation

### Funnel Steps and Events
1. **Opt-in Page** -> View Content (or Lead)
2. **Application Page** -> Lead
3. **Application Submitted** -> Submit Application
4. **Call Scheduled/Confirmation** -> Complete Registration

### Campaign Setup
1. Create campaign optimized for **Complete Registration**
2. Set up audiences, create ads, publish
3. **Duplicate** -> change to **Submit Application**
4. Publish
5. **Duplicate** -> change to **Lead**
6. Publish

**Result:** 3 campaigns optimizing for different funnel steps.

### Benefits for Lead Gen
- Strong probability of more leads for better cost
- Significantly increases retargeting list size
- Lower cost per action
- Better reach than cold direct response or even post-VFT campaigns
- Each campaign still drives actual buyers/leads, even when optimized for upper-funnel events

---

## Key Principles

1. **Always use standard events over custom conversions** -- thousands of times more data for the algorithm
2. **Optimize for the last 2-3 steps** of your funnel (skip View Content)
3. **Each cyclic campaign should be ROI positive** on its own
4. **Significantly strengthens retargeting** by building larger audiences at each funnel step
5. **Works with any funnel type** -- e-commerce, lead gen, application, scheduling
6. **Combine with other strategies** -- use cyclic campaigns within Harvester, VFT, Forester, or Tornado setups
7. **Great for exiting Learning Limited** -- more data across all funnel steps helps the algorithm learn faster

---

## When to Use Cyclic Campaigns

| Situation | Use Cyclic? |
|-----------|------------|
| Stuck in Learning Limited | Yes -- more data helps exit faster |
| Want more leads/sales volume | Yes -- each campaign drives additional conversions |
| Retargeting list too small | Yes -- builds audiences at every funnel step |
| High CPA on single-event optimization | Yes -- additional campaigns find buyers at different price points |
| Already profitable and scaling | Yes -- adds incremental volume |
| Very small budget (< $50/day) | Maybe -- may not have enough budget for 3 campaigns |

---

## Integration with Other Strategies

### With Venus Fly Trap
After warming audience with VFT content sequence, launch cyclic campaigns for the direct response phase. Optimizing for multiple funnel steps on warmed audiences yields even lower CPAs.

### With Forester
Use cyclic campaigns for Step 2 direct response targeting of warm audiences created by Content Cycle Bin 1.

### With Hammer Them
While Hammer Them handles content retargeting, use cyclic campaigns for the original direct response campaigns feeding leads into the Hammer Them pipeline.

### With Tornado
Layer cyclic campaigns into the direct response portion (Layer 3) of the Tornado. Each funnel step gets its own cyclic campaign alongside the content distribution layers.

---

## Pro Tips

1. **Facebook told Jeremy this directly** at their headquarters. This is not theory -- it is field-tested and endorsed by the platform itself.
2. **Set up standard events BEFORE launching** -- retroactive setup does not capture historical data.
3. **Use the Event Setup Tool** for easiest implementation (no code needed).
4. **Monitor each cyclic campaign independently** -- some will outperform others.
5. **Do not optimize for View Content** -- equivalent to running a traffic campaign.
6. **Name campaigns clearly** -- "Cyclic - Purchase," "Cyclic - Initiate Checkout," etc.

---

## Detailed Setup Walkthrough

### Step 1: Install Standard Events on All Funnel Pages

For each page in your funnel:
1. Go to Events Manager in Facebook Ads Manager
2. Click on your pixel
3. Top right: Setup -> Set Up New Events
4. Two options:
   - **Manual:** Copy standard event code, paste into page header section
   - **Event Setup Tool:** Enter URL, Facebook opens the page, click buttons to assign events

### Step 2: Assign Events to Funnel Steps

**E-Commerce Example:**
- Home/product page: View Content (header code)
- Add to Cart button: Add to Cart (assigned via Event Setup Tool clicking the button)
- Checkout page: Initiate Checkout (header code)
- Confirmation/thank you page: Purchase (header code)

**Lead Gen Example:**
- Opt-in page: View Content or Lead (header code)
- Application page: Lead (header code or button assignment)
- Application submitted: Submit Application (confirmation page header)
- Call scheduled/confirmation: Complete Registration (header code)

### Step 3: Create the Cyclic Campaign Set

1. Create Campaign 1: Optimize for LAST step (Purchase or Complete Registration)
2. Build out audiences and ads normally
3. Publish Campaign 1
4. Duplicate Campaign 1
5. Change optimization to SECOND-TO-LAST step (Initiate Checkout or Submit Application)
6. Publish Campaign 2
7. Duplicate Campaign 2
8. Change optimization to THIRD-TO-LAST step (Add to Cart or Lead)
9. Publish Campaign 3

**Do NOT optimize for View Content** -- that is equivalent to a traffic/landing page views campaign.

### Step 4: Monitor and Optimize

Each campaign should be tracked independently:
- Track ROAS per campaign
- Track cost per action per campaign
- All should be ROI positive
- The total volume across all three will exceed what a single campaign produces

---

## Advanced Applications

### Cyclic + Manual Bidding

Combine cyclic campaigns with manual bid strategy for competitive periods:
- Campaign 1 (Purchase): Manual bid at target CPA
- Campaign 2 (Initiate Checkout): Manual bid at slightly lower CPA target
- Campaign 3 (Add to Cart): Manual bid at even lower CPA
- Each campaign clears out buyers at different price points

### Cyclic + Lookalike Audiences

Create lookalike audiences based on each standard event:
- Lookalike of purchasers
- Lookalike of checkout initiators
- Lookalike of add-to-cart users
- Each lookalike is slightly different and can be tested as separate audiences

### Cyclic + Retargeting

Build retargeting audiences from each funnel step:
- People who added to cart but did not initiate checkout
- People who initiated checkout but did not purchase
- People who viewed content but did not add to cart
- Target each segment with specific messaging addressing their drop-off point

---

## Common Mistakes to Avoid

1. **Optimizing for View Content** -- wastes budget on traffic, not conversions
2. **Using custom conversions instead of standard events** -- misses the massive data advantage
3. **Only running one campaign** -- leaves money on the table
4. **Not monitoring each campaign separately** -- some will outperform, need individual optimization
5. **Setting up standard events AFTER launch** -- retroactive setup misses historical data
6. **Running too many cyclic levels on tiny budgets** -- each campaign needs minimum viable budget
7. **Forgetting to name campaigns clearly** -- "Cyclic - Purchase," "Cyclic - Add to Cart," etc.
