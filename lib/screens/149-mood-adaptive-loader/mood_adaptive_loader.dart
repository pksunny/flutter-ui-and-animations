import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo screen to showcase the mood-adaptive loader
class MoodAdaptiveLoaderDemoScreen extends StatefulWidget {
  const MoodAdaptiveLoaderDemoScreen({Key? key}) : super(key: key);

  @override
  State<MoodAdaptiveLoaderDemoScreen> createState() => _MoodAdaptiveLoaderDemoScreenState();
}

class _MoodAdaptiveLoaderDemoScreenState extends State<MoodAdaptiveLoaderDemoScreen> {
  LoaderMood _currentMood = LoaderMood.energetic;
  bool _isLoading = true;

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
              const Color(0xFFE9ECEF).withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Mood-Adaptive Loader',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Experience the magic of adaptive loading',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Main loader display area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // The amazing loader
                      if (_isLoading)
                        MoodAdaptiveLoader(
                          mood: _currentMood,
                          size: 120,
                        )
                      else
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  size: 72,
                                  color: Colors.green[400],
                                ),
                              ),
                            );
                          },
                        ),
                      
                      const SizedBox(height: 32),
                      
                      // Mood label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Current Mood: ${_getMoodName(_currentMood)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Control panel
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select Mood',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: LoaderMood.values.map((mood) {
                        final isSelected = _currentMood == mood;
                        return _MoodButton(
                          label: _getMoodName(mood),
                          icon: _getMoodIcon(mood),
                          isSelected: isSelected,
                          color: _getMoodColor(mood),
                          onTap: () {
                            setState(() {
                              _currentMood = mood;
                              _isLoading = true;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = !_isLoading;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isLoading ? 'Stop Loading' : 'Start Loading',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMoodName(LoaderMood mood) {
    switch (mood) {
      case LoaderMood.energetic:
        return 'Energetic';
      case LoaderMood.calm:
        return 'Calm';
      case LoaderMood.focused:
        return 'Focused';
      case LoaderMood.playful:
        return 'Playful';
      case LoaderMood.elegant:
        return 'Elegant';
      case LoaderMood.mysterious:
        return 'Mysterious';
    }
  }

  IconData _getMoodIcon(LoaderMood mood) {
    switch (mood) {
      case LoaderMood.energetic:
        return Icons.bolt;
      case LoaderMood.calm:
        return Icons.spa;
      case LoaderMood.focused:
        return Icons.center_focus_strong;
      case LoaderMood.playful:
        return Icons.celebration;
      case LoaderMood.elegant:
        return Icons.diamond;
      case LoaderMood.mysterious:
        return Icons.nightlight_round;
    }
  }

  Color _getMoodColor(LoaderMood mood) {
    switch (mood) {
      case LoaderMood.energetic:
        return Colors.orange;
      case LoaderMood.calm:
        return Colors.blue;
      case LoaderMood.focused:
        return Colors.purple;
      case LoaderMood.playful:
        return Colors.pink;
      case LoaderMood.elegant:
        return Colors.amber;
      case LoaderMood.mysterious:
        return Colors.indigo;
    }
  }
}

/// Mood button widget
class _MoodButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _MoodButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.grey[100],
                color.withOpacity(0.15),
                value,
              ),
              border: Border.all(
                color: Color.lerp(
                  Colors.grey[300]!,
                  color,
                  value,
                )!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Color.lerp(
                    Colors.grey[600],
                    color,
                    value,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Color.lerp(
                      Colors.grey[700],
                      color.withOpacity(0.9),
                      value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Enum defining different loader moods
enum LoaderMood {
  energetic,   // Fast, vibrant colors, dynamic movement
  calm,        // Slow, cool colors, gentle motion
  focused,     // Steady rhythm, sharp colors, precise movement
  playful,     // Bouncy, multiple colors, unpredictable patterns
  elegant,     // Smooth, gold/luxurious colors, graceful motion
  mysterious,  // Slow, dark colors with glowing effects
}

/// The main mood-adaptive loader widget
/// This is a highly customizable, production-ready loader that adapts
/// its appearance and animation based on the selected mood
class MoodAdaptiveLoader extends StatefulWidget {
  /// The mood that determines the loader's appearance and behavior
  final LoaderMood mood;
  
  /// Size of the loader (default: 100)
  final double size;
  
  /// Whether to show a subtle shadow effect (default: true)
  final bool showShadow;
  
  /// Custom color override (if null, uses mood-based colors)
  final Color? customColor;

  const MoodAdaptiveLoader({
    Key? key,
    required this.mood,
    this.size = 100.0,
    this.showShadow = true,
    this.customColor,
  }) : super(key: key);

  @override
  State<MoodAdaptiveLoader> createState() => _MoodAdaptiveLoaderState();
}

class _MoodAdaptiveLoaderState extends State<MoodAdaptiveLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final settings = _getMoodSettings(widget.mood);

    _rotationController = AnimationController(
      duration: Duration(milliseconds: settings.rotationDuration),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: settings.pulseDuration),
      vsync: this,
    )..repeat(reverse: true);

    _scaleController = AnimationController(
      duration: Duration(milliseconds: settings.scaleDuration),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(MoodAdaptiveLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) {
      _rotationController.dispose();
      _pulseController.dispose();
      _scaleController.dispose();
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = _getMoodSettings(widget.mood);
    
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: widget.showShadow
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: (widget.customColor ?? settings.primaryColor)
                      .withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            )
          : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _pulseController,
          _scaleController,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: _MoodLoaderPainter(
              mood: widget.mood,
              rotationProgress: _rotationController.value,
              pulseProgress: _pulseController.value,
              scaleProgress: _scaleController.value,
              settings: settings,
              customColor: widget.customColor,
            ),
          );
        },
      ),
    );
  }

  _MoodSettings _getMoodSettings(LoaderMood mood) {
    switch (mood) {
      case LoaderMood.energetic:
        return _MoodSettings(
          primaryColor: const Color(0xFFFF6B6B),
          secondaryColor: const Color(0xFFFFD93D),
          accentColor: const Color(0xFFFF8E53),
          rotationDuration: 800,
          pulseDuration: 500,
          scaleDuration: 600,
          particleCount: 8,
          animationCurve: Curves.easeInOutCubic,
        );
      
      case LoaderMood.calm:
        return _MoodSettings(
          primaryColor: const Color(0xFF6C63FF),
          secondaryColor: const Color(0xFF4ECDC4),
          accentColor: const Color(0xFF95E1D3),
          rotationDuration: 2500,
          pulseDuration: 2000,
          scaleDuration: 2200,
          particleCount: 6,
          animationCurve: Curves.easeInOut,
        );
      
      case LoaderMood.focused:
        return _MoodSettings(
          primaryColor: const Color(0xFF9B59B6),
          secondaryColor: const Color(0xFF3498DB),
          accentColor: const Color(0xFF1ABC9C),
          rotationDuration: 1500,
          pulseDuration: 1200,
          scaleDuration: 1300,
          particleCount: 4,
          animationCurve: Curves.linear,
        );
      
      case LoaderMood.playful:
        return _MoodSettings(
          primaryColor: const Color(0xFFFF6B9D),
          secondaryColor: const Color(0xFFC44569),
          accentColor: const Color(0xFFFFA502),
          rotationDuration: 1000,
          pulseDuration: 700,
          scaleDuration: 900,
          particleCount: 12,
          animationCurve: Curves.bounceOut,
        );
      
      case LoaderMood.elegant:
        return _MoodSettings(
          primaryColor: const Color(0xFFD4AF37),
          secondaryColor: const Color(0xFFFFD700),
          accentColor: const Color(0xFFFFF5E6),
          rotationDuration: 3000,
          pulseDuration: 2500,
          scaleDuration: 2800,
          particleCount: 6,
          animationCurve: Curves.easeInOutSine,
        );
      
      case LoaderMood.mysterious:
        return _MoodSettings(
          primaryColor: const Color(0xFF2C3E50),
          secondaryColor: const Color(0xFF34495E),
          accentColor: const Color(0xFF9B59B6),
          rotationDuration: 3500,
          pulseDuration: 3000,
          scaleDuration: 3200,
          particleCount: 8,
          animationCurve: Curves.easeInOutQuart,
        );
    }
  }
}

