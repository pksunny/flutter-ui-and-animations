import 'package:flutter/material.dart';
import 'dart:math' as math;

class BlobbyButtonExpansionScreen extends StatefulWidget {
  @override
  _BlobbyButtonExpansionScreenState createState() => _BlobbyButtonExpansionScreenState();
}

class _BlobbyButtonExpansionScreenState extends State<BlobbyButtonExpansionScreen> with TickerProviderStateMixin {
  int? _activeButton;

  void _setActiveButton(int? index) {
    setState(() {
      _activeButton = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E27),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B0E27),
              Color(0xFF1A1F3A),
              Color(0xFF2E2A5B),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: const Text(
                    'Blobby Button\nExpansions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: RippleWaveButton(
                          index: 3,
                          isActive: _activeButton == 3,
                          onTap: () => _setActiveButton(_activeButton == 3 ? null : 3),
                        ),
                      ),
                      SizedBox(height: 100),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: SpiralGalaxyButton(
                          index: 4,
                          isActive: _activeButton == 4,
                          onTap: () => _setActiveButton(_activeButton == 4 ? null : 4),
                        ),
                      ),
                      SizedBox(height: 100),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: BouncingBlobButton(
                          index: 5,
                          isActive: _activeButton == 5,
                          onTap: () => _setActiveButton(_activeButton == 5 ? null : 5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RippleWaveButton extends StatefulWidget {
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const RippleWaveButton({
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  _RippleWaveButtonState createState() => _RippleWaveButtonState();
}

class _RippleWaveButtonState extends State<RippleWaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(RippleWaveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RippleWavePainter(_waveAnimation.value),
          child: Container(
            width: 60 + (180 * _waveAnimation.value),
            height: 60 + (180 * _waveAnimation.value),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                child: _buildContent(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (!widget.isActive) {
      return Center(
        child: Icon(Icons.radio_button_unchecked, color: Colors.white, size: 24),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.waves, color: Colors.white, size: 28),
                    SizedBox(height: 8),
                    Text(
                      'Ripple Wave',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Concentric wave expansion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RippleWavePainter extends CustomPainter {
  final double progress;

  RippleWavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final waveProgress = (progress - (i * 0.3)).clamp(0.0, 1.0);
      final radius = maxRadius * waveProgress;
      final opacity = (1.0 - waveProgress) * 0.3;

      final paint = Paint()
        ..color = Color(0xFF9B59B6).withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawCircle(center, radius, paint);
    }

    final mainPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
      ).createShader(Rect.fromCircle(center: center, radius: 30))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 30, mainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


// Spiral Galaxy Button - Rotating spiral expansion
class SpiralGalaxyButton extends StatefulWidget {
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const SpiralGalaxyButton({
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  _SpiralGalaxyButtonState createState() => _SpiralGalaxyButtonState();
}

class _SpiralGalaxyButtonState extends State<SpiralGalaxyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(SpiralGalaxyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SpiralGalaxyPainter(_controller.value),
          child: Container(
            width: 60 + (200 * _controller.value),
            height: 60 + (200 * _controller.value),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                child: _buildContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (!widget.isActive) {
      return Center(
        child: Icon(Icons.brightness_1, color: Colors.white, size: 24),
      );
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 28),
            SizedBox(height: 8),
            Text(
              'Spiral Galaxy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Rotating spiral magic',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for spiral galaxy
class SpiralGalaxyPainter extends CustomPainter {
  final double progress;

  SpiralGalaxyPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw spiral arms
    for (int arm = 0; arm < 3; arm++) {
      final path = Path();
      final startAngle = (arm * 2 * math.pi / 3) + (progress * 2 * math.pi);
      
      path.moveTo(center.dx, center.dy);
      
      for (double t = 0; t < progress * 4; t += 0.1) {
        final angle = startAngle + t;
        final radius = t * maxRadius / 4;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        path.lineTo(x, y);
      }
      
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Color(0xFFE74C3C).withOpacity(0.8),
            Color(0xFFF39C12).withOpacity(0.4),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
        ..style= PaintingStyle.stroke
        ..strokeWidth= 2.0;
      
      canvas.drawPath(path, paint);
    }

    // Draw center
    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [Color(0xFFE74C3C), Color(0xFFF39C12)],
      ).createShader(Rect.fromCircle(center: center, radius: 30))
      ..style= PaintingStyle.fill;

    canvas.drawCircle(center, 30, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Bouncing Blob Button - Playful bouncing expansion
class BouncingBlobButton extends StatefulWidget {
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const BouncingBlobButton({
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  _BouncingBlobButtonState createState() => _BouncingBlobButtonState();
}

class _BouncingBlobButtonState extends State<BouncingBlobButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
  }

  @override
  void didUpdateWidget(BouncingBlobButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_bounceAnimation.value * 4),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30 - (_bounceAnimation.value * 10)),
              gradient: LinearGradient(
                colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1ABC9C).withOpacity(0.3),
                  blurRadius: 20 + (_bounceAnimation.value * 30),
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(30 - (_bounceAnimation.value * 10)),
                child: _buildContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (!widget.isActive) {
      return Center(
        child: Icon(Icons.bubble_chart, color: Colors.white, size: 24),
      );
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_basketball, color: Colors.white, size: 16),
          SizedBox(height: 4),
          Text(
            'Bouncing\nBlob',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}