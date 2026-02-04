/// Clean Architecture Demo App
/// Phase 6: Clean Architecture Flutter Learning
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// SOLID Exercises
import 'exercises/ex01_single_responsibility.dart';
import 'exercises/ex02_open_closed.dart';
import 'exercises/ex03_liskov_substitution.dart';
import 'exercises/ex04_interface_segregation.dart';
import 'exercises/ex05_dependency_inversion.dart';

// DI Exercises
import 'exercises/ex06_manual_di.dart';
import 'exercises/ex07_get_it_basic.dart';
import 'exercises/ex08_get_it_lazy.dart';

// Repository Exercises
import 'exercises/ex09_repository_interface.dart';
import 'exercises/ex10_local_remote_source.dart';
import 'exercises/ex11_repository_impl.dart';

// Layers Exercises
import 'exercises/ex12_domain_entities.dart';
import 'exercises/ex13_use_cases.dart';
import 'exercises/ex14_presentation_viewmodel.dart';

// Error Handling Exercises
import 'exercises/ex15_either_result.dart';
import 'exercises/ex16_failure_classes.dart';

// Practice Projects
import 'exercises/ex17_notes_app_clean.dart';
import 'exercises/ex18_user_profile_clean.dart';

void main() {
  runApp(const CleanArchitectureApp());
}

class CleanArchitectureApp extends StatelessWidget {
  const CleanArchitectureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: MaterialApp(
        title: 'Clean Architecture',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ExerciseListPage(),
      ),
    );
  }
}

class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      (
        'SOLID Principles',
        Colors.blue,
        [
          ('Ex01: Single Responsibility', const Ex01SingleResponsibility()),
          ('Ex02: Open/Closed', const Ex02OpenClosed()),
          ('Ex03: Liskov Substitution', const Ex03LiskovSubstitution()),
          ('Ex04: Interface Segregation', const Ex04InterfaceSegregation()),
          ('Ex05: Dependency Inversion', const Ex05DependencyInversion()),
        ],
      ),
      (
        'Dependency Injection',
        Colors.green,
        [
          ('Ex06: Manual DI', const Ex06ManualDI()),
          ('Ex07: get_it Basic', const Ex07GetItBasic()),
          ('Ex08: get_it Lazy', const Ex08GetItLazy()),
        ],
      ),
      (
        'Repository Pattern',
        Colors.orange,
        [
          ('Ex09: Repository Interface', const Ex09RepositoryInterface()),
          ('Ex10: Local/Remote Sources', const Ex10LocalRemoteSource()),
          ('Ex11: Repository Impl', const Ex11RepositoryImpl()),
        ],
      ),
      (
        'Layer Architecture',
        Colors.purple,
        [
          ('Ex12: Domain Entities', const Ex12DomainEntities()),
          ('Ex13: Use Cases', const Ex13UseCases()),
          ('Ex14: ViewModel Pattern', const Ex14PresentationViewmodel()),
        ],
      ),
      (
        'Error Handling',
        Colors.red,
        [
          ('Ex15: Either/Result', const Ex15EitherResult()),
          ('Ex16: Failure Classes', const Ex16FailureClasses()),
        ],
      ),
      (
        'Practice Projects',
        Colors.teal,
        [
          ('Ex17: Notes App', const Ex17NotesAppClean()),
          ('Ex18: User Profiles', const Ex18UserProfileClean()),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 6: Clean Architecture'),
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
                color: color.withAlpha(30),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ),
              ...items.map(
                (item) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color,
                    child: Text('${sectionIndex + 1}'),
                  ),
                  title: Text(item.$1),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.$2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
