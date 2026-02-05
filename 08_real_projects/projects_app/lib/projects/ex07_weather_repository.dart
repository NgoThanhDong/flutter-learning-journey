/// ============================================================================
/// EXERCISE 07: WEATHER REPOSITORY
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Học Repository pattern cho data layer.
///
/// 📝 BẠN SẼ HỌC:
/// - Abstract class (interface) cho repository
/// - Implementation với simulated API
/// - Error handling
/// - Caching strategies
/// - Dependency Injection preparation
///
/// ============================================================================
library;

import 'dart:math';
import 'package:flutter/material.dart';

import 'ex06_weather_model.dart';

// ============================================================================
// ABSTRACT REPOSITORY
// ============================================================================
///
/// ## Repository Pattern là gì?
///
/// Repository pattern tách biệt:
/// - **Business logic** (BLoC/Cubit) - không cần biết data lấy từ đâu
/// - **Data access** (Repository) - biết cách lấy data từ API/DB
///
/// ## Tại sao dùng Abstract class?
///
/// 1. **Dependency Inversion**: BLoC phụ thuộc vào abstraction, không phải implementation
/// 2. **Testability**: Dễ tạo fake/mock cho testing
/// 3. **Flexibility**: Dễ thay đổi data source (API → Local DB)
///
/// ## Ví dụ:
///
/// ```dart
/// // BLoC không quan tâm data từ đâu
/// class WeatherBloc {
///   final WeatherRepository repository; // Abstract!
///
///   // Real API
///   WeatherBloc(repository: ApiWeatherRepository())
///
///   // Fake for testing
///   WeatherBloc(repository: FakeWeatherRepository())
/// }
/// ```
///
// ============================================================================

abstract class WeatherRepository {
  /// Lấy thời tiết hiện tại của thành phố.
  ///
  /// [city] tên thành phố (e.g., "Hanoi", "Ho Chi Minh")
  ///
  /// Throws [WeatherException] nếu có lỗi.
  Future<Weather> getCurrentWeather(String city);

  /// Lấy dự báo thời tiết 5 ngày.
  ///
  /// [city] tên thành phố.
  ///
  /// Throws [WeatherException] nếu có lỗi.
  Future<List<Forecast>> getForecast(String city);

  /// Lấy danh sách thành phố phổ biến.
  List<String> getPopularCities();
}

// ============================================================================
// WEATHER EXCEPTION
// ============================================================================
///
/// Custom exception cho Weather errors.
///
/// Tại sao cần custom exception?
/// - Phân biệt với các lỗi khác
/// - Chứa thông tin cụ thể (city, API error code)
/// - Dễ handle ở UI layer
///
// ============================================================================

class WeatherException implements Exception {
  final String message;
  final String? city;
  final int? statusCode;

  const WeatherException(this.message, {this.city, this.statusCode});

  @override
  String toString() => 'WeatherException: $message';

  /// Check nếu là lỗi không tìm thấy thành phố.
  bool get isCityNotFound => statusCode == 404;

  /// Check nếu là lỗi network.
  bool get isNetworkError => statusCode == null;
}

// ============================================================================
// SIMULATED REPOSITORY IMPLEMENTATION
// ============================================================================
///
/// Implementation simulate API calls.
///
/// Trong production, bạn sẽ:
/// 1. Gọi HTTP API thật
/// 2. Parse JSON response
/// 3. Handle network errors
///
/// Ở đây chúng ta simulate để:
/// - Không cần API key
/// - Hoạt động offline
/// - Dễ test và demo
///
// ============================================================================

class SimulatedWeatherRepository implements WeatherRepository {
  // ==========================================================================
  // RANDOM FOR SIMULATION
  // ==========================================================================

  final _random = Random();

  // ==========================================================================
  // SIMULATED DELAY
  // ==========================================================================
  //
  // Simulate network latency để demo loading states.
  //
  // Real API sẽ có delay thật từ network.
  // ==========================================================================

  Future<void> _simulateDelay() async {
    final delay = 500 + _random.nextInt(1000); // 500-1500ms
    await Future.delayed(Duration(milliseconds: delay));
  }

  // ==========================================================================
  // SIMULATE RANDOM ERROR
  // ==========================================================================
  //
  // 10% chance of error để demo error handling.
  // ==========================================================================

  void _maybeThrowError(String city) {
    if (_random.nextInt(10) < 1) {
      // 10% chance
      throw WeatherException('Không thể kết nối server', city: city);
    }
  }

  // ==========================================================================
  // CITY DATA
  // ==========================================================================

