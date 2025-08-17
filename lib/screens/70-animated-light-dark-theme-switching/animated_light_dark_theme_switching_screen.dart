import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class AnimatedLightDarkThemeSwitchingScreen extends StatefulWidget {
  @override
  _AnimatedLightDarkThemeSwitchingScreenState createState() => _AnimatedLightDarkThemeSwitchingScreenState();
}

class _AnimatedLightDarkThemeSwitchingScreenState extends State<AnimatedLightDarkThemeSwitchingScreen>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController _themeController;
  late AnimationController _rippleController;
  late AnimationController _floatingController;
  late AnimationController _cardController;
  late Animation<double> _themeAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _cardAnimation;

  Offset? _switchPosition;
  final GlobalKey _switchKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    
    _themeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _themeAnimation = CurvedAnimation(
      parent: _themeController,
      curve: Curves.easeInOutCubic,
    );
    
    _rippleAnimation = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutCubic,
    );
    
    _floatingAnimation = CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    );
    
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    );

    _floatingController.repeat();
    _cardController.forward();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _rippleController.dispose();
    _floatingController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });

    // Get switch position for ripple effect
    final RenderBox? renderBox =
        _switchKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _switchPosition = renderBox.localToGlobal(Offset.zero) +
          Offset(renderBox.size.width / 2, renderBox.size.height / 2);
    }

    _themeController.forward().then((_) {
      _themeController.reverse();
    });

    _rippleController.forward().then((_) {
      _rippleController.reset();
    });

    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _themeAnimation,
        _rippleAnimation,
        _floatingAnimation,
        _cardAnimation,
      ]),
      builder: (context, child) {
        return Stack(
          children: [
            // Animated Background
            AnimatedContainer(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          Color(0xFF0F0F23),
                          Color(0xFF1A1A2E),
                          Color(0xFF16213E),
                        ]
                      : [
                          Color(0xFFF8F9FF),
                          Color(0xFFE8F4FD),
                          Color(0xFFDEF3FF),
                        ],
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    // Floating Particles
                    ...List.generate(20, (index) => _buildFloatingParticle(index)),
                    
                    // Ripple Effect
                    if (_switchPosition != null && _rippleAnimation.value > 0)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: RipplePainter(
                            center: _switchPosition!,
                            progress: _rippleAnimation.value,
                            isDark: isDarkMode,
                          ),
                        ),
                      ),
                    
                    // Main Content
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildHeader(),
                            SizedBox(height: 40),
                            Expanded(
                              child: _buildContent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 6 + 2;
    final speed = random.nextDouble() * 0.5 + 0.3;
    final offset = random.nextDouble() * 2 * math.pi;

    return Positioned(
      left: random.nextDouble() * MediaQuery.of(context).size.width,
      top: random.nextDouble() * MediaQuery.of(context).size.height,
      child: Transform.translate(
        offset: Offset(
          math.sin(_floatingAnimation.value * 2 * math.pi * speed + offset) * 20,
          math.cos(_floatingAnimation.value * 2 * math.pi * speed + offset) * 15,
        ),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: isDarkMode ? 0.3 : 0.6,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDarkMode
                    ? [Colors.cyan.withOpacity(0.6), Colors.transparent]
                    : [Colors.blue.withOpacity(0.4), Colors.transparent],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 800),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          child: Text('Amazing UI'),
        ),
        _buildThemeSwitch(),
      ],
    );
  }

  Widget _buildThemeSwitch() {
    return GestureDetector(
      key: _switchKey,
      onTap: _toggleTheme,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF667EEA), Color(0xFF764BA2)]
                : [Color(0xFFFFB75E), Color(0xFFED8F03)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? Colors.purple : Colors.orange).withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
              left: isDarkMode ? 40 : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: 0.6 + (_themeAnimation.value * 0.4),
                  child: Icon(
                    isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: isDarkMode ? Colors.indigo : Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFeatureCard(
            icon: Icons.palette,
            title: 'Beautiful Design',
            description: 'Stunning gradients and smooth animations',
            index: 0,
          ),
          SizedBox(height: 20),
          _buildFeatureCard(
            icon: Icons.speed,
            title: 'Smooth Performance',
            description: 'Optimized animations with 60fps rendering',
            index: 1,
          ),
          SizedBox(height: 20),
          _buildFeatureCard(
            icon: Icons.auto_awesome,
            title: 'Magic Transitions',
            description: 'Seamless theme switching with ripple effects',
            index: 2,
          ),
          SizedBox(height: 40),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required int index,
  }) {
    return Transform.scale(
      scale: 0.8 + (_cardAnimation.value * 0.2),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkMode 
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.9),
          border: Border.all(
            color: isDarkMode 
                ? Colors.cyan.withOpacity(0.2)
                : Colors.blue.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode 
                  ? Colors.cyan.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.cyan.withOpacity(0.3), Colors.purple.withOpacity(0.3)]
                      : [Colors.blue.withOpacity(0.2), Colors.purple.withOpacity(0.2)],
                ),
              ),
              child: Icon(
                icon,
                color: isDarkMode ? Colors.cyan : Colors.blue,
                size: 28,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 800),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    child: Text(title),
                  ),
                  SizedBox(height: 5),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 800),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    child: Text(description),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return GestureDetector(
      onTap: _toggleTheme,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF667EEA), Color(0xFF764BA2)]
                : [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? Colors.purple : Colors.cyan).withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 800),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            child: Text('Toggle Theme Magic ✨'),
          ),
        ),
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final Offset center;
  final double progress;
  final bool isDark;

  RipplePainter({
    required this.center,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.indigo : Colors.blue).withOpacity(0.3 * (1 - progress))
      ..style = PaintingStyle.fill;

    final radius = progress * math.max(size.width, size.height) * 1.2;
    canvas.drawCircle(center, radius, paint);

    // Additional ripple rings
    for (int i = 1; i <= 3; i++) {
      final ringPaint = Paint()
        ..color = (isDark ? Colors.cyan : Colors.lightBlue)
            .withOpacity(0.1 * (1 - progress) / i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final ringRadius = progress * math.max(size.width, size.height) * (0.3 + i * 0.3);
      canvas.drawCircle(center, ringRadius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}