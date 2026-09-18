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

## Offline check-in (Phase 3)

Attendee lists are cached in drift; scans and manual toggles are queued in
`pending_checkins` when offline and replayed FIFO by a sync worker with
explicit conflict rules. See PLAN.md §D6.

## Time

All instants are UTC. Rendering uses the event's IANA zone via
`lib/core/time/app_time.dart`, which ports `regista/lib/time.ts` (including the
DST-gap check for the event form).
