import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class RabbitAnimationsScreen extends StatefulWidget {
  const RabbitAnimationsScreen({Key? key}) : super(key: key);

  @override
  _RabbitAnimationsScreenState createState() => _RabbitAnimationsScreenState();
}

class _RabbitAnimationsScreenState extends State<RabbitAnimationsScreen> with TickerProviderStateMixin {
  late AnimationController _jumpingController;
  late AnimationController _sleepingController;
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  double _sleepingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Jumping rabbit animation
    _jumpingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Sleeping rabbit animation
    _sleepingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Progress animation for sleeping rabbit
    _sleepingController.addListener(() {
      setState(() {
        _sleepingProgress = (_sleepingProgress + 0.001) % 1.0;
      });
    });

    // Add background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.purple.shade900,
            end: Colors.blue.shade900,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.blue.shade900,
            end: Colors.indigo.shade900,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.indigo.shade900,
            end: Colors.purple.shade900,
          ),
        ),
      ],
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _jumpingController.dispose();
    _sleepingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Rabbit Animations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _backgroundAnimation.value ?? Colors.purple.shade900,
                    Colors.black,
                  ],
                ),
              ),
              child: child,
            );
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, bottom: 16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Jumping Rabbit
                animationCard(
                  title: 'Jumping Rabbit',
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: AnimatedBuilder(
                          animation: _jumpingController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: JumpingRabbitPainter(
                                animation: _jumpingController.value,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const LinearProgressIndicator(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sleeping Rabbit
                animationCard(
                  title: 'Sleeping Rabbit',
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: AnimatedBuilder(
                          animation: _sleepingController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: SleepingRabbitPainter(
                                animation: _sleepingProgress,
                                breathingAnimation: _sleepingController.value,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(value: _sleepingProgress),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget animationCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// Painters for each rabbit animation

class JumpingRabbitPainter extends CustomPainter {
  final double animation;

  JumpingRabbitPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final double jumpHeight = 30.0 * math.sin(animation * math.pi);
    final double baseY = size.height - 30 - jumpHeight;
    
    final Paint bodyPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    
    final Paint earPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
      
    final Paint innerEarPaint = Paint()
      ..color = Colors.pink.shade100
      ..style = PaintingStyle.fill;
      
    final Paint eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final Paint nosePaint = Paint()
      ..color = Colors.pink.shade200
      ..style = PaintingStyle.fill;
      
    // Legs position changes with jump height
    final double legAngle = 0.2 + 0.3 * math.sin(animation * math.pi * 2);
    
    // Draw body
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, baseY),
        width: 40,
        height: 50,
      ),
      bodyPaint,
    );
    
    // Draw ears
    final earSpacing = 10.0;
    final earHeight = 25.0 + 5 * math.sin(animation * math.pi);
    
    // Left ear
    var leftEarPath = Path()
      ..moveTo(size.width / 2 - earSpacing, baseY - 25)
      ..quadraticBezierTo(
        size.width / 2 - earSpacing - 5, baseY - 25 - earHeight / 2,
        size.width / 2 - earSpacing, baseY - 25 - earHeight,
      )
      ..quadraticBezierTo(
        size.width / 2 - earSpacing + 8, baseY - 25 - earHeight / 2,
        size.width / 2 - earSpacing + 5, baseY - 25,
      )
      ..close();
    canvas.drawPath(leftEarPath, earPaint);
    
    // Left ear inner
    var leftInnerEarPath = Path()
      ..moveTo(size.width / 2 - earSpacing, baseY - 25)
      ..quadraticBezierTo(
        size.width / 2 - earSpacing - 2, baseY - 25 - earHeight / 2,
        size.width / 2 - earSpacing, baseY - 25 - earHeight + 5,
      )
      ..quadraticBezierTo(
        size.width / 2 - earSpacing + 5, baseY - 25 - earHeight / 2,
        size.width / 2 - earSpacing + 3, baseY - 25,
      )
      ..close();
    canvas.drawPath(leftInnerEarPath, innerEarPaint);
    
    // Right ear
    var rightEarPath = Path()
      ..moveTo(size.width / 2 + earSpacing, baseY - 25)
      ..quadraticBezierTo(
        size.width / 2 + earSpacing + 5, baseY - 25 - earHeight / 2,
        size.width / 2 + earSpacing, baseY - 25 - earHeight,
      )
      ..quadraticBezierTo(
        size.width / 2 + earSpacing - 8, baseY - 25 - earHeight / 2,
        size.width / 2 + earSpacing - 5, baseY - 25,
      )
      ..close();
    canvas.drawPath(rightEarPath, earPaint);
    
    // Right ear inner
    var rightInnerEarPath = Path()
      ..moveTo(size.width / 2 + earSpacing, baseY - 25)
      ..quadraticBezierTo(
        size.width / 2 + earSpacing + 2, baseY - 25 - earHeight / 2,
        size.width / 2 + earSpacing, baseY - 25 - earHeight + 5,
      )
      ..quadraticBezierTo(
        size.width / 2 + earSpacing - 5, baseY - 25 - earHeight / 2,
        size.width / 2 + earSpacing - 3, baseY - 25,
      )
      ..close();
    canvas.drawPath(rightInnerEarPath, innerEarPaint);
    
    // Draw eyes
    canvas.drawCircle(
      Offset(size.width / 2 - 8, baseY - 10),
      3,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2 + 8, baseY - 10),
      3,
      eyePaint,
    );
    
    // Draw nose
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, baseY - 5),
        width: 8,
        height: 6,
      ),
      nosePaint,
    );
    
    // Draw legs
    final Paint legPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
      
    // Front legs
    canvas.drawLine(
      Offset(size.width / 2 - 10, baseY + 15),
      Offset(size.width / 2 - 15, baseY + 25 + 5 * math.sin(legAngle)),
      legPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2 + 10, baseY + 15),
      Offset(size.width / 2 + 15, baseY + 25 + 5 * math.cos(legAngle)),
      legPaint,
    );
    
    // Rear legs (bigger)
    canvas.drawLine(
      Offset(size.width / 2 - 5, baseY + 20),
      Offset(size.width / 2 - 15, baseY + 35 + 5 * math.cos(legAngle)),
      legPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2 + 5, baseY + 20),
      Offset(size.width / 2 + 15, baseY + 35 + 5 * math.sin(legAngle)),
      legPaint,
    );
    
    // Draw tail
    final Paint tailPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(
      Offset(size.width / 2, baseY + 20),
      7,
      tailPaint,
    );
  }

  @override
  bool shouldRepaint(JumpingRabbitPainter oldDelegate) => true;
}

