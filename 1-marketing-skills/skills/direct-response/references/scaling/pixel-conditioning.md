# Pixel Conditioning Mastery
**Source: Jeremy Haynes / Megalodon Marketing -- Week 3 Lesson 6 + CBO Scaling + Cyclic Campaigns**

---

## What Is Pixel Conditioning

Training your Facebook/Meta pixel with quality conversion data so the algorithm knows exactly who your ideal buyers are. A well-conditioned pixel has enough historical data to reliably find people likely to convert.

---

## Standard Events vs Custom Conversions

### Custom Conversions (Limited)
- Specific to YOUR URL and YOUR pixel data
- Only YOU generate data for these conversions
- Facebook has far fewer data points to leverage
- Results: higher ad costs, lower reach, more expensive conversions

### Standard Events (Recommended)
- Used by ALL 7M+ Facebook advertisers
- Facebook accumulates massive data across all advertisers
- Platform can identify who in your audience is most likely to take each action
- "Thousands of times higher probability" of finding converters
- Standard events: View Content, Add to Cart, Initiate Checkout, Purchase, Lead, Submit Application, Complete Registration, Contact, Schedule

> Standard events leverage ALL advertisers' data. Custom conversions only leverage YOUR data.

---

## How to Set Up Standard Events

### Method 1: Manual Code Installation
1. Go to Events Manager (Ads Manager > top left > Measure and Report > Events Manager)
2. Click into your pixel
3. Click "Setup" in top right > "Set Up New Events"
4. Grab the standard event code for each funnel step
5. Add the code to the header section of each page (page-level, not site-level)

### Method 2: Facebook Event Setup Tool (Easier)
1. Click "Use Facebook's Event Setup Tool"
2. Enter the URL of your funnel page
3. Facebook opens the page and lets you click on buttons to assign standard events
4. Example: click "Add to Cart" button > assign Add to Cart standard event
5. No code needed with this method

### Assign Events to Each Funnel Step

**E-Commerce Funnel:**
| Page | Standard Event |
|------|---------------|
| Product/Home page | View Content |
| Add to cart button | Add to Cart |
| Cart/Checkout page | Initiate Checkout |
| Confirmation/Thank you | Purchase |

**Lead Gen Funnel:**
| Page | Standard Event |
|------|---------------|
| Opt-in page | View Content |
| After opt-in | Lead |
| Application page | Submit Application |
| After scheduling | Complete Registration |

---

## Pixel Conditioning Through Cyclic Campaigns

The cyclic campaign strategy directly conditions your pixel with data at every funnel stage.

### How It Works
Instead of one campaign optimized for the final step (purchase/registration), run 3 campaigns:

**E-Commerce:**
1. Campaign optimized for Purchase
2. Duplicate optimized for Initiate Checkout
3. Duplicate optimized for Add to Cart

**Lead Gen:**
1. Campaign optimized for Complete Registration
2. Duplicate optimized for Submit Application
3. Duplicate optimized for Lead

### Benefits for Pixel Conditioning
- Pixel receives conversion data from every funnel step
- More data = better optimization faster
- Exits learning phase quicker
- Each campaign independently produces ROI
- Significantly strengthens retargeting audiences
- Facebook can find likely converters at each stage

**Skip View Content** -- optimizing for that is essentially a traffic campaign. Start at least at the second-to-last step.

---

## Pixel Conditioning Through CBO

### Starting Fresh (New Account/Client)
- Start at $100-200/day (not aggressive)
- Let the learning phase complete (usually 72 hours, sometimes a full week)
- Campaign budget optimization distributes evenly during learning
- Once learning completes, budget flows to winners

### With Historical Data
- Can start at higher daily budgets
- Pixel already conditioned = higher probability of success spending more quickly
- Can repeat successful actions from past data

### The Learning Phase
- Facebook tests all variables you've given it
- Distributes across audiences and ad variations evenly
- Duration depends on spend level and conversion volume
- At $100-200/day: can exit in under 72 hours
- At $1,000/day: sometimes takes a full week
- During learning: reach, impressions, and results are relatively even across ad sets
- Data starts skewing toward one ad set = Facebook found a winner

### Protecting Conditioned Data
- Never scale more than 10-30% daily on same campaign (avoids learning mode reset)
- For large jumps: duplicate campaign at higher budget, kill original
- Keep clean, consistent data -- Facebook loves this

> "All that historical data was accumulated at lower levels of spend. The campaign gets confused when you jump aggressively."

---

## Pixel Warm-Up Strategy

### Phase 1: Initial Conditioning
1. Start with lowest cost bid strategy
2. $100-200/day budget
3. Optimize for standard events (not custom conversions)
4. Run cyclic campaigns to feed pixel data at every funnel step
5. Let learning phase complete fully

### Phase 2: Data Accumulation
1. Monitor for 72 hours minimum
2. Identify winning ad sets and ads
3. Horizontal scaling: duplicate, remove winner, test remaining audiences
4. Each test adds more conversion data to the pixel

### Phase 3: Confident Scaling
1. Scale winners 10-30% daily
2. Pixel now has enough data to find buyers efficiently
3. Can test broader audiences -- pixel intelligence compensates
4. Cost per acquisition should be stable and predictable

---

## Key Principles

1. **Always use standard events over custom conversions** -- leverage all advertisers' data
2. **Cyclic campaigns condition pixels faster** -- data from every funnel step
3. **Never reset learning mode unnecessarily** -- keep scaling incremental (10-30%)
4. **Clean data = better conditioning** -- don't make massive budget jumps on same campaign
5. **More historical data = more aggressive scaling possible** -- well-conditioned pixels handle higher spend
6. **The pixel gets smarter over time** -- more conversions = better optimization = lower costs
