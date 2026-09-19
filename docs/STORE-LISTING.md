# Store listing

Copy and assets for Google Play and the App Store. Screenshots are in
`store/screenshots/` (captured from `API_MODE=fake`, which has a full demo
organization — regenerate with the recipe at the bottom).

## Names

| Field | Value | Limit |
|---|---|---|
| App name | Thingstead | 30 |
| Play short description | Free event registration and QR check-in, in your pocket. | 80 |
| App Store subtitle | Events, tickets, and the door | 30 |
| Category | Events (Play) / Productivity or Business (App Store) | |
| Content rating | Everyone / 4+ | |

## Full description (Play: 4000 chars · App Store "Description": 4000)

Thingstead is the app for community events — the ones you go to, and the
ones you run.

**Going to something?**
Open an organization's link or code and see what's coming up. Register in a
tap. Your ticket lives in the app with its QR code, ready at the door, even
with no signal. Add the event to your calendar, share the page, and cancel
your place if plans change.

**Running the door?**
Switch to organizer mode and everything from the Thingstead dashboard is on
your phone:

- Scan tickets with the camera and see the result instantly: checked in,
  already in, wrong event, waitlisted.
- Check people in by hand from the attendee list, search by name or email.
- Keep going when the Wi‑Fi doesn't. Check-ins queue on the phone and sync
  when you're back online — with the time each person actually arrived, not
  the time the signal came back.
- Create and publish events, cap places, open a waitlist, promote from it.
- Export the attendee list as CSV, invite teammates, hand the scanner to
  staff.

**One account, both sides.** Sign in with email, or continue with Google or
Apple. If you're already an organizer on thingstead.pro, your organizations
are here. If you're not, set one up from the app in a minute.

Thingstead is free for organizations of any size. Registrations are free
for attendees. No ads, no tracking.

## Keywords (App Store, 100 chars)

events,tickets,QR,check-in,registration,organizer,meetup,community,attendee,door

## What's new (first release)

First release. Attendee tickets with QR codes, organizer check-in with
offline support, event management, and team invites.

## Promotional text (App Store, 170 chars)

Register for community events, keep your tickets, and run the door — scan,
check in, and sync later, even with no signal.

## Data safety (Play) / App privacy (App Store)

What the app collects and why, from `regista/docs/DATA-RETENTION.md`:

| Data | Collected | Shared | Purpose | Optional |
|---|---|---|---|---|
| Name, email | Yes | No | Account, tickets, attendee lists the organizer sees | Required to register |
| Photos/camera | Camera access only, no images stored | No | Scanning QR codes | Only in organizer mode |
| Device IDs / advertising ID | No | No | — | — |
| Location | No | No | — | — |
| Crash logs / analytics | No | No | — | — |

- Data is encrypted in transit (HTTPS only).
- Users can request deletion in-app: Account → Delete account. This
  anonymizes the account and removes it from every organization.
- Organizers see the name and email of people who register for *their*
  events, as on the web dashboard.
- Third parties: none beyond the hosting provider; sign-in tokens from
  Google/Apple are verified and not stored.

**Privacy policy URL:** ⚠️ the web only serves a per-organization policy
(`thingstead.pro/<org>/privacy`); both stores need one URL for the app
itself. Backend follow-up: serve `thingstead.pro/privacy` (apex, reserved
segment already) with the platform-level policy before submitting.

## Screenshots

Phone, 1080 × 2400, PNG. Play: 2–8; App Store: up to 10 per device size
(6.7" required; 6.5" and 5.5" optional, Apple scales). Order:

| # | File | Caption (Play "screenshot text", optional) |
|---|---|---|
| 1 | `04-event.png` | Register in a tap — or join the waitlist |
| 2 | `06-ticket.png` | Your ticket, with its QR code, ready at the door |
| 3 | `03-org-events.png` | Every event an organization is running |
| 4 | `07-org-events.png` | Organizer mode: your events and how the door is going |
| 5 | `09-attendees.png` | Check people in by hand, search by name |
| 6 | `10-scan.png` | Scan tickets — works offline, syncs later |
| 7 | `05-tickets.png` | All your tickets in one place |
| 8 | `02-find.png` | Find an organization by link or code |

`10-scan.png` shows the emulator's test-pattern camera feed; re-capture on
a real phone before publishing, or composite the overlay onto a photo.

Feature graphic (Play, 1024 × 500): the brand mark on sage with the tagline
— `store/feature-graphic.png`.

## Regenerating

```bash
flutter build apk --release --dart-define=API_MODE=fake
adb install -r build/app/outputs/flutter-apk/app-release.apk
adb shell cmd uimode night no
adb shell settings put system font_scale 1.0
# demo accounts: attendee@thingstead.test / demo@thingstead.test, password123
adb exec-out screencap -p > store/screenshots/NN-name.png
```

Status bar: the emulator's is fine for Play; Apple prefers a clean one
(9:41, full battery) — `adb shell settings put global sysui_demo_allowed 1`
then `adb shell am broadcast -a com.android.systemui.demo -e command clock
-e hhmm 0941`.
