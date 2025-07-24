import 'package:flutter/material.dart';

class ElevatorStyleTextReveal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FUTURISTIC REVEAL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                  color: Colors.cyan.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 60),
              WindowSlideReveal(
                width: 350,
                height: 250,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00F5FF),
                        Color(0xFF9D00FF),
                        Color(0xFF00FFA1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 60,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'REVEALED!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Amazing content inside',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'TAP TO REVEAL',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WindowSlideReveal extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final Duration duration;

  const WindowSlideReveal({
    Key? key,
    required this.child,
    this.width = 300,
    this.height = 200,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _WindowSlideRevealState createState() => _WindowSlideRevealState();
}

class _WindowSlideRevealState extends State<WindowSlideReveal>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _glowController;
  late AnimationController _scaleController;
  
  late Animation<double> _leftSlideAnimation;
  late Animation<double> _rightSlideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _leftSlideAnimation = Tween<double>(
      begin: 0.0,
      end: -widget.width / 2 - 20,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    ));

    _rightSlideAnimation = Tween<double>(
      begin: 0.0,
      end: widget.width / 2 + 20,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _glowController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    setState(() {
      _isRevealed = !_isRevealed;
    });

    if (_isRevealed) {
      _slideController.forward();
      _scaleController.forward();
    } else {
      _slideController.reverse();
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleReveal,
      child: Container(
        width: widget.width + 100,
        height: widget.height + 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect background
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: widget.width + 40,
                  height: widget.height + 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2 * _glowAnimation.value),
                        blurRadius: 50,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                );
              },
            ),
            
            // Revealed content
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: widget.child,
                  ),
                );
              },
            ),

            // Left door
            AnimatedBuilder(
              animation: _leftSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_leftSlideAnimation.value, 0),
                  child: ClipPath(
                    clipper: LeftDoorClipper(),
                    child: Container(
                      width: widget.width / 2,
                      height: widget.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E1E3F),
                            Color(0xFF2A2A5A),
                            Color(0xFF1A1A35),
                          ],
                        ),
                        border: Border(
                          right: BorderSide(
                            color: Colors.cyan.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(-5, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Circuit pattern
                          Positioned.fill(
                            child: CustomPaint(
                              painter: CircuitPainter(Colors.cyan.withOpacity(0.3)),
                            ),
                          ),
                          // Door handle
                          Positioned(
                            right: 15,
                            top: widget.height / 2 - 15,
                            child: Container(
                              width: 30,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.cyan.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyan.withOpacity(0.5),
                                    blurRadius: 8,
                                  ),
                                ],
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

            // Right door
            AnimatedBuilder(
              animation: _rightSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_rightSlideAnimation.value, 0),
                  child: ClipPath(
                    clipper: RightDoorClipper(),
                    child: Container(
                      width: widget.width / 2,
                      height: widget.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E1E3F),
                            Color(0xFF2A2A5A),
                            Color(0xFF1A1A35),
                          ],
                        ),
                        border: Border(
                          left: BorderSide(
                            color: Colors.cyan.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(5, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Circuit pattern
                          Positioned.fill(
                            child: CustomPaint(
                              painter: CircuitPainter(Colors.cyan.withOpacity(0.3)),
                            ),
                          ),
                          // Door handle
                          Positioned(
                            left: 15,
                            top: widget.height / 2 - 15,
                            child: Container(
                              width: 30,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.cyan.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyan.withOpacity(0.5),
                                    blurRadius: 8,
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}

class LeftDoorClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: Radius.circular(20),
      bottomLeft: Radius.circular(20),
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RightDoorClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CircuitPainter extends CustomPainter {
  final Color color;

  CircuitPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw circuit-like patterns
    Path path = Path();
    
    // Vertical lines
    for (double x = 20; x < size.width; x += 30) {
      path.moveTo(x, 10);
      path.lineTo(x, size.height - 10);
    }
    
    // Horizontal lines
    for (double y = 20; y < size.height; y += 40) {
      path.moveTo(10, y);
      path.lineTo(size.width - 10, y);
    }
    
    // Add some dots for circuit nodes
    paint.style = PaintingStyle.fill;
    for (double x = 20; x < size.width; x += 30) {
      for (double y = 20; y < size.height; y += 40) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
    
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}