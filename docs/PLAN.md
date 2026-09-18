# Thingstead — Flutter mobile app plan

## Context

Thingstead (formerly Regista, `D:\Personal\regista`, live at thingstead.pro / `https://thingstead.onrender.com`) is a multitenant free-event registration SaaS built on Next.js 16 + Prisma + Auth.js. Organizers (ADMIN/STAFF per org) publish events and check attendees in by QR; registrants currently have no accounts and get a QR ticket by email.

A React Native/Expo **organizer-only** companion app already exists at `regista/mobile/` (6 screens) talking to a 7-endpoint bearer-token API at `/api/mobile/*`. This plan replaces that direction with a **Flutter** app that is both an **attendee app and an organizer app in one**, built as a standalone project in the currently empty `D:\Personal\thingstead`.

### Decisions locked with the user

| Topic | Decision |
|---|---|
| Scope | Organizer (full: Expo parity + event CRUD, promote, erase, CSV export, team) **and** attendee (find org by link/code, register, QR ticket wallet) |
| Shape | One app, two modes; attendee is default, Organizer mode unlocks when the user has any org membership. New bundle id `pro.thingstead.app` |
| Location | Standalone Flutter project + new git repo in `D:\Personal\thingstead`. `regista/` is **read-only reference**; `regista/mobile/` (Expo) stays untouched |
| Accounts | Unified `User`: one login/token for both roles. Attendee sign-in = email+password, Google, Apple (Apple on iOS only for v1) |
| Discovery | Links + org code only — no cross-org directory |
| Backend | **Flutter-only.** Use the 7 real endpoints; every missing endpoint gets a written API contract (`docs/API-CONTRACT.md`) and a fake in-app implementation until a later backend plan ships it |
| State | Riverpod (codegen), feature-first layout |
| Offline | Organizer check-ins work offline: local attendee cache + mutation queue + replay with conflict handling |
| Platforms | Android on this Windows PC (Flutter/Android SDK not installed yet); iOS on the user's Mac. No cloud CI |

Not in scope (v1): custom questions (`Event.questions` — no web UI either), dark mode, tablet layouts, localization beyond English, token refresh (30-day HMAC token stays), Apple sign-in on Android.

### Facts from the web code that shape the design

