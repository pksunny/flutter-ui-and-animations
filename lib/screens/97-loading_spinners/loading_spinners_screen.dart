import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingSpinnersScreen extends StatefulWidget {
  const LoadingSpinnersScreen({Key? key}) : super(key: key);

  @override
  State<LoadingSpinnersScreen> createState() => _LoadingSpinnersScreenState();
}

class _LoadingSpinnersScreenState extends State<LoadingSpinnersScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<SpinnerData> spinners = [
    SpinnerData(
      name: "Neon Pulse",
      description: "Glowing neon circle with pulse effect",
      color: Colors.cyan,
    ),
    SpinnerData(
      name: "Galaxy Orbit",
      description: "Multiple orbiting particles",
      color: Colors.purple,
    ),
    SpinnerData(
      name: "Liquid Wave",
      description: "Smooth liquid-like animation",
      color: Colors.teal,
    ),
    SpinnerData(
      name: "Crystal Bloom",
      description: "Crystalline expanding pattern",
      color: Colors.pink,
    ),
    SpinnerData(
      name: "Digital Matrix",
      description: "Tech-inspired square pattern",
      color: Colors.green,
    ),
    SpinnerData(
      name: "Plasma Ring",
      description: "Electric ring with particles",
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
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
                      _currentIndex = index;
                    });
                  },
                  itemCount: spinners.length,
                  itemBuilder: (context, index) {
                    return _buildSpinnerPage(spinners[index]);
                  },
                ),
              ),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Amazing Spinners',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              background: Paint()
                ..shader = const LinearGradient(
                  colors: [Colors.cyan, Colors.purple, Colors.pink],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentIndex + 1} of ${spinners.length}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSpinnerPage(SpinnerData spinner) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: spinner.color.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: _buildSpinner(spinner),
        ),
        const SizedBox(height: 40),
        Text(
          spinner.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            spinner.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSpinner(SpinnerData spinner) {
    switch (spinner.name) {
      case "Neon Pulse":
        return NeonPulseSpinner(color: spinner.color);
      case "Galaxy Orbit":
        return GalaxyOrbitSpinner(color: spinner.color);
      case "Liquid Wave":
        return LiquidWaveSpinner(color: spinner.color);
      case "Crystal Bloom":
        return CrystalBloomSpinner(color: spinner.color);
      case "Digital Matrix":
        return DigitalMatrixSpinner(color: spinner.color);
      case "Plasma Ring":
        return PlasmaRingSpinner(color: spinner.color);
      default:
        return NeonPulseSpinner(color: spinner.color);
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentIndex > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Row(
            children: List.generate(
              spinners.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentIndex
                      ? spinners[_currentIndex].color
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _currentIndex < spinners.length - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class SpinnerData {
  final String name;
  final String description;
  final Color color;

  SpinnerData({
    required this.name,
    required this.description,
    required this.color,
  });
}

// Neon Pulse Spinner
class NeonPulseSpinner extends StatefulWidget {
  final Color color;

  const NeonPulseSpinner({Key? key, required this.color}) : super(key: key);

  @override
  State<NeonPulseSpinner> createState() => _NeonPulseSpinnerState();
}

class _NeonPulseSpinnerState extends State<NeonPulseSpinner>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseController]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * math.pi,
          child: CustomPaint(
            size: const Size(200, 200),
            painter: NeonPulsePainter(
              color: widget.color,
              pulseValue: _pulseController.value,
            ),
          ),
        );
      },
    );
  }
}

class NeonPulsePainter extends CustomPainter {
  final Color color;
  final double pulseValue;