  static const _cityData = <String, Map<String, dynamic>>{
    'hanoi': {
      'name': 'Hanoi',
      'country': 'VN',
      'baseTemp': 28.0,
      'humidity': 75,
    },
    'ho chi minh': {
      'name': 'Ho Chi Minh',
      'country': 'VN',
      'baseTemp': 32.0,
      'humidity': 70,
    },
    'da nang': {
      'name': 'Da Nang',
      'country': 'VN',
      'baseTemp': 30.0,
      'humidity': 72,
    },
    'tokyo': {
      'name': 'Tokyo',
      'country': 'JP',
      'baseTemp': 22.0,
      'humidity': 65,
    },
    'singapore': {
      'name': 'Singapore',
      'country': 'SG',
      'baseTemp': 31.0,
      'humidity': 80,
    },
    'london': {
      'name': 'London',
      'country': 'UK',
      'baseTemp': 15.0,
      'humidity': 85,
    },
    'new york': {
      'name': 'New York',
      'country': 'US',
      'baseTemp': 18.0,
      'humidity': 60,
    },
    'paris': {
      'name': 'Paris',
      'country': 'FR',
      'baseTemp': 17.0,
      'humidity': 70,
    },
    'seoul': {
      'name': 'Seoul',
      'country': 'KR',
      'baseTemp': 20.0,
      'humidity': 55,
    },
    'beijing': {
      'name': 'Beijing',
      'country': 'CN',
      'baseTemp': 23.0,
      'humidity': 50,
    },
  };

  // ==========================================================================
  // GET CURRENT WEATHER
  // ==========================================================================

  @override
  Future<Weather> getCurrentWeather(String city) async {
    await _simulateDelay();
    _maybeThrowError(city);

    final normalizedCity = city.toLowerCase().trim();
    final data = _cityData[normalizedCity];

    if (data == null) {
      throw WeatherException(
        'Không tìm thấy thành phố "$city"',
        city: city,
        statusCode: 404,
      );
    }

    // Generate random variations
    final baseTemp = data['baseTemp'] as double;
    final tempVariation = (_random.nextDouble() - 0.5) * 6; // ±3°C
    final temp = baseTemp + tempVariation;

    final conditions = WeatherCondition.values;
    final condition =
        conditions[_random.nextInt(
          conditions.length - 1,
        )]; // Exclude foggy most of the time

    return Weather(
      city: data['name'] as String,
      country: data['country'] as String,
      temperature: temp,
      feelsLike: temp + 2 + _random.nextDouble() * 2,
      tempMin: temp - 2 - _random.nextDouble() * 2,
      tempMax: temp + 2 + _random.nextDouble() * 2,
      humidity: (data['humidity'] as int) + _random.nextInt(10) - 5,
      windSpeed: 1 + _random.nextDouble() * 5,
      condition: condition,
      description: condition.displayName,
      timestamp: DateTime.now(),
    );
  }

  // ==========================================================================
  // GET FORECAST
  // ==========================================================================

  @override
  Future<List<Forecast>> getForecast(String city) async {
    await _simulateDelay();
    _maybeThrowError(city);

    final normalizedCity = city.toLowerCase().trim();
    final data = _cityData[normalizedCity];

    if (data == null) {
      throw WeatherException(
        'Không tìm thấy thành phố "$city"',
        city: city,
        statusCode: 404,
      );
    }

    final baseTemp = data['baseTemp'] as double;
    final forecasts = <Forecast>[];

    for (int i = 1; i <= 5; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final tempVariation = (_random.nextDouble() - 0.5) * 8;
      final temp = baseTemp + tempVariation;
      final conditions = WeatherCondition.values;

      forecasts.add(
        Forecast(
          dateTime: date,
          temperature: temp,
          tempMin: temp - 3,
          tempMax: temp + 3,
          condition: conditions[_random.nextInt(conditions.length)],
          precipitation: _random.nextInt(100),
        ),
      );
    }

    return forecasts;
  }

  // ==========================================================================
  // GET POPULAR CITIES
  // ==========================================================================

  @override
  List<String> getPopularCities() {
    return _cityData.values.map((data) => data['name'] as String).toList();
  }
}

// ============================================================================
// CACHING REPOSITORY WRAPPER
// ============================================================================
///
/// Decorator pattern: Wrap repository để thêm caching.
///
/// ## Tại sao cần caching?
///
/// - Giảm API calls (tiết kiệm tiền, băng thông)
/// - Faster response (không cần đợi network)
/// - Offline support (dùng cached data khi offline)
///
/// ## Cache strategy:
///
/// - Cache trong 5 phút
/// - Cache key = city name
/// - Clear cache khi cần fresh data
///
// ============================================================================

