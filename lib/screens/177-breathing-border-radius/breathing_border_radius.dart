import 'package:flutter/material.dart';
import 'dart:math' as math;

class BreathingBorderRadiusDemo extends StatelessWidget {
  const BreathingBorderRadiusDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF8F9FA),
              const Color(0xFFE9ECEF),
              const Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildCardGrid(),
                const SizedBox(height: 40),
                _buildCustomizationSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Breathing Cards',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Watch the corners breathe with subtle elegance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C757D),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCardGrid() {
    return Column(
      children: [
        // Row 1: Premium Cards
        Row(
          children: [
            Expanded(
              child: BreathingBorderCard(
                duration: const Duration(seconds: 4),
                minRadius: 5,
                maxRadius: 32,
                child: _buildCardContent(
                  icon: Icons.stars_rounded,
                  title: 'Premium',
                  subtitle: 'Slow & Smooth',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BreathingBorderCard(
                duration: const Duration(seconds: 3),
                minRadius: 20,
                maxRadius: 40,
                child: _buildCardContent(
                  icon: Icons.bolt_rounded,
                  title: 'Dynamic',
                  subtitle: 'Fast Breathing',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 2: Feature Cards
        Row(
          children: [
            Expanded(
              child: BreathingBorderCard(
                duration: const Duration(milliseconds: 3500),
                minRadius: 18,
                maxRadius: 36,
                curve: Curves.easeInOutCubic,
                child: _buildCardContent(
                  icon: Icons.water_drop_rounded,
                  title: 'Elegant',
                  subtitle: 'Cubic Ease',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BreathingBorderCard(
                duration: const Duration(milliseconds: 5000),
                minRadius: 12,
                maxRadius: 28,
                curve: Curves.easeInOutQuart,
                child: _buildCardContent(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Luxury',
                  subtitle: 'Quart Ease',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 3: Large Feature Card
        BreathingBorderCard(
          duration: const Duration(milliseconds: 4500),
          minRadius: 24,
          maxRadius: 48,
          curve: Curves.easeInOutSine,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF30CFD0), const Color(0xFF330867)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Featured Experience',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A premium breathing effect that creates an almost imperceptible but deeply satisfying sense of life and motion',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customization Variants',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),

        // Sharp Corners Variant
        BreathingBorderCard(
          duration: const Duration(seconds: 3),
          minRadius: 4,
          maxRadius: 24,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.crop_square_rounded, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sharp to Round',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From 4px to 24px radius',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Super Rounded Variant
        BreathingBorderCard(
          duration: const Duration(milliseconds: 6000),
          minRadius: 40,
          maxRadius: 60,
          curve: Curves.easeInOutBack,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFFFEFBA), const Color(0xFFFFFFFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD93D).withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFC837), Color(0xFFFF8008)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.circle_rounded, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Super Rounded',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Extreme breathing: 40px to 60px',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
  }) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🌟 BREATHING BORDER RADIUS CARD WIDGET
///
/// A premium, production-ready widget that creates a subtle breathing effect
/// by animating the border radius between two values.
///
/// This creates an almost imperceptible but premium feeling of life and motion.
///
/// Features:
/// - Fully customizable duration, radius range, and animation curve
/// - Automatic infinite loop with reverse animation
/// - Production-ready and performance-optimized
/// - Highly reusable across different apps
///
/// Parameters:
/// - [child]: The widget to display inside the breathing card
/// - [duration]: How long one breath cycle takes (default: 4 seconds)
/// - [minRadius]: Minimum border radius in pixels (default: 16)
/// - [maxRadius]: Maximum border radius in pixels (default: 32)
/// - [curve]: Animation curve for breathing effect (default: easeInOutSine)
///
/// Example:
/// ```dart
/// BreathingBorderCard(
///   duration: Duration(seconds: 5),
///   minRadius: 20,
///   maxRadius: 40,
///   curve: Curves.easeInOutCubic,
///   child: YourContentWidget(),
/// )
/// ```
class BreathingBorderCard extends StatefulWidget {
  /// The widget to display inside the breathing card
  final Widget child;

  /// Duration of one complete breathing cycle (round → sharp → round)
  final Duration duration;

  /// Minimum border radius in pixels (when "exhaled")
  final double minRadius;

  /// Maximum border radius in pixels (when "inhaled")
  final double maxRadius;

  /// Animation curve for the breathing effect
  final Curve curve;

  const BreathingBorderCard({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 4),
    this.minRadius = 16.0,
    this.maxRadius = 32.0,
    this.curve = Curves.easeInOutSine,
  }) : assert(minRadius >= 0, 'minRadius must be non-negative'),
       assert(
         maxRadius > minRadius,
         'maxRadius must be greater than minRadius',
       ),
       super(key: key);

  @override
  State<BreathingBorderCard> createState() => _BreathingBorderCardState();
}

class _BreathingBorderCardState extends State<BreathingBorderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  /// Initialize the breathing animation controller and tween
  void _initializeAnimation() {
    // Create animation controller with specified duration
    _controller = AnimationController(duration: widget.duration, vsync: this);

    // Create tween animation for border radius
    _radiusAnimation = Tween<double>(
      begin: widget.minRadius,
      end: widget.maxRadius,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Start infinite breathing animation (forward → reverse → repeat)
    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(BreathingBorderCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize animation if parameters changed
    if (oldWidget.duration != widget.duration ||
        oldWidget.minRadius != widget.minRadius ||
        oldWidget.maxRadius != widget.maxRadius ||
        oldWidget.curve != widget.curve) {
      _controller.dispose();
      _initializeAnimation();
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
      animation: _radiusAnimation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(_radiusAnimation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// 🎨 BREATHING BORDER RADIUS CONTAINER
///
/// A simpler variant that includes both the breathing border radius
/// and a container with customizable decoration.
///
/// Perfect for quick implementations without manually wrapping content.
///
/// Parameters:
/// - [width]: Container width (default: double.infinity)
/// - [height]: Container height (default: 200)
/// - [padding]: Internal padding (default: 24)
/// - [decoration]: Container decoration (color, gradient, etc.)
/// - [child]: The widget to display inside
/// - [duration]: Breathing cycle duration
/// - [minRadius]: Minimum border radius
/// - [maxRadius]: Maximum border radius
/// - [curve]: Animation curve
///
/// Example:
/// ```dart
/// BreathingBorderContainer(
///   decoration: BoxDecoration(
///     gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
///   ),
///   child: Text('Premium Content'),
/// )
/// ```
class BreathingBorderContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final Decoration? decoration;
  final Widget child;
  final Duration duration;
  final double minRadius;
  final double maxRadius;
  final Curve curve;

  const BreathingBorderContainer({
    Key? key,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(24),
    this.decoration,
    required this.child,
    this.duration = const Duration(seconds: 4),
    this.minRadius = 16.0,
    this.maxRadius = 32.0,
    this.curve = Curves.easeInOutSine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BreathingBorderCard(
      duration: duration,
      minRadius: minRadius,
      maxRadius: maxRadius,
      curve: curve,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: decoration,
        child: child,
      ),
    );
  }
}
