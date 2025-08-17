import 'package:flutter/material.dart';
import 'dart:math' as math;

class Animated3dCardEffectScreen extends StatefulWidget {
  const Animated3dCardEffectScreen({super.key});

  @override
  State<Animated3dCardEffectScreen> createState() => _Animated3dCardEffectScreenState();
}

class _Animated3dCardEffectScreenState extends State<Animated3dCardEffectScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;
  
  bool _isFlipped = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.elasticOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeOut,
    ));
    
    // Start the glow animation loop
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _onCardTap() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
    
    if (_isFlipped) {
      _rotationController.forward();
    } else {
      _rotationController.reverse();
    }
    
    _particleController.reset();
    _particleController.forward();
  }

  void _onCardHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
    
    if (isHovering) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F0F),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _rotationAnimation,
              _scaleAnimation,
              _glowAnimation,
              _particleAnimation,
            ]),
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Particle effects
                  ...List.generate(12, (index) {
                    final angle = (index * 30.0) * (math.pi / 180);
                    final radius = 150.0 * _particleAnimation.value;
                    final x = math.cos(angle) * radius;
                    final y = math.sin(angle) * radius;
                    
                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Opacity(
                        opacity: (1.0 - _particleAnimation.value) * 0.8,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  
                  // Glow effect
                  Container(
                    width: 320,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(
                            0.3 * _glowAnimation.value,
                          ),
                          blurRadius: 40 * _glowAnimation.value,
                          spreadRadius: 10 * _glowAnimation.value,
                        ),
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(
                            0.2 * _glowAnimation.value,
                          ),
                          blurRadius: 60 * _glowAnimation.value,
                          spreadRadius: 15 * _glowAnimation.value,
                        ),
                      ],
                    ),
                  ),
                  
                  // Main card
                  MouseRegion(
                    onEnter: (_) => _onCardHover(true),
                    onExit: (_) => _onCardHover(false),
                    child: GestureDetector(
                      onTap: _onCardTap,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateY(_rotationAnimation.value),
                          child: _rotationAnimation.value <= math.pi / 2
                              ? _buildFrontCard()
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(math.pi),
                                  child: _buildBackCard(),
                                ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Floating elements
                  if (_isHovering) ...[
                    Positioned(
                      top: 100,
                      left: 50,
                      child: _buildFloatingElement(0),
                    ),
                    Positioned(
                      top: 120,
                      right: 60,
                      child: _buildFloatingElement(1),
                    ),
                    Positioned(
                      bottom: 100,
                      left: 80,
                      child: _buildFloatingElement(2),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFF6B73FF),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          CustomPaint(
            size: const Size(300, 180),
            painter: CardPatternPainter(),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PREMIUM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.diamond,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'TAP ME!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '•••• •••• •••• 1234',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          'VISA',
                          style: TextStyle(
                            color: Color(0xFF1A1F71),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFf093fb),
            Color(0xFFf5576c),
            Color(0xFFFF6B6B),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          CustomPaint(
            size: const Size(300, 180),
            painter: CardPatternPainter(isBack: true),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 10),
                const Text(
                  'AMAZING!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Beautiful 3D Animation',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElement(int index) {
    final colors = [Colors.cyanAccent, Colors.purpleAccent, Colors.pinkAccent];
    final icons = [Icons.auto_awesome, Icons.blur_circular, Icons.scatter_plot];
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[index].withOpacity(0.3),
        border: Border.all(
          color: colors[index].withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Icon(
        icons[index],
        color: colors[index],
        size: 16,
      ),
    );
  }
}

class CardPatternPainter extends CustomPainter {
  final bool isBack;
  
  CardPatternPainter({this.isBack = false});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(isBack ? 0.1 : 0.05)
      ..strokeWidth = 1;

    // Create geometric pattern
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 6; j++) {
        final x = (i * 30.0) + (j.isEven ? 15.0 : 0.0);
        final y = j * 30.0;
        
        if (x < size.width && y < size.height) {
          if (isBack) {
            // Dots pattern for back
            canvas.drawCircle(Offset(x, y), 2, paint);
          } else {
            // Lines pattern for front
            canvas.drawLine(
              Offset(x, y),
              Offset(x + 15, y + 15),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}