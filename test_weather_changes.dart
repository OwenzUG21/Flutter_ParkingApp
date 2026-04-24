// Quick test to verify weather data changes
// Run this in your main.dart temporarily to see weather variations

import 'package:flutter/material.dart';
import 'lib/services/weather_service.dart';

void testWeatherChanges() async {
  final weatherService = WeatherService();

  print('=== Testing Weather Data Changes ===');

  // Test different cities
  final cities = ['Kampala', 'Entebbe', 'Jinja', 'Mbarara'];

  for (final city in cities) {
    final weather = await weatherService.getWeather(city, forceRefresh: true);
    if (weather != null) {
      print(
          '$city: ${weather.temperature}°C, ${weather.main}, ${weather.description}');
    }
  }

  print('\n=== Testing Multiple Calls (should show cache working) ===');

  // Test caching - first call
  final start = DateTime.now();
  final weather1 = await weatherService.getWeather('Kampala');
  final firstCallTime = DateTime.now().difference(start).inMilliseconds;

  // Second call (should be from cache)
  final start2 = DateTime.now();
  final weather2 = await weatherService.getWeather('Kampala');
  final secondCallTime = DateTime.now().difference(start2).inMilliseconds;

  print('First call: ${firstCallTime}ms');
  print('Second call (cached): ${secondCallTime}ms');
  print('Same data: ${weather1?.temperature == weather2?.temperature}');

  // Force refresh
  final weather3 =
      await weatherService.getWeather('Kampala', forceRefresh: true);
  print('After force refresh: ${weather3?.temperature}°C');
}

// Add this to your main.dart initState or main function to test:
// testWeatherChanges();
