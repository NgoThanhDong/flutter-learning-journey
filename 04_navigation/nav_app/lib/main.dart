/// ===========================================
/// PHASE 4: NAVIGATION - MAIN ENTRY
/// ===========================================
///
/// File này là menu chính để truy cập tất cả các bài tập.
/// Chạy: flutter run -d chrome

library;

import 'package:flutter/material.dart';

// Import các exercises
import 'exercises/ex01_push_pop.dart';
import 'exercises/ex02_push_replacement.dart';
import 'exercises/ex03_push_and_remove.dart';
import 'exercises/ex04_pass_data.dart';
import 'exercises/ex05_return_data.dart';
import 'exercises/ex06_named_routes.dart';
import 'exercises/ex07_route_arguments.dart';
import 'exercises/ex08_on_generate_route.dart';
import 'exercises/ex09_go_router_basic.dart';
import 'exercises/ex10_path_parameters.dart';
import 'exercises/ex11_query_parameters.dart';
import 'exercises/ex12_nested_routes.dart';
import 'exercises/ex13_redirect_guard.dart';
import 'exercises/ex14_error_handling.dart';
import 'exercises/ex15_bottom_nav_router.dart';
import 'exercises/ex16_auth_flow.dart';
import 'exercises/ex17_ecommerce_routes.dart';
import 'exercises/ex18_deep_link_demo.dart';

void main() {
  runApp(const NavigationApp());
}

// NavigationApp là widget để tạo ứng dụng điều hướng
class NavigationApp extends StatelessWidget {
  const NavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phase 4: Navigation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExerciseListScreen(),
    );
  }
}

// ExerciseListScreen là widget để tạo danh sách các bài tập
class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 4: Navigation 🧭'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Phần 1: Navigator Basics
          _buildSectionHeader(context, '📦 Navigator Basics (1.0)'),
          _ExerciseCard(1, 'Push & Pop', const Ex01PushPop()),
          _ExerciseCard(2, 'Push Replacement', const Ex02PushReplacement()),
          _ExerciseCard(3, 'Remove Until', const Ex03PushAndRemove()),
          _ExerciseCard(4, 'Pass Data', const Ex04PassData()),
          _ExerciseCard(5, 'Return Data', const Ex05ReturnData()),

          const SizedBox(height: 20),

          // Phần 2: Named Routes
          _buildSectionHeader(context, '🏷️ Named Routes'),
          _ExerciseCard(6, 'Named Routes Basic', const Ex06NamedRoutes()),
          _ExerciseCard(7, 'Route Arguments', const Ex07RouteArguments()),
          _ExerciseCard(8, 'onGenerateRoute', const Ex08OnGenerateRoute()),

          const SizedBox(height: 20),

          // Phần 3: go_router
          _buildSectionHeader(context, '🚀 go_router (2.0)'),
          _ExerciseCard(9, 'Basic Setup', const Ex09GoRouterBasic()),
          _ExerciseCard(10, 'Path Parameters', const Ex10PathParameters()),
          _ExerciseCard(11, 'Query Parameters', const Ex11QueryParameters()),
          _ExerciseCard(12, 'Nested & ShellRoute', const Ex12NestedRoutes()),
          _ExerciseCard(13, 'Redirect & Guards', const Ex13RedirectGuard()),
          _ExerciseCard(14, 'Error Handling', const Ex14ErrorHandling()),

          const SizedBox(height: 20),

          // Phần 4: Practice
          _buildSectionHeader(context, '🎯 Practice Projects'),
          _ExerciseCard(
            15,
            'Bottom Nav Router',
            const Ex15BottomNavRouter(),
            color: Colors.orange,
          ),
          _ExerciseCard(
            16,
            'Full Auth Flow',
            const Ex16AuthFlow(),
            color: Colors.orange,
          ),
          _ExerciseCard(
            17,
            'E-commerce Nav',
            const Ex17EcommerceRoutes(),
            color: Colors.orange,
          ),
          _ExerciseCard(
            18,
            'Deep Link Demo',
            const Ex18DeepLinkDemo(),
            color: Colors.orange,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // _buildSectionHeader là widget để tạo tiêu đề phần
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

// _ExerciseCard là widget để tạo thẻ bài tập
class _ExerciseCard extends StatelessWidget {
  final int number;
  final String title;
  final Widget screen;
  final Color? color;

  const _ExerciseCard(this.number, this.title, this.screen, {this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              color ?? Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '$number',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color != null
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Lưu ý: Vì mỗi bài tập là một MaterialApp riêng,
          // việc push nó vào stack sẽ tạo ra một Nested App.
          // Đây là cách đơn giản nhất để demo độc lập từng bài.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
