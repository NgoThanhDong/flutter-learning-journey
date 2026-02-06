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

  final ScrollController _scrollController = ScrollController();
  String _activeSection = 'Home';
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 1. Back to top visibility
    if (_scrollController.offset > 300 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 300 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }

    // 2. Active Section Highlighting
    _checkActiveSection();
  }

  void _checkActiveSection() {
    double minDistance = double.infinity;
    String newSection = _activeSection;

    for (final entry in _keys.entries) {
      final key = entry.value;
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        // Distance of section top to the top of viewport (0)
        final distance = (position.dy).abs();

        // Check if section is somewhat visible (top is above screen center)
        // A simple heuristic: The section closest to the top (0) is active
        if (distance < minDistance) {
          minDistance = distance;
          newSection = entry.key;
        }
      }
    }

    if (newSection != _activeSection) {
      setState(() => _activeSection = newSection);
    }
  }

  Future<void> _simulateDownload() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Generating PDF...',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
    );

    // Simulate delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context); // Close dialog

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('CV downloaded successfully to your device!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _scrollTo(String key) {
    if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
      Navigator.pop(context);
    }

    final contextKey = _keys[key]?.currentContext;
    if (contextKey != null) {
      Scrollable.ensureVisible(
        contextKey,
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
      // Manually set active section to avoid jerky updates during scroll
      setState(() => _activeSection = key);
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
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withValues(alpha: 0.9),
            border: Border(
              bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
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
              // Desktop Menu with Active Highlight
              if (!isMobile)
                ...navItems.map((item) {
                  final isActive = _activeSection == item;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () => _scrollTo(item),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            isActive
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onSurface,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                          if (isActive)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 2,
                              width: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                        ],
                      ),
                    ),
                  );
                }),

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
                        selected: _activeSection == item,
                        selectedColor: Theme.of(context).primaryColor,
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
      floatingActionButton:
          _showBackToTop
              ? FloatingActionButton(
                onPressed: () => _scrollTo('Home'),
                mini: true,
                child: const Icon(Icons.arrow_upward),
              )
              : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // HERO (Always visible initially, but consistent wrapping)
            RevealOnScroll(
              scrollController: _scrollController,
              child: Container(
                key: _keys['Home'],
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Center(
                  child: Ex18PortfolioHome(
                    onContactTap: () => _scrollTo('Contact'),
                    onDownloadTap: _simulateDownload,
                  ),
                ),
              ),
            ),

            // SKILLS
            RevealOnScroll(
              scrollController: _scrollController,
              delay: const Duration(milliseconds: 200),
              child: Container(
                key: _keys['Skills'],
                child: const SkillsSection(),
              ),
            ),

            // PROJECTS
            RevealOnScroll(
              scrollController: _scrollController,
              child: Container(
                key: _keys['Projects'],
                child: const ProjectsSection(),
              ),
            ),

            // CONTACT
            RevealOnScroll(
              scrollController: _scrollController,
              child: Container(
                key: _keys['Contact'],
                child: const ContactSection(),
              ),
            ),

            // FOOTER
            Container(
              height: 80,
              alignment: Alignment.center,
              color: Colors.black87,
              child: const Text(
                'Built with Flutter by Me',
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

// ============================================================================
// ANIMATION WIDGET
// ============================================================================

class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration delay;

  const RevealOnScroll({
    super.key,
    required this.child,
    required this.scrollController,
    this.delay = Duration.zero,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2), // Slide up from 20% down
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Listen to scroll
    widget.scrollController.addListener(_checkVisibility);
    // Initial check after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (_isVisible) return;
    if (!mounted) return;

    final context = this.context;
    final renderObject = context.findRenderObject();
    if (renderObject == null) return;

    final renderBox = renderObject as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // Trigger when top of widget enters the bottom 85% of screen
    if (position.dy < screenHeight * 0.85) {
      if (widget.delay != Duration.zero) {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      } else {
        _controller.forward();
      }

      setState(() => _isVisible = true);
      // Cleanup listener
      widget.scrollController.removeListener(_checkVisibility);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
