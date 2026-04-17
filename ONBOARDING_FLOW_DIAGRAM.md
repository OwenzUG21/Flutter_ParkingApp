# Onboarding Flow Diagram

## Visual Flow Chart

```
┌─────────────────────────────────────────────────────────────────┐
│                         APP LAUNCH                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      SPLASH SCREEN                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  • Initialize Firebase                                    │  │
│  │  • Initialize Databases                                   │  │
│  │  • Initialize Notifications                               │  │
│  │  • Initialize Theme Service                               │  │
│  │  • Check Onboarding Status                                │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
                    ┌────────────────┐
                    │ Check Flag:    │
                    │ onboarding_    │
                    │ complete?      │
                    └────────┬───────┘
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
         ┌──────────┐              ┌──────────┐
         │   FALSE  │              │   TRUE   │
         │(First    │              │(Returning│
         │ Launch)  │              │  User)   │
         └────┬─────┘              └────┬─────┘
              │                         │
              ▼                         │
┌─────────────────────────────┐        │
│   ONBOARDING SCREEN 1       │        │
│  ┌──────────────────────┐   │        │
│  │ 🚗 Find Parking Fast │   │        │
│  │                      │   │        │
│  │ [Animation Playing]  │   │        │
│  │ • Car moving         │   │        │
│  │ • Pin pulsing        │   │        │
│  │ • Map floating       │   │        │
│  └──────────────────────┘   │        │
│                              │        │
│  [Skip]          [Next] ────┼────┐   │
└──────────────────────────────┘    │   │
                                    │   │
                                    ▼   │
┌─────────────────────────────┐        │
│   ONBOARDING SCREEN 2       │        │
│  ┌──────────────────────┐   │        │
│  │ 📱 Book in Seconds   │   │        │
│  │                      │   │        │
│  │ [Animation Playing]  │   │        │
│  │ • Tap ripple         │   │        │
│  │ • Slot glowing       │   │        │
│  │ • UI fading          │   │        │
│  └──────────────────────┘   │        │
│                              │        │
│  [Skip]          [Next] ────┼────┐   │
└──────────────────────────────┘    │   │
                                    │   │
                                    ▼   │
┌─────────────────────────────┐        │
│   ONBOARDING SCREEN 3       │        │
│  ┌──────────────────────┐   │        │
│  │ 🛡️ Safe Parking      │   │        │
│  │                      │   │        │
│  │ [Animation Playing]  │   │        │
│  │ • Shield appearing   │   │        │
│  │ • Car bouncing       │   │        │
│  │ • Particles floating │   │        │
│  └──────────────────────┘   │        │
│                              │        │
│  [Skip]    [Get Started] ───┼────┐   │
└──────────────────────────────┘    │   │
                                    │   │
                                    ▼   │
                          ┌──────────────┴──────┐
                          │ Save Flag:          │
                          │ onboarding_complete │
                          │ = true              │
                          └──────────┬──────────┘
                                     │
                                     ▼
                          ┌─────────────────────┐
                          │   LOGIN SCREEN      │
                          │  ┌──────────────┐   │
                          │  │ Email        │   │
                          │  │ Password     │   │
                          │  │ [Login]      │   │
                          │  │ [Sign Up]    │   │
                          │  └──────────────┘   │
                          └──────────┬──────────┘
                                     │
                                     ▼
                          ┌─────────────────────┐
                          │   DASHBOARD         │
                          │   (Main App)        │
                          └─────────────────────┘
```

## User Interaction Flow

### First Time User Journey
```
1. Launch App
   ↓
2. See Splash Screen (2-3 seconds)
   ↓
3. Onboarding Screen 1
   • Read: "Find Parking Fast"
   • Watch: Car animation
   • Action: Swipe left OR tap "Next"
   ↓
4. Onboarding Screen 2
   • Read: "Book in Seconds"
   • Watch: Phone tap animation
   • Action: Swipe left OR tap "Next"
   ↓
5. Onboarding Screen 3
   • Read: "Safe Parking"
   • Watch: Shield animation
   • Action: Tap "Get Started"
   ↓
6. Login Screen
   • Enter credentials
   • Start using app
```

### Returning User Journey
```
1. Launch App
   ↓
2. See Splash Screen (2-3 seconds)
   ↓
3. Login Screen (Skip onboarding)
   ↓
4. Dashboard
```

### Skip Flow (Any Time)
```
Onboarding Screen (any)
   ↓
Tap "Skip" button
   ↓
Login Screen
   ↓
Dashboard
```

