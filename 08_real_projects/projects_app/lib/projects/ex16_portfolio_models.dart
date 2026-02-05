/// ============================================================================
/// EXERCISE 16: PORTFOLIO MODELS
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Định nghĩa các Data Models cho Portfolio App.
///
/// 📝 BẠN SẼ HỌC:
/// - Designing data structures for a real app
/// - Using Enums for types (SkillType, SocialPlatform)
/// - Creating mock data generator
///
/// ============================================================================
library;

import 'package:flutter/material.dart';

// ============================================================================
// ENUMS
// ============================================================================

enum SkillType {
  language, // Dart, JavaScript...
  framework, // Flutter, React...
  tool, // Git, Figma...
  other; // Design patterns...

  String get displayName => switch (this) {
    SkillType.language => 'Languages',
    SkillType.framework => 'Frameworks',
    SkillType.tool => 'Tools',
    SkillType.other => 'Others',
  };

  Color get color => switch (this) {
    SkillType.language => Colors.blue,
    SkillType.framework => Colors.green,
    SkillType.tool => Colors.orange,
    SkillType.other => Colors.purple,
  };
}

enum SocialPlatform {
  github,
  linkedin,
  twitter,
  facebook,
  email,
  website;

  IconData get icon => switch (this) {
    SocialPlatform.github => Icons.code,
    SocialPlatform.linkedin => Icons.work,
    SocialPlatform.twitter => Icons.flutter_dash,
    SocialPlatform.facebook => Icons.facebook,
    SocialPlatform.email => Icons.email,
    SocialPlatform.website => Icons.language,
  };
}

// ============================================================================
// MODELS
// ============================================================================

/// Thông tin cá nhân cơ bản
class Profile {
  final String name;
  final String role;
  final String bio;
  final String avatarUrl;
  final String location;
  final String email;

  const Profile({
    required this.name,
    required this.role,
    required this.bio,
    required this.avatarUrl,
    required this.location,
    required this.email,
  });
}

/// Kỹ năng chuyên môn
class Skill {
  final String name;
  final double level; // 0.0 -> 1.0
  final SkillType type;
  final String? iconUrl; // Optional custom icon

  const Skill({
    required this.name,
    required this.level,
    this.type = SkillType.other,
    this.iconUrl,
  });

  String get levelLabel {
    if (level >= 0.9) return 'Expert';
    if (level >= 0.7) return 'Advanced';
    if (level >= 0.5) return 'Intermediate';
    return 'Beginner';
  }
}

/// Dự án đã thực hiện
class Project {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> techStack;
  final String? demoUrl;
  final String? sourceUrl;
  final DateTime date;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.techStack,
    this.demoUrl,
    this.sourceUrl,
    required this.date,
  });
}

/// Liên kết mạng xã hội
class SocialLink {
  final SocialPlatform platform;
  final String url;
  final String username;

  const SocialLink({
    required this.platform,
    required this.url,
    required this.username,
  });
}

// ============================================================================
// MOCK DATA GENERATOR
// ============================================================================

class PortfolioData {
  static const Profile profile = Profile(
    name: 'Nguyễn Văn Flutter',
    role: 'Senior Flutter Developer',
    bio:
        'Passionate mobile developer with 5+ years of experience building beautiful, performant iOS and Android applications using Flutter.',
    avatarUrl: 'https://i.pravatar.cc/300',
    location: 'Ho Chi Minh City, Vietnam',
    email: 'hello@flutter.dev',
  );

  static const List<Skill> skills = [
    Skill(name: 'Dart', level: 0.95, type: SkillType.language),
    Skill(name: 'Flutter', level: 0.9, type: SkillType.framework),
    Skill(name: 'Swift', level: 0.6, type: SkillType.language),
    Skill(name: 'Kotlin', level: 0.5, type: SkillType.language),
    Skill(name: 'Git', level: 0.85, type: SkillType.tool),
    Skill(name: 'Firebase', level: 0.8, type: SkillType.tool),
    Skill(name: 'Clean Arch', level: 0.85, type: SkillType.other),
    Skill(name: 'BLoC', level: 0.9, type: SkillType.other),
  ];

  static final List<Project> projects = [
    Project(
      id: 'p1',
      name: 'E-commerce App',
      description:
          'A full-featured shopping app with cart, checkout, and payment integration.',
      imageUrl: 'https://picsum.photos/seed/p1/600/400',
      techStack: ['Flutter', 'BLoC', 'Firebase'],
      demoUrl: 'https://demo.com',
      sourceUrl: 'https://github.com',
      date: DateTime(2023, 12, 1),
    ),
    Project(
      id: 'p2',
      name: 'Weather Forecast',
      description: 'Beautiful weather app with animations and real-time data.',
      imageUrl: 'https://picsum.photos/seed/p2/600/400',
      techStack: ['Flutter', 'Dio', 'OpenWeatherAPI'],
      demoUrl: 'https://weather.demo',
      date: DateTime(2023, 10, 15),
    ),
    Project(
      id: 'p3',
      name: 'Task Manager',
      description: 'Productivity app to manage daily tasks and projects.',
      imageUrl: 'https://picsum.photos/seed/p3/600/400',
      techStack: ['Flutter', 'Hive', 'Riverpod'],
      sourceUrl: 'https://github.com',
      date: DateTime(2023, 8, 20),
    ),
    Project(
      id: 'p4',
      name: 'Social Media Dashboard',
      description: 'Analytics dashboard for social media managers.',
      imageUrl: 'https://picsum.photos/seed/p4/600/400',
      techStack: ['Flutter Web', 'Responsive', 'Charts'],
      date: DateTime(2023, 5, 10),
    ),
  ];

  static const List<SocialLink> socialLinks = [
    SocialLink(
      platform: SocialPlatform.github,
      url: 'https://github.com/flutter',
      username: '@flutter',
    ),
    SocialLink(
      platform: SocialPlatform.linkedin,
      url: 'https://linkedin.com/in/flutter',
      username: 'Flutter Developer',
    ),
    SocialLink(
      platform: SocialPlatform.twitter,
      url: 'https://twitter.com/flutterdev',
      username: '@flutterdev',
    ),
    SocialLink(
      platform: SocialPlatform.email,
      url: 'mailto:hello@flutter.dev',
      username: 'hello@flutter.dev',
    ),
  ];
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex16PortfolioModels extends StatelessWidget {
  const Ex16PortfolioModels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex16: Portfolio Models'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '👤 Profile Data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(PortfolioData.profile.avatarUrl),
              ),
              title: Text(PortfolioData.profile.name),
              subtitle: Text(PortfolioData.profile.role),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            '🛠️ Skills Data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                PortfolioData.skills
                    .map(
                      (skill) => Chip(
                        label: Text(skill.name),
                        avatar: CircleAvatar(
                          backgroundColor: skill.type.color,
                          child: Text(
                            (skill.level * 10).toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(height: 24),
          const Text(
            '🚀 Projects Data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...PortfolioData.projects.map(
            (p) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(p.name),
                subtitle: Text(p.techStack.join(', ')),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
