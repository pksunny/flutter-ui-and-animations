import 'package:flutter/material.dart';
import 'dart:math' as math;

class PalestineFlagScreen extends StatefulWidget {
  const PalestineFlagScreen({Key? key}) : super(key: key);

  @override
  State<PalestineFlagScreen> createState() => _PalestineFlagScreenState();
}

class _PalestineFlagScreenState extends State<PalestineFlagScreen> with TickerProviderStateMixin {
  late AnimationController _outlineController;
  late AnimationController _fillController;
  late AnimationController _textController;
  late Animation<double> _outlineAnimation;
  late Animation<double> _blackFillAnimation;
  late Animation<double> _whiteFillAnimation;
  late Animation<double> _greenFillAnimation;
  late Animation<double> _triangleFillAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textScaleAnimation;

  bool _outlineCompleted = false;
  bool _fillCompleted = false;

  @override
  void initState() {
    super.initState();
    
    // Outline animation controller
    _outlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    _outlineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _outlineController, curve: Curves.easeInOut),
    );
    
    // Fill animation controller
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    _blackFillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fillController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );
    
    _whiteFillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fillController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );
    
    _greenFillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fillController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );
    
    _triangleFillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fillController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    
    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    // Start the outline animation
    _outlineController.forward();
    
    _outlineController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _outlineCompleted = true;
        });
        // Start filling animation after outline is complete
        _fillController.forward();
      }
    });
    
    _fillController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _fillCompleted = true;
        });
        // Start text animation after fill is complete
        _textController.forward();
      }
    });
  }

  @override
  void dispose() {
    _outlineController.dispose();
    _fillController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final flagWidth = size.width * 0.8;
    final flagHeight = flagWidth * 0.6;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.red[900]!,
              Colors.red[700]!,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Blood splatter effects (abstract shapes)
            Positioned(
              top: size.height * 0.1,
              left: size.width * 0.1,
              child: Opacity(
                opacity: 0.6,
                child: BloodSplatter(
                  size: Size(size.width * 0.3, size.height * 0.3),
                  color: Colors.red[800]!,
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.2,
              right: size.width * 0.15,
              child: Opacity(
                opacity: 0.5,
                child: BloodSplatter(
                  size: Size(size.width * 0.25, size.height * 0.25),
                  color: Colors.red[700]!,
                ),
              ),
            ),
            
            // Flag and text container
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flag
                  Container(
                    width: flagWidth,
                    height: flagHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.7),
                        width: 2.0,
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _outlineController, 
                        _fillController,
                        _textController,
                      ]),
                      builder: (context, child) {
                        return CustomPaint(
                          painter: PalestineFlagPainter(
                            outlineProgress: _outlineAnimation.value,
                            blackFillProgress: _blackFillAnimation.value,
                            whiteFillProgress: _whiteFillAnimation.value,
                            greenFillProgress: _greenFillAnimation.value,
                            triangleFillProgress: _triangleFillAnimation.value,
                            outlineCompleted: _outlineCompleted,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  
                  // Text animation
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: Transform.scale(
                          scale: _textScaleAnimation.value,
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [Colors.white, Colors.white70],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds);
                            },
                            child: Text(
                              "FREE PALESTINE",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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

class PalestineFlagPainter extends CustomPainter {
  final double outlineProgress;
  final double blackFillProgress;
  final double whiteFillProgress;
  final double greenFillProgress;
  final double triangleFillProgress;
  final bool outlineCompleted;

  PalestineFlagPainter({
    required this.outlineProgress,
    required this.blackFillProgress,
    required this.whiteFillProgress,
    required this.greenFillProgress,
    required this.triangleFillProgress,
    required this.outlineCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final Paint blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final Paint greenPaint = Paint()
      ..color = Colors.green[700]!
      ..style = PaintingStyle.fill;
    
    final Paint redPaint = Paint()
      ..color = Colors.red[900]!
      ..style = PaintingStyle.fill;
    
    // Define flag dimensions
    final width = size.width;
    final height = size.height;
    final stripeHeight = height / 3;
    
    // Calculate progress for outline animation
    final outlinePathLength = width * 2 + height * 2; // perimeter of flag
    final currentOutlineLength = outlinePathLength * outlineProgress;
    
    // Draw outlines
    if (outlineProgress > 0) {
      final path = Path();

      // Top line
      final topProgress = math.min(1.0, currentOutlineLength / width);
      if (topProgress > 0) {
        path.moveTo(0, 0);
        path.lineTo(width * topProgress, 0);
      }
      
      // Right line
      if (topProgress >= 1.0) {
        final rightProgress = math.min(1.0, (currentOutlineLength - width) / height);
        path.lineTo(width, height * rightProgress);
      }

      // Bottom line
      if (topProgress >= 1.0 && (currentOutlineLength - width) / height >= 1.0) {
        final bottomProgress = math.min(1.0, (currentOutlineLength - width - height) / width);
        path.lineTo(width - (width * bottomProgress), height);
      }

      // Left line
      if (topProgress >= 1.0 && (currentOutlineLength - width) / height >= 1.0 && 
          (currentOutlineLength - width - height) / width >= 1.0) {
        final leftProgress = math.min(1.0, (currentOutlineLength - width * 2 - height) / height);
        path.lineTo(0, height - (height * leftProgress));
      }

      canvas.drawPath(path, outlinePaint);
      
      // Draw the triangle outline
      if (outlineProgress >= 0.7) {
        final trianglePath = Path();
        final triangleProgress = math.min(1.0, (outlineProgress - 0.7) / 0.3);
        
        trianglePath.moveTo(0, 0);
        trianglePath.lineTo(width * 0.3 * triangleProgress, height * 0.5 * triangleProgress);
        trianglePath.lineTo(0, height * triangleProgress);
        trianglePath.close();
        
        canvas.drawPath(trianglePath, outlinePaint);
      }
    }
    
    // Draw filled flag if outline is completed
    if (outlineCompleted) {
      // Draw the black stripe at the top
      Rect blackRect = Rect.fromLTWH(0, 0, width * blackFillProgress, stripeHeight);
      canvas.drawRect(blackRect, blackPaint);
      
      // Draw the white stripe in the middle
      Rect whiteRect = Rect.fromLTWH(0, stripeHeight, width * whiteFillProgress, stripeHeight);
      canvas.drawRect(whiteRect, whitePaint);
      
      // Draw the green stripe at the bottom
      Rect greenRect = Rect.fromLTWH(0, stripeHeight * 2, width * greenFillProgress, stripeHeight);
      canvas.drawRect(greenRect, greenPaint);
      
      // Draw the red triangle
      if (triangleFillProgress > 0) {
        final trianglePath = Path();
        trianglePath.moveTo(0, 0);
        trianglePath.lineTo(width * 0.3 * triangleFillProgress, height * 0.5);
        trianglePath.lineTo(0, height);
        trianglePath.close();
        
        canvas.drawPath(trianglePath, redPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PalestineFlagPainter oldDelegate) {
    return oldDelegate.outlineProgress != outlineProgress ||
        oldDelegate.blackFillProgress != blackFillProgress ||
        oldDelegate.whiteFillProgress != whiteFillProgress ||
        oldDelegate.greenFillProgress != greenFillProgress ||
        oldDelegate.triangleFillProgress != triangleFillProgress ||
        oldDelegate.outlineCompleted != outlineCompleted;
  }
}

class BloodSplatter extends StatelessWidget {
  final Size size;
  final Color color;

  const BloodSplatter({Key? key, required this.size, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: BloodSplatterPainter(color: color),
      ),
    );
  }
}

class BloodSplatterPainter extends CustomPainter {
  final Color color;
  final math.Random random = math.Random(42);

  BloodSplatterPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw main splatter
    final Path mainPath = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Create irregular shape
    mainPath.moveTo(centerX, centerY);
    
    for (int i = 0; i < 20; i++) {
      final angle = 2 * math.pi * i / 20;
      final radius = size.width * 0.3 * (0.7 + 0.3 * random.nextDouble());
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      
      if (i == 0) {
        mainPath.moveTo(x, y);
      } else {
        final controlX = centerX + radius * 1.2 * math.cos(angle - 0.1);
        final controlY = centerY + radius * 1.2 * math.sin(angle - 0.1);
        mainPath.quadraticBezierTo(controlX, controlY, x, y);
      }
    }
    
    mainPath.close();
    canvas.drawPath(mainPath, paint);
    
    // Draw splatters
    for (int i = 0; i < 8; i++) {
      final splatterPath = Path();
      final splatterX = size.width * random.nextDouble();
      final splatterY = size.height * random.nextDouble();
      final splatterSize = size.width * 0.1 * random.nextDouble();
      
      splatterPath.addOval(Rect.fromCircle(
        center: Offset(splatterX, splatterY),
        radius: splatterSize,
      ));
      
      canvas.drawPath(splatterPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}