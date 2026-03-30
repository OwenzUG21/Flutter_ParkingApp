# Lottie Animations Guide

## Overview
Lottie animations have been integrated into the ParkFlexApp for the splash screen and drawer header.

## Current Implementation

### Splash Screen
- **Logo Animation**: `lib/assets/animations/parking_logo.json`
  - Animated "P" logo with rotation and scale effects
  - Located above the app name

- **Text Animation**: `lib/assets/animations/parking_text.json`
  - Subtle animation overlay on "ParkFlexApp" text
  - Fade-in and slide-up effect

### Drawer Header
- **Logo Animation**: Same `parking_logo.json` file
  - Animated "P" logo in the drawer header
  - Continuous loop animation

## Getting Better Lottie Animations

The current animations are basic placeholders. For professional parking-themed animations, visit:

### Recommended Sources:
1. **LottieFiles** (https://lottiefiles.com/)
   - Search for: "parking", "car parking", "parking lot", "P logo"
   - Free and premium options available
   - Download as JSON

2. **Specific Animation Suggestions:**
   - Parking sign animation
   - Car parking animation
   - Parking meter animation
   - Location pin with parking symbol
   - Animated "P" with car icon

### How to Replace Animations:

1. Download your chosen Lottie animation (JSON format)
2. Replace the files:
   - `lib/assets/animations/parking_logo.json` - For the P logo
   - `lib/assets/animations/parking_text.json` - For text effects

3. Run `flutter pub get` to ensure assets are recognized
4. Hot reload or restart the app

## Customization Options

### Adjust Animation Speed:
```dart
Lottie.asset(
  'lib/assets/animations/parking_logo.json',
  repeat: true,
  animate: true,
  frameRate: FrameRate(60), // Adjust frame rate
)
```

### Control Animation Loop:
```dart
Lottie.asset(
  'lib/assets/animations/parking_logo.json',
  repeat: false, // Play once
  // or
  repeat: true,  // Loop continuously
)
```

### Add Animation Controller:
```dart
AnimationController _controller;

@override
void initState() {
  super.initState();
  _controller = AnimationController(vsync: this);
}

Lottie.asset(
  'lib/assets/animations/parking_logo.json',
  controller: _controller,
  onLoaded: (composition) {
    _controller.duration = composition.duration;
    _controller.forward();
  },
)
```

## Testing

After adding new animations:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run the app: `flutter run`
4. Check both splash screen and drawer header

## Notes
- Lottie files should be optimized for mobile (keep file size under 100KB)
- Test animations on both Android and iOS
- Ensure animations don't slow down app startup
- Consider using `precacheImage` for better performance
