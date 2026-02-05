/// ============================================================================
/// EXERCISE 19: PORTFOLIO SECTIONS
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Xây dựng các Section: Skills, Projects, và Contact.
///
/// 📝 BẠN SẼ HỌC:
/// - Grid Layout cho Skills
/// - Card Layout cho Projects
/// - Form validation cho Contact
///
/// ============================================================================
library;

import 'package:flutter/material.dart';

import 'ex16_portfolio_models.dart';

// ============================================================================
// SKILLS SECTION
// ============================================================================

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(64),
      child: Column(
        children: [
          const Text(
            'My Skills',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Technologies and tools I use to build products.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 48),

          // Grid
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children:
                PortfolioData.skills
                    .map((skill) => _SkillCard(skill: skill))
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: skill.type.color.withOpacity(0.1),
            child: Icon(Icons.code, color: skill.type.color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            skill.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            skill.levelLabel,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: skill.level,
            color: skill.type.color,
            backgroundColor: skill.type.color.withOpacity(0.1),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PROJECTS SECTION
// ============================================================================

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Featured Projects',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Highlights of my recent work.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 48),

          // Project List
          LayoutBuilder(
            builder: (context, constraints) {
              // If wide -> Grid 2 columns, else 1 column
              if (constraints.maxWidth > 800) {
                return Wrap(
                  spacing: 32,
                  runSpacing: 32,
                  alignment: WrapAlignment.center,
                  children:
                      PortfolioData.projects
                          .map(
                            (p) => SizedBox(
                              width: 400,
                              child: _ProjectCard(project: p),
                            ),
                          )
                          .toList(),
                );
              }
              return Column(
                children:
                    PortfolioData.projects
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: _ProjectCard(project: p),
                          ),
                        )
                        .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              project.imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      project.techStack
                          .map(
                            (tech) => Chip(
                              label: Text(
                                tech,
                                style: const TextStyle(fontSize: 10),
                              ),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (project.demoUrl != null)
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.launch, size: 16),
                        label: const Text('Live Demo'),
                      ),
                    if (project.sourceUrl != null) ...[
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.code, size: 16),
                        label: const Text('Source Code'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CONTACT SECTION
// ============================================================================

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade900,
      padding: const EdgeInsets.all(64),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Have a project in mind or just want to say hi?',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 48),

              // Form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator:
                              (v) =>
                                  v!.isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator:
                              (v) => !v!.contains('@') ? 'Invalid email' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          validator:
                              (v) =>
                                  v!.isEmpty ? 'Please enter a message' : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Message sent! 🚀'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Send Message',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children:
                    PortfolioData.socialLinks
                        .map(
                          (link) => IconButton(
                            onPressed: () {},
                            icon: Icon(link.platform.icon),
                            color: Colors.white,
                            iconSize: 32,
                            tooltip: link.platform.name,
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex19PortfolioSections extends StatelessWidget {
  const Ex19PortfolioSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex19: Sections Demo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SkillsSection(),
            const Divider(height: 1),
            const ProjectsSection(),
            const Divider(height: 1),
            const ContactSection(),
          ],
        ),
      ),
    );
  }
}