## State Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    SharedPreferences                        │
│                                                             │
│  Key: "onboarding_complete"                                 │
│  Value: boolean (true/false)                                │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  First Launch:        null or false                   │  │
│  │  After Onboarding:    true                            │  │
│  │  Subsequent Launches: true (persisted)                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   OnboardingHelper API                      │
│                                                             │
│  isOnboardingComplete()                                     │
│    → Returns: Future<bool>                                  │
│    → Checks SharedPreferences                               │
│                                                             │
│  completeOnboarding()                                       │
│    → Returns: Future<void>                                  │
│    → Sets flag to true                                      │
│                                                             │
│  resetOnboarding()                                          │
│    → Returns: Future<void>                                  │
│    → Removes flag (for testing)                             │
└─────────────────────────────────────────────────────────────┘
```

## Animation Timeline

### Screen 1: Find Parking Fast (4 seconds loop)
```
Time:  0s    1s    2s    3s    4s (loop)
       │     │     │     │     │
Car:   ├─────────────────────→ (moves forward)
Pin:   ↕     ↕     ↕     ↕     ↕ (pulses)
Map:   ↕     ↕     ↕     ↕     ↕ (floats)
```

### Screen 2: Book in Seconds (4 seconds loop)
```
Time:  0s    1s    2s    3s    4s (loop)
       │     │     │     │     │
Tap:   ●     ○     ●     ○     ● (ripple)
Slot:  ◐     ◑     ◐     ◑     ◐ (glow)
UI:    ▓     ░     ▓     ░     ▓ (fade)
```

### Screen 3: Safe Parking (4 seconds loop)
```
Time:  0s    1s    2s    3s    4s (loop)
       │     │     │     │     │
Shield: ○    ●     ●     ●     ○ (appear/fade)
Car:   ↓     ↑     ↓     ↑     ↓ (bounce)
Parts: ·     ·     ·     ·     · (float)
```

## Navigation Routes

```
┌─────────────────────────────────────────────────────────────┐
│                      App Routes                             │
├─────────────────────────────────────────────────────────────┤
│  /splash        → SplashScreen                              │
│  /onboarding    → OnboardingScreen (NEW)                    │
│  /login         → LoginScreen                               │
│  /auth          → AuthWrapper                               │
│  /signup        → SignupScreen                              │
│  /dashboard     → DashboardScreen                           │
│  ...            → (other routes)                            │
└─────────────────────────────────────────────────────────────┘
```

## Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OnboardingScreen                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  PageController                                       │  │
│  │  • Manages page navigation                            │  │
│  │  • Tracks current page index                          │  │
│  │  • Handles swipe gestures                             │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  PageView.builder                                     │  │
│  │  • Displays onboarding pages                          │  │
│  │  • Enables swipe navigation                           │  │
│  │  • Builds pages dynamically                           │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  SmoothPageIndicator                                  │  │
│  │  • Shows current page                                 │  │
│  │  • Expanding dots effect                              │  │
│  │  • Smooth transitions                                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Buttons                                              │  │
│  │  • Skip (top-right)                                   │  │
│  │  • Next (bottom, screens 1-2)                         │  │
│  │  • Get Started (bottom, screen 3)                     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                  OnboardingContent Model                    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Properties:                                          │  │
│  │  • title: String                                      │  │
│  │  • subtitle: String                                   │  │
│  │  • animationPath: String                              │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Static List: contents                                │  │
│  │  • Screen 1 data                                      │  │
│  │  • Screen 2 data                                      │  │
│  │  • Screen 3 data                                      │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## File Dependencies

```
main.dart
  ├─→ onboarding_screen.dart
  │     ├─→ onboarding_content.dart
  │     ├─→ onboarding_helper.dart
  │     ├─→ login.dart
  │     └─→ lottie package
  │           └─→ onboarding_1_find_parking.json
  │           └─→ onboarding_2_easy_booking.json
  │           └─→ onboarding_3_safe_parking.json
  │
  └─→ splash_screen.dart
        └─→ onboarding_helper.dart
              └─→ shared_preferences package
```

## Testing Scenarios

### Scenario 1: First Launch
```
Given: Fresh app install
When: User launches app
Then: 
  1. Splash screen appears
  2. Onboarding screen 1 appears
  3. User can navigate through 3 screens
  4. User completes onboarding
  5. Login screen appears
  6. Flag is saved
```

### Scenario 2: Returning User
```
Given: Onboarding completed previously
When: User launches app
Then:
  1. Splash screen appears
  2. Login screen appears (skip onboarding)
  3. User can login
```

### Scenario 3: Skip Onboarding
```
Given: User on any onboarding screen
When: User taps "Skip"
Then:
  1. Navigate to login screen
  2. Save completion flag
  3. Don't show onboarding again
```

### Scenario 4: Reset for Testing
```
Given: Developer wants to test onboarding
When: Call OnboardingHelper.resetOnboarding()
Then:
  1. Flag is removed
  2. Next launch shows onboarding
  3. Can test flow again
```

---

**Legend:**
- → : Navigation/Flow
- ↓ : Downward movement
- ↑ : Upward movement
- ↕ : Up/down oscillation
- ● : Active/Visible
- ○ : Inactive/Hidden
- ◐ : Partial/Glowing
- ▓ : Opaque
- ░ : Transparent
- · : Particle
