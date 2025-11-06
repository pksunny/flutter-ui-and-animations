import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo screen showcasing the Lightning Text Reveal widget
class LightningTextDemo extends StatefulWidget {
  const LightningTextDemo({Key? key}) : super(key: key);

  @override
  State<LightningTextDemo> createState() => _LightningTextDemoState();
}

class _LightningTextDemoState extends State<LightningTextDemo> {
  bool _showFirst = true;

  void _toggleAnimation() {
    setState(() {
      _showFirst = !_showFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF5F7FA),
              const Color(0xFFE8EEF5),
              const Color(0xFFF0F4F8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, color: Colors.amber[700], size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Lightning Text Reveal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Example 1: Large Title
                        if (_showFirst) ...[
                          LightningTextReveal(
                            key: const ValueKey('example1'),
                            text: 'ELECTRIFY',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A202C),
                              letterSpacing: 8,
                            ),
                            lightningColor: Colors.amber,
                            glowColor: Colors.amber.shade300,
                            duration: const Duration(milliseconds: 2500),
                            lightningWidth: 4.0,
                            glowIntensity: 15.0,
                            autoStart: true,
                          ),
                          const SizedBox(height: 16),
                          LightningTextReveal(
                            key: const ValueKey('example2'),
                            text: 'Your Experience',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                              letterSpacing: 2,
                            ),
                            lightningColor: Colors.cyan,
                            glowColor: Colors.cyan.shade200,
                            duration: const Duration(milliseconds: 2000),
                            delay: const Duration(milliseconds: 800),
                            lightningWidth: 2.5,
                            glowIntensity: 10.0,
                            autoStart: true,
                          ),
                        ] else ...[
                          LightningTextReveal(
                            key: const ValueKey('example3'),
                            text: 'INNOVATION',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D3748),
                              letterSpacing: 6,
                            ),
                            lightningColor: Colors.purple,
                            glowColor: Colors.purple.shade200,
                            duration: const Duration(milliseconds: 2200),
                            lightningWidth: 3.5,
                            glowIntensity: 12.0,
                            autoStart: true,
                          ),
                          const SizedBox(height: 16),
                          LightningTextReveal(
                            key: const ValueKey('example4'),
                            text: 'Starts Here',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                              letterSpacing: 3,
                            ),
                            lightningColor: Colors.pink,
                            glowColor: Colors.pink.shade200,
                            duration: const Duration(milliseconds: 1800),
                            delay: const Duration(milliseconds: 600),
                            lightningWidth: 2.0,
                            glowIntensity: 8.0,
                            autoStart: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Action Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _AnimatedButton(
                  onTap: _toggleAnimation,
                  text: 'Replay Animation',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main Lightning Text Reveal Widget
///
/// Creates an electric lightning effect that travels across text letters,
/// revealing them one by one with stunning visual effects.
///
/// Features:
/// - Customizable lightning color and glow
/// - Adjustable animation speed and delays
/// - Multiple lightning bolts per letter
/// - Smooth fade-in effects
/// - Fully reusable and production-ready
class LightningTextReveal extends StatefulWidget {
  /// The text to be revealed
  final String text;

  /// Text style (font size, weight, color, etc.)
  final TextStyle style;

  /// Color of the lightning bolts
  final Color lightningColor;

  /// Color of the glow effect
  final Color glowColor;

  /// Total duration of the animation
  final Duration duration;

  /// Delay before animation starts
  final Duration delay;

  /// Width of lightning bolts
  final double lightningWidth;

  /// Intensity of the glow effect (blur radius)
  final double glowIntensity;

  /// Whether to start animation automatically
  final bool autoStart;

  /// Callback when animation completes
  final VoidCallback? onComplete;

  const LightningTextReveal({
    Key? key,
    required this.text,
    required this.style,
    this.lightningColor = Colors.amber,
    this.glowColor = Colors.amberAccent,
    this.duration = const Duration(milliseconds: 2000),
    this.delay = Duration.zero,
    this.lightningWidth = 3.0,
    this.glowIntensity = 10.0,
    this.autoStart = true,
    this.onComplete,
  }) : super(key: key);

  @override
  State<LightningTextReveal> createState() => _LightningTextRevealState();
}

class _LightningTextRevealState extends State<LightningTextReveal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<_LetterAnimationData> _letterAnimations = [];

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Create staggered animation data for each letter
    final letters = widget.text.length;
    for (int i = 0; i < letters; i++) {
      final start = i / letters;
      final end = math.min(1.0, (i + 1) / letters + 0.2);

      _letterAnimations.add(
        _LetterAnimationData(
          index: i,
          interval: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animation,
              curve: Interval(start, end, curve: Curves.easeOut),
            ),
          ),
        ),
      );
    }

    if (widget.autoStart) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward().then((_) {
            widget.onComplete?.call();
          });
        }
      });
    }

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LightningTextPainter(
        text: widget.text,
        style: widget.style,
        progress: _animation.value,
        letterAnimations: _letterAnimations,
        lightningColor: widget.lightningColor,
        glowColor: widget.glowColor,
        lightningWidth: widget.lightningWidth,
        glowIntensity: widget.glowIntensity,
      ),
      size: _calculateTextSize(widget.text, widget.style),
    );
  }

  Size _calculateTextSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return Size(textPainter.width + 40, textPainter.height + 60);
  }
}

