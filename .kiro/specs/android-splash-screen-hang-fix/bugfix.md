# Bugfix Requirements Document

## Introduction

The Flutter app is stuck on the Android native splash screen (white colored screen) and never progresses to the Flutter UI. This prevents users from accessing the application, as the app remains indefinitely on the native splash screen without transitioning to the Flutter SplashScreen widget or any subsequent screens. The issue affects app launch on Android devices, making the application unusable.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN the app is launched on Android THEN the system displays the native splash screen (white background from launch_background.xml) and never transitions to the Flutter UI

1.2 WHEN the Flutter engine attempts to initialize during app launch THEN the system fails to render the Flutter SplashScreen widget

1.3 WHEN the app remains on the native splash screen THEN the system does not execute the navigation to '/auth' route after 1200ms

### Expected Behavior (Correct)

2.1 WHEN the app is launched on Android THEN the system SHALL display the native splash screen briefly, then transition to the Flutter SplashScreen widget

2.2 WHEN the Flutter engine initializes during app launch THEN the system SHALL successfully render the Flutter SplashScreen widget with the progress indicator and logo

2.3 WHEN the Flutter SplashScreen is displayed THEN the system SHALL execute the Timer callback after 1200ms and navigate to the '/auth' route

### Unchanged Behavior (Regression Prevention)

3.1 WHEN Firebase initialization completes successfully THEN the system SHALL CONTINUE TO initialize Firebase before runApp() is called

3.2 WHEN ThemeService initialization completes successfully THEN the system SHALL CONTINUE TO load theme preferences from the database

3.3 WHEN background services (DatabaseManager, NotificationService, OneSignalService, FavoritesService) initialize THEN the system SHALL CONTINUE TO initialize them asynchronously without blocking the UI

3.4 WHEN the app is running on iOS or other platforms THEN the system SHALL CONTINUE TO function normally without regression

3.5 WHEN the user navigates from SplashScreen to AuthWrapper THEN the system SHALL CONTINUE TO check authentication state and display the appropriate screen (LoginScreen or DashboardScreen)
