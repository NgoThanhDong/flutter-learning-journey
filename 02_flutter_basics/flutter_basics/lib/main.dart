import 'package:flutter/material.dart';

// Import exercises (uncomment khi làm bài tập)
import 'exercises/ex01_hello_flutter.dart';
import 'exercises/ex02_counter.dart';
import 'exercises/ex03_toggle_theme.dart';
import 'exercises/ex04_like_button.dart';
import 'exercises/ex05_profile_card.dart';
import 'exercises/ex06_product_card.dart';
import 'exercises/ex07_social_post_card.dart';
import 'exercises/ex08_navigation_bar.dart';
import 'exercises/ex09_price_row.dart';
import 'exercises/ex10_profile_header.dart';
import 'exercises/ex11_grid_layout.dart';
import 'exercises/ex12_contact_list.dart';
import 'exercises/ex13_product_grid.dart';
import 'exercises/ex14_horizontal_categories.dart';
import 'exercises/ex15_login_form.dart';
import 'exercises/ex16_registration_form.dart';
import 'exercises/ex17_settings_page.dart';
import 'exercises/ex18_app_theme.dart';
import 'exercises/ex19_dark_mode_toggle.dart';
import 'exercises/ex20_login_screen.dart';
import 'exercises/ex21_ecommerce_home.dart';
import 'exercises/ex22_chat_ui.dart';

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
            _ExerciseItem('Ex 03: Toggle Theme', Ex03ToggleTheme()),
            _ExerciseItem('Ex 04: Like Button', Ex04LikeButton()),
          ]),
          _buildLessonSection(context, 'Bài 3: Basic Widgets', [
            _ExerciseItem('Ex 05: Profile Card', Ex05ProfileCard()),
            _ExerciseItem('Ex 06: Product Card', Ex06ProductCard()),
            _ExerciseItem('Ex 07: Social Post Card', Ex07SocialPostCard()),
          ]),
          _buildLessonSection(context, 'Bài 4: Layout', [
            _ExerciseItem('Ex 08: Navigation Bar', Ex08NavigationBar()),
            _ExerciseItem('Ex 09: Price Row', Ex09PriceRow()),
            _ExerciseItem('Ex 10: Profile Header', Ex10ProfileHeader()),
            _ExerciseItem('Ex 11: Grid Layout', Ex11GridLayout()),
          ]),
          _buildLessonSection(context, 'Bài 5: Scrollable', [
            _ExerciseItem('Ex 12: Contact List', Ex12ContactList()),
            _ExerciseItem('Ex 13: Product Grid', Ex13ProductGrid()),
            _ExerciseItem('Ex 14: Horizontal Categories', Ex14HorizontalCategories()),
          ]),
          _buildLessonSection(context, 'Bài 6: Input', [
            _ExerciseItem('Ex 15: Login Form', Ex15LoginForm()),
            _ExerciseItem('Ex 16: Registration Form', Ex16RegistrationForm()),
            _ExerciseItem('Ex 17: Settings Page', Ex17SettingsPage()),
          ]),
          _buildLessonSection(context, 'Bài 7: Styling', [
            _ExerciseItem('Ex 18: App Theme', Ex18AppTheme()),
            _ExerciseItem('Ex 19: Dark Mode Toggle', Ex19DarkModeToggle()),
          ]),
          _buildLessonSection(context, 'Bài 8: Practice', [
            _ExerciseItem('Ex 20: Login Screen', Ex20LoginScreen()),
            _ExerciseItem('Ex 21: E-commerce Home', Ex21EcommerceHome()),
            _ExerciseItem('Ex 22: Chat UI', Ex22ChatUI()),
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
