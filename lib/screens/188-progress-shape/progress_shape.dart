import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressShape extends StatefulWidget {
  const ProgressShape({Key? key}) : super(key: key);

  @override
  State<ProgressShape> createState() => _ProgressShapeState();
}

class _ProgressShapeState extends State<ProgressShape> {
  double _storyProgress = 0.0;
  double _onboardingProgress = 0.0;
  double _circleProgress = 0.0;
  bool _isStoryAnimating = false;
  bool _isOnboardingAnimating = false;
  bool _isCircleAnimating = false;

  void _startStoryProgress() {
    if (_isStoryAnimating) return;
    setState(() {
      _isStoryAnimating = true;
      _storyProgress = 0.0;
    });

    // Simulate story progression
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _storyProgress = 1.0);
        Future.delayed(const Duration(milliseconds: 3000), () {
          if (mounted) {
            setState(() => _isStoryAnimating = false);
          }
        });
      }
    });
  }

  void _startOnboardingProgress() {
    if (_isOnboardingAnimating) return;
    setState(() {
      _isOnboardingAnimating = true;
      _onboardingProgress = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _onboardingProgress = 1.0);
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) {
            setState(() => _isOnboardingAnimating = false);
          }
        });
      }
    });
  }

  void _startCircleProgress() {
    if (_isCircleAnimating) return;
    setState(() {
      _isCircleAnimating = true;
      _circleProgress = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _circleProgress = 1.0);
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            setState(() => _isCircleAnimating = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              const Text(
                'Morph Progress',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Progress as shape transformation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 48),

              // Story Progress Section
              _buildSection(
                title: 'Story Progress',
                subtitle: 'Instagram-style morphing bar',
                child: Column(
                  children: [
                    MorphProgressBar(
                      progress: _storyProgress,
                      height: 4,
                      backgroundColor: const Color(0xFFE5E5E5),
                      foregroundColor: const Color(0xFF6366F1),
                      borderRadius: 2,
                      duration: const Duration(milliseconds: 2800),
                      curve: Curves.easeInOut,
                    ),
                    const SizedBox(height: 24),
                    _buildActionButton(
                      label: 'Start Story',
                      onPressed: _startStoryProgress,
                      isActive: _isStoryAnimating,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Onboarding Progress Section
              _buildSection(
                title: 'Onboarding Steps',
                subtitle: 'Pill-shaped morph indicator',
                child: Column(
                  children: [
                    MorphProgressBar(
                      progress: _onboardingProgress,
                      height: 8,
                      backgroundColor: const Color(0xFFF0F0F0),
                      foregroundColor: const Color(0xFF10B981),
                      borderRadius: 4,
                      duration: const Duration(milliseconds: 2200),
                      curve: Curves.easeInOutCubic,
                    ),
                    const SizedBox(height: 24),
                    _buildActionButton(
                      label: 'Start Onboarding',
                      onPressed: _startOnboardingProgress,
                      isActive: _isOnboardingAnimating,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Circle Morph Progress Section
              _buildSection(
                title: 'Circle Morph',
                subtitle: 'Circular fill animation',
                child: Column(
                  children: [
                    Center(
                      child: MorphCircleProgress(
                        progress: _circleProgress,
                        size: 120,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFFF0F0F0),
                        foregroundColor: const Color(0xFFEC4899),
                        duration: const Duration(milliseconds: 1800),
                        curve: Curves.easeInOutQuart,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildActionButton(
                      label: 'Start Circle',
                      onPressed: _startCircleProgress,
                      isActive: _isCircleAnimating,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Multiple Story Bars Demo
              _buildSection(
                title: 'Multi-Story View',
                subtitle: 'Multiple morphing segments',
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < 3 ? 6.0 : 0),
                        child: MorphProgressBar(
                          progress: _storyProgress,
                          height: 3,
                          backgroundColor: const Color(0xFFE0E0E0),
                          foregroundColor: const Color(0xFF6366F1),
                          borderRadius: 1.5,
                          duration: Duration(
                            milliseconds: 2800 + (index * 200),
                          ),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE0E0E0),
          disabledForegroundColor: const Color(0xFF999999),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isActive ? 'Animating...' : label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

/// Reusable Morph Progress Bar Widget
/// Animates from empty to filled state with smooth shape morphing
class MorphProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final Duration duration;
  final Curve curve;

  const MorphProgressBar({
    Key? key,
    required this.progress,
    this.height = 4.0,
    this.backgroundColor = const Color(0xFFE5E5E5),
    this.foregroundColor = const Color(0xFF6366F1),
    this.borderRadius = 2.0,
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: progress),
          duration: duration,
          curve: curve,
          builder: (context, value, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Reusable Morph Circle Progress Widget
/// Circular progress indicator with morphing fill animation
class MorphCircleProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final Duration duration;
  final Curve curve;

  const MorphCircleProgress({
    Key? key,
    required this.progress,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    this.backgroundColor = const Color(0xFFE5E5E5),
    this.foregroundColor = const Color(0xFF6366F1),
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: progress),
        duration: duration,
        curve: curve,
        builder: (context, value, child) {
          return Stack(
            children: [
              // Background circle
              CustomPaint(
                size: Size(size, size),
                painter: _CirclePainter(
                  progress: 1.0,
                  color: backgroundColor,
                  strokeWidth: strokeWidth,
                ),
              ),
              // Foreground progress circle
              CustomPaint(
                size: Size(size, size),
                painter: _CirclePainter(
                  progress: value,
                  color: foregroundColor,
                  strokeWidth: strokeWidth,
                ),
              ),
              // Center percentage text
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: value * 100),
                  duration: duration,
                  curve: curve,
                  builder: (context, textValue, child) {
                    return Text(
                      '${textValue.toInt()}%',
                      style: TextStyle(
                        fontSize: size * 0.2,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Custom painter for circular progress
class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CirclePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Draw arc from top (-90 degrees) clockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
