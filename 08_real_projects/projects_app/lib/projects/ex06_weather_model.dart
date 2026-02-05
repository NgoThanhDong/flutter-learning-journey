/// ============================================================================
/// EXERCISE 06: WEATHER MODEL
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Thiết kế data models cho ứng dụng thời tiết.
///
/// 📝 BẠN SẼ HỌC:
/// - Multiple related models
/// - Enum cho weather conditions
/// - Icon và color mapping
/// - Celsius ↔ Fahrenheit conversion
/// - fromJson cho API parsing
///
/// ============================================================================
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ============================================================================
// WEATHER CONDITION ENUM
// ============================================================================
///
/// Enum đại diện cho các điều kiện thời tiết.
///
/// ## Tại sao dùng Enum?
///
/// - Type-safe: Không thể có giá trị ngoài các options
/// - IDE support: Autocomplete, exhaustive switch
/// - Clean code: Dễ đọc hơn magic strings
///
/// ## Các conditions:
/// - sunny: Trời nắng
/// - partlyCloudy: Có mây một phần
/// - cloudy: Nhiều mây
/// - rainy: Mưa
/// - stormy: Bão
/// - snowy: Tuyết
/// - foggy: Sương mù
///
// ============================================================================

enum WeatherCondition {
  sunny,
  partlyCloudy,
  cloudy,
  rainy,
  stormy,
  snowy,
  foggy;

  // ==========================================================================
  // DISPLAY NAME
  // ==========================================================================
  //
  // [displayName] là getter trả về tên hiển thị tiếng Việt.
  //
  // Switch expression (Dart 3):
  // - Ngắn gọn hơn switch statement
  // - Return value trực tiếp
  // - Exhaustive: Phải cover tất cả cases
  // ==========================================================================

  String get displayName => switch (this) {
    WeatherCondition.sunny => 'Trời nắng',
    WeatherCondition.partlyCloudy => 'Có mây',
    WeatherCondition.cloudy => 'Nhiều mây',
    WeatherCondition.rainy => 'Mưa',
    WeatherCondition.stormy => 'Bão',
    WeatherCondition.snowy => 'Tuyết',
    WeatherCondition.foggy => 'Sương mù',
  };

  // ==========================================================================
  // ICON
  // ==========================================================================
  //
  // Icon Unicode cho mỗi condition.
  //
  // Có thể dùng với Text widget:
  // Text(condition.icon, style: TextStyle(fontSize: 48))
  // ==========================================================================

  String get icon => switch (this) {
    WeatherCondition.sunny => '☀️',
    WeatherCondition.partlyCloudy => '⛅',
    WeatherCondition.cloudy => '☁️',
    WeatherCondition.rainy => '🌧️',
    WeatherCondition.stormy => '⛈️',
    WeatherCondition.snowy => '❄️',
    WeatherCondition.foggy => '🌫️',
  };

  // ==========================================================================
  // BACKGROUND COLORS
  // ==========================================================================
  //
  // Gradient colors cho background dựa trên condition.
  //
  // Trả về List<Color> để dùng với LinearGradient.
  // ==========================================================================

  List<Color> get gradientColors => switch (this) {
    WeatherCondition.sunny => [
      const Color(0xFFFFB347), // Orange
      const Color(0xFFFFCC33), // Yellow
    ],
    WeatherCondition.partlyCloudy => [
      const Color(0xFF87CEEB), // Sky blue
      const Color(0xFFFFA500), // Orange
    ],
    WeatherCondition.cloudy => [
      const Color(0xFF87CEEB), // Sky blue
      const Color(0xFFB0C4DE), // Light steel blue
    ],
    WeatherCondition.rainy => [
      const Color(0xFF4A6FA5), // Steel blue
      const Color(0xFF2C3E50), // Dark blue
    ],
    WeatherCondition.stormy => [
      const Color(0xFF2C3E50), // Dark blue
      const Color(0xFF1A1A2E), // Dark navy
    ],
    WeatherCondition.snowy => [
      const Color(0xFFE0E0E0), // Light grey
      const Color(0xFFFFFFFF), // White
    ],
    WeatherCondition.foggy => [
      const Color(0xFFBDBDBD), // Grey
      const Color(0xFF757575), // Dark grey
    ],
  };

