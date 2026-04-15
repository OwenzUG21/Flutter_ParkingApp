# Android Splash Screen Hang Fix Design

## Overview

The Flutter app is stuck on the Android native splash screen and never transitions to the Flutter UI. The root cause is likely related to the Android 12+ SplashScreen API implementation in MainActivity.kt, which may be blocking the Flutter engine initialization or preventing the transition to Flutter's first frame. The fix will involve adjusting the splash screen configuration to ensure proper handoff from native to Flutter, potentially by removing or configuring the `installSplashScreen()` call and ensuring the Flutter engine can render its first frame.

## Glossary

- **Bug_Condition (C)