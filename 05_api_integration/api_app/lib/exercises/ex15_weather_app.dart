/// ===========================================
/// EXERCISE 15: WEATHER APP
/// ===========================================
/// 🎯 Mục tiêu:
/// - Thực hành gọi real API (Open-Meteo)
/// - Parse complex JSON response
/// - Hiển thị weather data với UI đẹp
///
/// 📝 API: Open-Meteo (Free, no API key)
/// GET https://api.open-meteo.com/v1/forecast
///   ?latitude=21.03&longitude=105.85
///   &current=temperature_2m,wind_speed_10m,relative_humidity_2m
/// 
/// {"latitude":21.0,"longitude":105.875,"generationtime_ms":0.04839897155761719,
/// "utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":24.0,
/// "current_units":{"time":"iso8601","interval":"seconds","temperature_2m":"°C",
/// "wind_speed_10m":"km/h","relative_humidity_2m":"%"},
/// "current":{"time":"2026-02-05T00:45","interval":900,"temperature_2m":17.9,
/// "wind_speed_10m":1.3,"relative_humidity_2m":96}}

library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// [Weather Model]
class Weather {
  final double temperature; // nhiệt độ
  final double windSpeed; // tốc độ gió
  final int humidity; // độ ẩm
  final DateTime time; // thời gian

  const Weather({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.time,
  });

  // Parse JSON response from API response to Weather object
  factory Weather.fromJson(Map<String, dynamic> json) {
    // Get current weather data
    final current = json['current'] as Map<String, dynamic>;
    // Parse data
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      time: DateTime.parse(current['time'] as String),
    );
  }
}

/// [Weather App] là một ứng dụng hiển thị thông tin thời tiết
class Ex15WeatherApp extends StatefulWidget {
  const Ex15WeatherApp({super.key});

  @override
  State<Ex15WeatherApp> createState() => _Ex15WeatherAppState();
}

class _Ex15WeatherAppState extends State<Ex15WeatherApp> {
  Weather? _weather; // dữ liệu thời tiết
  bool _isLoading = false; // trạng thái loading
  String? _error; // thông báo lỗi

  // Các thành phố VN
  final _cities = [
    {'name': 'Hà Nội', 'lat': 21.03, 'lon': 105.85},
    {'name': 'TP.HCM', 'lat': 10.82, 'lon': 106.63},
    {'name': 'Đà Nẵng', 'lat': 16.07, 'lon': 108.22},
  ];
  late Map<String, dynamic> _selectedCity; // thành phố đã chọn

  @override
  void initState() {
    super.initState();
    _selectedCity = _cities[0]; // default city
    _fetchWeather(); // fetch weather data when app starts
  }

  /// Fetch weather data from API
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final lat = _selectedCity['lat']; // latitude (vĩ độ)
      final lon = _selectedCity['lon']; // longitude (kinh độ)

      // Fetch weather data from API
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast'
          '?latitude=$lat&longitude=$lon'
          '&current=temperature_2m,wind_speed_10m,relative_humidity_2m',
        ),
      );

      // Parse response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _weather = Weather.fromJson(json);
      } else {
        throw Exception('Status: ${response.statusCode}');
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex15: Weather App')),
      body: Column(
        children: [
          // City selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Thành phố: '),
                const SizedBox(width: 8),

                // Dropdown button to select city
                DropdownButton<String>(
                  value: _selectedCity['name'], // default value (Hà Nội)
                  // Dropdown items là các thành phố có trong _cities
                  items: _cities
                      .map(
                        (c) => DropdownMenuItem(
                          value: c['name'] as String,
                          child: Text(c['name'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (name) {
                    // Update selected city
                    _selectedCity = _cities.firstWhere(
                      (c) => c['name'] == name,
                    );
                    _fetchWeather(); // Fetch weather data when city changes
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /// Build content widget là widget hiển thị thông tin thời tiết
  Widget _buildContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_weather == null) return const Center(child: Text('No data'));

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedCity['name'] as String, // Tên thành phố
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              const Icon(Icons.wb_sunny, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                '${_weather!.temperature}°C', // Nhiệt độ
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Độ ẩm
                  _buildInfo(Icons.water_drop, '${_weather!.humidity}%'),
                  const SizedBox(width: 24),
                  // Tốc độ gió
                  _buildInfo(Icons.air, '${_weather!.windSpeed} km/h'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build info widget là widget hiển thị thông tin
  Widget _buildInfo(IconData icon, String value) {
    return Row(
      children: [Icon(icon, size: 20), const SizedBox(width: 4), Text(value)],
    );
  }
}
