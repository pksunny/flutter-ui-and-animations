import 'package:flutter/material.dart';

class AnimatedMovingGradientTextScreen extends StatefulWidget {
  const AnimatedMovingGradientTextScreen({super.key});

  @override
  State<AnimatedMovingGradientTextScreen> createState() => _AnimatedMovingGradientTextScreenState();
}

class _AnimatedMovingGradientTextScreenState extends State<AnimatedMovingGradientTextScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  int selectedAnimation = 0;
  final List<String> animationNames = [
    'Flowing Wave',
    'Rainbow Spectrum',
    'Neon Pulse',
    'Cosmic Flow',
    'Fire Blaze',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
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
              const Color(0xFF1A1A2E).withOpacity(0.8),
              const Color(0xFF16213E).withOpacity(0.9),
              const Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xFF00F5FF),
                                  Color(0xFF9D50FF),
                                  Color(0xFFFF006E),
                                ],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'GRADIENT MAGIC',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Amazing Moving Gradient Text Animations',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Gradient Text
              Expanded(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildGradientText();
                      },
                    ),
                  ),
                ),
              ),

              // Animation Controls
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Choose Animation Style',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: animationNames.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedAnimation = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: selectedAnimation == index
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF6366F1),
                                            Color(0xFF8B5CF6),
                                          ],
                                        )
                                      : null,
                                  color: selectedAnimation == index
                                      ? null
                                      : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: selectedAnimation == index
                                        ? Colors.transparent
                                        : Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  animationNames[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: selectedAnimation == index
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientText() {
    switch (selectedAnimation) {
      case 0:
        return _buildFlowingWave();
      case 1:
        return _buildRainbowSpectrum();
      case 2:
        return _buildNeonPulse();
      case 3:
        return _buildCosmicFlow();
      case 4:
        return _buildFireBlaze();
      default:
        return _buildFlowingWave();
    }
  }

  Widget _buildFlowingWave() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea),
            const Color(0xFF764ba2),
            const Color(0xFFf093fb),
            const Color(0xFFf5576c),
          ],
          stops: [
            _animation.value - 0.3,
            _animation.value,
            _animation.value + 0.3,
            _animation.value + 0.6,
          ].map((e) => e.clamp(0.0, 1.0)).toList(),
        ).createShader(bounds);
      },
      child: const Text(
        'FLOWING\nWAVE',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.1,
          letterSpacing: 3,
        ),
      ),
    );
  }

  Widget _buildRainbowSpectrum() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
          ],
          stops: List.generate(7, (index) => 
            (index / 6 + _animation.value) % 1.0
          )..sort(),
        ).createShader(bounds);
      },
      child: const Text(
        'RAINBOW\nSPECTRUM',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.1,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildNeonPulse() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return RadialGradient(
            center: Alignment.center,
            radius: _animation.value + 0.5,
            colors: [
              const Color(0xFF00F5FF),
              const Color(0xFF9D50FF),
              const Color(0xFFFF006E),
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ).createShader(bounds);
        },
        child: const Text(
          'NEON\nPULSE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
            letterSpacing: 2.5,
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F5FF).withOpacity(0.5),
                  blurRadius: 30 * _pulseAnimation.value,
                  spreadRadius: 10 * _pulseAnimation.value,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildCosmicFlow() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return SweepGradient(
          center: Alignment.center,
          startAngle: _animation.value * 6.28,
          colors: [
            const Color(0xFF8E2DE2),
            const Color(0xFF4A00E0),
            const Color(0xFF00D4FF),
            const Color(0xFF5200FF),
            const Color(0xFF8E2DE2),
          ],
        ).createShader(bounds);
      },
      child: const Text(
        'COSMIC\nFLOW',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.1,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildFireBlaze() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.white,
          ],
          stops: [
            0.0,
            _animation.value * 0.3 + 0.2,
            _animation.value * 0.5 + 0.4,
            _animation.value * 0.3 + 0.7,
          ],
        ).createShader(bounds);
      },
      child: const Text(
        'FIRE\nBLAZE',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.1,
          letterSpacing: 3,
        ),
      ),
    );
  }
}