- Token: `base64url(JSON{sub,exp}).HMAC` — `regista/lib/mobile-auth.ts:29`. App can read `exp` client-side (no signature check). 401 → sign out; no refresh endpoint.
- `GET /api/mobile/orgs` doubles as token validation + "does this user have organizer access" until a `/me` endpoint exists.
- Attendees payload **omits `checkInToken`** (`regista/app/api/mobile/orgs/[slug]/events/[eventSlug]/attendees/route.ts`), so offline scan verification needs a contract change (see §E #23); app degrades to blind queueing until then.
- QR payload = `https://app.thingstead.pro/checkin?c=<token>` (`regista/lib/urls.ts:76`); scanner accepts full URL or bare token (`regista/lib/checkin.ts:6`). Outcomes: `checked_in|already|cancelled|waitlist|wrong_event|invalid`, idempotent.
- Public tenant pages are **path-based on the apex** (`thingstead.pro/<org>/<event>`), dashboard on `app.thingstead.pro` (`regista/proxy.ts`). Reserved first segments in `regista/lib/slug.ts`.
- Web has **no password reset** and web signup always creates a Tenant — an attendee-only account is a new backend concept (contract #1).
- Event validation (`regista/lib/events.ts`): title 2–140, description ≤5000, capacity 1–1,000,000, wall-clock `YYYY-MM-DDTHH:mm` + IANA timezone, DST-gap check in `regista/lib/time.ts:70`.
- Authorization: event create/edit/status = any member; event delete + all team actions = ADMIN (`regista/app/app/o/[slug]/events/actions.ts`, `team/actions.tsx`).
- Brand tokens: `regista/mobile/src/theme.ts` (navy `#26385c`, navyDark `#1b2942`, gold `#c6a45f`, bg `#f4f5f8`, success `#2f7d4f`, danger `#b4232a`, warn `#8a6a2f`). Icon/splash PNGs in `regista/mobile/assets/`.

---

## A. Toolchain setup (Windows 11 Home, PowerShell)

```powershell
# Flutter stable (git clone so `flutter upgrade` works; avoid paths with spaces)
New-Item -ItemType Directory -Force C:\dev | Out-Null
git clone -b stable https://github.com/flutter/flutter.git C:\dev\flutter
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path","User") + ";C:\dev\flutter\bin", "User")
# open a NEW terminal
flutter --version; flutter config --no-analytics

# Android Studio (brings SDK, emulator, bundled JBR = JDK 21; no separate JDK needed)
winget install --id Google.AndroidStudio -e
# Run it once; SDK Manager > SDK Tools: tick "Android SDK Command-line Tools (latest)", Platform-Tools,
# Build-Tools, Emulator, and "Android Emulator hypervisor driver" (Home edition has no Hyper-V).
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "$env:LOCALAPPDATA\Android\Sdk", "User")
flutter config --android-sdk "$env:LOCALAPPDATA\Android\Sdk"
flutter config --jdk-dir "C:\Program Files\Android\Android Studio\jbr"
flutter doctor --android-licenses
flutter doctor -v   # need: Flutter OK, Android toolchain OK, Android Studio OK (ignore VS/Chrome/Windows-desktop)

# Emulator: Pixel 8, API 35, Google APIs image (MLKit for the QR scanner needs Play services)
$sdk = "$env:LOCALAPPDATA\Android\Sdk"
& "$sdk\cmdline-tools\latest\bin\sdkmanager.bat" "platforms;android-35" "system-images;android-35;google_apis;x86_64"
& "$sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd -n pixel8_api35 -k "system-images;android-35;google_apis;x86_64" -d pixel_8
flutter emulators --launch pixel8_api35
```

**Mac (iOS):** Xcode from App Store → `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer && sudo xcodebuild -runFirstLaunch`; `brew install cocoapods`; clone Flutter stable the same way; `flutter doctor`; sign in to the Apple Developer account in Xcode > Settings > Accounts. Per pull: `flutter pub get; cd ios && pod install; flutter run`.

---

## B. Project scaffold

```powershell
cd D:\Personal\thingstead
flutter create --org pro.thingstead --project-name thingstead --platforms android,ios --empty .
git init; git add -A; git commit -m "chore: flutter create"
```

Then:
- `android/app/build.gradle.kts`: `applicationId = "pro.thingstead.app"`, `minSdk = 23`.
- iOS: replace `pro.thingstead.thingstead` → `pro.thingstead.app` in `ios/Runner.xcodeproj/project.pbxproj`.
- Copy `regista/mobile/assets/{icon,adaptive-icon,splash-icon}.png` → `assets/brand/`.
- `.gitignore` additions: `android/key.properties`, `*.jks`, `ios/Runner/GoogleService-Info.plist`, `*.g.dart`/`*.freezed.dart` are **committed** (simpler for the Mac; no build_runner needed just to run).

**Dependencies** (check pub.dev for current majors at scaffold time; the notable API-breaking ones are flagged):

```powershell
flutter pub add flutter_riverpod riverpod_annotation go_router dio freezed_annotation json_annotation flutter_secure_storage shared_preferences mobile_scanner qr_flutter drift drift_flutter sqlite3_flutter_libs connectivity_plus google_sign_in sign_in_with_apple app_links share_plus path_provider intl timezone flutter_timezone url_launcher uuid crypto
flutter pub add --dev build_runner riverpod_generator riverpod_lint custom_lint freezed json_serializable drift_dev mocktail flutter_lints flutter_launcher_icons flutter_native_splash
# add `integration_test: {sdk: flutter}` under dev_dependencies by hand
```

| Package | Why / flag |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` (3.x) | Locked. **v3 flag:** providers auto-retry on error; set `ProviderScope(retry:)` so only `ApiError(status: 0)` retries, never 401/403/404. Don't import `legacy.dart`. |
| `go_router` | `StatefulShellRoute.indexedStack` for the two bottom-nav shells, `redirect` guards. |
| `dio` | Interceptors (bearer, 401, cold-start retry), `ResponseType.bytes` for CSV. |
| `freezed` + `json_serializable` | Immutable models = DTOs (API shape is the domain shape; no double mapping). **v3 flag:** unions must be `sealed class`. |
| `flutter_secure_storage` | Token, server URL, cached user (mirrors Expo `SecureStore`). Set `android:allowBackup="false"`. |
| `shared_preferences` | Non-secret prefs: app mode, selected org, recent org codes. |
| `mobile_scanner` | QR via MLKit/AVFoundation; `formats: [qrCode]`, `DetectionSpeed.noDuplicates`, torch. Majors bump often — read its changelog. |
| `qr_flutter` | Render the attendee's ticket QR (same URL the web SVG encodes). |
| `drift` + `drift_flutter` + `sqlite3_flutter_libs` | Typed SQLite for cached attendees + pending check-in queue; `watch()` streams for badges; `NativeDatabase.memory()` in tests. |
| `connectivity_plus` | Hint to attempt a queue drain — never trusted as "online". |
| `google_sign_in` (7.x) | **7.0 rewrote the API:** `GoogleSignIn.instance.initialize(serverClientId:)`, `authenticate()`, `.authentication.idToken`. Old tutorials are wrong. |
| `sign_in_with_apple` | iOS only in v1: `getAppleIDCredential(scopes, nonce)`. |
| `app_links` | Full `Uri` incl. host (needed: `thingstead.pro/<org>` vs `app.thingstead.pro/checkin`). Disable Flutter's built-in deep linking (`FlutterDeepLinkingEnabled=false` iOS; omit the Android meta-data). |
| `share_plus` + `path_provider` | CSV → temp file → share sheet. |
| `intl` + `timezone` + `flutter_timezone` | IANA rendering via `tz.TZDateTime`; device zone preselect in the event form. Use `timezone/data/latest_10y.dart`. |
| `url_launcher` | Open web-only paths (privacy, dashboard) in an in-app browser tab. |
| `uuid`, `crypto` | Queue op ids; SHA-256 nonce for Apple. |
| `flutter_launcher_icons`, `flutter_native_splash` | Generate from `assets/brand/*`, background `#1b2942`. |
| dev: `riverpod_lint`, `custom_lint`, `mocktail` | Lints + codegen-free mocks. |

`analysis_options.yaml`: `include: package:flutter_lints/flutter.yaml` + `plugins: [custom_lint]`. `build.yaml`: restrict generators to `lib/**`.

---

## C. Folder structure

```
D:\Personal\thingstead\
  docs/API-CONTRACT.md            <- section E, the spec the backend plan implements 1:1
  docs/ARCHITECTURE.md            <- short: modes, repos, API_MODE, offline queue
  assets/brand/
  lib/
    main.dart                     bootstrap: tz init, open drift, read secure storage -> ProviderScope -> runApp
    app.dart                      MaterialApp.router(theme, routerConfig)
    core/
      config/app_config.dart      ApiMode {real, fake} from --dart-define=API_MODE (default fake); DEFAULT_SERVER_URL, PUBLIC_ORIGIN, APP_ORIGIN
      config/feature_availability.dart   enum Feature + isAvailable(feature, apiMode) — hides UI for endpoints the real server lacks
      theme/{app_colors, app_theme, spacing, status_chip}.dart
      router/{app_router, routes, guards, router_refresh, deep_link_parser, deep_link_handler}.dart
      network/{api_client, auth_interceptor, unauthorized_events, cold_start_interceptor, api_error}.dart
      storage/{secure_store, prefs}.dart
      storage/db/{app_database, tables}.dart + daos/{cached_attendees_dao, pending_checkins_dao}.dart
      time/{app_time, clock}.dart
      connectivity/connectivity_provider.dart
      fake/{fake_store, fake_latency, seed}.dart     one shared in-memory world for every Fake* repo
      util/{slugify, csv, debounce, validators, checkin_code}.dart
      widgets/{async_view, empty_state, error_banner, app_button, app_text_field, chip, server_waking_view, confirm_dialog}.dart
    features/
      auth/        domain/{user, auth_repository, social_credential, auth_result}.dart
                   data/{real_auth_repository, fake_auth_repository, token_codec, google_sign_in_service, apple_sign_in_service}.dart
                   application/{auth_controller, auth_state}.dart
                   presentation/{login, signup, check_email, verify, forgot_password, reset_password}_screen.dart, widgets/social_buttons.dart
      shell/       application/app_mode_controller.dart; presentation/{attendee_shell, organizer_shell, mode_switch_tile}.dart
      attendee/
        orgs/          domain/{public_org, public_event, public_events_repository}; data/{real_,fake_}public_events_repository
                       application/{org_lookup, recent_orgs, public_events}_controller; presentation/{find_events, org_events, event_detail}_screen, link_scanner_sheet
        registration/  domain/{registration_repository, register_outcome}; data/{real_,fake_}...; application/register_controller; presentation/register_sheet
        tickets/       domain/{ticket, tickets_repository}; data/{real_,fake_}...; application/{tickets, import_ticket}_controller
                       presentation/{tickets, ticket_detail, import_ticket}_screen, ticket_qr
        account/       presentation/account_screen.dart
      organizer/
        orgs/          domain/{org, orgs_repository}; data/...; application/{orgs, selected_org}_controller; presentation/{org_picker_screen, org_switcher_button}
        events/        domain/{event_summary, event_detail, event_input, org_events_repository}; data/...; application/{events, event_form, event_detail}_controller
                       presentation/{events, event_detail, event_form}_screen, event_card, timezone_picker
        attendees/     domain/{attendee, attendees_repository}; data/{real_,fake_}..., attendees_cache (drift-backed)
                       application/{attendees, attendee_actions, export}_controller; presentation/{attendees_screen, attendee_row, attendee_actions_sheet}
        checkin/       domain/{checkin_repository, scan_result, pending_checkin, sync_status}; data/{real_,fake_}checkin_repository, sync_worker, offline_resolver
                       application/{sync, checkin}_controller; presentation/{needs_attention_screen, sync_badge}
        scanner/       domain/scan_source.dart; data/{camera_scan_source, manual_scan_source}; application/scanner_controller
                       presentation/{scanner_screen, scan_result_card, manual_entry_sheet, camera_permission_view}
        team/          domain/{team_member, invitation, team_repository}; data/{real_,fake_}...; application/team_controller
                       presentation/{team_screen, invite_sheet, member_tile}
        settings/      application/account_controller (delete account); presentation/{settings_screen, server_address_screen, delete_account_dialog}
  test/
    helpers/{pump_app, fake_repos, test_clock, fixtures, in_memory_db}.dart
    core/{api_client, api_error, token_codec, deep_link_parser, app_time, csv, checkin_code}_test.dart
    features/... (one _test per controller/repo/resolver — see §H)
    widgets/{login, events, attendees, scanner, ticket_detail, event_form}_screen_test.dart
  integration_test/{offline_queue, organizer_flow, attendee_flow}_test.dart
```

Conventions: one abstract repository per feature in `domain/`; `application/` = `@riverpod` controllers only; `presentation/` = widgets only, never touches Dio or drift.

---

## D. Core architecture

### D1. API client
- `serverUrlProvider` (keepAlive) reads `thingstead.serverUrl` from secure storage, default `https://thingstead.onrender.com`, trailing slashes trimmed (port `normalizeServerUrl`, `regista/mobile/src/config.ts`). Changing it signs out.
- `apiClientProvider` → `Dio(baseUrl: '$serverUrl/api', connectTimeout 15s, receiveTimeout 20s, headers Accept + X-Client: thingstead-flutter/<ver>)`. Rebuilds when URL/token change.
- Interceptors in order: `AuthInterceptor` (bearer), `ColdStartInterceptor` (first-call timeout/connection error → retry up to 4× at 5s, flips `serverWakingProvider` → "Waking the server…" UI; Render free tier sleeps), `ErrorMappingInterceptor` (non-2xx → `ApiError(status, message)` using `{error}` with the same fallbacks as `regista/mobile/src/api.ts:104-112`; transport failure → `ApiError(0, …)`; `fieldErrors` preserved).
- 401: interceptor emits on `unauthorizedEventsProvider` (broadcast stream, avoids provider cycle); `AuthController` listens → `signOut(reason: sessionExpired)`. `/auth/login` exempt.
- 403 on organizer routes → refresh `/orgs`; if the org vanished, leave organizer mode with a snackbar.

### D2. Repositories, fakes, `API_MODE`
- `--dart-define=API_MODE=real|fake`, default `fake` for dev; release builds use `real`.
- Per feature: `XRepository` (abstract) + `RealXRepository(Dio)` + `FakeXRepository(FakeStore, FakeLatency)`. One `FakeStore` seeded from `core/fake/seed.dart`: 2 orgs (one ADMIN, one STAFF), 5 events across statuses, ~40 attendees in all statuses incl. erased, pending invitations. Latency 250–600 ms jittered; `Duration.zero` in tests. Fakes enforce server rules (capacity, `duplicate`, waitlist order, last-admin guard, sole-admin delete block).
- Provider wiring: `@Riverpod(keepAlive: true) XRepository xRepository(Ref ref) => switch (apiMode) { real => Real…, fake => Fake… }`. Tests override at the edge: `ProviderScope(overrides: [xRepositoryProvider.overrideWithValue(fake)])`.
- **Feature gating in `real` mode:** `Feature { signup, passwordReset, socialSignIn, attendeeMode, eventCrud, promoteErase, csvExport, team, offlineTokens }`. `Real*` methods for missing endpoints throw `ApiError(501, 'Not available on this server yet')`; UI entry points check `isAvailable` so a `real` build against today's backend shows no dead buttons. Enabling a feature when the backend ships = one line.

### D3. Auth state machine
```
AuthState = booting | signedOut(reason?) | signedIn(User, token, expiresAt, List<Org> orgs)
hasOrganizerAccess = orgs.isNotEmpty
```
- Boot: read token + cached user; decode `exp` via `TokenCodec`; expired/missing → `signedOut`; else `signedIn` optimistically, then `GET /mobile/orgs` (validates token, fills orgs). Swap to `GET /mobile/me` when contract #8 lands.
- Email/password: `POST /mobile/auth/login` (real today). 429 message shown verbatim.
- Google: `GoogleSignIn.instance.initialize(serverClientId: WEB_CLIENT_ID)`; `authenticate()` → `idToken` → `POST /mobile/auth/google` → same `{token, user}`. Sign-out also calls `GoogleSignIn.instance.signOut()`.
- Apple (iOS): `rawNonce` → `sha256` to `getAppleIDCredential` → `POST /mobile/auth/apple {identityToken, nonce, fullName?}`. Apple returns name/email **only on first authorization** — persist `fullName` in secure storage on receipt and always send it; backend keys on `sub`. On `400 {reason:"apple_identity_incomplete"}` show the "Settings > Apple ID > Sign-In with Apple > Thingstead > Stop using, then retry" remedy.
- Signup/verify/resend/forgot/reset: UI + repo (contract #1–5). Token links (`app.thingstead.pro/verify?token=`, `/reset?token=`) route in-app via deep links; screens also accept a pasted token.
- Expiry UX: "Session expires in N days — sign in again to extend" when < 5 days remain; proactive sign-out at `exp`.
- Sign-out wipes token, cached user, selected org, drift cache + queue (after warning if unsynced ops exist), resets mode to attendee.

### D4. Modes and routing
- `AppMode {attendee, organizer}` in prefs, default attendee. Organizer selectable only when `hasOrganizerAccess`. First login with orgs lands in organizer mode (mirrors Expo). Switch tiles on Account (attendee) and Settings (organizer).
- Two `StatefulShellRoute.indexedStack`:
  - **Attendee `/a`**: tabs `/a/events` (Find), `/a/tickets`, `/a/account`. Nested `/a/orgs/:org`, `/a/orgs/:org/events/:event`, `/a/tickets/:id`, `/a/tickets/import`.
  - **Organizer `/o`**: tabs `/o/events`, `/o/scan`, `/o/team`, `/o/settings`. Nested `/o/orgs` (picker), `/o/events/new`, `/o/events/:event`, `/o/events/:event/edit`, `/o/events/:event/attendees`, `/o/scan?event=&code=`, `/o/sync/attention`, `/o/settings/server`.
  - Auth stack `/auth/{login,signup,check-email,verify,forgot,reset}`, plus `/splash`.
- Selected org lives in state (`selectedOrgControllerProvider`, persisted slug), not the path; org switcher = app-bar button → bottom sheet listing orgs with role/plan chips (port `OrgsScreen.tsx`).
- `redirect` rules (via `RouterRefresh` listenable over auth + mode): booting → `/splash`; auth-required routes (`/a/tickets*`, `/a/account`, register action, all `/o/*`) while signedOut → `/auth/login?from=`; signedIn on `/auth/*` → `from` or mode home; `/o/*` without organizer access → `/a/events`; `/o/*` with no selected org: 1 org → auto-select, >1 → `/o/orgs`; `/o/team*` when role ≠ ADMIN → `/o/events`; feature-gated routes when `!isAvailable` → mode home.
- `/a/orgs/:org...` is public (no login) so shared links open instantly; login demanded only at "Register".

### D5. Deep links
`app_links`: `getInitialLink()` + `uriLinkStream` → pure `DeepLinkParser.parse(Uri) → DeepLinkTarget` (unit-tested; scheme-agnostic so `thingstead://thingstead.pro/acme/x` == `https://thingstead.pro/acme/x`). `DeepLinkHandler` waits for auth ≠ booting and stashes the target in `from` when login is required.

| URL | Target |
|---|---|
| `thingstead.pro/<org>` | `/a/orgs/<org>` (switch to attendee mode) |
| `thingstead.pro/<org>/<event>` | `/a/orgs/<org>/events/<event>` |
| `thingstead.pro/<org>/<event>/manage?token=` | `/a/tickets/import?…` (login required; token never logged) |
| `app.thingstead.pro/checkin?c=` | if organizer-eligible → organizer mode, `/o/scan?code=` (submits immediately); else "this is an organizer link" |
| `app.thingstead.pro/verify?token=`, `/reset?token=` | in-app verify / reset |
| `app.thingstead.pro/invite?token=` | `/o/invite?token=` (contract #33, optional) else open in browser |
| reserved first segment (`signup`, `privacy`, `app`, `home`, `api`, `www`, …) or `app.thingstead.pro/o/…` | in-app browser tab |

- Android `AndroidManifest.xml`: intent filters `android:autoVerify="true"` for `https://thingstead.pro` (all paths) and `https://app.thingstead.pro` with `pathPrefix` for `/checkin`, `/verify`, `/reset`, `/invite`; plus `<data android:scheme="thingstead"/>`.
- iOS `Runner.entitlements`: `applinks:thingstead.pro`, `applinks:app.thingstead.pro`; `Info.plist` `CFBundleURLTypes` for `thingstead`; `FlutterDeepLinkingEnabled=false`.
- **Backend follow-up (noted in contract):** host `/.well-known/assetlinks.json` (package `pro.thingstead.app`, SHA-256 of upload key **and** Play App Signing key) and `/.well-known/apple-app-site-association` on both hosts, `application/json`, no redirect. Until then the custom scheme + "Open with" chooser work. Test: `adb shell am start -W -a android.intent.action.VIEW -d "https://thingstead.pro/acme" pro.thingstead.app`.

### D6. Offline check-in queue
**Approach:** cache attendees locally; resolve scans against the cache when `checkInToken` is available (contract #23), else queue blind and resolve on sync. Cache wiped on sign-out and org switch.

Drift tables (`core/storage/db/tables.dart`):
```
cached_attendees  (org_slug, event_slug, id) PK; name, email, status, checked_in_at, erased, check_in_token (indexed, nullable), fetched_at
cached_events     (org_slug, slug) PK; title, timezone, starts_at, status, confirmed, checked_in, fetched_at
pending_checkins  id TEXT PK (uuid = idempotency key); org_slug; event_slug; kind (manual|scan); registration_id?; code?;
                  desired_checked_in?; client_at; created_at; attempts; next_attempt_at; last_error?;
                  state (pending|syncing|synced|attention); server_outcome?; server_checked_in_at?
sync_meta         (org_slug, event_slug) PK; last_synced_at; last_error?
```
- Attendee list fetches **unfiltered** (server caps at 500), upserts cache; search is local `LIKE` (same semantics as server `contains insensitive`). Pull-to-refresh refetches. Rows show a "pending" glyph when a queued op targets them.
- **Manual toggle:** optimistic flip in cache (port `AttendeesScreen.tsx:75-102`); online → `POST …/checkin`, write back; `ApiError(0)` or offline → enqueue `manual`, keep optimistic value. Multiple ops on one registration collapse to the last desired state; if equal to server-known state, drop.
- **Scan:** `checkin_code.dart` ports `extractCheckInToken`. Online → `POST /mobile/checkin` + patch cache. Offline → `OfflineResolver`: token in cache → same decision table as `performCheckIn` (`wrong_event`, `cancelled`, `waitlist`, `already` if checked in or already pending, else mark locally + enqueue `scan` → `checked_in` with "offline" tag). Token not in cache → enqueue blind → new local outcome `queued_unverified` (amber card: "Queued — will confirm when back online").
- **`SyncController`** (keepAlive `Notifier<SyncStatus>`): triggers on connectivity change, app resume, after each enqueue, 60 s timer while pending > 0. Single-flight FIFO drain by `created_at`; ops marked `syncing` in flight.
- **Conflict rules:** manual → 200 → `synced`, cache takes server value; 404 → `attention`. Scan → `checked_in`/`already` → `synced`, server `at` wins; `invalid`/`wrong_event`/`cancelled`/`waitlist` → `attention` with scanned-at time. 401 → stop; auth signs out; ops stay `pending` (queue keyed by org/event survives re-login). 403 → stop; `sync_meta.last_error = membership`. `ApiError(0)`/5xx → backoff `min(2^attempts s, 5 min)`; after 20 → `attention`.
- **UI:** `SyncBadge` on Scan tab + attendee header (pending count / spinner / "Synced 2 min ago" / red when attention > 0); `/o/sync/attention` lists items with "Open attendee" and "Dismiss".

### D7. Time
`AppTime`: `initializeTimeZones()` at boot; `formatEventDate(iso, zone)` → "Sat, 15 Aug, 6:00 PM" (port `regista/mobile/src/format.ts`); `formatEventWhen(start, end, zone)` (port `regista/lib/time.ts:107`); unknown zone → device zone. Models keep UTC `DateTime`. Event form: date+time pickers produce wall-clock components; payload `'${y}-${mm}-${dd}T${HH}:${MM}'` + IANA zone (default device zone via `flutter_timezone`); replicate `wallClockExists` DST-gap check with a `tz.TZDateTime` round-trip; `endsAt > startsAt`. `Clock` provider for tests.

### D8. Error / loading UX
`AsyncView<T>` over `AsyncValue`: skeleton on first load; error → `ErrorBanner` + Retry (`ref.invalidate`); stale data stays visible on refresh errors. `RefreshIndicator` on every list. Empty-state strings copied from the Expo screens. `ServerWakingView` when `serverWakingProvider` is true. Mutations via `AsyncValue.guard`; inline `fieldErrors`, snackbar otherwise.

---

## E. API contract for missing endpoints → `docs/API-CONTRACT.md`

Conventions (inherit from the existing 7): JSON; `Authorization: Bearer` on `/api/mobile/*`; `/api/public/*` unauthenticated read-only; errors `{error}` + optional `{fieldErrors:{field:msg}}` on 400; 401 bad token; 403 non-member / role / tenant not ACTIVE (never 404 for non-members); 404 resource; 409 conflict; 429 rate limit; ISO-8601 UTC timestamps; wall-clock inputs `YYYY-MM-DDTHH:mm` + `timezone`.
`Ticket = {id, status, name, email, checkedInAt, checkInToken, createdAt, started, org:{slug,name}, event:{slug,title,startsAt,endsAt,timezone}}`.
`EventDetail = {id, slug, title, description, startsAt, endsAt, timezone, startsAtLocal, endsAtLocal, capacity, waitlistEnabled, status, confirmed, waitlist, checkedIn, createdAt}`.

| # | Method & path | Auth | Request → Response | Errors | Backend follow-up (not this plan) |
|---|---|---|---|---|---|
| 1 | `POST /mobile/auth/signup` | none | `{email, password≥8, name}` → `{ok:true}` always | 400 fieldErrors, 429 | Attendee account **without** a Tenant; `VerificationToken.tenantId=null`; attendee variant of the verify email |
| 2 | `POST /mobile/auth/verify` | none | `{token}` → `{token, user}` (signs in) | 400 | Same raw token as `app.<root>/verify?token=` |
| 3 | `POST /mobile/auth/resend-verification` | none | `{email}` → `{ok:true}` always | 429 | Web resend is cookie-based; needs email-keyed variant |
| 4 | `POST /mobile/auth/forgot-password` | none | `{email}` → `{ok:true}` always | 429 | New `PasswordResetToken` (hashed, 1 h, single-use) + email + web `app.<root>/reset?token=` page |
| 5 | `POST /mobile/auth/reset-password` | none | `{token, password}` → `{token, user}` | 400 | Set `passwordHash`, mark verified, invalidate other reset tokens |
| 6 | `POST /mobile/auth/google` | none | `{idToken}` → `{token, user, isNewUser}` | 401, 403 email unverified, 429 | Verify JWT (`aud` = Web client id); link by lower-cased email; optional `User.googleSub` |
| 7 | `POST /mobile/auth/apple` | none | `{identityToken, authorizationCode?, nonce, fullName?}` → `{token, user, isNewUser}` | 401, 400 `{reason:"apple_identity_incomplete"}` | Verify vs Apple JWKS (`aud` = `pro.thingstead.app`); `User.appleSub String? @unique`; match `appleSub` then email |
| 8 | `GET /mobile/me` | bearer | → `{user:{id,email,name,emailVerified}, orgs:[Org]}` | 401 | Replaces boot-time `/orgs` probe |
| 9 | `PATCH /mobile/me` | bearer | `{name}` → `{user}` | 400 | — |
| 10 | `GET /public/orgs/{slug}` | none | → `{org:{slug,name}}` | 404 (missing or not ACTIVE) | — |
| 11 | `GET /public/orgs/{slug}/events` | none | → `{org, events:[{slug,title,startsAt,endsAt,timezone,capacity,remaining,isFull,waitlistEnabled}]}` PUBLISHED only | 404 | Mirrors `app/[domain]/page.tsx` |
| 12 | `GET /public/orgs/{slug}/events/{eventSlug}` | none | → `{org, event:{…+description}}` | 404 (draft/closed too) | Mirrors `app/[domain]/[eventSlug]/page.tsx` |
| 13 | `POST /mobile/orgs/{slug}/events/{eventSlug}/register` | bearer | `{name}` (email = account email) → `{outcome: confirmed\|waitlisted\|full\|duplicate\|closed, ticket?}` | 400, 429 | `Registration.userId String?` + index; reuse the `register` transaction; still sends email |
| 14 | `GET /mobile/tickets` | bearer | → `{tickets:[Ticket]}` (mine, not erased, newest first) | 401 | — |
| 15 | `GET /mobile/tickets/{id}` | bearer | → `{ticket}` | 404 | — |
| 16 | `POST /mobile/tickets/import` | bearer | `{token}` (raw manage token) → `{ticket}`, sets `userId` | 404, 403 `{reason:"email_mismatch"}` | Email must match account so a forwarded link can't attach another's ticket |
| 17 | `POST /mobile/tickets/{id}/cancel` | bearer | → `{outcome: cancelled\|already\|started}` | 404, 429 | `cancelRegistration` semantics; audit with `actorUserId` |
| 18 | `GET /mobile/orgs/{slug}/events/{eventSlug}` | member | → `{event: EventDetail}` | 403, 404 | `startsAtLocal` via `utcToZonedInput` |
| 19 | `POST /mobile/orgs/{slug}/events` | member | `{title, slug?, description?, startsAt, endsAt?, timezone, capacity?, waitlistEnabled}` → `201 {event}` (DRAFT) | 400 fieldErrors, 403 | Reuse `eventInputSchema` + `uniqueEventSlug` |
| 20 | `PATCH /mobile/orgs/{slug}/events/{eventSlug}` | member | same → `{event}` | 400, 404 | Runs `promoteFromWaitlist` like the web |
| 21 | `POST …/events/{eventSlug}/status` | member | `{status}` → `{event:{slug,status}}` | 400, 404 | — |
| 22 | `DELETE …/events/{eventSlug}` | ADMIN | → `{ok:true, registrationsDeleted}` | 403 (STAFF), 404 | Audit `DELETE_EVENT` first |
| 23 | **Change** `GET …/attendees` | member | add `checkInToken: string\|null` per attendee; add `waitlist` count to `event` | — | Enables offline scan verification. Later: `?cursor=` for >500 |
| 24 | **Change** `POST …/attendees/{id}/checkin` | member | `{checkedIn, at?: ISO}` | 400 if `at` in future | Use `at` (≤ now, ≥ createdAt) for offline replays |
| 25 | `POST …/attendees/{id}/promote` | member | → `{outcome: promoted\|full\|gone}` | 403, 404 | `promoteRegistration` |
| 26 | `POST …/attendees/{id}/erase` | member | → `{ok:true}` idempotent | 404 | `eraseRegistration` |
| 27 | `GET …/attendees/export` | member | → `text/csv`, `Content-Disposition: attachment`, `no-store` | 403, 404 | Same columns/escaping as `lib/csv.ts`; audit `EXPORT_ATTENDEES` |
| 28 | `GET /mobile/orgs/{slug}/team` | ADMIN | → `{members:[{id,userId,name,email,role,isSelf,joinedAt}], invitations:[{id,email,role,expiresAt,expired}], adminCount}` | 403 | Mirrors `team/page.tsx` |
| 29 | `POST …/team/invitations` | ADMIN | `{email, role}` → `201 {invitation}` or `200 {alreadyMember:true}` | 400, 429, 502 mail-failed | `inviteMember` |
| 30 | `DELETE …/team/invitations/{id}` | ADMIN | → `{ok:true}` | 404 | — |
| 31 | `PATCH …/team/members/{membershipId}` | ADMIN | `{role}` → `{member}` | 404, 409 `last_admin` | `withLastAdminGuard` |
| 32 | `DELETE …/team/members/{membershipId}` | ADMIN | → `{ok:true}` (self = leave) | 404, 409 `last_admin` | — |
| 33 | `POST /mobile/invitations/accept` (optional) | bearer | `{token}` → `{org:{slug,name,role}}` | 400, 403 email_mismatch | `redeemInvitation` |

Also in the doc: token format/TTL, `X-Client` header, the `fake.`-token prefix convention (client-only), and the assetlinks/AASA hosting requirements from D5.

---

## F. Screen inventory

**Auth:** `/splash` (boot) · `/auth/login` (email+password, Google, Apple-on-iOS, links to signup/forgot, "Server: host · Change" footer — port `LoginScreen.tsx`) · `/auth/signup` · `/auth/check-email` (resend, "I have a token") · `/auth/verify?token=` (auto-submit) · `/auth/forgot` · `/auth/reset?token=`.

**Attendee shell (Events · Tickets · Account):**
- `/a/events` Find: org-code field (slug validation), "Scan a link QR", recent orgs.
- `/a/orgs/:org` published events with when/remaining chips; public; pull-to-refresh.
- `/a/orgs/:org/events/:event` title, when, places left / Full, description, Register CTA (login-gated; "Join waitlist" when full + waitlist on; disabled "Full" otherwise — mirrors `register-form.tsx`). Register bottom sheet → outcome card → `/a/tickets/:id`.
- `/a/tickets` grouped upcoming/past with status chip.
- `/a/tickets/:id` big QR (`qr_flutter`, encodes `$APP_ORIGIN/checkin?c=<token>`) only when CONFIRMED; details; "Cancel my place" (hidden when started/cancelled, like the manage page).
- `/a/tickets/import` from manage-link deep link; handles `email_mismatch`.
- `/a/account` name/email, edit name, session expiry, "Switch to organizer" (when eligible), server address, sign out, delete account (same confirm copy as `SettingsScreen.tsx`, 409 sole-admin message verbatim).

**Organizer shell (Events · Scan · Team · Settings; org switcher in app bar):**
- `/o/orgs` org picker (>1 org).
- `/o/events` cards: status chip, date in event zone, Confirmed x/cap, Checked in, "Scan check-in"; FAB "New event" (gated). Refresh on return.
- `/o/events/:event` counts, public link (copy/share), Publish/Close/Reopen, Edit, Attendees, Export CSV → share sheet, Delete (ADMIN, confirm with count).
- `/o/events/new`, `/o/events/:event/edit` title, slug (auto-slugify, editable), description, start/end pickers, searchable timezone picker, capacity, waitlist switch; inline field errors.
- `/o/events/:event/attendees` local search, rows with status chip / "In at 6:04 PM" / optimistic+offline toggle, actions sheet (Promote for WAITLIST, Erase w/ confirm, Copy email); header: sync badge + Scan.
- `/o/scan?event=&code=` full-screen `mobile_scanner`, gold reticle, in-flight lock, outcome card (6 outcomes + `queued_unverified` + offline tag), "Scan next", manual entry sheet, torch, permission rationale (copy `ScannerScreen.tsx:86-101`, "Open settings" when permanently denied). Tab entry without `event` asks which event first.
- `/o/sync/attention` items with outcome, scanned-at, "Open attendee", "Dismiss".
- `/o/team` (ADMIN) members with role chip / "(you)" / Make admin|staff / Remove|Leave (last-admin disabled with explanation), pending invites + Revoke, Invite sheet (email + role).
- `/o/settings` signed-in card, org + role + plan, "Switch to attendee mode", Server address (`/o/settings/server` — port `SettingsScreen.tsx` incl. "Will save as:" preview + reset), sync status, sign out (warns on unsynced ops), delete account, version + API-mode badge (non-release).

---

## G. Phased delivery

Every phase ends with: `dart run build_runner build -d`, `flutter analyze` clean, `dart run custom_lint` clean, `flutter test` green, app running on the emulator via `flutter run --dart-define=API_MODE=<mode>`, and a git commit.

**Phase 0 — Toolchain, scaffold, theme, router skeleton, fake mode**
Sections A + B. Files: `main.dart`, `app.dart`, `core/config/*`, `core/theme/*` (tokens from `regista/mobile/src/theme.ts`), `core/router/*` with both shells + placeholder screens, `core/widgets/*`, `core/fake/*`, `core/network/{api_client,api_error}.dart`, `core/time/app_time.dart`, `docs/API-CONTRACT.md`, `docs/ARCHITECTURE.md`, `README.md`.
Verify: `flutter run --dart-define=API_MODE=fake` shows the attendee shell (3 tabs) and can toggle to the organizer shell; tests `app_time_test` (port cases from `regista/tests/time.test.mjs`), `deep_link_parser_test`, `api_error_test`.

**Phase 1 — Auth + shells + settings**
Files: `features/auth/*`, `features/shell/*`, `features/organizer/settings/*`, `features/attendee/account/*`, `core/storage/*`, remaining interceptors, `core/router/guards.dart`.
Real: login, `/orgs` probe, delete account. Fake: signup/verify/resend/forgot/reset, Google/Apple (native SDK calls wired behind `Feature.socialSignIn`; testable on device once client IDs exist).
Verify (real mode): login against `thingstead.onrender.com`; cold-start view on a sleeping server; sign out; server-URL change signs out; corrupted stored token → bounced to login; delete-account 409 message. Tests: `token_codec_test`, `auth_controller_test`, widget `login_screen_test`.

**Phase 2 — Organizer parity with Expo (7 real endpoints)**
Files: `features/organizer/{orgs,events,attendees,scanner,checkin}/*` (real + fake repos, controllers, screens; `ScanSource` abstraction; `checkin_code.dart`). Events list, attendee list with optimistic toggle (online-only this phase), scanner with outcomes, org switcher/picker.
Verify: every Expo flow on the emulator against the real server; scanner via emulator virtual-scene camera or manual entry. Tests: `checkin_code_test`, `attendees_controller_test` (optimistic rollback), widget `events_screen_test`, `scanner_screen_test` with `FakeScanSource`.

**Phase 3 — Offline queue**
Files: `core/storage/db/*`, `features/organizer/checkin/data/{sync_worker,offline_resolver}.dart`, `application/sync_controller.dart`, `presentation/{needs_attention_screen,sync_badge}.dart`, `core/connectivity/*`; attendees controller becomes cache-backed; fake attendees include `checkInToken`; real repo tolerates its absence (blind queueing).
Verify: `adb shell cmd connectivity airplane-mode enable` → toggle + scan cached tokens → badge shows pending → disable airplane → drains; `already` conflicts land as synced; invalid code lands in attention. Tests: `offline_resolver_test`, `sync_worker_test` (in-memory drift, scripted outcomes / 0 / 401), `integration_test/offline_queue_test.dart`.

**Phase 4 — Organizer full (fake)**
Files: event detail/form screens, `event_form_controller`, `event_input.dart` validation (port `eventInputSchema` + DST check), `export_controller` + `core/util/csv.dart` (same formula-escaping as `lib/csv.ts`), `features/organizer/team/*`, feature gating in UI.
Verify (fake): create → publish → attendees → promote → erase → export via share sheet → close → delete; team invite/revoke/role/remove with last-admin rule. Tests: `event_input_test`, `csv_test` (port `regista/tests/csv.test.mjs`), `team_controller_test`, widget `event_form_screen_test`.

**Phase 5 — Attendee mode (fake) + deep links**
Files: `features/attendee/{orgs,registration,tickets}/*`, `core/router/deep_link_handler.dart`, Android intent filters, iOS entitlements/Info.plist, `link_scanner_sheet.dart`.
Verify: `adb shell am start -W -a android.intent.action.VIEW -d "https://thingstead.pro/acme/summer-meetup" pro.thingstead.app` opens event detail; register → ticket with QR; scan that QR with the organizer scanner in fake mode → `checked_in`; manage-link import; cancel. Tests: `register_controller_test` (all 5 outcomes), `tickets_controller_test`, `import_ticket_test`, widget `ticket_detail_screen_test` (QR only when CONFIRMED).

**Phase 6 — Native polish + release**
Icons/splash (`dart run flutter_launcher_icons; dart run flutter_native_splash:create`); `NSCameraUsageDescription` (copy the Expo string); `ITSAppUsesNonExemptEncryption=false`; Android `CAMERA` + `uses-feature required=false`; `allowBackup=false`; Sign in with Apple capability; Google client IDs (`GIDClientID`, reversed URL scheme); Android upload keystore:
```powershell
keytool -genkey -v -keystore $env:USERPROFILE\thingstead-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
`android/key.properties` (gitignored) + `signingConfigs.release`; `flutter build appbundle --dart-define=API_MODE=real`. Mac: `flutter build ipa` → Xcode archive → TestFlight. Store copy/screenshots per `regista/docs/MOBILE-RELEASE.md`.
Verify: release build installs and signs in; `adb shell pm get-app-links pro.thingstead.app` once the well-known files are hosted.

---

## H. Testing strategy

- **Unit** (`flutter test`): fake repos (rule enforcement), real repos against a mocked `HttpClientAdapter` (mocktail), `ApiError` mapping, `TokenCodec`, `DeepLinkParser`, `AppTime` (DST gap, unknown-zone fallback), `EventInput`, CSV escaping, `checkin_code`, `OfflineResolver` decision table, `SyncWorker` replay/conflict/backoff (drift `NativeDatabase.memory()` + `TestClock`).
- **Widget:** `pumpApp(child, overrides)` helper wraps `ProviderScope` + `MaterialApp.router`; fakes with zero latency. Cover login, events list, attendees (search, optimistic + rollback, pending glyph), scanner (every outcome card, "Scan next" resets lock), ticket detail, event form (field errors), team (last-admin disabled).
- **Scanner without a camera:** `ScanSource` = abstract `Stream<String> codes` + `start/stop`; `CameraScanSource` wraps `MobileScannerController`; `ManualScanSource` fed by the manual-entry sheet; tests inject `FakeScanSource`. Emulator: Extended Controls > Camera > virtual scene with a QR PNG, or manual entry.
- **Integration** (`flutter test integration_test/ -d emulator-5554`): offline queue, organizer flow (fake), attendee flow (fake).
- Golden tests optional (`ScanResultCard`, `EventCard`).

---

## I. Risks / open items

- **Render free tier sleeps** (`regista/render.yaml`): `ColdStartInterceptor` + waking UI mitigate; still needs an always-on instance before store review (`docs/MOBILE-RELEASE.md`).
- **30-day token, no refresh:** expiry surfaced; proactive sign-out; queue survives re-login. A `POST /mobile/auth/refresh` can be added later with one repo method.
- **Sign in with Apple:** App ID capability required; test on a real device (simulator is flaky). Android deferred (needs backend web callback + Services ID).
- **Google Sign-In:** three OAuth clients (Web for backend audience, Android w/ package + SHA-1 of debug keystore `%USERPROFILE%\.android\debug.keystore` and upload/Play key, iOS w/ bundle id). Missing SHA-1 fails silently as `DEVELOPER_ERROR`.
- **`flutter_secure_storage` on Android:** keys can vanish across backup/restore; `allowBackup=false`; missing token = signed out, never a crash.
- **`mobile_scanner` on emulator:** no real camera; use virtual scene or manual entry; needs `google_apis` image for MLKit.
- **drift migrations:** treat cache tables as disposable (drop/recreate on version bump); migrate only `pending_checkins`.
- **Riverpod 3 auto-retry** could hammer 401/403 — configure `retry` globally (D1) and test it.
- **500-attendee cap + missing `checkInToken`/`at`** reduce offline fidelity until the contract lands; app degrades to blind queueing and server timestamps.
- **App Links / Universal Links** need the well-known files + Play App Signing SHA-256; until then links open via chooser or `thingstead://`.
- **Attendee accounts without a tenant** break the web's "every user has a membership" assumption in the verify-email copy (backend follow-up in contract #1). `deleteUserAccount` and `/orgs` already tolerate zero memberships.
- Package majors (go_router, mobile_scanner, google_sign_in 7, flutter_secure_storage 10, freezed 3, riverpod 3) — confirm current versions on pub.dev at scaffold time and read changelogs before wiring.

## Critical files (first to write, most depended-upon)

- `docs/API-CONTRACT.md` — the spec every fake and real repo implements 1:1.
- `lib/core/router/app_router.dart` — two shells, guards, deep-link translation.
- `lib/core/network/api_client.dart` — Dio + interceptors + `ApiError`.
- `lib/features/auth/application/auth_controller.dart` — auth state machine, `hasOrganizerAccess`, social orchestration, sign-out cleanup.
- `lib/features/organizer/checkin/data/sync_worker.dart` + `core/storage/db/tables.dart` + `offline_resolver.dart` — offline queue.

Reference files in the web repo the port mirrors: `regista/mobile/src/api.ts`, `regista/mobile/src/screens/{ScannerScreen,AttendeesScreen,SettingsScreen,LoginScreen}.tsx`, `regista/lib/{checkin,events,time,urls,slug,csv}.ts`.
