/// BLoC Pattern Demo App
/// Phase 7: Flutter Learning Roadmap
library;

import 'package:flutter/material.dart';

// Lessons
import 'exercises/ex01_stream_controller.dart';
import 'exercises/ex02_stream_transformation.dart';
import 'exercises/ex03_stream_builder.dart';
import 'exercises/ex04_counter_cubit.dart';
import 'exercises/ex05_theme_cubit.dart';
import 'exercises/ex06_timer_cubit.dart';
import 'exercises/ex07_counter_bloc.dart';
import 'exercises/ex08_auth_bloc.dart';
import 'exercises/ex09_bloc_observer.dart';
import 'exercises/ex10_bloc_consumer.dart';
import 'exercises/ex11_multi_bloc_provider.dart';
import 'exercises/ex12_bloc_selector.dart';
import 'exercises/ex13_repository_integration.dart';
import 'exercises/ex14_api_handling.dart';
import 'exercises/ex15_dependency_injection.dart';
import 'exercises/ex16_todo_cubit.dart';
import 'exercises/ex17_weather_bloc.dart';
import 'exercises/ex18_infinite_list.dart';
import 'exercises/ex19_cart_bloc.dart';
import 'exercises/ex20_user_management.dart';

void main() {
  runApp(const BlocPatternApp());
}

class BlocPatternApp extends StatelessWidget {
  const BlocPatternApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 7: BLoC Pattern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ExerciseListPage(),
    );
  }
}

class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      (
        'Streams Foundation',
        Colors.blue,
        [
          ('Ex01: Stream Controller', const Ex01StreamController()),
          ('Ex02: Transformations', const Ex02StreamTransformation()),
          ('Ex03: StreamBuilder', const Ex03StreamBuilder()),
        ]
      ),
      (
        'Cubit Basics',
        Colors.green,
        [
          ('Ex04: Counter Cubit', const Ex04CounterCubit()),
          ('Ex05: Theme Cubit', const Ex05ThemeCubit()),
          ('Ex06: Timer Cubit', const Ex06TimerCubit()),
        ]
      ),
      (
        'BLoC Concept',
        Colors.orange,
        [
          ('Ex07: Counter BLoC', const Ex07CounterBloc()),
          ('Ex08: Auth Flow', const Ex08AuthBloc()),
          ('Ex09: Bloc Observer', const Ex09BlocObserver()),
        ]
      ),
      (
        'BLoC Widgets',
        Colors.purple,
        [
          ('Ex10: BlocConsumer', const Ex10BlocConsumer()),
          ('Ex11: MultiBlocProvider', const Ex11MultiBlocProvider()),
          ('Ex12: BlocSelector', const Ex12BlocSelector()),
        ]
      ),
      (
        'Architecture & DI',
        Colors.red,
        [
          ('Ex13: Repo Integration', const Ex13RepositoryIntegration()),
          ('Ex14: API Handling', const Ex14ApiHandling()),
          ('Ex15: GetIt Injection', const Ex15DependencyInjection()),
        ]
      ),
      (
        'Practice Projects',
        Colors.teal,
        [
          ('Ex16: Todo App', const Ex16TodoCubit()),
          ('Ex17: Weather App', const Ex17WeatherBloc()),
          ('Ex18: Infinite List', const Ex18InfiniteList()),
          ('Ex19: Shopping Cart', const Ex19CartBloc()),
          ('Ex20: User Management', const Ex20UserManagement()),
        ]
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 7: BLoC Pattern'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, sectionIndex) {
          final (title, color, items) = exercises[sectionIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: color.withOpacity(0.1),
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color, fontSize: 18),
                ),
              ),
              ...items.map((item) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Text(
                          '${sectionIndex * 3 + items.indexOf(item) + 1}',
                          style: TextStyle(color: color, fontSize: 12)),
                    ),
                    title: Text(item.$1),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => item.$2)),
                  )),
            ],
          );
        },
      ),
    );
  }
}
