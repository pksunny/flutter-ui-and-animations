import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Demo screen showcasing the Haptic Reaction Glow widget
class ReactionGlow extends StatefulWidget {
  const ReactionGlow({Key? key}) : super(key: key);

  @override
  State<ReactionGlow> createState() => _ReactionGlowState();
}

class _ReactionGlowState extends State<ReactionGlow> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  int _likeCount = 0;
  bool _isBookmarked = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
              const Color(0xFF0A0E21),
              const Color(0xFF1D1E33),
              const Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const SizedBox(height: 20),
                Text(
                  '✨ Haptic Glow',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF7B2FFF)],
                      ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Experience haptic feedback with beautiful glow animations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // Example 1: Primary Button
                _buildSectionTitle('Primary Action Button'),
                const SizedBox(height: 16),
                HapticReactionGlow(
                  onTap: () {
                    _showSnackBar('Primary action triggered!');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF0091FF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rocket_launch, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Launch Experience',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Example 2: Icon Buttons
                _buildSectionTitle('Interactive Icons'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HapticReactionGlow(
                      glowColor: Colors.pink,
                      onTap: () {
                        setState(() => _likeCount++);
                      },
                      child: _buildIconButton(
                        Icons.favorite,
                        Colors.pink,
                        _likeCount.toString(),
                      ),
                    ),
                    HapticReactionGlow(
                      glowColor: Colors.amber,
                      onTap: () {
                        setState(() => _isBookmarked = !_isBookmarked);
                      },
                      child: _buildIconButton(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        Colors.amber,
                        'Save',
                      ),
                    ),
                    HapticReactionGlow(
                      glowColor: Colors.green,
                      onTap: () {
                        _showSnackBar('Shared successfully!');
                      },
                      child: _buildIconButton(
                        Icons.share,
                        Colors.green,
                        'Share',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Example 3: Form Submit
                _buildSectionTitle('Form Submission'),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(),
                      const SizedBox(height: 20),
                      HapticReactionGlow(
                        glowColor: const Color(0xFF7B2FFF),
                        hapticType: HapticType.medium,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _showSnackBar('Form submitted successfully!');
                            _emailController.clear();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B2FFF), Color(0xFFB537F2)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Example 4: Card Interaction
                _buildSectionTitle('Interactive Card'),
                const SizedBox(height: 16),
                HapticReactionGlow(
                  glowColor: const Color(0xFF00FFA3),
                  glowSize: 1.15,
                  onTap: () {
                    _showSnackBar('Card selected!');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1D1E33),
                          const Color(0xFF2D2E43),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00FFA3), Color(0xFF00C9FF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Premium Feature',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Unlock advanced capabilities',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.4),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Customization Options
                _buildSectionTitle('Fully Customizable'),
                const SizedBox(height: 16),
                _buildFeatureChip('🎨 Custom Glow Colors'),
                const SizedBox(height: 8),
                _buildFeatureChip('⚡ Multiple Haptic Types'),
                const SizedBox(height: 8),
                _buildFeatureChip('🎭 Adjustable Animation Duration'),
                const SizedBox(height: 8),
                _buildFeatureChip('📏 Configurable Glow Size'),
                const SizedBox(height: 8),
                _buildFeatureChip('🔧 Production Ready'),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, String label) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(Icons.email, color: Colors.white.withOpacity(0.6)),
        filled: true,
        fillColor: const Color(0xFF1D1E33),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF7B2FFF),
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1D1E33),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Enum for different haptic feedback types
enum HapticType {
  light,
  medium,
  heavy,
  selection,
  success,
  warning,
  error,
}

/// 🌟 HAPTIC REACTION GLOW WIDGET
/// 
/// A highly customizable, production-ready widget that combines haptic feedback
/// with beautiful glow pulse animations on tap interactions.
/// 
/// Features:
/// - Smooth glow pulse animation
/// - Haptic feedback on tap
/// - Fully customizable colors, duration, and intensity
/// - Reusable across different UI components
/// - Built with performance in mind
/// 
/// Usage:
/// ```dart
/// HapticReactionGlow(
///   onTap: () => print('Tapped!'),
///   glowColor: Colors.blue,
///   child: YourWidget(),
/// )
/// ```
class HapticReactionGlow extends StatefulWidget {
  /// The child widget to wrap with glow effect
  final Widget child;

  /// Callback function when tapped
  final VoidCallback onTap;

  /// Color of the glow effect (default: cyan)
  final Color glowColor;

  /// Duration of the glow animation (default: 600ms)
  final Duration duration;

  /// Type of haptic feedback (default: light)
  final HapticType hapticType;

  /// Maximum scale of the glow effect (default: 1.1)
  final double glowSize;

  /// Whether the widget is enabled (default: true)
  final bool enabled;

  /// Optional callback when animation starts
  final VoidCallback? onAnimationStart;

  /// Optional callback when animation completes
  final VoidCallback? onAnimationComplete;

  const HapticReactionGlow({
    Key? key,
    required this.child,
    required this.onTap,
    this.glowColor = const Color(0xFF00D4FF),
    this.duration = const Duration(milliseconds: 600),
    this.hapticType = HapticType.light,
    this.glowSize = 1.1,
    this.enabled = true,
    this.onAnimationStart,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<HapticReactionGlow> createState() => _HapticReactionGlowState();
}

class _HapticReactionGlowState extends State<HapticReactionGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Scale animation: 1.0 -> glowSize -> 1.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.glowSize)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.glowSize, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_controller);

    // Opacity animation: 0.0 -> 1.0 -> 0.0
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 80,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!widget.enabled) return;

    // Trigger haptic feedback
    _triggerHaptic();

    // Trigger callback
    widget.onTap();

    // Start animation
    widget.onAnimationStart?.call();
    await _controller.forward(from: 0.0);
  }

  void _triggerHaptic() {
    switch (widget.hapticType) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticType.success:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.warning:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.error:
        HapticFeedback.vibrate();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? _handleTap : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect layers (multiple for depth)
              if (_opacityAnimation.value > 0) ...[
                _buildGlowLayer(
                  scale: _scaleAnimation.value * 1.15,
                  opacity: _opacityAnimation.value * 0.3,
                  blur: 40,
                ),
                _buildGlowLayer(
                  scale: _scaleAnimation.value * 1.1,
                  opacity: _opacityAnimation.value * 0.5,
                  blur: 25,
                ),
                _buildGlowLayer(
                  scale: _scaleAnimation.value * 1.05,
                  opacity: _opacityAnimation.value * 0.7,
                  blur: 15,
                ),
              ],
              // The actual child widget
              child!,
            ],
          );
        },
        child: widget.child,
      ),
    );
  }

  Widget _buildGlowLayer({
    required double scale,
    required double opacity,
    required double blur,
  }) {
    return Transform.scale(
      scale: scale,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withOpacity(opacity),
              blurRadius: blur,
              spreadRadius: blur / 3,
            ),
          ],
        ),
        child: Opacity(
          opacity: 0,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Helper class for creating preset glow styles
class GlowPresets {
  static const Color primary = Color(0xFF00D4FF);
  static const Color success = Color(0xFF00FFA3);
  static const Color warning = Color(0xFFFFAA00);
  static const Color error = Color(0xFFFF4757);
  static const Color purple = Color(0xFF7B2FFF);
  static const Color pink = Color(0xFFFF006E);

  static HapticReactionGlow button({
    required Widget child,
    required VoidCallback onTap,
    Color? glowColor,
  }) {
    return HapticReactionGlow(
      onTap: onTap,
      glowColor: glowColor ?? primary,
      hapticType: HapticType.medium,
      glowSize: 1.08,
      child: child,
    );
  }

  static HapticReactionGlow icon({
    required Widget child,
    required VoidCallback onTap,
    Color? glowColor,
  }) {
    return HapticReactionGlow(
      onTap: onTap,
      glowColor: glowColor ?? primary,
      hapticType: HapticType.light,
      glowSize: 1.15,
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }

  static HapticReactionGlow card({
    required Widget child,
    required VoidCallback onTap,
    Color? glowColor,
  }) {
    return HapticReactionGlow(
      onTap: onTap,
      glowColor: glowColor ?? primary,
      hapticType: HapticType.selection,
      glowSize: 1.05,
      duration: const Duration(milliseconds: 700),
      child: child,
    );
  }
}