/// ===========================================
/// PHASE 3: STATE MANAGEMENT - MAIN ENTRY
/// ===========================================
///
/// File này chứa navigation tới tất cả exercises.
/// Chạy: flutter run -d chrome
///
/// Mỗi exercise là 1 màn hình độc lập.
/// Bấm vào từng exercise để học và thực hành.

library;

import 'package:flutter/material.dart';

// Import tất cả exercises
import 'exercises/ex01_counter_setstate.dart';
import 'exercises/ex02_theme_inherited.dart';
import 'exercises/ex03_todo_lifting.dart';
import 'exercises/ex04_counter_provider.dart';
import 'exercises/ex05_theme_provider.dart';
import 'exercises/ex06_todo_provider.dart';
import 'exercises/ex07_cart_provider.dart';
import 'exercises/ex08_multi_provider.dart';
import 'exercises/ex09_selector.dart';
import 'exercises/ex10_consumer_widget.dart';
import 'exercises/ex11_counter_riverpod.dart';
import 'exercises/ex12_todo_riverpod.dart';
import 'exercises/ex13_async_riverpod.dart';
import 'exercises/ex14_shopping_cart.dart';
import 'exercises/ex15_notes_app.dart';
import 'exercises/ex16_theme_switcher.dart';

void main() {
  runApp(const StateApp());
}

class StateApp extends StatelessWidget {
  const StateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 3: State Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExerciseListScreen(),
    );
  }
}

/// ===========================================
/// DANH SÁCH EXERCISES
/// ===========================================
class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 3: State Management'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Phần 1: setState & InheritedWidget
          _buildSectionHeader(context, '📦 Phần 1: setState & InheritedWidget'),
          _ExerciseCard(
            number: 1,
            title: 'Counter với setState',
            subtitle: 'Ôn lại setState cơ bản',
            color: Colors.blue,
            builder: (_) => const Ex01CounterSetstate(),
          ),
          _ExerciseCard(
            number: 2,
            title: 'Theme với InheritedWidget',
            subtitle: 'Hiểu nền tảng của Provider',
            color: Colors.blue,
            builder: (_) => const Ex02ThemeInherited(),
          ),
          _ExerciseCard(
            number: 3,
            title: 'Todo với Lifting State Up',
            subtitle: 'Chia sẻ state giữa widgets',
            color: Colors.blue,
            builder: (_) => const Ex03TodoLifting(),
          ),

          const SizedBox(height: 24),

          // Phần 2: Provider
          _buildSectionHeader(context, '🏪 Phần 2: Provider'),
          _ExerciseCard(
            number: 4,
            title: 'Counter với Provider',
            subtitle: 'ChangeNotifier & ChangeNotifierProvider',
            color: Colors.green,
            builder: (_) => const Ex04CounterProvider(),
          ),
          _ExerciseCard(
            number: 5,
            title: 'Theme với Provider',
            subtitle: 'App-level state management',
            color: Colors.green,
            builder: (_) => const Ex05ThemeProvider(),
          ),
          _ExerciseCard(
            number: 6,
            title: 'Todo với Provider',
            subtitle: 'CRUD operations với ChangeNotifier',
            color: Colors.green,
            builder: (_) => const Ex06TodoProvider(),
          ),
          _ExerciseCard(
            number: 7,
            title: 'Shopping Cart',
            subtitle: 'Complex state với derived values',
            color: Colors.green,
            builder: (_) => const Ex07CartProvider(),
          ),
          _ExerciseCard(
            number: 8,
            title: 'MultiProvider',
            subtitle: 'Quản lý nhiều state',
            color: Colors.green,
            builder: (_) => const Ex08MultiProvider(),
          ),
          _ExerciseCard(
            number: 9,
            title: 'Selector',
            subtitle: 'Tối ưu rebuild với select',
            color: Colors.green,
            builder: (_) => const Ex09Selector(),
          ),
          _ExerciseCard(
            number: 10,
            title: 'Consumer với Child',
            subtitle: 'Tối ưu với child parameter',
            color: Colors.green,
            builder: (_) => const Ex10ConsumerWidget(),
          ),

          const SizedBox(height: 24),

          // Phần 3: Riverpod
          _buildSectionHeader(context, '🚀 Phần 3: Riverpod'),
          _ExerciseCard(
            number: 11,
            title: 'Counter với Riverpod',
            subtitle: 'StateProvider & ConsumerWidget',
            color: Colors.purple,
            builder: (_) => const Ex11CounterRiverpod(),
          ),
          _ExerciseCard(
            number: 12,
            title: 'Todo với Riverpod',
            subtitle: 'StateNotifier & immutable updates',
            color: Colors.purple,
            builder: (_) => const Ex12TodoRiverpod(),
          ),
          _ExerciseCard(
            number: 13,
            title: 'Async với Riverpod',
            subtitle: 'FutureProvider & AsyncValue',
            color: Colors.purple,
            builder: (_) => const Ex13AsyncRiverpod(),
          ),

          const SizedBox(height: 24),

          // Phần 4: Practice
          _buildSectionHeader(context, '🎯 Phần 4: Practice Projects'),
          _ExerciseCard(
            number: 14,
            title: 'Shopping Cart (Provider)',
            subtitle: 'Complete cart với navigation',
            color: Colors.orange,
            builder: (_) => const Ex14ShoppingCart(),
          ),
          _ExerciseCard(
            number: 15,
            title: 'Notes App (Riverpod)',
            subtitle: 'CRUD + Search với StateNotifier',
            color: Colors.orange,
            builder: (_) => const Ex15NotesApp(),
          ),
          _ExerciseCard(
            number: 16,
            title: 'Theme Switcher (Provider)',
            subtitle: 'Dark mode + Color picker',
            color: Colors.orange,
            builder: (_) => const Ex16ThemeSwitcher(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// ===========================================
/// EXERCISE CARD
/// ===========================================
class _ExerciseCard extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  final Color color;
  final WidgetBuilder builder;

  const _ExerciseCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: Text('$number'),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: builder));
        },
      ),
    );
  }
}