/// Data class to hold animation information for each letter
class _LetterAnimationData {
  final int index;
  final Animation<double> interval;

  _LetterAnimationData({required this.index, required this.interval});
}

/// Custom painter that draws the lightning effect and text
class _LightningTextPainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final double progress;
  final List<_LetterAnimationData> letterAnimations;
  final Color lightningColor;
  final Color glowColor;
  final double lightningWidth;
  final double glowIntensity;

  _LightningTextPainter({
    required this.text,
    required this.style,
    required this.progress,
    required this.letterAnimations,
    required this.lightningColor,
    required this.glowColor,
    required this.lightningWidth,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    // Center the text
    double currentX = 20;
    final startY = (size.height - _getTextHeight()) / 2;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final animProgress =
          i < letterAnimations.length
              ? letterAnimations[i].interval.value
              : 0.0;

      // Calculate letter position
      textPainter.text = TextSpan(text: char, style: style);
      textPainter.layout();

      final letterCenter = Offset(
        currentX + textPainter.width / 2,
        startY + textPainter.height / 2,
      );

      // Draw lightning effect for this letter
      if (animProgress > 0 && animProgress < 0.95) {
        _drawLightningBolt(canvas, letterCenter, animProgress);
      }

      // Draw the letter with fade-in effect
      final opacity = math.max(0.0, math.min(1.0, (animProgress - 0.3) * 2));
      if (opacity > 0) {
        canvas.save();
        canvas.translate(currentX, startY);

        final letterStyle = style.copyWith(
          color: style.color?.withOpacity(opacity),
        );
        textPainter.text = TextSpan(text: char, style: letterStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset.zero);

        canvas.restore();
      }

      currentX += textPainter.width;
    }
  }

  void _drawLightningBolt(Canvas canvas, Offset center, double progress) {
    final random = math.Random(center.dx.toInt() + center.dy.toInt());

    // Draw multiple lightning bolts for more dramatic effect
    for (int bolt = 0; bolt < 2; bolt++) {
      final boltOffset = bolt * 0.15;
      final boltProgress = math.max(0.0, math.min(1.0, progress - boltOffset));

      if (boltProgress <= 0) continue;

      final points = <Offset>[];
      final segments = 8;

      // Generate lightning path
      double currentY = center.dy - 30;
      double currentX = center.dx + (random.nextDouble() - 0.5) * 20;

      points.add(Offset(currentX, currentY));

      for (int i = 0; i < segments; i++) {
        final t = (i + 1) / segments;
        if (t > boltProgress) break;

        currentY += (60 / segments) * (1 + random.nextDouble() * 0.5);
        currentX += (random.nextDouble() - 0.5) * 15;

        points.add(Offset(currentX, currentY));
      }

      // Draw glow effect
      final glowPaint =
          Paint()
            ..color = glowColor.withOpacity(0.6 * (1 - boltProgress))
            ..strokeWidth = lightningWidth * 3
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowIntensity);

      _drawPath(canvas, points, glowPaint);

      // Draw main lightning bolt
      final boltPaint =
          Paint()
            ..color = lightningColor.withOpacity(0.9)
            ..strokeWidth = lightningWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      _drawPath(canvas, points, boltPaint);

      // Draw bright core
      final corePaint =
          Paint()
            ..color = Colors.white.withOpacity(0.7 * (1 - boltProgress))
            ..strokeWidth = lightningWidth * 0.4
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      _drawPath(canvas, points, corePaint);

      // Draw sparks at endpoints
      if (points.length > 1 && boltProgress > 0.3) {
        _drawSparks(canvas, points.last, random, boltProgress);
      }
    }
  }

  void _drawPath(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawSparks(
    Canvas canvas,
    Offset center,
    math.Random random,
    double progress,
  ) {
    final sparkCount = 4;
    final sparkPaint =
        Paint()
          ..color = lightningColor.withOpacity(0.8 * (1 - progress))
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < sparkCount; i++) {
      final angle = (i / sparkCount) * math.pi * 2 + random.nextDouble();
      final length = 5 + random.nextDouble() * 8;
      final end = Offset(
        center.dx + math.cos(angle) * length,
        center.dy + math.sin(angle) * length,
      );
      canvas.drawLine(center, end, sparkPaint);
    }
  }

  double _getTextHeight() {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return textPainter.height;
  }

  @override
  bool shouldRepaint(_LightningTextPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Feature card widget for demo
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Animated button widget
class _AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const _AnimatedButton({Key? key, required this.onTap, required this.text})
    : super(key: key);

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                _isPressed
                    ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
                    : [const Color(0xFF764BA2), const Color(0xFF667EEA)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF667EEA,
              ).withOpacity(_isPressed ? 0.3 : 0.4),
              blurRadius: _isPressed ? 12 : 20,
              offset: Offset(0, _isPressed ? 4 : 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.replay, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