  // ==========================================================================
  // FROM STRING
  // ==========================================================================
  //
  // Parse string từ API thành enum.
  //
  // API có thể trả về: "Clear", "Clouds", "Rain", etc.
  // ==========================================================================

  static WeatherCondition fromString(String condition) {
    final normalized = condition.toLowerCase();
    return switch (normalized) {
      'clear' || 'sunny' => WeatherCondition.sunny,
      'few clouds' || 'partly cloudy' => WeatherCondition.partlyCloudy,
      'clouds' || 'cloudy' || 'overcast' => WeatherCondition.cloudy,
      'rain' || 'rainy' || 'drizzle' || 'shower' => WeatherCondition.rainy,
      'thunderstorm' || 'storm' || 'stormy' => WeatherCondition.stormy,
      'snow' || 'snowy' => WeatherCondition.snowy,
      'mist' || 'fog' || 'foggy' || 'haze' => WeatherCondition.foggy,
      _ => WeatherCondition.cloudy, // Default
    };
  }
}

// ============================================================================
// WEATHER MODEL
// ============================================================================
///
/// Model đại diện cho dữ liệu thời tiết hiện tại.
///
// ============================================================================

class Weather extends Equatable {
  // ==========================================================================
  // PROPERTIES
  // ==========================================================================

  /// Tên thành phố.
  final String city;

  /// Tên quốc gia (optional).
  final String? country;

  /// Nhiệt độ hiện tại (Celsius).
  final double temperature;

  /// Nhiệt độ cảm nhận (Celsius).
  final double feelsLike;

  /// Nhiệt độ thấp nhất trong ngày.
  final double tempMin;

  /// Nhiệt độ cao nhất trong ngày.
  final double tempMax;

  /// Độ ẩm tương đối (%).
  final int humidity;

  /// Tốc độ gió (m/s).
  final double windSpeed;

  /// Điều kiện thời tiết.
  final WeatherCondition condition;

  /// Mô tả chi tiết (từ API).
  final String description;

  /// Thời điểm lấy data.
  final DateTime timestamp;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const Weather({
    required this.city,
    this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.timestamp,
  });

  // ==========================================================================
  // COMPUTED PROPERTIES
  // ==========================================================================

  /// Nhiệt độ làm tròn (integer).
  int get temperatureRounded => temperature.round();

  /// Nhiệt độ cảm nhận làm tròn.
  int get feelsLikeRounded => feelsLike.round();

  /// Convert sang Fahrenheit.
  double get temperatureFahrenheit => (temperature * 9 / 5) + 32;

  /// Location string với country (nếu có).
  String get location => country != null ? '$city, $country' : city;

  /// Thời gian update (format HH:mm).
  String get lastUpdated {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // ==========================================================================
  // FROM JSON
  // ==========================================================================
  //
  // Parse từ OpenWeatherMap API response.
  //
  // Response structure:
  // {
  //   "name": "Hanoi",
  //   "sys": {"country": "VN"},
  //   "main": {
  //     "temp": 28.5,
  //     "feels_like": 32.0,
  //     "temp_min": 26.0,
  //     "temp_max": 30.0,
  //     "humidity": 75
  //   },
  //   "wind": {"speed": 3.5},
  //   "weather": [{"main": "Clouds", "description": "scattered clouds"}]
  // }
  // ==========================================================================

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>?;
    final weatherList = json['weather'] as List<dynamic>;
    final weatherData = weatherList.first as Map<String, dynamic>;

    return Weather(
      city: json['name'] as String,
      country: sys?['country'] as String?,
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      condition: WeatherCondition.fromString(weatherData['main'] as String),
      description: weatherData['description'] as String,
      timestamp: DateTime.now(),
    );
  }

  // ==========================================================================
  // SAMPLE DATA (for demo/testing)
  // ==========================================================================

