import 'package:flutter/material.dart';
import 'dart:math' as math;

class PopupTextAnimationScreen extends StatefulWidget {
  @override
  _PopupTextAnimationScreenState createState() =>
      _PopupTextAnimationScreenState();
}

class _PopupTextAnimationScreenState extends State<PopupTextAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _buttonController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _buttonController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);

    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _showPopup(String type) {
    switch (type) {
      case 'typewriter':
        _showTypewriterPopup();
        break;
      case 'glitch':
        _showGlitchPopup();
        break;
      case 'neon':
        _showNeonPopup();
        break;
      case 'particle':
        _showParticlePopup();
        break;
      case 'holographic':
        _showHolographicPopup();
        break;
    }
  }

  void _showTypewriterPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => TypewriterPopup(),
    );
  }

  void _showGlitchPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => GlitchPopup(),
    );
  }

  void _showNeonPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => NeonPopup(),
    );
  }

  void _showParticlePopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => ParticlePopup(),
    );
  }

  void _showHolographicPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => HolographicPopup(),
    );
  }

  Widget _buildAnimatedButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required String type,
  }) {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) => _buttonController.reverse(),
      onTapCancel: () => _buttonController.reverse(),
      onTap: () => _showPopup(type),
      child: AnimatedBuilder(
        animation: _buttonScale,
        builder: (context, child) {
          return Transform.scale(
            scale: _buttonScale.value,
            child: Container(
              height: 120,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(
                  math.cos(_backgroundAnimation.value) * 0.3,
                  math.sin(_backgroundAnimation.value) * 0.3,
                ),
                radius: 1.5,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0f0f23),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Amazing Popup',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            foreground:
                                Paint()
                                  ..shader = LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Colors.blue,
                                      Colors.pink,
                                    ],
                                  ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                        Text(
                          'Animations',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap any button to experience stunning animations',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Animated Buttons Grid
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        children: [
                          _buildAnimatedButton(
                            title: 'Typewriter',
                            subtitle: 'Classic typing effect',
                            icon: Icons.keyboard,
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            type: 'typewriter',
                          ),
                          _buildAnimatedButton(
                            title: 'Glitch',
                            subtitle: 'Digital distortion',
                            icon: Icons.electrical_services,
                            colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                            type: 'glitch',
                          ),
                          _buildAnimatedButton(
                            title: 'Neon Glow',
                            subtitle: 'Cyberpunk vibes',
                            icon: Icons.flash_on,
                            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                            type: 'neon',
                          ),
                          _buildAnimatedButton(
                            title: 'Particles',
                            subtitle: 'Magical effects',
                            icon: Icons.auto_awesome,
                            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                            type: 'particle',
                          ),
                          _buildAnimatedButton(
                            title: 'Holographic',
                            subtitle: '3D floating effect',
                            icon: Icons.view_in_ar,
                            colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
                            type: 'holographic',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Typewriter Popup
class TypewriterPopup extends StatefulWidget {
  @override
  _TypewriterPopupState createState() => _TypewriterPopupState();
}

class _TypewriterPopupState extends State<TypewriterPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _displayText = '';
  final String _fullText =
      'Welcome to the amazing world of Flutter animations!';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 50),
      vsync: this,
    );
    _startTyping();
  }

  void _startTyping() async {
    for (int i = 0; i <= _fullText.length; i++) {
      await Future.delayed(Duration(milliseconds: 80));
      if (mounted) {
        setState(() {
          _displayText = _fullText.substring(0, i);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF1a1a2e).withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.keyboard, color: Colors.purple, size: 48),
            SizedBox(height: 20),
            Container(
              height: 100,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: _displayText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'monospace',
                    ),
                    children: [
                      TextSpan(
                        text: '|',
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

// Glitch Popup
class GlitchPopup extends StatefulWidget {
  @override
  _GlitchPopupState createState() => _GlitchPopupState();
}

class _GlitchPopupState extends State<GlitchPopup>
    with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late Animation<double> _glitchAnimation;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    )..repeat(reverse: true);

    _glitchAnimation = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(_glitchController);
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _glitchAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              _glitchAnimation.value * (math.Random().nextDouble() - 0.5) * 2,
              0,
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF0a0a0a).withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.electrical_services, color: Colors.red, size: 48),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Text(
                        'GLITCH EFFECT',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-2, -1),
                        child: Text(
                          'GLITCH EFFECT',
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'SYSTEM.ERROR.404',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('TERMINATE'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Neon Popup
class NeonPopup extends StatefulWidget {
  @override
  _NeonPopupState createState() => _NeonPopupState();
}

class _NeonPopupState extends State<NeonPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0a0a0a).withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.cyan.withOpacity(_glowAnimation.value),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(_glowAnimation.value * 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flash_on,
                  color: Colors.cyan,
                  size: 48,
                  shadows: [
                    Shadow(
                      color: Colors.cyan.withOpacity(_glowAnimation.value),
                      blurRadius: 20,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'NEON DREAMS',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        color: Colors.cyan.withOpacity(_glowAnimation.value),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Cyberpunk Vibes Only',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('DISCONNECT'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Particle Popup
class ParticlePopup extends StatefulWidget {
  @override
  _ParticlePopupState createState() => _ParticlePopupState();
}

class _ParticlePopupState extends State<ParticlePopup>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Create particles
    for (int i = 0; i < 20; i++) {
      particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: Color(0xFF1a1a2e).withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Stack(
              children: [
                // Particles
                ...particles.map((particle) {
                  final progress = (_controller.value + particle.offset) % 1.0;
                  return Positioned(
                    left:
                        particle.x * 300 +
                        math.sin(progress * 2 * math.pi) * 20,
                    top:
                        particle.y * 400 +
                        math.cos(progress * 2 * math.pi) * 15,
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        color: particle.color.withOpacity(
                          math.sin(progress * math.pi),
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: particle.color.withOpacity(0.5),
                            blurRadius: particle.size * 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.green, size: 48),
                      SizedBox(height: 20),
                      Text(
                        'MAGICAL',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'PARTICLES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Floating in digital space',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Dismiss'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double offset;

  Particle()
    : x = math.Random().nextDouble(),
      y = math.Random().nextDouble(),
      size = math.Random().nextDouble() * 4 + 2,
      color =
          [Colors.green, Colors.blue, Colors.purple, Colors.pink][math.Random()
              .nextInt(4)],
      offset = math.Random().nextDouble();
}

// Morphing Popup
class MorphingPopup extends StatefulWidget {
  @override
  _MorphingPopupState createState() => _MorphingPopupState();
}

class _MorphingPopupState extends State<MorphingPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _morphAnimation;
  int _currentTextIndex = 0;
  final List<String> _texts = ['TRANSFORM', 'MORPH', 'EVOLVE', 'CHANGE'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _morphAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.addListener(() {
      if (_controller.value > 0.8 &&
          _controller.status == AnimationStatus.forward) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _texts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _morphAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + math.sin(_morphAnimation.value * 2 * math.pi) * 0.1,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2d1b69).withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.withOpacity(0.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: _morphAnimation.value * 2 * math.pi,
                    child: Icon(Icons.transform, color: Colors.pink, size: 48),
                  ),
                  SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      _texts[_currentTextIndex],
                      key: ValueKey(_currentTextIndex),
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Shape shifting in real-time',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Stabilize'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Holographic Popup
class HolographicPopup extends StatefulWidget {
  @override
  _HolographicPopupState createState() => _HolographicPopupState();
}

class _HolographicPopupState extends State<HolographicPopup>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xFF667eea).withOpacity(0.3),
                    Color(0xFF764ba2).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: math.sin(_controller.value * 2 * math.pi) * 0.3,
                      child: Icon(
                        Icons.view_in_ar,
                        color: Colors.white,
                        size: 48,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'HOLOGRAPHIC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.8),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: Colors.purple.withOpacity(0.6),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'PROJECTION',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Floating in 3D space',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Text(
                            'DEACTIVATE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Transform extension for 3D effects
extension Transform3D on Widget {
  Widget rotateY(double angle) {
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
      child: this,
    );
  }
}
