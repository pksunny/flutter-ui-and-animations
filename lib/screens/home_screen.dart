import 'package:flutter/material.dart';
import 'package:futurecore_codex/screens/3-six_nill/six_nill_screen.dart';
import 'dart:math' as math;
import '1-subscription/subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _scaleController;
  late AnimationController _gradientController;
  
  final List<Color> _colors = [
    const Color(0xFF6C63FF),
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFF4081),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _scaleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  void _navigateToSubscription(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const SixNillScreen(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          
          return Stack(
            children: [
              // Fade in the destination screen slowly
              FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: curved,
                    curve: const Interval(0.5, 1.0),
                  ),
                ),
                child: child,
              ),
              
              // Liquid animation layer
              AnimatedBuilder(
                animation: curved,
                builder: (context, _) {
                  return ClipPath(
                    clipper: _AdvancedLiquidClipper(
                      progress: curved.value,
                      waves: 3,
                      waveAmplitude: 120, // Increased from 40
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _colors[0].withOpacity(1.0), // Increased opacity
                            _colors[1].withOpacity(1.0), // Increased opacity
                          ],
                        ),
                      ),
                      child: this.build(context), // Show current screen during transition
                    ),
                  );
                },
              ),
            ],
          );
        },
        transitionDuration: const Duration(milliseconds: 1500),
        reverseTransitionDuration: const Duration(milliseconds: 1000),
        opaque: false,
        barrierDismissible: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.3, 0.6, 1.0],
                  colors: List.generate(
                    _colors.length,
                    (index) => Color.lerp(
                      _colors[index],
                      _colors[(index + 1) % _colors.length],
                      _gradientController.value,
                    )!,
                  ),
                ),
              ),
              child: SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ...List.generate(
                      5,
                      (index) => _buildAnimatedCircle(index),
                    ),
                    ...List.generate(
                      20,
                      (index) => _buildParticle(index),
                    ),
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildAnimatedLogo(),
                              const SizedBox(height: 40),
                              _buildWelcomeText(),
                              const SizedBox(height: 40),
                              _buildGetStartedButton(context),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle(int index) {
    final size = MediaQuery.of(context).size;
    final random = math.Random(index);
    
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Positioned(
          left: size.width * (random.nextDouble() - 0.3),
          top: size.height * (random.nextDouble() - 0.3),
          child: Transform.rotate(
            angle: _rotateController.value * 2 * math.pi,
            child: Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _colors[index % _colors.length].withOpacity(0.2),
                    _colors[index % _colors.length].withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticle(int index) {
    final size = MediaQuery.of(context).size;
    final random = math.Random(index);
    final particleSize = random.nextDouble() * 10 + 5;
    
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        final wave = math.sin(_rotateController.value * 2 * math.pi + index);
        final horizontalWave = math.cos(_rotateController.value * 2 * math.pi + index);
        
        return Positioned(
          top: (random.nextDouble() * size.height) + (30 * wave),
          left: (random.nextDouble() * size.width) + (30 * horizontalWave),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: particleSize * (1 + 0.2 * wave),
            height: particleSize * (1 + 0.2 * wave),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3 + 0.2 * wave.abs()),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: particleSize * wave.abs(),
                  spreadRadius: 2 * wave.abs(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _rotateController]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateController.value * 2 * math.pi,
          child: Transform.translate(
            offset: Offset(0, 20 * math.sin(_floatController.value * math.pi)),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: _colors,
                  transform: GradientRotation(_rotateController.value * 2 * math.pi),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeText() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 4 * math.sin(_floatController.value * math.pi)),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: const Text(
              'Welcome to\nFutureCore Codex',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _scaleController.forward(),
      onExit: (_) => _scaleController.reverse(),
      child: GestureDetector(
        onTap: () => _navigateToSubscription(context),
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + 0.1 * _scaleController.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.9)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AdvancedLiquidClipper extends CustomClipper<Path> {
  final double progress;
  final int waves;
  final double waveAmplitude;

  _AdvancedLiquidClipper({
    required this.progress,
    this.waves = 3,
    this.waveAmplitude = 30,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    final baseHeight = height * progress;
    path.moveTo(0, height);
    path.lineTo(0, baseHeight);

    // Create multiple waves
    for (var i = 0; i <= width; i++) {
      final x = i.toDouble();
      final normalizedX = x / width;
      final waveProgress = normalizedX * waves * math.pi;
      final waveHeight = math.sin(waveProgress + progress * math.pi * 2) * 
                        waveAmplitude * (1 - progress);
      final y = baseHeight + waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(width, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerY = size.height * (1 - progress);
    final rippleRadius = size.width * 0.3 * progress;

    if (progress < 0.5) {
      canvas.drawCircle(
        Offset(size.width / 2, centerY),
        rippleRadius,
        paint,
      );
    }

    // Multiple ripple rings
    for (var i = 0; i < 3; i++) {
      final ripplePaint = Paint()
        ..color = color.withOpacity((1 - progress) * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(
        Offset(size.width / 2, centerY),
        rippleRadius * (1 + i * 0.2),
        ripplePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
