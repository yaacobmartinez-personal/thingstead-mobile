# Thingstead (mobile)

Flutter app for [Thingstead](https://thingstead.pro), the free-event
registration SaaS. One app, two modes: attendees find events and keep QR
tickets; organizers manage events and check people in at the door.

The backend is the Next.js app in the sibling `regista` repository. This app
talks to it over `/api/mobile/*` and `/api/public/*`; endpoints that do not
exist yet are specified in [docs/API-CONTRACT.md](docs/API-CONTRACT.md) and
faked in-app until they ship.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_MODE=fake     # default: fully offline demo world
flutter run --dart-define=API_MODE=real     # against the live API
```

Fake-mode accounts: `demo@thingstead.test` (organizer) and
`attendee@thingstead.test`, password `password123`.

Optional defines: `SERVER_URL` (default `https://thingstead.onrender.com`),
`PUBLIC_ORIGIN`, `APP_ORIGIN`.

## Check

```bash
flutter analyze
flutter test
```

## Docs

- [docs/PLAN.md](docs/PLAN.md) — the approved implementation plan and phases
- [docs/REDESIGN.md](docs/REDESIGN.md) — the visual redesign plan (Phase D: green palette, illustrations, motion, dark mode)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — modes, layers, `API_MODE`
- [docs/MAC-SETUP.md](docs/MAC-SETUP.md) — building and running the iOS app on a Mac
- [docs/API-CONTRACT.md](docs/API-CONTRACT.md) — backend contract

## Toolchain

Flutter stable (3.47+), Android SDK 36, JDK 17+ (Android Studio's bundled
JBR works). iOS builds need Xcode on a Mac.

### Windows note: Gradle "Unable to establish loopback connection"

On some Windows machines the JDK cannot create the Unix-domain socket it uses
for NIO selectors inside `%LOCALAPPDATA%\Temp`, and every Gradle invocation
fails with `java.io.IOException: Unable to establish loopback connection`
(`SocketException: Invalid argument: connect`). Point the JDK at a plain
directory instead:

```powershell
New-Item -ItemType Directory -Force C:\dev\tmp | Out-Null
[Environment]::SetEnvironmentVariable("JAVA_TOOL_OPTIONS", "-Djdk.net.unixdomain.tmpdir=C:\dev\tmp", "User")
```

Open a new terminal afterwards.
