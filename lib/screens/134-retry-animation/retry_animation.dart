import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo screen showcasing the Network Retry Wave Animation
class RetryAnimation extends StatefulWidget {
  const RetryAnimation({Key? key}) : super(key: key);

  @override
  State<RetryAnimation> createState() => _RetryAnimationState();
}

class _RetryAnimationState extends State<RetryAnimation> {
  bool _isRetrying = false;

  void _simulateRetry() {
    setState(() => _isRetrying = true);

    // Simulate network retry duration
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _isRetrying = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Network Retry Wave Animation Widget
              NetworkRetryWaveAnimation(
                isRetrying: _isRetrying,
                size: 280,
                waveColor: const Color(0xFF6C63FF),
                accentColor: const Color(0xFF00F5FF),
                iconColor: Colors.white,
                backgroundColor: const Color(0xFF1A1F3A),
                waveCount: 3,
                animationDuration: const Duration(milliseconds: 2500),
                particleCount: 20,
              ),

              const SizedBox(height: 60),

              // Status Text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _isRetrying ? 'Reconnecting...' : 'Connection Lost',
                  key: ValueKey(_isRetrying),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                _isRetrying
                    ? 'Please wait while we restore your connection'
                    : 'Tap below to retry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 40),

              // Retry Button
              if (!_isRetrying) _RetryButton(onPressed: _simulateRetry),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ultra-stylish Network Retry Wave Animation Widget
///
/// A beautiful, customizable widget that displays animated waves
/// during network retry operations. Features include:
/// - Multiple animated wave layers
/// - Floating particles
/// - Pulsing glow effects
/// - Smooth transitions
/// - Fully customizable colors and sizing
class NetworkRetryWaveAnimation extends StatefulWidget {
  /// Whether the retry animation is active
  final bool isRetrying;

  /// Size of the animation container
  final double size;

  /// Primary wave color
  final Color waveColor;

  /// Accent color for particles and highlights
  final Color accentColor;

  /// Icon color
  final Color iconColor;

  /// Background color of the container
  final Color backgroundColor;

  /// Number of wave layers (recommended: 2-4)
  final int waveCount;

  /// Duration of one complete wave cycle
  final Duration animationDuration;

  /// Number of floating particles
  final int particleCount;

  /// Custom icon to display (defaults to wifi_off)
  final IconData? customIcon;

  /// Icon size
  final double iconSize;

  const NetworkRetryWaveAnimation({
    Key? key,
    required this.isRetrying,
    this.size = 250,
    this.waveColor = const Color(0xFF6C63FF),
    this.accentColor = const Color(0xFF00F5FF),
    this.iconColor = Colors.white,
    this.backgroundColor = const Color(0xFF1A1F3A),
    this.waveCount = 3,
    this.animationDuration = const Duration(milliseconds: 2500),
    this.particleCount = 20,
    this.customIcon,
    this.iconSize = 48,
  }) : super(key: key);

  @override
  State<NetworkRetryWaveAnimation> createState() =>
      _NetworkRetryWaveAnimationState();
}

class _NetworkRetryWaveAnimationState extends State<NetworkRetryWaveAnimation>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late List<AnimationController> _particleControllers;

  @override
  void initState() {
    super.initState();

    // Wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Rotation animation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Particle animation controllers
    _particleControllers = List.generate(
      widget.particleCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000 + (index * 100)),
      ),
    );

    if (widget.isRetrying) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(NetworkRetryWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRetrying != oldWidget.isRetrying) {
      if (widget.isRetrying) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  void _startAnimations() {
    _waveController.repeat();
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    for (var controller in _particleControllers) {
      controller.repeat();
    }
  }

  void _stopAnimations() {
    _waveController.stop();
    _pulseController.stop();
    _rotationController.stop();
    for (var controller in _particleControllers) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    for (var controller in _particleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Waves
          if (widget.isRetrying)
            ...List.generate(widget.waveCount, (index) {
              return AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return _WaveLayer(
                    progress: (_waveController.value + (index * 0.3)) % 1.0,
                    size: widget.size,
                    color: widget.waveColor,
                    opacity: 0.3 - (index * 0.08),
                  );
                },
              );
            }),

          // Floating Particles
          if (widget.isRetrying)
            ...List.generate(widget.particleCount, (index) {
              return AnimatedBuilder(
                animation: _particleControllers[index],
                builder: (context, child) {
                  return _FloatingParticle(
                    progress: _particleControllers[index].value,
                    size: widget.size,
                    color: widget.accentColor,
                    index: index,
                    totalParticles: widget.particleCount,
                  );
                },
              );
            }),

          // Center Container with Glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulseValue = _pulseController.value;

              return Container(
                width: widget.size * 0.35,
                height: widget.size * 0.35,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  shape: BoxShape.circle,
                  boxShadow:
                      widget.isRetrying
                          ? [
                            BoxShadow(
                              color: widget.accentColor.withOpacity(
                                0.3 + (pulseValue * 0.3),
                              ),
                              blurRadius: 30 + (pulseValue * 20),
                              spreadRadius: 5 + (pulseValue * 10),
                            ),
                            BoxShadow(
                              color: widget.waveColor.withOpacity(0.2),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ]
                          : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                ),
                child: child,
              );
            },
            child: Center(
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle:
                        widget.isRetrying
                            ? _rotationController.value * 2 * math.pi
                            : 0,
                    child: Icon(
                      widget.customIcon ?? Icons.wifi_off_rounded,
                      size: widget.iconSize,
                      color: widget.iconColor,
                    ),
                  );
                },
              ),
            ),
          ),

          // Rotating Ring
          if (widget.isRetrying)
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -_rotationController.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(widget.size * 0.5, widget.size * 0.5),
                    painter: _RotatingRingPainter(
                      color: widget.accentColor,
                      progress: _rotationController.value,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Wave layer painter for creating expanding wave effect
class _WaveLayer extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;
  final double opacity;

  const _WaveLayer({
    required this.progress,
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    final scale = 0.3 + (progress * 0.7);
    final fadeOpacity = opacity * (1 - progress);

    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(fadeOpacity), width: 2),
        ),
      ),
    );
  }
}

/// Floating particle widget
class _FloatingParticle extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;
  final int index;
  final int totalParticles;

  const _FloatingParticle({
    required this.progress,
    required this.size,
    required this.color,
    required this.index,
    required this.totalParticles,
  });

  @override
  Widget build(BuildContext context) {
    final angle = (index / totalParticles) * 2 * math.pi;
    final distance = (size * 0.25) + (progress * size * 0.15);

    final x = math.cos(angle + (progress * math.pi * 2)) * distance;
    final y = math.sin(angle + (progress * math.pi * 2)) * distance;

    final opacity = (math.sin(progress * math.pi) * 0.7).clamp(0.0, 1.0);
    final particleSize = 3.0 + (math.sin(progress * math.pi) * 2);

    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: particleSize,
        height: particleSize,
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity * 0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for rotating ring effect
class _RotatingRingPainter extends CustomPainter {
  final Color color;
  final double progress;

  _RotatingRingPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw animated arc segments
    for (int i = 0; i < 4; i++) {
      final startAngle = (i * math.pi / 2) + (progress * math.pi * 2);
      final sweepAngle = math.pi / 4;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RotatingRingPainter oldDelegate) => true;
}

/// Stylish retry button with hover and press effects
class _RetryButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _RetryButton({required this.onPressed});

  @override
  State<_RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<_RetryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF00F5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.refresh_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Retry Connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
