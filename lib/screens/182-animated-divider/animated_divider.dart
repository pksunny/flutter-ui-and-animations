import 'package:flutter/material.dart';

class AnimatedDividerDemo extends StatefulWidget {
  const AnimatedDividerDemo({Key? key}) : super(key: key);

  @override
  State<AnimatedDividerDemo> createState() => _AnimatedDividerDemoState();
}

class _AnimatedDividerDemoState extends State<AnimatedDividerDemo> {
  bool _showDivider1 = false;
  bool _showDivider2 = false;
  bool _showDivider3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Header
              Text(
                'Animated Dividers',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Elegant line animations that bring structure to your sections',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 60),

              // Section 1
              _buildSection(
                context,
                title: 'Horizontal Draw',
                description: 'Classic left-to-right line animation',
                divider: AnimatedDivider(
                  show: _showDivider1,
                  direction: DividerDirection.horizontal,
                  color: Colors.blue,
                  thickness: 2.0,
                  duration: const Duration(milliseconds: 800),
                ),
                onTrigger: () => setState(() => _showDivider1 = !_showDivider1),
                isActive: _showDivider1,
              ),

              const SizedBox(height: 48),

              // Section 2
              _buildSection(
                context,
                title: 'Center Expand',
                description: 'Expands from center outward',
                divider: AnimatedDivider(
                  show: _showDivider2,
                  direction: DividerDirection.horizontal,
                  expandFrom: ExpandFrom.center,
                  color: Colors.purple,
                  thickness: 3.0,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                ),
                onTrigger: () => setState(() => _showDivider2 = !_showDivider2),
                isActive: _showDivider2,
              ),

              const SizedBox(height: 48),

              // Section 3
              _buildSection(
                context,
                title: 'Gradient Flow',
                description: 'Animated gradient divider with shimmer',
                divider: AnimatedDivider(
                  show: _showDivider3,
                  direction: DividerDirection.horizontal,
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.orange, Colors.yellow],
                  ),
                  thickness: 2.5,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeInOutQuart,
                ),
                onTrigger: () => setState(() => _showDivider3 = !_showDivider3),
                isActive: _showDivider3,
              ),

              const SizedBox(height: 60),

              // Reset All Button
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showDivider1 = false;
                      _showDivider2 = false;
                      _showDivider3 = false;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset All'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget divider,
    required VoidCallback onTrigger,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          divider,
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onTrigger,
            icon: Icon(isActive ? Icons.visibility_off : Icons.play_arrow),
            label: Text(isActive ? 'Hide' : 'Animate'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Direction for the divider animation
enum DividerDirection { horizontal, vertical }

/// Starting point for the expand animation
enum ExpandFrom { start, center, end }

/// Ultra-premium animated divider widget with drawing animation
///
/// This widget creates a divider line that animates from hidden to visible
/// with a smooth drawing effect. Highly customizable and reusable.
class AnimatedDivider extends StatefulWidget {
  /// Whether to show the divider (triggers animation)
  final bool show;

  /// Direction of the divider line
  final DividerDirection direction;

  /// Where the divider should expand from
  final ExpandFrom expandFrom;

  /// Solid color of the divider (ignored if gradient is provided)
  final Color color;

  /// Gradient for the divider (overrides color if provided)
  final Gradient? gradient;

  /// Thickness of the divider line
  final double thickness;

  /// Length of the divider (null = full width/height)
  final double? length;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Border radius for rounded ends
  final double borderRadius;

  const AnimatedDivider({
    Key? key,
    required this.show,
    this.direction = DividerDirection.horizontal,
    this.expandFrom = ExpandFrom.start,
    this.color = Colors.black,
    this.gradient,
    this.thickness = 1.0,
    this.length,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    this.borderRadius = 0.0,
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

    // Initialize animation controller
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Create curved animation
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    // Start animation if show is true
    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedDivider oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update duration if changed
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    // Trigger animation based on show state
    if (widget.show && !oldWidget.show) {
      _controller.forward();
    } else if (!widget.show && oldWidget.show) {
      _controller.reverse();
    }
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
        return CustomPaint(
          painter: _DividerPainter(
            progress: _animation.value,
            direction: widget.direction,
            expandFrom: widget.expandFrom,
            color: widget.color,
            gradient: widget.gradient,
            thickness: widget.thickness,
            borderRadius: widget.borderRadius,
          ),
          size: _calculateSize(),
        );
      },
    );
  }

  /// Calculate the size of the divider based on direction and length
  Size _calculateSize() {
    if (widget.direction == DividerDirection.horizontal) {
      return Size(widget.length ?? double.infinity, widget.thickness);
    } else {
      return Size(widget.thickness, widget.length ?? 200);
    }
  }
}

/// Custom painter for drawing the animated divider line
class _DividerPainter extends CustomPainter {
  final double progress;
  final DividerDirection direction;
  final ExpandFrom expandFrom;
  final Color color;
  final Gradient? gradient;
  final double thickness;
  final double borderRadius;

  _DividerPainter({
    required this.progress,
    required this.direction,
    required this.expandFrom,
    required this.color,
    this.gradient,
    required this.thickness,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..strokeCap = borderRadius > 0 ? StrokeCap.round : StrokeCap.butt
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke;

    // Apply gradient or solid color
    if (gradient != null) {
      final rect =
          direction == DividerDirection.horizontal
              ? Rect.fromLTWH(0, 0, size.width, thickness)
              : Rect.fromLTWH(0, 0, thickness, size.height);
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    // Calculate start and end points based on direction and expand origin
    final path = Path();

    if (direction == DividerDirection.horizontal) {
      _drawHorizontalLine(path, size);
    } else {
      _drawVerticalLine(path, size);
    }

    canvas.drawPath(path, paint);
  }

  void _drawHorizontalLine(Path path, Size size) {
    final width = size.width * progress;

    switch (expandFrom) {
      case ExpandFrom.start:
        // Draw from left to right
        path.moveTo(0, thickness / 2);
        path.lineTo(width, thickness / 2);
        break;

      case ExpandFrom.center:
        // Draw from center outward
        final center = size.width / 2;
        final halfWidth = width / 2;
        path.moveTo(center - halfWidth, thickness / 2);
        path.lineTo(center + halfWidth, thickness / 2);
        break;

      case ExpandFrom.end:
        // Draw from right to left
        path.moveTo(size.width, thickness / 2);
        path.lineTo(size.width - width, thickness / 2);
        break;
    }
  }

  void _drawVerticalLine(Path path, Size size) {
    final height = size.height * progress;

    switch (expandFrom) {
      case ExpandFrom.start:
        // Draw from top to bottom
        path.moveTo(thickness / 2, 0);
        path.lineTo(thickness / 2, height);
        break;

      case ExpandFrom.center:
        // Draw from center outward
        final center = size.height / 2;
        final halfHeight = height / 2;
        path.moveTo(thickness / 2, center - halfHeight);
        path.lineTo(thickness / 2, center + halfHeight);
        break;

      case ExpandFrom.end:
        // Draw from bottom to top
        path.moveTo(thickness / 2, size.height);
        path.lineTo(thickness / 2, size.height - height);
        break;
    }
  }

  @override
  bool shouldRepaint(_DividerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.thickness != thickness ||
        oldDelegate.direction != direction ||
        oldDelegate.expandFrom != expandFrom;
  }
}
