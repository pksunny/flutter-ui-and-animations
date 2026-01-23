import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientEdgeFlow extends StatelessWidget {
  const GradientEdgeFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Premium title with subtle animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
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
              child: const Text(
                'Gradient Edge Flow',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5,
                  color: Color(0xFF1a1a1a),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Premium Flutter Animation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 60),
            
            // Different style variations
            const GradientEdgeFlowButton(
              label: 'Get Started',
              width: 240,
              height: 56,
              borderWidth: 10,
            ),
            const SizedBox(height: 24),
            
            const GradientEdgeFlowButton(
              label: 'Learn More',
              width: 200,
              height: 48,
              gradientColors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
                Color(0xFFEC4899),
              ],
              borderWidth: 5.0,
            ),
            const SizedBox(height: 24),
            
            const GradientEdgeFlowButton(
              label: 'Contact Us',
              width: 180,
              height: 44,
              gradientColors: [
                Color(0xFF10B981),
                Color(0xFF3B82F6),
                Color(0xFF6366F1),
              ],
              borderWidth: 1.5,
              animationSpeed: 4.0,
            ),
            const SizedBox(height: 60),
            
            // Small interactive demo
            const GradientEdgeFlowCard(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 32,
                      color: Color(0xFF3B82F6),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Premium Card',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a1a1a),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hover to see the magic',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium button with gradient flowing animation on edges only
/// 
/// Features:
/// - Gradient flows along the border/edge perimeter
/// - Clean interior without gradient interference
/// - Smooth continuous animation
/// - Hover state with scale and shadow effects
/// - Highly customizable parameters
class GradientEdgeFlowButton extends StatefulWidget {
  final String label;
  final double width;
  final double height;
  final List<Color> gradientColors;
  final double borderWidth;
  final double borderRadius;
  final double animationSpeed;
  final VoidCallback? onTap;

  const GradientEdgeFlowButton({
    super.key,
    required this.label,
    this.width = 200,
    this.height = 50,
    this.gradientColors = const [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
    ],
    this.borderWidth = 2.0,
    this.borderRadius = 12.0,
    this.animationSpeed = 3.0,
    this.onTap,
  });

  @override
  State<GradientEdgeFlowButton> createState() => _GradientEdgeFlowButtonState();
}

class _GradientEdgeFlowButtonState extends State<GradientEdgeFlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // Continuous rotation animation for gradient flow
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.animationSpeed.toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.gradientColors.first.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: GradientEdgePainter(
                    progress: _controller.value,
                    colors: widget.gradientColors,
                    borderWidth: widget.borderWidth,
                    borderRadius: widget.borderRadius,
                  ),
                  child: child,
                );
              },
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that draws gradient flowing along the edge/border
/// 
/// Implementation:
/// - Creates a continuous gradient that rotates around the perimeter
/// - Uses sweep gradient with rotation animation
/// - Clips the gradient to only show on the border area
class GradientEdgePainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double borderWidth;
  final double borderRadius;

  GradientEdgePainter({
    required this.progress,
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;

    // Create rotating sweep gradient
    final gradient = SweepGradient(
      colors: [...colors, colors.first], // Loop back to first color
      stops: _generateStops(colors.length + 1),
      transform: GradientRotation(progress * 2 * math.pi),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw rounded rectangle border with gradient
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rrect, paint);
  }

  List<double> _generateStops(int count) {
    return List.generate(count, (index) => index / (count - 1));
  }

  @override
  bool shouldRepaint(GradientEdgePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}

/// Premium card with gradient edge flow animation
/// 
/// Features:
/// - Same gradient edge animation as button
/// - Scales and elevates on hover
/// - Clean white interior
/// - Accepts any child widget
class GradientEdgeFlowCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final List<Color> gradientColors;
  final double borderWidth;
  final double animationSpeed;

  const GradientEdgeFlowCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.gradientColors = const [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
    ],
    this.borderWidth = 2.0,
    this.animationSpeed = 3.0,
  });

  @override
  State<GradientEdgeFlowCard> createState() => _GradientEdgeFlowCardState();
}

class _GradientEdgeFlowCardState extends State<GradientEdgeFlowCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.animationSpeed.toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.gradientColors.first.withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: GradientEdgePainter(
                  progress: _controller.value,
                  colors: widget.gradientColors,
                  borderWidth: widget.borderWidth,
                  borderRadius: widget.borderRadius,
                ),
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}