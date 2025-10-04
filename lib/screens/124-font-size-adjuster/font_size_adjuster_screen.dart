import 'package:flutter/material.dart';
import 'dart:math' as math;

class FontSizeAdjusterScreen extends StatefulWidget {
  const FontSizeAdjusterScreen({Key? key}) : super(key: key);

  @override
  State<FontSizeAdjusterScreen> createState() => _FontSizeAdjusterScreenState();
}

class _FontSizeAdjusterScreenState extends State<FontSizeAdjusterScreen>
    with TickerProviderStateMixin {
  double _fontSize = 24.0;
  late AnimationController _glowController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  
  final double _minFontSize = 12.0;
  final double _maxFontSize = 72.0;

  @override
  void initState() {
    super.initState();
    
    // Glow animation for the slider thumb
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Scale animation for text changes
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Rotation animation for device icons
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onFontSizeChanged(double value) {
    setState(() {
      _fontSize = value;
    });
    _scaleController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildMainTextDisplay(),
                        const SizedBox(height: 40),
                        _buildFontSizeSlider(),
                        const SizedBox(height: 50),
                        _buildDevicePreviewGrid(),
                        const SizedBox(height: 30),
                        _buildAccessibilityInfo(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.blue.withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFa855f7), Color(0xFF3b82f6)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFa855f7).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.text_fields_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Font Adjuster',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Responsive Typography Made Easy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainTextDisplay() {
    return AnimatedBuilder(
      animation: _scaleController,
      builder: (context, child) {
        final scale = 1.0 + (_scaleController.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFa855f7), Color(0xFF3b82f6), Color(0xFF06b6d4)],
                  ).createShader(bounds),
                  child: Text(
                    'The Quick Brown Fox',
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Jumps Over The Lazy Dog',
                  style: TextStyle(
                    fontSize: _fontSize * 0.7,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFontSizeSlider() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Font Size',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(const Color(0xFFa855f7), const Color(0xFF3b82f6), 
                              _glowController.value)!,
                          Color.lerp(const Color(0xFF3b82f6), const Color(0xFFa855f7), 
                              _glowController.value)!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(const Color(0xFFa855f7), const Color(0xFF3b82f6), 
                              _glowController.value)!.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      '${_fontSize.toInt()}px',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: _CustomThumbShape(glowAnimation: _glowController),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
            ),
            child: Stack(
              children: [
                // Background gradient track
                Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Active gradient track
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_fontSize - _minFontSize) / (_maxFontSize - _minFontSize),
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFa855f7), Color(0xFF3b82f6), Color(0xFF06b6d4)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFa855f7).withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Slider(
                  value: _fontSize,
                  min: _minFontSize,
                  max: _maxFontSize,
                  onChanged: _onFontSizeChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_minFontSize.toInt()}px',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Text(
                '${_maxFontSize.toInt()}px',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDevicePreviewGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Device Previews',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
          children: [
            _buildDeviceCard('Phone', Icons.phone_android, 375, 0.4),
            _buildDeviceCard('Tablet', Icons.tablet_android, 768, 0.5),
            _buildDeviceCard('Desktop', Icons.computer, 1920, 0.7),
            _buildDeviceCard('Watch', Icons.watch, 180, 0.2),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceCard(String deviceName, IconData icon, double screenWidth, double scale) {
    final adjustedFontSize = _fontSize * scale;
    
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFa855f7), Color(0xFF3b82f6)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFa855f7).withOpacity(0.4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                deviceName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${screenWidth.toInt()}px wide',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${adjustedFontSize.toInt()}px',
                  style: TextStyle(
                    fontSize: adjustedFontSize.clamp(8, 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sample Text',
                style: TextStyle(
                  fontSize: adjustedFontSize.clamp(6, 14),
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccessibilityInfo() {
    final readabilityScore = _getReadabilityScore(_fontSize);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            readabilityScore.color.withOpacity(0.2),
            readabilityScore.color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: readabilityScore.color.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: readabilityScore.color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  readabilityScore.icon,
                  color: readabilityScore.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      readabilityScore.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      readabilityScore.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ReadabilityScore _getReadabilityScore(double fontSize) {
    if (fontSize < 16) {
      return ReadabilityScore(
        title: 'Small Text',
        description: 'May be difficult to read on some devices',
        color: Colors.orange,
        icon: Icons.warning_rounded,
      );
    } else if (fontSize >= 16 && fontSize <= 24) {
      return ReadabilityScore(
        title: 'Optimal Readability',
        description: 'Perfect for body text and general content',
        color: Colors.green,
        icon: Icons.check_circle_rounded,
      );
    } else if (fontSize > 24 && fontSize <= 40) {
      return ReadabilityScore(
        title: 'Large Text',
        description: 'Great for headings and emphasis',
        color: Colors.blue,
        icon: Icons.visibility_rounded,
      );
    } else {
      return ReadabilityScore(
        title: 'Extra Large',
        description: 'Best for displays and accessibility needs',
        color: Colors.purple,
        icon: Icons.accessibility_new_rounded,
      );
    }
  }
}

// Custom thumb shape with animated glow effect
class _CustomThumbShape extends SliderComponentShape {
  final Animation<double> glowAnimation;

  _CustomThumbShape({required this.glowAnimation});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Outer glow
    final glowPaint = Paint()
      ..color = Color.lerp(const Color(0xFFa855f7), const Color(0xFF3b82f6), 
          glowAnimation.value)!.withOpacity(0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15 * glowAnimation.value);
    canvas.drawCircle(center, 20, glowPaint);

    // Main gradient circle
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(const Color(0xFFa855f7), const Color(0xFF3b82f6), glowAnimation.value)!,
          Color.lerp(const Color(0xFF3b82f6), const Color(0xFF06b6d4), glowAnimation.value)!,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 12));
    canvas.drawCircle(center, 12, gradientPaint);

    // Inner white circle
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 6, innerPaint);
  }
}

// Data model for readability scores
class ReadabilityScore {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  ReadabilityScore({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });
}