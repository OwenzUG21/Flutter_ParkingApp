import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Using OpenWeatherMap API - you'll need to get a free API key from https://openweathermap.org/api
  static const String _apiKey =
      'YOUR_API_KEY_HERE'; // Replace with your API key
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData?> getWeather(String city) async {
    // If no API key is set, return mock data for testing
    if (_apiKey == 'YOUR_API_KEY_HERE') {
      return _getMockWeather(city);
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      }
      return _getMockWeather(city);
    } catch (e) {
      print('Error fetching weather: $e');
      return _getMockWeather(city);
    }
  }

  Future<WeatherData?> getWeatherByCoordinates(double lat, double lon) async {
    // If no API key is set, return mock data for testing
    if (_apiKey == 'YOUR_API_KEY_HERE') {
      return _getMockWeather('Kampala');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      }
      return _getMockWeather('Kampala');
    } catch (e) {
      print('Error fetching weather: $e');
      return _getMockWeather('Kampala');
    }
  }

  // Mock weather data for testing without API key
  WeatherData _getMockWeather(String city) {
    return WeatherData(
      main: 'Clear',
      description: 'clear sky',
      temperature: 28.0,
      humidity: 65,
      icon: '01d',
    );
  }
}

class WeatherData {
  final String main;
  final String description;
  final double temperature;
  final int humidity;
  final String icon;

  WeatherData({
    required this.main,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      icon: json['weather'][0]['icon'],
    );
  }

  String get weatherIcon {
    switch (main.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
      case 'drizzle':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      default:
        return '🌤️';
    }
  }
}
