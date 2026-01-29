import 'package:flutter/material.dart';

// Import exercises (uncomment khi làm bài tập)
import 'exercises/ex01_hello_flutter.dart';
import 'exercises/ex02_counter.dart';
// ...

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Basics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExerciseListScreen(),
    );
  }
}

/// Danh sách tất cả exercises
class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 2: Flutter Basics'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLessonSection(context, 'Bài 1: Introduction', [
            _ExerciseItem('Ex 01: Hello Flutter', Ex01HelloFlutter()),
          ]),
          _buildLessonSection(context, 'Bài 2: Widget Fundamentals', [
            _ExerciseItem('Ex 02: Counter App', Ex02Counter()),
            _ExerciseItem('Ex 03: Toggle Theme', null),
            _ExerciseItem('Ex 04: Like Button', null),
          ]),
          _buildLessonSection(context, 'Bài 3: Basic Widgets', [
            _ExerciseItem('Ex 05: Profile Card', null),
            _ExerciseItem('Ex 06: Product Card', null),
            _ExerciseItem('Ex 07: Social Post Card', null),
          ]),
          _buildLessonSection(context, 'Bài 4: Layout', [
            _ExerciseItem('Ex 08: Navigation Bar', null),
            _ExerciseItem('Ex 09: Price Row', null),
            _ExerciseItem('Ex 10: Profile Header', null),
            _ExerciseItem('Ex 11: Grid Layout', null),
          ]),
          _buildLessonSection(context, 'Bài 5: Scrollable', [
            _ExerciseItem('Ex 12: Contact List', null),
            _ExerciseItem('Ex 13: Product Grid', null),
            _ExerciseItem('Ex 14: Horizontal Categories', null),
          ]),
          _buildLessonSection(context, 'Bài 6: Input', [
            _ExerciseItem('Ex 15: Login Form', null),
            _ExerciseItem('Ex 16: Registration Form', null),
            _ExerciseItem('Ex 17: Settings Page', null),
          ]),
          _buildLessonSection(context, 'Bài 7: Styling', [
            _ExerciseItem('Ex 18: App Theme', null),
            _ExerciseItem('Ex 19: Dark Mode Toggle', null),
          ]),
          _buildLessonSection(context, 'Bài 8: Practice', [
            _ExerciseItem('Ex 20: Login Screen', null),
            _ExerciseItem('Ex 21: E-commerce Home', null),
            _ExerciseItem('Ex 22: Chat UI', null),
          ]),
        ],
      ),
    );
  }

  Widget _buildLessonSection(
    BuildContext context,
    String title,
    List<_ExerciseItem> exercises,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...exercises.map(
              (ex) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  ex.widget != null
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: ex.widget != null ? Colors.green : Colors.grey,
                ),
                title: Text(ex.name),
                trailing: ex.widget != null
                    ? const Icon(Icons.arrow_forward_ios, size: 16)
                    : null,
                onTap: ex.widget != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ex.widget!),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseItem {
  final String name;
  final Widget? widget;

  _ExerciseItem(this.name, this.widget);
}
