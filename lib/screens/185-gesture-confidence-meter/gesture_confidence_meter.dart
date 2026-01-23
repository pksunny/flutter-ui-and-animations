import 'package:flutter/material.dart';
import 'dart:math' as math;

class GestureConfidenceMeter extends StatefulWidget {
  const GestureConfidenceMeter({super.key});

  @override
  State<GestureConfidenceMeter> createState() => _GestureConfidenceMeterState();
}

class _GestureConfidenceMeterState extends State<GestureConfidenceMeter> {
  String _lastAction = 'Long-press any button below';

  void _onActionTriggered(String action) {
    setState(() {
      _lastAction = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                const Text(
                  'Gesture Confidence Meter',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hold to reveal your progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),

                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
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
                  child: Text(
                    _lastAction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                ),
                const SizedBox(height: 64),

                // Demo buttons
                ConfidenceButton(
                  onTriggered:
                      () => _onActionTriggered('Primary Action Triggered! 🎉'),
                  child: const Text(
                    'Primary Action',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                ConfidenceButton(
                  onTriggered:
                      () => _onActionTriggered('Delete Action Triggered! 🗑️'),
                  backgroundColor: const Color(0xFFFF3B30),
                  progressColor: const Color(0xFFFF6B6B),
                  child: const Text(
                    'Delete Item',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                ConfidenceButton(
                  onTriggered: () => _onActionTriggered('Success! Confirmed ✅'),
                  backgroundColor: const Color(0xFF34C759),
                  progressColor: const Color(0xFF5EDB7A),
                  triggerDuration: const Duration(milliseconds: 1200),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 64),

                // Custom styled button
                ConfidenceButton(
                  onTriggered:
                      () => _onActionTriggered('Custom Style Activated! ✨'),
                  backgroundColor: Colors.white,
                  progressColor: const Color(0xFF007AFF),
                  showBorder: true,
                  triggerDuration: const Duration(milliseconds: 800),
                  child: const Text(
                    'Custom Style',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007AFF),
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

/// Premium confidence meter button with smooth progress visualization
///
/// Shows real-time feedback during long-press gesture:
/// - Progress ring fills up as user holds
/// - Scale animation provides tactile feedback
/// - Haptic-like visual response on trigger
/// - Customizable colors, duration, and styling
class ConfidenceButton extends StatefulWidget {
  const ConfidenceButton({
    super.key,
    required this.onTriggered,
    required this.child,
    this.backgroundColor = const Color(0xFF007AFF),
    this.progressColor = const Color(0xFF5AC8FA),
    this.triggerDuration = const Duration(milliseconds: 1000),
    this.showBorder = false,
    this.width = double.infinity,
    this.height = 56.0,
  });

  final VoidCallback onTriggered;
  final Widget child;
  final Color backgroundColor;
  final Color progressColor;
  final Duration triggerDuration;
  final bool showBorder;
  final double width;
  final double height;

  @override
  State<ConfidenceButton> createState() => _ConfidenceButtonState();
}

class _ConfidenceButtonState extends State<ConfidenceButton>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _scaleController;
  late AnimationController _successController;

  bool _isPressed = false;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();

    // Controls the progress ring fill animation
    _progressController = AnimationController(
      vsync: this,
      duration: widget.triggerDuration,
    )..addListener(() {
      if (_progressController.value >= 1.0 && !_hasTriggered) {
        _hasTriggered = true;
        _triggerSuccess();
      }
    });

    // Controls button scale for press feedback
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: 1.0,
    );

    // Controls success pulse animation
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _scaleController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isPressed = true;
      _hasTriggered = false;
    });
    _scaleController.animateTo(0.95, curve: Curves.easeOut);
    _progressController.forward();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _resetButton();
  }

  void _onLongPressCancel() {
    _resetButton();
  }

  void _resetButton() {
    setState(() {
      _isPressed = false;
    });
    _scaleController.animateTo(1.0, curve: Curves.elasticOut);
    _progressController.reverse();
  }

  void _triggerSuccess() {
    _successController.forward(from: 0.0);
    widget.onTriggered();

    // Reset after success animation
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _resetButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onLongPressCancel: _onLongPressCancel,
      child: ScaleTransition(
        scale: _scaleController,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring background
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: _ConfidenceRingPainter(
                      progress: _isPressed ? _progressController.value : 0.0,
                      backgroundColor: widget.backgroundColor,
                      progressColor: widget.progressColor,
                      showBorder: widget.showBorder,
                    ),
                  );
                },
              ),

              // Success pulse overlay
              AnimatedBuilder(
                animation: _successController,
                builder: (context, child) {
                  final pulseValue = _successController.value;
                  return Opacity(
                    opacity: 1.0 - pulseValue,
                    child: Transform.scale(
                      scale: 1.0 + (pulseValue * 0.15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: widget.progressColor.withOpacity(0.5),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Button content
              IgnorePointer(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the confidence meter progress ring
class _ConfidenceRingPainter extends CustomPainter {
  _ConfidenceRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.showBorder,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final bool showBorder;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    // Background
    final bgPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    // Optional border for white/light backgrounds
    if (showBorder) {
      final borderPaint =
          Paint()
            ..color = progressColor.withOpacity(0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;
      canvas.drawRRect(rrect, borderPaint);
    }

    // Progress overlay (fills from left to right)
    if (progress > 0) {
      final progressRect = Rect.fromLTWH(
        0,
        0,
        size.width * progress,
        size.height,
      );
      final progressRRect = RRect.fromRectAndRadius(
        progressRect,
        const Radius.circular(16),
      );

      // Gradient for smooth visual progression
      final gradient = LinearGradient(
        colors: [
          progressColor.withOpacity(0.3),
          progressColor.withOpacity(0.5),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

      final progressPaint =
          Paint()..shader = gradient.createShader(progressRect);

      canvas.save();
      canvas.clipRRect(rrect);
      canvas.drawRRect(progressRRect, progressPaint);
      canvas.restore();

      // Leading edge glow effect
      if (progress < 1.0) {
        final edgeRect = Rect.fromLTWH(
          (size.width * progress) - 20,
          0,
          20,
          size.height,
        );

        final edgeGradient = LinearGradient(
          colors: [
            progressColor.withOpacity(0.0),
            progressColor.withOpacity(0.6),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );

        final edgePaint = Paint()..shader = edgeGradient.createShader(edgeRect);

        canvas.save();
        canvas.clipRRect(rrect);
        canvas.drawRect(edgeRect, edgePaint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_ConfidenceRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
