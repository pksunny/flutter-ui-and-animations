import 'package:flutter/material.dart';
import 'dart:math' as math;

// ============================================================================
// MAIN DEMO APP - Shows all loading animations in a beautiful showcase
// ============================================================================
class AmazingLoadingAnimationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Loading Animations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0A0A0A),
      ),
      home: LoadingAnimationsDemo(),
    );
  }
}

class LoadingAnimationsDemo extends StatefulWidget {
  @override
  _LoadingAnimationsDemoState createState() => _LoadingAnimationsDemoState();
}

class _LoadingAnimationsDemoState extends State<LoadingAnimationsDemo> {
  int selectedIndex = 0;
  
  final List<LoaderConfig> loaders = [
    LoaderConfig("Rotating Circle", () => FuturisticRotatingCircle()),
    LoaderConfig("Pulsing Dots", () => FuturisticPulsingDots()),
    LoaderConfig("Wave Animation", () => FuturisticWaveLoader()),
    LoaderConfig("Rotating Cube", () => FuturisticRotatingCube()),
    LoaderConfig("Liquid Fill", () => FuturisticLiquidFillLoader()),
    LoaderConfig("Gradient Spinner", () => FuturisticGradientSpinner()),
    LoaderConfig("Shimmer Loader", () => FuturisticShimmerLoader()),
    LoaderConfig("Heartbeat Loader", () => FuturisticHeartbeatLoader()),
    LoaderConfig("Typing Indicator", () => FuturisticTypingIndicator()),
    LoaderConfig("Flip Loader", () => FuturisticFlipLoader()),
    LoaderConfig("Clock Loader", () => FuturisticClockLoader()),
    LoaderConfig("DNA Helix", () => FuturisticDNAHelixLoader()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F23),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'ULTIMATE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Color(0xFF00F5FF), Color(0xFF9C27B0)],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                    Text(
                      'LOADING ANIMATIONS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 3,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Animation Display
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: loaders[selectedIndex].builder(),
                    ),
                  ),
                ),
              ),
              
              // Loader Selection Grid
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: loaders.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedIndex;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [Color(0xFF00F5FF), Color(0xFF9C27B0)],
                                  )
                                : LinearGradient(
                                    colors: [Colors.white12, Colors.white54],
                                  ),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              loaders[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 11,
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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

class LoaderConfig {
  final String name;
  final Widget Function() builder;
  
  LoaderConfig(this.name, this.builder);
}

// ============================================================================
// 1. FUTURISTIC ROTATING CIRCLE LOADER
// ============================================================================
class FuturisticRotatingCircle extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;
  final double strokeWidth;
  final bool showGlow;

  const FuturisticRotatingCircle({
    Key? key,
    this.size = 60,
    this.primaryColor = const Color(0xFF00F5FF),
    this.secondaryColor = const Color(0xFF9C27B0),
    this.duration = const Duration(seconds: 2),
    this.strokeWidth = 4,
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticRotatingCircleState createState() => _FuturisticRotatingCircleState();
}

class _FuturisticRotatingCircleState extends State<FuturisticRotatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: widget.showGlow
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                )
              : null,
          child: CustomPaint(
            painter: RotatingCirclePainter(
              progress: _controller.value,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

class RotatingCirclePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  RotatingCirclePainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Rotating gradient arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: [
        primaryColor,
        secondaryColor,
        primaryColor.withOpacity(0.1),
        Colors.transparent,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * math.pi);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawArc(
      rect,
      0,
      math.pi * 1.5,
      false,
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// 2. FUTURISTIC PULSING DOTS LOADER
// ============================================================================
class FuturisticPulsingDots extends StatefulWidget {
  final int dotCount;
  final double dotSize;
  final Color dotColor;
  final Duration duration;
  final double spacing;
  final bool showGlow;

  const FuturisticPulsingDots({
    Key? key,
    this.dotCount = 5,
    this.dotSize = 12,
    this.dotColor = const Color(0xFF00F5FF),
    this.duration = const Duration(milliseconds: 1200),
    this.spacing = 16,
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticPulsingDotsState createState() => _FuturisticPulsingDotsState();
}

class _FuturisticPulsingDotsState extends State<FuturisticPulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.dotCount, (index) {
            final delay = index * (1.0 / widget.dotCount);
            final animationValue = (_controller.value - delay) % 1.0;
            final scale = _getScaleForIndex(animationValue);
            final opacity = _getOpacityForIndex(animationValue);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.dotColor.withOpacity(opacity),
                        widget.dotColor.withOpacity(opacity * 0.5),
                      ],
                    ),
                    boxShadow: widget.showGlow
                        ? [
                            BoxShadow(
                              color: widget.dotColor.withOpacity(opacity * 0.6),
                              blurRadius: 10 * scale,
                              spreadRadius: 2 * scale,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _getScaleForIndex(double animationValue) {
    if (animationValue < 0.5) {
      return 1.0 + (animationValue * 2) * 0.5;
    } else {
      return 1.5 - ((animationValue - 0.5) * 2) * 0.5;
    }
  }

  double _getOpacityForIndex(double animationValue) {
    if (animationValue < 0.5) {
      return 0.3 + (animationValue * 2) * 0.7;
    } else {
      return 1.0 - ((animationValue - 0.5) * 2) * 0.7;
    }
  }
}

// ============================================================================
// 3. FUTURISTIC WAVE LOADER
// ============================================================================
class FuturisticWaveLoader extends StatefulWidget {
  final int barCount;
  final double barWidth;
  final double maxHeight;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;
  final bool showGlow;

  const FuturisticWaveLoader({
    Key? key,
    this.barCount = 7,
    this.barWidth = 4,
    this.maxHeight = 40,
    this.primaryColor = const Color(0xFF00F5FF),
    this.secondaryColor = const Color(0xFF9C27B0),
    this.duration = const Duration(milliseconds: 1500),
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticWaveLoaderState createState() => _FuturisticWaveLoaderState();
}

class _FuturisticWaveLoaderState extends State<FuturisticWaveLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(widget.barCount, (index) {
            final normalizedIndex = index / (widget.barCount - 1);
            final waveValue = math.sin(
              (_controller.value * 2 * math.pi) + (normalizedIndex * math.pi),
            );
            final height = (waveValue.abs() * widget.maxHeight) + (widget.maxHeight * 0.2);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              width: widget.barWidth,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.barWidth / 2),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    widget.primaryColor,
                    widget.secondaryColor,
                  ],
                ),
                boxShadow: widget.showGlow
                    ? [
                        BoxShadow(
                          color: widget.primaryColor.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        );
      },
    );
  }
}

// ============================================================================
// 4. FUTURISTIC ROTATING CUBE LOADER
// ============================================================================
class FuturisticRotatingCube extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;
  final bool showGlow;

  const FuturisticRotatingCube({
    Key? key,
    this.size = 50,
    this.primaryColor = const Color(0xFF00F5FF),
    this.secondaryColor = const Color(0xFF9C27B0),
    this.duration = const Duration(seconds: 3),
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticRotatingCubeState createState() => _FuturisticRotatingCubeState();
}

class _FuturisticRotatingCubeState extends State<FuturisticRotatingCube>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _scaleController]),
      builder: (context, child) {
        final scale = 0.8 + (_scaleController.value * 0.4);
        return Transform.scale(
          scale: scale,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotationController.value * 2 * math.pi)
              ..rotateY(_rotationController.value * 2 * math.pi)
              ..rotateZ(_rotationController.value * 2 * math.pi),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.primaryColor,
                    widget.secondaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: widget.showGlow
                    ? [
                        BoxShadow(
                          color: widget.primaryColor.withOpacity(0.5),
                          blurRadius: 20 * scale,
                          spreadRadius: 5 * scale,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// 5. FUTURISTIC LIQUID FILL LOADER
// ============================================================================
class FuturisticLiquidFillLoader extends StatefulWidget {
  final double size;
  final Color liquidColor;
  final Color backgroundColor;
  final Duration duration;
  final bool showGlow;

  const FuturisticLiquidFillLoader({
    Key? key,
    this.size = 80,
    this.liquidColor = const Color(0xFF00F5FF),
    this.backgroundColor = const Color(0xFF1A1A2E),
    this.duration = const Duration(seconds: 3),
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticLiquidFillLoaderState createState() =>
      _FuturisticLiquidFillLoaderState();
}

class _FuturisticLiquidFillLoaderState extends State<FuturisticLiquidFillLoader>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _fillController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _fillController]),
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: widget.showGlow
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.liquidColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                )
              : null,
          child: ClipOval(
            child: CustomPaint(
              painter: LiquidFillPainter(
                waveProgress: _waveController.value,
                fillProgress: _fillController.value,
                liquidColor: widget.liquidColor,
                backgroundColor: widget.backgroundColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class LiquidFillPainter extends CustomPainter {
  final double waveProgress;
  final double fillProgress;
  final Color liquidColor;
  final Color backgroundColor;

  LiquidFillPainter({
    required this.waveProgress,
    required this.fillProgress,
    required this.liquidColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Calculate fill level
    final fillLevel = size.height - (fillProgress * size.height);

    // Create wave path
    final wavePath = Path();
    wavePath.moveTo(0, fillLevel);

    for (double x = 0; x <= size.width; x++) {
      final waveY = fillLevel +
          math.sin((x / size.width * 4 * math.pi) + (waveProgress * 2 * math.pi)) * 10;
      wavePath.lineTo(x, waveY);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    // Paint liquid
    final liquidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          liquidColor.withOpacity(0.7),
          liquidColor,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(wavePath, liquidPaint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// 6. FUTURISTIC GRADIENT SPINNER
// ============================================================================
class FuturisticGradientSpinner extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final Duration duration;
  final double strokeWidth;
  final bool showGlow;

  const FuturisticGradientSpinner({
    Key? key,
    this.size = 60,
    this.colors = const [
      Color(0xFF00F5FF),
      Color(0xFF9C27B0),
      Color(0xFFFF6EC7),
      Color(0xFF00F5FF),
    ],
    this.duration = const Duration(milliseconds: 1500),
    this.strokeWidth = 4,
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticGradientSpinnerState createState() =>
      _FuturisticGradientSpinnerState();
}

class _FuturisticGradientSpinnerState extends State<FuturisticGradientSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: widget.showGlow
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.colors.first.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                )
              : null,
          child: CustomPaint(
            painter: GradientSpinnerPainter(
              progress: _controller.value,
              colors: widget.colors,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

class GradientSpinnerPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;

  GradientSpinnerPainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Create rotating gradient
    final gradient = SweepGradient(
      startAngle: progress * 2 * math.pi,
      colors: colors,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      0,
      math.pi * 1.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// 7. FUTURISTIC SHIMMER LOADER
// ============================================================================
class FuturisticShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;
  final BorderRadius? borderRadius;

  const FuturisticShimmerLoader({
    Key? key,
    this.width = 200,
    this.height = 20,
    this.baseColor = const Color(0xFF1A1A2E),
    this.highlightColor = const Color(0xFF00F5FF),
    this.duration = const Duration(milliseconds: 1500),
    this.borderRadius,
  }) : super(key: key);

  @override
  _FuturisticShimmerLoaderState createState() =>
      _FuturisticShimmerLoaderState();
}

class _FuturisticShimmerLoaderState extends State<FuturisticShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment(-1.0, -0.3),
              end: Alignment(1.0, 0.3),
              stops: [
                math.max(0.0, _controller.value - 0.3),
                _controller.value,
                math.min(1.0, _controller.value + 0.3),
              ],
              colors: [
                widget.baseColor,
                widget.highlightColor.withOpacity(0.5),
                widget.baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// 8. FUTURISTIC HEARTBEAT LOADER
// ============================================================================
class FuturisticHeartbeatLoader extends StatefulWidget {
  final double size;
  final Color heartColor;
  final Duration duration;
  final bool showGlow;

  const FuturisticHeartbeatLoader({
    Key? key,
    this.size = 50,
    this.heartColor = const Color(0xFFFF6EC7),
    this.duration = const Duration(milliseconds: 1000),
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticHeartbeatLoaderState createState() =>
      _FuturisticHeartbeatLoaderState();
}

class _FuturisticHeartbeatLoaderState extends State<FuturisticHeartbeatLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: widget.showGlow
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: widget.heartColor.withOpacity(0.6),
                        blurRadius: 15 * _scaleAnimation.value,
                        spreadRadius: 5 * _scaleAnimation.value,
                      ),
                    ],
                  )
                : null,
            child: CustomPaint(
              painter: HeartPainter(
                color: widget.heartColor,
                pulseValue: _scaleAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class HeartPainter extends CustomPainter {
  final Color color;
  final double pulseValue;

  HeartPainter({required this.color, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Heart shape path
    path.moveTo(width * 0.5, height * 0.25);
    path.cubicTo(width * 0.2, height * 0.1, width * -0.25, height * 0.6, width * 0.5, height);
    path.moveTo(width * 0.5, height * 0.25);
    path.cubicTo(width * 0.8, height * 0.1, width * 1.25, height * 0.6, width * 0.5, height);

    canvas.drawPath(path, paint);

    // Add gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.7),
          color,
          color.withOpacity(0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// 9. FUTURISTIC TYPING INDICATOR LOADER
// ============================================================================
class FuturisticTypingIndicator extends StatefulWidget {
  final int dotCount;
  final double dotSize;
  final Color dotColor;
  final Duration duration;
  final double spacing;
  final bool showGlow;

  const FuturisticTypingIndicator({
    Key? key,
    this.dotCount = 3,
    this.dotSize = 8,
    this.dotColor = const Color(0xFF00F5FF),
    this.duration = const Duration(milliseconds: 1400),
    this.spacing = 12,
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticTypingIndicatorState createState() =>
      _FuturisticTypingIndicatorState();
}

class _FuturisticTypingIndicatorState extends State<FuturisticTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.dotCount, (index) {
            final delay = index * 0.2;
            final animationValue = (_controller.value - delay) % 1.0;
            final bounceValue = _getBounceValue(animationValue);
            final opacity = _getOpacityValue(animationValue);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: Transform.translate(
                offset: Offset(0, -bounceValue * 10),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.dotColor.withOpacity(opacity),
                        widget.dotColor.withOpacity(opacity * 0.5),
                      ],
                    ),
                    boxShadow: widget.showGlow
                        ? [
                            BoxShadow(
                              color: widget.dotColor.withOpacity(opacity * 0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _getBounceValue(double t) {
    if (t < 0.5) {
      return math.sin(t * math.pi);
    }
    return 0;
  }

  double _getOpacityValue(double t) {
    if (t < 0.5) {
      return 0.3 + (math.sin(t * math.pi) * 0.7);
    }
    return 0.3;
  }
}

// ============================================================================
// 10. FUTURISTIC FLIP LOADER
// ============================================================================
class FuturisticFlipLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;
  final bool showGlow;

  const FuturisticFlipLoader({
    Key? key,
    this.size = 50,
    this.primaryColor = const Color(0xFF00F5FF),
    this.secondaryColor = const Color(0xFF9C27B0),
    this.duration = const Duration(milliseconds: 2000),
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticFlipLoaderState createState() => _FuturisticFlipLoaderState();
}

class _FuturisticFlipLoaderState extends State<FuturisticFlipLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final rotationX = _controller.value * 2 * math.pi;
        final rotationY = (_controller.value + 0.25) * 2 * math.pi;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(rotationX)
            ..rotateY(rotationY),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.primaryColor,
                  widget.secondaryColor,
                ],
              ),
              boxShadow: widget.showGlow
                  ? [
                      BoxShadow(
                        color: widget.primaryColor.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// 11. FUTURISTIC CLOCK LOADER
// ============================================================================
class FuturisticClockLoader extends StatefulWidget {
  final double size;
  final Color clockColor;
  final Color handColor;
  final Duration duration;
  final bool showGlow;

  const FuturisticClockLoader({
    Key? key,
    this.size = 60,
    this.clockColor = const Color(0xFF00F5FF),
    this.handColor = const Color(0xFFFFFFFF),
    this.duration = const Duration(seconds: 4),
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticClockLoaderState createState() => _FuturisticClockLoaderState();
}

class _FuturisticClockLoaderState extends State<FuturisticClockLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: widget.showGlow
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.clockColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                )
              : null,
          child: CustomPaint(
            painter: ClockPainter(
              progress: _controller.value,
              clockColor: widget.clockColor,
              handColor: widget.handColor,
            ),
          ),
        );
      },
    );
  }
}

class ClockPainter extends CustomPainter {
  final double progress;
  final Color clockColor;
  final Color handColor;

  ClockPainter({
    required this.progress,
    required this.clockColor,
    required this.handColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Clock face
    final facePaint = Paint()
      ..color = clockColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, facePaint);

    // Clock border
    final borderPaint = Paint()
      ..color = clockColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 1.5, borderPaint);

    // Hour markers
    final markerPaint = Paint()
      ..color = clockColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final startPoint = Offset(
        center.dx + (radius - 10) * math.cos(angle - math.pi / 2),
        center.dy + (radius - 10) * math.sin(angle - math.pi / 2),
      );
      final endPoint = Offset(
        center.dx + (radius - 5) * math.cos(angle - math.pi / 2),
        center.dy + (radius - 5) * math.sin(angle - math.pi / 2),
      );
      canvas.drawLine(startPoint, endPoint, markerPaint);
    }

    // Hour hand
    final hourAngle = (progress * 2 * math.pi) - math.pi / 2;
    final hourHand = Paint()
      ..color = handColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final hourEnd = Offset(
      center.dx + (radius * 0.5) * math.cos(hourAngle),
      center.dy + (radius * 0.5) * math.sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHand);

    // Minute hand
    final minuteAngle = (progress * 12 * 2 * math.pi) - math.pi / 2;
    final minuteHand = Paint()
      ..color = handColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final minuteEnd = Offset(
      center.dx + (radius * 0.7) * math.cos(minuteAngle),
      center.dy + (radius * 0.7) * math.sin(minuteAngle),
    );
    canvas.drawLine(center, minuteEnd, minuteHand);

    // Center dot
    final centerPaint = Paint()..color = handColor;
    canvas.drawCircle(center, 4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// 12. FUTURISTIC DNA HELIX LOADER
// ============================================================================
class FuturisticDNAHelixLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;
  final bool showGlow;

  const FuturisticDNAHelixLoader({
    Key? key,
    this.size = 80,
    this.primaryColor = const Color(0xFF00F5FF),
    this.secondaryColor = const Color(0xFF9C27B0),
    this.duration = const Duration(seconds: 3),
    this.showGlow = true,
  }) : super(key: key);

  @override
  _FuturisticDNAHelixLoaderState createState() =>
      _FuturisticDNAHelixLoaderState();
}

class _FuturisticDNAHelixLoaderState extends State<FuturisticDNAHelixLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: DNAHelixPainter(
              progress: _controller.value,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              showGlow: widget.showGlow,
            ),
          ),
        );
      },
    );
  }
}

class DNAHelixPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final bool showGlow;

  DNAHelixPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.showGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;
    final height = size.height;

    // Draw DNA strands
    final strandPaint1 = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final strandPaint2 = Paint()
      ..color = secondaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    final path2 = Path();

    for (double y = 0; y <= height; y += 2) {
      final t = y / height;
      final angle1 = (t * 4 * math.pi) + (progress * 2 * math.pi);
      final angle2 = angle1 + math.pi;

      final x1 = center.dx + radius * math.cos(angle1);
      final x2 = center.dx + radius * math.cos(angle2);

      if (y == 0) {
        path1.moveTo(x1, y);
        path2.moveTo(x2, y);
      } else {
        path1.lineTo(x1, y);
        path2.lineTo(x2, y);
      }
    }

    canvas.drawPath(path1, strandPaint1);
    canvas.drawPath(path2, strandPaint2);

    // Draw connecting lines and nucleotide dots
    final connectPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    final dotPaint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final dotPaint2 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    for (double y = 10; y < height - 10; y += 15) {
      final t = y / height;
      final angle1 = (t * 4 * math.pi) + (progress * 2 * math.pi);
      final angle2 = angle1 + math.pi;

      final x1 = center.dx + radius * math.cos(angle1);
      final x2 = center.dx + radius * math.cos(angle2);

      final point1 = Offset(x1, y);
      final point2 = Offset(x2, y);

      // Connection line
      canvas.drawLine(point1, point2, connectPaint);

      // Nucleotide dots
      canvas.drawCircle(point1, 4, dotPaint1);
      canvas.drawCircle(point2, 4, dotPaint2);

      if (showGlow) {
        final glowPaint1 = Paint()
          ..color = primaryColor.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        final glowPaint2 = Paint()
          ..color = secondaryColor.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(point1, 8, glowPaint1);
        canvas.drawCircle(point2, 8, glowPaint2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}