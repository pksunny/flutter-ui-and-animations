import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Demo screen showcasing the MagicalCopyPulse widget
class CopyAnimation extends StatelessWidget {
  const CopyAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1a1f3a), Color(0xFF0f1329)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Title
                const Text(
                  '✨ Magical Copy Pulse',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to experience the magic',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Example 1: Classic Purple
                _buildExample(
                  context,
                  title: 'Classic Purple Glow',
                  subtitle: 'Email Address',
                  textToCopy: 'hello@magical.app',
                  glowColor: Colors.purple,
                ),
                const SizedBox(height: 30),

                // Example 2: Cyan Blue
                _buildExample(
                  context,
                  title: 'Cyan Dream',
                  subtitle: 'API Key',
                  textToCopy: 'sk_live_4242424242424242',
                  glowColor: Colors.cyan,
                  iconColor: Colors.cyan,
                ),
                const SizedBox(height: 30),

                // Example 3: Pink Rose
                _buildExample(
                  context,
                  title: 'Rose Gold',
                  subtitle: 'Referral Code',
                  textToCopy: 'MAGIC2025',
                  glowColor: Colors.pink,
                  iconColor: Colors.pinkAccent,
                ),
                const SizedBox(height: 30),

                // Example 4: Green Emerald
                _buildExample(
                  context,
                  title: 'Emerald Shine',
                  subtitle: 'Promo Code',
                  textToCopy: 'SAVE50NOW',
                  glowColor: Colors.green,
                  iconColor: Colors.greenAccent,
                ),
                const SizedBox(height: 30),

                // Example 5: Custom styled card
                _buildCustomCard(context),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExample(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String textToCopy,
    required Color glowColor,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      textToCopy,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              MagicalCopyPulse(
                textToCopy: textToCopy,
                glowColor: glowColor,
                iconColor: iconColor ?? Colors.white,
                size: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.withOpacity(0.2),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🎨 Ultra Customizable',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MagicalCopyPulse(
                textToCopy: 'Small Size',
                size: 40,
                glowColor: Colors.amber,
                iconColor: Colors.amber,
                successMessage: 'Copied! 🎉',
              ),
              MagicalCopyPulse(
                textToCopy: 'Medium Size',
                size: 56,
                glowColor: Colors.teal,
                iconColor: Colors.tealAccent,
                rippleCount: 3,
              ),
              MagicalCopyPulse(
                textToCopy: 'Large Size',
                size: 70,
                glowColor: Colors.orange,
                iconColor: Colors.deepOrange,
                pulseDuration: const Duration(milliseconds: 400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🌟 MAGICAL COPY PULSE WIDGET 🌟
///
/// An extraordinary, ultra-stylish copy-to-clipboard widget with mesmerizing animations
///
/// Features:
/// - Magical pulse animation on tap
/// - Beautiful glow rings that expand outward
/// - Smooth icon transformation
/// - Haptic feedback
/// - Customizable colors, sizes, and animations
/// - Success message with fade animation
/// - Production-ready and fully reusable
class MagicalCopyPulse extends StatefulWidget {
  /// The text to copy to clipboard
  final String textToCopy;

  /// Size of the button (default: 56)
  final double size;

  /// Glow ring color (default: purple)
  final Color glowColor;

  /// Icon color (default: white)
  final Color iconColor;

  /// Background color (default: white with 10% opacity)
  final Color? backgroundColor;

  /// Duration of pulse animation (default: 500ms)
  final Duration pulseDuration;

  /// Number of ripple rings (default: 2)
  final int rippleCount;

  /// Success message to show (default: "Copied!")
  final String successMessage;

  /// Callback when text is copied
  final VoidCallback? onCopied;

  const MagicalCopyPulse({
    Key? key,
    required this.textToCopy,
    this.size = 56.0,
    this.glowColor = Colors.purple,
    this.iconColor = Colors.white,
    this.backgroundColor,
    this.pulseDuration = const Duration(milliseconds: 500),
    this.rippleCount = 2,
    this.successMessage = 'Copied!',
    this.onCopied,
  }) : super(key: key);

  @override
  State<MagicalCopyPulse> createState() => _MagicalCopyPulseState();
}

class _MagicalCopyPulseState extends State<MagicalCopyPulse>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _iconController;
  late AnimationController _successController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _successOpacityAnimation;

  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    );

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    );

    // Icon animation controller
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_iconController);

    _iconRotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    // Success message animation
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _successOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_successController);
  }

  Future<void> _handleCopy() async {
    // Copy to clipboard
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Trigger animations
    setState(() => _isCopied = true);
    _pulseController.forward(from: 0);
    _iconController.forward(from: 0);
    _successController.forward(from: 0);

    // Callback
    widget.onCopied?.call();

    // Reset after animation
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      setState(() => _isCopied = false);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _iconController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main button with animations
        GestureDetector(
          onTap: _handleCopy,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated ripple rings
                ...List.generate(widget.rippleCount, (index) {
                  return AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final delay = index * 0.15;
                      final progress = (_pulseAnimation.value - delay).clamp(
                        0.0,
                        1.0,
                      );

                      return _RippleRing(
                        progress: progress,
                        size: widget.size,
                        color: widget.glowColor,
                      );
                    },
                  );
                }),

                // Main button
                AnimatedBuilder(
                  animation: _iconScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _iconScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _iconRotationAnimation.value,
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            color:
                                widget.backgroundColor ??
                                Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  _isCopied
                                      ? widget.glowColor
                                      : Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              if (_isCopied)
                                BoxShadow(
                                  color: widget.glowColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: Icon(
                            _isCopied
                                ? Icons.check_rounded
                                : Icons.content_copy_rounded,
                            color:
                                _isCopied ? widget.glowColor : widget.iconColor,
                            size: widget.size * 0.45,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Success message
        AnimatedBuilder(
          animation: _successOpacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _successOpacityAnimation.value,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.successMessage,
                  style: TextStyle(
                    color: widget.glowColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Custom painter for ripple ring effect
class _RippleRing extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;

  const _RippleRing({
    required this.progress,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    final scale = 1.0 + (progress * 0.8);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(opacity * 0.6), width: 3),
        ),
      ),
    );
  }
}
