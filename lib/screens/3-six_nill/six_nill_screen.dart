import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SixNillScreen extends StatefulWidget {
  const SixNillScreen({Key? key}) : super(key: key);

  @override
  State<SixNillScreen> createState() => _SixNillScreenState();
}

class _SixNillScreenState extends State<SixNillScreen> with TickerProviderStateMixin {
  // Aircraft image paths
  final String jf17 = "assets/images/six_nill/jf17.png";
  final String rafale = "assets/images/six_nill/rafale.png";
  
  // Animation controllers
  late AnimationController _skyController;
  late AnimationController _cloudController;
  late AnimationController _mainJetController;
  late AnimationController _explosionsController;
  late AnimationController _hudController;
  late AnimationController _victoryController;
  late AnimationController _radarController;
  
  // Aircraft controllers
  List<EnemyAircraft> enemyAircrafts = [];
  final int totalEnemyAircrafts = 6;
  
  // UI State
  bool _showVictory = false;
  double _flagOpacity = 0.0;
  double _victoryTextOpacity = 0.0;
  bool _sceneCompleted = false;
  
  // Particles
  final List<Particle> _particles = [];
  final int _particleCount = 300;
  
  // Loaded image assets
  ui.Image? jf17Image;
  ui.Image? rafaleImage;
  
  @override
  void initState() {
    super.initState();
    
    // Load images
    _loadImages();
    
    // Initialize animation controllers
    _skyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
    
    _mainJetController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    
    _explosionsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    
    _hudController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _victoryController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    // Initialize enemy aircrafts
    _initializeEnemyAircrafts();
    
    // Generate particles
    _generateParticles();
    
    // Start animation sequence
    _startAnimationSequence();
  }
  
  void _loadImages() async {
    jf17Image = await _loadImage(jf17);
    rafaleImage = await _loadImage(rafale);
    setState(() {});
  }
  
