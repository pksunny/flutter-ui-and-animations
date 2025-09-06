import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThreeDFloatingIconsScreen extends StatefulWidget {
  @override
  _ThreeDFloatingIconsScreenState createState() => _ThreeDFloatingIconsScreenState();
}

class _ThreeDFloatingIconsScreenState extends State<ThreeDFloatingIconsScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildBackgroundParticle(index)),
            
            // Main floating icons grid
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _rotationController,
                  _floatingController,
                  _pulseController,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.9 + (_pulseController.value * 0.1),
                    child: _buildIconsGrid(),
                  );
                },
              ),
            ),
            
            // Floating decorative elements
            _buildFloatingDecorations(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconsGrid() {
    final icons = [
      Icons.home_rounded,
      Icons.search_rounded,
      Icons.favorite_rounded,
      Icons.shopping_cart_rounded,
      Icons.person_rounded,
      Icons.settings_rounded,
      Icons.notifications_rounded,
      Icons.camera_alt_rounded,
      Icons.music_note_rounded,
    ];

    return Wrap(
      spacing: 40,
      runSpacing: 40,
      children: icons.asMap().entries.map((entry) {
        int index = entry.key;
        IconData icon = entry.value;
        return _buildFloatingIcon(icon, index);
      }).toList(),
    );
  }

  Widget _buildFloatingIcon(IconData icon, int index) {
    final double phase = (index * 0.3) % (2 * math.pi);
    final double floatOffset = math.sin(_floatingController.value * 2 * math.pi + phase) * 15;
    final double rotationOffset = _rotationController.value * 2 * math.pi + (index * 0.5);
    
    return Transform.translate(
      offset: Offset(0, floatOffset),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(math.sin(rotationOffset) * 0.2)
          ..rotateY(math.cos(rotationOffset) * 0.2)
          ..rotateZ(math.sin(rotationOffset * 0.5) * 0.1),
        child: GestureDetector(
          onTap: () => _onIconTap(index),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getGradientColors(index),
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getGradientColors(index)[0].withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    final gradients = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFf093fb), Color(0xFFf5576c)],
      [Color(0xFF4facfe), Color(0xFF00f2fe)],
      [Color(0xFF43e97b), Color(0xFF38f9d7)],
      [Color(0xFFfa709a), Color(0xFFfee140)],
      [Color(0xFFa8edea), Color(0xFFfed6e3)],
      [Color(0xFFffecd2), Color(0xFFfcb69f)],
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFfbc2eb), Color(0xFFa6c1ee)],
    ];
    return gradients[index % gradients.length];
  }

  Widget _buildBackgroundParticle(int index) {
    final random = math.Random(index);
    final size = 2.0 + random.nextDouble() * 4;
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final top = random.nextDouble() * MediaQuery.of(context).size.height;
    final phase = random.nextDouble() * 2 * math.pi;
    
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final opacity = 0.3 + (math.sin(_floatingController.value * 2 * math.pi + phase) * 0.4);
        return Positioned(
          left: left,
          top: top + (math.sin(_floatingController.value * 2 * math.pi + phase) * 30),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity.clamp(0.1, 0.7)),
              borderRadius: BorderRadius.circular(size / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingDecorations() {
    return Stack(
      children: [
        // Corner decorative elements
        Positioned(
          top: 100,
          left: 50,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.cyan.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        Positioned(
          bottom: 150,
          right: 80,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_rotationController.value * 2 * math.pi,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withOpacity(0.4),
                        Colors.pink.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onIconTap(int index) {
    // Create a bounce animation when icon is tapped
    final controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    final animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    ));

    controller.forward().then((_) {
      controller.reverse().then((_) {
        controller.dispose();
      });
    });
    
    // Add haptic feedback
    // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
  }
}