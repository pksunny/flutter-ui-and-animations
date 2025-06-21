import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class LampControlScreen extends StatefulWidget {
  @override
  _LampControlScreenState createState() => _LampControlScreenState();
}

class _LampControlScreenState extends State<LampControlScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _lampController;
  late AnimationController _wirePhysicsController;
  late AnimationController _roomLightController;
  late AnimationController _flickerController;
  
  late Animation<double> _lampBrightness;
  late Animation<double> _wireSwing;
  late Animation<double> _roomGlow;
  late Animation<double> _lampFlicker;
  
  bool _isLampOn = false;
  double _wirePullDistance = 0;
  bool _isDragging = false;
  Offset _lampPosition = Offset(0, 150);
  Offset _wireEndPosition = Offset(0, 0);
  
  @override
  void initState() {
    super.initState();
    
    _lampController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _wirePhysicsController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _roomLightController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _flickerController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    
    _lampBrightness = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lampController, curve: Curves.easeInOut),
    );
    
    _wireSwing = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _wirePhysicsController, curve: Curves.elasticOut),
    );
    
    _roomGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _roomLightController, curve: Curves.easeInOut),
    );
    
    _lampFlicker = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _flickerController, curve: Curves.easeInOut),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _lampPosition = Offset(size.width / 2, size.height * 0.25);
        _wireEndPosition = Offset(size.width / 2, size.height * 0.25 + 250);
      });
    });
  }
  
  @override
  void dispose() {
    _lampController.dispose();
    _wirePhysicsController.dispose();
    _roomLightController.dispose();
    _flickerController.dispose();
    super.dispose();
  }
  
  void _toggleLamp() {
    HapticFeedback.mediumImpact();
    
    setState(() {
      _isLampOn = !_isLampOn;
    });
    
    if (_isLampOn) {
      _lampController.forward();
      _roomLightController.forward();
      _flickerController.repeat(reverse: true);
    } else {
      _lampController.reverse();
      _roomLightController.reverse();
      _flickerController.stop();
      _flickerController.reset();
    }
    
    // Start wire swing physics
    _wirePhysicsController.forward().then((_) {
      _wirePhysicsController.reverse();
    });
  }
  
  void _onWirePanStart(DragStartDetails details) {
    final wireHandleRect = Rect.fromCenter(
      center: _wireEndPosition,
      width: 50,
      height: 50,
    );
    
    if (wireHandleRect.contains(details.localPosition)) {
      setState(() {
        _isDragging = true;
      });
      HapticFeedback.lightImpact();
    }
  }
  
  void _onWirePanUpdate(DragUpdateDetails details) {
    if (_isDragging) {
      final originalY = _lampPosition.dy + 250;
      final newY = math.max(originalY, details.localPosition.dy);
      final pullDistance = newY - originalY;
      
      setState(() {
        _wirePullDistance = pullDistance;
        _wireEndPosition = Offset(_wireEndPosition.dx, newY);
      });
    }
  }
  
  void _onWirePanEnd(DragEndDetails details) {
    if (_isDragging) {
      setState(() {
        _isDragging = false;
      });
      
      // Check if pulled enough to toggle
      if (_wirePullDistance > 40 || details.velocity.pixelsPerSecond.dy > 200) {
        _toggleLamp();
      }
      
      // Reset wire position with physics
      setState(() {
        _wirePullDistance = 0;
        _wireEndPosition = Offset(_wireEndPosition.dx, _lampPosition.dy + 250);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _lampController,
          _wirePhysicsController,
          _roomLightController,
          _flickerController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // Dark bedroom colors when off, warm glow when on
                  Color.lerp(
                    Color(0xFF0A0B1A),
                    Color(0xFF2A1F15),
                    _roomGlow.value * 0.6,
                  )!,
                  Color.lerp(
                    Color(0xFF050515),
                    Color(0xFF1A1408),
                    _roomGlow.value * 0.4,
                  )!,
                  Color.lerp(
                    Color(0xFF000000),
                    Color(0xFF0F0A05),
                    _roomGlow.value * 0.2,
                  )!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Stars/particles in background
                if (_isLampOn) _buildFloatingParticles(),
                
                // Room ambient glow
                if (_isLampOn) _buildRoomAmbientGlow(),
                
                // Main lamp assembly
                _buildLampAssembly(),
                
                // Wire with physics
                _buildWireWithPhysics(),
                
                // Floor glow effect
                if (_isLampOn) _buildFloorGlow(),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLampAssembly() {
    final swingOffset = math.sin(_wireSwing.value * math.pi * 4) * 15 * _wireSwing.value;
    
    return Positioned(
      left: _lampPosition.dx - 100 + swingOffset,
      top: _lampPosition.dy,
      child: Container(
        width: 200,
        height: 180,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Massive outer glow when lamp is on - creates realistic lighting
            if (_isLampOn)
              Positioned(
                top: 40,
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFFA500).withOpacity(0.6 * _lampFlicker.value),
                        Color(0xFFFF8C00).withOpacity(0.3 * _lampFlicker.value),
                        Color(0xFFFF6B35).withOpacity(0.1 * _lampFlicker.value),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
            
            // Ceiling mount fixture
            Positioned(
              top: 0,
              child: Container(
                width: 20,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A1A1A),
                      Color(0xFF2A2A2A),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            
            // Main lamp shade - realistic pendant design
            Positioned(
              top: 25,
              child: Container(
                width: 160,
                height: 140,
                child: Stack(
                  children: [
                    // Outer shade - matte black metal
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2A2A2A),
                            Color(0xFF1A1A1A),
                            Color(0xFF0A0A0A),
                            Color(0xFF1A1A1A),
                          ],
                          stops: [0.0, 0.3, 0.7, 1.0],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(80),
                          bottomRight: Radius.circular(80),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    
                    // Inner glow surface - warm when on
                    if (_isLampOn)
                      Positioned(
                        top: 8,
                        left: 8,
                        right: 8,
                        bottom: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.bottomCenter,
                              radius: 0.8,
                              colors: [
                                Color(0xFFFFF8DC).withOpacity(0.9 * _lampFlicker.value),
                                Color(0xFFFFA500).withOpacity(0.7 * _lampFlicker.value),
                                Color(0xFFFF8C00).withOpacity(0.5 * _lampFlicker.value),
                                Color(0xFFFF6B35).withOpacity(0.2 * _lampFlicker.value),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.3, 0.6, 0.8, 1.0],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(75),
                              bottomRight: Radius.circular(75),
                            ),
                          ),
                        ),
                      ),
                    
                    // Realistic light bulb - Edison style
                    if (_isLampOn)
                      Positioned(
                        bottom: 30,
                        left: 65,
                        child: Container(
                          width: 30,
                          height: 50,
                          child: Stack(
                            children: [
                              // Bulb glass
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFFFF8DC).withOpacity(0.8 * _lampFlicker.value),
                                      Color(0xFFFFE4B5).withOpacity(0.9 * _lampFlicker.value),
                                      Color(0xFFFFA500).withOpacity(0.7 * _lampFlicker.value),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15),
                                    bottom: Radius.circular(12),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFFA500).withOpacity(0.8 * _lampFlicker.value),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                              // Filament lines
                              Positioned(
                                top: 8,
                                left: 10,
                                child: Container(
                                  width: 10,
                                  height: 30,
                                  child: Column(
                                    children: List.generate(4, (i) => Container(
                                      width: 8,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFD700).withOpacity(0.9 * _lampFlicker.value),
                                        borderRadius: BorderRadius.circular(0.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFFFD700).withOpacity(0.6),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              // Bulb base
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 30,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3A3A3A),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Lamp shade highlight - makes it look metallic
                    Positioned(
                      top: 20,
                      left: 30,
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    
                    // Bottom rim detail
                    Positioned(
                      bottom: 5,
                      left: 10,
                      right: 10,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF3A3A3A),
                              Color(0xFF1A1A1A),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWireWithPhysics() {
    final swingOffset = math.sin(_wireSwing.value * math.pi * 4) * 15 * _wireSwing.value;
    final wireStart = Offset(_lampPosition.dx + swingOffset, _lampPosition.dy);
    final wireEnd = Offset(_wireEndPosition.dx + swingOffset, _wireEndPosition.dy + _wirePullDistance);
    
    return Positioned.fill(
      child: GestureDetector(
        onPanStart: _onWirePanStart,
        onPanUpdate: _onWirePanUpdate,
        onPanEnd: _onWirePanEnd,
        child: CustomPaint(
          painter: WirePhysicsPainter(
            wireStart: wireStart,
            wireEnd: wireEnd,
            isDragging: _isDragging,
            swingValue: _wireSwing.value,
            pullDistance: _wirePullDistance,
          ),
        ),
      ),
    );
  }
  
  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ParticlesPainter(
          lampCenter: _lampPosition,
          brightness: _lampBrightness.value * _lampFlicker.value,
          time: _roomLightController.value * 10,
        ),
      ),
    );
  }
  
  Widget _buildRoomAmbientGlow() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.5,
            colors: [
              Color(0xFFFFA500).withOpacity(0.2 * _roomGlow.value * _lampFlicker.value),
              Color(0xFFFF8C00).withOpacity(0.12 * _roomGlow.value * _lampFlicker.value),
              Color(0xFFFF6B35).withOpacity(0.06 * _roomGlow.value * _lampFlicker.value),
              Colors.transparent,
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFloorGlow() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              Color(0xFFFFA500).withOpacity(0.4 * _roomGlow.value * _lampFlicker.value),
              Color(0xFFFF8C00).withOpacity(0.2 * _roomGlow.value * _lampFlicker.value),
              Color(0xFFFF6B35).withOpacity(0.1 * _roomGlow.value * _lampFlicker.value),
              Colors.transparent,
            ],
            stops: [0.0, 0.5, 0.8, 1.0],
          ),
        ),
      ),
    );
  }
}

class WirePhysicsPainter extends CustomPainter {
  final Offset wireStart;
  final Offset wireEnd;
  final bool isDragging;
  final double swingValue;
  final double pullDistance;
  
  WirePhysicsPainter({
    required this.wireStart,
    required this.wireEnd,
    required this.isDragging,
    required this.swingValue,
    required this.pullDistance,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Draw ceiling connection - more realistic
    final ceilingMount = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
      ).createShader(Rect.fromLTWH(wireStart.dx - 15, 0, 30, 40));
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(wireStart.dx, 20), width: 30, height: 40),
        Radius.circular(5),
      ),
      ceilingMount,
    );
    
    // Main electrical wire - twisted cable look
    final path = Path();
    path.moveTo(wireStart.dx, wireStart.dy);
    
    // Create realistic wire sag and swing
    final distance = (wireEnd - wireStart).distance;
    final swingInfluence = swingValue * 20;
    final sagAmount = math.max(15, distance * 0.18) + pullDistance * 0.4;
    
    final controlPoint1 = Offset(
      wireStart.dx + swingInfluence,
      wireStart.dy + distance * 0.25,
    );
    
    final controlPoint2 = Offset(
      wireEnd.dx + swingInfluence * 0.5,
      wireEnd.dy - distance * 0.15 + sagAmount,
    );
    
    path.cubicTo(
      controlPoint1.dx, controlPoint1.dy,
      controlPoint2.dx, controlPoint2.dy,
      wireEnd.dx, wireEnd.dy,
    );
    
    // Wire shadow first
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawPath(path, shadowPaint);
    
    // Main wire - realistic electrical cable
    final wirePaint = Paint()
      ..color = isDragging ? Color(0xFF4A4A4A) : Color(0xFF2A2A2A)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(path, wirePaint);
    
    // Wire texture lines for realism
    final texturePaint = Paint()
      ..color = Color(0xFF3A3A3A)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    canvas.drawPath(path, texturePaint);
    
    // Realistic pull cord handle - wooden bead style
    final handlePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFFDEB887), // Burlywood
          Color(0xFFA0522D), // Sienna
          Color(0xFF8B4513), // Saddle brown
        ],
        stops: [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCenter(center: wireEnd, width: 50, height: 30));
    
    // Wooden bead shape
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: wireEnd, width: 50, height: 30),
        Radius.circular(15),
      ),
      handlePaint,
    );
    
    // Wood grain effect
    final grainPaint = Paint()
      ..color = Color(0xFF654321).withOpacity(0.4)
      ..strokeWidth = 1;
    
    for (int i = -2; i <= 2; i++) {
      canvas.drawLine(
        Offset(wireEnd.dx - 20, wireEnd.dy + i * 3),
        Offset(wireEnd.dx + 20, wireEnd.dy + i * 3),
        grainPaint,
      );
    }
    
    // Handle highlight for 3D effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: wireEnd + Offset(-8, -5), width: 25, height: 12),
        Radius.circular(6),
      ),
      highlightPaint,
    );
    
    // Drag interaction glow
    if (isDragging) {
      final dragGlow = Paint()
        ..color = Color(0xFFFFA500).withOpacity(0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
      
      canvas.drawCircle(wireEnd, 30, dragGlow);
    }
  }
  
  @override
  bool shouldRepaint(WirePhysicsPainter oldDelegate) {
    return wireStart != oldDelegate.wireStart ||
        wireEnd != oldDelegate.wireEnd ||
        isDragging != oldDelegate.isDragging ||
        swingValue != oldDelegate.swingValue ||
        pullDistance != oldDelegate.pullDistance;
  }
}

