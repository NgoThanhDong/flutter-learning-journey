/// ============================================================================
/// PHASE 7: BLOC PATTERN - MAIN ENTRY POINT
/// ============================================================================
///
/// Ứng dụng này chứa 17 bài tập về BLoC Pattern:
///
/// 📚 LESSONS:
/// - Lesson 1: Streams Foundation (Ex01-03)
/// - Lesson 2: Cubit Basics (Ex04-06)
/// - Lesson 3: BLoC Pattern (Ex07-10)
/// - Lesson 4: BLoC Widgets (Ex11-14)
/// - Lesson 5: Architecture & DI (Ex15-17)
///
/// ============================================================================
library;

import 'package:flutter/material.dart';

// Import all exercises
import 'exercises/ex01_stream_controller.dart';
import 'exercises/ex02_stream_transformations.dart';
import 'exercises/ex03_stream_builder_widget.dart';
import 'exercises/ex04_counter_cubit.dart';
import 'exercises/ex05_theme_cubit.dart';
import 'exercises/ex06_timer_cubit.dart';
import 'exercises/ex07_counter_bloc.dart';
import 'exercises/ex08_auth_bloc.dart';
import 'exercises/ex09_form_validation_bloc.dart';
import 'exercises/ex10_bloc_observer.dart';
import 'exercises/ex11_bloc_builder.dart';
import 'exercises/ex12_bloc_listener.dart';
import 'exercises/ex13_bloc_consumer.dart';
import 'exercises/ex14_bloc_selector.dart';
import 'exercises/ex15_todo_app.dart';
import 'exercises/ex16_weather_app.dart';
import 'exercises/ex17_user_crud.dart';

void main() {
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 7: BLoC Pattern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExerciseList(),
    );
  }
}

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    // List of all exercises grouped by lesson
    final exercises = <_ExerciseGroup>[
      _ExerciseGroup(
        title: 'Lesson 1: Streams Foundation',
        color: Colors.blue,
        exercises: [
          ('Ex01: Stream Controller', const Ex01StreamController()),
          ('Ex02: Stream Transformations', const Ex02StreamTransformations()),
          ('Ex03: StreamBuilder Widget', const Ex03StreamBuilderWidget()),
        ],
      ),
      _ExerciseGroup(
        title: 'Lesson 2: Cubit Basics',
        color: Colors.green,
        exercises: [
          ('Ex04: Counter Cubit', const Ex04CounterCubit()),
          ('Ex05: Theme Cubit', const Ex05ThemeCubit()),
          ('Ex06: Timer Cubit', const Ex06TimerCubit()),
        ],
      ),
      _ExerciseGroup(
        title: 'Lesson 3: BLoC Pattern',
        color: Colors.orange,
        exercises: [
          ('Ex07: Counter BLoC', const Ex07CounterBloc()),
          ('Ex08: Auth BLoC', const Ex08AuthBloc()),
          ('Ex09: Form Validation', const Ex09FormValidationBloc()),
          ('Ex10: BlocObserver', const Ex10BlocObserver()),
        ],
      ),
      _ExerciseGroup(
        title: 'Lesson 4: BLoC Widgets',
        color: Colors.purple,
        exercises: [
          ('Ex11: BlocBuilder', const Ex11BlocBuilder()),
          ('Ex12: BlocListener', const Ex12BlocListener()),
          ('Ex13: BlocConsumer', const Ex13BlocConsumer()),
          ('Ex14: BlocSelector', const Ex14BlocSelector()),
        ],
      ),
      _ExerciseGroup(
        title: 'Lesson 5: Architecture & DI',
        color: Colors.teal,
        exercises: [
          ('Ex15: Todo App', const Ex15TodoApp()),
          ('Ex16: Weather App', const Ex16WeatherApp()),
          ('Ex17: User CRUD', const Ex17UserCrud()),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 7: BLoC Pattern'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, groupIndex) {
          final group = exercises[groupIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: group.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      group.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: group.color,
                      ),
                    ),
                  ],
                ),
              ),
              // Exercise cards
              ...group.exercises.map((exercise) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8, left: 12),
                  child: ListTile(
                    leading: Container(
                      width: 8,
                      height: 40,
                      decoration: BoxDecoration(
                        color: group.color.withAlpha(100),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    title: Text(exercise.$1),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 16, color: group.color),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => exercise.$2),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

class _ExerciseGroup {
  final String title;
  final Color color;
  final List<(String, Widget)> exercises;

  const _ExerciseGroup({
    required this.title,
    required this.color,
    required this.exercises,
  });
}
