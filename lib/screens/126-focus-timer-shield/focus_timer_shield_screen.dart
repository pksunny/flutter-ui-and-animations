import 'package:flutter/material.dart';
import 'dart:math' as math;

class FocusTimerShieldDemo extends StatelessWidget {
  const FocusTimerShieldDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusTimerShield(
        // Fully customizable parameters
        accentColor: const Color(0xFF6C63FF),
        secondaryColor: const Color(0xFFFF6584),
        backgroundColor: const Color(0xFF0A0E21),
        shieldColor: Colors.black,
        maxShieldOpacity: 0.92,
        timerDuration: const Duration(seconds: 30), // Pomodoro timer
        enableParticles: true,
        enablePulseEffect: true,
        enableBreathingAnimation: true,
        onTimerComplete: () {
          // Callback when timer completes
          debugPrint('Focus session completed! 🎉');
        },
        onTimerStart: () {
          debugPrint('Focus mode activated! 🔥');
        },
        onTimerStop: () {
          debugPrint('Focus session paused.');
        },
      ),
    );
  }
}

/// 🎯 FOCUS TIMER SHIELD - Main Widget
/// 
/// A beautiful focus timer with visual distraction shield that gradually
/// darkens the screen to help users maintain deep focus.
/// 
/// Features:
/// - Animated distraction shield (opacity transition)
/// - Circular progress indicator with glow effect
/// - Particle system for ambient atmosphere
/// - Breathing animation for zen-like experience
/// - Fully customizable colors and behaviors
class FocusTimerShield extends StatefulWidget {
  /// Primary accent color for UI elements
  final Color accentColor;
  
  /// Secondary color for gradients and highlights
  final Color secondaryColor;
  
  /// Background color of the main UI
  final Color backgroundColor;
  
  /// Color of the distraction shield overlay
  final Color shieldColor;
  
  /// Maximum opacity of the shield (0.0 - 1.0)
  final double maxShieldOpacity;
  
  /// Duration of the focus timer
  final Duration timerDuration;
  
  /// Enable floating particle effects
  final bool enableParticles;
  
  /// Enable pulsing glow effect
  final bool enablePulseEffect;
  
  /// Enable breathing circle animation
  final bool enableBreathingAnimation;
  
  /// Callback when timer completes
  final VoidCallback? onTimerComplete;
  
  /// Callback when timer starts
  final VoidCallback? onTimerStart;
  
  /// Callback when timer stops
  final VoidCallback? onTimerStop;

  const FocusTimerShield({
    Key? key,
    this.accentColor = const Color(0xFF6C63FF),
    this.secondaryColor = const Color(0xFFFF6584),
    this.backgroundColor = const Color(0xFF0A0E21),
    this.shieldColor = Colors.black,
    this.maxShieldOpacity = 0.92,
    this.timerDuration = const Duration(seconds: 30),
    this.enableParticles = true,
    this.enablePulseEffect = true,
    this.enableBreathingAnimation = true,
    this.onTimerComplete,
    this.onTimerStart,
    this.onTimerStop,
  }) : super(key: key);

  @override
  State<FocusTimerShield> createState() => _FocusTimerShieldState();
}

