import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeBombCountdown extends StatefulWidget {
  final DateTime deadline;
  final VoidCallback onExpired;
  final VoidCallback? onCompleted;
  final Duration alertThreshold;
  final Duration criticalThreshold;
  final bool playSounds;
  
  const TimeBombCountdown({
    Key? key,
    required this.deadline,
    required this.onExpired,
    this.onCompleted,
    this.alertThreshold = const Duration(hours: 24),
    this.criticalThreshold = const Duration(hours: 1),
    this.playSounds = true,
  }) : super(key: key);

  @override
  State<TimeBombCountdown> createState() => _TimeBombCountdownState();
}

class _TimeBombCountdownState extends State<TimeBombCountdown> with TickerProviderStateMixin {
  late Timer _timer;
  late Duration _remainingTime;
  late AnimationController _bombController;
  late AnimationController _fuseController;
  late AnimationController _tickController;
  late AnimationController _shakeController;
  late AnimationController _explosionController;
  late AnimationController _gridController;
  late AnimationController _backgroundParticleController;
  late AnimationController _warningShakeController;
  double _blastScale = 1.0;
  
  final List<ParticleModel> _particles = [];
  final List<BackgroundParticle> _backgroundParticles = [];
  bool _isExploded = false;
  bool _isCompleted = false;
  int _tickCounter = 0;
  double _progressPosition = 0.0;
  
  // Particles generator
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    
    // Initialize animation controllers
    _bombController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fuseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _tickController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _explosionController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _gridController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _backgroundParticleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _warningShakeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    // Start the timer that updates everything
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
      _updateAnimations();
      _maybePlayTickSound();
      