  Future<ui.Image> _loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }
  
  void _initializeEnemyAircrafts() {
    final random = math.Random();
    
    // Create 6 enemy aircrafts with different positions and states
    for (int i = 0; i < totalEnemyAircrafts; i++) {
      final posX = random.nextDouble() * 0.8 + 0.1; // between 0.1 and 0.9
      final posY = random.nextDouble() * 0.3 + 0.1; // between 0.1 and 0.4
      final size = random.nextDouble() * 0.1 + 0.15; // between 0.15 and 0.25
      final rotateSpeed = random.nextDouble() * 0.05 + 0.02;
      final fallSpeed = random.nextDouble() * 0.02 + 0.01;
      final fallDelay = random.nextDouble() * 5.0;
      
      enemyAircrafts.add(EnemyAircraft(
        initialX: posX,
        initialY: posY,
        size: size,
        rotateSpeed: rotateSpeed,
        fallSpeed: fallSpeed,
        fallDelay: fallDelay,
        exploding: false,
        rotation: 0.0,
      ));
    }
  }
  
  void _generateParticles() {
    final random = math.Random();
    
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 1,
        speedX: (random.nextDouble() - 0.5) * 0.01,
        speedY: (random.nextDouble() - 0.5) * 0.01,
        color: Colors.white.withOpacity(random.nextDouble() * 0.7 + 0.3),
      ));
    }
  }
  
  void _startAnimationSequence() {
    // Start main animations
    _mainJetController.forward();
    
    // Start explosion animations after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _explosionsController.forward();
      
      // Start enemy aircraft explosions sequentially
      for (int i = 0; i < enemyAircrafts.length; i++) {
        Future.delayed(Duration(milliseconds: 500 * i), () {
          if (mounted) {
            setState(() {
              enemyAircrafts[i].exploding = true;
            });
          }
        });
      }
    });
    
    // Show victory scene after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _showVictory = true;
        });
        _victoryController.forward();
        
        // Animate flag opacity with proper bounds checking
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          setState(() {
            if (_flagOpacity < 0.95) {
              _flagOpacity = math.min(1.0, _flagOpacity + 0.05);
            } else {
              _flagOpacity = 1.0;
              timer.cancel();
              
              // Animate victory text after flag is visible
              Timer.periodic(const Duration(milliseconds: 50), (textTimer) {
                if (!mounted) {
                  textTimer.cancel();
                  return;
                }
                setState(() {
                  if (_victoryTextOpacity < 0.95) {
                    _victoryTextOpacity = math.min(1.0, _victoryTextOpacity + 0.05);
                  } else {
                    _victoryTextOpacity = 1.0;
                    textTimer.cancel();
                    _sceneCompleted = true;
                  }
                });
              });
            }
          });
        });
      }
    });
  }
  
  @override
  void dispose() {
    _skyController.dispose();
    _cloudController.dispose();
    _mainJetController.dispose();
    _explosionsController.dispose();
    _hudController.dispose();
    _victoryController.dispose();
    _radarController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background sky
          AnimatedBuilder(
            animation: _skyController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: SkyPainter(
                  animationValue: _skyController.value,
                ),
              );
            },
          ),
          
          // Stars/particles
          CustomPaint(
            size: size,
            painter: ParticlePainter(particles: _particles),
            foregroundPainter: CloudPainter(
              animationValue: _cloudController.value,
            ),
          ),
          
          // Combat scene with enemy aircrafts
          AnimatedBuilder(
            animation: Listenable.merge([
              _explosionsController,
              _mainJetController,
            ]),
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: CombatScenePainter(
                  enemyAircrafts: enemyAircrafts,
                  mainJetProgress: _mainJetController.value,
                  explosionProgress: _explosionsController.value,
                  jf17Image: jf17Image,
                  rafaleImage: rafaleImage,
                ),
              );
            },
          ),
          
          // HUD elements
          AnimatedBuilder(
            animation: _hudController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: HUDPainter(
                  pulseValue: _hudController.value,
                  radarValue: _radarController.value,
                ),
              );
            },
          ),
          
          // Tactical data displays
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                border: Border.all(
                  color: Colors.green.withOpacity(0.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedBuilder(
                animation: _hudController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: TacticalDataPainter(
                      pulseValue: _hudController.value,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Missile lock indicators
          AnimatedBuilder(
            animation: _mainJetController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: MissileLockPainter(
                  progress: _mainJetController.value,
                  enemyAircrafts: enemyAircrafts,
                ),
              );
            },
          ),
          
          // Victory overlay
          if (_showVictory)
            AnimatedBuilder(
              animation: _victoryController,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Pakistan flag background with animated opacity
                    Opacity(
                      opacity: _flagOpacity,
                      child: CustomPaint(
                        size: size,
                        painter: PakistanFlagPainter(),
                      ),
                    ),
                    
                    // Victory text with animated opacity
                    Opacity(
                      opacity: _victoryTextOpacity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 400),
                            Text(
                              "VICTORY",
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 15,
                                    color: Colors.green.withOpacity(0.8),
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "6",
                                  style: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15,
                                        color: Colors.white.withOpacity(0.8),
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  " : ",
                                  style: TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15,
                                        color: Colors.green.withOpacity(0.8),
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "NIL",
                                  style: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15,
                                        color: Colors.white.withOpacity(0.8),
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Particle effects for victory scene
                    if (_sceneCompleted)
                      CustomPaint(
                        size: size,
                        painter: VictoryParticlePainter(
                          progress: _victoryController.value,
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

// Models and Painters

class EnemyAircraft {
  final double initialX;
  final double initialY;
  final double size;
  final double rotateSpeed;
  final double fallSpeed;
  final double fallDelay;
  bool exploding;
  double rotation;
  
  EnemyAircraft({
    required this.initialX,
    required this.initialY,
    required this.size,
    required this.rotateSpeed,
    required this.fallSpeed,
    required this.fallDelay,
    required this.exploding,
    required this.rotation,
  });
  
  void update(double progress) {
    // Update rotation and fall
    if (progress > fallDelay / 10) {
      rotation += rotateSpeed;
    }
  }
  
  double getX(double progress) {
    return initialX;
  }
  
  double getY(double progress) {
    if (progress < fallDelay / 10) {
      return initialY;
    }
    return initialY + (progress - fallDelay / 10) * fallSpeed * 10;
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final Color color;
  
  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.color,
  });
  
  void update() {
    x += speedX;
    y += speedY;
    
    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class SkyPainter extends CustomPainter {
  final double animationValue;
  
  SkyPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    // Create a dark and dramatic sky gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF000428),
        const Color(0xFF000F3B),
        const Color(0xFF001F4B),
      ],
      stops: const [0.0, 0.4, 1.0],
    );
    
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
    
    // Add dynamic atmospheric effects
    final shimmerPaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 5; i++) {
      final offset = math.sin(animationValue * math.pi * 2 + i) * 50;
      final rect = Rect.fromLTWH(
        offset,
        i * 100.0,
        size.width - offset * 2,
        70,
      );
      canvas.drawRect(rect, shimmerPaint);
    }
  }
  
  @override
  bool shouldRepaint(SkyPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class CloudPainter extends CustomPainter {
  final double animationValue;
  
  CloudPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    // Draw several clouds moving across screen
    for (int i = 0; i < 8; i++) {
      final cloudProgress = (animationValue + i / 8) % 1.0;
      final xPos = size.width * cloudProgress - size.width * 0.2;
      
      final path = Path();
      final cloudY = size.height * (0.2 + i * 0.1);
      final cloudWidth = size.width * 0.3;
      final cloudHeight = size.height * 0.05;
      
      path.addOval(Rect.fromCenter(
        center: Offset(xPos, cloudY),
        width: cloudWidth,
        height: cloudHeight,
      ));
      
      path.addOval(Rect.fromCenter(
        center: Offset(xPos + cloudWidth * 0.2, cloudY - cloudHeight * 0.2),
        width: cloudWidth * 0.6,
        height: cloudHeight * 0.8,
      ));
      
      path.addOval(Rect.fromCenter(
        center: Offset(xPos - cloudWidth * 0.2, cloudY + cloudHeight * 0.1),
        width: cloudWidth * 0.7,
        height: cloudHeight * 0.9,
      ));
      
      canvas.drawPath(path, cloudPaint);
    }
    
    // Add smoke and battle haze
    for (int i = 0; i < 5; i++) {
      final smokeProgress = (animationValue * 0.5 + i / 5) % 1.0;
      final xPos = size.width * smokeProgress;
      final yPos = size.height * (0.4 + i * 0.1);
      
      final smokePaint = Paint()
        ..color = Colors.grey.withOpacity(0.07)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      
      canvas.drawCircle(
        Offset(xPos, yPos),
        size.width * 0.15,
        smokePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(CloudPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  
  ParticlePainter({required this.particles});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
      
      // Update particle position for next frame
      particle.update();
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class CombatScenePainter extends CustomPainter {
  final List<EnemyAircraft> enemyAircrafts;
  final double mainJetProgress;
  final double explosionProgress;
  final ui.Image? jf17Image;
  final ui.Image? rafaleImage;
  
  CombatScenePainter({
    required this.enemyAircrafts,
    required this.mainJetProgress,
    required this.explosionProgress,
    required this.jf17Image,
    required this.rafaleImage,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Update enemy aircraft positions
    for (final aircraft in enemyAircrafts) {
      aircraft.update(explosionProgress);
    }
    
    // Draw enemy aircrafts (IAF jets)
    if (rafaleImage != null) {
      for (int i = 0; i < enemyAircrafts.length; i++) {
        final aircraft = enemyAircrafts[i];
        final x = aircraft.getX(explosionProgress) * size.width;
        final y = aircraft.getY(explosionProgress) * size.height;
        final jetSize = size.width * aircraft.size;
        
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(aircraft.rotation);
        
        // Draw smoke trail for falling aircraft
        if (aircraft.exploding) {
          final smokePaint = Paint()
            ..color = Colors.grey.withOpacity(0.7)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
          
          final firePaint = Paint()
            ..color = Colors.orange.withOpacity(0.8)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
          
          final random = math.Random(i);
          
          for (int j = 0; j < 8; j++) {
            final smokeOffset = Offset(
              random.nextDouble() * 20 - 10,
              random.nextDouble() * 20 - 10 + j * 10,
            );
            
            canvas.drawCircle(
              smokeOffset,
              jetSize * 0.3 * (1 - j / 10),
              smokePaint,
            );
            
            if (j < 3) {
              canvas.drawCircle(
                smokeOffset,
                jetSize * 0.15 * (1 - j / 5),
                firePaint,
              );
            }
          }
        }
        
        // Draw enemy aircraft
        final enemyPaint = Paint();
        canvas.drawImageRect(
          rafaleImage!,
          Rect.fromLTWH(0, 0, rafaleImage!.width.toDouble(), 
                         rafaleImage!.height.toDouble()),
          Rect.fromCenter(
            center: Offset.zero,
            width: jetSize,
            height: jetSize * 0.6,
          ),
          enemyPaint,
        );
        
        // Add explosion effects
        if (aircraft.exploding) {
          final explosionPaint = Paint()
            ..color = Colors.orange.withOpacity(0.9)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
          
          canvas.drawCircle(
            Offset.zero,
            jetSize * 0.4 * math.sin(explosionProgress * math.pi),
            explosionPaint,
          );
          
          final outerExplosionPaint = Paint()
            ..color = Colors.red.withOpacity(0.7)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
          
          canvas.drawCircle(
            Offset.zero,
            jetSize * 0.6 * math.sin(explosionProgress * math.pi * 0.8),
            outerExplosionPaint,
          );
        }
        
        canvas.restore();
      }
    }
    
    // Draw main PAF JF-17 Thunder jet
    if (jf17Image != null) {
      // Calculate jet path
      final startY = size.height * 0.8;
      final endY = size.height * 0.3;
      final startX = size.width * 0.2;
      final endX = size.width * 0.8;
      
      final curveProgress = Curves.easeInOut.transform(mainJetProgress);
      final x = startX + (endX - startX) * curveProgress;
      final y = startY - (startY - endY) * curveProgress;
      
      // Draw glowing trail
      final trailPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      
      final pathPoints = <Offset>[];
      for (int i = 10; i >= 0; i--) {
        final trailProgress = math.max(0.0, curveProgress - i * 0.01);
        final trailX = startX + (endX - startX) * trailProgress;
        final trailY = startY - (startY - endY) * trailProgress;
        pathPoints.add(Offset(trailX, trailY));
      }
      
      final trail = Path()..addPolygon(pathPoints, false);
      
      // Draw green and white trail (Pakistan colors)
      final greenGradient = ui.Gradient.linear(
        Offset(x - 100, y),
        Offset(x, y),
        [
          Colors.green.withOpacity(0),
          Colors.green.withOpacity(0.8),
        ],
      );
      
      trailPaint.shader = greenGradient;
      canvas.drawPath(trail, trailPaint);
      
      final whiteGradient = ui.Gradient.linear(
        Offset(x - 60, y),
        Offset(x, y),
        [
          Colors.white.withOpacity(0),
          Colors.white.withOpacity(0.9),
        ],
      );
      
      trailPaint.shader = whiteGradient;
      trailPaint.strokeWidth = 5;
      canvas.drawPath(trail, trailPaint);
      
      // Draw the JF-17 jet
      final jetSize = size.width * 0.35; // Increased from 0.25 to 0.35
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(math.pi * 0.1); // Slight upward angle
      
      final jetPaint = Paint();
      canvas.drawImageRect(
        jf17Image!,
        Rect.fromLTWH(0, 0, jf17Image!.width.toDouble(), 
                      jf17Image!.height.toDouble()),
        Rect.fromCenter(
          center: Offset.zero,
          width: jetSize,
          height: jetSize * 0.5, // Adjusted ratio for better proportions
        ),
        jetPaint,
      );
      
      // Adjust engine glow/afterburner accordingly
      final glowPaint = Paint()
        ..color = Colors.orange.withOpacity(0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20); // Increased blur
      
      canvas.drawCircle(
        Offset(-jetSize * 0.4, 0),
        jetSize * 0.2, // Increased glow size to match larger jet
        glowPaint,
      );
      
      canvas.restore();
    }
  }
  
  @override
  bool shouldRepaint(CombatScenePainter oldDelegate) {
    return oldDelegate.mainJetProgress != mainJetProgress ||
           oldDelegate.explosionProgress != explosionProgress;
  }
}

class HUDPainter extends CustomPainter {
  final double pulseValue;
  final double radarValue;
  
  HUDPainter({
    required this.pulseValue,
    required this.radarValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Draw HUD frame
    final hudPaint = Paint()
      ..color = Colors.green.withOpacity(0.6 + pulseValue * 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Draw crosshair
    final crosshairPaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Center crosshair
    canvas.drawLine(
      Offset(size.width / 2 - 30, size.height / 2),
      Offset(size.width / 2 + 30, size.height / 2),
      crosshairPaint,
    );
    
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - 30),
      Offset(size.width / 2, size.height / 2 + 30),
      crosshairPaint,
    );
    
    // Draw circular targeting elements
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50 + pulseValue * 10,
      crosshairPaint,
    );
    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      80 + pulseValue * 20,
      crosshairPaint..strokeWidth = 1,
    );
    
    // Draw angle indicators
    final angleWidth = size.width * 0.7;
    final angleHeight = size.height * 0.6;
    final angleRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: angleWidth,
      height: angleHeight,
    );
    
    final anglePath = Path()
      ..moveTo(size.width / 2 - angleWidth / 2, size.height / 2)
      ..lineTo(size.width / 2 - angleWidth / 2 + 20, size.height / 2 - 10)
      ..lineTo(size.width / 2 - angleWidth / 2 + 40, size.height / 2)
      ..moveTo(size.width / 2 + angleWidth / 2, size.height / 2)
      ..lineTo(size.width / 2 + angleWidth / 2 - 20, size.height / 2 - 10)
      ..lineTo(size.width / 2 + angleWidth / 2 - 40, size.height / 2);
    
    canvas.drawPath(anglePath, hudPaint);
    
    // Draw horizon line
    final horizonPaint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.5),
      horizonPaint,
    );
    
    // Draw altitude and speed bars
    final barPaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Left bar (speed)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.05,
        size.height * 0.3,
        15,
        size.height * 0.4,
      ),
      barPaint,
    );
    
    // Speed indicator
    final speedY = size.height * 0.7 - pulseValue * size.height * 0.2;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.05 - 5,
        speedY - 10,
        25,
        20,
      ),
      Paint()
        ..color = Colors.green.withOpacity(0.8)
        ..style = PaintingStyle.fill,
    );
    
    // Speed text
    final speedTextPainter = TextPainter(
      text: TextSpan(
        text: "${(900 + pulseValue * 100).toInt()} KTS",
        style: TextStyle(
          color: Colors.green.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    speedTextPainter.layout();
    speedTextPainter.paint(
      canvas,
      Offset(size.width * 0.05 + 20, speedY - 6),
    );
    
    // Right bar (altitude)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.95 - 15,
        size.height * 0.3,
        15,
        size.height * 0.4,
      ),
      barPaint,
    );
    
    // Altitude indicator
    final altY = size.height * 0.7 - (1 - pulseValue) * size.height * 0.25;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.95 - 20,
        altY - 10,
        25,
        20,
      ),
      Paint()
        ..color = Colors.green.withOpacity(0.8)
        ..style = PaintingStyle.fill,
    );
    
    // Altitude text
    final altTextPainter = TextPainter(
      text: TextSpan(
        text: "${(25000 - pulseValue * 3000).toInt()} FT",
        style: TextStyle(
          color: Colors.green.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    
    altTextPainter.layout();
    altTextPainter.paint(
      canvas,
      Offset(size.width * 0.95 - 60, altY - 6),
    );
    
    // Draw radar sweep
    final radarCenterX = size.width * 0.9;
    final radarCenterY = size.height * 0.85;
    final radarRadius = size.width * 0.08;
    
    // Draw radar background
    final radarBgPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(radarCenterX, radarCenterY),
      radarRadius,
      radarBgPaint,
    );
    
    // Draw radar grid
    final radarGridPaint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawCircle(
      Offset(radarCenterX, radarCenterY),
      radarRadius,
      radarGridPaint,
    );
    
    canvas.drawCircle(
      Offset(radarCenterX, radarCenterY),
      radarRadius * 0.7,
      radarGridPaint,
    );
    
    canvas.drawCircle(
      Offset(radarCenterX, radarCenterY),
      radarRadius * 0.4,
      radarGridPaint,
    );
    
    canvas.drawLine(
      Offset(radarCenterX - radarRadius, radarCenterY),
      Offset(radarCenterX + radarRadius, radarCenterY),
      radarGridPaint,
    );
    
    canvas.drawLine(
      Offset(radarCenterX, radarCenterY - radarRadius),
      Offset(radarCenterX, radarCenterY + radarRadius),
      radarGridPaint,
    );
    
    // Draw radar sweep
    final sweepPaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final sweepAngle = 2 * math.pi * radarValue;
    final sweepPath = Path()
      ..moveTo(radarCenterX, radarCenterY)
      ..lineTo(
        radarCenterX + radarRadius * math.cos(sweepAngle),
        radarCenterY + radarRadius * math.sin(sweepAngle),
      )
      ..arcTo(
        Rect.fromCircle(
          center: Offset(radarCenterX, radarCenterY),
          radius: radarRadius,
        ),
        sweepAngle,
        math.pi / 8,
        false,
      )
      ..lineTo(radarCenterX, radarCenterY);
    
    canvas.drawPath(sweepPath, sweepPaint);
    
    // Draw blips on radar (representing enemy and friendly aircraft)
    final blipPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    final friendlyBlipPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    
    // Enemy blips
    for (int i = 0; i < 6; i++) {
      final angle = math.pi / 4 + i * math.pi / 10;
      final distance = radarRadius * (0.5 + i * 0.08);
      
      final blipX = radarCenterX + distance * math.cos(angle);
      final blipY = radarCenterY + distance * math.sin(angle);
      
      // Make blips blink when in the radar sweep
      final blipAngleDiff = (angle - sweepAngle).abs() % (2 * math.pi);
      if (blipAngleDiff < 0.3 || blipAngleDiff > 2 * math.pi - 0.3) {
        canvas.drawCircle(
          Offset(blipX, blipY),
          3,
          blipPaint,
        );
      } else if (angle < sweepAngle || angle > sweepAngle - 0.5) {
        canvas.drawCircle(
          Offset(blipX, blipY),
          2,
          blipPaint..color = Colors.red.withOpacity(0.5),
        );
      }
    }
    
    // Friendly blip (our aircraft)
    canvas.drawCircle(
      Offset(radarCenterX, radarCenterY - radarRadius * 0.2),
      4,
      friendlyBlipPaint,
    );
    
    // Status indicators at the bottom
    final statusWidth = size.width * 0.6;
    final statusY = size.height * 0.95;
    
    final statusPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawLine(
      Offset(size.width / 2 - statusWidth / 2, statusY),
      Offset(size.width / 2 + statusWidth / 2, statusY),
      statusPaint,
    );
    
    // Status text
    final statusTextPainter = TextPainter(
      text: TextSpan(
        text: "ALL SYSTEMS OPERATIONAL - MISSILES READY - TARGET ACQUIRED",
        style: TextStyle(
          color: Colors.green.withOpacity(0.8 + pulseValue * 0.2),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    statusTextPainter.layout(maxWidth: statusWidth);
    statusTextPainter.paint(
      canvas,
      Offset(size.width / 2 - statusWidth / 2, statusY - 20),
    );
  }
  
  @override
  bool shouldRepaint(HUDPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
           oldDelegate.radarValue != radarValue;
  }
}

class TacticalDataPainter extends CustomPainter {
  final double pulseValue;
  
  TacticalDataPainter({required this.pulseValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    // Draw tactical data frame
    final framePaint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawRect(
      Rect.fromLTWH(5, 5, size.width - 10, size.height - 10),
      framePaint,
    );
    
    // Draw internal dividers
    canvas.drawLine(
      Offset(5, size.height * 0.4),
      Offset(size.width - 5, size.height * 0.4),
      framePaint,
    );
    
    canvas.drawLine(
      Offset(size.width * 0.5, 5),
      Offset(size.width * 0.5, size.height * 0.4),
      framePaint,
    );
    
    // Draw tactical data titles
    final titleTextPainter = TextPainter(
      text: TextSpan(
        text: "",
        style: TextStyle(
          color: Colors.green.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    titleTextPainter.layout();
    titleTextPainter.paint(canvas, const Offset(10, 10));
    
    final subtitle1TextPainter = TextPainter(
      text: TextSpan(
        text: "TARGET ANALYSIS",
        style: TextStyle(
          color: Colors.green.withOpacity(0.9),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    subtitle1TextPainter.layout();
    subtitle1TextPainter.paint(canvas, Offset(size.width * 0.5 + 5, 10));
    
    // Draw simulated data
    final dataPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "MISSILES: ",
            style: TextStyle(
              color: Colors.green.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
          TextSpan(
            text: "ARMED",
            style: TextStyle(
              color: Colors.red.withOpacity(0.8 + pulseValue * 0.2),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    
    dataPainter.layout();
    dataPainter.paint(canvas, const Offset(10, 30));
    
    final data2Painter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "TARGETS: ",
            style: TextStyle(
              color: Colors.green.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
          TextSpan(
            text: "",
            style: TextStyle(
              color: Colors.green.withOpacity(0.8 + pulseValue * 0.2),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    
    data2Painter.layout();
    data2Painter.paint(canvas, const Offset(10, 45));
    
    final data3Painter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "STATUS: ",
            style: TextStyle(
              color: Colors.green.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
          TextSpan(
            text: "",
            style: TextStyle(
              color: Colors.orange.withOpacity(0.8 + pulseValue * 0.2),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    
    data3Painter.layout();
    data3Painter.paint(canvas, const Offset(10, 60));
    
    // Target analysis data
    final targetDataPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "RAFALE JETS\n",
            style: TextStyle(
              color: Colors.red.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: "DISTANCE: 2.5KM\nALTITUDE: 24,000FT\nSPEED: 850KTS",
            style: TextStyle(
              color: Colors.green.withOpacity(0.8),
              fontSize: 9,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    
    targetDataPainter.layout();
    targetDataPainter.paint(canvas, Offset(size.width * 0.5 + 5, 30));
    
    // Draw battle statistics
    final statTitlePainter = TextPainter(
      text: TextSpan(
        // text: "COMBAT STATISTICS",
        text: "",
        style: TextStyle(
          color: Colors.green.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    statTitlePainter.layout();
    statTitlePainter.paint(canvas, Offset(10, size.height * 1.0 + 10));
    
    // Draw pulsing score
    final scorePainter = TextPainter(
      text: TextSpan(
        text: "PAF 6 - 0 IAF",
        style: TextStyle(
          color: Colors.green.withOpacity(0.8 + pulseValue * 0.2),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    scorePainter.layout();
    scorePainter.paint(
      canvas,
      Offset(size.width / 2 - scorePainter.width / 2, size.height * 0.7),
    );
    
    // Draw animated wave display (audio-wave style)
    final wavePaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final wavePath = Path();
    final waveWidth = size.width - 20;
    final waveStartY = size.height * 0.4 + 40;
    final waveHeight = 15.0;
    
    wavePath.moveTo(10, waveStartY);
    
    for (int i = 0; i < 40; i++) {
      final x = 10 + i * waveWidth / 40;
      final normalizedX = i / 40;
      final amplitude = math.sin(normalizedX * math.pi * 4 + pulseValue * math.pi * 2);
      final y = waveStartY + amplitude * waveHeight;
      
      wavePath.lineTo(x, y);
    }
    
    canvas.drawPath(wavePath, wavePaint);
  }
  
  @override
  bool shouldRepaint(TacticalDataPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue;
  }
}

class MissileLockPainter extends CustomPainter {
  final double progress;
  final List<EnemyAircraft> enemyAircrafts;
  
  MissileLockPainter({
    required this.progress,
    required this.enemyAircrafts,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.2) return; // Don't show locks initially
    
    final lockPaint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final startProgress = math.min(1.0, progress * 2);
    final targetCount = (startProgress * enemyAircrafts.length).round();
    
    for (int i = 0; i < targetCount; i++) {
      final aircraft = enemyAircrafts[i];
      final x = aircraft.getX(progress) * size.width;
      final y = aircraft.getY(progress) * size.height;
      
      // Draw rectangular targeting box
      final boxSize = size.width * aircraft.size * 1.2;
      final boxRect = Rect.fromCenter(
        center: Offset(x, y),
        width: boxSize,
        height: boxSize * 0.6,
      );
      
      // Flash the box based on pulse
      final flash = (progress * 10 + i).floor() % 2 == 0;
      
      if (flash || aircraft.exploding) {
        canvas.drawRect(boxRect, lockPaint);
        
        // Draw corner brackets
        final cornerSize = boxSize * 0.2;
        
        // Top-left corner
        canvas.drawLine(
          Offset(boxRect.left, boxRect.top + cornerSize),
          Offset(boxRect.left, boxRect.top),
          lockPaint,
        );
        
        canvas.drawLine(
          Offset(boxRect.left, boxRect.top),
          Offset(boxRect.left + cornerSize, boxRect.top),
          lockPaint,
        );
        
        // Top-right corner
        canvas.drawLine(
          Offset(boxRect.right - cornerSize, boxRect.top),
          Offset(boxRect.right, boxRect.top),
          lockPaint,
        );
        
        canvas.drawLine(
          Offset(boxRect.right, boxRect.top),
          Offset(boxRect.right, boxRect.top + cornerSize),
          lockPaint,
        );
        
        // Bottom-left corner
        canvas.drawLine(
          Offset(boxRect.left, boxRect.bottom - cornerSize),
          Offset(boxRect.left, boxRect.bottom),
          lockPaint,
        );
        
        canvas.drawLine(
          Offset(boxRect.left, boxRect.bottom),
          Offset(boxRect.left + cornerSize, boxRect.bottom),
          lockPaint,
        );
        
        // Bottom-right corner
        canvas.drawLine(
          Offset(boxRect.right - cornerSize, boxRect.bottom),
          Offset(boxRect.right, boxRect.bottom),
          lockPaint,
        );
        
        canvas.drawLine(
          Offset(boxRect.right, boxRect.bottom),
          Offset(boxRect.right, boxRect.bottom - cornerSize),
          lockPaint,
        );
        
        // Draw target information for first few aircraft
        if (i < 3) {
          final infoTextPainter = TextPainter(
            text: TextSpan(
              text: "IAF-${i + 1} LOCKED",
              style: TextStyle(
                color: Colors.red.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          
          infoTextPainter.layout();
          infoTextPainter.paint(
            canvas,
            Offset(x + boxSize / 2 + 10, y - 20),
          );
          
          // Draw distance indicator
          final distanceTextPainter = TextPainter(
            text: TextSpan(
              text: "${(3 - i) * 500 + 1500}m",
              style: TextStyle(
                color: Colors.red.withOpacity(0.7),
                fontSize: 9,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          
          distanceTextPainter.layout();
          distanceTextPainter.paint(
            canvas,
            Offset(x + boxSize / 2 + 10, y - 5),
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(MissileLockPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class PakistanFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw semi-transparent overlay
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.black.withOpacity(0.7)
        ..style = PaintingStyle.fill,
    );
    
    // Draw Pakistan flag
    final flagWidth = size.width * 0.6;
    final flagHeight = flagWidth * 2 / 3; // Standard flag ratio
    final flagRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 - 50),
      width: flagWidth,
      height: flagHeight,
    );
    
    // Draw green background
    canvas.drawRect(
      flagRect,
      Paint()
        ..color = const Color(0xFF01411C)
        ..style = PaintingStyle.fill,
    );
    
    // Draw white vertical stripe
    canvas.drawRect(
      Rect.fromLTWH(
        flagRect.left,
        flagRect.top,
        flagRect.width * 0.25,
        flagRect.height,
      ),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    
    // Draw crescent
    final centerX = flagRect.left + flagRect.width * 0.65;
    final centerY = flagRect.top + flagRect.height / 2;
    final moonRadius = flagRect.height * 0.35;
    
    canvas.drawCircle(
      Offset(centerX, centerY),
      moonRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    
    canvas.drawCircle(
      Offset(centerX + moonRadius * 0.35, centerY),
      moonRadius * 0.85,
      Paint()
        ..color = const Color(0xFF01411C)
        ..style = PaintingStyle.fill,
    );
    
    // Draw star
    final starPath = Path();
    final starRadius = moonRadius * 0.4;
    final starCenter = Offset(centerX + moonRadius * 0.6, centerY - moonRadius * 0.1);
    
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / 5;
      final x = starCenter.dx + starRadius * math.cos(angle);
      final y = starCenter.dy + starRadius * math.sin(angle);
      
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
      
      final innerAngle = angle + math.pi / 5;
      final innerRadius = starRadius * 0.4;
      final innerX = starCenter.dx + innerRadius * math.cos(innerAngle);
      final innerY = starCenter.dy + innerRadius * math.sin(innerAngle);
      
      starPath.lineTo(innerX, innerY);
    }
    
    starPath.close();
    
    canvas.drawPath(
      starPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    
    // Draw glowing edge
    canvas.drawRect(
      flagRect.inflate(5),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5),
    );
  }
  
  @override
  bool shouldRepaint(PakistanFlagPainter oldDelegate) => false;
}

class VictoryParticlePainter extends CustomPainter {
  final double progress;
  final List<VictoryParticle> _particles = [];
  
  VictoryParticlePainter({required this.progress}) {
    // Generate particles only once
    if (_particles.isEmpty) {
      _generateParticles();
    }
  }
  
  void _generateParticles() {
    final random = math.Random();
    
    // Create sparks and embers
    for (int i = 0; i < 100; i++) {
      final type = random.nextDouble() > 0.7 ? ParticleType.ember : ParticleType.spark;
      final color = type == ParticleType.ember
          ? Colors.orange.withOpacity(0.7 + random.nextDouble() * 0.3)
          : Colors.white.withOpacity(0.7 + random.nextDouble() * 0.3);
      
      _particles.add(VictoryParticle(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.3 + 0.4, // Start around the victory text
        size: type == ParticleType.ember
            ? random.nextDouble() * 4 + 2
            : random.nextDouble() * 2 + 1,
        speedX: (random.nextDouble() - 0.5) * 0.01,
        speedY: -0.005 - random.nextDouble() * 0.01,
        color: color,
        type: type,
        lifespan: 0.5 + random.nextDouble() * 0.5,
        age: random.nextDouble() * 0.5,
      ));
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in _particles) {
      // Update particle position
      particle.update();
      
      // Draw particle based on its type
      if (particle.type == ParticleType.spark) {
        // Draw spark as a line
        final sparkPaint = Paint()
          ..color = particle.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = particle.size
          ..strokeCap = StrokeCap.round;
        
        canvas.drawLine(
          Offset(
            particle.x * size.width,
            particle.y * size.height,
          ),
          Offset(
            (particle.x - particle.speedX * 10) * size.width,
            (particle.y - particle.speedY * 10) * size.height,
          ),
          sparkPaint,
        );
      } else {
        // Draw ember as a circle with blur
        final emberPaint = Paint()
          ..color = particle.color
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        
        canvas.drawCircle(
          Offset(particle.x * size.width, particle.y * size.height),
          particle.size,
          emberPaint,
        );
      }
      
      // Recycle particles that go off-screen or expire
      if (particle.y < 0 || particle.y > 1 || particle.age > particle.lifespan) {
        particle.reset();
      }
    }
  }
  
  @override
  bool shouldRepaint(VictoryParticlePainter oldDelegate) => true;
}

enum ParticleType { spark, ember }

class VictoryParticle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  Color color;
  ParticleType type;
  double lifespan;
  double age;
  
  final random = math.Random();
  
  VictoryParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.color,
    required this.type,
    required this.lifespan,
    required this.age,
  });
  
  void update() {
    x += speedX;
    y += speedY;
    speedY += 0.0001; // Slight gravity effect
    age += 0.016; // Approximately one frame at 60fps
  }
  
  void reset() {
    x = random.nextDouble();
    y = random.nextDouble() * 0.3 + 0.4;
    age = 0;
    speedX = (random.nextDouble() - 0.5) * 0.01;
    speedY = -0.005 - random.nextDouble() * 0.01;
  }
}

class ExplosionManager {
  final List<Explosion> explosions = [];
  final math.Random random = math.Random();

  void addExplosion(double x, double y, Color baseColor) {
    explosions.add(Explosion(
      x: x,
      y: y,
      baseColor: baseColor,
      size: 30 + random.nextDouble() * 20,
      duration: 0.8 + random.nextDouble() * 0.4,
    ));
  }

  void update() {
    for (int i = explosions.length - 1; i >= 0; i--) {
      explosions[i].update();
      if (explosions[i].isDone) {
        explosions.removeAt(i);
      }
    }
  }
}

class Explosion {
  final double x;
  final double y;
  final Color baseColor;
  final double size;
  final double duration;
  double progress = 0.0;
  bool isDone = false;

  Explosion({
    required this.x,
    required this.y,
    required this.baseColor,
    required this.size,
    required this.duration,
  });

  void update() {
    if (!isDone) {
      progress += 0.016 / duration;
      if (progress >= 1.0) {
        isDone = true;
      }
    }
  }
}

class DebrisParticle {
  double x;
  double y;
  double speedX;
  double speedY;
  double rotation;
  double rotationSpeed;
  double size;
  Color color;
  
  DebrisParticle({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    required this.color,
  });
  
  void update() {
    x += speedX;
    y += speedY;
    speedY += 0.1; // Gravity
    rotation += rotationSpeed;
  }
}