class CachedWeatherRepository implements WeatherRepository {
  final WeatherRepository _inner;

  /// Cache storage.
  final Map<String, _CacheEntry<Weather>> _weatherCache = {};
  final Map<String, _CacheEntry<List<Forecast>>> _forecastCache = {};

  /// Cache duration.
  static const _cacheDuration = Duration(minutes: 5);

  CachedWeatherRepository(this._inner);

  @override
  Future<Weather> getCurrentWeather(String city) async {
    final key = city.toLowerCase().trim();
    final cached = _weatherCache[key];

    // Check cache validity
    if (cached != null && !cached.isExpired) {
      debugPrint('📦 Cache hit for weather: $city');
      return cached.data;
    }

    // Fetch fresh data
    debugPrint('🌐 Fetching fresh weather: $city');
    final weather = await _inner.getCurrentWeather(city);

    // Store in cache
    _weatherCache[key] = _CacheEntry(weather, _cacheDuration);

    return weather;
  }

  @override
  Future<List<Forecast>> getForecast(String city) async {
    final key = city.toLowerCase().trim();
    final cached = _forecastCache[key];

    if (cached != null && !cached.isExpired) {
      debugPrint('📦 Cache hit for forecast: $city');
      return cached.data;
    }

    debugPrint('🌐 Fetching fresh forecast: $city');
    final forecast = await _inner.getForecast(city);
    _forecastCache[key] = _CacheEntry(forecast, _cacheDuration);

    return forecast;
  }

  @override
  List<String> getPopularCities() => _inner.getPopularCities();

  /// Clear all cache.
  void clearCache() {
    _weatherCache.clear();
    _forecastCache.clear();
    debugPrint('🗑️ Cache cleared');
  }

  /// Clear cache for specific city.
  void clearCityCache(String city) {
    final key = city.toLowerCase().trim();
    _weatherCache.remove(key);
    _forecastCache.remove(key);
  }
}

/// Cache entry with expiration.
class _CacheEntry<T> {
  final T data;
  final DateTime expiresAt;

  _CacheEntry(this.data, Duration duration)
    : expiresAt = DateTime.now().add(duration);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex07WeatherRepository extends StatefulWidget {
  const Ex07WeatherRepository({super.key});

  @override
  State<Ex07WeatherRepository> createState() => _Ex07WeatherRepositoryState();
}

class _Ex07WeatherRepositoryState extends State<Ex07WeatherRepository> {
  final _repository = CachedWeatherRepository(SimulatedWeatherRepository());
  final _cityController = TextEditingController(text: 'Hanoi');

  Weather? _weather;
  List<Forecast>? _forecast;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final city = _cityController.text.trim();
      final weather = await _repository.getCurrentWeather(city);
      final forecast = await _repository.getForecast(city);

      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } on WeatherException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularCities = _repository.getPopularCities();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex07: Weather Repository'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear Cache',
            onPressed: () {
              _repository.clearCache();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cache cleared!')));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '📚 Repository Pattern:\n'
              '• Abstract class định nghĩa interface\n'
              '• SimulatedWeatherRepository implement với fake data\n'
              '• CachedWeatherRepository wrap để thêm caching\n'
              '• Error handling với WeatherException',
            ),
          ),

          const SizedBox(height: 16),

          // Search
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên thành phố',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _fetchWeather(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _fetchWeather,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Fetch'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Popular cities
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularCities.map((city) {
              return ActionChip(
                label: Text(city),
                onPressed: () {
                  _cityController.text = city;
                  _fetchWeather();
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Error
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!)),
                ],
              ),
            ),

          // Weather result
          if (_weather != null) ...[
            const Text(
              '📍 Current Weather:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Card(
              child: ListTile(
                leading: Text(
                  _weather!.condition.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(
                  '${_weather!.location} - ${_weather!.temperatureRounded}°C',
                ),
                subtitle: Text(
                  '${_weather!.condition.displayName}\n'
                  'Feels: ${_weather!.feelsLikeRounded}°C | '
                  'Humidity: ${_weather!.humidity}%',
                ),
              ),
            ),
          ],

          // Forecast result
          if (_forecast != null) ...[
            const SizedBox(height: 16),
            const Text(
              '📅 5-Day Forecast:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _forecast!.length,
                itemBuilder: (_, index) {
                  final f = _forecast![index];
                  return Card(
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(f.dayOfWeek),
                          Text(
                            f.condition.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text('${f.temperature.round()}°'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
