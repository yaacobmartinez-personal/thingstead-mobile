# Architecture

Short orientation for the Flutter app. The full plan with phases is in
[PLAN.md](PLAN.md); the API is in [API-CONTRACT.md](API-CONTRACT.md).

## One app, two modes

- **Attendee** (`/a/*`, default): find an org by link or code, see its published
  events, register, keep QR tickets.
- **Organizer** (`/o/*`): events, attendee list, QR scanner check-in, team,
  settings. Offered once the signed-in user has any org membership.

Both are `StatefulShellRoute.indexedStack` shells in `lib/core/router/app_router.dart`.
The current mode is `AppModeController` (persisted); switching mode navigates
to that shell's home. Deep links pick the mode for the target.

## Layers

```
presentation/   widgets only; reads controllers, never Dio or drift
application/    @riverpod controllers (state machines, AsyncValue)
domain/         models (freezed) + abstract repositories
data/           RealXRepository(Dio) and FakeXRepository(FakeStore)
```

Feature folders live under `lib/features/{auth,shell,attendee/*,organizer/*}`;
cross-cutting code under `lib/core`.

## `API_MODE`

`--dart-define=API_MODE=fake|real` (default `fake`). Every repository provider
is a `switch` over the mode. Fakes share one `FakeStore` (`lib/core/fake`), an
in-memory copy of the server's data model seeded by `seed.dart`, so the
attendee and organizer sides see each other's changes. Fakes enforce the same
rules as the server (capacity, duplicates, last-admin guard).

