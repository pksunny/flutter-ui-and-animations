import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiRewardSystem extends StatefulWidget {
  const ConfettiRewardSystem({Key? key}) : super(key: key);

  @override
  State<ConfettiRewardSystem> createState() => _ConfettiRewardSystemState();
}

class _ConfettiRewardSystemState extends State<ConfettiRewardSystem> {
  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfettiOverlay(
        key: _confettiKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.purple.shade50,
                Colors.pink.shade50,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Title
                Text(
                  '🎉 Interactive Confetti',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Colors.purple.shade600,
                          Colors.blue.shade600,
                          Colors.pink.shade600,
                        ],
                      ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap any button to celebrate! 🎊',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Demo Buttons Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDemoButton(
                              context,
                              'Classic Confetti',
                              Icons.celebration,
                              [Colors.red, Colors.orange],
                              () => _confettiKey.currentState?.burst(
                                ConfettiConfig.classic(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDemoButton(
                              context,
                              'Emoji Party',
                              Icons.emoji_emotions,
                              [Colors.purple, Colors.pink],
                              () => _confettiKey.currentState?.burst(
                                ConfettiConfig.emoji(
                                  emojis: ['🎉', '🎊', '⭐', '💫', '✨'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDemoButton(
                              context,
                              'Achievement',
                              Icons.workspace_premium,
                              [Colors.amber, Colors.orange],
                              () => _confettiKey.currentState?.burst(
                                ConfettiConfig.achievement(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDemoButton(
                              context,
                              'Love Hearts',
                              Icons.favorite,
                              [Colors.pink, Colors.red],
                              () => _confettiKey.currentState?.burst(
                                ConfettiConfig.hearts(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDemoButton(
                              context,
                              'Money Rain',
                              Icons.attach_money,
                              [Colors.green, Colors.teal],
                              () => _confettiKey.currentState?.burst(
                                ConfettiConfig.money(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDemoButton(
                              context,
                              'Icon Burst',
                              Icons.star,
                              [Colors.blue, Colors.cyan],
                              () => _confettiKey.currentState?.burst(
                                ConfettiConfig.icons(
                                  icons: [
                                    Icons.star,
                                    Icons.favorite,
                                    Icons.bolt,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Continuous confetti button
                      _buildDemoButton(
                        context,
                        'Continuous Party Mode',
                        Icons.auto_awesome,
                        [Colors.deepPurple, Colors.indigo],
                        () => _confettiKey.currentState?.burstContinuous(
                          ConfettiConfig.rainbow(),
                          duration: const Duration(seconds: 3),
                        ),
                        isWide: true,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Info text
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Fully customizable • Realistic physics • Production ready',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoButton(
    BuildContext context,
    String label,
    IconData icon,
    List<Color> gradientColors,
    VoidCallback onTap, {
    bool isWide = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: isWide ? 70 : 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: Colors.white, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Configuration class for confetti particles
class ConfettiConfig {
  final int particleCount;
  final List<String>? emojis;
  final List<IconData>? icons;
  final List<Color>? colors;
  final double minSize;
  final double maxSize;
  final double gravity;
  final double velocityMultiplier;
  final bool useGradient;

  const ConfettiConfig({
    this.particleCount = 50,
    this.emojis,
    this.icons,
    this.colors,
    this.minSize = 8,
    this.maxSize = 16,
    this.gravity = 0.5,
    this.velocityMultiplier = 1.0,
    this.useGradient = false,
  });

  /// Classic colorful confetti
  factory ConfettiConfig.classic() => const ConfettiConfig(
        particleCount: 60,
        colors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.pink,
        ],
        minSize: 10,
        maxSize: 18,
        useGradient: true,
      );

  /// Emoji confetti
  factory ConfettiConfig.emoji({List<String>? emojis}) => ConfettiConfig(
        particleCount: 40,
        emojis: emojis ?? ['🎉', '🎊', '🎈', '⭐', '💫', '✨', '🌟'],
        minSize: 20,
        maxSize: 32,
      );

  /// Achievement/trophy theme
  factory ConfettiConfig.achievement() => const ConfettiConfig(
        particleCount: 50,
        emojis: ['🏆', '🥇', '⭐', '👑', '💎', '✨'],
        minSize: 24,
        maxSize: 36,
      );

  /// Love hearts
  factory ConfettiConfig.hearts() => const ConfettiConfig(
        particleCount: 45,
        emojis: ['❤️', '💖', '💕', '💗', '💓', '💝'],
        minSize: 20,
        maxSize: 30,
      );

  /// Money rain
  factory ConfettiConfig.money() => const ConfettiConfig(
        particleCount: 55,
        emojis: ['💰', '💵', '💸', '🤑', '💴', '💶'],
        minSize: 22,
        maxSize: 34,
        gravity: 0.3,
      );

  /// Icon confetti
  factory ConfettiConfig.icons({required List<IconData> icons}) => ConfettiConfig(
        particleCount: 40,
        icons: icons,
        colors: [
          Colors.amber,
          Colors.orange,
          Colors.deepOrange,
          Colors.yellow,
        ],
        minSize: 24,
        maxSize: 36,
      );

  /// Rainbow gradient confetti
  factory ConfettiConfig.rainbow() => const ConfettiConfig(
        particleCount: 70,
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
          Colors.pink,
        ],
        minSize: 12,
        maxSize: 20,
        useGradient: true,
        velocityMultiplier: 1.2,
      );
}

/// Individual confetti particle with physics
class ConfettiParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  double size;
  Color? color;
  String? emoji;
  IconData? icon;
  bool useGradient;
  List<Color>? gradientColors;

  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    this.color,
    this.emoji,
    this.icon,
    this.useGradient = false,
    this.gradientColors,
  });

  void update(double gravity) {
    // Apply gravity
    velocity = Offset(velocity.dx, velocity.dy + gravity);
    
    // Update position
    position = position + velocity;
    
    // Update rotation
    rotation += rotationSpeed;
    
    // Air resistance
    velocity = Offset(velocity.dx * 0.99, velocity.dy);
  }
}

/// Overlay widget that manages confetti particles
class ConfettiOverlay extends StatefulWidget {
  final Widget child;

  const ConfettiOverlay({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ConfettiOverlay> createState() => ConfettiOverlayState();
}

class ConfettiOverlayState extends State<ConfettiOverlay>
    with TickerProviderStateMixin {
  final List<ConfettiParticle> _particles = [];
  AnimationController? _controller;
  bool _isAnimating = false;

  /// Trigger a single confetti burst
  void burst(ConfettiConfig config, {Offset? origin}) {
    final size = MediaQuery.of(context).size;
    final center = origin ?? Offset(size.width / 2, size.height / 2);

    setState(() {
      _particles.clear();
      final random = Random();

      for (int i = 0; i < config.particleCount; i++) {
        // Random angle and velocity
        final angle = random.nextDouble() * 2 * pi;
        final speed = (5 + random.nextDouble() * 10) * config.velocityMultiplier;
        
        final velocity = Offset(
          cos(angle) * speed,
          sin(angle) * speed - 5, // Initial upward bias
        );

        Color? particleColor;
        String? emoji;
        IconData? icon;
        List<Color>? gradientColors;

        if (config.emojis != null && config.emojis!.isNotEmpty) {
          emoji = config.emojis![random.nextInt(config.emojis!.length)];
        } else if (config.icons != null && config.icons!.isNotEmpty) {
          icon = config.icons![random.nextInt(config.icons!.length)];
          if (config.colors != null && config.colors!.isNotEmpty) {
            particleColor = config.colors![random.nextInt(config.colors!.length)];
          }
        } else if (config.colors != null && config.colors!.isNotEmpty) {
          if (config.useGradient) {
            // Create gradient colors
            final color1 = config.colors![random.nextInt(config.colors!.length)];
            final color2 = config.colors![random.nextInt(config.colors!.length)];
            gradientColors = [color1, color2];
          } else {
            particleColor = config.colors![random.nextInt(config.colors!.length)];
          }
        }

        _particles.add(ConfettiParticle(
          position: center,
          velocity: velocity,
          rotation: random.nextDouble() * 2 * pi,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
          size: config.minSize + random.nextDouble() * (config.maxSize - config.minSize),
          color: particleColor,
          emoji: emoji,
          icon: icon,
          useGradient: config.useGradient && gradientColors != null,
          gradientColors: gradientColors,
        ));
      }
    });

    _startAnimation(config);
  }

  /// Trigger continuous confetti bursts
  void burstContinuous(ConfettiConfig config, {required Duration duration}) {
    final timer = Duration(milliseconds: 150);
    int elapsed = 0;

    void triggerBurst() {
      if (elapsed >= duration.inMilliseconds) return;
      
      burst(config);
      elapsed += timer.inMilliseconds;
      
      Future.delayed(timer, triggerBurst);
    }

    triggerBurst();
  }

  void _startAnimation(ConfettiConfig config) {
    _controller?.dispose();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _isAnimating = true;

    _controller!.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.update(config.gravity);
        }
      });
    });

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
          _particles.clear();
        });
      }
    });

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ConfettiPainter(particles: _particles),
              ),
            ),
          ),
      ],
    );
  }
}

/// Custom painter for rendering confetti particles
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Skip particles outside screen bounds
      if (particle.position.dy > size.height + 100) continue;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      if (particle.emoji != null) {
        // Draw emoji
        final textPainter = TextPainter(
          text: TextSpan(
            text: particle.emoji,
            style: TextStyle(fontSize: particle.size),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
      } else if (particle.icon != null) {
        // Draw icon
        final textPainter = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(particle.icon!.codePoint),
            style: TextStyle(
              fontSize: particle.size,
              fontFamily: particle.icon!.fontFamily,
              color: particle.color ?? Colors.amber,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
      } else {
        // Draw shape with color or gradient
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 1.5,
        );

        final paint = Paint();
        
        if (particle.useGradient && particle.gradientColors != null) {
          paint.shader = LinearGradient(
            colors: particle.gradientColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(rect);
        } else {
          paint.color = particle.color ?? Colors.blue;
        }

        // Draw rounded rectangle
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));
        canvas.drawRRect(rrect, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}