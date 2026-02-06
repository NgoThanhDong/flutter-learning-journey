/// ============================================================================
/// EXERCISE 18: PORTFOLIO HOME (HERO SECTION)
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Xây dựng Hero Section ấn tượng cho trang chủ.
///
/// 📝 BẠN SẼ HỌC:
/// - Creating engaging hero sections
/// - Typing text animation
/// - Animated buttons and layouts
///
/// ============================================================================
library;

import 'dart:async';
import 'package:flutter/material.dart';

import 'ex16_portfolio_models.dart';

// ============================================================================
// TYPING TEXT ANIMATION
// ============================================================================

class TypingText extends StatefulWidget {
  final List<String> texts;
  final Duration typingSpeed;
  final Duration deleteSpeed;
  final TextStyle? style;

  const TypingText({
    super.key,
    required this.texts,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.deleteSpeed = const Duration(milliseconds: 50),
    this.style,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _currentText = '';
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isTyping = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(
      _isTyping ? widget.typingSpeed : widget.deleteSpeed,
      (timer) {
        if (!mounted) return;

        setState(() {
          final targetText = widget.texts[_textIndex];

          if (_isTyping) {
            // Typing...
            if (_charIndex < targetText.length) {
              _charIndex++;
              _currentText = targetText.substring(0, _charIndex);
            } else {
              // Finished typing
              _isTyping = false;
              _timer?.cancel();
              // Pause before deleting
              Future.delayed(const Duration(seconds: 2), _startAnimation);
            }
          } else {
            // Deleting...
            if (_charIndex > 0) {
              _charIndex--;
              _currentText = targetText.substring(0, _charIndex);
            } else {
              // Finished deleting
              _isTyping = true;
              _textIndex = (_textIndex + 1) % widget.texts.length;
              _timer?.cancel();
              // Pause before typing next
              Future.delayed(
                const Duration(milliseconds: 500),
                _startAnimation,
              );
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_currentText, style: widget.style),
        // Cursor blink
        _CursorBlink(style: widget.style),
      ],
    );
  }
}

class _CursorBlink extends StatefulWidget {
  final TextStyle? style;
  const _CursorBlink({this.style});

  @override
  State<_CursorBlink> createState() => _CursorBlinkState();
}

class _CursorBlinkState extends State<_CursorBlink>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text('|', style: widget.style),
    );
  }
}

// ============================================================================
// HERO SECTION
// ============================================================================

class Ex18PortfolioHome extends StatelessWidget {
  final VoidCallback? onContactTap;
  final VoidCallback? onDownloadTap;

  const Ex18PortfolioHome({super.key, this.onContactTap, this.onDownloadTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLarge = size.width > 800;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child:
            isLarge
                ? Row(
                  children: [
                    Expanded(child: _buildTextContent(context)),
                    Expanded(child: _buildAvatar(context)),
                  ],
                )
                : Column(
                  children: [
                    _buildAvatar(context),
                    const SizedBox(height: 32),
                    _buildTextContent(context, centered: true),
                  ],
                ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
          border: Border.all(color: Colors.white, width: 8),
        ),
        child: ClipOval(
          child: Image.network(
            PortfolioData.profile.avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 100, color: Colors.grey.shade400);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, {bool centered = false}) {
    final style = TextStyle(
      fontSize: 18,
      color: Colors.grey.shade700,
      height: 1.5,
    );
    final alignment =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.left;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          "Hello, I'm",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          PortfolioData.profile.name,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
              centered ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            const Text(
              'A ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TypingText(
              texts: const [
                'Flutter Developer',
                'Mobile Engineer',
                'UI/UX Enthusiast',
              ],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(PortfolioData.profile.bio, style: style, textAlign: textAlign),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: onDownloadTap,
              icon: const Icon(Icons.download),
              label: const Text('Download CV'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onContactTap,
              icon: const Icon(Icons.contact_mail),
              label: const Text('Contact Me'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
