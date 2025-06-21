import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> with TickerProviderStateMixin {
  bool _isRetaliationStarted = false;
  late AnimationController _buttonPulseController;
  late AnimationController _flagWaveController;
  late AnimationController _explosionController;
  final List<ExplosionParticle> _explosionParticles = [];
  final List<Missile> _missiles = [];
  final _random = math.Random();
  Timer? _missileTimer;
  Timer? _explosionTimer;
  double _alertOpacity = 0.0;
  final List<FighterJet> _pakistanJets = [];
  final List<FighterJet> _indianJets = [];
  final List<LaserBeam> _laserBeams = [];
  int _downingCount = 0;
  bool _isVictory = false;
  late AnimationController _victoryController;

  @override
  void initState() {
    super.initState();
    
    _buttonPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _flagWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _explosionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _victoryController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    // Start radar animation
    Future.delayed(const Duration(seconds: 1), () {
      _pulseAlert();
    });

    _startBattleSequence();
  }
  
  void _pulseAlert() {
    setState(() {
      _alertOpacity = 1.0;
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _alertOpacity = 0.0;
        });
        
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _pulseAlert();
          }
        });
      }
    });
  }
  
  void _startRetaliation() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isRetaliationStarted = true;
    });
    
    // Add missiles at random intervals
    _missileTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _missiles.add(Missile(
            startX: _random.nextDouble() * MediaQuery.of(context).size.width,
            endX: _random.nextDouble() * MediaQuery.of(context).size.width,
          ));
        });
      }
    });
    
    // Add explosions at random intervals
    _explosionTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        _createExplosion();
        HapticFeedback.mediumImpact();
      }
    });
  }
  
  void _createExplosion({double? x, double? y, List<Color>? colors}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final centerX = x ?? _random.nextDouble() * screenWidth;
    final centerY = y ?? _random.nextDouble() * screenHeight * 0.6 + 100;
    
    setState(() {
      for (int i = 0; i < 50; i++) {
        _explosionParticles.add(ExplosionParticle(
          x: centerX,
          y: centerY,
          dx: (_random.nextDouble() - 0.5) * 10,
          dy: (_random.nextDouble() - 0.5) * 10,
          color: colors != null ? colors[_random.nextInt(colors.length)] : _getExplosionColor(),
          size: _random.nextDouble() * 6 + 2,
          lifetime: _random.nextDouble() * 1.5 + 0.5,
        ));
      }
    });
  }
  
  Color _getExplosionColor() {
    final colors = [
      Colors.red.shade700,
      Colors.orange.shade800,
      Colors.orange.shade500,
      Colors.yellow.shade600,
      Colors.amber.shade700,
    ];
    return colors[_random.nextInt(colors.length)];
  }
  
  void _updateParticles() {
    setState(() {
      // Update explosions
      for (int i = _explosionParticles.length - 1; i >= 0; i--) {
        final particle = _explosionParticles[i];
        particle.update();
        if (particle.isDead) {
          _explosionParticles.removeAt(i);
        }
      }
      
      // Update missiles
      for (int i = _missiles.length - 1; i >= 0; i--) {
        final missile = _missiles[i];
        missile.update();
        if (missile.isDone) {
          _missiles.removeAt(i);
          _createExplosion();
        }
      }
    });
  }

  @override
  void dispose() {
    _buttonPulseController.dispose();
    _flagWaveController.dispose();
    _explosionController.dispose();
    _victoryController.dispose();
    _missileTimer?.cancel();
    _explosionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateParticles());
    
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade900,
                  Colors.black87,
                  Colors.black,
                ],
              ),
            ),
          ),
          
          // Radar Grid
          CustomPaint(
            painter: RadarGridPainter(),
            size: Size.infinite,
          ),
          
          // Alert Overlay
          AnimatedOpacity(
            opacity: _alertOpacity,
            duration: const Duration(milliseconds: 100),
            child: Container(
              color: Colors.red.withOpacity(0.15),
            ),
          ),
          
          // Top UI - Border Alert
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 105,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red.shade800,
                    Colors.red.shade900.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                      const SizedBox(width: 10),
                      Text(
                        "BORDER ALERT",
                        style: TextStyle(
                          color: Colors.amber.shade300,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Flags at the top
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedBuilder(
                  animation: _flagWaveController,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(0.05 * math.sin(_flagWaveController.value * math.pi * 2)),
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: IndiaFlagPainter(),
                        size: const Size(80, 50),
                      ),
                    );
                  },
                ),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey.shade700,
                ),
                AnimatedBuilder(
                  animation: _flagWaveController,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(0.05 * math.sin((_flagWaveController.value + 0.5) * math.pi * 2)),
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: PakistanFlagPainter(),
                        size: const Size(80, 50),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Battle status
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    _isRetaliationStarted ? "RETALIATION IN PROGRESS" : "THREAT DETECTED",
                    style: TextStyle(
                      color: _isRetaliationStarted ? Colors.red.shade400 : Colors.amber.shade400,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusItem("ALERT LEVEL", "CRITICAL", Colors.red),
                      _buildStatusItem("TARGETS", _isRetaliationStarted ? "ENGAGED" : "SCANNING", 
                        _isRetaliationStarted ? Colors.red : Colors.amber),
                      _buildStatusItem("SYSTEM", "ONLINE", Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Missiles
          ..._missiles.map((missile) => missile.build()),
          
          // Explosion particles
          ..._explosionParticles.map((particle) => Positioned(
            left: particle.x,
            top: particle.y,
            child: Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                color: particle.color,
                shape: BoxShape.circle,
              ),
            ),
          )),
          
          // Pakistani fighter jets
          ..._pakistanJets.map((jet) => jet.build()),
          
          // Indian fighter jets
          ..._indianJets.map((jet) => jet.build()),
          
          // Laser beams
          ..._laserBeams.map((beam) => beam.build()),
          
          // Bottom action button
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: _isRetaliationStarted
                  ? Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.warning_rounded, color: Colors.white, size: 30),
                          const SizedBox(height: 10),
                          const Text(
                            "RETALIATION ACTIVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "All systems engaged",
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: _startRetaliation,
                      child: AnimatedBuilder(
                        animation: _buttonPulseController,
                        builder: (context, child) {
                          return Container(
                            width: 280,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade800,
                                  Colors.red.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3 + 0.3 * _buttonPulseController.value),
                                  spreadRadius: 1 + 3 * _buttonPulseController.value,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.radar,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "START RETALIATION",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          
          // Bottom border design
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.grey.shade900,
                    Colors.grey.shade900.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _startBattleSequence() {
    // Add Pakistani F-16s
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_downingCount >= 6) {
        timer.cancel();
        _showVictorySequence();
        return;
      }
      
      if (mounted) {
        setState(() {
          _pakistanJets.add(FighterJet(
            startX: -50,
            y: 200 + _random.nextDouble() * 200,
            isPakistani: true,
          ));
        });
      }
    });

    // Add Indian jets to be targeted
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_downingCount >= 6) {
        timer.cancel();
        return;
      }
      
      if (mounted) {
        setState(() {
          _indianJets.add(FighterJet(
            startX: MediaQuery.of(context).size.width + 50,
            y: 150 + _random.nextDouble() * 300,
            isPakistani: false,
          ));
        });
      }
    });
  }

  void _showVictorySequence() {
    setState(() => _isVictory = true);
    _victoryController.forward();
    // Create victory explosions
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted || _victoryController.value >= 1) {
        timer.cancel();
        return;
      }
      _createVictoryExplosion();
    });
  }

  void _createVictoryExplosion() {
    final size = MediaQuery.of(context).size;
    _createExplosion(
      x: _random.nextDouble() * size.width,
      y: _random.nextDouble() * size.height * 0.7,
      colors: [
        Colors.green.shade400,
        Colors.green.shade600,
        Colors.white,
      ],
    );
  }
}

class RadarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade900.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final gridSize = 40.0;
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw radar circles
    final centerX = size.width / 2;
    final centerY = size.height * 0.6;
    
    final circlePaint = Paint()
      ..color = Colors.green.shade700.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        i * 80.0,
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IndiaFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final stripHeight = height / 3;
    
    // Orange strip
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, stripHeight),
      Paint()..color = const Color(0xFFFF9933),
    );
    
    // White strip
    canvas.drawRect(
      Rect.fromLTWH(0, stripHeight, width, stripHeight),
      Paint()..color = Colors.white,
    );
    
    // Green strip
    canvas.drawRect(
      Rect.fromLTWH(0, stripHeight * 2, width, stripHeight),
      Paint()..color = const Color(0xFF138808),
    );
    
    // Ashoka Chakra
    final centerX = width / 2;
    final centerY = height / 2;
    final radius = height / 6;
    
    final circlePaint = Paint()
      ..color = const Color(0xFF000080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      circlePaint,
    );
    
    // Draw spokes
    final spokePaint = Paint()
      ..color = const Color(0xFF000080)
      ..strokeWidth = 1.0;
    
    for (int i = 0; i < 24; i++) {
      final angle = i * 15 * math.pi / 180;
      canvas.drawLine(
        Offset(
          centerX + radius * 0.6 * math.cos(angle),
          centerY + radius * 0.6 * math.sin(angle),
        ),
        Offset(
          centerX + radius * 0.9 * math.cos(angle),
          centerY + radius * 0.9 * math.sin(angle),
        ),
        spokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PakistanFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Green background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = const Color(0xFF01411C),
    );
    
    // White strip
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width * 0.25, height),
      Paint()..color = Colors.white,
    );
    
    // Crescent
    final centerX = width * 0.6;
    final centerY = height * 0.5;
    final outerRadius = height * 0.35;
    final innerRadius = height * 0.28;
    
    final crescentPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Draw outer circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      outerRadius,
      crescentPaint,
    );
    
    // Draw inner circle (offset to create crescent)
    canvas.drawCircle(
      Offset(centerX + outerRadius * 0.2, centerY),
      innerRadius,
      Paint()..color = const Color(0xFF01411C),
    );
    
    // Draw star
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final starCenterX = centerX + outerRadius * 0.2;
    final starCenterY = centerY - outerRadius * 0.5;
    final starRadius = height * 0.08;
    
    final points = <Offset>[];
    for (int i = 0; i < 5; i++) {
      final outerAngle = -math.pi / 2 + i * 2 * math.pi / 5;
      final innerAngle = outerAngle + math.pi / 5;
      
      points.add(Offset(
        starCenterX + starRadius * math.cos(outerAngle),
        starCenterY + starRadius * math.sin(outerAngle),
      ));
      
      points.add(Offset(
        starCenterX + starRadius * 0.4 * math.cos(innerAngle),
        starCenterY + starRadius * 0.4 * math.sin(innerAngle),
      ));
    }
    
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ExplosionParticle {
  double x;
  double y;
  double dx;
  double dy;
  Color color;
  double size;
  double lifetime;
  double age = 0;
  
  ExplosionParticle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.color,
    required this.size,
    required this.lifetime,
  });
  
  bool get isDead => age >= lifetime;
  
  void update() {
    x += dx;
    y += dy;
    dx *= 0.98;
    dy *= 0.98;
    age += 0.016; // Approximate for 60fps
    size *= 0.97;
  }
}

