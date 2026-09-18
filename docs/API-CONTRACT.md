# Thingstead mobile API contract

The Flutter app is built against this contract. Section 1 documents what the
backend (`regista`, Next.js) serves today; section 2 specifies every endpoint
the app needs that does **not** exist yet. Each fake repository in the app
implements section 2 exactly, so the backend can be built 1:1 against it and
the app switched from `API_MODE=fake` to `real` per feature (see
`lib/core/config/feature_availability.dart`).

Status: **draft, 2026-09-18**. Anything in section 2 may change until the
backend implements it; when it does, this file is the source of truth for both.

---

## 0. Conventions

Inherited from the seven existing endpoints (`regista/app/api/mobile/**`,
`regista/lib/mobile-auth.ts`):

- Base path: `<server>/api`. `/api/mobile/*` needs `Authorization: Bearer <token>`.
  `/api/public/*` is unauthenticated and read-only.
- Bodies are JSON. Successful responses are `200` unless noted (`201` on create).
- **Errors** are `{ "error": string }`. A `400` may add
  `{ "fieldErrors": { "<field>": string } }` (same shape as the web server-action
  states). Some endpoints add a machine-readable `"reason"`.
- **Status codes:** `400` validation · `401` missing/invalid/expired token ·
  `403` not a member / insufficient role / tenant not ACTIVE (**never** `404` for
  a non-member, so tenants are not enumerable) · `404` resource missing ·
  `409` state conflict · `429` rate limited · `501` not implemented (used by the
  app's real client for endpoints in section 2 that have not shipped).
- **Timestamps** are ISO-8601 UTC strings. Wall-clock inputs (event times) are
  `YYYY-MM-DDTHH:mm` interpreted in the event's IANA `timezone`, exactly like the
  web form (`regista/lib/time.ts`).
- **Token**: `base64url(JSON{sub, exp}) + "." + base64url(HMAC-SHA256(body, AUTH_SECRET))`,
  30-day TTL, identity only — membership and role are resolved from the database
  on every request. There is no refresh endpoint; on `401` the app signs out.
  The app may read `exp` from the payload but never trusts it for authorization.
- The app sends `X-Client: thingstead-flutter/<version> (<platform>)` on every
  request for server-side diagnostics.
- Rate limits mirror the web actions (login 10/15 min per IP; registration
  20/h per IP; resend/forgot 3/15 min per email).

### Shared shapes

```jsonc
Org        = { slug, name, role: "ADMIN"|"STAFF", plan: "FREE"|"PREMIUM"|"CUSTOM" }
User       = { id, email, name: string|null }
Ticket     = { id, status: "CONFIRMED"|"WAITLIST"|"CANCELLED", name, email,
               checkedInAt: ISO|null, checkInToken: string|null, createdAt: ISO,
               started: bool,
               org: { slug, name },
               event: { slug, title, startsAt: ISO, endsAt: ISO|null, timezone } }
EventDetail = { id, slug, title, description: string|null,
                startsAt: ISO, endsAt: ISO|null, timezone,
                startsAtLocal: "YYYY-MM-DDTHH:mm", endsAtLocal: "YYYY-MM-DDTHH:mm"|null,
                capacity: int|null, waitlistEnabled: bool,
                status: "DRAFT"|"PUBLISHED"|"CLOSED",
                confirmed: int, waitlist: int, checkedIn: int, createdAt: ISO }
```

---

## 1. Existing endpoints (real today)

| # | Method & path | Auth | Request → Response | Errors |
|---|---|---|---|---|
| E1 | `POST /mobile/auth/login` | none | `{email, password}` → `{token, user: User}` | 400, 401 "Wrong email or password." (same for unverified), 429 |
| E2 | `GET /mobile/orgs` | bearer | → `{orgs: [Org]}` (ACTIVE tenants only, ordered by membership date) | 401 |
| E3 | `GET /mobile/orgs/{slug}/events` | member | → `{org: {slug, name}, events: [{slug, title, startsAt, endsAt, timezone, capacity, status, confirmed, checkedIn}]}` ordered by `startsAt` | 401, 403 |
| E4 | `GET /mobile/orgs/{slug}/events/{eventSlug}/attendees?q=` | member | `q` = case-insensitive contains on name or email → `{event: {title, timezone, capacity}, attendees: [{id, name, email, status, checkedInAt, erased}]}` max 500, `createdAt` asc; name/email `null` when erased | 401, 403, 404 |
| E5 | `POST /mobile/orgs/{slug}/events/{eventSlug}/attendees/{id}/checkin` | member | `{checkedIn: bool}` → `{checkedInAt: ISO|null}` (audit-logged; matches on `(id, tenantId)` only) | 400, 401, 403, 404 |
| E6 | `POST /mobile/checkin` | member (slug in body) | `{slug, code, eventSlug?}` — `code` is the raw token or the full `…/checkin?c=` URL → `{outcome: "checked_in"|"already"|"cancelled"|"waitlist"|"wrong_event"|"invalid", name, at: ISO|null, eventTitle}` (always 200 for business outcomes) | 400, 401, 403 |
| E7 | `DELETE /mobile/account` | bearer | → `{ok: true}` | 401, 409 `{error, reason: "sole_admin", blocked: [{tenantSlug, tenantName}]}` |

---

## 2. Endpoints the app needs (to be built)

"Backend follow-up" notes what the Next.js side must add; none of it is done by
the app. Item numbers are referenced from `lib/core/config/feature_availability.dart`.

### 2.1 Accounts and sign-in — `Feature.signup`, `passwordReset`, `socialSignIn`

| # | Method & path | Auth | Request → Response | Errors | Backend follow-up |
|---|---|---|---|---|---|
| 1 | `POST /mobile/auth/signup` | none | `{email, password (≥8), name}` → `{ok: true}` **always** (no account enumeration) | 400 fieldErrors, 429 | Creates a `User` **without** a Tenant (new concept: today web signup always creates one). Reuse `VerificationToken` with `tenantId = null`. An existing *unverified* user is claimable, same rule as web. Needs an attendee variant of the verification email (the current copy says "activate <organization>"). |
| 2 | `POST /mobile/auth/verify` | none | `{token}` → `{token, user}` (signs the user in) | 400 invalid / expired / used | Same raw token as `app.<root>/verify?token=`. When `tenantId` is null only set `emailVerified`. |
| 3 | `POST /mobile/auth/resend-verification` | none | `{email}` → `{ok: true}` always | 429 | Web resend is cookie-keyed (`signup/actions.tsx`); needs an email-keyed variant. |
| 4 | `POST /mobile/auth/forgot-password` | none | `{email}` → `{ok: true}` always | 429 | New `PasswordResetToken` (hashed, 1 h TTL, single-use) + email template + a web page at `app.<root>/reset?token=` for users without the app. **The web has no reset flow today.** |
| 5 | `POST /mobile/auth/reset-password` | none | `{token, password}` → `{token, user}` | 400 invalid / expired | Sets `passwordHash`, marks `emailVerified` if null, invalidates other reset tokens for the user. |
| 6 | `POST /mobile/auth/google` | none | `{idToken}` → `{token, user, isNewUser: bool}` | 401 bad token, 403 Google reports `email_verified=false`, 429 | Verify the JWT against Google (`aud` = the **Web** OAuth client id, `iss` google). Link by lower-cased email; create the user with `emailVerified = now`. Optional `User.googleSub`. |
| 7 | `POST /mobile/auth/apple` | none | `{identityToken, authorizationCode?, nonce, fullName?: {givenName, familyName}}` → `{token, user, isNewUser}` | 401 bad token / nonce mismatch, 400 `{reason: "apple_identity_incomplete"}` | Verify against Apple's JWKS (`aud` = `pro.thingstead.app`; also the Services ID if Android support is added later). Add `User.appleSub String? @unique`. Match by `appleSub` first, then email. Apple sends name/email **only on the first authorization**; the app persists and resends `fullName`, but if the `sub` is unknown and no email arrives, return the 400 so the app can show the "Stop using Apple ID → retry" remedy. Private-relay emails are fine. |
| 8 | `GET /mobile/me` | bearer | → `{user: {id, email, name, emailVerified: bool}, orgs: [Org]}` | 401 | Replaces the app's boot-time `GET /mobile/orgs` probe with one call. |
| 9 | `PATCH /mobile/me` | bearer | `{name}` → `{user}` | 400 | — |

### 2.2 Attendee: public reads — `Feature.attendeeMode`

| # | Method & path | Auth | Request → Response | Errors | Backend follow-up |
|---|---|---|---|---|---|
| 10 | `GET /public/orgs/{slug}` | none | → `{org: {slug, name}}` | 404 (missing **or** not ACTIVE) | — |
| 11 | `GET /public/orgs/{slug}/events` | none | → `{org, events: [{slug, title, startsAt, endsAt, timezone, capacity, remaining: int|null, isFull: bool, waitlistEnabled}]}` PUBLISHED only, `startsAt` asc | 404 | Mirrors `app/[domain]/page.tsx`. `remaining = capacity - confirmed` (null when uncapped). |
| 12 | `GET /public/orgs/{slug}/events/{eventSlug}` | none | → `{org, event: {…as above, description}}` | 404 (also for DRAFT/CLOSED) | Mirrors `app/[domain]/[eventSlug]/page.tsx`. |

### 2.3 Attendee: registration and tickets — `Feature.attendeeMode`

| # | Method & path | Auth | Request → Response | Errors | Backend follow-up |
|---|---|---|---|---|---|
| 13 | `POST /mobile/orgs/{slug}/events/{eventSlug}/register` | bearer (any user) | `{name}` — email is the account's verified email → `{outcome: "confirmed"|"waitlisted"|"full"|"duplicate"|"closed", ticket?: Ticket}` (`ticket` present for confirmed/waitlisted/duplicate) | 400 fieldErrors, 404 event not public, 429 (20/h) | Add `Registration.userId String?` + `@@index([userId])`, set on create and on re-registration after cancel. Reuse the `register` transaction (`app/[domain]/[eventSlug]/actions.tsx`) including the row lock and waitlist logic. Still sends the confirmation email. |
| 14 | `GET /mobile/tickets` | bearer | → `{tickets: [Ticket]}` — registrations where `userId = me`, excluding erased, newest first | 401 | — |
| 15 | `GET /mobile/tickets/{id}` | bearer | → `{ticket: Ticket}` | 404 (not mine or erased) | — |
| 16 | `POST /mobile/tickets/import` | bearer | `{token}` (raw manage token from the emailed link) → `{ticket}` and sets `userId = me` | 404 invalid/erased, 403 `{reason: "email_mismatch"}` | Uses `inspectRegistration` (`lib/registrations.ts`). The registration's email must equal the account's email so a forwarded link cannot attach someone else's ticket. |
| 17 | `POST /mobile/tickets/{id}/cancel` | bearer | → `{outcome: "cancelled"|"already"|"started"}` | 404, 429 | `cancelRegistration` semantics (no cancel once the event has started); audit `CANCEL_REGISTRATION` with `actorUserId = me`. |

### 2.4 Organizer: events — `Feature.eventCrud`

| # | Method & path | Auth | Request → Response | Errors | Backend follow-up |
|---|---|---|---|---|---|
| 18 | `GET /mobile/orgs/{slug}/events/{eventSlug}` | member | → `{event: EventDetail}` | 403, 404 | `startsAtLocal`/`endsAtLocal` via `utcToZonedInput`. |
| 19 | `POST /mobile/orgs/{slug}/events` | member | `{title, slug?, description?, startsAt: wall-clock, endsAt?: wall-clock, timezone, capacity?: int|null, waitlistEnabled: bool}` → `201 {event: EventDetail}` (status DRAFT) | 400 fieldErrors (same messages as `eventInputSchema`), 403 | Reuse `eventInputSchema` + `uniqueEventSlug` from `lib/events.ts`. |
| 20 | `PATCH /mobile/orgs/{slug}/events/{eventSlug}` | member | same body → `{event}` (slug may change) | 400 fieldErrors incl. the capacity floor, 404 | Runs `promoteFromWaitlist` when capacity rises, like the web. |
| 21 | `POST /mobile/orgs/{slug}/events/{eventSlug}/status` | member | `{status: "DRAFT"|"PUBLISHED"|"CLOSED"}` → `{event: {slug, status}}` | 400, 404 | — |
| 22 | `DELETE /mobile/orgs/{slug}/events/{eventSlug}` | **ADMIN** | → `{ok: true, registrationsDeleted: int}` | 403 (STAFF), 404 | Audit `DELETE_EVENT` before the cascade, as the web does. |

### 2.5 Organizer: attendees — `Feature.promoteErase`, `csvExport`, `offlineTokens`

| # | Method & path | Auth | Request → Response | Errors | Backend follow-up |
|---|---|---|---|---|---|
| 23 | **Change** E4 `GET …/attendees` | member | add `checkInToken: string|null` to each attendee (null when erased); add `waitlist: int` to `event` | — | Enables offline scan resolution: the app matches a scanned token against its cached list. The token is not a credential (schema comment) and members can already check anyone in, so this adds no privilege. Later: `?cursor=` / `?since=` for events over 500 registrations. |
| 24 | **Change** E5 `POST …/attendees/{id}/checkin` | member | `{checkedIn: bool, at?: ISO}` → unchanged | 400 if `at` is in the future | `at` is the real door time for offline replays; clamp to `[createdAt, now]`. Audit unchanged. |
| 25 | `POST …/attendees/{id}/promote` | member | → `{outcome: "promoted"|"full"|"gone"}` | 403, 404 | `promoteRegistration` transaction (`attendees/actions.ts`). |
| 26 | `POST …/attendees/{id}/erase` | member | → `{ok: true}` (idempotent) | 404 | `eraseRegistration` (`attendees/actions.ts`): anonymize, clear tokens, audit. |
| 27 | `GET …/attendees/export` | member | → `text/csv; charset=utf-8`, `Content-Disposition: attachment; filename="<event-slug>-attendees.csv"`, `Cache-Control: no-store` | 403, 404 | Same columns and formula-escaping as `attendees/export/route.ts` + `lib/csv.ts`; audit `EXPORT_ATTENDEES`. |

### 2.6 Organizer: team — `Feature.team` (all ADMIN)

| # | Method & path | Request → Response | Errors | Backend follow-up |
|---|---|---|---|---|
| 28 | `GET /mobile/orgs/{slug}/team` | → `{members: [{id, userId, name, email, role, isSelf, joinedAt}], invitations: [{id, email, role, expiresAt, expired: bool}], adminCount: int}` | 403 | Mirrors `team/page.tsx`. |
| 29 | `POST /mobile/orgs/{slug}/team/invitations` | `{email, role}` → `201 {invitation}` or `200 {alreadyMember: true}` | 400 fieldErrors, 429, 502 `{error}` when created but the email failed | `inviteMember` (`team/actions.tsx`). |
| 30 | `DELETE /mobile/orgs/{slug}/team/invitations/{id}` | → `{ok: true}` | 404 | — |
| 31 | `PATCH /mobile/orgs/{slug}/team/members/{membershipId}` | `{role}` → `{member}` | 404, 409 `{reason: "last_admin"}` | `withLastAdminGuard`. |
| 32 | `DELETE /mobile/orgs/{slug}/team/members/{membershipId}` | → `{ok: true}` (self = leave) | 404, 409 `{reason: "last_admin"}` | — |
| 33 | `POST /mobile/invitations/accept` *(optional)* | bearer: `{token}` → `{org: {slug, name, role}}` | 400 invalid, 403 `{reason: "email_mismatch"}` | `redeemInvitation`; lets `app.<root>/invite?token=` open in-app. Until then the app opens the link in the browser. |

---

## 3. Deep-link hosting (backend follow-up, no app change)

For Android App Links and iOS Universal Links to open the app directly, the
web must serve, on **both** `thingstead.pro` and `app.thingstead.pro`, with
`Content-Type: application/json` and no redirect:

- `/.well-known/assetlinks.json` — package `pro.thingstead.app`, the SHA-256 of
  the **upload** key *and* of the **Play App Signing** key.
- `/.well-known/apple-app-site-association` — `<TEAMID>.pro.thingstead.app`;
  on the apex include everything except `/signup*`, `/privacy*`, `/app*`; on
  `app.` include only `/checkin`, `/verify`, `/reset`, `/invite`.

Until these exist the custom scheme `thingstead://` and the OS "Open with"
chooser still work.

---

## 4. Client-only conventions

- `API_MODE=fake` signs users in with tokens prefixed `fake.`; these are never
  sent to a real server.
- The app treats `501` from any section-2 endpoint as "not shipped yet" and
  hides the feature; it never retries a 501.