class _FocusTimerShieldState extends State<FocusTimerShield>
    with TickerProviderStateMixin {
  // Timer state
  bool _isTimerRunning = false;
  bool _isTimerCompleted = false;
  late Duration _remainingTime;
  late Duration _totalDuration;

  // Animation controllers
  late AnimationController _shieldController;
  late AnimationController _pulseController;
  late AnimationController _breathingController;
  late AnimationController _particleController;
  late AnimationController _timerController;

  // Animations
  late Animation<double> _shieldOpacity;
  late Animation<double> _pulseScale;
  late Animation<double> _breathingScale;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.timerDuration;
    _totalDuration = widget.timerDuration;

    // Initialize shield animation (distraction overlay)
    _shieldController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _shieldOpacity = Tween<double>(
      begin: 0.0,
      end: widget.maxShieldOpacity,
    ).animate(CurvedAnimation(
      parent: _shieldController,
      curve: Curves.easeInOutCubic,
    ));

    // Initialize pulse animation (glow effect)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initialize breathing animation (zen circle)
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _breathingScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    // Initialize particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize timer countdown controller
    _timerController = AnimationController(
      vsync: this,
      duration: widget.timerDuration,
    )..addListener(_onTimerTick);
  }

  void _onTimerTick() {
    setState(() {
      _remainingTime = Duration(
        seconds: (_totalDuration.inSeconds * (1 - _timerController.value)).round(),
      );

      if (_timerController.isCompleted && !_isTimerCompleted) {
        _isTimerCompleted = true;
        _onTimerComplete();
      }
    });
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      setState(() => _isTimerRunning = true);
      _timerController.forward(from: _timerController.value);
      _shieldController.forward();
      widget.onTimerStart?.call();
    }
  }

  void _pauseTimer() {
    if (_isTimerRunning) {
      setState(() => _isTimerRunning = false);
      _timerController.stop();
      _shieldController.reverse();
      widget.onTimerStop?.call();
    }
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _isTimerCompleted = false;
      _remainingTime = _totalDuration;
    });
    _timerController.reset();
    _shieldController.reverse();
  }

  void _onTimerComplete() {
    widget.onTimerComplete?.call();
    _shieldController.reverse();
  }

  @override
  void dispose() {
    _shieldController.dispose();
    _pulseController.dispose();
    _breathingController.dispose();
    _particleController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background layer
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.backgroundColor,
                widget.backgroundColor.withOpacity(0.8),
              ],
            ),
          ),
        ),

        // Particle effects layer (ambient atmosphere)
        if (widget.enableParticles)
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  animation: _particleController.value,
                  color: widget.accentColor,
                ),
                size: Size.infinite,
              );
            },
          ),

        // Main content layer
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // Header
              _buildHeader(),
              
              const Spacer(),
              
              // Timer circle with breathing animation
              _buildTimerCircle(),
              
              const Spacer(),
              
              // Control buttons
              _buildControls(),
              
              const SizedBox(height: 60),
            ],
          ),
        ),

        // Distraction shield overlay (gradually darkens screen)
        AnimatedBuilder(
          animation: _shieldOpacity,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: _shieldOpacity.value < 0.1,
              child: Container(
                color: widget.shieldColor.withOpacity(_shieldOpacity.value),
                child: _shieldOpacity.value > 0.5
                    ? Center(
                        child: _buildShieldMessage(),
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [widget.accentColor, widget.secondaryColor],
            ).createShader(bounds),
            child: const Text(
              'FOCUS MODE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Deep Work Session',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCircle() {
    double progress = 1 - _timerController.value;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathingController,
        _pulseController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.enableBreathingAnimation && _isTimerRunning
              ? _breathingScale.value
              : 1.0,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: widget.enablePulseEffect && _isTimerRunning
                  ? [
                      BoxShadow(
                        color: widget.accentColor.withOpacity(0.4 * _pulseScale.value),
                        blurRadius: 60 * _pulseScale.value,
                        spreadRadius: 10 * _pulseScale.value,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.backgroundColor.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                ),

                // Progress indicator
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CustomPaint(
                    painter: CircularProgressPainter(
                      progress: progress,
                      color: widget.accentColor,
                      secondaryColor: widget.secondaryColor,
                      strokeWidth: 8,
                    ),
                  ),
                ),

                // Timer text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDuration(_remainingTime),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isTimerCompleted
                          ? 'COMPLETED'
                          : _isTimerRunning
                              ? 'STAY FOCUSED'
                              : 'READY TO START',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset button
          _buildControlButton(
            icon: Icons.refresh_rounded,
            onTap: _resetTimer,
            isSecondary: true,
          ),
          
          const SizedBox(width: 32),
          
          // Play/Pause button (larger, primary)
          _buildControlButton(
            icon: _isTimerRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onTap: _isTimerRunning ? _pauseTimer : _startTimer,
            isPrimary: true,
            size: 80,
            iconSize: 40,
          ),
          
          const SizedBox(width: 32),
          
          // Settings button
          _buildControlButton(
            icon: Icons.settings_rounded,
            onTap: () {
              // Settings action
            },
            isSecondary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isSecondary = false,
    double size = 64,
    double iconSize = 28,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isPrimary
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.accentColor, widget.secondaryColor],
                )
              : null,
          color: isSecondary ? Colors.white.withOpacity(0.1) : null,
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: widget.accentColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildShieldMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.self_improvement_rounded,
          size: 64,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(height: 24),
        Text(
          'Focus Shield Active',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Distractions minimized.\nStay in the zone.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

/// 🎨 Custom Painter for Circular Progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    this.strokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + (2 * math.pi * progress),
      colors: [color, secondaryColor, color],
      stops: const [0.0, 0.5, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// ✨ Custom Painter for Particle Effects
class ParticlePainter extends CustomPainter {
  final double animation;
  final Color color;
  final List<Particle> particles = [];

  ParticlePainter({required this.animation, required this.color}) {
    // Generate particles
    for (int i = 0; i < 30; i++) {
      particles.add(Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 3 + 1,
        speed: math.Random().nextDouble() * 0.5 + 0.2,
        phase: math.Random().nextDouble() * math.pi * 2,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final x = particle.x * size.width;
      final yOffset = (animation * particle.speed) % 1.0;
      final y = ((particle.y + yOffset) % 1.0) * size.height;
      
      final opacity = (math.sin(animation * math.pi * 2 + particle.phase) + 1) / 2;
      
      final paint = Paint()
        ..color = color.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// 🌟 Particle Data Class
class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
}