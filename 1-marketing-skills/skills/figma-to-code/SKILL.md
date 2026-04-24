# Figma to Code

Converts Figma designs into production-ready React and Next.js components. Handles component reuse, variant mapping, and design token extraction. Best used alongside the official Figma MCP server.

## Prerequisites

This skill works best when the Figma MCP server is connected, providing access to Figma file data via tools like `figma_get_file`, `figma_get_node`, etc. If the MCP server is not available, the user can provide:
- Figma file URLs or node IDs
- Screenshots of the design
- Exported design specs or JSON

## Workflow

### Step 1: Inspect the Design

Using the Figma MCP tools (or user-provided screenshots/specs):

1. **Get the file structure.** Identify all pages and top-level frames.
2. **Identify components.** List all reusable components, their variants, and where they appear.
3. **Extract the design system:**
   - Colors (with names, hex values, opacity)
   - Typography (font family, sizes, weights, line heights, letter spacing)
   - Spacing scale (padding, margins, gaps)
   - Border radii
   - Shadows / elevation
   - Breakpoints (if responsive frames exist)
4. **Map the layout.** For each frame/page, identify:
   - Layout type (flex row, flex column, grid, absolute)
   - Alignment and distribution
   - Responsive behavior (auto-layout properties)
   - Overflow handling

### Step 2: Create Design Tokens

Before writing any components, extract design tokens into a centralized file:

```typescript
// tokens.ts (or tailwind.config extension)
export const tokens = {
  colors: {
    primary: '#XXXXXX',
    secondary: '#XXXXXX',
    background: '#XXXXXX',
    surface: '#XXXXXX',
    text: {
      primary: '#XXXXXX',
      secondary: '#XXXXXX',
      muted: '#XXXXXX',
    },
    border: '#XXXXXX',
    error: '#XXXXXX',
    success: '#XXXXXX',
  },
  typography: {
    heading1: { fontSize: 'Xpx', fontWeight: 700, lineHeight: 'X' },
    heading2: { fontSize: 'Xpx', fontWeight: 600, lineHeight: 'X' },
    body: { fontSize: 'Xpx', fontWeight: 400, lineHeight: 'X' },
    caption: { fontSize: 'Xpx', fontWeight: 400, lineHeight: 'X' },
  },
  spacing: {
    xs: 'Xpx',
    sm: 'Xpx',
    md: 'Xpx',
    lg: 'Xpx',
    xl: 'Xpx',
  },
  radii: {
    sm: 'Xpx',
    md: 'Xpx',
    lg: 'Xpx',
    full: '9999px',
  },
  shadows: {
    sm: '...',
    md: '...',
    lg: '...',
  },
} as const;
```

If the project uses Tailwind CSS, extend the Tailwind config with these tokens instead of creating a separate file.

### Step 3: Build Components (Bottom-Up)

Build in this order -- smallest components first, then compose them:

#### 3a. Atomic Components
Start with the smallest reusable pieces:
- Buttons (with all variants: primary, secondary, ghost, sizes)
- Input fields
- Labels / badges
- Icons (use an icon library or SVG components)
- Avatar
- Divider

#### 3b. Molecule Components
Compose atoms into small groups:
- Card (with header, body, footer slots)
- Form field (label + input + error message)
- Navigation item (icon + label + active state)
- List item
- Stat / metric display

#### 3c. Organism Components
Compose molecules into larger sections:
- Header / navbar
- Sidebar
- Data table
- Form sections
- Hero sections
- Feature grids

#### 3d. Page Layouts
Compose organisms into full pages:
- Page shell (header + sidebar + main content area)
- Specific page layouts

### Step 4: Component Standards

Every component must follow these rules:

1. **TypeScript interfaces for all props.** No `any` types.
```typescript
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'ghost';
  size: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
  loading?: boolean;
  className?: string;
}
```

2. **Map Figma variants to component props.** Each Figma variant becomes a prop value.

3. **Use design tokens, not hardcoded values.** Every color, spacing, and font reference should come from tokens.

4. **Responsive by default.** Use relative units, flex/grid layouts, and container queries or media queries as appropriate.

5. **Accessible by default.**
   - Semantic HTML elements (`button`, `nav`, `main`, `aside`, etc.)
   - ARIA labels where needed
   - Keyboard navigation support
   - Sufficient color contrast
   - Focus indicators

6. **Styling approach.** Match the project's existing approach:
   - If Tailwind CSS is used, use Tailwind classes
   - If CSS Modules exist, use CSS Modules
   - If styled-components or similar, use that
   - If no styling approach exists, default to Tailwind CSS

### Step 5: Handle Assets

1. **Icons:** Prefer an icon library (Lucide, Heroicons, Phosphor) over exporting SVGs. Map Figma icon names to library equivalents.
2. **Images:** Note placeholder dimensions and aspect ratios. Use `next/image` for Next.js projects.
3. **Fonts:** Check if the Figma font is available via Google Fonts or needs to be self-hosted. Configure in layout or CSS.
4. **Illustrations / complex SVGs:** Export from Figma and place in a `public/` or `assets/` directory.

### Step 6: Pixel-Perfect Verification

After building each component:

1. Compare against the Figma design visually (use the Claude Preview tool if available to screenshot the rendered component)
2. Check:
   - Spacing matches (within 1-2px tolerance)
   - Colors are exact (use the hex values from Figma, not approximations)
   - Typography matches (font, size, weight, line height, letter spacing)
   - Border radius matches
   - Shadow matches
   - Hover/active/focus states match the interaction specs
3. Test at multiple breakpoints if responsive variants exist in Figma

## Output Structure

Organize generated files following the project's existing conventions. If no convention exists:

```
components/
  ui/              # Atomic components (Button, Input, Badge, etc.)
  [feature]/       # Feature-specific composed components
  layout/          # Layout components (Header, Sidebar, PageShell)
lib/
  tokens.ts        # Design tokens
  utils.ts         # Utility functions (cn(), etc.)
```

## What NOT to Do

- Do not approximate colors. Use the exact hex values from Figma.
- Do not ignore spacing. If Figma says 24px gap, it's 24px, not "about 1.5rem."
- Do not skip variants. If a button has 3 variants in Figma, build all 3.
- Do not hardcode content. Use props for all text, images, and data.
- Do not create components that only work at one screen size.
- Do not ignore the existing project conventions for file structure, naming, or styling.
