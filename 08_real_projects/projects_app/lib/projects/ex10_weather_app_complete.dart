/// ============================================================================
/// EXERCISE 10: WEATHER APP COMPLETE
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Ghép tất cả components thành Weather App hoàn chỉnh.
///
/// 📝 BẠN SẼ HỌC:
/// - Dependency Injection với get_it
/// - App initialization
/// - BlocProvider setup
/// - Pull-to-refresh
/// - Recent searches (local storage)
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'ex06_weather_model.dart';
import 'ex07_weather_repository.dart';
import 'ex08_weather_bloc.dart';
import 'ex09_weather_ui.dart';

// ============================================================================
// DEPENDENCY INJECTION SETUP
// ============================================================================
///
/// /// get_it là Service Locator pattern để quản lý dependencies.
///
/// ## Tại sao dùng get_it?
///
/// 1. **Decoupling**: Classes không tạo dependencies trực tiếp
/// 2. **Testability**: Dễ inject mocks cho testing
/// 3. **Singleton management**: Quản lý lifecycle tự động
///
/// ## Registration types:
///
/// - `registerSingleton`: Tạo ngay, 1 instance cho toàn app
/// - `registerLazySingleton`: Tạo khi cần lần đầu, rồi reuse
/// - `registerFactory`: Tạo mới mỗi lần get
///
// ============================================================================

final weatherGetIt = GetIt.instance;

/// Setup dependencies cho Weather App.
///
/// Gọi method này TRƯỚC khi chạy app.
Future<void> setupWeatherDependencies() async {
  // SharedPreferences cho recent searches
  final prefs = await SharedPreferences.getInstance();
  weatherGetIt.registerSingleton<SharedPreferences>(prefs);

  // Repository: Lazy singleton - tạo khi cần
  weatherGetIt.registerLazySingleton<WeatherRepository>(
    () => CachedWeatherRepository(SimulatedWeatherRepository()),
  );

  // BLoC: Factory - tạo mới mỗi lần (cho mỗi screen)
  weatherGetIt.registerFactory<WeatherBloc>(
    () => WeatherBloc(repository: weatherGetIt<WeatherRepository>()),
  );

  // Recent searches manager
  weatherGetIt.registerLazySingleton<RecentSearchesManager>(
    () => RecentSearchesManager(weatherGetIt<SharedPreferences>()),
  );
}

// ============================================================================
// RECENT SEARCHES MANAGER
// ============================================================================
///
/// Quản lý danh sách thành phố đã search gần đây.
///
// ============================================================================

class RecentSearchesManager {
  final SharedPreferences _prefs;
  static const _key = 'weather_recent_searches';
  static const _maxRecent = 5;

  RecentSearchesManager(this._prefs);

  /// Lấy danh sách recent searches.
  List<String> getRecent() {
    return _prefs.getStringList(_key) ?? [];
  }

  /// Thêm thành phố vào recent.
  Future<void> addRecent(String city) async {
    final recent = getRecent();

    // Remove if already exists
    recent.remove(city);

    // Add at beginning
    recent.insert(0, city);

    // Keep max items
    if (recent.length > _maxRecent) {
      recent.removeLast();
    }

    await _prefs.setStringList(_key, recent);
  }

  /// Xóa thành phố khỏi recent.
  Future<void> removeRecent(String city) async {
    final recent = getRecent();
    recent.remove(city);
    await _prefs.setStringList(_key, recent);
  }

  /// Xóa tất cả recent.
  Future<void> clearRecent() async {
    await _prefs.remove(_key);
  }
}

// ============================================================================
// WEATHER APP - MAIN WIDGET
// ============================================================================

class Ex10WeatherAppComplete extends StatefulWidget {
  const Ex10WeatherAppComplete({super.key});

  @override
  State<Ex10WeatherAppComplete> createState() => _Ex10WeatherAppCompleteState();
}

class _Ex10WeatherAppCompleteState extends State<Ex10WeatherAppComplete> {
  bool _isInitialized = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Only setup if not already done
      if (!weatherGetIt.isRegistered<WeatherRepository>()) {
        await setupWeatherDependencies();
      }
      setState(() => _isInitialized = true);
    } catch (e) {
      setState(() => _initError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Initialization error: $_initError')),
        ),
      );
    }

    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return BlocProvider(
      create: (_) => weatherGetIt<WeatherBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        home: const _WeatherHomePage(),
      ),
    );
  }
}

// ============================================================================
// HOME PAGE
// ============================================================================

class _WeatherHomePage extends StatefulWidget {
  const _WeatherHomePage();

  @override
  State<_WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<_WeatherHomePage> {
  final _searchController = TextEditingController();
  late final RecentSearchesManager _recentManager;

  @override
  void initState() {
    super.initState();
    _recentManager = weatherGetIt<RecentSearchesManager>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String city) {
    if (city.trim().isEmpty) return;

    context.read<WeatherBloc>().add(WeatherFetchRequested(city));
    _recentManager.addRecent(city.trim());
    setState(() {}); // Update recent list
  }

  @override
  Widget build(BuildContext context) {
    final popularCities = weatherGetIt<WeatherRepository>().getPopularCities();
    final recentCities = _recentManager.getRecent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌦️ Weather'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: WeatherSearchBar(
              controller: _searchController,
              onSearch: () => _search(_searchController.text),
              suggestions: recentCities.isEmpty
                  ? popularCities.take(5).toList()
                  : recentCities,
              onSuggestionTap: (city) {
                _searchController.text = city;
                _search(city);
              },
            ),
          ),

          // Content
          Expanded(
            child: BlocConsumer<WeatherBloc, WeatherState>(
              listener: (context, state) {
                // Add to recent searches on success
                if (state is WeatherSuccess) {
                  _recentManager.addRecent(state.weather.city);
                }
              },
              builder: (context, state) {
                return switch (state) {
                  WeatherInitial() => const WeatherEmptyState(),
                  WeatherLoading() => const Padding(
                    padding: EdgeInsets.all(16),
                    child: WeatherLoadingSkeleton(),
                  ),
                  WeatherSuccess() => _buildSuccessView(state),
                  WeatherFailure() => WeatherErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<WeatherBloc>().add(
                        WeatherFetchRequested(state.city),
                      );
                    },
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(WeatherSuccess state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WeatherBloc>().add(const WeatherRefreshRequested());
        // Wait for the BLoC to finish
        await context.read<WeatherBloc>().stream.firstWhere(
          (s) => s is! WeatherLoading,
        );
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Weather card
          WeatherCard(
            weather: state.weather,
            onRefresh: () {
              context.read<WeatherBloc>().add(const WeatherRefreshRequested());
            },
          ),

          // Forecast
          if (state.forecast != null && state.forecast!.isNotEmpty) ...[
            const SizedBox(height: 24),
            ForecastList(forecasts: state.forecast!),
          ],

          // Temperature unit info
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${state.weather.temperatureRounded}°C = ${state.weather.temperatureFahrenheit.round()}°F',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.wb_sunny, size: 48, color: Colors.amber),
        title: const Text('Weather App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🌦️ Ứng dụng thời tiết'),
            SizedBox(height: 8),
            Text('Features:'),
            Text('• Tìm kiếm thành phố'),
            Text('• Thời tiết hiện tại'),
            Text('• Dự báo 5 ngày'),
            Text('• Pull-to-refresh'),
            Text('• Recent searches'),
            SizedBox(height: 16),
            Text(
              'Phase 8: Real Projects\nExercise 06-10',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _recentManager.clearRecent();
              Navigator.pop(context);
              setState(() {}); // Update UI
            },
            child: const Text('Clear Recent'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
