# Weather API Setup Guide

## Overview
Weather icons have been added to show the current weather in Kampala on both the Dashboard and Parking Map screens. The weather display is positioned on the RIGHT SIDE of the screen.

## Features Added
- Weather icon and temperature display on the RIGHT side of "Current Location" section on Dashboard
- Weather icon and temperature display on the RIGHT side of the AppBar in Parking Map screen
- Real-time weather data from OpenWeatherMap API
- Automatic weather emoji icons (☀️, ☁️, 🌧️, ⛈️, ❄️, 🌫️)
- Mock weather data for testing (shows ☀️ 28°C by default without API key)

## Quick Start (No API Key Needed for Testing)
The app will work immediately with mock weather data showing:
- ☀️ Clear sky
- 28°C temperature

Just run the app and you'll see the weather on the right side!

## Setup Instructions for Real Weather Data

### 1. Get a Free API Key
1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Navigate to "API keys" section
4. Copy your API key

### 2. Add Your API Key
Open `lib/services/weather_service.dart` and replace `YOUR_API_KEY_HERE` with your actual API key:

```dart
static const String _apiKey = 'your_actual_api_key_here';
```

### 3. Install Dependencies
Run the following command to install the required packages:

```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

## UI Layout
- Dashboard: Weather appears in a styled card on the RIGHT side of "Kampala, Uganda"
- Parking Map: Weather appears on the RIGHT side of the AppBar title

## Files Modified
- `pubspec.yaml` - Added `http` package
- `lib/services/weather_service.dart` - Weather service with mock data fallback
- `lib/screens/dashboard.dart` - Weather display on right side of Current Location
- `lib/screens/parkingmap.dart` - Weather display on right side of AppBar

## Weather Icons
The app displays different emoji icons based on weather conditions:
- ☀️ Clear sky
- ☁️ Cloudy
- 🌧️ Rain/Drizzle
- ⛈️ Thunderstorm
- ❄️ Snow
- 🌫️ Mist/Fog/Haze
- 🌤️ Default

## API Usage
- Free tier: 1,000 API calls per day
- Updates: Weather data is fetched when the screen loads
- Location: Currently set to "Kampala, Uganda"
- Fallback: Shows mock data if API fails or no key is set

## Troubleshooting
- If weather doesn't show, check your API key is correct
- Ensure you have internet connectivity
- Check the console for any error messages
- API keys may take a few minutes to activate after creation
- Without an API key, mock weather data (☀️ 28°C) will be displayed

