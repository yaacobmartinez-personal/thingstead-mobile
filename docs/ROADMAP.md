# Roadmap

## v1 — in progress: ship to the stores

Code is complete on `main` (app) and `master` (regista). What remains is
accounts and configuration, in `docs/RELEASE.md` and `docs/STORE-LISTING.md`.

## v1.1 — parked 2026-09-20

Estimates and scope from the comparison with Eventbrite's event form.

1. **Event location** (~1.5 days, both repos). `Event.location String?`
   (+ optional `locationUrl`), shown on the public page, the ticket, the
   organizer card and the confirmation email; "Open in Maps" in the app.
   Ship alone, first.
2. **Custom registration questions** (~5–6 days, both repos).
   `Event.questions Json?` (array of `{id, label, type: text|choice|checkbox,
   required, options?}`); answers in the existing `Registration.customFields`
   keyed by question id. Builder on web and app, dynamic register form on
   both, answers in attendee lists and one CSV column per question.
   v1 scope guard: three types, no conditionals, questions freeze once the
   event has registrations.
3. Smaller: a short **summary** line separate from the description;
   **scheduled** registration open/close instead of manual publish/close;
   a second organization from Settings for existing organizers.
4. Later: **cover images** (needs upload storage — Render has no disk).

Each is schema-first: regista merged and deployed before the app PR, behind
a `Feature` flag as before.