      if (_remainingTime.inSeconds <= 0 && !_isExploded && !_isCompleted) {
        _explode();
      }
    });
    
    // Generate initial particles
    _generateParticles(5);
    _generateBackgroundParticles(30);

    // Update progress position
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        _progressPosition = _remainingTime.inMilliseconds / 
          widget.deadline.difference(DateTime.now().subtract(const Duration(seconds: 10))).inMilliseconds;
        _progressPosition = _progressPosition.clamp(0.0, 1.0);
      });
    });
  }
  
  void _updateRemainingTime() {
    setState(() {
      _remainingTime = widget.deadline.difference(DateTime.now());
      if (_remainingTime.inSeconds <= 0) {
        _remainingTime = Duration.zero;
      }
    });
  }
  
  void _updateAnimations() {
    // Calculate progress for animations using proper Duration arithmetic
    final totalDuration = widget.deadline.difference(DateTime.now().subtract(const Duration(days: 1)));
    final progress = 1.0 - (_remainingTime.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
    
    // Update fuse burn speed based on remaining time
    if (_remainingTime < widget.criticalThreshold) {
      _fuseController.duration = const Duration(milliseconds: 500);
      _fuseController.forward(from: 0);
      _fuseController.repeat();
      
      // Add shake animation when time is critical
      if (!_shakeController.isAnimating) {
        _shakeController.forward(from: 0);
        _shakeController.repeat(reverse: true);
      }
    } else if (_remainingTime < widget.alertThreshold) {
      _fuseController.duration = const Duration(milliseconds: 1000);
      _fuseController.forward(from: 0);
      _fuseController.repeat();
    }
    
    // Generate more particles as deadline approaches
    if (_remainingTime < widget.alertThreshold && _random.nextDouble() < 0.2) {
      _generateParticles(1);
    }
    
    if (_remainingTime < widget.criticalThreshold && _random.nextDouble() < 0.4) {
      _generateParticles(2);
    }

    // Add warning shake when close to deadline
    if (_remainingTime.inSeconds <= 3 && !_isExploded) {
      _warningShakeController.forward(from: 0.0);
      HapticFeedback.mediumImpact();
    }
  }
  
  void _maybePlayTickSound() {
    if (!widget.playSounds) return;
    
    _tickCounter++;
    
    // Play tick sound at varying intervals based on remaining time
    int tickInterval = 4; // Default: every 4 seconds
    
    if (_remainingTime < widget.criticalThreshold) {
      tickInterval = 1; // Every second when critical
    } else if (_remainingTime < widget.alertThreshold) {
      tickInterval = 2; // Every 2 seconds when getting close
    }
    
    if (_tickCounter % tickInterval == 0) {
      _tickController.forward(from: 0);
      // In real app, we'd play sound here
      // AudioPlayer.play('assets/sounds/tick.mp3');
      HapticFeedback.lightImpact(); // Provide haptic feedback
    }
  }
  
  void _explode() {
    setState(() {
      _isExploded = true;
      _blastScale = 1.0;
    });
    
    // Add blast wave animation
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _blastScale = 2.0);
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() => _blastScale = 1.0);
      });
    });

    // Play explosion animation
    _explosionController.forward(from: 0);
    
    // In real app, play explosion sound
    // AudioPlayer.play('assets/sounds/explosion.mp3');
    HapticFeedback.heavyImpact();
    
    // Generate explosion particles
    _generateExplosionParticles(40);
    
    // Call the onExpired callback
    widget.onExpired();
  }
  
  void markAsCompleted() {
    if (_isExploded) return;
    
    setState(() {
      _isCompleted = true;
    });
    
    // Generate celebration particles
    _generateCelebrationParticles(50);
    
    // In real app, play success sound
    // AudioPlayer.play('assets/sounds/success.mp3');
    HapticFeedback.mediumImpact();
    
    // Call the onCompleted callback if provided
    widget.onCompleted?.call();
  }
  
  void _generateParticles(int count) {
    for (int i = 0; i < count; i++) {
      _particles.add(ParticleModel(
        position: Offset(
          20 + _random.nextDouble() * 30, 
          20 + _random.nextDouble() * 30,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 2,
          -2 - _random.nextDouble() * 2,
        ),
        color: Colors.orange.withOpacity(0.7),
        size: 2 + _random.nextDouble() * 4,
        lifetime: 1 + _random.nextDouble() * 1.5,
      ));
    }
  }
  
  void _generateExplosionParticles(int count) {
    for (int i = 0; i < count; i++) {
      double angle = _random.nextDouble() * 2 * math.pi;
      double speed = 5 + _random.nextDouble() * 10;
      
      _particles.add(ParticleModel(
        position: const Offset(75, 75), // Center of the bomb
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        ),
        color: _getExplosionParticleColor(),
        size: 3 + _random.nextDouble() * 7,
        lifetime: 0.5 + _random.nextDouble() * 1.5,
      ));
    }
  }
  
  void _generateCelebrationParticles(int count) {
    for (int i = 0; i < count; i++) {
      double angle = _random.nextDouble() * 2 * math.pi;
      double speed = 3 + _random.nextDouble() * 8;
      
      _particles.add(ParticleModel(
        position: const Offset(75, 75), // Center of the bomb
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        ),
        color: _getCelebrationParticleColor(),
        size: 2 + _random.nextDouble() * 5,
        lifetime: 1 + _random.nextDouble() * 2,
      ));
    }
  }

  void _generateBackgroundParticles(int count) {
    for (int i = 0; i < count; i++) {
      _backgroundParticles.add(BackgroundParticle(
        position: Offset(
          _random.nextDouble() * 400,
          _random.nextDouble() * 400,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 0.5,
          (_random.nextDouble() - 0.5) * 0.5,
        ),
        size: 1 + _random.nextDouble() * 2,
      ));
    }
  }
  
  Color _getExplosionParticleColor() {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.amber,
      Colors.deepOrange,
    ];
    return colors[_random.nextInt(colors.length)];
  }
  
  Color _getCelebrationParticleColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.yellow,
    ];
    return colors[_random.nextInt(colors.length)];
  }
  
  String _formatRemainingTime() {
    if (_remainingTime.inDays > 0) {
      return '${_remainingTime.inDays}d ${_remainingTime.inHours % 24}h';
    } else if (_remainingTime.inHours > 0) {
      return '${_remainingTime.inHours}h ${_remainingTime.inMinutes % 60}m';
    } else if (_remainingTime.inMinutes > 0) {
      return '${_remainingTime.inMinutes}m ${_remainingTime.inSeconds % 60}s';
    } else {
      return '${_remainingTime.inSeconds}s';
    }
  }
  
  Color _getBombColor() {
    if (_isCompleted) return Colors.green;
    if (_isExploded) return Colors.red;
    
    if (_remainingTime < widget.criticalThreshold) {
      return Colors.red;
    } else if (_remainingTime < widget.alertThreshold) {
      return Colors.orange;
    } else {
      return Colors.grey.shade800;
    }
  }
  
  @override
  void dispose() {
    _timer.cancel();
    _bombController.dispose();
    _fuseController.dispose();
    _tickController.dispose();
    _shakeController.dispose();
    _explosionController.dispose();
    _gridController.dispose();
    _backgroundParticleController.dispose();
    _warningShakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([_shakeController, _warningShakeController]),
        builder: (context, child) {
          return Transform.translate(
            offset: _getShakeOffset(),
            child: Transform.scale(
              scale: _isExploded ? _blastScale : 1.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.blue.shade900.withOpacity(0.3),
                      Colors.black,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated Grid Background
                    AnimatedBuilder(
                      animation: _gridController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 
                                   MediaQuery.of(context).size.height),
                          painter: GridPainter(
                            progress: _gridController.value,
                          ),
                        );
                      },
                    ),

                    // Background Particles
                    AnimatedBuilder(
                      animation: _backgroundParticleController,
                      builder: (context, _) {
                        for (var particle in _backgroundParticles) {
                          particle.update();
                        }
                        return CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 
                                   MediaQuery.of(context).size.height),
                          painter: BackgroundParticlePainter(
                            particles: _backgroundParticles,
                          ),
                        );
                      },
                    ),

                    // Center bomb content
                    Center(
                      child: Container(
                        width: 300, // Increased size
                        height: 300, // Increased size
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // The bomb
                            CustomPaint(
                              size: const Size(250, 250), // Increased size
                              painter: BombPainter(
                                color: _getBombColor(),
                                fuseProgress: _fuseController.value,
                                isExploded: _isExploded,
                                isCompleted: _isCompleted,
                              ),
                            ),
                            
                            // Particles
                            if (_particles.isNotEmpty)
                              CustomPaint(
                                size: const Size(300, 300),
                                painter: ParticlePainter(particles: _particles),
                              ),
                            
                            // Countdown text
                            if (!_isExploded && !_isCompleted)
                              Positioned(
                                bottom: 100,
                                child: Text(
                                  _formatRemainingTime(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36, // Increased size
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 4,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Progress Bar at bottom
                    Positioned(
                      bottom: 50,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 20, // Increased height
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            // Progress Fill
                            FractionallySizedBox(
                              widthFactor: _progressPosition,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade900,
                                      Colors.orange.shade900,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Status text
                    if (_isExploded || _isCompleted)
                      Positioned(
                        bottom: 100,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            _isExploded ? "BOOM! DEADLINE MISSED" : "DEFUSED! TASK COMPLETED",
                            style: TextStyle(
                              color: _isExploded ? Colors.red : Colors.green,
                              fontSize: 32, // Increased size
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Offset _getShakeOffset() {
    if (_remainingTime < widget.criticalThreshold) {
      return Offset(
        math.sin(_shakeController.value * math.pi * 8) * 5,
        0,
      );
    } else if (_warningShakeController.isAnimating) {
      return Offset(
        math.sin(_warningShakeController.value * math.pi * 4) * 3,
        0,
      );
    }
    return Offset.zero;
  }
}

class BombPainter extends CustomPainter {
  final Color color;
  final double fuseProgress;
  final bool isExploded;
  final bool isCompleted;
  
  BombPainter({
    required this.color,
    required this.fuseProgress,
    required this.isExploded,
    required this.isCompleted,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 20);
    final radius = size.width / 3;
    
    // Draw fuse
    if (!isExploded && !isCompleted) {
      final fusePaint = Paint()
        ..color = Colors.brown
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;
      
      final fusePath = Path()
        ..moveTo(center.dx, center.dy - radius)
        ..quadraticBezierTo(
          center.dx + 30, 
          center.dy - radius - 30, 
          center.dx + 40, 
          center.dy - radius - 60,
        );
      
      canvas.drawPath(fusePath, fusePaint);
      
      // Draw burning fuse tip
      final fuseEndPoint = Offset(
        center.dx + 40,
        center.dy - radius - 60 + (fuseProgress * 60),
      );
      
      canvas.drawCircle(
        fuseEndPoint, 
        4, 
        Paint()..color = Colors.orange,
      );
    }
    
    // Draw bomb body
    final bombPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    if (isExploded) {
      // Draw explosion fragments instead of bomb
      for (int i = 0; i < 8; i++) {
        final angle = i * math.pi / 4;
        final fragmentPath = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(
            center.dx + math.cos(angle) * radius * 1.2,
            center.dy + math.sin(angle) * radius * 1.2,
          )
          ..lineTo(
            center.dx + math.cos(angle + 0.3) * radius * 1.5,
            center.dy + math.sin(angle + 0.3) * radius * 1.5,
          )
          ..lineTo(
            center.dx + math.cos(angle - 0.3) * radius * 1.5,
            center.dy + math.sin(angle - 0.3) * radius * 1.5,
          )
          ..close();
        
        canvas.drawPath(fragmentPath, bombPaint);
      }
    } else {
      // Draw bomb cap
      final capPaint = Paint()
        ..color = Colors.grey.shade900
        ..style = PaintingStyle.fill;
      
      final capRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy - radius + 10),
        width: radius * 1.2,
        height: radius * 0.4,
      );
      
      canvas.drawOval(capRect, capPaint);
      
      // Draw bomb body
      canvas.drawCircle(center, radius, bombPaint);
      
      // Draw bomb highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
        radius * 0.2,
        highlightPaint,
      );
    }
    
    if (isCompleted) {
      // Draw checkmark
      final checkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      
      final checkPath = Path()
        ..moveTo(center.dx - radius * 0.4, center.dy)
        ..lineTo(center.dx - radius * 0.1, center.dy + radius * 0.3)
        ..lineTo(center.dx + radius * 0.4, center.dy - radius * 0.3);
      
      canvas.drawPath(checkPath, checkPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant BombPainter oldDelegate) {
    return oldDelegate.color != color ||
           oldDelegate.fuseProgress != fuseProgress ||
           oldDelegate.isExploded != isExploded ||
           oldDelegate.isCompleted != isCompleted;
  }
}

class ParticleModel {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double lifetime;
  double age = 0;
  
  ParticleModel({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifetime,
  });
  
  void update() {
    position += velocity;
    velocity *= 0.98; // Slight deceleration
    velocity += const Offset(0, 0.1); // Gravity
    age += 0.016; // Roughly 60fps
  }
  
  bool get isDead => age >= lifetime;
  
  double get opacity => 1 - (age / lifetime);
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;
  
  ParticlePainter({required this.particles});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        particle.position,
        particle.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true; // Always repaint for animations
  }
}

class GridPainter extends CustomPainter {
  final double progress;
  
  GridPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1;
    
    final spacing = 20.0;
    final xOffset = progress * spacing;
    final yOffset = progress * spacing;
    
    // Draw vertical lines
    for (var i = 0; i < size.width / spacing; i++) {
      canvas.drawLine(
        Offset(i * spacing + xOffset, 0),
        Offset(i * spacing + xOffset, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (var i = 0; i < size.height / spacing; i++) {
      canvas.drawLine(
        Offset(0, i * spacing + yOffset),
        Offset(size.width, i * spacing + yOffset),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => true;
}

class BackgroundParticle {
  Offset position;
  Offset velocity;
  double size;
  
  BackgroundParticle({
    required this.position,
    required this.velocity,
    required this.size,
  });
  
  void update() {
    position += velocity;
    
    if (position.dx < 0) position = Offset(400, position.dy);
    if (position.dx > 400) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, 200);
    if (position.dy > 200) position = Offset(position.dx, 0);
  }
}

class BackgroundParticlePainter extends CustomPainter {
  final List<BackgroundParticle> particles;
  
  BackgroundParticlePainter({required this.particles});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    for (final particle in particles) {
      canvas.drawCircle(
        particle.position,
        particle.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant BackgroundParticlePainter oldDelegate) => true;
}

// Example usage in a StatefulWidget:
class DeadlineTaskCard extends StatelessWidget {
  final String taskTitle;
  final String taskDescription;
  final DateTime deadline;
  final VoidCallback onMarkCompleted;

  const DeadlineTaskCard({
    Key? key,
    required this.taskTitle,
    required this.taskDescription,
    required this.deadline,
    required this.onMarkCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              taskDescription,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deadline:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      '${deadline.day}/${deadline.month}/${deadline.year} at ${deadline.hour}:${deadline.minute.toString().padLeft(2, '0')}',
                    ),
                  ],
                ),
                TimeBombCountdown(
                  deadline: deadline,
                  onExpired: () {
                    // Handle expired deadline
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task deadline missed!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onMarkCompleted,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }
}