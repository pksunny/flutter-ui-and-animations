import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
/// Demo screen showcasing the Electric Shock Progress Bar
class ElectricShockProgressbar extends StatefulWidget {
  @override
  _ElectricShockProgressbarState createState() => _ElectricShockProgressbarState();
}

class _ElectricShockProgressbarState extends State<ElectricShockProgressbar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    
    // Auto-animate progress for demo
    _progressController.addListener(() {
      setState(() {
        _progress = _progressController.value;
      });
    });
    
    _startDemo();
  }

  void _startDemo() async {
    while (mounted) {
      await _progressController.forward();
      await Future.delayed(Duration(seconds: 1));
      await _progressController.reverse();
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Electric Shock Progress Bar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 60),
            
            // Main Electric Progress Bar
            ElectricShockProgressBar(
              progress: _progress,
              width: 350,
              height: 80,
            ),
            
            SizedBox(height: 40),
            
            // Compact version
            ElectricShockProgressBar(
              progress: _progress,
              width: 280,
              height: 50,
              electricColor: Colors.purple,
              glowIntensity: 0.8,
              shockFrequency: 15,
            ),
            
            SizedBox(height: 40),
            
            // Custom styled version
            ElectricShockProgressBar(
              progress: _progress,
              width: 320,
              height: 60,
              electricColor: Colors.green,
              backgroundColor: Color(0xFF1A1A1A),
              progressColor: Color(0xFF2D5A2D),
              borderRadius: 25,
              shockIntensity: 1.5,
              pulseEffect: true,
            ),
            
            SizedBox(height: 60),
            
            // Progress indicator
            Text(
              '${(_progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Electric Shock Progress Bar Widget
/// A highly customizable progress bar with electric shock animations
class ElectricShockProgressBar extends StatefulWidget {
  /// Current progress (0.0 to 1.0)
  final double progress;
  
  /// Width of the progress bar
  final double width;
  
  /// Height of the progress bar
  final double height;
  
  /// Primary electric/lightning color
  final Color electricColor;
  
  /// Background color of the progress bar
  final Color backgroundColor;
  
  /// Progress fill color
  final Color progressColor;
  
  /// Border radius of the progress bar
  final double borderRadius;
  
  /// Intensity of the electric shock effect (0.5 to 2.0)
  final double shockIntensity;
  
  /// Frequency of electric shocks per second
  final int shockFrequency;
  
  /// Intensity of the glow effect (0.0 to 1.0)
  final double glowIntensity;
  
  /// Enable pulsing effect on progress
  final bool pulseEffect;
  
  /// Duration of animations in milliseconds
  final int animationDuration;
  
  const ElectricShockProgressBar({
    Key? key,
    required this.progress,
    this.width = 300,
    this.height = 60,
    this.electricColor = const Color(0xFF00FFFF),
    this.backgroundColor = const Color(0xFF1A1A1A),
    this.progressColor = const Color(0xFF003333),
    this.borderRadius = 30,
    this.shockIntensity = 1.0,
    this.shockFrequency = 12,
    this.glowIntensity = 1.0,
    this.pulseEffect = false,
    this.animationDuration = 100,
  }) : super(key: key);

  @override
  _ElectricShockProgressBarState createState() => _ElectricShockProgressBarState();
}

class _ElectricShockProgressBarState extends State<ElectricShockProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _shockController;
  late AnimationController _pulseController;
  late Animation<double> _shockAnimation;
  late Animation<double> _pulseAnimation;
  
  List<ElectricArc> _electricArcs = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    
    // Electric shock animation controller
    _shockController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration),
      vsync: this,
    )..repeat();
    
    _shockAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shockController,
      curve: Curves.easeInOut,
    ));
    
    // Pulse animation controller
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    if (widget.pulseEffect) {
      _pulseController.repeat(reverse: true);
    }
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Generate initial electric arcs
    _generateElectricArcs();
    
    // Regenerate arcs periodically
    _scheduleArcRegeneration();
  }

  void _generateElectricArcs() {
    _electricArcs.clear();
    
    if (widget.progress > 0) {
      int arcCount = (widget.shockFrequency * widget.progress * widget.shockIntensity).round();
      
      for (int i = 0; i < arcCount; i++) {
        _electricArcs.add(ElectricArc(
          startX: _random.nextDouble() * widget.width * widget.progress,
          startY: _random.nextDouble() * widget.height,
          endX: _random.nextDouble() * widget.width * widget.progress,
          endY: _random.nextDouble() * widget.height,
          intensity: 0.3 + _random.nextDouble() * 0.7,
          thickness: 1.0 + _random.nextDouble() * 2.0,
          segments: 5 + _random.nextInt(8),
        ));
      }
    }
  }

  void _scheduleArcRegeneration() {
    Future.delayed(Duration(milliseconds: 50 + _random.nextInt(100)), () {
      if (mounted) {
        setState(() {
          _generateElectricArcs();
        });
        _scheduleArcRegeneration();
      }
    });
  }

  @override
  void didUpdateWidget(ElectricShockProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _generateElectricArcs();
    }
  }

  @override
  void dispose() {
    _shockController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shockAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.pulseEffect ? _pulseAnimation.value : 1.0,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                // Outer glow
                BoxShadow(
                  color: widget.electricColor.withOpacity(0.3 * widget.glowIntensity),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                // Inner glow
                BoxShadow(
                  color: widget.electricColor.withOpacity(0.1 * widget.glowIntensity),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: CustomPaint(
                painter: ElectricProgressPainter(
                  progress: widget.progress,
                  electricColor: widget.electricColor,
                  backgroundColor: widget.backgroundColor,
                  progressColor: widget.progressColor,
                  electricArcs: _electricArcs,
                  animationValue: _shockAnimation.value,
                  shockIntensity: widget.shockIntensity,
                  glowIntensity: widget.glowIntensity,
                ),
                size: Size(widget.width, widget.height),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Electric Arc data structure
class ElectricArc {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double intensity;
  final double thickness;
  final int segments;
  
  ElectricArc({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.intensity,
    required this.thickness,
    required this.segments,
  });
}

/// Custom painter for the electric progress bar
class ElectricProgressPainter extends CustomPainter {
  final double progress;
  final Color electricColor;
  final Color backgroundColor;
  final Color progressColor;
  final List<ElectricArc> electricArcs;
  final double animationValue;
  final double shockIntensity;
  final double glowIntensity;
  
  final math.Random _random = math.Random();

  ElectricProgressPainter({
    required this.progress,
    required this.electricColor,
    required this.backgroundColor,
    required this.progressColor,
    required this.electricArcs,
    required this.animationValue,
    required this.shockIntensity,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw background
    _drawBackground(canvas, rect);
    
    // Draw progress fill
    _drawProgressFill(canvas, rect);
    
    // Draw electric arcs
    _drawElectricArcs(canvas, size);
    
    // Draw progress border glow
    _drawProgressGlow(canvas, rect);
    
    // Draw sparks and particles
    _drawSparks(canvas, size);
  }

  void _drawBackground(Canvas canvas, Rect rect) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
      backgroundPaint,
    );
  }

  void _drawProgressFill(Canvas canvas, Rect rect) {
    if (progress <= 0) return;
    
    final progressRect = Rect.fromLTWH(
      0,
      0,
      rect.width * progress,
      rect.height,
    );
    
    // Create gradient for progress
    final gradient = LinearGradient(
      colors: [
        progressColor,
        progressColor.withOpacity(0.7),
        electricColor.withOpacity(0.3),
      ],
      stops: [0.0, 0.7, 1.0],
    );
    
    final progressPaint = Paint()
      ..shader = gradient.createShader(progressRect)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(progressRect, Radius.circular(rect.height / 2)),
      progressPaint,
    );
  }

  void _drawElectricArcs(Canvas canvas, Size size) {
    for (final arc in electricArcs) {
      _drawElectricArc(canvas, arc, size);
    }
  }

  void _drawElectricArc(Canvas canvas, ElectricArc arc, Size size) {
    final paint = Paint()
      ..color = electricColor.withOpacity(arc.intensity * glowIntensity)
      ..strokeWidth = arc.thickness * shockIntensity
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.0);
    
    final path = Path();
    path.moveTo(arc.startX, arc.startY);
    
    // Create jagged electric arc
    for (int i = 1; i <= arc.segments; i++) {
      final t = i / arc.segments;
      final baseX = arc.startX + (arc.endX - arc.startX) * t;
      final baseY = arc.startY + (arc.endY - arc.startY) * t;
      
      // Add randomness for electric effect
      final offsetX = baseX + (_random.nextDouble() - 0.5) * 20 * shockIntensity;
      final offsetY = baseY + (_random.nextDouble() - 0.5) * 20 * shockIntensity;
      
      path.lineTo(offsetX, offsetY);
    }
    
    // Draw main arc
    canvas.drawPath(path, paint);
    
    // Draw glow effect
    final glowPaint = Paint()
      ..color = electricColor.withOpacity(0.3 * arc.intensity * glowIntensity)
      ..strokeWidth = arc.thickness * shockIntensity * 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0);
    
    canvas.drawPath(path, glowPaint);
  }

  void _drawProgressGlow(Canvas canvas, Rect rect) {
    if (progress <= 0) return;
    
    final progressWidth = rect.width * progress;
    final glowRect = Rect.fromLTWH(-5, -5, progressWidth + 10, rect.height + 10);
    
    final glowPaint = Paint()
      ..color = electricColor.withOpacity(0.2 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(glowRect, Radius.circular(rect.height / 2 + 5)),
      glowPaint,
    );
  }

  void _drawSparks(Canvas canvas, Size size) {
    if (progress <= 0) return;
    
    final sparkCount = (progress * 15 * shockIntensity).round();
    final progressEdge = size.width * progress;
    
    for (int i = 0; i < sparkCount; i++) {
      final sparkX = progressEdge + (_random.nextDouble() - 0.5) * 30;
      final sparkY = _random.nextDouble() * size.height;
      final sparkSize = 1.0 + _random.nextDouble() * 3.0;
      
      final sparkPaint = Paint()
        ..color = electricColor.withOpacity(0.7 * _random.nextDouble() * glowIntensity)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.0);
      
      canvas.drawCircle(
        Offset(sparkX, sparkY),
        sparkSize,
        sparkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}