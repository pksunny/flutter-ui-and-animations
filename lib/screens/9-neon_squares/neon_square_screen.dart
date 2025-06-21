import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;


class NeonAnimationScreen extends StatefulWidget {
  @override
  _NeonAnimationScreenState createState() => _NeonAnimationScreenState();
}

class _NeonAnimationScreenState extends State<NeonAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderProgressAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    // Border drawing animation (0 to 1)
    _borderProgressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    // Rotation animation for the traveling segment
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.linear),
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Neon Border Animation'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Square shape
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(100, 100),
                        painter: NeonBorderPainter(
                          borderProgress: _borderProgressAnimation.value,
                          rotationProgress: _rotationAnimation.value,
                          shapeType: ShapeType.square,
                          neonColor: Colors.cyan,
                        ),
                      );
                    },
                  ),
                  
                  // Circle shape
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(100, 100),
                        painter: NeonBorderPainter(
                          borderProgress: _borderProgressAnimation.value,
                          rotationProgress: _rotationAnimation.value,
                          shapeType: ShapeType.circle,
                          neonColor: Colors.pink,
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rounded square
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(100, 100),
                        painter: NeonBorderPainter(
                          borderProgress: _borderProgressAnimation.value,
                          rotationProgress: _rotationAnimation.value,
                          shapeType: ShapeType.roundedSquare,
                          neonColor: Colors.green,
                        ),
                      );
                    },
                  ),
                  
                  // Custom rounded square
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(100, 100),
                        painter: NeonBorderPainter(
                          borderProgress: _borderProgressAnimation.value,
                          rotationProgress: _rotationAnimation.value,
                          shapeType: ShapeType.customRounded,
                          neonColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ShapeType {
  square,
  circle,
  roundedSquare,
  customRounded,
}

class NeonBorderPainter extends CustomPainter {
  final double borderProgress;
  final double rotationProgress;
  final ShapeType shapeType;
  final Color neonColor;

  NeonBorderPainter({
    required this.borderProgress,
    required this.rotationProgress,
    required this.shapeType,
    required this.neonColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0);

    Path path = _createPath(size);
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.first;
    double totalLength = pathMetric.length;

    if (borderProgress < 1.0) {
      // Phase 1: Drawing full border
      double currentLength = totalLength * borderProgress;
      Path extractedPath = pathMetric.extractPath(0.0, currentLength);
      
      // Draw glow effect
      glowPaint.color = neonColor.withOpacity(0.6);
      canvas.drawPath(extractedPath, glowPaint);
      
      // Draw main border
      paint.color = neonColor;
      canvas.drawPath(extractedPath, paint);
    } else {
      // Phase 2: Traveling border segment
      double segmentLength = totalLength * 0.2; // 20% of total border
      double startPosition = (totalLength - segmentLength) * rotationProgress;
      
      Path travelingSegment = pathMetric.extractPath(
        startPosition,
        startPosition + segmentLength,
      );
      
      // Draw glow effect for traveling segment
      glowPaint.color = neonColor.withOpacity(0.8);
      canvas.drawPath(travelingSegment, glowPaint);
      
      // Draw main traveling segment
      paint.color = neonColor;
      canvas.drawPath(travelingSegment, paint);
    }
  }

  Path _createPath(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    switch (shapeType) {
      case ShapeType.square:
        path.addRect(Rect.fromLTWH(0, 0, width, height));
        break;
        
      case ShapeType.circle:
        path.addOval(Rect.fromLTWH(0, 0, width, height));
        break;
        
      case ShapeType.roundedSquare:
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, width, height),
          Radius.circular(15),
        ));
        break;
        
      case ShapeType.customRounded:
        path.addRRect(RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, width, height),
          topLeft: Radius.circular(25),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(25),
        ));
        break;
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}