/// Settings class to store mood-specific animation parameters
class _MoodSettings {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final int rotationDuration;
  final int pulseDuration;
  final int scaleDuration;
  final int particleCount;
  final Curve animationCurve;

  _MoodSettings({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.rotationDuration,
    required this.pulseDuration,
    required this.scaleDuration,
    required this.particleCount,
    required this.animationCurve,
  });
}

/// Custom painter for the mood-adaptive loader
class _MoodLoaderPainter extends CustomPainter {
  final LoaderMood mood;
  final double rotationProgress;
  final double pulseProgress;
  final double scaleProgress;
  final _MoodSettings settings;
  final Color? customColor;

  _MoodLoaderPainter({
    required this.mood,
    required this.rotationProgress,
    required this.pulseProgress,
    required this.scaleProgress,
    required this.settings,
    this.customColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw based on mood type
    switch (mood) {
      case LoaderMood.energetic:
        _drawEnergeticLoader(canvas, center, radius);
        break;
      case LoaderMood.calm:
        _drawCalmLoader(canvas, center, radius);
        break;
      case LoaderMood.focused:
        _drawFocusedLoader(canvas, center, radius);
        break;
      case LoaderMood.playful:
        _drawPlayfulLoader(canvas, center, radius);
        break;
      case LoaderMood.elegant:
        _drawElegantLoader(canvas, center, radius);
        break;
      case LoaderMood.mysterious:
        _drawMysteriousLoader(canvas, center, radius);
        break;
    }
  }

  void _drawEnergeticLoader(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Draw rotating particles with gradient
    for (int i = 0; i < settings.particleCount; i++) {
      final angle = (2 * math.pi / settings.particleCount) * i +
          (rotationProgress * 2 * math.pi);
      
      final pulseScale = 0.7 + (pulseProgress * 0.3);
      final particleRadius = radius * 0.7 * pulseScale;
      
      final x = center.dx + particleRadius * math.cos(angle);
      final y = center.dy + particleRadius * math.sin(angle);

      // Gradient effect
      final gradient = RadialGradient(
        colors: [
          customColor ?? settings.primaryColor,
          customColor ?? settings.secondaryColor,
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: Offset(x, y), radius: 8),
      );

      canvas.drawCircle(Offset(x, y), 8, paint);
    }

    // Draw center pulsing circle
    final centerPaint = Paint()
      ..color = (customColor ?? settings.accentColor).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      center,
      radius * 0.25 * (1 + pulseProgress * 0.2),
      centerPaint,
    );
  }

