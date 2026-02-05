# Lesson 03: Weather App - Ứng Dụng Thời Tiết với API

> 🌦️ Xây dựng ứng dụng thời tiết với API integration và Repository pattern

---

## 🎯 Mục Tiêu

Trong bài này, bạn sẽ xây dựng ứng dụng Weather hoàn chỉnh với:

- ✅ **API Integration** với HTTP client
- ✅ **Repository Pattern** cho data layer
- ✅ **BLoC with Events** thay vì Cubit
- ✅ **Loading/Error states** handling
- ✅ **Dependency Injection** với get_it
- ✅ **Beautiful Weather UI**

---

## 🏗️ Kiến Trúc Ứng Dụng

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│                                                              │
│   WeatherScreen          WeatherWidgets                     │
│        │                      │                              │
│        └──────────┬───────────┘                             │
│                   │                                         │
│                   ▼                                         │
│             WeatherBloc (Events → States)                   │
│                   │                                         │
└───────────────────┼─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                            │
│                                                              │
│   WeatherRepository    ←→    WeatherApiClient              │
│   (Abstract/Impl)            (HTTP calls to API)           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🌐 API Integration

### Sử dụng OpenWeatherMap Style (Simulated)

Trong exercise này, chúng ta simulate API response thay vì gọi API thật để:
- Không cần API key
- Luôn hoạt động offline
- Dễ test và debug

**Real API URL** (tham khảo):
```
https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}
```

### Response Structure:
```json
{
  "city": "Hanoi",
  "temperature": 28.5,
  "feelsLike": 32.0,
  "humidity": 75,
  "windSpeed": 3.5,
  "condition": "Cloudy",
  "icon": "02d"
}
```

---

## 📝 Exercises

### Ex06: Weather Model (`ex06_weather_model.dart`)

**Học được gì:**
- Multiple data models (Weather, Forecast)
- Weather condition enums
- Icon mapping
- Unit conversion

```dart
class Weather extends Equatable {
  final String city;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final WeatherCondition condition;
  final String iconCode;
}

enum WeatherCondition {
  sunny, cloudy, rainy, stormy, snowy
}
```

---

### Ex07: Weather Repository (`ex07_weather_repository.dart`)

**Học được gì:**
- Repository pattern
- Abstract class cho testing
- Error handling với Either
- Simulated API calls

```dart
abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
  Future<List<Forecast>> getForecast(String city);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final http.Client client;
  
  @override
  Future<Weather> getWeather(String city) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return Weather(...);
  }
}
```

---

### Ex08: Weather BLoC (`ex08_weather_bloc.dart`)

**Học được gì:**
- BLoC với Events (thay vì Cubit)
- Multiple event types
- Debounce search
- Caching results

**Events:**
```dart
sealed class WeatherEvent {}
class WeatherFetchRequested extends WeatherEvent {
  final String city;
}
class WeatherRefreshRequested extends WeatherEvent {}
```

**States:**
```dart
sealed class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final Weather weather;
  final List<Forecast>? forecast;
}
class WeatherError extends WeatherState {
  final String message;
}
```

---

### Ex09: Weather UI (`ex09_weather_ui.dart`)

**Học được gì:**
- Weather card design
- Animated icons
- Gradient backgrounds
- Glassmorphism effects

**UI Components:**
```
┌─────────────────────────────────────┐
│         🔍 Tìm thành phố            │
├─────────────────────────────────────┤
│                                     │
│            ☀️                       │
│           28°C                      │
│        "Trời nắng"                  │
│                                     │
│   💨 3.5m/s  💧 75%  🌡️ 32°        │
│                                     │
├─────────────────────────────────────┤
│   Dự báo 5 ngày                     │
│   ┌───┬───┬───┬───┬───┐            │
│   │Mon│Tue│Wed│Thu│Fri│            │
│   │☀️ │☁️ │🌧️ │⛈️ │☀️ │            │
│   │28°│26°│24°│22°│29°│            │
│   └───┴───┴───┴───┴───┘            │
│                                     │
└─────────────────────────────────────┘
```

---

### Ex10: Weather App Complete (`ex10_weather_app_complete.dart`)

**Học được gì:**
- get_it dependency injection
- App initialization
- Recent searches (local storage)
- Pull to refresh

---

## 🔑 Key Concepts

### 1. Repository Pattern

```dart
// Abstract (interface)
abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
}

// Implementation
class WeatherRepositoryImpl implements WeatherRepository {
  final http.Client client;
  
  WeatherRepositoryImpl({required this.client});
  
  @override
  Future<Weather> getWeather(String city) async {
    final response = await client.get(Uri.parse('.../$city'));
    return Weather.fromJson(jsonDecode(response.body));
  }
}

// Fake for testing
class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> getWeather(String city) async {
    return Weather(city: city, temperature: 25, ...);
  }
}
```

### 2. BLoC vs Cubit

| Cubit | BLoC |
|-------|------|
| Gọi method trực tiếp | Gửi Event |
| `cubit.fetchWeather()` | `bloc.add(FetchWeather())` |
| Ít boilerplate | Nhiều boilerplate |
| Khó debug | Dễ debug (log events) |
| Dùng cho logic đơn giản | Dùng cho logic phức tạp |

### 3. Dependency Injection với get_it

```dart
// Setup
final getIt = GetIt.instance;

void setupDependencies() {
  // Singleton: 1 instance, reuse
  getIt.registerSingleton<http.Client>(http.Client());
  
  // Lazy singleton: Tạo khi cần lần đầu
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(client: getIt()),
  );
  
  // Factory: Tạo mới mỗi lần
  getIt.registerFactory<WeatherBloc>(
    () => WeatherBloc(repository: getIt()),
  );
}

// Usage
final bloc = getIt<WeatherBloc>();
```

---

## 🎨 Weather Icons Mapping

| Condition | Icon | Background |
|-----------|------|------------|
| Sunny | ☀️ | Orange gradient |
| Cloudy | ☁️ | Grey gradient |
| Rainy | 🌧️ | Blue gradient |
| Stormy | ⛈️ | Dark gradient |
| Snowy | ❄️ | White gradient |

---

## 📦 Packages Sử Dụng

| Package | Mục đích |
|---------|----------|
| `flutter_bloc` | State management |
| `equatable` | Object comparison |
| `http` | API calls |
| `get_it` | Dependency Injection |
| `shimmer` | Loading skeleton |
| `intl` | Date formatting |

---

## 🚀 Chạy Weather App

```bash
cd 08_real_projects/projects_app
flutter run -d chrome
```

Chọn **"🌦️ Weather App"** từ menu.

---

## ▶️ Bước Tiếp Theo

Sau khi hoàn thành Weather App, tiếp tục với:

➡️ [Lesson 04: Shopping App](./lesson_04_shopping_app.md)

---

## 📋 Checklist

- [ ] Hiểu Repository pattern
- [ ] Implement BLoC với Events
- [ ] Xử lý Loading/Error states
- [ ] Setup Dependency Injection
- [ ] Tạo Weather UI đẹp
- [ ] Implement search functionality
