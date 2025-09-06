import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class LiquidGlassEffectScreen extends StatefulWidget {
  const LiquidGlassEffectScreen({Key? key}) : super(key: key);

  @override
  State<LiquidGlassEffectScreen> createState() =>
      _LiquidGlassEffectScreenState();
}

class _LiquidGlassEffectScreenState extends State<LiquidGlassEffectScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFF1a1a2e),
                        const Color(0xFF16213e),
                        math.sin(_rotationAnimation.value) * 0.5 + 0.5,
                      )!,
                      Color.lerp(
                        const Color(0xFF0f3460),
                        const Color(0xFF533483),
                        math.cos(_rotationAnimation.value * 0.7) * 0.5 + 0.5,
                      )!,
                      Color.lerp(
                        const Color(0xFF533483),
                        const Color(0xFFe94560),
                        math.sin(_rotationAnimation.value * 0.3) * 0.3 + 0.7,
                      )!,
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating Orbs
          ...List.generate(
            5,
            (index) => AnimatedBuilder(
              animation: Listenable.merge([
                _floatingAnimation,
                _rotationAnimation,
              ]),
              builder: (context, child) {
                final offset = index * (2 * math.pi / 5);
                return Positioned(
                  left:
                      MediaQuery.of(context).size.width * 0.5 +
                      math.cos(_rotationAnimation.value + offset) * 150 +
                      _floatingAnimation.value,
                  top:
                      MediaQuery.of(context).size.height * 0.3 +
                      math.sin(_rotationAnimation.value + offset) * 100 +
                      _floatingAnimation.value * 0.5,
                  child: Container(
                    width: 60 + index * 10,
                    height: 60 + index * 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Header Glass Card
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: GlassContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.cyanAccent.withOpacity(0.8),
                                          Colors.purpleAccent.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Liquid Glass',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            foreground:
                                                Paint()
                                                  ..shader = LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.cyanAccent,
                                                    ],
                                                  ).createShader(
                                                    const Rect.fromLTWH(
                                                      0.0,
                                                      0.0,
                                                      200.0,
                                                      70.0,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Beautiful UI Experience',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Feature Cards
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        FeatureCard(
                          icon: Icons.palette,
                          title: 'Design',
                          subtitle: 'Beautiful UI',
                          gradient: [Colors.pinkAccent, Colors.purpleAccent],
                          delay: 0,
                        ),
                        FeatureCard(
                          icon: Icons.animation,
                          title: 'Animate',
                          subtitle: 'Smooth Motion',
                          gradient: [Colors.cyanAccent, Colors.blueAccent],
                          delay: 200,
                        ),
                        FeatureCard(
                          icon: Icons.auto_fix_high,
                          title: 'Effects',
                          subtitle: 'Glass Morph',
                          gradient: [
                            Colors.orangeAccent,
                            Colors.deepOrangeAccent,
                          ],
                          delay: 400,
                        ),
                        FeatureCard(
                          icon: Icons.trending_up,
                          title: 'Performance',
                          subtitle: 'Optimized',
                          gradient: [Colors.greenAccent, Colors.tealAccent],
                          delay: 600,
                        ),
                      ],
                    ),
                  ),

                  // Bottom Action Bar
                  AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value * 0.3),
                        child: GlassContainer(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GlassButton(icon: Icons.home, onTap: () {}),
                              GlassButton(icon: Icons.search, onTap: () {}),
                              GlassButton(
                                icon: Icons.favorite,
                                onTap: () {},
                                isActive: true,
                              ),
                              GlassButton(icon: Icons.person, onTap: () {}),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const GlassContainer({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.08),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final int delay;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.delay = 0,
  }) : super(key: key);

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTap: () {
                _controller.reverse().then((_) => _controller.forward());
              },
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: widget.gradient),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
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
}

class GlassButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const GlassButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            onTap: widget.onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          widget.isActive
                              ? Colors.cyanAccent.withOpacity(0.6)
                              : Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    gradient:
                        widget.isActive
                            ? LinearGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.2),
                                Colors.purpleAccent.withOpacity(0.2),
                              ],
                            )
                            : LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.06),
                              ],
                            ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color:
                        widget.isActive
                            ? Colors.cyanAccent
                            : Colors.white.withOpacity(0.9),
                    size: 24,
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
