# Flutter's own rules come from the Flutter Gradle plugin. These cover the
# plugins that reflect at runtime.

# mobile_scanner → ML Kit barcode
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.vision.** { *; }
-dontwarn com.google.mlkit.**

# drift / sqlite3_flutter_libs load the native library by name
-keep class org.sqlite.** { *; }
-keep class eu.simonbinder.** { *; }

# Play Core split-install classes referenced by Flutter's deferred components
# but not bundled in this app.
-dontwarn com.google.android.play.core.**
