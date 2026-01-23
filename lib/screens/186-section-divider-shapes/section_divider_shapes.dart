import 'package:flutter/material.dart';
import 'dart:math' as math;

class SectionDividerShapes extends StatefulWidget {
  const SectionDividerShapes({Key? key}) : super(key: key);

  @override
  State<SectionDividerShapes> createState() => _SectionDividerShapesState();
}

class _SectionDividerShapesState extends State<SectionDividerShapes> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

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
    setState(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar.large(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1F2937),
            elevation: 0,
            title: const Text(
              'Smart Dividers',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Content sections with animated dividers
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSection(
                  'Introduction',
                  'Premium section dividers with custom paint animations',
                  const Color(0xFF6366F1),
                  0,
                ),

                AnimatedDivider(
                  type: DividerType.wave,
                  color: const Color(0xFF6366F1),
                  scrollProgress: _scrollProgress,
                  sectionIndex: 0,
                ),

                _buildSection(
                  'Features',
                  'Smooth animations, custom shapes, and scroll-reactive behavior',
                  const Color(0xFF8B5CF6),
                  1,
                ),

                AnimatedDivider(
                  type: DividerType.angular,
                  color: const Color(0xFF8B5CF6),
                  scrollProgress: _scrollProgress,
                  sectionIndex: 1,
                ),

                _buildSection(
                  'Design',
                  'Clean, minimal, and modern aesthetic with premium feel',
                  const Color(0xFFEC4899),
                  2,
                ),

                AnimatedDivider(
                  type: DividerType.curve,
                  color: const Color(0xFFEC4899),
                  scrollProgress: _scrollProgress,
                  sectionIndex: 2,
                ),

                _buildSection(
                  'Performance',
                  'Optimized rendering with Flutter CustomPaint',
                  const Color(0xFF06B6D4),
                  3,
                ),

                AnimatedDivider(
                  type: DividerType.asymmetric,
                  color: const Color(0xFF06B6D4),
                  scrollProgress: _scrollProgress,
                  sectionIndex: 3,
                ),

                _buildSection(
                  'Customization',
                  'Highly configurable with multiple shape variants',
                  const Color(0xFF10B981),
                  4,
                ),

                AnimatedDivider(
                  type: DividerType.zigzag,
                  color: const Color(0xFF10B981),
                  scrollProgress: _scrollProgress,
                  sectionIndex: 4,
                ),

                _buildSection(
                  'Conclusion',
                  'Elevate your Flutter apps with premium animated dividers',
                  const Color(0xFFF59E0B),
                  5,
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    String description,
    Color accentColor,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF6B7280),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Explore More',
              color: accentColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Enum defining different divider shape types
enum DividerType { wave, angular, curve, asymmetric, zigzag }

/// Animated divider widget with custom paint shapes
class AnimatedDivider extends StatefulWidget {
  final DividerType type;
  final Color color;
  final double scrollProgress;
  final int sectionIndex;
  final double height;

  const AnimatedDivider({
    Key? key,
    required this.type,
    required this.color,
    required this.scrollProgress,
    required this.sectionIndex,
    this.height = 120,
  }) : super(key: key);

  @override
  State<AnimatedDivider> createState() => _AnimatedDividerState();
}

class _AnimatedDividerState extends State<AnimatedDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calculate section-specific animation offset
        final sectionOffset = (widget.sectionIndex * 0.2) % 1.0;
        final combinedProgress =
            (widget.scrollProgress + _animation.value + sectionOffset) % 1.0;

        return SizedBox(
          height: widget.height,
          width: double.infinity,
          child: CustomPaint(painter: _getPainter(combinedProgress)),
        );
      },
    );
  }

  CustomPainter _getPainter(double progress) {
    switch (widget.type) {
      case DividerType.wave:
        return WaveDividerPainter(
          color: widget.color,
          animationProgress: progress,
        );
      case DividerType.angular:
        return AngularDividerPainter(
          color: widget.color,
          animationProgress: progress,
        );
      case DividerType.curve:
        return CurveDividerPainter(
          color: widget.color,
          animationProgress: progress,
        );
      case DividerType.asymmetric:
        return AsymmetricDividerPainter(
          color: widget.color,
          animationProgress: progress,
        );
      case DividerType.zigzag:
        return ZigzagDividerPainter(
          color: widget.color,
          animationProgress: progress,
        );
    }
  }
}

/// Wave-shaped divider painter
class WaveDividerPainter extends CustomPainter {
  final Color color;
  final double animationProgress;

