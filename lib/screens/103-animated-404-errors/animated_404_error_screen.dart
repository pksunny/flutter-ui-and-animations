import 'package:flutter/material.dart';
import 'dart:math' as math;

// Demo page to showcase different error types
class Animated404ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      appBar: AppBar(
        title: const Text('Animated Error Pages'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildErrorButton(
              context,
              'Show 404 Error',
              () => Navigator.push(context, _createRoute(Animated404Page())),
              Colors.purple,
            ),
            const SizedBox(height: 20),
            _buildErrorButton(
              context,
              'Show 500 Error',
              () => Navigator.push(context, _createRoute(Animated500Page())),
              Colors.red,
            ),
            const SizedBox(height: 20),
            _buildErrorButton(
              context,
              'Show 403 Error',
              () => Navigator.push(context, _createRoute(Animated403Page())),
              Colors.orange,
            ),
            const SizedBox(height: 20),
            _buildErrorButton(
              context,
              'Show Network Error',
              () => Navigator.push(context, _createRoute(AnimatedNetworkErrorPage())),
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorButton(BuildContext context, String text, VoidCallback onPressed, Color color) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

// Base error page widget with common functionality
abstract class BaseErrorPage extends StatefulWidget {
  final String errorCode;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;

  const BaseErrorPage({
    Key? key,
    required this.errorCode,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);
}

abstract class BaseErrorPageState<T extends BaseErrorPage> extends State<T>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_floatingController);
  }

  void _startAnimations() {
    _mainController.forward();
    _floatingController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget buildCustomIcon();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0A0B),
              widget.primaryColor.withOpacity(0.1),
              const Color(0xFF0A0A0B),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildFloatingParticle(index)),
            
            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Custom animated icon
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: buildCustomIcon(),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Error code
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_pulseController.value * 0.05),
                                child: Text(
                                  widget.errorCode,
                                  style: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [
                                          widget.primaryColor,
                                          widget.secondaryColor,
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                      ),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 30,
                                        color: widget.primaryColor.withOpacity(0.5),
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Title
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 10),
                          
                          // Subtitle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              widget.subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildActionButton(
                                'Go Home',
                                widget.primaryColor,
                                () => Navigator.of(context).popUntil((route) => route.isFirst),
                              ),
                              const SizedBox(width: 20),
                              _buildActionButton(
                                'Try Again',
                                Colors.white.withOpacity(0.2),
                                () => Navigator.of(context).pop(),
                                isOutlined: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    final size = 2.0 + random.nextDouble() * 4;
    final initialX = random.nextDouble();
    final initialY = random.nextDouble();
    final duration = 3000 + random.nextInt(2000);
    
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final progress = (_floatingController.value + (index * 0.1)) % 1.0;
        return Positioned(
          left: MediaQuery.of(context).size.width * (initialX + math.sin(progress * 2 * math.pi) * 0.1),
          top: MediaQuery.of(context).size.height * (initialY + math.cos(progress * 2 * math.pi) * 0.05),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.primaryColor.withOpacity(0.3 + progress * 0.4),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed, {bool isOutlined = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: isOutlined ? null : LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: isOutlined ? Border.all(color: Colors.white.withOpacity(0.3), width: 1) : null,
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isOutlined ? Colors.white : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// 404 Not Found Page
class Animated404Page extends BaseErrorPage {
  Animated404Page({Key? key})
      : super(
          key: key,
          errorCode: '404',
          title: 'Page Not Found',
          subtitle: 'The page you\'re looking for seems to have wandered off into the digital void.',
          primaryColor: const Color(0xFF8B5CF6),
          secondaryColor: const Color(0xFFEC4899),
        );

  @override
  _Animated404PageState createState() => _Animated404PageState();
}

class _Animated404PageState extends BaseErrorPageState<Animated404Page> {
  @override
  Widget buildCustomIcon() {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CustomPaint(
                    painter: DottedCirclePainter(
                      color: widget.primaryColor,
                      progress: _floatingController.value,
                    ),
                  ),
                ),
              ),
              // Inner content
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.primaryColor.withOpacity(0.2),
                      widget.secondaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 500 Server Error Page
class Animated500Page extends BaseErrorPage {
  Animated500Page({Key? key})
      : super(
          key: key,
          errorCode: '500',
          title: 'Server Error',
          subtitle: 'Something went wrong on our end. Our engineers are working to fix it.',
          primaryColor: const Color(0xFFEF4444),
          secondaryColor: const Color(0xFFDC2626),
        );

  @override
  _Animated500PageState createState() => _Animated500PageState();
}

class _Animated500PageState extends BaseErrorPageState<Animated500Page> {
  @override
  Widget buildCustomIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing background
              Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.2),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
              // Warning icon
              Icon(
                Icons.warning_rounded,
                size: 50,
                color: widget.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

// 403 Forbidden Page
class Animated403Page extends BaseErrorPage {
  Animated403Page({Key? key})
      : super(
          key: key,
          errorCode: '403',
          title: 'Access Forbidden',
          subtitle: 'You don\'t have permission to access this resource.',
          primaryColor: const Color(0xFFF59E0B),
          secondaryColor: const Color(0xFFD97706),
        );

  @override
  _Animated403PageState createState() => _Animated403PageState();
}

class _Animated403PageState extends BaseErrorPageState<Animated403Page> {
  @override
  Widget buildCustomIcon() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lock body
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              // Lock shackle
              Positioned(
                top: 20,
                child: Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.primaryColor,
                      width: 4,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Key hole
              Positioned(
                bottom: 30,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Network Error Page
class AnimatedNetworkErrorPage extends BaseErrorPage {
  AnimatedNetworkErrorPage({Key? key})
      : super(
          key: key,
          errorCode: 'NET',
          title: 'Network Error',
          subtitle: 'Check your internet connection and try again.',
          primaryColor: const Color(0xFF3B82F6),
          secondaryColor: const Color(0xFF1D4ED8),
        );

  @override
  _AnimatedNetworkErrorPageState createState() => _AnimatedNetworkErrorPageState();
}

class _AnimatedNetworkErrorPageState extends BaseErrorPageState<AnimatedNetworkErrorPage> {
  @override
  Widget buildCustomIcon() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: NetworkIconPainter(
              color: widget.primaryColor,
              progress: _floatingController.value,
            ),
          ),
        );
      },
    );
  }
}

// Custom painters
class DottedCirclePainter extends CustomPainter {
  final Color color;
  final double progress;

  DottedCirclePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const dotCount = 12;
    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi + (progress * 2 * math.pi);
      final dotCenter = Offset(
        center.dx + radius * 0.8 * math.cos(angle),
        center.dy + radius * 0.8 * math.sin(angle),
      );
      
      final opacity = (math.sin(progress * 2 * math.pi + i * 0.5) + 1) / 2;
      paint.color = color.withOpacity(opacity * 0.8);
      canvas.drawCircle(dotCenter, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NetworkIconPainter extends CustomPainter {
  final Color color;
  final double progress;

  NetworkIconPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw signal arcs
    for (int i = 1; i <= 3; i++) {
      final arcProgress = (progress + i * 0.2) % 1.0;
      final opacity = math.sin(arcProgress * math.pi);
      paint.color = color.withOpacity(opacity * 0.8);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: i * 15.0),
        -math.pi / 4,
        math.pi / 2,
        false,
        paint,
      );
    }

    // Draw base
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}