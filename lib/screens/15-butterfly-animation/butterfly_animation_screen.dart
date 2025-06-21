import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class ButterflyGarden extends StatefulWidget {
  const ButterflyGarden({Key? key}) : super(key: key);

  @override
  State<ButterflyGarden> createState() => _ButterflyGardenState();
}

class _ButterflyGardenState extends State<ButterflyGarden>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _backgroundController;
  List<Butterfly> butterflies = [];
  Offset? touchPosition;
  bool isPressed = false;
  Timer? _spawnTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..repeat();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Initialize with some butterflies
    _initializeButterflies();

    // Spawn new butterflies periodically
    _spawnTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (butterflies.length < 15) {
        _addRandomButterfly();
      }
    });

    _controller.addListener(() {
      _updateButterflies();
    });
  }

  void _initializeButterflies() {
    for (int i = 0; i < 8; i++) {
      butterflies.add(_createRandomButterfly());
    }
  }

  Butterfly _createRandomButterfly() {
    final random = math.Random();
    return Butterfly(
      position: Offset(
        random.nextDouble() * 400,
        random.nextDouble() * 600,
      ),
      velocity: Offset(
        (random.nextDouble() - 0.5) * 2,
        (random.nextDouble() - 0.5) * 2,
      ),
      color: HSLColor.fromAHSL(
        1.0,
        random.nextDouble() * 360,
        0.6 + random.nextDouble() * 0.4,
        0.4 + random.nextDouble() * 0.3,
      ).toColor(),
      size: 15 + random.nextDouble() * 25,
      wingPhase: random.nextDouble() * 2 * math.pi,
      flutterSpeed: 0.1 + random.nextDouble() * 0.2,
    );
  }

  void _addRandomButterfly() {
    setState(() {
      butterflies.add(_createRandomButterfly());
    });
  }

  void _updateButterflies() {
    setState(() {
      for (var butterfly in butterflies) {
        butterfly.update(touchPosition, isPressed);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundController.dispose();
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    (math.sin(_backgroundController.value * 2 * math.pi) + 1) / 2,
                  )!,
                  Color.lerp(
                    const Color(0xFF0F3460),
                    const Color(0xFF533483),
                    (math.cos(_backgroundController.value * 2 * math.pi) + 1) / 2,
                  )!,
                  Color.lerp(
                    const Color(0xFF533483),
                    const Color(0xFF7209B7),
                    (math.sin(_backgroundController.value * 2 * math.pi + 1) + 1) / 2,
                  )!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Floating particles in background
                ...List.generate(50, (index) {
                  return AnimatedBuilder(
                    animation: _backgroundController,
                    builder: (context, child) {
                      final random = math.Random(index);
                      final x = random.nextDouble() * MediaQuery.of(context).size.width;
                      final y = random.nextDouble() * MediaQuery.of(context).size.height;
                      final offset = _backgroundController.value * 2 * math.pi;
                      
                      return Positioned(
                        left: x + math.sin(offset + index) * 20,
                        top: y + math.cos(offset + index * 0.5) * 15,
                        child: Container(
                          width: 2 + random.nextDouble() * 3,
                          height: 2 + random.nextDouble() * 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1 + random.nextDouble() * 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  );
                }),
                
                // Main gesture detector
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      touchPosition = details.localPosition;
                      isPressed = true;
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      isPressed = false;
                    });
                  },
                  onTapDown: (details) {
                    setState(() {
                      touchPosition = details.localPosition;
                      isPressed = true;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      isPressed = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomPaint(
                      painter: ButterflyPainter(butterflies, touchPosition, isPressed),
                    ),
                  ),
                ),
                
                // Touch ripple effect
                if (touchPosition != null && isPressed)
                  Positioned(
                    left: touchPosition!.dx - 30,
                    top: touchPosition!.dy - 30,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                // UI Overlay
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Text(
                            '🦋 Butterfly Garden',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Butterflies: ${butterflies.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Touch and drag to attract butterflies',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Add butterfly button
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: FloatingActionButton(
                    onPressed: _addRandomButterfly,
                    backgroundColor: Colors.purple.withOpacity(0.8),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Butterfly {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double wingPhase;
  double flutterSpeed;
  Offset target;
  bool isAttracted = false;

  Butterfly({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.wingPhase,
    required this.flutterSpeed,
  }) : target = position;

  void update(Offset? touchPos, bool isPressed) {
    wingPhase += flutterSpeed;
    
    if (touchPos != null && isPressed) {
      // Calculate attraction to touch
      final distance = (touchPos - position).distance;
      if (distance < 200) {
        isAttracted = true;
        target = touchPos;
        final direction = (touchPos - position);
        final normalizedDirection = direction / direction.distance;
        
        // Smooth attraction with some randomness
        velocity = velocity * 0.8 + normalizedDirection * 0.3;
        velocity = velocity + Offset(
          (math.Random().nextDouble() - 0.5) * 0.1,
          (math.Random().nextDouble() - 0.5) * 0.1,
        );
      }
    } else {
      isAttracted = false;
      // Natural wandering behavior
      velocity = velocity * 0.95 + Offset(
        (math.Random().nextDouble() - 0.5) * 0.2,
        (math.Random().nextDouble() - 0.5) * 0.2,
      );
    }
    
    // Limit velocity
    if (velocity.distance > 3) {
      velocity = velocity / velocity.distance * 3;
    }
    
    position += velocity;
    
    // Bounce off edges with some margin
    if (position.dx < 0 || position.dx > 400) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > 800) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
    
    // Keep in bounds
    position = Offset(
      position.dx.clamp(0, 400),
      position.dy.clamp(0, 800),
    );
  }
}

class ButterflyPainter extends CustomPainter {
  final List<Butterfly> butterflies;
  final Offset? touchPosition;
  final bool isPressed;

  ButterflyPainter(this.butterflies, this.touchPosition, this.isPressed);

  @override
  void paint(Canvas canvas, Size size) {
    for (var butterfly in butterflies) {
      _drawButterfly(canvas, butterfly);
    }
    
    // Draw touch attraction field
    if (touchPosition != null && isPressed) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      
      canvas.drawCircle(touchPosition!, 100, paint);
      canvas.drawCircle(touchPosition!, 150, paint..color = Colors.white.withOpacity(0.05));
    }
  }

  void _drawButterfly(Canvas canvas, Butterfly butterfly) {
    final paint = Paint()
      ..color = butterfly.color
      ..style = PaintingStyle.fill;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final wingFlutter = math.sin(butterfly.wingPhase) * 0.3 + 0.7;
    final bodyLength = butterfly.size * 0.8;
    final wingSpan = butterfly.size * wingFlutter;

    // Draw shadow
    canvas.save();
    canvas.translate(butterfly.position.dx + 2, butterfly.position.dy + 2);
    _drawButterflyShape(canvas, shadowPaint, wingSpan, bodyLength, 0.7);
    canvas.restore();

    // Draw butterfly
    canvas.save();
    canvas.translate(butterfly.position.dx, butterfly.position.dy);
    
    // Rotate based on velocity direction
    if (butterfly.velocity.distance > 0.1) {
      final angle = math.atan2(butterfly.velocity.dy, butterfly.velocity.dx);
      canvas.rotate(angle + math.pi / 2);
    }
    
    _drawButterflyShape(canvas, paint, wingSpan, bodyLength, 1.0);
    canvas.restore();

    // Draw trail if attracted
    if (butterfly.isAttracted) {
      final trailPaint = Paint()
        ..color = butterfly.color.withOpacity(0.3)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      
      canvas.drawCircle(butterfly.position, butterfly.size * 0.3, trailPaint);
    }
  }

  void _drawButterflyShape(Canvas canvas, Paint paint, double wingSpan, double bodyLength, double opacity) {
    paint.color = paint.color.withOpacity(paint.color.opacity * opacity);
    
    // Body
    final bodyPaint = Paint()
      ..color = Colors.brown.withOpacity(0.8 * opacity)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 3, height: bodyLength),
        const Radius.circular(1.5),
      ),
      bodyPaint,
    );

    // Wings
    final wingPath = Path();
    
    // Top wings
    wingPath.moveTo(-wingSpan * 0.3, -bodyLength * 0.3);
    wingPath.quadraticBezierTo(-wingSpan * 0.6, -bodyLength * 0.5, -wingSpan * 0.4, -bodyLength * 0.1);
    wingPath.quadraticBezierTo(-wingSpan * 0.2, -bodyLength * 0.2, -wingSpan * 0.1, -bodyLength * 0.3);
    wingPath.close();
    
    wingPath.moveTo(wingSpan * 0.3, -bodyLength * 0.3);
    wingPath.quadraticBezierTo(wingSpan * 0.6, -bodyLength * 0.5, wingSpan * 0.4, -bodyLength * 0.1);
    wingPath.quadraticBezierTo(wingSpan * 0.2, -bodyLength * 0.2, wingSpan * 0.1, -bodyLength * 0.3);
    wingPath.close();
    
    // Bottom wings
    wingPath.moveTo(-wingSpan * 0.2, bodyLength * 0.1);
    wingPath.quadraticBezierTo(-wingSpan * 0.4, bodyLength * 0.3, -wingSpan * 0.3, bodyLength * 0.2);
    wingPath.quadraticBezierTo(-wingSpan * 0.1, bodyLength * 0.15, -wingSpan * 0.05, bodyLength * 0.1);
    wingPath.close();
    
    wingPath.moveTo(wingSpan * 0.2, bodyLength * 0.1);
    wingPath.quadraticBezierTo(wingSpan * 0.4, bodyLength * 0.3, wingSpan * 0.3, bodyLength * 0.2);
    wingPath.quadraticBezierTo(wingSpan * 0.1, bodyLength * 0.15, wingSpan * 0.05, bodyLength * 0.1);
    wingPath.close();
    
    canvas.drawPath(wingPath, paint);
    
    // Wing patterns
    final patternPaint = Paint()
      ..color = Colors.white.withOpacity(0.4 * opacity)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(-wingSpan * 0.35, -bodyLength * 0.25), wingSpan * 0.08, patternPaint);
    canvas.drawCircle(Offset(wingSpan * 0.35, -bodyLength * 0.25), wingSpan * 0.08, patternPaint);
    
    // Antennae
    final antennaPaint = Paint()
      ..color = Colors.black.withOpacity(0.7 * opacity)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      Offset(-2, -bodyLength * 0.4),
      Offset(-4, -bodyLength * 0.5),
      antennaPaint,
    );
    canvas.drawLine(
      Offset(2, -bodyLength * 0.4),
      Offset(4, -bodyLength * 0.5),
      antennaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}