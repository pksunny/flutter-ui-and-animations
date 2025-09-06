import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class TypingEffectsScreen extends StatefulWidget {
  @override
  _TypingEffectsScreenState createState() => _TypingEffectsScreenState();
}

class _TypingEffectsScreenState extends State<TypingEffectsScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  final List<String> _texts = [
    "Welcome to Amazing Typing Effects",
    "Flutter makes everything possible",
    "Beautiful animations bring life to UI",
    "Code with passion and creativity",
    "Innovation starts with imagination",
  ];

  final List<String> _effectNames = [
    "Classic Typewriter",
    "Neon Glow Effect",
    "Matrix Rain Style",
    "Gradient Wave",
    "Particle Explosion",
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    Colors.purple.shade900,
                    Colors.blue.shade900,
                    (math.sin(_backgroundAnimation.value) + 1) / 2,
                  )!,
                  Color.lerp(
                    Colors.blue.shade900,
                    Colors.indigo.shade900,
                    (math.cos(_backgroundAnimation.value) + 1) / 2,
                  )!,
                  Color.lerp(
                    Colors.indigo.shade900,
                    Colors.purple.shade900,
                    (math.sin(_backgroundAnimation.value + math.pi) + 1) / 2,
                  )!,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _buildTypingEffect(index);
                      },
                    ),
                  ),
                  _buildBottomNavigation(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Typing Effects Showcase",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.purple.withOpacity(0.5),
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            _effectNames[_currentPage],
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingEffect(int index) {
    switch (index) {
      case 0:
        return ClassicTypingEffect(text: _texts[index]);
      case 1:
        return NeonGlowTypingEffect(text: _texts[index]);
      case 2:
        return MatrixTypingEffect(text: _texts[index]);
      case 3:
        return GradientWaveTypingEffect(text: _texts[index]);
      case 4:
        return ParticleTypingEffect(text: _texts[index]);
      default:
        return ClassicTypingEffect(text: _texts[0]);
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed:
                _currentPage > 0
                    ? () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                    : null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: _currentPage > 0 ? Colors.white : Colors.white38,
              size: 28,
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white38,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
          IconButton(
            onPressed:
                _currentPage < 4
                    ? () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                    : null,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: _currentPage < 4 ? Colors.white : Colors.white38,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

// Classic Typewriter Effect
class ClassicTypingEffect extends StatefulWidget {
  final String text;

  ClassicTypingEffect({required this.text});

  @override
  _ClassicTypingEffectState createState() => _ClassicTypingEffectState();
}

class _ClassicTypingEffectState extends State<ClassicTypingEffect>
    with TickerProviderStateMixin {
  String _displayedText = "";
  Timer? _timer;
  bool _showCursor = true;
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _startTyping();
  }

  void _startTyping() {
    _displayedText = "";
    int index = 0;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[index];
        });
        index++;
      } else {
        timer.cancel();
        Timer(Duration(seconds: 2), () {
          if (mounted) _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _cursorController,
          builder: (context, child) {
            return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _displayedText,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: _cursorController.value > 0.5 ? "|" : " ",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Neon Glow Typing Effect
class NeonGlowTypingEffect extends StatefulWidget {
  final String text;

  NeonGlowTypingEffect({required this.text});

  @override
  _NeonGlowTypingEffectState createState() => _NeonGlowTypingEffectState();
}

class _NeonGlowTypingEffectState extends State<NeonGlowTypingEffect>
    with TickerProviderStateMixin {
  String _displayedText = "";
  Timer? _timer;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _startTyping();
  }

  void _startTyping() {
    _displayedText = "";
    int index = 0;
    _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
      if (index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[index];
        });
        index++;
      } else {
        timer.cancel();
        Timer(Duration(seconds: 3), () {
          if (mounted) _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.cyan.withOpacity(0.5)),
        ),
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Text(
              _displayedText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10 * _glowAnimation.value,
                    color: Colors.cyan,
                    offset: Offset(0, 0),
                  ),
                  Shadow(
                    blurRadius: 20 * _glowAnimation.value,
                    color: Colors.cyan.withOpacity(0.5),
                    offset: Offset(0, 0),
                  ),
                  Shadow(
                    blurRadius: 30 * _glowAnimation.value,
                    color: Colors.cyan.withOpacity(0.3),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Matrix Rain Style Typing Effect
class MatrixTypingEffect extends StatefulWidget {
  final String text;

  MatrixTypingEffect({required this.text});

  @override
  _MatrixTypingEffectState createState() => _MatrixTypingEffectState();
}

class _MatrixTypingEffectState extends State<MatrixTypingEffect>
    with TickerProviderStateMixin {
  List<String> _displayedChars = [];
  Timer? _timer;
  late AnimationController _matrixController;
  List<String> _matrixChars = "01アイウエオカキクケコサシスセソ".split('');

  @override
  void initState() {
    super.initState();
    _matrixController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    )..repeat();
    _startTyping();
  }

  void _startTyping() {
    _displayedChars = List.filled(widget.text.length, '');
    int index = 0;
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (index < widget.text.length) {
        // Show random characters for a moment before revealing the real character
        for (int i = 0; i < 3; i++) {
          Future.delayed(Duration(milliseconds: i * 50), () {
            if (mounted) {
              setState(() {
                if (i < 2) {
                  _displayedChars[index] =
                      _matrixChars[math.Random().nextInt(_matrixChars.length)];
                } else {
                  _displayedChars[index] = widget.text[index];
                }
              });
            }
          });
        }
        index++;
      } else {
        timer.cancel();
        Timer(Duration(seconds: 2), () {
          if (mounted) _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _matrixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          _displayedChars.join(''),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.greenAccent,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(blurRadius: 5, color: Colors.green, offset: Offset(0, 0)),
            ],
          ),
        ),
      ),
    );
  }
}

// Gradient Wave Typing Effect
class GradientWaveTypingEffect extends StatefulWidget {
  final String text;

  GradientWaveTypingEffect({required this.text});

  @override
  _GradientWaveTypingEffectState createState() =>
      _GradientWaveTypingEffectState();
}

class _GradientWaveTypingEffectState extends State<GradientWaveTypingEffect>
    with TickerProviderStateMixin {
  String _displayedText = "";
  Timer? _timer;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_waveController);
    _startTyping();
  }

  void _startTyping() {
    _displayedText = "";
    int index = 0;
    _timer = Timer.periodic(Duration(milliseconds: 120), (timer) {
      if (index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[index];
        });
        index++;
      } else {
        timer.cancel();
        Timer(Duration(seconds: 2), () {
          if (mounted) _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.2),
              Colors.blue.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AnimatedBuilder(
          animation: _waveAnimation,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    Color.lerp(
                      Colors.purple,
                      Colors.pink,
                      (math.sin(_waveAnimation.value) + 1) / 2,
                    )!,
                    Color.lerp(
                      Colors.blue,
                      Colors.cyan,
                      (math.cos(_waveAnimation.value) + 1) / 2,
                    )!,
                    Color.lerp(
                      Colors.orange,
                      Colors.red,
                      (math.sin(_waveAnimation.value + math.pi) + 1) / 2,
                    )!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                _displayedText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Particle Explosion Typing Effect
class ParticleTypingEffect extends StatefulWidget {
  final String text;

  ParticleTypingEffect({required this.text});

  @override
  _ParticleTypingEffectState createState() => _ParticleTypingEffectState();
}

class _ParticleTypingEffectState extends State<ParticleTypingEffect>
    with TickerProviderStateMixin {
  String _displayedText = "";
  Timer? _timer;
  late AnimationController _particleController;
  late Animation<double> _particleAnimation;
  List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_particleController);
    _startTyping();
  }

  void _startTyping() {
    _displayedText = "";
    int index = 0;
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[index];
        });
        _createParticles();
        _particleController.reset();
        _particleController.forward();
        index++;
      } else {
        timer.cancel();
        Timer(Duration(seconds: 2), () {
          if (mounted) _startTyping();
        });
      }
    });
  }

  void _createParticles() {
    _particles.clear();
    for (int i = 0; i < 10; i++) {
      _particles.add(
        Particle(
          x: math.Random().nextDouble() * 200 - 100,
          y: math.Random().nextDouble() * 200 - 100,
          color:
              [
                Colors.orange,
                Colors.red,
                Colors.yellow,
                Colors.pink,
              ][math.Random().nextInt(4)],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    _particles,
                    _particleAnimation.value,
                  ),
                  size: Size(300, 200),
                );
              },
            ),
            Text(
              _displayedText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.orange,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  Color color;

  Particle({required this.x, required this.y, required this.color});
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter(this.particles, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint =
          Paint()
            ..color = particle.color.withOpacity(1 - animation)
            ..style = PaintingStyle.fill;

      final center = Offset(
        size.width / 2 + particle.x * animation,
        size.height / 2 + particle.y * animation,
      );

      canvas.drawCircle(center, (1 - animation) * 5, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
