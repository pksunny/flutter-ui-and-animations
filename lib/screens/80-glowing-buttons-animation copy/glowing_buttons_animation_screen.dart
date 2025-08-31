import 'package:flutter/material.dart';


class GlowingButtonsAnimationScreen extends StatefulWidget {
  const GlowingButtonsAnimationScreen({Key? key}) : super(key: key);

  @override
  State<GlowingButtonsAnimationScreen> createState() => _GlowingButtonsAnimationScreenState();
}

class _GlowingButtonsAnimationScreenState extends State<GlowingButtonsAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _borderController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _borderController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );
    
    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F23),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF00F5FF),
                      Color(0xFF00C9FF),
                      Color(0xFF92FE9D),
                      Color(0xFFFFCD3C),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'Amazing Glowing Buttons',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                
                // Neon Pulse Button
                _buildNeonPulseButton(),
                const SizedBox(height: 40),
                
                // Gradient Wave Button
                _buildGradientWaveButton(),
                const SizedBox(height: 40),
                
                // Electric Border Button
                _buildElectricBorderButton(),
                const SizedBox(height: 40),
                
                // Plasma Glow Button
                _buildPlasmaGlowButton(),
                const SizedBox(height: 40),
                
                // Holographic Button
                _buildHolographicButton(),
                const SizedBox(height: 40),
                
                // Cosmic Button
                _buildCosmicButton(),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonPulseButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F5FF).withOpacity(0.5 * _pulseAnimation.value),
                blurRadius: 30 * _pulseAnimation.value,
                spreadRadius: 5 * _pulseAnimation.value,
              ),
              BoxShadow(
                color: const Color(0xFF00F5FF).withOpacity(0.3 * _pulseAnimation.value),
                blurRadius: 60 * _pulseAnimation.value,
                spreadRadius: 10 * _pulseAnimation.value,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001122),
              foregroundColor: const Color(0xFF00F5FF),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: const Color(0xFF00F5FF).withOpacity(_pulseAnimation.value * 0.8),
                  width: 2,
                ),
              ),
              elevation: 0,
            ),
            child: const Text(
              'NEON PULSE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientWaveButton() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: const [
                Color(0xFFFF006E),
                Color(0xFFFFBE0B),
                Color(0xFF8338EC),
                Color(0xFF3A86FF),
              ],
              stops: [
                (_waveAnimation.value - 0.3).clamp(0.0, 1.0),
                (_waveAnimation.value).clamp(0.0, 1.0),
                (_waveAnimation.value + 0.3).clamp(0.0, 1.0),
                (_waveAnimation.value + 0.6).clamp(0.0, 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF006E).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(-5, 0),
              ),
              BoxShadow(
                color: const Color(0xFF3A86FF).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(5, 0),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              'GRADIENT WAVE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildElectricBorderButton() {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            gradient: SweepGradient(
              startAngle: _borderAnimation.value * 2 * 3.14159,
              colors: const [
                Color(0xFFFFD60A),
                Color(0xFFFFD60A),
                Colors.transparent,
                Colors.transparent,
                Color(0xFFFFD60A),
              ],
              stops: const [0.0, 0.2, 0.3, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD60A).withOpacity(0.6),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(32),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xFFFFD60A),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'ELECTRIC BORDER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlasmaGlowButton() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _waveAnimation]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8 + (_pulseAnimation.value * 0.3),
              colors: [
                const Color(0xFFFF0080).withOpacity(0.8),
                const Color(0xFF7928CA).withOpacity(0.6),
                const Color(0xFF0D9488).withOpacity(0.4),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF0080).withOpacity(0.4 * _pulseAnimation.value),
                blurRadius: 40,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: const Color(0xFF7928CA).withOpacity(0.3 * _pulseAnimation.value),
                blurRadius: 60,
                spreadRadius: 8,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F0F0F).withOpacity(0.8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color.lerp(const Color(0xFFFF0080), const Color(0xFFFFFFFF), _waveAnimation.value)!,
                  Color.lerp(const Color(0xFF7928CA), const Color(0xFFFF0080), _waveAnimation.value)!,
                ],
              ).createShader(bounds),
              child: const Text(
                'PLASMA GLOW',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHolographicButton() {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Color.lerp(const Color(0xFF00D4FF), const Color(0xFF5A67D8), _borderAnimation.value)!,
                Color.lerp(const Color(0xFF5A67D8), const Color(0xFFED64A6), _borderAnimation.value)!,
                Color.lerp(const Color(0xFFED64A6), const Color(0xFFF093FB), _borderAnimation.value)!,
                Color.lerp(const Color(0xFFF093FB), const Color(0xFF00D4FF), _borderAnimation.value)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_borderAnimation.value * 2 * 3.14159),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D4FF).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(-3, -3),
              ),
              BoxShadow(
                color: const Color(0xFFED64A6).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              'HOLOGRAPHIC',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCosmicButton() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _waveAnimation, _borderAnimation]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: RadialGradient(
              center: Alignment(
                0.3 * (1 + _waveAnimation.value),
                -0.3 * (1 + _waveAnimation.value),
              ),
              radius: 1.2 + (_pulseAnimation.value * 0.5),
              colors: [
                const Color(0xFFFFE066),
                const Color(0xFFFF6B6B),
                const Color(0xFF4ECDC4),
                const Color(0xFF45B7D1),
                const Color(0xFF96CEB4),
                const Color(0xFF1A1A2E).withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFE066).withOpacity(0.3 * _pulseAnimation.value),
                blurRadius: 50,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: const Color(0xFF4ECDC4).withOpacity(0.2 * _pulseAnimation.value),
                blurRadius: 80,
                spreadRadius: 15,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Stack(
              children: [
                const Text(
                  'COSMIC ENERGY',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.transparent,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.white,
                      Color.lerp(Colors.white, const Color(0xFFFFE066), _borderAnimation.value)!,
                      Colors.white,
                    ],
                    stops: [
                      (_borderAnimation.value - 0.3).clamp(0.0, 1.0),
                      _borderAnimation.value,
                      (_borderAnimation.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'COSMIC ENERGY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}