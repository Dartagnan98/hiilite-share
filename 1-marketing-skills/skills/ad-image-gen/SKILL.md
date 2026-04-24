# Ad Image Generator -- Nano Banana Pro Creative Production System

Generate batches of ad creative images with multiple hook variations, styles, and formats.
Uses Google's Nano Banana Pro, Gemini 2.5 Flash Image, and Imagen 4 models.

## Trigger
Use when the user says "generate image", "ad image", "create ad creative", "make me an image",
"ad visual", "product shot", "social media image", "generate creative", "nano banana",
"generate ads for [client]", "batch creative", "ad images for [business]",
or any request to create marketing/advertising imagery.

## API Call

```bash
GOOGLE_API_KEY=$(grep GOOGLE_API_KEY ${PROJECT_DIR}/.env | cut -d= -f2)
curl -s "https://generativelanguage.googleapis.com/v1beta/models/MODEL_NAME:generateContent?key=${GOOGLE_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{"parts": [{"text": "PROMPT"}]}],
    "generationConfig": {"responseModalities": ["TEXT", "IMAGE"]}
  }' | python3 -c "
import sys,json,base64
d=json.load(sys.stdin)
if 'error' in d:
    print('ERROR:', d['error']['message']); sys.exit(1)
parts = d['candidates'][0]['content']['parts']
for p in parts:
    if 'inlineData' in p:
        img = base64.b64decode(p['inlineData']['data'])
        open('FILEPATH','wb').write(img)
        print(f'Saved: {len(img)} bytes -> FILEPATH')
    elif 'text' in p: print(p['text'])
"
```

Models (replace MODEL_NAME):
- `nano-banana-pro-preview` -- Best quality, default
- `gemini-2.5-flash-image` -- Fast, good quality
- `imagen-4.0-generate-001` -- Photorealistic
- `imagen-4.0-ultra-generate-001` -- Ultra quality (slower)

Send to Telegram:
```bash
TOKEN=$(grep TELEGRAM_BOT_TOKEN ${PROJECT_DIR}/.env | cut -d= -f2)
CHAT_ID=$(grep ALLOWED_CHAT_IDS ${PROJECT_DIR}/.env | cut -d= -f2 | cut -d, -f1)
curl -s -F "chat_id=${CHAT_ID}" -F "photo=@FILEPATH" -F "caption=CAPTION" "https://api.telegram.org/bot${TOKEN}/sendPhoto"
```

## WORKFLOW: How to Produce Ad Creative

### Step 1: Understand the Business

Before generating anything, check the client knowledge file:
- Client A: ~/your-knowledge-base/clients/<client>/
- Joe: ~/your-knowledge-base/clients/<client>/
- Client C: ~/your-knowledge-base/clients/<client>/
- Client D: ~/your-knowledge-base/clients/<client>/

Understand: what they sell, who buys it, what the offer is, what emotional triggers work.

### Step 2: Generate Hook Variations

Every ad needs a HOOK -- the thing that stops the scroll. For each business, generate images across these 5 hook categories:

**1. PROBLEM HOOK** -- Show the pain point
- Before/after contrast, frustration, struggle
- Example (tattoo): "Close-up of a faded, blown-out old tattoo on someone's arm, harsh fluorescent lighting, unflattering, person looking at it with disappointment"
- Example (gym): "Empty gym floor at 5am, single pair of shoes by the door, dramatic morning light through windows, lonely atmosphere"

**2. TRANSFORMATION HOOK** -- Show the result
- The dream outcome, the after state, aspirational
- Example (tattoo): "Stunning full-sleeve Japanese tattoo, vivid colors, dramatic studio lighting, client admiring it in mirror, pride, professional photography"
- Example (gym): "Fighter celebrating after winning a match, sweat glistening, dramatic spotlight, crowd blurred in background, peak emotion"

**3. SOCIAL PROOF HOOK** -- Show others doing it
- Busy shop, happy clients, community energy
- Example (tattoo): "Packed tattoo shop on a Saturday, multiple artists working, clients laughing, warm amber lighting, community vibe, candid photography"
- Example (spa): "Group of women relaxing in luxury spa lounge, robes, champagne, soft lighting, friendship, lifestyle photography"

**4. URGENCY/SCARCITY HOOK** -- Create FOMO
- Limited time, exclusive, seasonal, event-driven
- Example (barbershop): "Vintage barbershop 'APPOINTMENT ONLY' neon sign glowing, dark moody exterior at night, exclusive feel, cinematic"
- Example (real estate): "SOLD sign being hammered into lawn of beautiful home, golden hour, slightly motion-blurred, someone just missed out"

**5. CURIOSITY HOOK** -- Make them want to know more
- Unusual angle, mystery, unexpected perspective
- Example (tattoo): "Extreme macro shot of tattoo needle touching skin, single ink droplet, shallow depth of field, clinical precision, almost abstract"
- Example (gym): "Overhead drone shot of boxing ring, single fighter shadow boxing, geometric composition, dark and moody, cinematic"

### Step 3: Format Variations

For each hook, generate across multiple ad formats:

| Format | Aspect | Use Case | Prompt Addition |
|--------|--------|----------|-----------------|
| Feed Square | 1:1 | Instagram/Facebook feed | "square 1:1 composition, centered subject" |
| Feed Portrait | 4:5 | Instagram feed (max real estate) | "4:5 vertical composition, subject fills frame" |
| Story/Reel | 9:16 | Stories, Reels, TikTok | "vertical 9:16 format, text-safe zones top 15% and bottom 20%" |
| Landscape | 16:9 | Facebook feed, YouTube thumbnail | "16:9 landscape, headline space on right third" |

