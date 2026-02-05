/// ============================================================================
/// EXERCISE 09: WEATHER UI COMPONENTS
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Xây dựng UI components đẹp cho Weather App.
///
/// 📝 BẠN SẼ HỌC:
/// - Gradient backgrounds
/// - Glassmorphism effects
/// - Animated weather icons
/// - Responsive layouts
/// - Loading skeletons với Shimmer
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'ex06_weather_model.dart';

// ============================================================================
// WEATHER CARD - Main card hiển thị thời tiết
// ============================================================================
///
/// Card hiển thị thời tiết hiện tại với:
/// - Gradient background theo condition
/// - Temperature lớn ở giữa
/// - City name và condition
/// - Details row (feels like, humidity, wind)
///
// ============================================================================

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final VoidCallback? onRefresh;

  const WeatherCard({super.key, required this.weather, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // Gradient theo weather condition
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: weather.condition.gradientColors,
        ),
        borderRadius: BorderRadius.circular(24),
        // Shadow với màu gradient
        boxShadow: [
          BoxShadow(
            color: weather.condition.gradientColors.first.withAlpha(100),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================================
            // HEADER: Location + Refresh
            // ==================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white70,
                      size: 20,
                    ),
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
                // Refresh button
                if (onRefresh != null)
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    onPressed: onRefresh,
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================================
            // MAIN CONTENT: Icon + Temperature
            // ==================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Temperature
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperatureRounded}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.w200,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weather.condition.displayName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                // Weather Icon
                Text(
                  weather.condition.icon,
                  style: const TextStyle(fontSize: 100),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ==================================================================
            // DETAILS ROW
            // ==================================================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Glassmorphism effect
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _WeatherDetailItem(
                    icon: Icons.thermostat,
                    label: 'Cảm giác',
                    value: '${weather.feelsLikeRounded}°',
                  ),
                  _VerticalDivider(),
                  _WeatherDetailItem(
                    icon: Icons.water_drop,
                    label: 'Độ ẩm',
                    value: '${weather.humidity}%',
                  ),
                  _VerticalDivider(),
                  _WeatherDetailItem(
                    icon: Icons.air,
                    label: 'Gió',
                    value: '${weather.windSpeed.toStringAsFixed(1)}m/s',
                  ),
                ],
              ),
            ),

            // Last updated
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Cập nhật: ${weather.lastUpdated}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.white24);
  }
}

// ============================================================================
// FORECAST CARD - Dự báo 1 ngày
// ============================================================================

class ForecastCard extends StatelessWidget {
  final Forecast forecast;
  final bool isSelected;

  const ForecastCard({
    super.key,
    required this.forecast,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Day of week
          Text(
            forecast.dayOfWeek,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          // Weather icon
          Text(forecast.condition.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          // Temperature
          Text(
            '${forecast.temperature.round()}°',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Precipitation if available
          if (forecast.precipitation != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, size: 12, color: Colors.blue.shade300),
                const SizedBox(width: 2),
                Text(
                  '${forecast.precipitation}%',
                  style: TextStyle(fontSize: 10, color: Colors.blue.shade400),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// FORECAST LIST - Danh sách dự báo nhiều ngày
// ============================================================================

class ForecastList extends StatelessWidget {
  final List<Forecast> forecasts;
  final int? selectedIndex;
  final ValueChanged<int>? onSelect;

  const ForecastList({
    super.key,
    required this.forecasts,
    this.selectedIndex,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📅 Dự báo 5 ngày',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: onSelect != null ? () => onSelect!(index) : null,
                child: ForecastCard(
                  forecast: forecasts[index],
                  isSelected: selectedIndex == index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOADING SKELETON - Shimmer effect khi đang load
// ============================================================================
///
/// Shimmer effect cho better UX khi loading.
///
/// Tại sao dùng skeleton thay vì spinner?
/// - User biết UI sẽ trông như thế nào
/// - Cảm giác app load nhanh hơn
/// - Professional look
///
// ============================================================================

class WeatherLoadingSkeleton extends StatelessWidget {
  const WeatherLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          // Main card skeleton
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 24),
          // Forecast skeleton
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Container(
                  height: 120,
                  margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SEARCH BAR - Ô tìm kiếm thành phố
// ============================================================================

class WeatherSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final List<String>? suggestions;
  final ValueChanged<String>? onSuggestionTap;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.suggestions,
    this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Tìm thành phố...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSearch,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          onSubmitted: (_) => onSearch(),
        ),

        // Suggestions
        if (suggestions != null && suggestions!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions!.map((city) {
              return ActionChip(
                label: Text(city),
                avatar: const Icon(Icons.location_city, size: 16),
                onPressed: onSuggestionTap != null
                    ? () => onSuggestionTap!(city)
                    : null,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// ============================================================================
// ERROR VIEW - Hiển thị lỗi
// ============================================================================

class WeatherErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const WeatherErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off,
                size: 64,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE - Trạng thái ban đầu
// ============================================================================

class WeatherEmptyState extends StatelessWidget {
  const WeatherEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wb_sunny, size: 100, color: Colors.amber.shade200),
          const SizedBox(height: 24),
          Text(
            'Xem thời tiết',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Nhập tên thành phố để xem\nthông tin thời tiết',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex09WeatherUI extends StatelessWidget {
  const Ex09WeatherUI({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleWeather = Weather.sample();
    final sampleForecasts = List.generate(
      5,
      (index) => Forecast(
        dateTime: DateTime.now().add(Duration(days: index + 1)),
        temperature: 25 + index * 1.5 - 3,
        condition:
            WeatherCondition.values[index % WeatherCondition.values.length],
        precipitation: (index * 15) % 100,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex09: Weather UI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '🎨 UI Components Demo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Weather Card
          WeatherCard(weather: sampleWeather, onRefresh: () {}),

          const SizedBox(height: 24),

          // Forecast List
          ForecastList(forecasts: sampleForecasts, selectedIndex: 2),

          const SizedBox(height: 24),

          // Loading skeleton
          const Text(
            '⏳ Loading Skeleton:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const WeatherLoadingSkeleton(),

          const SizedBox(height: 24),

          // Search bar
          const Text(
            '🔍 Search Bar:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          WeatherSearchBar(
            controller: TextEditingController(),
            onSearch: () {},
            suggestions: ['Hanoi', 'Tokyo', 'London'],
          ),
        ],
      ),
    );
  }
}
