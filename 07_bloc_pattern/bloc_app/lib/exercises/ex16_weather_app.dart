/// ============================================================================
/// EXERCISE 16: WEATHER APP (API PATTERN WITH BLOC)
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - BLoC với API integration pattern
/// - Loading, Success, Error states
/// - Repository pattern (simulated)
///
/// 📝 ARCHITECTURE:
/// UI → BLoC → Repository → API (simulated)
///
/// ============================================================================
library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// WEATHER MODEL
// ============================================================================
class Weather extends Equatable {
  final String city;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;

  const Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  List<Object> get props => [city, temperature, condition, humidity, windSpeed];
}

// ============================================================================
// WEATHER REPOSITORY (SIMULATED)
// ============================================================================
class WeatherRepository {
  // Simulate API call
  Future<Weather> getWeather(String city) async {
    await Future.delayed(const Duration(seconds: 1));

    // Random failure (20% chance)
    if (Random().nextInt(10) < 2) {
      throw Exception('Failed to fetch weather for $city');
    }

    // Simulated weather data
    final conditions = ['Sunny', 'Cloudy', 'Rainy', 'Stormy', 'Snowy'];
    return Weather(
      city: city,
      temperature: 15 + Random().nextInt(20).toDouble(),
      condition: conditions[Random().nextInt(conditions.length)],
      humidity: 40 + Random().nextInt(50),
      windSpeed: Random().nextDouble() * 20,
    );
  }
}

// ============================================================================
// EVENTS
// ============================================================================
sealed class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String city;
  const FetchWeather(this.city);
  @override
  List<Object> get props => [city];
}

// ============================================================================
// STATES
// ============================================================================
sealed class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  const WeatherLoaded(this.weather);
  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
  @override
  List<Object> get props => [message];
}

// ============================================================================
// BLOC
// ============================================================================
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc({required this.repository}) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      final weather = await repository.getWeather(event.city);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex16WeatherApp extends StatelessWidget {
  const Ex16WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ========================================================================
    // REPOSITORY PROVIDER
    // ========================================================================
    //
    // RepositoryProvider: Cung cấp repository cho widget tree
    //
    // Tại sao dùng?
    // - Tách biệt data layer (repository) khỏi presentation (BLoC)
    // - BLoC có thể access repository qua context.read
    // - Dễ dàng mock repository khi test
    // ========================================================================
    return RepositoryProvider(
      create: (_) => WeatherRepository(),
      child: BlocProvider(
        create: (context) => WeatherBloc(
          repository: context.read<WeatherRepository>(),
        ),
        child: const _WeatherView(),
      ),
    );
  }
}

class _WeatherView extends StatefulWidget {
  const _WeatherView();

  @override
  State<_WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<_WeatherView> {
  final _controller = TextEditingController(text: 'Hanoi');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex16: Weather App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ================================================================
            // SEARCH INPUT
            // ================================================================
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter city name...',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.read<WeatherBloc>().add(FetchWeather(value));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final city = _controller.text.trim();
                    if (city.isNotEmpty) {
                      context.read<WeatherBloc>().add(FetchWeather(city));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================================================================
            // WEATHER DISPLAY
            // ================================================================
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  return switch (state) {
                    WeatherInitial() => const _InitialWidget(),
                    WeatherLoading() => const _LoadingWidget(),
                    WeatherLoaded(:final weather) =>
                      _WeatherCard(weather: weather),
                    WeatherError(:final message) =>
                      _ErrorWidget(message: message),
                  };
                },
              ),
            ),

            // ================================================================
            // EXPLANATION
            // ================================================================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 Pattern: UI → BLoC → Repository → API\n'
                '• 20% chance of simulated error\n'
                '• States: Initial, Loading, Loaded, Error',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialWidget extends StatelessWidget {
  const _InitialWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Nhập tên thành phố để xem thời tiết'),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải dữ liệu...'),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Lỗi: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          const Text('Thử lại với thành phố khác'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weather.city,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Icon(
              _getWeatherIcon(weather.condition),
              size: 80,
              color: _getWeatherColor(weather.condition),
            ),
            const SizedBox(height: 8),
            Text(
              weather.condition,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoChip(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                ),
                _InfoChip(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition) {
      case 'Sunny':
        return Icons.wb_sunny;
      case 'Cloudy':
        return Icons.cloud;
      case 'Rainy':
        return Icons.water_drop;
      case 'Stormy':
        return Icons.thunderstorm;
      case 'Snowy':
        return Icons.ac_unit;
      default:
        return Icons.cloud;
    }
  }

  Color _getWeatherColor(String condition) {
    switch (condition) {
      case 'Sunny':
        return Colors.orange;
      case 'Cloudy':
        return Colors.grey;
      case 'Rainy':
        return Colors.blue;
      case 'Stormy':
        return Colors.purple;
      case 'Snowy':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
