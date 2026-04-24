# Weather API Setup Guide

## Current Status
Your weather app is currently using **mock data** that changes dynamically based on time and location. This provides realistic-looking weather variations for testing purposes.

## To Get Real Weather Data

### Step 1: Get a Free API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Go to your API keys section
4. Copy your API key

### Step 2: Update the Weather Service
1. Open `lib/services/weather_service.dart`
2. Find this line:
   ```dart
   static const String _apiKey = 'YOUR_API_KEY_HERE';
   ```
3. Replace `'YOUR_API_KEY_HERE'` with your actual API key:
   ```dart
   static const String _apiKey = 'your_actual_api_key_here';
   ```

### Step 3: Test Real Weather Data
- Restart your app
- The weather screen will now show real weather data
- Pull to refresh or tap the refresh button to get updated data

## Mock Data Features (Current Implementation)
- **Dynamic temperatures** based on city and time of day
- **Varied weather conditions** (clear, cloudy, rainy, thunderstorms)
- **Realistic humidity levels** that match weather conditions
- **Time-based variations** (cooler in morning/evening)
- **City-specific base temperatures**:
  - Kampala: 26°C base
  - Entebbe: 24°C base  
  - Jinja: 27°C base
  - Mbarara: 22°C base
  - And more...

## Caching System
- Weather data is cached for 10 minutes to reduce API calls
- Pull to refresh or tap refresh button to force new data
- Cache automatically expires and refreshes

## Troubleshooting
- If weather still appears static, try force-closing and reopening the app
- Check your internet connection for real API data
- Verify your API key is correctly entered (no extra spaces)