/// ===========================================
/// EXERCISE 17: WEATHER APP (BLOC)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xây dựng ứng dụng Thời tiết với BLoC
/// - Input: Tên thành phố (Events: GetWeather)
/// - Output: Nhiệt độ + Mô tả (States: Loading, Loaded, Error)
/// - Giả lập API call
///
/// 📝 Pattern:
/// Initial -> Loading -> Loaded(Weather) -> UI

library;

import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. MODEL
class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String description;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
  });

  @override
  List<Object> get props => [cityName, temperature, description];
}

/// 2. EVENTS
sealed class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object> get props => [];
}

class GetWeather extends WeatherEvent {
  final String cityName;
  const GetWeather(this.cityName);
  @override
  List<Object> get props => [cityName];
}

class ResetWeather extends WeatherEvent {}

/// 3. STATES
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

/// 4. BLOC
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<GetWeather>(_onGetWeather);
    on<ResetWeather>((event, emit) => emit(WeatherInitial()));
  }

  Future<void> _onGetWeather(
    GetWeather event,
    Emitter<WeatherState> emit,
  ) async {
    if (event.cityName.isEmpty) {
      emit(const WeatherError('Please enter a city name'));
      return;
    }

    emit(WeatherLoading());

    try {
      // Simulate API Delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate Data Fetching & Random Error
      if (event.cityName.toLowerCase() == 'error') {
        throw Exception('Simulated API Error');
      }

      final randomTemp = 20 + Random().nextInt(15) + Random().nextDouble();
      final weather = Weather(
        cityName: event.cityName,
        temperature: double.parse(randomTemp.toStringAsFixed(1)),
        description: randomTemp > 25 ? 'Sunny ☀️' : 'Cloudy ☁️',
      );

      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(const WeatherError('Could not fetch weather. Try again.'));
    }
  }
}

/// 5. UI
class Ex17WeatherBloc extends StatelessWidget {
  const Ex17WeatherBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Ex17: Weather App (BLoC)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Trigger Event
                    context
                        .read<WeatherBloc>()
                        .add(GetWeather(cityController.text));
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                context.read<WeatherBloc>().add(GetWeather(value));
              },
            ),
            const SizedBox(height: 10),
            const Text('Note: Enter "error" to simulate failure',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),

            // Content Area
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  /// INITIAL
                  if (state is WeatherInitial) {
                    return const Center(
                        child: Text('Enter a city to see weather'));
                  }

                  /// LOADING
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  /// LOADED
                  if (state is WeatherLoaded) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.weather.cityName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${state.weather.temperature}°C',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.weather.description,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<WeatherBloc>().add(ResetWeather()),
                            child: const Text('Search Another'),
                          ),
                        ],
                      ),
                    );
                  }

                  /// ERROR
                  if (state is WeatherError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 60, color: Colors.red),
                          const SizedBox(height: 10),
                          Text(state.message,
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
