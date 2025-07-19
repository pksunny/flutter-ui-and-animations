import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';


class QuantumMatrixCodeBreakerAnimationScreen extends StatefulWidget {
  const QuantumMatrixCodeBreakerAnimationScreen({Key? key}) : super(key: key);

  @override
  State<QuantumMatrixCodeBreakerAnimationScreen> createState() => _QuantumMatrixCodeBreakerAnimationScreenState();
}

class _QuantumMatrixCodeBreakerAnimationScreenState extends State<QuantumMatrixCodeBreakerAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _matrixController;
  late AnimationController _hackController;
  late AnimationController _revealController;
  late AnimationController _glitchController;
  late AnimationController _typewriterController;
  late AnimationController _scanlineController;
  
  late Animation<double> _matrixAnimation;
  late Animation<double> _hackAnimation;
  late Animation<double> _revealAnimation;
  late Animation<double> _glitchAnimation;
  late Animation<double> _typewriterAnimation;
  late Animation<double> _scanlineAnimation;
  
  bool _isHacking = false;
  bool _isRevealed = false;
  bool _showTerminal = false;
  int _hackingProgress = 0;
  String _currentHackText = '';
  Timer? _hackingTimer;
  
  final List<String> _hackingMessages = [
    'INITIALIZING QUANTUM BREACH...',
    'SCANNING NEURAL NETWORK...',
    'BYPASSING FIREWALL...',
    'DECRYPTING MATRIX CODE...',
    'INJECTING PAYLOAD...',
    'OVERRIDING SECURITY...',
    'ACCESSING CORE SYSTEM...',
    'BREACH SUCCESSFUL!',
  ];

  final List<String> _matrixChars = [
    'ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ',
    'サ', 'シ', 'ス', 'セ', 'ソ', 'タ', 'チ', 'ツ', 'テ', 'ト',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
  ];

  @override
  void initState() {
    super.initState();
    
    _matrixController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _hackController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _scanlineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _matrixAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _matrixController,
      curve: Curves.linear,
    ));
    
    _hackAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hackController,
      curve: Curves.easeInOut,
    ));
    
    _revealAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    ));
    
    _glitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glitchController,
      curve: Curves.easeInOut,
    ));
    
    _typewriterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typewriterController,
      curve: Curves.linear,
    ));
    
    _scanlineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanlineController,
      curve: Curves.linear,
    ));

    _scanlineController.repeat();
  }

  @override
  void dispose() {
    _matrixController.dispose();
    _hackController.dispose();
    _revealController.dispose();
    _glitchController.dispose();
    _typewriterController.dispose();
    _scanlineController.dispose();
    _hackingTimer?.cancel();
    super.dispose();
  }

  void _initiateQuantumBreach() async {
    if (_isHacking) return;
    
    setState(() {
      _isHacking = true;
      _showTerminal = true;
      _hackingProgress = 0;
      _currentHackText = '';
    });

    // Start matrix rain effect
    _matrixController.repeat();
    
    // Start hacking sequence
    _startHackingSequence();
    
    // Glitch effects during hacking
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!_isHacking) {
        timer.cancel();
        return;
      }
      _glitchController.forward().then((_) => _glitchController.reverse());
    });

    // Complete the breach after sequence
    await Future.delayed(const Duration(milliseconds: 8000));
    
    if (_isHacking) {
      await _completeQuantumBreach();
    }
  }

  void _startHackingSequence() {
    _hackingTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_hackingProgress >= _hackingMessages.length) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _currentHackText = _hackingMessages[_hackingProgress];
        _hackingProgress++;
      });
      
      _typewriterController.forward().then((_) => _typewriterController.reset());
    });
  }

  Future<void> _completeQuantumBreach() async {
    _hackingTimer?.cancel();
    _matrixController.stop();
    
    setState(() {
      _isHacking = false;
      _isRevealed = true;
    });
    
    // Dramatic reveal with multiple effects
    await _hackController.forward();
    await _revealController.forward();
    
    // Hide terminal after reveal
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _showTerminal = false;
    });
  }

  void _resetQuantumMatrix() async {
    setState(() {
      _isRevealed = false;
      _showTerminal = false;
    });
    
    await _revealController.reverse();
    await _hackController.reverse();
    _matrixController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 2.0,
            colors: [
              Color(0xFF001100),
              Color(0xFF000000),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Matrix rain background
            if (_isHacking)
              AnimatedBuilder(
                animation: _matrixAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: MatrixRainPainter(
                      _matrixAnimation.value,
                      _matrixChars,
                    ),
                  );
                },
              ),
            
            // Scanning lines
            AnimatedBuilder(
              animation: _scanlineAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: ScanlinePainter(_scanlineAnimation.value),
                );
              },
            ),
            
            // Glitch effect overlay
            if (_isHacking)
              AnimatedBuilder(
                animation: _glitchAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: GlitchPainter(_glitchAnimation.value),
                  );
                },
              ),
            
            // Main content with quantum reveal effect
            AnimatedBuilder(
              animation: Listenable.merge([_hackAnimation, _revealAnimation]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_hackAnimation.value * 0.1)
                    ..scale(0.8 + (_revealAnimation.value * 0.2)),
                  child: Opacity(
                    opacity: _isRevealed ? _revealAnimation.value : 1.0,
                    child: _buildMainContent(),
                  ),
                );
              },
            ),
            
            // Terminal overlay
            if (_showTerminal)
              _buildTerminalOverlay(),
            
            // Quantum breach button
            _buildQuantumButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00FF41).withOpacity(_isRevealed ? 0.8 : 0.3),
            width: 2,
          ),
          boxShadow: [
            if (_isRevealed)
              BoxShadow(
                color: const Color(0xFF00FF41).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.8),
              const Color(0xFF001100).withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantum symbol
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00FF41),
                  width: 3,
                ),
                boxShadow: [
                  if (_isRevealed)
                    BoxShadow(
                      color: const Color(0xFF00FF41).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  '⚛',
                  style: TextStyle(
                    fontSize: 60,
                    color: const Color(0xFF00FF41),
                    shadows: [
                      if (_isRevealed)
                        Shadow(
                          color: const Color(0xFF00FF41),
                          blurRadius: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Title
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  const Color(0xFF00FF41),
                  const Color(0xFF00FF41).withOpacity(0.7),
                ],
              ).createShader(bounds),
              child: Text(
                _isRevealed ? 'QUANTUM BREACH\nSUCCESSFUL' : 'QUANTUM MATRIX\nSECURED',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                  height: 1.2,
                  shadows: [
                    if (_isRevealed)
                      Shadow(
                        color: const Color(0xFF00FF41),
                        blurRadius: 10,
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Description
            Text(
              _isRevealed 
                  ? 'Neural pathways compromised.\nMatrix barriers dissolved.\nAccess level: ADMINISTRATOR'
                  : 'Encrypted neural network detected.\nQuantum entanglement required.\nInitiate breach protocol?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF00FF41).withOpacity(0.8),
                height: 1.8,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminalOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 300,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: const Color(0xFF00FF41), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QUANTUM BREACH TERMINAL v2.1.4',
                style: TextStyle(
                  color: const Color(0xFF00FF41),
                  fontSize: 14,
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Color(0xFF00FF41)),
              const SizedBox(height: 10),
              
              Expanded(
                child: ListView.builder(
                  itemCount: _hackingProgress,
                  itemBuilder: (context, index) {
                    if (index >= _hackingMessages.length) return Container();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            '> ',
                            style: TextStyle(
                              color: const Color(0xFF00FF41),
                              fontSize: 12,
                              fontFamily: 'Courier',
                            ),
                          ),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _typewriterAnimation,
                              builder: (context, child) {
                                final message = _hackingMessages[index];
                                final visibleLength = index == _hackingProgress - 1
                                    ? (_typewriterAnimation.value * message.length).round()
                                    : message.length;
                                return Text(
                                  message.substring(0, visibleLength),
                                  style: TextStyle(
                                    color: const Color(0xFF00FF41),
                                    fontSize: 12,
                                    fontFamily: 'Courier',
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Progress bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _hackingProgress / _hackingMessages.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF41),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF41),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantumButton() {
    return Positioned(
      bottom: 50,
      right: 30,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF41).withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isRevealed ? _resetQuantumMatrix : _initiateQuantumBreach,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00FF41),
                  const Color(0xFF00AA00),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF00FF41),
                width: 2,
              ),
            ),
            child: Icon(
              _isRevealed ? Icons.refresh : Icons.security,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class MatrixRainPainter extends CustomPainter {
  final double animationValue;
  final List<String> chars;

  MatrixRainPainter(this.animationValue, this.chars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (int column = 0; column < 20; column++) {
      final x = (size.width / 20) * column;
      
      for (int i = 0; i < 30; i++) {
        final y = (i * 25.0 + animationValue * 300) % size.height;
        final charIndex = ((column + i + animationValue * 10).round()) % chars.length;
        final opacity = math.max(0.0, 1.0 - (i / 30.0));
        
        paint.color = Color(0xFF00FF41).withOpacity(opacity * 0.8);
        
        final textPainter = TextPainter(
          text: TextSpan(
            text: chars[charIndex],
            style: TextStyle(
              color: paint.color,
              fontSize: 16,
              fontFamily: 'Courier',
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ScanlinePainter extends CustomPainter {
  final double animationValue;

  ScanlinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF41).withOpacity(0.1)
      ..strokeWidth = 2;

    final y = size.height * animationValue;
    
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GlitchPainter extends CustomPainter {
  final double animationValue;

  GlitchPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (animationValue == 0) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 10; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = random.nextDouble() * 200;
      final height = 2.0;

      paint.color = [
        const Color(0xFFFF0000),
        const Color(0xFF00FF00),
        const Color(0xFF0000FF),
      ][random.nextInt(3)].withOpacity(animationValue * 0.3);

      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}