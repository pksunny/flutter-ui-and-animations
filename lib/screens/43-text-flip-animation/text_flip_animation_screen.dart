import 'package:flutter/material.dart';
import 'dart:math' as math;

class TextFlipAnimationScreen extends StatefulWidget {
  const TextFlipAnimationScreen({Key? key}) : super(key: key);

  @override
  State<TextFlipAnimationScreen> createState() => _TextFlipAnimationScreenState();
}

class _TextFlipAnimationScreenState extends State<TextFlipAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _backgroundController;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _backgroundAnimation;

  final List<Map<String, String>> textPairs = [
    {'original': 'NEURAL LINK', 'translation': 'CONNECTION ESTABLISHED'},
    {'original': 'CYBER GHOST', 'translation': 'DIGITAL PHANTOM'},
    {'original': 'NEON DREAMS', 'translation': 'ELECTRIC VISIONS'},
    {'original': 'MATRIX CODE', 'translation': 'SYSTEM OVERRIDE'},
    {'original': 'DATA STREAM', 'translation': 'INFORMATION FLOW'},
    {'original': 'HACK THE WORLD', 'translation': 'BREAK THE SYSTEM'},
    {'original': 'FUTURE NOW', 'translation': 'TOMORROW TODAY'},
    {'original': 'CHROME HEART', 'translation': 'METAL SOUL'},
  ];

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _backgroundAnimation = ColorTween(
      begin: const Color(0xFF0a0a0a),
      end: const Color(0xFF1a0a1a),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _backgroundController.dispose();
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
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  _backgroundAnimation.value ?? const Color(0xFF0a0a0a),
                  const Color(0xFF0a0a0a),
                  const Color(0xFF000000),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated grid background
                _buildAnimatedGrid(),
                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: _buildFlipTextGrid(),
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

  Widget _buildAnimatedGrid() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return CustomPaint(
          painter: GridPainter(_backgroundController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(0.1),
                  Colors.purple.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: Colors.cyan.withOpacity(_glowAnimation.value * 0.6),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(_glowAnimation.value * 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                Text(
                  'TEXT FLIP ANIMATION',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                    shadows: [
                      Shadow(
                        color: Colors.cyan.withOpacity(_glowAnimation.value),
                        blurRadius: 10,
                      ),
                    ],
                    letterSpacing: 2,
                  ),
                ),
                
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlipTextGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.2,
        ),
        itemCount: textPairs.length,
        itemBuilder: (context, index) {
          return FlipTextCard(
            originalText: textPairs[index]['original']!,
            translatedText: textPairs[index]['translation']!,
            delay: Duration(milliseconds: index * 200),
          );
        },
      ),
    );
  }
}

class FlipTextCard extends StatefulWidget {
  final String originalText;
  final String translatedText;
  final Duration delay;

  const FlipTextCard({
    Key? key,
    required this.originalText,
    required this.translatedText,
    required this.delay,
  }) : super(key: key);

  @override
  State<FlipTextCard> createState() => _FlipTextCardState();
}

class _FlipTextCardState extends State<FlipTextCard>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _glowController;
  late Animation<double> _flipAnimation;
  late Animation<double> _glowAnimation;
  bool _showOriginal = true;

  @override
  void initState() {
    super.initState();
    
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.2,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Initial entrance animation
    Future.delayed(widget.delay, () {
      if (mounted) {
        _glowController.forward();
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_flipController.isAnimating) return;
    
    setState(() {
      _showOriginal = !_showOriginal;
    });
    
    if (_flipController.isDismissed) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * math.pi),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _showOriginal
                      ? [
                          Colors.cyan.withOpacity(0.1),
                          Colors.blue.withOpacity(0.1),
                        ]
                      : [
                          Colors.purple.withOpacity(0.1),
                          Colors.pink.withOpacity(0.1),
                        ],
                ),
                border: Border.all(
                  color: (_showOriginal ? Colors.cyan : Colors.purple)
                      .withOpacity(_glowAnimation.value),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_showOriginal ? Colors.cyan : Colors.purple)
                        .withOpacity(_glowAnimation.value * 0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    // Animated scan line effect
                    _buildScanLine(),
                    // Text content
                    _buildTextContent(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanLine() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Positioned(
          top: _glowController.value * 200,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  (_showOriginal ? Colors.cyan : Colors.purple)
                      .withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (_showOriginal ? Colors.cyan : Colors.purple)
                      .withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextContent() {
    final isShowingBack = _flipAnimation.value > 0.5;
    final currentText = _showOriginal ? widget.originalText : widget.translatedText;
    final displayText = isShowingBack ? 
        (_showOriginal ? widget.translatedText : widget.originalText) : 
        currentText;
    final textColor = isShowingBack ? 
        (_showOriginal ? Colors.purple : Colors.cyan) : 
        (_showOriginal ? Colors.cyan : Colors.purple);

    return Container(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(isShowingBack ? math.pi : 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  shadows: [
                    Shadow(
                      color: textColor.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: textColor.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isShowingBack ? 'DECODED' : 'TAP TO DECODE',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.7),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double animationValue;
  
  GridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.1)
      ..strokeWidth = 0.5;

    final gridSize = 50.0;
    final offset = animationValue * gridSize;

    // Draw vertical lines
    for (double x = -offset; x < size.width + gridSize; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = -offset; y < size.height + gridSize; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}