class SleepingRabbitPainter extends CustomPainter {
  final double animation; // 0.0-1.0 for sleep to wake transition
  final double breathingAnimation; // For subtle breathing movement

  SleepingRabbitPainter({required this.animation, required this.breathingAnimation});

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height - 30;
    
    final Paint bodyPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    
    final Paint earPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
      
    final Paint innerEarPaint = Paint()
      ..color = Colors.pink.shade100
      ..style = PaintingStyle.fill;
      
    final Paint eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
      
    final Paint eyeLidPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    
    final Paint nosePaint = Paint()
      ..color = Colors.pink.shade200
      ..style = PaintingStyle.fill;
      
    // Breathing effect
    final breathingOffset = 2 * math.sin(breathingAnimation * math.pi);
    
    // Ear position changes from flat (sleeping) to upright (awake)
    final earRotation = -1.5 + animation * 1.5;
    
    // Draw body with breathing
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, baseY),
        width: 50,
        height: 30 + breathingOffset,
      ),
      bodyPaint,
    );
    
    // Draw ears
    final earSpacing = 10.0;
    final earHeight = 20.0;
    
    canvas.save();
    canvas.translate(size.width / 2 - earSpacing, baseY - 10);
    canvas.rotate(earRotation * (1 - animation)); // Ears lie flat when sleeping
    
    // Left ear
    var leftEarPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        -5, -earHeight / 2,
        0, -earHeight,
      )
      ..quadraticBezierTo(
        8, -earHeight / 2,
        5, 0,
      )
      ..close();
    canvas.drawPath(leftEarPath, earPaint);
    
    // Left ear inner
    var leftInnerEarPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        -2, -earHeight / 2,
        0, -earHeight + 5,
      )
      ..quadraticBezierTo(
        5, -earHeight / 2,
        3, 0,
      )
      ..close();
    canvas.drawPath(leftInnerEarPath, innerEarPaint);
    canvas.restore();
    
    canvas.save();
    canvas.translate(size.width / 2 + earSpacing, baseY - 10);
    canvas.rotate(-earRotation * (1 - animation)); // Ears lie flat when sleeping
    
    // Right ear
    var rightEarPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        5, -earHeight / 2,
        0, -earHeight,
      )
      ..quadraticBezierTo(
        -8, -earHeight / 2,
        -5, 0,
      )
      ..close();
    canvas.drawPath(rightEarPath, earPaint);
    
    // Right ear inner
    var rightInnerEarPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        2, -earHeight / 2,
        0, -earHeight + 5,
      )
      ..quadraticBezierTo(
        -5, -earHeight / 2,
        -3, 0,
      )
      ..close();
    canvas.drawPath(rightInnerEarPath, innerEarPaint);
    canvas.restore();
    
    // Draw eyes - closed when sleeping, open when awake
    final eyeOpenness = animation;
    
    // Left eye
    canvas.drawCircle(
      Offset(size.width / 2 - 8, baseY - 5),
      3,
      eyePaint,
    );
    
    // Left eyelid
    if (eyeOpenness < 1.0) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2 - 8, baseY - 5),
          width: 8,
          height: 8,
        ),
        0,
        math.pi * 2 * (1 - eyeOpenness),
        true,
        eyeLidPaint,
      );
    }
    
    // Right eye
    canvas.drawCircle(
      Offset(size.width / 2 + 8, baseY - 5),
      3,
      eyePaint,
    );
    
    // Right eyelid
    if (eyeOpenness < 1.0) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2 + 8, baseY - 5),
          width: 8,
          height: 8,
        ),
        0,
        math.pi * 2 * (1 - eyeOpenness),
        true,
        eyeLidPaint,
      );
    }
    
    // Draw nose
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, baseY),
        width: 8,
        height: 6,
      ),
      nosePaint,
    );
    
    // Draw front legs
    final Paint legPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
      
    // Legs tucked in when sleeping, extended when awake
    final legExtension = animation * 10;
    
    canvas.drawLine(
      Offset(size.width / 2 - 10, baseY + 10),
      Offset(size.width / 2 - 15, baseY + 15 + legExtension),
      legPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2 + 10, baseY + 10),
      Offset(size.width / 2 + 15, baseY + 15 + legExtension),
      legPaint,
    );
    
    // Draw tail
    final Paint tailPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(
      Offset(size.width / 2 - 25, baseY + 5),
      5,
      tailPaint,
    );
  }

  @override
  bool shouldRepaint(SleepingRabbitPainter oldDelegate) => true;
}