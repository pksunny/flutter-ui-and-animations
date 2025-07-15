import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;


class FingerTrailLiquidDragScreen extends StatefulWidget {
  @override
  _FingerTrailLiquidDragScreenState createState() => _FingerTrailLiquidDragScreenState();
}

class _FingerTrailLiquidDragScreenState extends State<FingerTrailLiquidDragScreen>
    with TickerProviderStateMixin {
  List<TrailPoint> trailPoints = [];
  late AnimationController _animationController;
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 16),
      vsync: this,
    )..repeat();

    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animationController.addListener(() {
      setState(() {
        _updateTrailPoints();
      });
    });
  }

  void _updateTrailPoints() {
    for (int i = trailPoints.length - 1; i >= 0; i--) {
      trailPoints[i].life -= 0.02;
      trailPoints[i].size *= 0.98;
      
      // Add some fluid motion
      trailPoints[i].x += trailPoints[i].velocityX * 0.3;
      trailPoints[i].y += trailPoints[i].velocityY * 0.3;
      
      // Slow down velocity
      trailPoints[i].velocityX *= 0.95;
      trailPoints[i].velocityY *= 0.95;
      
      if (trailPoints[i].life <= 0) {
        trailPoints.removeAt(i);
      }
    }
  }

  void _addTrailPoint(Offset position) {
    final random = math.Random();
    
    // Add multiple points for richer trail
    for (int i = 0; i < 3; i++) {
      trailPoints.add(TrailPoint(
        x: position.dx + (random.nextDouble() - 0.5) * 10,
        y: position.dy + (random.nextDouble() - 0.5) * 10,
        size: 15.0 + random.nextDouble() * 25,
        life: 1.0,
        velocityX: (random.nextDouble() - 0.5) * 2,
        velocityY: (random.nextDouble() - 0.5) * 2,
        hue: (DateTime.now().millisecondsSinceEpoch / 10) % 360,
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
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
              Color(0xFF0a0a0a),
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundParticlesPainter(_backgroundController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Main liquid trail canvas
            GestureDetector(
              onPanUpdate: (details) {
                _addTrailPoint(details.localPosition);
              },
              onTapDown: (details) {
                _addTrailPoint(details.localPosition);
              },
              child: CustomPaint(
                painter: LiquidTrailPainter(trailPoints),
                size: Size.infinite,
              ),
            ),
            
            // Futuristic UI overlay
            SafeArea(
              child: Column(
                children: [
                  // Top bar with neon effect
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00d4ff).withOpacity(0.2),
                          Color(0xFFff0080).withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFF00d4ff).withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF00d4ff).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Color(0xFF00d4ff),
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'LIQUID TRAIL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrailPoint {
  double x;
  double y;
  double size;
  double life;
  double velocityX;
  double velocityY;
  double hue;

  TrailPoint({
    required this.x,
    required this.y,
    required this.size,
    required this.life,
    required this.velocityX,
    required this.velocityY,
    required this.hue,
  });
}

class LiquidTrailPainter extends CustomPainter {
  final List<TrailPoint> trailPoints;

  LiquidTrailPainter(this.trailPoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (trailPoints.isEmpty) return;

    // Create gradient shader for liquid effect
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    // Draw liquid blobs
    for (var point in trailPoints) {
      final alpha = (point.life * 255).clamp(0, 255).toInt();
      
      // Create dynamic color based on position and time
      final color = HSVColor.fromAHSV(
        alpha / 255.0,
        point.hue,
        0.8,
        0.9,
      ).toColor();

      // Create radial gradient for each blob
      final gradient = RadialGradient(
        colors: [
          color.withOpacity(point.life * 0.8),
          color.withOpacity(point.life * 0.4),
          color.withOpacity(0),
        ],
        stops: [0.0, 0.7, 1.0],
      );

      final rect = Rect.fromCircle(
        center: Offset(point.x, point.y),
        radius: point.size,
      );

      paint.shader = gradient.createShader(rect);
      
      // Draw the liquid blob
      canvas.drawCircle(
        Offset(point.x, point.y),
        point.size,
        paint,
      );
    }

    // Connect nearby points with liquid bridges
    paint.shader = null;
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    
    for (int i = 0; i < trailPoints.length - 1; i++) {
      final current = trailPoints[i];
      final next = trailPoints[i + 1];
      
      final distance = math.sqrt(
        math.pow(current.x - next.x, 2) + math.pow(current.y - next.y, 2)
      );
      
      if (distance < 50) {
        final alpha = ((current.life + next.life) / 2 * 100).clamp(0, 100).toInt();
        
        final bridgeColor = HSVColor.fromAHSV(
          alpha / 255.0,
          (current.hue + next.hue) / 2,
          0.7,
          0.8,
        ).toColor();
        
        paint.color = bridgeColor;
        paint.strokeWidth = (current.size + next.size) / 4;
        paint.style = PaintingStyle.stroke;
        paint.strokeCap = StrokeCap.round;
        
        canvas.drawLine(
          Offset(current.x, current.y),
          Offset(next.x, next.y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BackgroundParticlesPainter extends CustomPainter {
  final double animationValue;

  BackgroundParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    final random = math.Random(42); // Fixed seed for consistent particles

    // Draw floating particles
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      final offsetX = math.sin(animationValue * 2 * math.pi + i) * 20;
      final offsetY = math.cos(animationValue * 2 * math.pi + i * 0.5) * 15;
      
      final alpha = (math.sin(animationValue * 2 * math.pi + i * 0.3) * 0.3 + 0.4)
          .clamp(0.1, 0.7);
      
      paint.color = Color(0xFF00d4ff).withOpacity(alpha);
      
      canvas.drawCircle(
        Offset(x + offsetX, y + offsetY),
        2 + math.sin(animationValue * 4 * math.pi + i) * 1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}