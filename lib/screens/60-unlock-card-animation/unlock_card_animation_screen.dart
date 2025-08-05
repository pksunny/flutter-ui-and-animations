import 'package:flutter/material.dart';
import 'dart:math' as math;

class UnlockCardAnimationScreen extends StatefulWidget {
  @override
  _UnlockCardAnimationScreenState createState() => _UnlockCardAnimationScreenState();
}

class _UnlockCardAnimationScreenState extends State<UnlockCardAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Color(0xFF2A1810),
              Color(0xFF1A0F2E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00D4FF).withOpacity(
                              0.3 + 0.2 * _glowController.value,
                            ),
                            blurRadius: 20 + 10 * _glowController.value,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        'NEURAL FEATURES',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [
                                Color(0xFF00D4FF),
                                Color(0xFF9D4EDD),
                                Color(0xFFFF006E),
                              ],
                            ).createShader(Rect.fromLTWH(0, 0, 300, 50)),
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Unlock the future of possibilities',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.85,
                  children: [
                    FeatureCard(
                      title: 'AI VISION',
                      subtitle: 'Neural Processing',
                      icon: Icons.visibility,
                      isLocked: false,
                      progress: 1.0,
                      gradientColors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                      floatController: _floatController,
                    ),
                    FeatureCard(
                      title: 'QUANTUM\nSYNC',
                      subtitle: 'Coming Soon',
                      icon: Icons.sync,
                      isLocked: true,
                      progress: 0.65,
                      gradientColors: [Color(0xFF9D4EDD), Color(0xFF7209B7)],
                      floatController: _floatController,
                    ),
                    FeatureCard(
                      title: 'MIND\nLINK',
                      subtitle: 'Beta Access',
                      icon: Icons.psychology,
                      isLocked: true,
                      progress: 0.35,
                      gradientColors: [Color(0xFFFF006E), Color(0xFFCC0055)],
                      floatController: _floatController,
                    ),
                    FeatureCard(
                      title: 'HOLO\nINTERFACE',
                      subtitle: 'Development',
                      icon: Icons.view_in_ar,
                      isLocked: true,
                      progress: 0.15,
                      gradientColors: [Color(0xFFFFBE0B), Color(0xFFE6A800)],
                      floatController: _floatController,
                    ),
                    FeatureCard(
                      title: 'TIME\nSHIFT',
                      subtitle: 'Theoretical',
                      icon: Icons.access_time,
                      isLocked: true,
                      progress: 0.05,
                      gradientColors: [Color(0xFF06FFA5), Color(0xFF05CC84)],
                      floatController: _floatController,
                    ),
                    FeatureCard(
                      title: 'NEURAL\nFUSION',
                      subtitle: 'Concept Phase',
                      icon: Icons.hub,
                      isLocked: true,
                      progress: 0.02,
                      gradientColors: [Color(0xFFFF4081), Color(0xFFE91E63)],
                      floatController: _floatController,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLocked;
  final double progress;
  final List<Color> gradientColors;
  final AnimationController floatController;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isLocked,
    required this.progress,
    required this.gradientColors,
    required this.floatController,
  }) : super(key: key);

  @override
  _FeatureCardState createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _revealController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _revealAnimation;
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    
    _shakeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _revealController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _revealAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isLocked) {
      _shakeController.forward().then((_) {
        _shakeController.reset();
        setState(() {
          _isRevealed = true;
        });
        _revealController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _shakeAnimation,
        _pulseAnimation,
        widget.floatController,
      ]),
      builder: (context, child) {
        double floatOffset = math.sin(widget.floatController.value * 2 * math.pi) * 3;
        double shakeOffset = math.sin(_shakeAnimation.value * 10 * math.pi) * 5 * _shakeAnimation.value;
        
        return Transform.translate(
          offset: Offset(shakeOffset, floatOffset),
          child: Transform.scale(
            scale: widget.isLocked ? _pulseAnimation.value : 1.0,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isLocked
                        ? [
                            Colors.grey.withOpacity(0.3),
                            Colors.grey.withOpacity(0.1),
                          ]
                        : widget.gradientColors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.isLocked ? Colors.grey : widget.gradientColors[0])
                          .withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: (widget.isLocked ? Colors.grey : widget.gradientColors[0])
                        .withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      // Animated background pattern
                      if (!widget.isLocked)
                        AnimatedBuilder(
                          animation: widget.floatController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: CircuitPainter(
                                animation: widget.floatController.value,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              size: Size.infinite,
                            );
                          },
                        ),
                      
                      // Main content
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  widget.icon,
                                  color: widget.isLocked
                                      ? Colors.grey.withOpacity(0.5)
                                      : Colors.white,
                                  size: 32,
                                ),
                                if (widget.isLocked)
                                  Icon(
                                    Icons.lock,
                                    color: Colors.grey.withOpacity(0.7),
                                    size: 24,
                                  ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: widget.isLocked
                                    ? Colors.grey.withOpacity(0.7)
                                    : Colors.white,
                                letterSpacing: 1,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.isLocked
                                    ? Colors.grey.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Reveal overlay
                      if (_isRevealed && widget.isLocked)
                        AnimatedBuilder(
                          animation: _revealAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black.withOpacity(0.9),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: _revealAnimation.value,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.hourglass_empty,
                                        color: widget.gradientColors[0],
                                        size: 40,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'COMING SOON',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        width: 100,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2),
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: widget.progress,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(2),
                                              gradient: LinearGradient(
                                                colors: widget.gradientColors,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${(widget.progress * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
}

class CircuitPainter extends CustomPainter {
  final double animation;
  final Color color;

  CircuitPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Create animated circuit-like patterns
    double offset = animation * 50;
    
    for (int i = 0; i < 5; i++) {
      double x = (i * 30.0 + offset) % size.width;
      double y = (i * 20.0 + offset * 0.7) % size.height;
      
      path.moveTo(x, y);
      path.lineTo(x + 20, y);
      path.lineTo(x + 20, y + 10);
      path.moveTo(x + 10, y + 5);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}