class ParticlesPainter extends CustomPainter {
  final Offset lampCenter;
  final double brightness;
  final double time;
  
  ParticlesPainter({
    required this.lampCenter,
    required this.brightness,
    required this.time,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = Color(0xFFFFA500).withOpacity(0.7 * brightness)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    
    // Floating dust particles in lamp light - more realistic
    for (int i = 0; i < 25; i++) {
      final angle = (i / 25) * 2 * math.pi + time * 0.3;
      final radius = 60 + math.sin(time * 0.8 + i) * 50;
      final x = lampCenter.dx + math.cos(angle) * radius;
      final y = lampCenter.dy + 100 + math.sin(time * 0.5 + i) * 80;
      
      final particleSize = 0.8 + math.sin(time * 2 + i) * 0.6;
      
      if (y > lampCenter.dy + 50 && y < size.height && x > 50 && x < size.width - 50) {
        canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
      }
    }
    
    // Brighter sparkles near the bulb
    for (int i = 0; i < 12; i++) {
      final sparkleX = lampCenter.dx + math.sin(time * 1.5 + i * 0.5) * 80;
      final sparkleY = lampCenter.dy + 80 + math.cos(time * 1.8 + i) * 40;
      
      final sparklePaint = Paint()
        ..color = Color(0xFFFFD700).withOpacity(0.9 * brightness)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1);
      
      canvas.drawCircle(Offset(sparkleX, sparkleY), 0.8, sparklePaint);
    }
  }
  
  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return brightness != oldDelegate.brightness || time != oldDelegate.time;
  }
}