  WaveDividerPainter({required this.color, required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 40.0;
    final waveCount = 3;

    path.moveTo(0, size.height / 2);

    for (var i = 0; i <= waveCount; i++) {
      final x = (size.width / waveCount) * i;
      final y =
          size.height / 2 +
          math.sin((i * math.pi) + (animationProgress * 2 * math.pi)) *
              waveHeight;

      if (i == 0) {
        path.lineTo(x, y);
      } else {
        final prevX = (size.width / waveCount) * (i - 1);
        final controlX1 = prevX + (size.width / waveCount) * 0.5;
        final controlY1 =
            size.height / 2 +
            math.sin(
                  ((i - 0.5) * math.pi) + (animationProgress * 2 * math.pi),
                ) *
                waveHeight;

        path.quadraticBezierTo(controlX1, controlY1, x, y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw accent line
    final linePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final linePath = Path();
    linePath.moveTo(0, size.height / 2);

    for (var i = 0; i <= waveCount; i++) {
      final x = (size.width / waveCount) * i;
      final y =
          size.height / 2 +
          math.sin((i * math.pi) + (animationProgress * 2 * math.pi)) *
              waveHeight;

      if (i == 0) {
        linePath.lineTo(x, y);
      } else {
        final prevX = (size.width / waveCount) * (i - 1);
        final controlX1 = prevX + (size.width / waveCount) * 0.5;
        final controlY1 =
            size.height / 2 +
            math.sin(
                  ((i - 0.5) * math.pi) + (animationProgress * 2 * math.pi),
                ) *
                waveHeight;

        linePath.quadraticBezierTo(controlX1, controlY1, x, y);
      }
    }

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(WaveDividerPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}

/// Angular/diagonal divider painter
class AngularDividerPainter extends CustomPainter {
  final Color color;
  final double animationProgress;

  AngularDividerPainter({required this.color, required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    final angle = 15 + (math.sin(animationProgress * 2 * math.pi) * 10);
    final midPoint = size.height / 2;
    final offset = math.tan(angle * math.pi / 180) * size.width;

    final path =
        Path()
          ..moveTo(0, midPoint - offset / 2)
          ..lineTo(size.width, midPoint + offset / 2)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    canvas.drawPath(path, paint);

    // Draw accent line
    final linePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(0, midPoint - offset / 2),
      Offset(size.width, midPoint + offset / 2),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(AngularDividerPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}

/// Smooth curve divider painter
class CurveDividerPainter extends CustomPainter {
  final Color color;
  final double animationProgress;

  CurveDividerPainter({required this.color, required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    final curveDepth = 50 + (math.sin(animationProgress * 2 * math.pi) * 20);
    final path =
        Path()
          ..moveTo(0, size.height / 2)
          ..quadraticBezierTo(
            size.width / 2,
            size.height / 2 + curveDepth,
            size.width,
            size.height / 2,
          )
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    canvas.drawPath(path, paint);

    // Draw accent line
    final linePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final linePath =
        Path()
          ..moveTo(0, size.height / 2)
          ..quadraticBezierTo(
            size.width / 2,
            size.height / 2 + curveDepth,
            size.width,
            size.height / 2,
          );

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(CurveDividerPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}

/// Asymmetric divider painter
class AsymmetricDividerPainter extends CustomPainter {
  final Color color;
  final double animationProgress;

  AsymmetricDividerPainter({
    required this.color,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    final leftHeight = 30 + (math.sin(animationProgress * 2 * math.pi) * 15);
    final rightHeight = 60 + (math.cos(animationProgress * 2 * math.pi) * 20);

    final path =
        Path()
          ..moveTo(0, size.height / 2 - leftHeight)
          ..cubicTo(
            size.width * 0.3,
            size.height / 2 - leftHeight,
            size.width * 0.7,
            size.height / 2 + rightHeight,
            size.width,
            size.height / 2 + rightHeight,
          )
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    canvas.drawPath(path, paint);

    // Draw accent line
    final linePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final linePath =
        Path()
          ..moveTo(0, size.height / 2 - leftHeight)
          ..cubicTo(
            size.width * 0.3,
            size.height / 2 - leftHeight,
            size.width * 0.7,
            size.height / 2 + rightHeight,
            size.width,
            size.height / 2 + rightHeight,
          );

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(AsymmetricDividerPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}

/// Zigzag divider painter
class ZigzagDividerPainter extends CustomPainter {
  final Color color;
  final double animationProgress;

  ZigzagDividerPainter({required this.color, required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    final zigzagCount = 6;
    final zigzagHeight = 30 + (math.sin(animationProgress * 2 * math.pi) * 10);
    final path = Path();

    path.moveTo(0, size.height / 2);

    for (var i = 0; i <= zigzagCount; i++) {
      final x = (size.width / zigzagCount) * i;
      final y =
          i.isEven
              ? size.height / 2 - zigzagHeight
              : size.height / 2 + zigzagHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw accent line
    final linePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final linePath = Path();
    linePath.moveTo(0, size.height / 2);

    for (var i = 0; i <= zigzagCount; i++) {
      final x = (size.width / zigzagCount) * i;
      final y =
          i.isEven
              ? size.height / 2 - zigzagHeight
              : size.height / 2 + zigzagHeight;
      linePath.lineTo(x, y);
    }

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(ZigzagDividerPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}

/// Premium reusable button widget with micro-interactions
class PremiumButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double width;
  final double height;

  const PremiumButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onTap,
    this.width = 180,
    this.height = 48,
  }) : super(key: key);

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.color, widget.color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow:
                    _isPressed
                        ? []
                        : [
                          BoxShadow(
                            color: widget.color.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
