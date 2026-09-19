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

Xcode → Settings → Accounts → **+** → sign in with the Apple ID that owns the
Apple Developer Program membership (needed for TestFlight and for Universal
Links / Sign in with Apple capabilities; a free account can still run on a
plugged-in iPhone for 7 days at a time).

## 3. Clone and open

```bash
git clone <remote-url> ~/dev/thingstead    # see "Remote" below
cd ~/dev/thingstead
flutter pub get                            # also generates ios/Podfile the first time
cd ios && pod install && cd ..
```

Then open the **workspace** — never the project — or the pods will not resolve:

```bash
open ios/Runner.xcworkspace
```

## 4. One-time: signing and capabilities in Xcode

Select **Runner** (project) → **Runner** (target) → **Signing & Capabilities**:

1. **Automatically manage signing** ✓, **Team** = your team. Xcode creates the
   App ID `pro.thingstead.app` and a development profile.
2. Attach the entitlements file that is already in the repo:
   Build Settings → search "Code Signing Entitlements" → set to
   `Runner/Runner.entitlements` for all configurations. This turns on
   **Associated Domains** (`applinks:thingstead.pro`, `www.`, `app.`) for
   Universal Links. Until the backend hosts
   `/.well-known/apple-app-site-association` (docs/API-CONTRACT.md §3) links
   open through the `thingstead://` scheme instead — that already works.
3. Optional, not needed yet: **+ Capability → Sign in with Apple**. The
   feature is behind `Feature.socialSignIn` and only exercised in fake mode
   until the backend endpoint exists.

Do the same for the `RunnerTests` target's Team if Xcode nags about it.

## 5. Run

Simulator (no camera, but the manual-entry sheet covers the scanner):

```bash
open -a Simulator
flutter run --dart-define=API_MODE=fake
```

Real iPhone (camera works — the actual scanner):

```bash
flutter devices                              # find the phone's id
flutter run -d <device-id> --dart-define=API_MODE=fake
```

First run on a phone: unlock it, tap Trust, and on iOS 16+ turn on
Settings → Privacy & Security → **Developer Mode**. If iOS says the
developer is untrusted: Settings → General → VPN & Device Management → trust
your team.

`--dart-define=API_MODE=real` points at `https://thingstead.onrender.com`;
note the live server has no mobile API yet (the regista repo is ahead of
what Render deploys), so fake is the useful mode until that ships.

## 6. Per session

```bash
git pull
flutter pub get
cd ios && pod install && cd ..     # only when pubspec.lock changed
flutter run --dart-define=API_MODE=fake
```

Codegen output (`*.g.dart`, `*.freezed.dart`) is committed, so
`build_runner` is not needed just to run. If you edit a `@riverpod` /
`@freezed` file on the Mac: `dart run build_runner build -d`.

## 7. Release build and TestFlight (Phase 6)

```bash
flutter build ipa --dart-define=API_MODE=real
```

This produces `build/ios/ipa/thingstead.ipa` and an `.xcarchive`. Upload with
Xcode → Window → Organizer → Distribute App, or `xcrun altool` /
Transporter. Before the first upload:

- App Store Connect → create the app with bundle id `pro.thingstead.app`.
- `ITSAppUsesNonExemptEncryption = NO` in `ios/Runner/Info.plist` (HTTPS
  only), or answer the export-compliance question on every upload.
- Icon and splash: `dart run flutter_launcher_icons` and
  `dart run flutter_native_splash:create` (Phase 6, assets in `assets/brand/`).

## Remote

The repo is developed on Windows and needs a remote the Mac can pull from.
From the Windows checkout:

```bash
gh repo create thingstead --private --source=. --remote=origin --push
```

or create an empty private repo on GitHub and:

```bash
git remote add origin git@github.com:<you>/thingstead.git
git push -u origin main
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `CocoaPods not installed` / `pod: command not found` | `brew install cocoapods`, restart the terminal |
| Pod install fails on deployment target | `ios/Podfile`: uncomment `platform :ios, '15.0'` |
| "Signing for Runner requires a development team" | Step 4.1 |
| App installs but the camera is black on the simulator | Expected; use manual entry or a real phone |
| Universal Link opens Safari instead of the app | The AASA file is not hosted yet (backend follow-up); `thingstead://…` links work |
| Build error mentioning `Flutter.h` not found | You opened `Runner.xcodeproj`; open `Runner.xcworkspace` |
| Stale pods after upgrading plugins | `cd ios && pod deintegrate && pod install` |
