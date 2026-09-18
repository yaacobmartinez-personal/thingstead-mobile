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
the only change needed when an endpoint lands.

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
