# Building the iOS app on a Mac

The Android side is developed on Windows; iOS needs a Mac with Xcode. This is
the one-time setup plus the per-session routine. Nothing here changes the
code — the iOS project is already configured (bundle id `pro.thingstead.app`,
iOS 15.0 minimum, camera usage string, custom URL scheme, Universal Links
entitlements file).

## 1. One-time: tools

```bash
# Xcode from the App Store (≈ 15 GB; 16.x or newer), then:
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
xcodebuild -version

# CocoaPods (Flutter's iOS plugins are wired through it)
brew install cocoapods        # or: sudo gem install cocoapods
pod --version

# Flutter — same channel and version as the Windows machine (3.47.x stable)
git clone -b stable https://github.com/flutter/flutter.git ~/dev/flutter
echo 'export PATH="$HOME/dev/flutter/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
flutter --version
flutter config --no-analytics
flutter doctor            # Xcode + CocoaPods must be green; Android/Chrome can stay red
```

If `flutter doctor` complains about the iOS simulator, open Xcode once and
install the iOS platform when it asks (Settings → Platforms).

## 2. One-time: Apple account in Xcode

Xcode → Settings → Accounts → **+** → sign in with your Apple ID. This
creates a **Personal Team**, which is enough for everything in this guide
except §7: the simulator without limits, and your own iPhone over USB with
builds that expire after 7 days (just run again).

**Use the Apple ID that will later hold the Developer Program membership.**
Building `pro.thingstead.app` under a Personal Team ties that bundle id to
the Apple ID; joining the Program with the same ID upgrades cleanly. If the
paid account will be a different one, set the bundle id to
`pro.thingstead.app.dev` in Xcode for the free phase and do not commit it.

## 3. Clone and open

```bash
git clone https://github.com/yaacobmartinez-personal/thingstead-mobile.git ~/dev/thingstead
cd ~/dev/thingstead
flutter pub get
open -a Simulator
flutter run --dart-define-from-file=release.json   # real backend; sign in with your account
```

The first run creates `ios/Podfile` and `Runner.xcworkspace` and runs
`pod install` itself — there is nothing to do by hand. If it stops on
"requires a development team", do §4 and run again.

For anything in Xcode, open the **workspace** — never the project — or the
pods will not resolve:

```bash
open ios/Runner.xcworkspace
```

## 4. One-time: signing in Xcode

Select **Runner** (project) → **Runner** (target) → **Signing & Capabilities**:

- **Automatically manage signing** ✓, **Team** = your team. Xcode creates the
  App ID `pro.thingstead.app` and a development profile.
- Do the same for the `RunnerTests` target if Xcode nags about it.

**With a Personal Team, stop here.** The two capabilities below are paid-only
and Xcode refuses to build if they are present:

- Do **not** attach `Runner/Runner.entitlements` (Associated Domains).
  `thingstead://…` links still open the app; `https://thingstead.pro/…`
  opens Safari until the membership exists.
- Do **not** add Sign in with Apple. The app hides the Apple button unless
  built with `--dart-define=APPLE_SIGN_IN=true`, so nothing dead shows.

**With a Developer Program team**, also:

1. Build Settings → "Code Signing Entitlements" → `Runner/Runner.entitlements`
   for all configurations. Turns on **Associated Domains** for Universal
   Links; the backend serves `/.well-known/apple-app-site-association` once
   `APPLE_TEAM_ID` is set on Render (docs/RELEASE.md).
2. **+ Capability → Sign in with Apple**, then build with
   `--dart-define=APPLE_SIGN_IN=true`.

## 5. Run

Simulator (no camera, but the manual-entry sheet covers the scanner):

```bash
open -a Simulator
flutter run --dart-define-from-file=release.json   # real backend
flutter run --dart-define=API_MODE=fake           # demo data, no account needed
```

Real mode is the one to test; fake mode has two demo organizations with
events and attendees in every state (waitlist, checked in, erased, pending
invites), which a fresh real account does not, and shows the Apple/Google
buttons before their OAuth setup exists.

Real iPhone (camera works — the actual scanner, and the offline check-in
path is worth testing here):

```bash
flutter devices                              # find the phone's id
flutter run -d <device-id> --dart-define=API_MODE=real
```

First run on a phone: unlock it, tap Trust, and on iOS 16+ turn on
Settings → Privacy & Security → **Developer Mode** (the phone reboots). If
iOS says the developer is untrusted: Settings → General → VPN & Device
Management → trust your Apple ID. Personal Team builds stop launching after
7 days; `flutter run` again re-signs.

`--dart-define=API_MODE=real` points at `https://thingstead.onrender.com`,
which serves the whole mobile API. Sign in with your thingstead.pro account.
Fake mode stays useful for demos and for working without an account, and
is the only way to try the Google/Apple buttons before their OAuth setup
exists (docs/RELEASE.md).

## 6. Per session

```bash
git pull
flutter pub get
flutter run --dart-define-from-file=release.json   # re-runs pod install when plugins changed
```

Codegen output (`*.g.dart`, `*.freezed.dart`) is committed, so
`build_runner` is not needed just to run. If you edit a `@riverpod` /
`@freezed` file on the Mac: `dart run build_runner build -d`.

## 7. Release build and TestFlight — needs the Developer Program

```bash
flutter build ipa --dart-define-from-file=release.json   # fill in the iOS id and APPLE_SIGN_IN first
```

This produces `build/ios/ipa/thingstead.ipa` and an `.xcarchive`. Upload with
Xcode → Window → Organizer → Distribute App, or Transporter. Before the
first upload:

- App Store Connect → create the app with bundle id `pro.thingstead.app`.
- The two capabilities from §4 attached.
- Icon, splash and `ITSAppUsesNonExemptEncryption` are already done.
- Store copy and screenshots: docs/STORE-LISTING.md.

## Remote

`https://github.com/yaacobmartinez-personal/thingstead-mobile` (private).
Developed on Windows, pushed to `main`; the Mac pulls from there. Cloning
over HTTPS needs a GitHub personal access token or `gh auth login` on the
Mac; SSH works if the Mac's key is on the account.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `CocoaPods not installed` / `pod: command not found` | `brew install cocoapods`, restart the terminal |
| Pod install fails on deployment target | `ios/Podfile`: uncomment `platform :ios, '15.0'` |
| "Signing for Runner requires a development team" | §4 |
| Build fails mentioning "Associated Domains" or "Sign in with Apple" on a Personal Team | Remove the entitlements / capability — §4 |
| The app stops launching after a week | Personal Team build expired; `flutter run` again |
| App installs but the camera is black on the simulator | Expected; use manual entry or a real phone |
| Universal Link opens Safari instead of the app | The AASA file is not hosted yet (backend follow-up); `thingstead://…` links work |
| Build error mentioning `Flutter.h` not found | You opened `Runner.xcodeproj`; open `Runner.xcworkspace` |
| Stale pods after upgrading plugins | `cd ios && pod deintegrate && pod install` |