  factory Weather.sample({String city = 'Hanoi'}) {
    return Weather(
      city: city,
      country: 'VN',
      temperature: 28.5,
      feelsLike: 32.0,
      tempMin: 26.0,
      tempMax: 30.0,
      humidity: 75,
      windSpeed: 3.5,
      condition: WeatherCondition.partlyCloudy,
      description: 'Có mây một phần',
      timestamp: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    city,
    country,
    temperature,
    feelsLike,
    tempMin,
    tempMax,
    humidity,
    windSpeed,
    condition,
    description,
    timestamp,
  ];
}

// ============================================================================
// FORECAST MODEL
// ============================================================================
///
/// Model đại diện cho dự báo thời tiết (1 ngày/giờ).
///
// ============================================================================

class Forecast extends Equatable {
  /// Thời điểm dự báo.
  final DateTime dateTime;

  /// Nhiệt độ dự báo.
  final double temperature;

  /// Nhiệt độ thấp nhất (if daily forecast).
  final double? tempMin;

  /// Nhiệt độ cao nhất (if daily forecast).
  final double? tempMax;

  /// Điều kiện thời tiết.
  final WeatherCondition condition;

  /// Xác suất mưa (0-100%).
  final int? precipitation;

  const Forecast({
    required this.dateTime,
    required this.temperature,
    this.tempMin,
    this.tempMax,
    required this.condition,
    this.precipitation,
  });

  /// Ngày trong tuần (T2, T3, ...).
  String get dayOfWeek {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return days[dateTime.weekday % 7];
  }

  /// Ngày/tháng format.
  String get dateFormatted {
    return '${dateTime.day}/${dateTime.month}';
  }

  /// Giờ format (for hourly forecast).
  String get hourFormatted {
    return '${dateTime.hour}:00';
  }

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weatherList = json['weather'] as List<dynamic>;
    final weatherData = weatherList.first as Map<String, dynamic>;

    return Forecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperature: (main['temp'] as num).toDouble(),
      tempMin: (main['temp_min'] as num?)?.toDouble(),
      tempMax: (main['temp_max'] as num?)?.toDouble(),
      condition: WeatherCondition.fromString(weatherData['main'] as String),
      precipitation: json['pop'] != null
          ? ((json['pop'] as num) * 100).round()
          : null,
    );
  }

  @override
  List<Object?> get props => [
    dateTime,
    temperature,
    tempMin,
    tempMax,
    condition,
    precipitation,
  ];
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex06WeatherModel extends StatelessWidget {
  const Ex06WeatherModel({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleWeather = Weather.sample();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex06: Weather Model'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            '🌦️ Weather Model Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Sample Weather Card
          _WeatherCard(weather: sampleWeather),

          const SizedBox(height: 24),

          // Weather Conditions
          const Text(
            '🌤️ Weather Conditions:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: WeatherCondition.values.map((condition) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: condition.gradientColors),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(condition.icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      condition.displayName,
                      style: TextStyle(
                        color: condition == WeatherCondition.snowy
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Forecast Demo
          const Text(
            '📅 5-Day Forecast:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                final conditions = WeatherCondition.values;
                final forecast = Forecast(
                  dateTime: DateTime.now().add(Duration(days: index)),
                  temperature: 25 + (index * 1.5 - 3),
                  condition: conditions[index % conditions.length],
                );
                return _ForecastCard(forecast: forecast);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Weather weather;

  const _WeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: weather.condition.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: weather.condition.gradientColors.first.withAlpha(128),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 20),
              const SizedBox(width: 4),
              Text(
                weather.location,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Temperature & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temperatureRounded}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    weather.condition.displayName,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
              Text(
                weather.condition.icon,
                style: const TextStyle(fontSize: 80),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeatherDetail(
                icon: Icons.thermostat,
                label: 'Cảm giác',
                value: '${weather.feelsLikeRounded}°',
              ),
              _WeatherDetail(
                icon: Icons.water_drop,
                label: 'Độ ẩm',
                value: '${weather.humidity}%',
              ),
              _WeatherDetail(
                icon: Icons.air,
                label: 'Gió',
                value: '${weather.windSpeed}m/s',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const _ForecastCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            forecast.dayOfWeek,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(forecast.condition.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            '${forecast.temperature.round()}°',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
