/// ============================================================================
/// EXERCISE 17: PORTFOLIO NAVIGATION
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Thiết lập navigation cho Portfolio App.
///
/// 📝 BẠN SẼ HỌC:
/// - Building a responsive navigation bar
/// - Handling scroll-to-element logic
/// - Mobile Drawer implementation
///
/// ============================================================================
library;

import 'package:flutter/material.dart';

// ============================================================================
// NAVIGATION BAR ITEMS
// ============================================================================

final navItems = ['Home', 'Skills', 'Projects', 'Contact'];

// ============================================================================
// RESPONSIVE NAVIGATION SHELL
// ============================================================================

class Ex17PortfolioNavigation extends StatefulWidget {
  const Ex17PortfolioNavigation({super.key});

  @override
  State<Ex17PortfolioNavigation> createState() =>
      _Ex17PortfolioNavigationState();
}

class _Ex17PortfolioNavigationState extends State<Ex17PortfolioNavigation> {
  // Key cho các section để scroll đến
  final Map<String, GlobalKey> _sectionKeys = {
    'Home': GlobalKey(),
    'Skills': GlobalKey(),
    'Projects': GlobalKey(),
    'Contact': GlobalKey(),
  };

  void _scrollToSection(String section) {
    final key = _sectionKeys[section];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dùng MediaQuery để check màn hình
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          isMobile
              ? AppBar(
                title: const Text('My Portfolio'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
              : null, // Desktop dùng custom header
      drawer:
          isMobile
              ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Center(
                        child: Text(
                          'Menu',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                    ...navItems.map(
                      (item) => ListTile(
                        title: Text(item),
                        onTap: () {
                          Navigator.pop(context); // Close drawer
                          _scrollToSection(item);
                        },
                      ),
                    ),
                  ],
                ),
              )
              : null,
      body: Stack(
        children: [
          // Main Body Content
          SingleChildScrollView(
            child: Column(
              children: [
                // ============================================================
                // DESKTOP HEADER (Only visible on large screens)
                // ============================================================
                if (!isMobile)
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'MY PORTFOLIO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Row(
                          children:
                              navItems.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 32),
                                  child: TextButton(
                                    onPressed: () => _scrollToSection(item),
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),

                // ============================================================
                // SECTIONS (Placeholder)
                // ============================================================
                _buildSection('Home', Colors.blue.shade100, 600),
                _buildSection('Skills', Colors.green.shade100, 500),
                _buildSection('Projects', Colors.orange.shade100, 700),
                _buildSection('Contact', Colors.purple.shade100, 400),

                // Footer
                Container(
                  height: 100,
                  color: Colors.grey.shade900,
                  alignment: Alignment.center,
                  child: const Text(
                    '© 2024 My Portfolio. All rights reserved.',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Color color, double height) {
    return Container(
      key: _sectionKeys[title],
      height: height,
      color: color,
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Content goes here...'),
        ],
      ),
    );
  }
}
