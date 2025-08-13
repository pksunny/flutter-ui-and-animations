import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class DigitalClockScreen extends StatefulWidget {
  @override
  _DigitalClockScreenState createState() => _DigitalClockScreenState();
}

class _DigitalClockScreenState extends State<DigitalClockScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _rotationController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    // Create animations
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));
    
    // Start timer for time updates
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0A),
            ],
            center: Alignment.center,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _rotationController,
              _pulseController,
              _glowController,
              _particleController,
            ]),
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Particle effects
                  ...List.generate(12, (index) => _buildParticle(index)),
                  
                  // Outer glow ring
                  Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00F5FF).withOpacity(_glowAnimation.value * 0.3),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Color(0xFF8A2BE2).withOpacity(_glowAnimation.value * 0.2),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Main clock container
                  Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1E1E2E).withOpacity(0.9),
                          Color(0xFF2D2D44).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Color(0xFF00F5FF).withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Hour markers and numbers
                        ...List.generate(12, (index) => _buildHourMarker(index + 1)),
                        
                        // Clock hands
                        CustomPaint(
                          size: Size(350, 350),
                          painter: ClockHandsPainter(_currentTime, _glowAnimation.value),
                        ),
                        
                        // Digital time display
                        // Container(
                        //   margin: EdgeInsets.only(top: 100,),
                        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(25),
                        //     gradient: LinearGradient(
                        //       colors: [
                        //         Color(0xFF00F5FF).withOpacity(0.2),
                        //         Color(0xFF8A2BE2).withOpacity(0.2),
                        //       ],
                        //     ),
                        //     border: Border.all(
                        //       color: Color(0xFF00F5FF).withOpacity(0.5),
                        //       width: 1,
                        //     ),
                        //   ),
                        //   child: Text(
                        //     _formatTime(_currentTime),
                        //     style: TextStyle(
                        //       fontSize: 24,
                        //       fontWeight: FontWeight.bold,
                        //       color: Color(0xFF00F5FF),
                        //       letterSpacing: 2,
                        //       shadows: [
                        //         Shadow(
                        //           color: Color(0xFF00F5FF).withOpacity(0.8),
                        //           blurRadius: 10,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        
                        // Date display
                        // Container(
                        //   margin: EdgeInsets.only(top: 140),
                        //   child: Text(
                        //     _formatDate(_currentTime),
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       color: Color(0xFF8A2BE2),
                        //       letterSpacing: 1,
                        //       shadows: [
                        //         Shadow(
                        //           color: Color(0xFF8A2BE2).withOpacity(0.6),
                        //           blurRadius: 5,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        
                        // Center dot
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFF00F5FF),
                                Color(0xFF8A2BE2),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00F5FF),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    final angle = (index * 30) * (math.pi / 180);
    final radius = 200 + (math.sin(_particleAnimation.value * 2 * math.pi + index) * 20);
    final x = math.cos(angle + _particleAnimation.value * 2 * math.pi) * radius;
    final y = math.sin(angle + _particleAnimation.value * 2 * math.pi) * radius;
    
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF00F5FF).withOpacity(0.6),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF00F5FF),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourMarker(int hour) {
    final angle = (hour * 30 - 90) * (math.pi / 180);
    final isMainHour = hour % 3 == 0;
    final radius = 140.0;
    
    return Transform.rotate(
      angle: angle + math.pi / 2,
      child: Transform.translate(
        offset: Offset(0, -radius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isMainHour ? 4 : 2,
              height: isMainHour ? 30 : 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00F5FF),
                    Color(0xFF8A2BE2),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00F5FF).withOpacity(0.6),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            if (isMainHour) ...[
              SizedBox(height: 10),
              Transform.rotate(
                angle: -(angle + math.pi / 2),
                child: Text(
                  hour.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00F5FF),
                    shadows: [
                      Shadow(
                        color: Color(0xFF00F5FF),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
           '${time.minute.toString().padLeft(2, '0')}:'
           '${time.second.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime time) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return '${days[time.weekday % 7]}, ${months[time.month - 1]} ${time.day}';
  }
}

class ClockHandsPainter extends CustomPainter {
  final DateTime time;
  final double glowIntensity;

  ClockHandsPainter(this.time, this.glowIntensity);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Calculate angles
    final secondAngle = (time.second * 6 - 90) * (math.pi / 180);
    final minuteAngle = (time.minute * 6 + time.second * 0.1 - 90) * (math.pi / 180);
    final hourAngle = (time.hour % 12 * 30 + time.minute * 0.5 - 90) * (math.pi / 180);

    // Hour hand
    _drawHand(
      canvas,
      center,
      hourAngle,
      80,
      6,
      Color(0xFF00F5FF),
    );

    // Minute hand
    _drawHand(
      canvas,
      center,
      minuteAngle,
      110,
      4,
      Color(0xFF8A2BE2),
    );

    // Second hand
    _drawHand(
      canvas,
      center,
      secondAngle,
      130,
      2,
      Color(0xFFFF6B6B),
    );
  }

  void _drawHand(Canvas canvas, Offset center, double angle, double length, 
                 double width, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

    final endPoint = Offset(
      center.dx + math.cos(angle) * length,
      center.dy + math.sin(angle) * length,
    );

    canvas.drawLine(center, endPoint, paint);
    
    // Add glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(glowIntensity * 0.5)
      ..strokeWidth = width * 3
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawLine(center, endPoint, glowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}