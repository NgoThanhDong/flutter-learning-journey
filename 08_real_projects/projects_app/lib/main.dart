/// ============================================================================
/// PHASE 8: REAL PROJECTS - MAIN ENTRY POINT
/// ============================================================================
///
/// Ứng dụng demo cho Phase 8 Flutter Learning Roadmap.
/// Chạy để xem demos của các projects:
/// - Notes App (Ex01-05)
/// - Weather App (Ex06-10)
/// - Shopping App (Ex11-15)
///
/// ============================================================================
library;

import 'package:flutter/material.dart';

// Notes App
import 'projects/ex01_note_model.dart';
import 'projects/ex02_notes_cubit.dart';
import 'projects/ex03_notes_list_screen.dart';
import 'projects/ex04_note_editor_screen.dart';
import 'projects/ex05_notes_app_complete.dart';

// Weather App
import 'projects/ex06_weather_model.dart';
import 'projects/ex07_weather_repository.dart';
import 'projects/ex08_weather_bloc.dart';
import 'projects/ex09_weather_ui.dart';
import 'projects/ex10_weather_app_complete.dart';

// Shopping App
import 'projects/ex11_product_model.dart';
import 'projects/ex12_cart_cubit.dart';
import 'projects/ex13_product_list_screen.dart';
import 'projects/ex14_product_detail_screen.dart';
import 'projects/ex15_shopping_app_complete.dart';

void main() {
  runApp(const Phase8App());
}

class Phase8App extends StatelessWidget {
  const Phase8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phase 8: Real Projects',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ProjectSelector(),
    );
  }
}

// ============================================================================
// PROJECT SELECTOR - Main Menu
// ============================================================================

class ProjectSelector extends StatelessWidget {
  const ProjectSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 8: Real Projects'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            '🚀 Chọn Project để Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Phase 8 bao gồm 3 ứng dụng thực tế hoàn chỉnh',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Complete Apps
          const Text(
            '📱 ỨNG DỤNG HOÀN CHỈNH',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 12),

          _ProjectCard(
            icon: '📝',
            title: 'Notes App',
            subtitle: 'Ứng dụng ghi chú hoàn chỉnh',
            color: Colors.amber,
            onTap: () => _navigateTo(context, const Ex05NotesAppComplete()),
          ),
          _ProjectCard(
            icon: '🌤️',
            title: 'Weather App',
            subtitle: 'Ứng dụng thời tiết với API',
            color: Colors.blue,
            onTap: () => _navigateTo(context, const Ex10WeatherAppComplete()),
          ),
          _ProjectCard(
            icon: '🛒',
            title: 'Shopping App',
            subtitle: 'Ứng dụng mua sắm với giỏ hàng',
            color: Colors.purple,
            onTap: () => _navigateTo(context, const Ex15ShoppingAppComplete()),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Notes App Exercises
          const Text(
            '📝 NOTES APP EXERCISES',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 12),

          _ExerciseItem(
            number: '01',
            title: 'Note Model',
            widget: const Ex01NoteModel(),
          ),
          _ExerciseItem(
            number: '02',
            title: 'Notes Cubit',
            widget: const Ex02NotesCubit(),
          ),
          _ExerciseItem(
            number: '03',
            title: 'Notes List Screen',
            widget: const Ex03NotesListScreen(),
          ),
          _ExerciseItem(
            number: '04',
            title: 'Note Editor Screen',
            widget: const Ex04NoteEditorScreen(),
          ),

          const SizedBox(height: 16),

          // Weather App Exercises
          const Text(
            '🌤️ WEATHER APP EXERCISES',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 12),

          _ExerciseItem(
            number: '06',
            title: 'Weather Model',
            widget: const Ex06WeatherModel(),
          ),
          _ExerciseItem(
            number: '07',
            title: 'Weather Repository',
            widget: const Ex07WeatherRepository(),
          ),
          _ExerciseItem(
            number: '08',
            title: 'Weather BLoC',
            widget: const Ex08WeatherBloc(),
          ),
          _ExerciseItem(
            number: '09',
            title: 'Weather UI Components',
            widget: const Ex09WeatherUI(),
          ),

          const SizedBox(height: 16),

          // Shopping App Exercises
          const Text(
            '🛒 SHOPPING APP EXERCISES',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const SizedBox(height: 12),

          _ExerciseItem(
            number: '11',
            title: 'Product Model',
            widget: const Ex11ProductModel(),
          ),
          _ExerciseItem(
            number: '12',
            title: 'Cart Cubit',
            widget: const Ex12CartCubit(),
          ),
          _ExerciseItem(
            number: '13',
            title: 'Product List Screen',
            widget: const Ex13ProductListScreen(),
          ),
          _ExerciseItem(
            number: '14',
            title: 'Product Detail Screen',
            widget: const Ex14ProductDetail(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

// ============================================================================
// PROJECT CARD - For complete apps
// ============================================================================

class _ProjectCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withAlpha(40), color.withAlpha(20)],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withAlpha(80),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EXERCISE ITEM - For individual exercises
// ============================================================================

class _ExerciseItem extends StatelessWidget {
  final String number;
  final String title;
  final Widget widget;

  const _ExerciseItem({
    required this.number,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.indigo.shade100,
        child: Text(
          number,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text('Ex$number: $title'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
      },
    );
  }
}
