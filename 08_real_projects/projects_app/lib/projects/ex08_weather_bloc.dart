/// ============================================================================
/// EXERCISE 08: WEATHER BLOC
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Học BLoC pattern với Events (thay vì Cubit).
///
/// 📝 BẠN SẼ HỌC:
/// - Tạo Events cho mỗi action
/// - Định nghĩa States đầy đủ
/// - Event handlers với `on<Event>`
/// - Khi nào dùng BLoC vs Cubit
/// - Debounce search với Transformer
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'ex06_weather_model.dart';
import 'ex07_weather_repository.dart';

// ============================================================================
// WEATHER EVENTS
// ============================================================================
///
/// ## BLoC vs Cubit - Khi nào dùng?
///
/// **Cubit** (như Notes App):
/// - Logic đơn giản
/// - Gọi method trực tiếp: `cubit.addNote()`
/// - Ít boilerplate
///
/// **BLoC** (như Weather App):
/// - Logic phức tạp
/// - Cần log/debug events
/// - Cần transform events (debounce, throttle)
/// - Có nhiều async operations
///
/// ## Event Pattern:
///
/// ```
/// User Action → Event → BLoC Handler → State
///
/// Tap "Search" → WeatherFetchRequested("Hanoi")
///                        ↓
///              BLoC.on<WeatherFetchRequested>
///                        ↓
///              emit(WeatherLoading)
///              await repository.getWeather()
///              emit(WeatherSuccess) or emit(WeatherFailure)
/// ```
///
// ============================================================================

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Event: Yêu cầu lấy thời tiết của thành phố.
///
/// Gửi khi user search hoặc chọn thành phố.
class WeatherFetchRequested extends WeatherEvent {
  /// Tên thành phố cần lấy thời tiết.
  final String city;

  const WeatherFetchRequested(this.city);

  @override
  List<Object?> get props => [city];
}

/// Event: Yêu cầu refresh data (pull-to-refresh).
///
/// Giữ nguyên thành phố hiện tại, chỉ fetch lại data.
class WeatherRefreshRequested extends WeatherEvent {
  const WeatherRefreshRequested();
}

/// Event: Xóa data và quay về trạng thái ban đầu.
class WeatherCleared extends WeatherEvent {
  const WeatherCleared();
}

// ============================================================================
// WEATHER STATES
// ============================================================================
///
/// Sealed class đảm bảo:
/// - Tất cả states được định nghĩa trong file này
/// - Pattern matching exhaustive
/// - Compile-time check cho missing cases
///
// ============================================================================

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu - chưa có data.
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// Đang loading data.
///
/// [city] thành phố đang fetch (để show trên UI).
/// [previousWeather] data cũ (nếu có) để show trong khi loading.
class WeatherLoading extends WeatherState {
  final String city;
  final Weather? previousWeather;

  const WeatherLoading({required this.city, this.previousWeather});

  @override
  List<Object?> get props => [city, previousWeather];
}

/// Load thành công, có data.
class WeatherSuccess extends WeatherState {
  final Weather weather;
  final List<Forecast>? forecast;

  const WeatherSuccess({required this.weather, this.forecast});

  @override
  List<Object?> get props => [weather, forecast];
}

/// Load thất bại.
class WeatherFailure extends WeatherState {
  final String message;
  final String city;
  final Weather? previousWeather; // Giữ data cũ nếu có

  const WeatherFailure({
    required this.message,
    required this.city,
    this.previousWeather,
  });

  @override
  List<Object?> get props => [message, city, previousWeather];
}

