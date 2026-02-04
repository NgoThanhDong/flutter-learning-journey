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

library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// [Weather Model]
class Weather {
  final double temperature;
  final double windSpeed;
  final int humidity;
  final DateTime time;

  const Weather({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      time: DateTime.parse(current['time'] as String),
    );
  }
}

class Ex15WeatherApp extends StatefulWidget {
  const Ex15WeatherApp({super.key});

  @override
  State<Ex15WeatherApp> createState() => _Ex15WeatherAppState();
}

class _Ex15WeatherAppState extends State<Ex15WeatherApp> {
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  // Các thành phố VN
  final _cities = [
    {'name': 'Hà Nội', 'lat': 21.03, 'lon': 105.85},
    {'name': 'TP.HCM', 'lat': 10.82, 'lon': 106.63},
    {'name': 'Đà Nẵng', 'lat': 16.07, 'lon': 108.22},
  ];
  late Map<String, dynamic> _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = _cities[0];
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final lat = _selectedCity['lat'];
      final lon = _selectedCity['lon'];

      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast'
          '?latitude=$lat&longitude=$lon'
          '&current=temperature_2m,wind_speed_10m,relative_humidity_2m',
        ),
      );

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
                DropdownButton<String>(
                  value: _selectedCity['name'],
                  items: _cities
                      .map(
                        (c) => DropdownMenuItem(
                          value: c['name'] as String,
                          child: Text(c['name'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (name) {
                    _selectedCity = _cities.firstWhere(
                      (c) => c['name'] == name,
                    );
                    _fetchWeather();
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
                _selectedCity['name'] as String,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              const Icon(Icons.wb_sunny, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                '${_weather!.temperature}°C',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfo(Icons.water_drop, '${_weather!.humidity}%'),
                  const SizedBox(width: 24),
                  _buildInfo(Icons.air, '${_weather!.windSpeed} km/h'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String value) {
    return Row(
      children: [Icon(icon, size: 20), const SizedBox(width: 4), Text(value)],
    );
  }
}
