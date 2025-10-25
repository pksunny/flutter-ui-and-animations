import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo page showcasing the morphing skeleton loader
class Morphing extends StatefulWidget {
  const Morphing({Key? key}) : super(key: key);

  @override
  State<Morphing> createState() => _MorphingState();
}

class _MorphingState extends State<Morphing> {
  bool _isLoading = true;

  void _reload() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Morphing Skeleton',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),

            // Content List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: MorphingMorphing(
                      isLoading: _isLoading,
                      duration: const Duration(milliseconds: 2500),
                      morphDuration: const Duration(milliseconds: 800),
                      shimmerDuration: const Duration(milliseconds: 1500),
                      skeletonConfig: SkeletonConfig(
                        shapes: [
                          SkeletonShape.circle(
                            size: 60,
                            alignment: Alignment.centerLeft,
                          ),
                          SkeletonShape.roundedRect(
                            width: 120,
                            height: 16,
                            borderRadius: 8,
                            offset: const Offset(75, 8),
                          ),
                          SkeletonShape.roundedRect(
                            width: 80,
                            height: 12,
                            borderRadius: 6,
                            offset: const Offset(75, 32),
                          ),
                        ],
                        baseColor: const Color(0xFF1A1F3A),
                        highlightColor: const Color(0xFF2D3454),
                        shimmerGradient: const LinearGradient(
                          colors: [
                            Color(0xFF1A1F3A),
                            Color(0xFF3D4566),
                            Color(0xFF1A1F3A),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: _buildContentCard(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(int index) {
    final colors = [
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFFD79A8),
      const Color(0xFF74B9FF),
      const Color(0xFFFFA502),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[index % colors.length].withOpacity(0.1),
            colors[index % colors.length].withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors[index % colors.length].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colors[index % colors.length],
                  colors[index % colors.length].withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[index % colors.length].withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Active now',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors[index % colors.length],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Configuration class for skeleton shapes
class SkeletonConfig {
  final List<SkeletonShape> shapes;
  final Color baseColor;
  final Color highlightColor;
  final Gradient shimmerGradient;

  const SkeletonConfig({
    required this.shapes,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.shimmerGradient = const LinearGradient(
      colors: [
        Color(0xFFE0E0E0),
        Color(0xFFF5F5F5),
        Color(0xFFE0E0E0),
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  });
}

/// Represents a single skeleton shape with morphing properties
class SkeletonShape {
  final double width;
  final double height;
  final double borderRadius;
  final Offset offset;
  final Alignment alignment;
  final bool isCircle;

  const SkeletonShape({
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.offset = Offset.zero,
    this.alignment = Alignment.topLeft,
    this.isCircle = false,
  });

  factory SkeletonShape.circle({
    required double size,
    Offset offset = Offset.zero,
    Alignment alignment = Alignment.center,
  }) {
    return SkeletonShape(
      width: size,
      height: size,
      borderRadius: size / 2,
      offset: offset,
      alignment: alignment,
      isCircle: true,
    );
  }

  factory SkeletonShape.roundedRect({
    required double width,
    required double height,
    double borderRadius = 8,
    Offset offset = Offset.zero,
    Alignment alignment = Alignment.topLeft,
  }) {
    return SkeletonShape(
      width: width,
      height: height,
      borderRadius: borderRadius,
      offset: offset,
      alignment: alignment,
    );
  }
}

/// Main morphing skeleton loader widget
class MorphingMorphing extends StatefulWidget {
  /// Whether to show loading skeleton or actual content
  final bool isLoading;

  /// The actual content widget to display after loading
  final Widget child;

  /// Configuration for skeleton shapes
  final SkeletonConfig skeletonConfig;

  /// Total duration before transitioning to content
  final Duration duration;

  /// Duration of the morph animation
  final Duration morphDuration;

  /// Duration of shimmer animation cycle
  final Duration shimmerDuration;

  /// Delay before starting the animation
  final Duration delay;

  const MorphingMorphing({
    Key? key,
    required this.isLoading,
    required this.child,
    required this.skeletonConfig,
    this.duration = const Duration(milliseconds: 2000),
    this.morphDuration = const Duration(milliseconds: 600),
    this.shimmerDuration = const Duration(milliseconds: 1200),
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<MorphingMorphing> createState() => _MorphingMorphingState();
}

class _MorphingMorphingState extends State<MorphingMorphing>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _shimmerController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _morphController = AnimationController(
      vsync: this,
      duration: widget.morphDuration,
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: widget.shimmerDuration,
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    if (widget.isLoading) {
      _startLoadingSequence();
    } else {
      _fadeController.value = 1.0;
    }
  }

  void _startLoadingSequence() async {
    await Future.delayed(widget.delay);
    if (!mounted) return;

    // Continuous morph animation during loading
    _morphController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(MorphingMorphing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLoading != widget.isLoading) {
      if (widget.isLoading) {
        _fadeController.value = 0.0;
        _morphController.repeat(reverse: true);
      } else {
        _morphController.stop();
        _fadeController.forward();
      }
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _shimmerController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: widget.isLoading
          ? _buildSkeleton()
          : FadeTransition(
              opacity: _fadeController,
              child: widget.child,
            ),
    );
  }

  Widget _buildSkeleton() {
    return AnimatedBuilder(
      animation: Listenable.merge([_morphController, _shimmerController]),
      builder: (context, child) {
        return CustomPaint(
          painter: MorphingSkeletonPainter(
            shapes: widget.skeletonConfig.shapes,
            morphProgress: _morphController.value,
            shimmerProgress: _shimmerController.value,
            baseColor: widget.skeletonConfig.baseColor,
            highlightColor: widget.skeletonConfig.highlightColor,
            shimmerGradient: widget.skeletonConfig.shimmerGradient,
          ),
          child: SizedBox(
            width: double.infinity,
            height: _calculateSkeletonHeight(),
          ),
        );
      },
    );
  }

  double _calculateSkeletonHeight() {
    double maxHeight = 0;
    for (var shape in widget.skeletonConfig.shapes) {
      final bottom = shape.offset.dy + shape.height;
      if (bottom > maxHeight) maxHeight = bottom;
    }
    return maxHeight + 32; // Add padding
  }
}

/// Custom painter for morphing skeleton shapes
class MorphingSkeletonPainter extends CustomPainter {
  final List<SkeletonShape> shapes;
  final double morphProgress;
  final double shimmerProgress;
  final Color baseColor;
  final Color highlightColor;
  final Gradient shimmerGradient;

  MorphingSkeletonPainter({
    required this.shapes,
    required this.morphProgress,
    required this.shimmerProgress,
    required this.baseColor,
    required this.highlightColor,
    required this.shimmerGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    // Draw base shapes
    for (var shape in shapes) {
      final rect = _calculateMorphedRect(shape, size);
      final radius = _calculateMorphedRadius(shape);

      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(radius),
      );

      canvas.drawRRect(rrect, basePaint);
    }

    // Draw shimmer effect
    _drawShimmer(canvas, size);
  }

  Rect _calculateMorphedRect(SkeletonShape shape, Size size) {
    // Create organic breathing effect
    final breatheFactor = math.sin(morphProgress * math.pi * 2) * 0.05;
    final pulseX = math.cos(morphProgress * math.pi * 4) * 2;
    final pulseY = math.sin(morphProgress * math.pi * 3) * 1;

    final morphedWidth = shape.width * (1 + breatheFactor);
    final morphedHeight = shape.height * (1 + breatheFactor);

    return Rect.fromLTWH(
      shape.offset.dx + pulseX,
      shape.offset.dy + pulseY,
      morphedWidth,
      morphedHeight,
    );
  }

  double _calculateMorphedRadius(SkeletonShape shape) {
    if (shape.isCircle) {
      return shape.borderRadius;
    }

    // Subtle radius morphing
    final radiusWave = math.sin(morphProgress * math.pi * 2) * 2;
    return (shape.borderRadius + radiusWave).clamp(4.0, 50.0);
  }

  void _drawShimmer(Canvas canvas, Size size) {
    final shimmerPaint = Paint()..blendMode = BlendMode.srcATop;

    // Calculate shimmer position
    final shimmerX = -size.width + (shimmerProgress * size.width * 2);

    // Create shimmer gradient
    shimmerPaint.shader = LinearGradient(
      colors: shimmerGradient.colors,
      stops: shimmerGradient.stops,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      transform: GradientRotation(0.3),
    ).createShader(
      Rect.fromLTWH(shimmerX, 0, size.width, size.height),
    );

    // Draw shimmer over shapes
    for (var shape in shapes) {
      final rect = _calculateMorphedRect(shape, size);
      final radius = _calculateMorphedRadius(shape);

      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(radius),
      );

      canvas.drawRRect(rrect, shimmerPaint);
    }
  }

  @override
  bool shouldRepaint(MorphingSkeletonPainter oldDelegate) {
    return oldDelegate.morphProgress != morphProgress ||
        oldDelegate.shimmerProgress != shimmerProgress;
  }
}