  void _drawCalmLoader(Canvas canvas, Offset center, double radius) {
    // Smooth wave-like circles
    for (int i = 0; i < 3; i++) {
      final waveOffset = (rotationProgress + (i * 0.33)) % 1.0;
      final waveRadius = radius * (0.3 + waveOffset * 0.6);
      final opacity = 1.0 - waveOffset;

      final paint = Paint()
        ..color = (customColor ?? settings.primaryColor)
            .withOpacity(opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawCircle(center, waveRadius, paint);
    }

    // Gentle rotating arc
    final arcPaint = Paint()
      ..color = customColor ?? settings.secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    final arcRect = Rect.fromCircle(center: center, radius: radius * 0.5);
    canvas.drawArc(
      arcRect,
      rotationProgress * 2 * math.pi,
      math.pi * 1.5,
      false,
      arcPaint,
    );
  }

  void _drawFocusedLoader(Canvas canvas, Offset center, double radius) {
    // Precise geometric shapes
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw rotating squares
    for (int i = 0; i < settings.particleCount; i++) {
      final angle = (2 * math.pi / settings.particleCount) * i +
          (rotationProgress * 2 * math.pi);
      
      final squareRadius = radius * 0.6;
      final x = center.dx + squareRadius * math.cos(angle);
      final y = center.dy + squareRadius * math.sin(angle);

      paint.color = (customColor ?? settings.primaryColor)
          .withOpacity(0.7 + pulseProgress * 0.3);

      final squareSize = 12.0 * (0.8 + scaleProgress * 0.4);
      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: squareSize,
        height: squareSize,
      );

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + rotationProgress * math.pi);
      canvas.translate(-x, -y);
      canvas.drawRect(rect, paint);
      canvas.restore();
    }
  }

  void _drawPlayfulLoader(Canvas canvas, Offset center, double radius) {
    // Bouncy, colorful particles
    final colors = [
      customColor ?? settings.primaryColor,
      customColor ?? settings.secondaryColor,
      customColor ?? settings.accentColor,
    ];

    for (int i = 0; i < settings.particleCount; i++) {
      final angle = (2 * math.pi / settings.particleCount) * i +
          (rotationProgress * 2 * math.pi);
      
      // Add playful bounce effect
      final bounce = math.sin(rotationProgress * math.pi * 4 + i) * 0.2;
      final particleRadius = radius * (0.6 + bounce);
      
      final x = center.dx + particleRadius * math.cos(angle);
      final y = center.dy + particleRadius * math.sin(angle);

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      final size = 10.0 * (0.7 + scaleProgress * 0.6);
      canvas.drawCircle(Offset(x, y), size, paint);

      // Add sparkle effect
      if (pulseProgress > 0.7) {
        final sparklePaint = Paint()
          ..color = Colors.white.withOpacity((pulseProgress - 0.7) * 3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), size * 0.5, sparklePaint);
      }
    }
  }

  void _drawElegantLoader(Canvas canvas, Offset center, double radius) {
    // Smooth, luxurious animation
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Outer ring with gradient
    final gradient = SweepGradient(
      colors: [
        customColor ?? settings.primaryColor,
        customColor ?? settings.secondaryColor,
        customColor ?? settings.accentColor,
        customColor ?? settings.primaryColor,
      ],
      transform: GradientRotation(rotationProgress * 2 * math.pi),
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    final outerRadius = radius * 0.8;
    canvas.drawCircle(center, outerRadius, paint);

    // Inner elegant arcs
    for (int i = 0; i < 3; i++) {
      final arcRadius = radius * (0.3 + i * 0.15);
      final arcPaint = Paint()
        ..color = (customColor ?? settings.secondaryColor)
            .withOpacity(0.4 - i * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      final startAngle = (rotationProgress * 2 * math.pi) + (i * math.pi / 3);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: arcRadius),
        startAngle,
        math.pi * 0.8,
        false,
        arcPaint,
      );
    }
  }

  void _drawMysteriousLoader(Canvas canvas, Offset center, double radius) {
    // Dark, glowing effect
    
    // Outer glow
    for (int i = 3; i > 0; i--) {
      final glowPaint = Paint()
        ..color = (customColor ?? settings.accentColor)
            .withOpacity(0.1 * pulseProgress)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        center,
        radius * (0.6 + i * 0.1 + pulseProgress * 0.2),
        glowPaint,
      );
    }

    // Rotating mysterious symbols/particles
    for (int i = 0; i < settings.particleCount; i++) {
      final angle = (2 * math.pi / settings.particleCount) * i +
          (rotationProgress * 2 * math.pi * 0.5); // Slower rotation
      
      final particleRadius = radius * 0.7;
      final x = center.dx + particleRadius * math.cos(angle);
      final y = center.dy + particleRadius * math.sin(angle);

      // Fading trail effect
      for (int j = 0; j < 3; j++) {
        final trailAngle = angle - (j * 0.3);
        final tx = center.dx + particleRadius * math.cos(trailAngle);
        final ty = center.dy + particleRadius * math.sin(trailAngle);

        final trailPaint = Paint()
          ..color = (customColor ?? settings.accentColor)
              .withOpacity((0.6 - j * 0.2) * pulseProgress)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(tx, ty), 4.0 - j, trailPaint);
      }

      // Main particle with glow
      final paint = Paint()
        ..color = customColor ?? settings.accentColor
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(Offset(x, y), 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoodLoaderPainter oldDelegate) {
    return oldDelegate.rotationProgress != rotationProgress ||
        oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.scaleProgress != scaleProgress ||
        oldDelegate.mood != mood;
  }
}