class Missile {
  final double startX;
  final double endX;
  double progress = 0.0;
  final double speed = 0.02;
  bool isDone = false;
  
  Missile({required this.startX, required this.endX});
  
  void update() {
    progress += speed;
    if (progress >= 1.0) {
      isDone = true;
    }
  }
  
  Widget build() {
    final currentX = startX + (endX - startX) * progress;
    final currentY = 180 + (600 - 180) * progress;
    
    return Positioned(
      left: currentX - 2,
      top: currentY - 10,
      child: Transform.rotate(
        angle: math.atan2((600 - 180), (endX - startX)),
        child: Container(
          width: 4,
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.amber.shade400,
                Colors.red.shade700,
              ],
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.8),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FighterJet {
  final double startX;
  final double y;
  final bool isPakistani;
  double progress = 0.0;
  final double speed = 0.01;
  bool isDone = false;
  
  FighterJet({required this.startX, required this.y, required this.isPakistani});
  
  void update() {
    progress += speed;
    if (progress >= 1.0) {
      isDone = true;
    }
  }
  
  Widget build() {
    final currentX = startX + (isPakistani ? 1 : -1) * progress * 1000;
    
    return Positioned(
      left: currentX - 20,
      top: y - 10,
      child: Transform.rotate(
        angle: isPakistani ? 0 : math.pi,
        child: Icon(
          Icons.airplanemode_active,
          color: isPakistani ? Colors.green : Colors.orange,
          size: 40,
        ),
      ),
    );
  }
}

class LaserBeam {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  double progress = 0.0;
  final double speed = 0.05;
  bool isDone = false;
  
  LaserBeam({required this.startX, required this.startY, required this.endX, required this.endY});
  
  void update() {
    progress += speed;
    if (progress >= 1.0) {
      isDone = true;
    }
  }
  
  Widget build() {
    final currentX = startX + (endX - startX) * progress;
    final currentY = startY + (endY - startY) * progress;
    
    return Positioned(
      left: currentX - 2,
      top: currentY - 2,
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}