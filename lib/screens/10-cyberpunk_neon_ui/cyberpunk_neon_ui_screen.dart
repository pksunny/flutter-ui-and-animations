import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;


class CyberpunkDashboard extends StatefulWidget {
  @override
  _CyberpunkDashboardState createState() => _CyberpunkDashboardState();
}

class _CyberpunkDashboardState extends State<CyberpunkDashboard>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _scanlineController;
  late Animation<double> _borderAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanlineAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _scanlineController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_mainController);
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController);
    _scanlineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_scanlineController);

    _mainController.repeat();
    _pulseController.repeat(reverse: true);
    _scanlineController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _scanlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0a0a),
      body: Stack(
        children: [
          // Background grid pattern
          AnimatedBuilder(
            animation: _scanlineAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: GridPainter(_scanlineAnimation.value),
              );
            },
          ),
          
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  SizedBox(height: 30),
                  
                  // Stats Cards Row
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('CPU', '67', '%', Colors.cyan)),
                      SizedBox(width: 15),
                      Expanded(child: _buildStatCard('RAM', '4.2', 'GB', Colors.pink)),
                      SizedBox(width: 15),
                      Expanded(child: _buildStatCard('NET', '127', 'MB/s', Colors.green)),
                    ],
                  ),
                  SizedBox(height: 30),
                  
                  // Main Content Area
                  Expanded(
                    child: Row(
                      children: [
                        // Left Panel
                        Expanded(
                          flex: 2,
                          child: _buildMainPanel(),
                        ),
                        SizedBox(width: 20),
                        
                        // Right Panel
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildStatusPanel(),
                              SizedBox(height: 20),
                              _buildControlPanel(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Bottom Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(_pulseAnimation.value * 0.8),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: NeonBorderPainter(
                  borderProgress: _borderAnimation.value,
                  rotationProgress: _borderAnimation.value,
                  shapeType: ShapeType.circle,
                  neonColor: Colors.cyan,
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CYBERPUNK SYSTEM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.cyan.withOpacity(0.8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Neural Network Interface v2.1',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.cyan.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.power_settings_new,
              color: Colors.red,
              size: 30,
              shadows: [
                Shadow(
                  color: Colors.red.withOpacity(0.8),
                  blurRadius: 10,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, String unit, Color color) {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          height: 100,
          child: CustomPaint(
            painter: NeonBorderPainter(
              borderProgress: _borderAnimation.value,
              rotationProgress: _borderAnimation.value,
              shapeType: ShapeType.roundedSquare,
              neonColor: color,
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          color: color,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: color.withOpacity(0.8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          color: color.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainPanel() {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          child: CustomPaint(
            painter: NeonBorderPainter(
              borderProgress: _borderAnimation.value,
              rotationProgress: _borderAnimation.value,
              shapeType: ShapeType.customRounded,
              neonColor: Colors.orange,
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEURAL ACTIVITY',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.orange.withOpacity(0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _scanlineAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: WaveformPainter(_scanlineAnimation.value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusPanel() {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          height: 200,
          child: CustomPaint(
            painter: NeonBorderPainter(
              borderProgress: _borderAnimation.value,
              rotationProgress: _borderAnimation.value,
              shapeType: ShapeType.square,
              neonColor: Colors.green,
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildStatusItem('Connection', 'ACTIVE', Colors.green),
                  _buildStatusItem('Security', 'SECURED', Colors.green),
                  _buildStatusItem('Firewall', 'ENABLED', Colors.green),
                  _buildStatusItem('Encryption', 'AES-256', Colors.yellow),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlPanel() {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Expanded(
          child: Container(
            child: CustomPaint(
              painter: NeonBorderPainter(
                borderProgress: _borderAnimation.value,
                rotationProgress: _borderAnimation.value,
                shapeType: ShapeType.roundedSquare,
                neonColor: Colors.purple,
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTROLS',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildControlButton('SCAN', Colors.blue),
                          _buildControlButton('BOOST', Colors.red),
                          _buildControlButton('SYNC', Colors.yellow),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusItem(String label, String status, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String text, Color color) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(_pulseAnimation.value * 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('INITIALIZE', Colors.cyan),
        _buildActionButton('TERMINATE', Colors.red),
        _buildActionButton('OPTIMIZE', Colors.green),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 50,
          child: CustomPaint(
            painter: NeonBorderPainter(
              borderProgress: _borderAnimation.value,
              rotationProgress: _borderAnimation.value,
              shapeType: ShapeType.customRounded,
              neonColor: color,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Grid Background Painter
class GridPainter extends CustomPainter {
  final double animationValue;

  GridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.1)
      ..strokeWidth = 0.5;

    double gridSize = 50;
    double offset = animationValue * gridSize;

    for (double x = -offset; x < size.width + gridSize; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = -offset; y < size.height + gridSize; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Waveform Painter
class WaveformPainter extends CustomPainter {
  final double animationValue;

  WaveformPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = Colors.orange.withOpacity(0.6)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    Path path = Path();
    double waveHeight = size.height * 0.3;
    double centerY = size.height / 2;

    path.moveTo(0, centerY);

    for (double x = 0; x < size.width; x += 2) {
      double wave1 = math.sin((x / 50) + (animationValue * 4 * math.pi)) * waveHeight * 0.5;
      double wave2 = math.sin((x / 30) + (animationValue * 6 * math.pi)) * waveHeight * 0.3;
      double wave3 = math.sin((x / 20) + (animationValue * 8 * math.pi)) * waveHeight * 0.2;
      
      double y = centerY + wave1 + wave2 + wave3;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Reusing the NeonBorderPainter from previous code
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
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0);

    Path path = _createPath(size);
    PathMetrics pathMetrics = path.computeMetrics();
    if (pathMetrics.isEmpty) return;
    
    PathMetric pathMetric = pathMetrics.first;
    double totalLength = pathMetric.length;

    if (borderProgress < 1.0) {
      double currentLength = totalLength * borderProgress;
      Path extractedPath = pathMetric.extractPath(0.0, currentLength);
      
      glowPaint.color = neonColor.withOpacity(0.6);
      canvas.drawPath(extractedPath, glowPaint);
      
      paint.color = neonColor;
      canvas.drawPath(extractedPath, paint);
    } else {
      double segmentLength = totalLength * 0.15;
      double startPosition = (totalLength - segmentLength) * rotationProgress;
      
      Path travelingSegment = pathMetric.extractPath(
        startPosition,
        startPosition + segmentLength,
      );
      
      glowPaint.color = neonColor.withOpacity(0.8);
      canvas.drawPath(travelingSegment, glowPaint);
      
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
          Radius.circular(8),
        ));
        break;
        
      case ShapeType.customRounded:
        path.addRRect(RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, width, height),
          topLeft: Radius.circular(15),
          topRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(15),
        ));
        break;
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}