// ============================================================================
// WEATHER BLOC
// ============================================================================
///
/// BLoC xử lý weather events và emit states.
///
/// ## Dependencies:
/// - WeatherRepository: Lấy data từ API
///
/// ## Event Handlers:
/// - `on<WeatherFetchRequested>`: Fetch weather cho city
/// - `on<WeatherRefreshRequested>`: Refresh current city
/// - `on<WeatherCleared>`: Clear data
///
// ============================================================================

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  // ==========================================================================
  // DEPENDENCIES
  // ==========================================================================

  final WeatherRepository repository;

  // ==========================================================================
  // CURRENT CITY (for refresh)
  // ==========================================================================
  //
  // Lưu city hiện tại để dùng khi refresh.
  // ==========================================================================

  String? _currentCity;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================
  //
  // Khác với Cubit:
  // - Cubit: Không có event handlers
  // - BLoC: Register handlers với on<Event>
  //
  // Phải register TẤT CẢ events ở constructor.
  // ==========================================================================

  WeatherBloc({required this.repository}) : super(const WeatherInitial()) {
    // Register event handlers
    on<WeatherFetchRequested>(_onFetchRequested);
    on<WeatherRefreshRequested>(_onRefreshRequested);
    on<WeatherCleared>(_onCleared);
  }

  // ==========================================================================
  // HANDLER: FETCH REQUESTED
  // ==========================================================================
  //
  // Xử lý khi user search thành phố.
  //
  // Flow:
  // 1. Validate input
  // 2. Emit Loading state
  // 3. Fetch weather từ repository
  // 4. Fetch forecast
  // 5. Emit Success hoặc Failure
  //
  // [event] chứa thông tin từ user (city name).
  // [emit] function để emit states.
  //
  // Lưu ý: Handler phải là async để await API calls.
  // ==========================================================================

  Future<void> _onFetchRequested(
    WeatherFetchRequested event,
    Emitter<WeatherState> emit,
  ) async {
    final city = event.city.trim();

    // Validate
    if (city.isEmpty) {
      emit(
        const WeatherFailure(message: 'Vui lòng nhập tên thành phố', city: ''),
      );
      return;
    }

    // Get previous data for optimistic UI
    Weather? previousWeather;
    if (state is WeatherSuccess) {
      previousWeather = (state as WeatherSuccess).weather;
    }

    // Emit loading
    emit(WeatherLoading(city: city, previousWeather: previousWeather));

    try {
      // Fetch weather
      final weather = await repository.getCurrentWeather(city);

      // Save current city
      _currentCity = city;

      // Fetch forecast (parallel would be better, but sequential for clarity)
      List<Forecast>? forecast;
      try {
        forecast = await repository.getForecast(city);
      } catch (_) {
        // Forecast optional, don't fail if it fails
        debugPrint('Forecast fetch failed, continuing without it');
      }

      // Emit success
      emit(WeatherSuccess(weather: weather, forecast: forecast));
    } on WeatherException catch (e) {
      emit(
        WeatherFailure(
          message: e.message,
          city: city,
          previousWeather: previousWeather,
        ),
      );
    } catch (e) {
      emit(
        WeatherFailure(
          message: 'Lỗi không xác định: $e',
          city: city,
          previousWeather: previousWeather,
        ),
      );
    }
  }

  // ==========================================================================
  // HANDLER: REFRESH REQUESTED
  // ==========================================================================
  //
  // Xử lý pull-to-refresh.
  //
  // Dùng _currentCity đã lưu, không cần user nhập lại.
  // ==========================================================================

  Future<void> _onRefreshRequested(
    WeatherRefreshRequested event,
    Emitter<WeatherState> emit,
  ) async {
    if (_currentCity == null || _currentCity!.isEmpty) {
      return; // Nothing to refresh
    }

    // Reuse fetch logic
    add(WeatherFetchRequested(_currentCity!));
  }

  // ==========================================================================
  // HANDLER: CLEARED
  // ==========================================================================
  //
  // Reset về trạng thái ban đầu.
  // ==========================================================================

  void _onCleared(WeatherCleared event, Emitter<WeatherState> emit) {
    _currentCity = null;
    emit(const WeatherInitial());
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex08WeatherBloc extends StatelessWidget {
  const Ex08WeatherBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherBloc(
        repository: CachedWeatherRepository(SimulatedWeatherRepository()),
      ),
      child: const _WeatherBlocDemo(),
    );
  }
}

class _WeatherBlocDemo extends StatefulWidget {
  const _WeatherBlocDemo();

  @override
  State<_WeatherBlocDemo> createState() => _WeatherBlocDemoState();
}

class _WeatherBlocDemoState extends State<_WeatherBlocDemo> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex08: Weather BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
            onPressed: () {
              context.read<WeatherBloc>().add(const WeatherCleared());
              _controller.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Explanation
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.green.shade50,
            child: const Text(
              '📚 BLoC Pattern:\n'
              '• Events: WeatherFetchRequested, WeatherRefreshRequested, WeatherCleared\n'
              '• States: Initial, Loading, Success, Failure\n'
              '• Handlers: on<Event> để xử lý từng event',
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập thành phố (Hanoi, Tokyo, London...)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (value) {
                      context.read<WeatherBloc>().add(
                        WeatherFetchRequested(value),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<WeatherBloc>().add(
                      WeatherFetchRequested(_controller.text),
                    );
                  },
                ),
              ],
            ),
          ),

          // Quick cities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: ['Hanoi', 'Tokyo', 'London', 'New York'].map((city) {
                return ActionChip(
                  label: Text(city),
                  onPressed: () {
                    _controller.text = city;
                    context.read<WeatherBloc>().add(
                      WeatherFetchRequested(city),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          const Divider(height: 32),

          // State display
          Expanded(
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                return switch (state) {
                  WeatherInitial() => const _InitialView(),
                  WeatherLoading() => _LoadingView(state: state),
                  WeatherSuccess() => _SuccessView(state: state),
                  WeatherFailure() => _FailureView(state: state),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Nhập tên thành phố để xem thời tiết'),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  final WeatherLoading state;

  const _LoadingView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('Đang tìm thời tiết cho "${state.city}"...'),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final WeatherSuccess state;

  const _SuccessView({required this.state});

  @override
  Widget build(BuildContext context) {
    final weather = state.weather;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<WeatherBloc>().add(const WeatherRefreshRequested());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Main weather card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: weather.condition.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  weather.condition.icon,
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 8),
                Text(
                  '${weather.temperatureRounded}°C',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  weather.location,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  weather.condition.displayName,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Details
          Row(
            children: [
              Expanded(
                child: _DetailCard(
                  icon: Icons.thermostat,
                  label: 'Cảm giác',
                  value: '${weather.feelsLikeRounded}°C',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailCard(
                  icon: Icons.water_drop,
                  label: 'Độ ẩm',
                  value: '${weather.humidity}%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailCard(
                  icon: Icons.air,
                  label: 'Gió',
                  value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                ),
              ),
            ],
          ),

          // Forecast
          if (state.forecast != null) ...[
            const SizedBox(height: 24),
            const Text(
              '📅 Dự báo 5 ngày',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.forecast!.length,
                itemBuilder: (_, index) {
                  final f = state.forecast![index];
                  return Card(
                    child: Container(
                      width: 72,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            f.dayOfWeek,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  final WeatherFailure state;

  const _FailureView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<WeatherBloc>().add(
                WeatherFetchRequested(state.city),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
