import 'package:flutter/material.dart';
import 'dart:math' as math;


class ThrowAwayScreen extends StatefulWidget {
  @override
  _ThrowAwayScreenState createState() => _ThrowAwayScreenState();
}

class _ThrowAwayScreenState extends State<ThrowAwayScreen>
    with TickerProviderStateMixin {
  List<ThrowableWidget> widgets = [];
  List<ParticleSystem> particles = [];
  late AnimationController backgroundController;
  late Animation<double> backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    backgroundController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(backgroundController);

    _initializeWidgets();
  }

  void _initializeWidgets() {
    final colors = [
      Color(0xFF6C5CE7),
      Color(0xFFA29BFE),
      Color(0xFFFF7675),
      Color(0xFF74B9FF),
      Color(0xFF00CEC9),
      Color(0xFFE17055),
      Color(0xFFFF6B9D),
      Color(0xFF4834D4),
    ];

    final icons = [
      Icons.favorite,
      Icons.star,
      Icons.music_note,
      Icons.photo_camera,
      Icons.gamepad,
      Icons.coffee,
      Icons.flight,
      Icons.pets,
    ];

    for (int i = 0; i < 8; i++) {
      widgets.add(ThrowableWidget(
        key: GlobalKey(),
        color: colors[i % colors.length],
        icon: icons[i % icons.length],
        title: _getWidgetTitle(i),
        onThrow: _onWidgetThrown,
        index: i,
      ));
    }
  }

  String _getWidgetTitle(int index) {
    final titles = [
      'Love',
      'Dreams',
      'Music',
      'Memories',
      'Games',
      'Energy',
      'Journey',
      'Friends',
    ];
    return titles[index % titles.length];
  }

  void _onWidgetThrown(int index, Offset velocity) {
    setState(() {
      // Create particle explosion
      particles.add(ParticleSystem(
        position: Offset(200, 300 + (index * 100.0)),
        color: widgets[index].color,
      ));
      
      // Remove the widget after a delay
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            widgets.removeWhere((w) => w.index == index);
          });
        }
      });
    });

    // Regenerate widgets after all are thrown
    if (widgets.length <= 1) {
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            widgets.clear();
            particles.clear();
            _initializeWidgets();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: backgroundAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(backgroundAnimation.value),
                size: Size.infinite,
              );
            },
          ),
          
          // Particle systems
          ...particles.map((particle) => AnimatedParticles(particle: particle)),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildWidgetGrid(),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          ShimmerText(
            text: 'THROW-AWAY UI',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Flick any widget into the void',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Text(
        widgets.isEmpty ? 'Regenerating...' : '${widgets.length} widgets remaining',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  void dispose() {
    backgroundController.dispose();
    super.dispose();
  }
}

class ThrowableWidget extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final Function(int, Offset) onThrow;
  final int index;

  ThrowableWidget({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
    required this.onThrow,
    required this.index,
  }) : super(key: key);

  @override
  _ThrowableWidgetState createState() => _ThrowableWidgetState();
}

class _ThrowableWidgetState extends State<ThrowableWidget>
    with TickerProviderStateMixin {
  late AnimationController hoverController;
  late AnimationController throwController;
  late Animation<double> scaleAnimation;
  late Animation<double> rotationAnimation;
  late Animation<Offset> positionAnimation;
  
  bool isHovering = false;
  bool isBeingThrown = false;

  @override
  void initState() {
    super.initState();
    
    hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    throwController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: hoverController, curve: Curves.easeOut));
    
    rotationAnimation = Tween<double>(begin: 0.0, end: 4 * math.pi)
        .animate(CurvedAnimation(parent: throwController, curve: Curves.easeIn));
    
    positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: throwController, curve: Curves.easeIn));
  }

  void _handlePanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final speed = velocity.distance;
    
    if (speed > 500) {
      _throwWidget(velocity);
    }
  }

  void _throwWidget(Offset velocity) {
    if (isBeingThrown) return;
    
    setState(() {
      isBeingThrown = true;
    });

    // Calculate throw direction
    final screenSize = MediaQuery.of(context).size;
    final throwDistance = velocity.distance / 100;
    final direction = velocity / velocity.distance;
    
    positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: direction * throwDistance * 10,
    ).animate(CurvedAnimation(parent: throwController, curve: Curves.easeOut));

    throwController.forward().then((_) {
      widget.onThrow(widget.index, velocity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([hoverController, throwController]),
      builder: (context, child) {
        return Transform.translate(
          offset: positionAnimation.value,
          child: Transform.rotate(
            angle: rotationAnimation.value,
            child: Transform.scale(
              scale: scaleAnimation.value * (isBeingThrown ? 0.8 : 1.0),
              child: GestureDetector(
                onPanEnd: _handlePanEnd,
                onTapDown: (_) {
                  setState(() => isHovering = true);
                  hoverController.forward();
                },
                onTapUp: (_) {
                  setState(() => isHovering = false);
                  hoverController.reverse();
                },
                onTapCancel: () {
                  setState(() => isHovering = false);
                  hoverController.reverse();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color.withOpacity(0.8),
                        widget.color.withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        blurRadius: isHovering ? 20 : 10,
                        spreadRadius: isHovering ? 2 : 0,
                      ),
                    ],
                    border: Border.all(
                      color: widget.color.withOpacity(0.6),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    hoverController.dispose();
    throwController.dispose();
    super.dispose();
  }
}

class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;

  ShimmerText({required this.text, required this.style});

  @override
  _ShimmerTextState createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController shimmerController;
  late Animation<double> shimmerAnimation;

  @override
  void initState() {
    super.initState();
    shimmerController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0)
        .animate(shimmerController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white24,
                Colors.white,
                Colors.white24,
              ],
              stops: [
                shimmerAnimation.value - 0.3,
                shimmerAnimation.value,
                shimmerAnimation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    shimmerController.dispose();
    super.dispose();
  }
}

class ParticleSystem {
  final Offset position;
  final Color color;
  late List<Particle> particles;

  ParticleSystem({required this.position, required this.color}) {
    particles = List.generate(20, (index) {
      final angle = (index / 20) * 2 * math.pi;
      final speed = 50 + math.Random().nextDouble() * 100;
      return Particle(
        position: position,
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        ),
        color: color,
        life: 1.0,
      );
    });
  }
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double life;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.life,
  });
}

class AnimatedParticles extends StatefulWidget {
  final ParticleSystem particle;

  AnimatedParticles({required this.particle});

  @override
  _AnimatedParticlesState createState() => _AnimatedParticlesState();
}

class _AnimatedParticlesState extends State<AnimatedParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(widget.particle, controller.value),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  final ParticleSystem particleSystem;
  final double progress;

  ParticlePainter(this.particleSystem, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particleSystem.particles) {
      final currentPos = particle.position + (particle.velocity * progress);
      final opacity = (1 - progress).clamp(0.0, 1.0);
      
      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(currentPos, 3 * opacity, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BackgroundPainter extends CustomPainter {
  final double progress;

  BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          Color(0xFF1A1A2E).withOpacity(0.8),
          Color(0xFF16213E).withOpacity(0.6),
          Color(0xFF0A0A0A),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);

    // Draw floating geometric shapes
    final shapePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final angle = progress + (i * math.pi / 2.5);
      final x = size.width * 0.5 + math.cos(angle) * (size.width * 0.3);
      final y = size.height * 0.5 + math.sin(angle) * (size.height * 0.2);
      
      shapePaint.color = Color(0xFF6C5CE7).withOpacity(0.1);
      canvas.drawCircle(Offset(x, y), 20 + (i * 5), shapePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}