### Step 4: Style Variations

Apply different visual treatments to the same hook:

**Cinematic** -- "cinematic color grading, anamorphic bokeh, film grain, 35mm, shallow depth of field, dramatic lighting"

**Clean/Minimal** -- "clean white background, bright studio lighting, minimal composition, modern, sharp focus, product photography"

**Raw/Authentic** -- "candid, natural light, slightly grainy, iPhone quality, real moment, not staged, authentic"

**Dark/Moody** -- "dark background, dramatic rim lighting, high contrast, shadows, premium feel, low-key lighting"

**Warm/Inviting** -- "golden hour, warm tones, soft diffused light, welcoming atmosphere, lifestyle photography"

**Bold/Graphic** -- "bold solid color background, high saturation, pop art influence, eye-catching, graphic design meets photography"

### Step 5: Batch Generation

When the user asks for ad creative for a client, generate a BATCH:
- 5 hook variations x 2 styles = 10 images minimum
- Save all to /tmp/ad-batch-[client]-[date]/
- Show each one to the user
- Send the best ones to Telegram
- Name files descriptively: `hook-problem-cinematic-1.png`, `hook-transformation-warm-1.png`

## PROMPT CONSTRUCTION FORMULA

Every prompt should follow this structure:

```
[SCENE DESCRIPTION]. [SUBJECT DETAIL]. [LIGHTING]. [CAMERA SPECS]. [MOOD/ATMOSPHERE]. [STYLE KEYWORDS]. [FORMAT].
```

Example:
```
Tattoo artist working on an intricate Japanese dragon sleeve. Close-up of hands and needle, vivid ink colors visible on skin. Dramatic overhead spotlight with warm amber fill light, volumetric haze in background. 85mm lens, f/1.8, shallow depth of field. Focused, intense atmosphere, premium craft feel. Professional editorial photography, high detail, ultra-realistic. Square 1:1 composition.
```

## PROMPT ENHANCEMENT RULES

When the user gives a vague request, ALWAYS enhance with:

1. **Camera specs**: lens focal length (35mm wide, 50mm standard, 85mm portrait, 200mm telephoto), aperture (f/1.4-f/2.8 for bokeh, f/8-f/11 for sharp), depth of field
2. **Lighting**: natural/studio/dramatic/rim/volumetric/golden hour/neon, direction (overhead, side, backlighting), quality (hard, soft, diffused)
3. **Texture and detail**: skin texture, material quality, sweat, steam, dust particles, reflections
4. **Composition**: rule of thirds, centered, leading lines, negative space for text, safe zones
5. **Emotion**: what should the viewer FEEL? Excitement, aspiration, FOMO, curiosity, trust
6. **Format**: always specify aspect ratio for the intended placement

## ADVANCED TECHNIQUES (from Nano Banana Pro library)

### Liquid Glass Infographic (for premium product/service showcase)
```
Premium liquid glass Bento grid layout with [N] modules.
Product/service: [WHAT].
Cards: Apple liquid glass (85-90% transparent), whisper-thin borders, subtle drop shadow for floating depth.
Background: [product essence/texture] with light caustics and abstract glow, heavily blurred.
Color palette derived from [brand color]. Icons and accents in muted [brand color] at 30-40% saturation.
16:9 landscape, ultra-premium.
```

### Quote Card (for testimonial/social proof ads)
```
Wide quote card, [BRAND COLOR] background, light-gold serif font.
Quote: "[TESTIMONIAL TEXT]"
Attribution: "-- [CLIENT NAME], [TITLE]"
Large subtle quotation mark watermark before text.
Photo of person on left (one-third), text on right (two-thirds).
Gradient transition between photo and text area.
Professional, trustworthy, premium feel.
```

### Split Comparison (for before/after)
```
Split-screen image, left side and right side divided by clean white line.
Left (BEFORE): [negative state, muted colors, flat lighting]
Right (AFTER): [positive outcome, vibrant colors, dramatic lighting]
Same camera angle both sides. Text labels "BEFORE" and "AFTER" in clean sans-serif.
Professional photography, high contrast between sides.
```

### Environment Hero Shot (for local businesses)
```
[Business type] interior/exterior at [time of day].
[Key visual elements that make this business unique].
[Human element: staff working, clients enjoying].
[Specific lighting: Edison bulbs, neon signs, natural light, spotlights].
Wide angle 24mm lens, f/4, everything in focus.
Warm, inviting atmosphere that makes you want to walk in.
Professional architectural/interior photography style.
```

### Action/Movement Shot (for fitness, sports, dynamic businesses)
```
[Subject] in motion, [specific action].
Freeze-frame with slight motion blur on extremities.
[Dramatic lighting with rim light separating subject from background].
Sweat/water/dust particles caught in light.
Low angle, 35mm, f/2.8. High shutter speed frozen action.
Raw intensity, peak moment, emotional impact.
Sports/action photography style, magazine editorial quality.
```

## CLIENT-SPECIFIC KNOWLEDGE

When generating for a specific client, read their knowledge file first and incorporate:
- Brand colors, logo placement guidelines
- Specific services/offers to highlight
- Target audience demographics
- Location details (for environment shots)
- Existing ad creative style (to maintain consistency or deliberately break pattern)

## OUTPUT

After generating each image:
1. Read the file to show the user
2. Name the hook variation and style used
3. Ask if they want to iterate (darker, different angle, add text space, etc.)
4. Offer to send to Telegram or save to a specific folder
5. For batches, present all images then ask which to keep/iterate/discard
