import 'package:flutter/material.dart';
import 'dart:math' as math;

class HandDrawnButtonOutlineAnimation extends StatelessWidget {
  const HandDrawnButtonOutlineAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hand-Drawn Button',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3142),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Hover or tap to see the magic',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 60),
            HandDrawnButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Button pressed!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF2D3142),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Text(
                'Click Me',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            HandDrawnButton(
              onPressed: () {},
              width: 280,
              height: 64,
              strokeWidth: 3.5,
              animationDuration: const Duration(milliseconds: 1400),
              strokeColor: const Color(0xFF6C5CE7),
              hoverBackgroundColor: const Color(0xFFF3F2FF),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            HandDrawnButton(
              onPressed: () {},
              width: 200,
              height: 52,
              strokeWidth: 2.5,
              animationDuration: const Duration(milliseconds: 1000),
              strokeColor: const Color(0xFFFF6B6B),
              hoverBackgroundColor: const Color(0xFFFFF5F5),
              borderRadius: 16,
              child: const Text(
                'Download',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium hand-drawn button with animated sketch-style stroke
/// 
/// Features:
/// - Animates stroke path on hover/tap to simulate hand-drawing
/// - Smooth transitions with custom curves
/// - Highly customizable (size, colors, animation speed)
/// - Micro-interactions for premium feel
/// - Reusable across projects
class HandDrawnButton extends StatefulWidget {
  /// Child widget displayed inside button
  final Widget child;
  
  /// Callback when button is pressed
  final VoidCallback onPressed;
  
  /// Button width (default: 220)
  final double width;
  
  /// Button height (default: 56)
  final double height;
  
  /// Stroke thickness (default: 3.0)
  final double strokeWidth;
  
  /// Color of the hand-drawn stroke
  final Color strokeColor;
  
  /// Background color on hover
  final Color hoverBackgroundColor;
  
  /// Text/icon color
  final Color foregroundColor;
  
  /// Border radius for rounded corners
  final double borderRadius;
  
  /// Animation duration for stroke drawing
  final Duration animationDuration;
  
  /// Whether animation plays on every hover (true) or just once (false)
  final bool animateOnEveryHover;

  const HandDrawnButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.width = 220,
    this.height = 56,
    this.strokeWidth = 3.0,
    this.strokeColor = const Color(0xFF2D3142),
    this.hoverBackgroundColor = const Color(0xFFF5F5F5),
    this.foregroundColor = const Color(0xFF2D3142),
    this.borderRadius = 12,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.animateOnEveryHover = true,
  }) : super(key: key);

  @override
  State<HandDrawnButton> createState() => _HandDrawnButtonState();
}

class _HandDrawnButtonState extends State<HandDrawnButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _strokeAnimation;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _hasAnimatedOnce = false;

  @override
  void initState() {
    super.initState();
    
    // Animation controller for stroke drawing
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Curved animation for natural hand-drawing feel
    _strokeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHoverEnter() {
    setState(() => _isHovered = true);
    
    // Trigger animation on hover if allowed
    if (widget.animateOnEveryHover || !_hasAnimatedOnce) {
      _controller.forward(from: 0);
      _hasAnimatedOnce = true;
    }
  }

  void _handleHoverExit() {
    setState(() => _isHovered = false);
  }

  void _handleTapDown() {
    setState(() => _isPressed = true);
    
    // Trigger animation on tap if not already triggered by hover
    if (!_isHovered && (widget.animateOnEveryHover || !_hasAnimatedOnce)) {
      _controller.forward(from: 0);
      _hasAnimatedOnce = true;
    }
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate scale for press animation
    final double scale = _isPressed ? 0.97 : 1.0;
    
    return MouseRegion(
      onEnter: (_) => _handleHoverEnter(),
      onExit: (_) => _handleHoverExit(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _handleTapDown(),
        onTapUp: (_) => _handleTapUp(),
        onTapCancel: _handleTapCancel,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: _isHovered || _isPressed
                  ? widget.hoverBackgroundColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Stack(
              children: [
                // Hand-drawn stroke animation
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _strokeAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: HandDrawnStrokePainter(
                          progress: _strokeAnimation.value,
                          strokeColor: widget.strokeColor,
                          strokeWidth: widget.strokeWidth,
                          borderRadius: widget.borderRadius,
                        ),
                      );
                    },
                  ),
                ),
                
                // Button content
                Center(
                  child: DefaultTextStyle(
                    style: TextStyle(color: widget.foregroundColor),
                    child: IconTheme(
                      data: IconThemeData(color: widget.foregroundColor),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that draws animated hand-drawn stroke effect
/// 
/// Simulates hand-drawing by progressively revealing the stroke path
/// with subtle imperfections for organic feel
class HandDrawnStrokePainter extends CustomPainter {
  final double progress;
  final Color strokeColor;
  final double strokeWidth;
  final double borderRadius;

  HandDrawnStrokePainter({
    required this.progress,
    required this.strokeColor,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Create rounded rectangle path
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    // Convert RRect to Path
    final path = Path()..addRRect(rrect);

    // Add subtle hand-drawn imperfections
    final handDrawnPath = _addHandDrawnEffect(path, size);

    // Calculate path metrics for progressive drawing
    final pathMetrics = handDrawnPath.computeMetrics().first;
    final totalLength = pathMetrics.length;
    final currentLength = totalLength * progress;

    // Extract visible portion of path
    final extractPath = pathMetrics.extractPath(0, currentLength);

    canvas.drawPath(extractPath, paint);
  }

  /// Adds subtle variations to path for organic hand-drawn feel
  Path _addHandDrawnEffect(Path originalPath, Size size) {
    final points = <Offset>[];
    
    // Sample points along the path
    final pathMetrics = originalPath.computeMetrics().first;
    final totalLength = pathMetrics.length;
    const sampleCount = 120; // More points = smoother but more detailed
    
    for (int i = 0; i <= sampleCount; i++) {
      final distance = (i / sampleCount) * totalLength;
      final tangent = pathMetrics.getTangentForOffset(distance);
      if (tangent != null) {
        final point = tangent.position;
        
        // Add subtle wobble (0.3-0.8 pixels max deviation)
        final wobbleX = _noise(i * 0.3) * 0.5;
        final wobbleY = _noise(i * 0.3 + 100) * 0.5;
        
        points.add(Offset(
          point.dx + wobbleX,
          point.dy + wobbleY,
        ));
      }
    }

    // Create new path with wobbled points
    final handDrawnPath = Path();
    if (points.isNotEmpty) {
      handDrawnPath.moveTo(points[0].dx, points[0].dy);
      
      // Use quadratic curves for smooth hand-drawn effect
      for (int i = 1; i < points.length - 1; i += 2) {
        final p1 = points[i];
        final p2 = i + 1 < points.length ? points[i + 1] : points[i];
        handDrawnPath.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
      }
    }

    return handDrawnPath;
  }

  /// Simple noise function for natural variations
  double _noise(double x) {
    return math.sin(x * 2.3) * math.cos(x * 1.7) * 0.8;
  }

  @override
  bool shouldRepaint(HandDrawnStrokePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}