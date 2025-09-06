import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class NeonGlassmorphismScreen extends StatefulWidget {
  @override
  _NeonGlassmorphismScreenState createState() => _NeonGlassmorphismScreenState();
}

class _NeonGlassmorphismScreenState extends State<NeonGlassmorphismScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _rotationController,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _slideController.dispose();
    _glowController.dispose();
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
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f0f23),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Orbs
            ...List.generate(5, (index) => AnimatedBackgroundOrb(
              animation: _rotationAnimation,
              offset: Offset(
                100.0 + index * 80,
                150.0 + index * 120,
              ),
              color: [
                Colors.cyan,
                Colors.purple,
                Colors.pink,
                Colors.blue,
                Colors.green,
              ][index],
            )),
            
            // Main Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    SlideTransition(
                      position: _slideAnimation,
                      child: NeonGlassCard(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.cyan.withOpacity(0.8),
                                            Colors.purple.withOpacity(0.8),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.cyan.withOpacity(0.5),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NeonText(
                                      'NEON GLASS',
                                      fontSize: 24,
                                      color: Colors.cyan,
                                    ),
                                    NeonText(
                                      'Dashboard',
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _glowAnimation,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.purple.withOpacity(
                                            0.3 * _glowAnimation.value,
                                          ),
                                          blurRadius: 15 * _glowAnimation.value,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Stats Cards
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          AnimatedStatsCard(
                            title: 'USERS',
                            value: '12.5K',
                            icon: Icons.people_outline,
                            color: Colors.cyan,
                            animation: _pulseAnimation,
                            delay: 0,
                          ),
                          AnimatedStatsCard(
                            title: 'REVENUE',
                            value: '\$45.2K',
                            icon: Icons.trending_up,
                            color: Colors.green,
                            animation: _pulseAnimation,
                            delay: 200,
                          ),
                          AnimatedStatsCard(
                            title: 'ORDERS',
                            value: '892',
                            icon: Icons.shopping_cart_outlined,
                            color: Colors.orange,
                            animation: _pulseAnimation,
                            delay: 400,
                          ),
                          AnimatedStatsCard(
                            title: 'GROWTH',
                            value: '+23%',
                            icon: Icons.bar_chart,
                            color: Colors.purple,
                            animation: _pulseAnimation,
                            delay: 600,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Bottom Navigation
                    SlideTransition(
                      position: _slideAnimation,
                      child: NeonGlassCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NeonNavButton(Icons.home, true),
                              NeonNavButton(Icons.bar_chart, false),
                              NeonNavButton(Icons.favorite_outline, false),
                              NeonNavButton(Icons.person_outline, false),
                            ],
                          ),
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
}

class NeonGlassCard extends StatelessWidget {
  final Widget child;
  
  const NeonGlassCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  
  const NeonText(
    this.text, {
    Key? key,
    this.fontSize = 16,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: [
          Shadow(
            color: color.withOpacity(0.8),
            blurRadius: 10,
          ),
          Shadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
    );
  }
}

class AnimatedStatsCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Animation<double> animation;
  final int delay;
  
  const AnimatedStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.animation,
    required this.delay,
  }) : super(key: key);

  @override
  _AnimatedStatsCardState createState() => _AnimatedStatsCardState();
}

class _AnimatedStatsCardState extends State<AnimatedStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      _controller.forward();
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
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return NeonGlassCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              widget.color.withOpacity(0.3),
                              widget.color.withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.4 * widget.animation.value),
                              blurRadius: 15 * widget.animation.value,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 30,
                          color: widget.color,
                        ),
                      ),
                      SizedBox(height: 15),
                      NeonText(
                        widget.value,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class AnimatedBackgroundOrb extends StatelessWidget {
  final Animation<double> animation;
  final Offset offset;
  final Color color;
  
  const AnimatedBackgroundOrb({
    Key? key,
    required this.animation,
    required this.offset,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          left: offset.dx + math.cos(animation.value) * 30,
          top: offset.dy + math.sin(animation.value) * 20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NeonNavButton extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  
  const NeonNavButton(this.icon, this.isActive, {Key? key}) : super(key: key);

  @override
  _NeonNavButtonState createState() => _NeonNavButtonState();
}

class _NeonNavButtonState extends State<NeonNavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isActive
                    ? LinearGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.3),
                          Colors.purple.withOpacity(0.3),
                        ],
                      )
                    : null,
                border: Border.all(
                  color: widget.isActive
                      ? Colors.cyan.withOpacity(0.5)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                widget.icon,
                color: widget.isActive ? Colors.cyan : Colors.white60,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}