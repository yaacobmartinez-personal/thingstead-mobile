# Thingstead — visual redesign plan ("Phase D")

Runs after Phase 5 (attendee mode) and before Phase 6 (release). The
functionality is done; this pass changes how it looks and moves.

## Decisions (agreed 2026-09-18)

| Topic | Decision |
|---|---|
| Palette | **Go green** like the reference: sage/lime, dark ink text, white floating cards. Navy/gold retired in the app (the web keeps its own look). |
| Illustrations | **AI-generated** in one consistent style (Z-Image Turbo, fixed style prompt + recorded seeds), reviewed by you before they ship. |
| Scope | **Everything**: both shells, auth, plus a new 3-page onboarding. |
| Dark mode | **Yes**, light and dark from the start, `ThemeMode.system` with an in-app override. |

## What "rigid" is today, and what changes

| Today | After |
|---|---|
| Solid navy app bars on every screen; content starts below a hard edge | Hero image or illustration bleeding to the top; a white sheet with a 28 px rounded top overlapping it; floating circular buttons (back, skip, menu) |
| 12 px radii, 1 px borders, flat white cards on grey | 24 px cards, no borders, soft tinted shadows, sage backgrounds |
| Rectangular buttons, uniform 44–48 px | Pill buttons (lime with dark text for primary, ink-black for strong secondary, white ghost), a **slide-to-act** for the one big action on a screen |
| System font, same weight everywhere | Manrope: heavy display titles, medium body, small tracked-uppercase labels |
| Icons in list tiles, text-only empty states | Icon tiles on white rounded squares (the reference's category row), illustrated empty states |
| No motion beyond Material defaults | A motion system: staggered list entrances, hero card → detail transitions, sheet slide-ups, count-up stats, animated check-in, pulsing scanner reticle, shimmer skeletons |

## 1. Design system

### 1.1 Color tokens

Light (from the reference: bg ≈ #E6EFD8→#D9E7C3, buttons ≈ #C9DB93, ink ≈ #1C1F1A):

| Token | Value | Use |
|---|---|---|
| `sage` | `#E8F0D9` | scaffold background |
| `sageDeep` | `#D7E4BE` | background gradient end, pressed states |
| `surface` | `#FFFFFF` | cards, sheets |
| `surfaceTint` | `#F4F8EC` | inputs, secondary cards, icon tiles |
| `lime` | `#C8DC96` | primary buttons, selected nav indicator, chips |
| `limeDeep` | `#9DB85B` | icons, progress, links, focus ring |
| `moss` | `#2F4A2A` | headings on light illustrations, accents |
| `ink` | `#171C14` | text, strong buttons |
| `muted` | `#6B7565` | secondary text |
| `faint` | `#98A28F` | captions, dividers |
| `success` / `successBg` | `#2F7D4F` / `#E3F1E7` | checked-in, confirmed |
| `warn` / `warnBg` | `#B8892E` / `#F7EED6` | waitlist, drafts (a nod to the old gold) |
| `danger` / `dangerBg` | `#B4232A` / `#FBE9EA` | destructive, cancelled |
| `scrim` | `#171C14` @ 0→60 % | gradient over hero images for legible titles |

Dark:

| Token | Value |
|---|---|
| `sage` (bg) | `#121711` |
| `sageDeep` | `#0D110C` |
| `surface` | `#1C231A` |
| `surfaceTint` | `#262F23` |
| `lime` | `#C8DC96` (unchanged — the accent pops on dark) |
| `limeDeep` | `#AFCB6E` |
| `moss` | `#9DB85B` |
| `ink` (text) | `#EEF3E6` |
| `muted` | `#A5AF9C` |
| `faint` | `#6F7A68` |
| `successBg` / `warnBg` / `dangerBg` | 20 % tints of the base colors |

Rules: dark text on lime, never white on lime (contrast). Lime is an accent
— one lime element per view section, ink for the rest. Status colors are
the only other hues.

`AppColors` becomes two `AppPalette` instances (light, dark) exposed through
a `ThemeExtension` so widgets read `context.palette.lime`, never a constant.

### 1.2 Typography

**Manrope** (OFL, bundled in `assets/fonts/` — no runtime download). Scale:

| Style | Size / weight / spacing | Use |
|---|---|---|
| display | 32 / 800 / −0.5 | onboarding titles, hero titles over images |
| title | 24 / 800 / −0.3 | screen titles inside sheets |
| heading | 18 / 700 | card titles, section headings |
| body | 15 / 500 / line 1.5 | descriptions |
| label | 13 / 600 | buttons, chips |
| caption | 12 / 600 / +0.6 uppercase | "MEMBERS (3)", "UPCOMING", stat labels |
| numeral | 28 / 800 tabular | stats, date tiles |

### 1.3 Shape, spacing, elevation

- Radii: cards 24, sheets/heroes 28, icon tiles 20, inputs 16, chips & buttons pill.
- Spacing stays on the 4 px grid; screen gutter 20 (up from 16); card padding 20.
- Elevation: no Material shadows. One soft tinted shadow (`ink` @ 6 %, blur 24, y 8) for floating elements (FAB pill, action bar, date tile). Cards on sage use no shadow; cards on white use `surfaceTint`.
- Inputs: filled `surfaceTint`, no border at rest, 2 px `limeDeep` ring on focus, error ring `danger`.

### 1.4 Illustrations

Style: flat vector with subtle grain, lime/sage/moss palette with warm skin
tones and a few coral/pink accents (like the reference's blossoms), soft
shadows, no text, no logos, generous empty space where UI overlaps.

| Asset | Size (source → shipped) | Used on |
|---|---|---|
| `onboarding_1/2/3` | 864×1536 → 720×1280 webp | Onboarding: crowd at a festival · phone showing a ticket at a door · organizer with a scanner |
| `hero_auth` | 864×1536 → 720×1280 | Login / signup header |
| `hero_find` | 1536×864 → 1280×720 | Find tab greeting header |
| `hero_org` | 1536×864 → 1280×720 | Org page header (one generic "community garden" scene) |
| `hero_event_1…4` | 864×1536 → 720×1280 | Event pages; picked by `slug.hashCode % 4` so an event always gets the same one (meetup / workshop / dinner / outdoor) |
| `tile_*` (8) | 1024² → 256² | Category-style icon tiles: events, tickets, scan, team, link, waitlist, calendar, community |
| `empty_tickets`, `empty_events`, `empty_offline`, `empty_search` | 1024² → 512² | Empty states |

Pipeline: generate with `gr2_z_image_turbo_generate` using one shared style
prompt + a subject line, `random_seed: false`, seed recorded in
`assets/illustrations/MANIFEST.md` (prompt, seed, resolution) so any image
can be regenerated or tweaked. Downscale + convert to webp (quality 82),
budget ≤ 3 MB total. A contact sheet is sent to you for review before any
image is wired in; rejected ones get a new seed or prompt.

A typed catalog `Illustrations` (`lib/core/theme/illustrations.dart`) names
every asset so screens never spell paths.

### 1.5 Components (new `lib/core/ui/`)

| Widget | What it is |
|---|---|
| `HeroScaffold` | Image/illustration header (40–45 % height) with parallax on scroll, bottom scrim, floating `RoundIconButton`s, optional title/subtitle over the image, and a sheet body with a 28 px rounded top that overlaps the hero by 24 px. Collapses to a compact bar when scrolled. |
| `RoundIconButton` | 40 px white (or ink) circle with icon; used for back, skip, close, menu. |
| `PillButton` | `primary` (lime/ink text), `strong` (ink/white text), `ghost` (white/ink), `danger`. Press scales to 0.97 with haptics. Loading state swaps the label for a spinner without changing width. |
| `SlideToAct` | The reference's "Swipe and let's go": a lime track with a round ink thumb; completes at 85 % with haptics and a fill animation. Also activates on long-press and exposes a button semantics action, so it is accessible. |
| `IconTile` | 56 px white rounded square with an icon/illustration and a caption below (category row). |
| `DateTile` | "DEC / 24 / Monday / 08:00 pm – end" block with an optional "Add" button (opens a calendar template URL). |
| `AvatarStack` | Overlapping circles + "+N" pill (initials-based; no photos in the data). |
| `StatCounter` | Big numeral that counts up on first appearance, caption below. |
| `ProgressRing` | Checked-in / confirmed ratio for organizer cards, animates on load. |
| `StatusPill` | Replaces `StatusChip`; same tones, pill shape, optional leading dot. |
| `Skeleton` | Shimmer placeholders for cards/rows while loading (replaces spinners on lists). |
| `IllustratedEmptyState` | Illustration + title + hint + optional pill action. |
| `TicketCard` | Ticket-shaped card with side notches and a dashed perforation line (`CustomClipper`), QR on the stub. |
| `AppBottomNav` | Custom 3/4-item bar: pill indicator slides between items, icon scales on select. |
| `Stagger` | Helper: wraps list children in fade+slide-up with a 40 ms stagger (`flutter_animate`). |

`SectionCard`, `EmptyState`, `ErrorBanner`, `AsyncView` are restyled in place
(`AsyncView` gains a `skeleton:` slot).

## 2. Motion system

Durations: `fast` 150 ms (presses, chips), `base` 250 ms (fades, sheets), `slow` 400 ms (page/hero), `stagger` 40 ms per item. Curves: `easeOutCubic` for entrances, `easeInOutCubicEmphasized` for shared transitions, spring (`flutter_animate` `curve: Curves.easeOutBack`) only for the check-in success mark.

Packages: `flutter_animate` (entrances, micro), `animations` (Material motion: `SharedAxisTransition`, `FadeThroughTransition`, `OpenContainer`). No Lottie — the two "celebration" moments are drawn with `CustomPainter` so nothing else is bundled.

`MotionSettings` (Riverpod) reads `MediaQuery.disableAnimations` / the OS reduce-motion flag and a test override; looping animations (reticle pulse, QR breathing, shimmer) stop when reduced, and tests run with motion reduced so `pumpAndSettle` never hangs.

| Where | Motion |
|---|---|
| Tab switch | `FadeThroughTransition` between branches; nav pill indicator slides |
| Card → detail (events, tickets, orgs) | `OpenContainer` morph from the card into the hero screen; title `Hero` |
| Sheets (register, actions, invite, manual entry) | slide up with a spring-less ease, scrim fades; drag handle |
| Lists | `Stagger` entrance on first load and after pull-to-refresh |
| Loading | skeleton shimmer; content cross-fades in |
| Buttons | scale 0.97 + light haptic on press; loading spinner morph |
| `SlideToAct` | thumb follows finger, track fills, completes with medium haptic, then morphs into the outcome card |
| Register outcome | animated checkmark draw (confirmed) or hourglass tilt (waitlisted), confetti burst of lime/coral dots for confirmed |
| Stats (event detail, organizer cards) | count-up over 600 ms; `ProgressRing` sweeps |
| Attendee toggle | checkbox morphs to a filled check with a bounce; row background flashes `successBg` |
| Scanner | reticle corners pulse; on detect the reticle snaps to lime; outcome card slides up; success/refused haptics |
| Sync badge | pending count bounces on change; "Synced" tick draws |
| QR on ticket | slow 2 % breathing scale (stops under reduce motion); brightness hint fades in after 1 s |
| Onboarding | `PageView` with parallax illustrations (0.3×), animated dots, Skip fades out on the last page |
| Errors | `ErrorBanner` slides down; form fields shake 2× on server field errors |
| Empty states | illustration floats gently (4 s loop, reduced-motion aware) |

## 3. Screen by screen

### Onboarding (new, `features/onboarding/`)
Three pages, shown once (`Prefs.onboardingSeen`), reachable again from Account → "Show intro". Page = full-bleed illustration top 60 %, white sheet with display title, two lines of body, dots, `PillButton` "Get started" on the last page ("Next" before), `RoundIconButton` "Skip" floating top-right. Copy: *Join events near you* · *Your ticket lives here* · *Run the door from your phone*.

### Auth
`HeroScaffold` with `hero_auth`, wordmark and "Sign in" over the scrim, white sheet with filled inputs, lime `PillButton` "Sign in", ghost pills for Google/Apple, text links. Signup, check-email, verify, forgot, reset share the layout with smaller heroes. Server footer becomes a caption pill.

### Attendee shell
- **Find events**: `HeroScaffold` (`hero_find`) with "Hello, {first name}" (or "Hello there") and "Find your next event" over the image; sheet: code input as a pill search with a lime "Go" thumb, an `IconTile` row (Scan link · Paste link · My tickets · Recent), then "Recent" as cards with the org illustration crop. Real-mode "coming soon" becomes an `IllustratedEmptyState`.
- **Org page**: `HeroScaffold` (`hero_org`) with org name + "N upcoming events"; event cards with `DateTile` on the left, title, when, `StatusPill` (places left / Full · waitlist). `OpenContainer` into the event.
- **Event page**: the reference's third screen. `HeroScaffold` (`hero_event_n`) with "By {org}" and the title over the scrim, back `RoundIconButton`; sheet: `DateTile` + "Add" (calendar), `AvatarStack` "+N going" (from `capacity − remaining`, or confirmed count when uncapped is unknown → hide), `SlideToAct` "Swipe to register" / "Swipe to join the waitlist" (disabled track reads "Full"), Description, "Hosted by". Signed out, the slide completes into the login flow and returns.
- **Register sheet**: same fields; outcome replaces the sheet body with the animated mark + copy + "View my ticket".
- **Tickets**: `TicketCard`s grouped Upcoming/Past; QR stub shows a mini QR for confirmed; past cards desaturate. Empty → `IllustratedEmptyState` (`empty_tickets`).
- **Ticket**: full `TicketCard` with the big QR on the stub, perforation, event/org/name rows, `StatusPill`; "Cancel my place" as a danger ghost pill at the bottom; "Event page" ghost pill.
- **Import**: sheet-style page with the pasted-link input and a lime pill.
- **Account**: profile header with an initials avatar on a lime circle, grouped rounded lists, Appearance (System / Light / Dark) segmented pill, "Show intro".

### Organizer shell
- **Events**: greeting header ("Acme Meetups" + org switcher as a `RoundIconButton`), cards with `DateTile`, title, `StatusPill`, `ProgressRing` checked-in/confirmed, lime "Scan" pill. FAB becomes a floating ink pill "＋ New event".
- **Event detail**: `HeroScaffold` with `StatCounter`s (Confirmed / Waitlist / Checked in), public link card with copy/share ghost pills, Publish/Close as a strong pill, Attendees as lime pill, overflow in a `RoundIconButton`.
- **Event form**: sectioned white cards (Basics · When · Capacity) on sage, filled inputs, date/time as `DateTile`-styled pickers, timezone as a pill opening the searchable sheet.
- **Attendees**: pinned pill search, count caption, rows with initials avatar, `StatusPill`, animated check; row tap sheet restyled; export in a `RoundIconButton`.
- **Scanner**: unchanged layout, restyled reticle (rounded lime corners, pulse), outcome cards as rounded sheets with the status color, manual-entry sheet restyled.
- **Team**: member cards with initials avatars and role pills, invitation cards, invite sheet; lime pill FAB "Invite".
- **Settings / Needs attention / Server address**: grouped rounded lists on sage, Appearance control, version caption.

### Shell
`AppBottomNav` replaces `NavigationBar` in both shells; the organizer bar keeps the sync badge (now a lime dot with a count).

## 4. Implementation phases

**Status (2026-09-19):** D0–D7 delivered in one pass (commit after `267ef77`). Left open: six illustrations still to generate when the Z-Image quota returns (`assets/illustrations/MANIFEST.md` lists them), golden screenshots (optional), and the hidden `/dev/styles` page, which was not built — the emulator walkthrough covered both themes instead.

Each ends with `flutter analyze`, `flutter test`, an emulator pass in both themes, and a commit.

**D0 — Foundations.** Tokens (`AppPalette` light/dark as a `ThemeExtension`), Manrope fonts, `AppTheme.light()/dark()` rebuilt (buttons pill, inputs filled, cards 24, nav, sheets, dialogs, snackbars), `ThemeMode` from an `AppearanceController` (prefs), `MotionSettings`, `flutter_animate` + `animations` added, a hidden `/dev/styles` screen that renders every token, type style, button, chip, and input in both themes for review on the emulator. Every existing screen already looks different after this step.

**D1 — Illustrations.** Style prompt calibrated on two test images (you approve the style), then the full set generated, contact sheet reviewed, optimized, `Illustrations` catalog and `MANIFEST.md` committed.

**D2 — Components.** Everything in §1.5, each with a widget test; `Stagger`, page transitions wired into the router (`CustomTransitionPage` per route type: fade-through for tabs, shared-axis for pushes, slide-up for sheet-like pages).

**D3 — Onboarding + auth.** New feature folder, prefs flag, redirect rule (`/onboarding` when unseen and signed out), six auth screens restyled.

**D4 — Attendee screens.** Find, org, event (with `SlideToAct`), register outcome animation, tickets, ticket (`TicketCard`), import, account.

**D5 — Organizer screens.** Events, detail (`StatCounter`, `ProgressRing`), form, attendees, scanner reticle/outcomes, team, settings, attention, server.

**D6 — Dark mode + accessibility pass.** Every screen in dark on the emulator; contrast check on each token pair (≥ 4.5:1 body, 3:1 large); reduce-motion run-through; 48 px tap targets; `SlideToAct` semantics; dynamic type at 130 %.

**D7 — QA and docs.** Widget tests updated for new copy/structure (motion reduced under test); golden screenshots of 12 key screens × 2 themes in `test/goldens/` to catch regressions; `docs/ARCHITECTURE.md` gets a "Design system" section; screenshots for the store listing captured here too (feeds Phase 6).

Roughly: D0 and D2 are the bulk of the engineering; D3–D5 are mostly composition once the components exist.

## 5. Files that change or appear

```
assets/fonts/Manrope-*.ttf                     new
assets/illustrations/*.webp, MANIFEST.md       new
lib/core/theme/{palette,app_theme,typography,motion,illustrations}.dart   rewritten/new
lib/core/theme/app_colors.dart                 removed (palette); status_chip.dart kept, rebuilt on the palette as the pill
lib/core/ui/*.dart                             new component library (§1.5)
lib/core/router/{app_router,transitions}.dart  page transitions, /onboarding, /dev/styles
lib/features/onboarding/**                     new
lib/features/settings/application/appearance_controller.dart   new
lib/features/**/presentation/*                 restyled (no controller/domain changes)
test/widgets/*, test/goldens/*                 updated/new
```

Controllers, repositories, domain models, the offline queue and the deep-link
handler are untouched; the redesign is presentation-only.

## 6. Risks

- **Illustration consistency.** Different seeds drift in style. Mitigation: one style prompt, same steps/shift, a review round, regenerate outliers; keep the set small (≈ 20).
- **APK size.** ~20 webp images + 5 font weights ≈ 3–4 MB. Acceptable; reviewed in D1.
- **Contrast on green.** Lime never carries white text; body text is ink/muted on sage or white only; checked in D6 with a contrast script.
- **Motion cost on low-end phones.** No `BackdropFilter` in scrolling lists, parallax uses transforms only, shimmer stops off-screen; profile on the emulator with `--profile` once in D2.
- **Tests and animations.** Looping animations would hang `pumpAndSettle`; `MotionSettings.reduced` is forced in `pumpApp`.
- **`SlideToAct` discoverability/accessibility.** Long-press and a semantics tap action back it; the label says what happens.

## 7. Acceptance

- Both themes render every screen without a navy or 1 px-border remnant; the `/dev/styles` page matches §1.
- Onboarding shows once; Skip and Get started land on Find events.
- Event page: hero, date tile, avatar stack, slide-to-register; outcome animation plays; ticket opens with the `TicketCard`.
- Lists stagger in; card → detail morphs; tabs fade through; reduce-motion disables loops.
- Organizer flows from Phases 2–4 still pass their tests and the emulator checklist (scan, offline queue, CRUD, team).
- 234 existing tests still green plus new component and golden tests.
