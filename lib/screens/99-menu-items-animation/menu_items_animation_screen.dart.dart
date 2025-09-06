import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class MenuItemsAnimationScreen extends StatefulWidget {
  @override
  _MenuItemsAnimationScreenState createState() =>
      _MenuItemsAnimationScreenState();
}

class _MenuItemsAnimationScreenState extends State<MenuItemsAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _menuController;
  late AnimationController _particleController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<double> _menuOpacityAnimation;

  List<MenuItem> menuItems = [
    MenuItem(
      icon: Icons.home_rounded,
      title: 'Home',
      subtitle: 'Welcome back',
      color: Color(0xFF6C5CE7),
      gradient: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    ),
    MenuItem(
      icon: Icons.explore_rounded,
      title: 'Explore',
      subtitle: 'Discover new things',
      color: Color(0xFF00B894),
      gradient: [Color(0xFF00B894), Color(0xFF00CEC9)],
    ),
    MenuItem(
      icon: Icons.favorite_rounded,
      title: 'Favorites',
      subtitle: 'Your saved items',
      color: Color(0xFFE17055),
      gradient: [Color(0xFFE17055), Color(0xFFFF7675)],
    ),
    MenuItem(
      icon: Icons.person_rounded,
      title: 'Profile',
      subtitle: 'Manage your account',
      color: Color(0xFF0984E3),
      gradient: [Color(0xFF0984E3), Color(0xFF74B9FF)],
    ),
    MenuItem(
      icon: Icons.settings_rounded,
      title: 'Settings',
      subtitle: 'Customize your experience',
      color: Color(0xFFB2BEC3),
      gradient: [Color(0xFFB2BEC3), Color(0xFFDDD6FE)],
    ),
  ];

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _menuController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);

    _menuScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.elasticOut),
    );

    _menuOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _menuController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _menuController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _menuController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(_backgroundAnimation.value),
                  size: Size.infinite,
                );
              },
            ),

            // Floating Particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),

            // Main Menu Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),

                    // Menu Items
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _menuController,
                        builder: (context, child) {
                          return ListView.builder(
                            itemCount: menuItems.length,
                            itemBuilder: (context, index) {
                              return AnimatedMenuTile(
                                menuItem: menuItems[index],
                                index: index,
                                animation: _menuController,
                              );
                            },
                          );
                        },
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

class AnimatedMenuTile extends StatefulWidget {
  final MenuItem menuItem;
  final int index;
  final Animation<double> animation;

  const AnimatedMenuTile({
    Key? key,
    required this.menuItem,
    required this.index,
    required this.animation,
  }) : super(key: key);

  @override
  _AnimatedMenuTileState createState() => _AnimatedMenuTileState();
}

class _AnimatedMenuTileState extends State<AnimatedMenuTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverScale;
  late Animation<double> _hoverGlow;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _hoverScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _hoverGlow = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.animation,
        curve: Interval(
          math.min(0.1 + (widget.index * 0.05), 0.4),
          math.min(0.6 + (widget.index * 0.05), 1.0),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animation,
        curve: Interval(
          math.min(0.2 + (widget.index * 0.04), 0.5),
          math.min(0.8 + (widget.index * 0.04), 1.0),
          curve: Curves.easeOut,
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: AnimatedBuilder(
            animation: Listenable.merge([_hoverScale, _hoverGlow]),
            builder: (context, child) {
              return Transform.scale(
                scale: _hoverScale.value,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() => _isHovered = true);
                    _hoverController.forward();
                  },
                  onTapUp: (_) {
                    Future.delayed(Duration(milliseconds: 150), () {
                      setState(() => _isHovered = false);
                      _hoverController.reverse();
                    });
                  },
                  onTapCancel: () {
                    setState(() => _isHovered = false);
                    _hoverController.reverse();
                  },
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
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
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.menuItem.color.withOpacity(
                            0.3 * _hoverGlow.value,
                          ),
                          blurRadius: 20 + (10 * _hoverGlow.value),
                          spreadRadius: 2 * _hoverGlow.value,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.menuItem.gradient[0].withOpacity(
                                  0.1 + (0.1 * _hoverGlow.value),
                                ),
                                widget.menuItem.gradient[1].withOpacity(
                                  0.05 + (0.05 * _hoverGlow.value),
                                ),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              // Animated Icon Container
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: widget.menuItem.gradient,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.menuItem.color.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: AnimatedRotation(
                                  turns: _isHovered ? 0.1 : 0.0,
                                  duration: Duration(milliseconds: 300),
                                  child: Icon(
                                    widget.menuItem.icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),

                              SizedBox(width: 20),

                              // Text Content
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.menuItem.title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      widget.menuItem.subtitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Animated Arrow
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                transform: Matrix4.translationValues(
                                  _isHovered ? 10 : 0,
                                  0,
                                  0,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Color> gradient;

  MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
  });
}

class BackgroundPainter extends CustomPainter {
  final double animation;

  BackgroundPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    // Create animated gradient orbs
    for (int i = 0; i < 5; i++) {
      final centerX =
          (size.width * 0.2) +
          (size.width * 0.6 * math.sin(animation + i * 1.2));
      final centerY =
          (size.height * 0.2) +
          (size.height * 0.6 * math.cos(animation * 0.8 + i * 0.8));

      final radius = math.max(1.0, 80 + 40 * math.sin(animation * 2 + i));

      final rect = Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius,
      );

      // Ensure rect is valid
      if (rect.width > 0 && rect.height > 0) {
        paint.shader = RadialGradient(
          colors: [
            Color(0xFF6C5CE7).withOpacity(0.3),
            Color(0xFF6C5CE7).withOpacity(0.1),
            Colors.transparent,
          ],
          stops: [0.0, 0.7, 1.0],
        ).createShader(rect);

        canvas.drawCircle(Offset(centerX, centerY), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

class ParticlePainter extends CustomPainter {
  final double animation;

  ParticlePainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 20; i++) {
      final x =
          (size.width * 0.1) +
          (size.width * 0.8 * ((i * 0.1 + animation * 0.3) % 1));
      final y =
          (size.height * 0.1) +
          (size.height * 0.8 * ((i * 0.07 + animation * 0.2) % 1));

      final radius = math.max(0.5, 1 + 2 * math.sin(animation * 4 + i));
      final opacity = math.max(
        0.0,
        0.3 + 0.4 * math.sin(animation * 3 + i * 0.5),
      );

      paint.color = Colors.white.withOpacity(opacity * 0.6);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) =>
      oldDelegate.animation != animation;
}
