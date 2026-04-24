import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Using Open-Meteo API - free weather API, no API key required
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  // Cache to store weather data with timestamps
  static final Map<String, Map<String, dynamic>> _cache = {};
  static const int _cacheValidityMinutes = 10; // Cache valid for 10 minutes

  // City coordinates cache to avoid repeated geocoding
  static final Map<String, Map<String, double>> _cityCoordinates = {
    'kampala': {'lat': 0.3476, 'lon': 32.5825},
    'entebbe': {'lat': 0.0563, 'lon': 32.4432},
    'jinja': {'lat': 0.4244, 'lon': 33.2042},
    'mukono': {'lat': 0.3533, 'lon': 32.7553},
    'wakiso': {'lat': 0.4044, 'lon': 32.4597},
    'masaka': {'lat': -0.3540, 'lon': 31.7340},
    'mbarara': {'lat': -0.6103, 'lon': 30.6593},
  };

  Future<WeatherData?> getWeather(String city,
      {bool forceRefresh = false}) async {
    // Check cache first (unless force refresh is requested)
    if (!forceRefresh && _isCacheValid(city)) {
      return WeatherData.fromCachedData(_cache[city]!['data']);
    }

    try {
      // Get coordinates for the city
      final coordinates = await _getCoordinates(city);
      if (coordinates == null) {
        print('Could not find coordinates for $city');
        return _getMockWeather(city);
      }

      // Fetch weather data from Open-Meteo
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?latitude=${coordinates['lat']}&longitude=${coordinates['lon']}&current=temperature_2m,relative_humidity_2m,weather_code,is_day&timezone=auto'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherData = WeatherData.fromOpenMeteoJson(data);
        _updateCache(city, weatherData);
        return weatherData;
      } else {
        print('Weather API error: ${response.statusCode}');
        return _getMockWeather(city);
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return _getMockWeather(city);
    }
  }

  Future<WeatherData?> getWeatherByCoordinates(double lat, double lon,
      {bool forceRefresh = false}) async {
    final cacheKey = '${lat}_$lon';

    // Check cache first (unless force refresh is requested)
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      return WeatherData.fromCachedData(_cache[cacheKey]!['data']);
    }

    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,weather_code,is_day&timezone=auto'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherData = WeatherData.fromOpenMeteoJson(data);
        _updateCache(cacheKey, weatherData);
        return weatherData;
      } else {
        print('Weather API error: ${response.statusCode}');
        return _getMockWeather('Location');
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return _getMockWeather('Location');
    }
  }

  Future<Map<String, double>?> _getCoordinates(String city) async {
    final cityLower = city.toLowerCase();

    // Check if we have cached coordinates
    if (_cityCoordinates.containsKey(cityLower)) {
      return _cityCoordinates[cityLower];
    }

    try {
      // Use geocoding API to get coordinates
      final response = await http.get(
        Uri.parse('$_geocodingUrl?name=$city&count=1&language=en&format=json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final coordinates = <String, double>{
            'lat': result['latitude'].toDouble(),
            'lon': result['longitude'].toDouble(),
          };

          // Cache the coordinates
          _cityCoordinates[cityLower] = coordinates;
          return coordinates;
        }
      }
    } catch (e) {
      print('Error geocoding city $city: $e');
    }

    return null;
  }

  bool _isCacheValid(String key) {
    if (!_cache.containsKey(key)) return false;

    final cachedTime = _cache[key]!['timestamp'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(cachedTime).inMinutes;

    return difference < _cacheValidityMinutes;
  }

  void _updateCache(String key, WeatherData data) {
    _cache[key] = {
      'data': data.toMap(),
      'timestamp': DateTime.now(),
    };
  }

  // Clear cache to force fresh data
  void clearCache() {
    _cache.clear();
  }

  // Fallback mock weather data if API fails
  WeatherData _getMockWeather(String city) {
    final now = DateTime.now();
    final random = city.hashCode + now.day + now.hour;

    // Create different weather patterns based on city and time
    final weatherTypes = [
      {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'},
      {'main': 'Clouds', 'description': 'few clouds', 'icon': '02d'},
      {'main': 'Clouds', 'description': 'scattered clouds', 'icon': '03d'},
      {'main': 'Clouds', 'description': 'broken clouds', 'icon': '04d'},
      {'main': 'Rain', 'description': 'light rain', 'icon': '10d'},
      {'main': 'Rain', 'description': 'moderate rain', 'icon': '10d'},
      {'main': 'Thunderstorm', 'description': 'thunderstorm', 'icon': '11d'},
    ];

    final weatherIndex = random.abs() % weatherTypes.length;
    final selectedWeather = weatherTypes[weatherIndex];

    // Temperature varies by city and time
    double baseTemp = 25.0;
    switch (city.toLowerCase()) {
      case 'kampala':
        baseTemp = 26.0;
        break;
      case 'entebbe':
        baseTemp = 24.0;
        break;
      case 'jinja':
        baseTemp = 27.0;
        break;
      case 'mukono':
        baseTemp = 25.0;
        break;
      case 'wakiso':
        baseTemp = 25.5;
        break;
      case 'masaka':
        baseTemp = 23.0;
        break;
      case 'mbarara':
        baseTemp = 22.0;
        break;
    }

    // Add time-based temperature variation
    final hourVariation = (now.hour - 12) * 0.5; // Cooler in morning/evening
    final dayVariation = (random % 10 - 5) * 0.8; // Random daily variation
    final temperature = baseTemp + hourVariation + dayVariation;

    // Humidity varies with weather type
    int humidity = 60;
    switch (selectedWeather['main']) {
      case 'Rain':
      case 'Thunderstorm':
        humidity = 80 + (random % 15);
        break;
      case 'Clear':
        humidity = 45 + (random % 20);
        break;
      case 'Clouds':
        humidity = 65 + (random % 20);
        break;
    }

    return WeatherData(
      main: selectedWeather['main']!,
      description: selectedWeather['description']!,
      temperature: double.parse(temperature.toStringAsFixed(1)),
      humidity: humidity,
      icon: selectedWeather['icon']!,
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

  factory WeatherData.fromOpenMeteoJson(Map<String, dynamic> json) {
    final current = json['current'];
    final weatherCode = current['weather_code'] as int;
    final isDay = current['is_day'] == 1;

    final weatherInfo = _getWeatherFromCode(weatherCode, isDay);

    return WeatherData(
      main: weatherInfo['main']!,
      description: weatherInfo['description']!,
      temperature: current['temperature_2m'].toDouble(),
      humidity: current['relative_humidity_2m'],
      icon: weatherInfo['icon']!,
    );
  }

  factory WeatherData.fromCachedData(Map<String, dynamic> data) {
    return WeatherData(
      main: data['main'],
      description: data['description'],
      temperature: data['temperature'],
      humidity: data['humidity'],
      icon: data['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'main': main,
      'description': description,
      'temperature': temperature,
      'humidity': humidity,
      'icon': icon,
    };
  }

  static Map<String, String> _getWeatherFromCode(int code, bool isDay) {
    // Open-Meteo weather codes mapping
    switch (code) {
      case 0:
        return {
          'main': 'Clear',
          'description': 'clear sky',
          'icon': isDay ? '01d' : '01n'
        };
      case 1:
      case 2:
      case 3:
        return {
          'main': 'Clouds',
          'description': code == 1
              ? 'mainly clear'
              : code == 2
                  ? 'partly cloudy'
                  : 'overcast',
          'icon': isDay ? '02d' : '02n'
        };
      case 45:
      case 48:
        return {'main': 'Mist', 'description': 'fog', 'icon': '50d'};
      case 51:
      case 53:
      case 55:
        return {'main': 'Drizzle', 'description': 'drizzle', 'icon': '09d'};
      case 56:
      case 57:
        return {
          'main': 'Drizzle',
          'description': 'freezing drizzle',
          'icon': '09d'
        };
      case 61:
      case 63:
      case 65:
        return {
          'main': 'Rain',
          'description': code == 61
              ? 'light rain'
              : code == 63
                  ? 'moderate rain'
                  : 'heavy rain',
          'icon': '10d'
        };
      case 66:
      case 67:
        return {'main': 'Rain', 'description': 'freezing rain', 'icon': '13d'};
      case 71:
      case 73:
      case 75:
        return {'main': 'Snow', 'description': 'snow', 'icon': '13d'};
      case 77:
        return {'main': 'Snow', 'description': 'snow grains', 'icon': '13d'};
      case 80:
      case 81:
      case 82:
        return {'main': 'Rain', 'description': 'rain showers', 'icon': '09d'};
      case 85:
      case 86:
        return {'main': 'Snow', 'description': 'snow showers', 'icon': '13d'};
      case 95:
        return {
          'main': 'Thunderstorm',
          'description': 'thunderstorm',
          'icon': '11d'
        };
      case 96:
      case 99:
        return {
          'main': 'Thunderstorm',
          'description': 'thunderstorm with hail',
          'icon': '11d'
        };
      default:
        return {
          'main': 'Unknown',
          'description': 'unknown weather',
          'icon': '01d'
        };
    }
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
