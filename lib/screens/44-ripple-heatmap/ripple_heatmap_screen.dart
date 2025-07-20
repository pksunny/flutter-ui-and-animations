import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class RippleHeatmapScreen extends StatefulWidget {
  @override
  _RippleHeatmapScreenState createState() => _RippleHeatmapScreenState();
}

class _RippleHeatmapScreenState extends State<RippleHeatmapScreen>
    with TickerProviderStateMixin {
  List<RipplePoint> ripples = [];
  late AnimationController _controller;
  late AnimationController _backgroundController;
  
  final List<Color> heatColors = [
    Color(0xFF00F5FF), // Cyan
    Color(0xFF1E90FF), // Blue
    Color(0xFF9932CC), // Purple
    Color(0xFFFF1493), // Pink
    Color(0xFFFF4500), // Orange
    Color(0xFFFFD700), // Gold
    Color(0xFF32CD32), // Lime
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 8000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _addRipple(Offset position) {
    setState(() {
      Color rippleColor = heatColors[Random().nextInt(heatColors.length)];
      ripples.add(RipplePoint(
        position: position,
        color: rippleColor,
        startTime: DateTime.now(),
      ));
      
      // Keep only recent ripples to prevent memory issues
      if (ripples.length > 50) {
        ripples.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(_backgroundController.value),
                size: Size.infinite,
              );
            },
          ),
          
          // Main heatmap area
          GestureDetector(
            onTapDown: (details) => _addRipple(details.localPosition),
            onPanUpdate: (details) => _addRipple(details.localPosition),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Remove old ripples
                ripples.removeWhere((ripple) {
                  return DateTime.now().difference(ripple.startTime).inMilliseconds > 2000;
                });
                
                return CustomPaint(
                  painter: HeatmapPainter(ripples, _controller.value),
                  size: Size.infinite,
                );
              },
            ),
          ),
          
          // Top UI overlay
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  'RIPPLE HEATMAP ANIMATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 3.0,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Color(0xFF00F5FF),
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
          
          // Bottom stats panel
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xFF00F5FF).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00F5FF).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Active Ripples', ripples.length.toString()),
                  _buildStatItem('Heat Level', _getHeatLevel()),
                  _buildStatItem('Status', 'ACTIVE'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00F5FF),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  String _getHeatLevel() {
    if (ripples.length < 5) return 'LOW';
    if (ripples.length < 15) return 'MED';
    if (ripples.length < 30) return 'HIGH';
    return 'MAX';
  }
}

class RipplePoint {
  final Offset position;
  final Color color;
  final DateTime startTime;

  RipplePoint({
    required this.position,
    required this.color,
    required this.startTime,
  });
}

class HeatmapPainter extends CustomPainter {
  final List<RipplePoint> ripples;
  final double animationValue;

  HeatmapPainter(this.ripples, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var ripple in ripples) {
      var elapsed = DateTime.now().difference(ripple.startTime).inMilliseconds;
      var progress = (elapsed / 2000.0).clamp(0.0, 1.0);
      
      if (progress < 1.0) {
        _drawRipple(canvas, ripple, progress);
        _drawParticles(canvas, ripple, progress);
      }
    }
  }

  void _drawRipple(Canvas canvas, RipplePoint ripple, double progress) {
    // Main ripple circle
    var radius = 80 * progress;
    var opacity = (1.0 - progress) * 0.8;
    
    var paint = Paint()
      ..color = ripple.color.withOpacity(opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(ripple.position, radius, paint);

    // Outer glow ring
    var glowRadius = 120 * progress;
    var glowOpacity = (1.0 - progress) * 0.3;
    
    var glowPaint = Paint()
      ..color = ripple.color.withOpacity(glowOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(ripple.position, glowRadius, glowPaint);

    // Inner bright core
    if (progress < 0.3) {
      var coreRadius = 20 * (0.3 - progress) / 0.3;
      var corePaint = Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

      canvas.drawCircle(ripple.position, coreRadius, corePaint);
    }
  }

  void _drawParticles(Canvas canvas, RipplePoint ripple, double progress) {
    var particleCount = 12;
    var particleRadius = 60 + (40 * progress);
    
    for (int i = 0; i < particleCount; i++) {
      var angle = (i / particleCount) * 2 * pi + (animationValue * 2 * pi);
      var particleX = ripple.position.dx + cos(angle) * particleRadius;
      var particleY = ripple.position.dy + sin(angle) * particleRadius;
      
      var particleOpacity = (1.0 - progress) * 0.6;
      var particleSize = 4 * (1.0 - progress);
      
      var particlePaint = Paint()
        ..color = ripple.color.withOpacity(particleOpacity)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(Offset(particleX, particleY), particleSize, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Gradient background
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        Color(0xFF1A1A2E),
        Color(0xFF16213E),
        Color(0xFF0F0F23),
        Color(0xFF0A0A0F),
      ],
    );

    var paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Floating particles
    var particlePaint = Paint()
      ..color = Color(0xFF00F5FF).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      var x = (size.width / 20) * i + (sin(animationValue * 2 * pi + i) * 50);
      var y = (size.height / 4) + (cos(animationValue * 2 * pi + i * 0.5) * 100);
      var particleSize = 2 + sin(animationValue * 4 * pi + i) * 1;
      
      canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
    }

    // Grid lines
    var gridPaint = Paint()
      ..color = Color(0xFF00F5FF).withOpacity(0.05)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}