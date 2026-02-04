/// ===========================================
/// PHASE 5: API INTEGRATION - MAIN ENTRY
/// ===========================================
/// Ứng dụng học API Integration trong Flutter
/// Bao gồm 16 bài tập với comments chi tiết

library;

import 'package:flutter/material.dart';
import 'exercises/ex01_simple_get.dart';
import 'exercises/ex02_json_parsing.dart';
import 'exercises/ex03_post_request.dart';
import 'exercises/ex04_loading_states.dart';
import 'exercises/ex05_model_class.dart';
import 'exercises/ex06_nested_json.dart';
import 'exercises/ex07_list_parsing.dart';
import 'exercises/ex08_dio_basic.dart';
import 'exercises/ex09_dio_interceptors.dart';
import 'exercises/ex10_error_handling.dart';
import 'exercises/ex11_api_service.dart';
import 'exercises/ex12_shared_prefs.dart';
import 'exercises/ex13_hive_basic.dart';
import 'exercises/ex14_offline_cache.dart';
import 'exercises/ex15_weather_app.dart';
import 'exercises/ex16_todo_api.dart';

void main() {
  runApp(const ApiApp());
}

/// ===========================================
/// API APP
/// ===========================================
// ApiApp là widget gốc của ứng dụng
class ApiApp extends StatelessWidget {
  const ApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 5: API Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ExerciseListPage(),
    );
  }
}

/// ===========================================
/// EXERCISE LIST PAGE
/// ===========================================
// ExerciseListPage là trang chính của ứng dụng, gồm 16 bài tập
class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar là thanh tiêu đề của ứng dụng
      appBar: AppBar(
        title: const Text('Phase 5: API Integration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // body là ListView chứa các section
      body: ListView(
        children: [
          _buildSection('HTTP Basics', [
            _ExItem('Ex01: Simple GET', const Ex01SimpleGet()),
            _ExItem('Ex02: JSON Parsing', const Ex02JsonParsing()),
            _ExItem('Ex03: POST Request', const Ex03PostRequest()),
            _ExItem('Ex04: Loading States', const Ex04LoadingStates()),
          ]),
          _buildSection('Models & JSON', [
            _ExItem('Ex05: Model Class', const Ex05ModelClass()),
            _ExItem('Ex06: Nested JSON', const Ex06NestedJson()),
            _ExItem('Ex07: List Parsing', const Ex07ListParsing()),
          ]),
          _buildSection('Dio Package', [
            _ExItem('Ex08: Dio Basic', const Ex08DioBasic()),
            _ExItem('Ex09: Dio Interceptors', const Ex09DioInterceptors()),
            _ExItem('Ex10: Error Handling', const Ex10ErrorHandling()),
            _ExItem('Ex11: API Service', const Ex11ApiService()),
          ]),
          _buildSection('Local Storage', [
            _ExItem('Ex12: SharedPreferences', const Ex12SharedPrefs()),
            _ExItem('Ex13: Hive Basic', const Ex13HiveBasic()),
            _ExItem('Ex14: Offline Cache', const Ex14OfflineCache()),
          ]),
          _buildSection('Practice Projects', [
            _ExItem('Ex15: Weather App', const Ex15WeatherApp()),
            _ExItem('Ex16: Todo CRUD', const Ex16TodoApi()),
          ]),
        ],
      ),
    );
  }

  /// _buildSection là hàm private để build từng section
  /// title: Tiêu đề section
  /// items: Danh sách các bài tập trong section
  Widget _buildSection(String title, List<_ExItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),

        // Map từng bài tập thành ListTile
        // Builder được sử dụng để có context cho Navigator
        // onTap sẽ push sang trang bài tập tương ứng
        ...items.map(
          (item) => Builder(
            builder: (context) => ListTile(
              title: Text(item.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.page),
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

/// _ExItem là class private để lưu thông tin bài tập
/// title: Tiêu đề bài tập
/// page: Widget bài tập
class _ExItem {
  final String title;
  final Widget page;
  const _ExItem(this.title, this.page);
}