In `real` mode, `Feature` gates (`lib/core/config/feature_availability.dart`)
hide UI for endpoints the backend has not shipped. Flipping one to `true` is
the only change needed when an endpoint lands. As of 2026-09 everything in
the contract is live except Google/Apple sign-in (#6, #7) and the deep-link
well-known files (§3), so `socialSignIn` is the one flag still off.

## Offline check-in

Everything the organizer screens render comes from the drift database
(`lib/core/storage/db`): the attendee list, the events list, and the queue.
Network fetches upsert the caches; a manual toggle, an offline scan, and the
sync worker all write to the same rows, so one stream keeps the screen right.

- **Fetch**: `AttendeesController` fetches into `cached_attendees` and renders
  `LocalCache.watchAttendees`. A transport failure (or 5xx) shows the saved
  list with `stale: true`; a 403/404 is a real error.
- **Manual toggle**: written to the cache first; online it is sent, offline (or
  on transport failure) it is queued (`kind: manual`). Repeated toggles on one
  person collapse into the last desired state.
- **Scan**: online → server, then the cached row is patched. Offline →
  `OfflineResolver` applies the server's decision table to the cached row
  (wrong event / cancelled / waitlist / already / checked in) and queues a
  `scan` op; an unknown token is queued blind and shown as "Queued".
- **Sync** (`SyncWorker`, driven by `SyncController`): FIFO replay whenever
  connectivity returns, the app resumes, an op is enqueued, or 60 s pass with
  work pending. Rules: manual 200 → synced (server time wins); scan
  checked_in/already → synced; scan refused → attention and the optimistic
  local check-in is reverted; 404 → attention; 401 → stop (auth signs out,
  ops stay); 403 → stop, list marked blocked; transport/5xx → backoff
  `min(2^n s, 5 min)`, attention after 20 tries.
- **Door time**: a manual replay sends the op's `clientAt` as `at`
  (API-CONTRACT #24), so a queue drained an hour later still records when
  each person actually arrived; the server clamps it into
  `[registration.createdAt, now]` and rejects a clock more than five minutes
  fast. **Scan replays cannot do this yet** — `POST /mobile/checkin` has no
  `at` parameter, so an offline scan is stamped with its replay time until
  the backend adds one. Scans are the busier path at the door.
- **Session**: a deliberate sign-out wipes everything local (after a warning
  when ops are pending); an expired session keeps the queue for the re-login.
- **UI**: `SyncBadge` (pending / syncing / attention / synced N min ago) on
  the attendee header and Scan tab; `/o/sync/attention` lists refused ops
  with retry / dismiss / open attendees; rows with a queued op show a cloud
  glyph.

In fake mode the fakes throw a network error while the device reports
offline, so airplane mode demos the whole path without a server.

## Time

All instants are UTC. Rendering uses the event's IANA zone via
`lib/core/time/app_time.dart`, which ports `regista/lib/time.ts` (including the
DST-gap check for the event form).

## Organizer management (Phase 4)

Event CRUD, attendee promote/erase/export, and team management are fake-backed
until API-CONTRACT #18–#32 ship (`Feature.eventCrud`, `promoteErase`,
`csvExport`, `team`). The pieces:

- `events/domain/event_input.dart` — the form payload with the server's
  validation (`eventInputSchema` port, incl. the DST-gap check), so the same
  messages appear whether the check ran locally or on the server.
- `events/application/event_detail_controller.dart` — `eventDetailProvider`
  plus `EventActions` (create/update/setStatus/delete). Mutations invalidate
  the list and detail providers; screens refetch on return.
- `attendees/application/attendee_actions.dart` — promote/erase refetch the
  cached list (the screen renders from the cache); `export` writes the CSV to
  the temp dir and opens the share sheet through `CsvSharer`, which tests
  replace.
- `team/application/team_controller.dart` — `TeamController(org)` reloads
  after every action. The last-admin rule is enforced by the server (fake:
  409 `last_admin`) and mirrored in the UI via `TeamPage.canReduceAdmin`.

Riverpod's retry policy (`lib/core/network/retry_policy.dart`) only retries
transport failures, on the root scope and on every test container, so a 403
or 404 rejects a provider's `.future` immediately.

## Attendee mode and deep links (Phase 5)

Everything attendee-side is behind `Feature.attendeeMode` (API-CONTRACT
#10–#17), live on the real server since 2026-09.

- `attendee/orgs` — public org page and event page (`PublicEventsRepository`),
  `RecentOrgs` (prefs-persisted shortcuts; there is no directory), the Find
  tab (code field + link scanner), and `PublicEventScreen` with the Register
  CTA. Registering is login-gated at the button, not the route, so shared
  links open instantly.
- `attendee/registration` — `RegisterController` ports the web `register`
  action's outcomes (confirmed / waitlisted / full / duplicate / closed) and
  invalidates the public event and the ticket list.
- `attendee/tickets` — `TicketsController` (upcoming/past split, rebuilt on
  account change), `TicketActions` (import from a manage link with the
  email-mismatch rule, cancel with no waitlist promotion), and the ticket
  screen whose QR encodes `APP_ORIGIN/checkin?c=<token>` — the same URL the
  web ticket carries, so the organizer scanner reads it unchanged.
- Deep links: `app_links` → `DeepLinkParser` (pure) → `actionFor` (pure
  routing table, `lib/core/router/deep_link_handler.dart`) → `go`. Public
  pages nest under `/a/events` and ticket pages under `/a/tickets`, so a
  declarative `go` builds the full back stack. Flutter's built-in deep
  linking is disabled on both platforms. Cold-start links wait for the boot
  session check so organizer-only links (check-in) route correctly.

## Design system (Phase D)

The plan and its rationale are in `docs/REDESIGN.md`; this is the map.

- **Tokens.** `AppPalette` (`lib/core/theme/palette.dart`) is a
  `ThemeExtension` with one instance per brightness. Widgets read colors as
  `context.palette.x`, never as constants, so a screen is theme-correct
  without knowing which theme is active. Lime always carries `onLime` (ink);
  `strong` is ink on light and pale on dark. Avatars use fixed pale tones
  because their initials are always ink.
- **Type.** `AppType` (`typography.dart`) is the Manrope scale. Styles set
  both `fontWeight` and `fontVariations` because the bundled font is a
  variable TTF.
- **Theme.** `AppTheme.light()/dark()` (`app_theme.dart`) derive every
  Material component theme from the palette; `AppearanceController`
  (`features/settings/application/`) persists the `ThemeMode`.
- **Motion.** `Motion` (`motion.dart`) holds the durations and curves.
  `motionSettingsProvider` is false under `MediaQuery.disableAnimations` or
  reduce-motion, and every loop or decorative entrance checks it — which is
  also what keeps `pumpAndSettle` from hanging in tests (`TestWorld`
  overrides it to reduced). Route transitions live in
  `core/router/transitions.dart`; tab switches cross-fade through
  `AnimatedBranches` (`features/shell/presentation/`), whose `TickerMode`
  sits *inside* the fade so an inactive branch cannot freeze it.
- **Components.** `lib/core/ui/` — `HeroScaffold` (parallax image, scrim,
  sage sheet, floating round buttons, optional `BottomActionBar`),
  `PillButton`, `RoundIconButton` (40 px disc in a 48 px target),
  `SlideToAct` (drag, long-press, or semantics tap), `TicketCard`
  (perforated stub), `AppBottomNav`, `IconTile`/`DateTile`/`InitialsAvatar`/
  `AvatarStack`, `StatCounter`/`ProgressRing`, `Skeleton`, `Enter`/
  `StaggeredColumn`, `Celebration`, `showAppSheet`.
- **Illustrations.** `Illustrations` (`theme/illustrations.dart`) names the
  assets; `assets/illustrations/MANIFEST.md` records the style prompt and
  seed for each so any one can be regenerated. Event heroes are picked by
  slug hash so an event keeps its picture.
- **Onboarding.** `features/onboarding/` shows three pages once
  (`onboardingSeen` pref); the router sends a signed-out first launch of the
  attendee home there.

Testing notes that follow from the above: the Ahem test font is wide, so
chips and labels ellipsize (`Flexible` text); lazily built list items are
offstage until revealed, so widget tests use
`tester.ensureVisible(find.x(skipOffstage: false))` rather than
`scrollUntilVisible` (whose drags can start on a text field).

## Developer tools

The server address (login footer, Account, Settings) is a developer
affordance ported from the Expo app for pointing at staging or a laptop.
`devToolsProvider` (`lib/core/config/dev_tools.dart`) hides it in release
builds; long-pressing the version line in Account or Settings reveals it
for the session, so support can still reach it. Debug and profile builds
show it by default.

## Organizer onboarding

New organizers set up in the app instead of on the web (API-CONTRACT
#34–#35, `Feature.createOrg`):

- **Intent.** The signup screen asks "I'm here to: Attend / Organize". The
  choice is persisted (`OrganizeIntent`, a pref) because verification may
  come back through an emailed link. The router redirect sends a signed-in
  person with the intent and no membership to `/organize` when they leave
  the auth stack; the setup screen clears it on arrival.
- **Entry points.** The intro's last page ("I organize events"), the signup
  choice, and an Account-tab card for signed-in people without an org.
  Signed out, the intro link goes to `login?from=/organize`, which
  preselects "Organize" on signup.
- **Steps.** `/organize` (`CreateOrgScreen`: name, address with live
  availability) → `CreateOrg.submit` creates the org, refreshes memberships,
  selects it and switches to organizer mode → `/o/events/new?first=1` (the
  normal event form in first-event mode, with "Skip for now") →
  `/o/welcome?event=` (celebration, the event, what to do next).
- `/organize` lives outside `/o` because that prefix requires a membership;
  it requires a session.
