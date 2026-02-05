/// ============================================================================
/// EXERCISE 20: PORTFOLIO APP COMPLETE
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Hoàn thiện ứng dụng Portfolio.
///
/// 📝 BẠN SẼ HỌC:
/// - Assembling all components
/// - Final polish and responsiveness check
/// - Theme toggle implementation
///
/// ============================================================================
library;

import 'package:flutter/material.dart';

import 'ex16_portfolio_models.dart';
import 'ex18_portfolio_home.dart';
import 'ex19_portfolio_sections.dart';

// ============================================================================
// THEME CUBIT (Simple implementation for this exercise)
// ============================================================================

class PortfolioTheme extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  void toggle() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// ============================================================================
// MAIN APP
// ============================================================================

class Ex20PortfolioAppComplete extends StatefulWidget {
  const Ex20PortfolioAppComplete({super.key});

  @override
  State<Ex20PortfolioAppComplete> createState() =>
      _Ex20PortfolioAppCompleteState();
}

class _Ex20PortfolioAppCompleteState extends State<Ex20PortfolioAppComplete> {
  final _theme = PortfolioTheme();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _theme,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontWeight: FontWeight.bold),
              headlineMedium: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headlineMedium: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          themeMode: _theme.mode,
          home: PortfolioScaffold(themeNotifier: _theme),
        );
      },
    );
  }
}

// ============================================================================
// SCAFFOLD
// ============================================================================

class PortfolioScaffold extends StatefulWidget {
  final PortfolioTheme themeNotifier;
  const PortfolioScaffold({super.key, required this.themeNotifier});

  @override
  State<PortfolioScaffold> createState() => _PortfolioScaffoldState();
}

class _PortfolioScaffoldState extends State<PortfolioScaffold> {
  final Map<String, GlobalKey> _keys = {
    'Home': GlobalKey(),
    'Skills': GlobalKey(),
    'Projects': GlobalKey(),
    'Contact': GlobalKey(),
  };

  void _scrollTo(String key) {
    // If drawer is open (mobile), close it
    if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
      Navigator.pop(context);
    }

    final contextKey = _keys[key]?.currentContext;
    if (contextKey != null) {
      Scrollable.ensureVisible(
        contextKey,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final navItems = ['Home', 'Skills', 'Projects', 'Contact'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('PORTFOLIO'),
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              fontSize: 20,
            ),
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            actions: [
              // Desktop Menu
              if (!isMobile)
                ...navItems.map(
                  (item) => TextButton(
                    onPressed: () => _scrollTo(item),
                    child: Text(
                      item,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              const SizedBox(width: 8),

              // Theme Toggle
              IconButton(
                onPressed: widget.themeNotifier.toggle,
                icon: Icon(
                  widget.themeNotifier.mode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      drawer:
          isMobile
              ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              PortfolioData.profile.avatarUrl,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Menu',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    ...navItems.map(
                      (item) => ListTile(
                        leading: Icon(_getIconFor(item)),
                        title: Text(item),
                        onTap: () {
                          Navigator.pop(context);
                          _scrollTo(item);
                        },
                      ),
                    ),
                  ],
                ),
              )
              : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO
            Container(
              key: _keys['Home'],
              // Full height minus appbar roughly
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: const Center(child: Ex18PortfolioHome()),
            ),

            // SKILLS
            Container(key: _keys['Skills'], child: const SkillsSection()),

            // PROJECTS
            Container(key: _keys['Projects'], child: const ProjectsSection()),

            // CONTACT
            Container(key: _keys['Contact'], child: const ContactSection()),

            // FOOTER
            Container(
              height: 80,
              alignment: Alignment.center,
              color: Colors.black87,
              child: const Text(
                'Built with Flutter 💙 by Me',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFor(String item) {
    return switch (item) {
      'Home' => Icons.home,
      'Skills' => Icons.build,
      'Projects' => Icons.work,
      'Contact' => Icons.email,
      _ => Icons.circle,
    };
  }
}
