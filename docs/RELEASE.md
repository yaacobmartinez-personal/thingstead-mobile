# Releasing

## Android

### Signing

Release builds are signed with an **upload key** in a PKCS12 keystore
outside the repo:

```
%USERPROFILE%\thingstead-upload.jks      (alias: upload)
android/key.properties                   (gitignored; passwords + path)
```

Play App Signing re-signs with Google's own key on upload, so this key only
has to stay consistent for uploads. **Back the `.jks` and `key.properties`
up somewhere safe** (password manager attachment); losing them means a
support ticket with Google to reset the upload key.

`android/app/build.gradle.kts` reads `key.properties` when present and falls
back to the debug key otherwise, so a fresh clone and CI still build — those
builds just cannot be uploaded.

Fingerprints of the upload key (also needed for App Links, Google Sign-In):

```
SHA1:   3D:8B:98:0D:38:A4:8C:6D:D0:A6:AB:76:FF:23:22:CF:D7:3F:57:B2
SHA256: A1:EF:0D:F6:19:B0:27:40:3F:5E:99:2B:56:F3:BB:D4:20:7B:14:AD:E8:EA:F0:F4:FF:7B:76:75:9E:1C:FC:87
```

Once Play App Signing is on, Play Console → Setup → App signing shows the
**app signing key's** SHA-256 as well; `assetlinks.json` and the Google OAuth
client both need that one added alongside the upload key's.

### Build

```bash
flutter build appbundle --dart-define=API_MODE=real
# → build/app/outputs/bundle/release/app-release.aab
```

The bundle is ~70 MB because it carries the proguard map and debug symbols
for three ABIs; Play strips those and serves ~25 MB per device. `flutter
build apk --release` makes a fat universal APK for sideloading.

Bump `version:` in `pubspec.yaml` (`x.y.z+build`) before each upload; Play
rejects a reused build number.

Release builds are minified (R8) with rules in `android/app/proguard-rules.pro`
for ML Kit (scanner) and sqlite. If a release build crashes where debug does
not, suspect a missing keep rule first: `adb logcat | grep -i "ClassNotFound\|NoSuchMethod"`.

### Hardening already in place

- `allowBackup=false` + `dataExtractionRules` excluding everything: the
  session token is in encrypted storage whose key does not survive a
  restore, so a backup would only produce a half-broken app.
- `devToolsProvider` hides the server-address controls in release
  (long-press the version line to reveal).
- Release is not `DEBUGGABLE`; check with
  `adb shell dumpsys package pro.thingstead.app | grep flags`.

## Icon and splash

Sources are SVG in `assets/brand/` (`icon`, `adaptive-icon`, `splash-icon`,
`splash-icon-dark`), rasterised to 1024² PNG with headless Chrome:

```bash
chrome --headless=new --disable-gpu --hide-scrollbars \
  --default-background-color=00000000 --window-size=1024,1024 \
  --screenshot=icon.png file:///…/icon.html   # html wraps the svg in an <img>
```

Then regenerate the platform assets (config lives in `pubspec.yaml`):

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Android 12+ uses the system splash (mark on a lime disc over sage; dark
variant on `#121711`); older Android and iOS use the full-screen image.

## iOS

See `docs/MAC-SETUP.md`. `ITSAppUsesNonExemptEncryption` is already `false`
in `Info.plist`. `flutter build ipa --dart-define=API_MODE=real`, then
Xcode → Organizer → Distribute.

## Before store review

- Render free tier sleeps; the app shows "Waking the server…" for up to 30 s
  on a cold start. Move to an always-on instance before submitting or a
  reviewer's first impression is a spinner.
- Store listing copy and screenshots: capture from `API_MODE=fake`, which
  has a full demo org.