  NeonPulsePainter({required this.color, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3 + pulseValue * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(center, radius * 0.8, glowPaint);

    // Main ring
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 + pulseValue * 2;

    canvas.drawCircle(center, radius * 0.6, ringPaint);

    // Inner dots
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8);
      final dotOffset = Offset(
        center.dx + math.cos(angle) * radius * 0.3,
        center.dy + math.sin(angle) * radius * 0.3,
      );

      final dotPaint = Paint()
        ..color = color.withOpacity(0.7 + pulseValue * 0.3);

      canvas.drawCircle(dotOffset, 3 + pulseValue * 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Galaxy Orbit Spinner
class GalaxyOrbitSpinner extends StatefulWidget {
  final Color color;

  const GalaxyOrbitSpinner({Key? key, required this.color}) : super(key: key);

  @override
  State<GalaxyOrbitSpinner> createState() => _GalaxyOrbitSpinnerState();
}

class _GalaxyOrbitSpinnerState extends State<GalaxyOrbitSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          size: const Size(200, 200),
          painter: GalaxyOrbitPainter(
            color: widget.color,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class GalaxyOrbitPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  GalaxyOrbitPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw orbiting particles
    for (int orbit = 0; orbit < 3; orbit++) {
      final orbitRadius = radius * (0.2 + orbit * 0.25);
      final particleCount = 3 + orbit;
      
      for (int i = 0; i < particleCount; i++) {
        final angle = (animationValue * 2 * math.pi) + 
                     (i * 2 * math.pi / particleCount) + 
                     (orbit * math.pi / 6);
        
        final particleOffset = Offset(
          center.dx + math.cos(angle) * orbitRadius,
          center.dy + math.sin(angle) * orbitRadius,
        );

        final particlePaint = Paint()
          ..color = color.withOpacity(1.0 - orbit * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

        canvas.drawCircle(particleOffset, 4 - orbit * 1, particlePaint);
      }
    }

    // Central core
    final corePaint = Paint()
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(center, 8, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Liquid Wave Spinner
class LiquidWaveSpinner extends StatefulWidget {
  final Color color;

  const LiquidWaveSpinner({Key? key, required this.color}) : super(key: key);

  @override
  State<LiquidWaveSpinner> createState() => _LiquidWaveSpinnerState();
}

class _LiquidWaveSpinnerState extends State<LiquidWaveSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          size: const Size(200, 200),
          painter: LiquidWavePainter(
            color: widget.color,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class LiquidWavePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  LiquidWavePainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final waveRadius = radius * (0.2 + i * 0.15);
      final opacity = 1.0 - (i * 0.15) - (animationValue * 0.3);
      
      if (opacity > 0) {
        final paint = Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        final animatedRadius = waveRadius + 
            (math.sin(animationValue * 2 * math.pi - i * 0.5) * 10);

        canvas.drawCircle(center, animatedRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Crystal Bloom Spinner
class CrystalBloomSpinner extends StatefulWidget {
  final Color color;

  const CrystalBloomSpinner({Key? key, required this.color}) : super(key: key);

  @override
  State<CrystalBloomSpinner> createState() => _CrystalBloomSpinnerState();
}

class _CrystalBloomSpinnerState extends State<CrystalBloomSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
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
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: CustomPaint(
            size: const Size(200, 200),
            painter: CrystalBloomPainter(
              color: widget.color,
              animationValue: _controller.value,
            ),
          ),
        );
      },
    );
  }
}

class CrystalBloomPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  CrystalBloomPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final length = radius * (0.3 + animationValue * 0.4);
      
      final start = Offset(
        center.dx + math.cos(angle) * radius * 0.1,
        center.dy + math.sin(angle) * radius * 0.1,
      );
      
      final end = Offset(
        center.dx + math.cos(angle) * length,
        center.dy + math.sin(angle) * length,
      );

      final paint = Paint()
        ..color = color.withOpacity(0.8)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, paint);

      // Crystal tips
      final tipPaint = Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(end, 5, tipPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Digital Matrix Spinner
class DigitalMatrixSpinner extends StatefulWidget {
  final Color color;

  const DigitalMatrixSpinner({Key? key, required this.color}) : super(key: key);

  @override
  State<DigitalMatrixSpinner> createState() => _DigitalMatrixSpinnerState();
}

class _DigitalMatrixSpinnerState extends State<DigitalMatrixSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          size: const Size(200, 200),
          painter: DigitalMatrixPainter(
            color: widget.color,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class DigitalMatrixPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  DigitalMatrixPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final squareSize = 20.0;

    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        final x = center.dx - 2 * squareSize + col * squareSize;
        final y = center.dy - 2 * squareSize + row * squareSize;
        
        final distance = math.sqrt(
          math.pow(col - 2, 2) + math.pow(row - 2, 2)
        );
        
        final delay = distance * 0.2;
        final phase = (animationValue + delay) % 1.0;
        final opacity = math.sin(phase * math.pi);

        if (opacity > 0) {
          final paint = Paint()
            ..color = color.withOpacity(opacity)
            ..style = PaintingStyle.fill;

          final rect = Rect.fromLTWH(
            x - squareSize / 2,
            y - squareSize / 2,
            squareSize * 0.8,
            squareSize * 0.8,
          );

          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(2)),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Plasma Ring Spinner
class PlasmaRingSpinner extends StatefulWidget {
  final Color color;

  const PlasmaRingSpinner({Key? key, required this.color}) : super(key: key);

  @override
  State<PlasmaRingSpinner> createState() => _PlasmaRingSpinnerState();
}

class _PlasmaRingSpinnerState extends State<PlasmaRingSpinner>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _plasmaController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _plasmaController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _plasmaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _plasmaController]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * math.pi,
          child: CustomPaint(
            size: const Size(200, 200),
            painter: PlasmaRingPainter(
              color: widget.color,
              plasmaValue: _plasmaController.value,
            ),
          ),
        );
      },
    );
  }
}

class PlasmaRingPainter extends CustomPainter {
  final Color color;
  final double plasmaValue;

  PlasmaRingPainter({required this.color, required this.plasmaValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Main ring
    final ringPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius * 0.6, ringPaint);

    // Plasma particles
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi * 2 / 12) + (plasmaValue * math.pi * 2);
      final particleRadius = radius * 0.6 + 
          math.sin(plasmaValue * 4 * math.pi + i) * 15;
      
      final particleOffset = Offset(
        center.dx + math.cos(angle) * particleRadius,
        center.dy + math.sin(angle) * particleRadius,
      );

      final particlePaint = Paint()
        ..color = color.withOpacity(0.6 + math.sin(plasmaValue * 2 * math.pi + i) * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(particleOffset, 3, particlePaint);
    }

    // Electric arcs
    final arcPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    for (int i = 0; i < 3; i++) {
      final startAngle = plasmaValue * 2 * math.pi + i * 2;
      final endAngle = startAngle + 1;
      
      final start = Offset(
        center.dx + math.cos(startAngle) * radius * 0.4,
        center.dy + math.sin(startAngle) * radius * 0.4,
      );
      
      final end = Offset(
        center.dx + math.cos(endAngle) * radius * 0.8,
        center.dy + math.sin(endAngle) * radius * 0.8,
      );

      canvas.drawLine(start, end, arcPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}