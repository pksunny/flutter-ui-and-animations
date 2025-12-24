import 'package:flutter/material.dart';

/// Showcase screen demonstrating various bounce effects
class BounceShowcase extends StatelessWidget {
  const BounceShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildSection('Button Bounces', _buildButtonExamples()),
              const SizedBox(height: 40),
              _buildSection('Card Bounces', _buildCardExamples()),
              const SizedBox(height: 40),
              _buildSection('Image & Icon Bounces', _buildImageExamples()),
              const SizedBox(height: 40),
              _buildSection('Custom Intensity', _buildIntensityExamples()),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '✨ Bounce on Tap',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Minimal bounce effects that make UI feel alive',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2A2A2A),
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildButtonExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        BounceTap(
          onTap: () => debugPrint('Primary button tapped'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Text(
              'Primary Action',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        BounceTap(
          onTap: () => debugPrint('Secondary button tapped'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF667EEA), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Secondary',
              style: TextStyle(
                color: Color(0xFF667EEA),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        BounceTap(
          onTap: () => debugPrint('Product card tapped'),
          child: Container(
            width: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFA709A), Color(0xFFFF5858)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Product',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A2A2A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$99.99',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        BounceTap(
          onTap: () => debugPrint('Feature card tapped'),
          child: Container(
            width: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF43E97B).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Premium',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upgrade now',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageExamples() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        BounceTap(
          onTap: () => debugPrint('Avatar tapped'),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF093FB).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ),
        BounceTap(
          onTap: () => debugPrint('Notification tapped'),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 28,
                    color: Color(0xFF667EEA),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5858),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BounceTap(
          onTap: () => debugPrint('Icon button tapped'),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.favorite, size: 28, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildIntensityExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          children: [
            BounceTap(
              intensity: BounceIntensity.light,
              onTap: () => debugPrint('Light bounce'),
              child: _buildIntensityButton('Light', const Color(0xFF00B4DB)),
            ),
            const SizedBox(height: 8),
            Text(
              'Subtle',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        Column(
          children: [
            BounceTap(
              intensity: BounceIntensity.medium,
              onTap: () => debugPrint('Medium bounce'),
              child: _buildIntensityButton('Medium', const Color(0xFF667EEA)),
            ),
            const SizedBox(height: 8),
            Text(
              'Balanced',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        Column(
          children: [
            BounceTap(
              intensity: BounceIntensity.strong,
              onTap: () => debugPrint('Strong bounce'),
              child: _buildIntensityButton('Strong', const Color(0xFFFA709A)),
            ),
            const SizedBox(height: 8),
            Text(
              'Playful',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntensityButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Bounce intensity presets
enum BounceIntensity {
  light(0.97, 100), // 3% scale down, 100ms
  medium(0.95, 120), // 5% scale down, 120ms
  strong(0.92, 150); // 8% scale down, 150ms

  final double scale;
  final int duration;
  const BounceIntensity(this.scale, this.duration);
}

/// Main BounceTap widget - Production-ready, reusable bounce animation
///
/// This widget adds a smooth bounce effect when tapped, making UI elements
/// feel alive and responsive without being overwhelming.
///
/// Example usage:
/// ```dart
/// BounceTap(
///   onTap: () => print('Tapped!'),
///   child: YourWidget(),
/// )
/// ```
class BounceTap extends StatefulWidget {
  /// The widget to apply bounce effect to
  final Widget child;

  /// Callback when the widget is tapped
  final VoidCallback? onTap;

  /// Bounce intensity preset (light, medium, strong)
  final BounceIntensity intensity;

  /// Custom scale factor (overrides intensity if provided)
  /// Value between 0.0 and 1.0, where 1.0 is no scale, 0.9 is 10% smaller
  final double? customScale;

  /// Custom animation duration in milliseconds
  final int? customDuration;

  /// Animation curve for scale down
  final Curve curveDown;

  /// Animation curve for scale up (bounce back)
  final Curve curveUp;

  /// Enable haptic feedback on tap
  final bool enableHaptic;

  const BounceTap({
    Key? key,
    required this.child,
    this.onTap,
    this.intensity = BounceIntensity.medium,
    this.customScale,
    this.customDuration,
    this.curveDown = Curves.easeInOut,
    this.curveUp = Curves.elasticOut,
    this.enableHaptic = false,
  }) : super(key: key);

  @override
  State<BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<BounceTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    final duration = widget.customDuration ?? widget.intensity.duration;

    _controller = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: widget.customScale ?? widget.intensity.scale,
        ).chain(CurveTween(curve: widget.curveDown)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.customScale ?? widget.intensity.scale,
          end: 1.0,
        ).chain(CurveTween(curve: widget.curveUp)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(BounceTap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.intensity != widget.intensity ||
        oldWidget.customScale != widget.customScale ||
        oldWidget.customDuration != widget.customDuration) {
      _controller.dispose();
      _initializeAnimation();
    }
  }

  void _handleTap() {
    if (widget.onTap != null) {
      // Trigger bounce animation
      _controller.forward(from: 0.0);

      // Execute callback
      widget.onTap!();

      // Optional haptic feedback
      if (widget.enableHaptic) {
        // Note: Add haptic_feedback package and import it
        // HapticFeedback.lightImpact();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

/// Alternative: Simplified bounce wrapper for quick usage
class QuickBounce extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const QuickBounce({Key? key, required this.child, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BounceTap(onTap: onTap, child: child);
  }
}
