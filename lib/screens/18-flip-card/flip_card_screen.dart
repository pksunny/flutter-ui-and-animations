import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class FlipCardAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
              Color(0xFFf5576c),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LiquidGlassFlipCard(
                        frontChild: _buildCardContent(
                          icon: Icons.credit_card,
                          title: 'Payment',
                          subtitle: 'Secure & Fast',
                          color: Colors.blue.withOpacity(0.3),
                        ),
                        backChild: _buildCardContent(
                          icon: Icons.check_circle,
                          title: 'Verified',
                          subtitle: '256-bit SSL',
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: 30),
                      LiquidGlassFlipCard(
                        frontChild: _buildCardContent(
                          icon: Icons.account_balance_wallet,
                          title: 'Wallet',
                          subtitle: '\$2,450.00',
                          color: Colors.purple.withOpacity(0.3),
                        ),
                        backChild: _buildCardContent(
                          icon: Icons.trending_up,
                          title: 'Growth',
                          subtitle: '+12.5%',
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: 30),
                      LiquidGlassFlipCard(
                        frontChild: _buildCardContent(
                          icon: Icons.person,
                          title: 'Profile',
                          subtitle: 'John Doe',
                          color: Colors.teal.withOpacity(0.3),
                        ),
                        backChild: _buildCardContent(
                          icon: Icons.settings,
                          title: 'Settings',
                          subtitle: 'Customize',
                          color: Colors.indigo.withOpacity(0.3),
                        ),
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
  }

  Widget _buildCardContent({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class LiquidGlassFlipCard extends StatefulWidget {
  final Widget frontChild;
  final Widget backChild;
  final Duration duration;

  const LiquidGlassFlipCard({
    Key? key,
    required this.frontChild,
    required this.backChild,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _LiquidGlassFlipCardState createState() => _LiquidGlassFlipCardState();
}

class _LiquidGlassFlipCardState extends State<LiquidGlassFlipCard>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _liquidController;
  
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _liquidAnimation;
  
  bool _isShowingFront = true;

  @override
  void initState() {
    super.initState();
    
    _flipController = AnimationController(
      duration: Duration(milliseconds: 1200), // Slower animation
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _liquidController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutBack, // Smoother curve
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _liquidAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _liquidController,
      curve: Curves.linear,
    ));

    // Start continuous animations
    _glowController.repeat(reverse: true);
    _liquidController.repeat();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    _liquidController.dispose();
    super.dispose();
  }

  void _flip() {
    if (!_flipController.isAnimating) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
      
      if (_flipController.value == 0.0) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _flipAnimation,
          _scaleAnimation,
          _glowAnimation,
          _liquidAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 300,
              height: 180,
              child: Stack(
                children: [
                  // Liquid background effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomPaint(
                        painter: LiquidPainter(
                          animation: _liquidAnimation.value,
                          glowIntensity: _glowAnimation.value,
                        ),
                      ),
                    ),
                  ),
                  // Glass card
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_flipAnimation.value * math.pi),
                    child: _flipAnimation.value <= 0.5
                        ? _buildGlassCard(widget.frontChild, false)
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child: _buildGlassCard(widget.backChild, true),
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

  Widget _buildGlassCard(Widget child, bool isBack) {
    return Container(
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(-5, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class LiquidPainter extends CustomPainter {
  final double animation;
  final double glowIntensity;

  LiquidPainter({required this.animation, required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(Colors.blue.withOpacity(0.3), Colors.purple.withOpacity(0.3), animation)!,
          Color.lerp(Colors.purple.withOpacity(0.2), Colors.pink.withOpacity(0.2), animation)!,
          Color.lerp(Colors.pink.withOpacity(0.1), Colors.blue.withOpacity(0.1), animation)!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create liquid wave effect
    final path = Path();
    final wave1 = 20 * math.sin((animation * 4 * math.pi) + 0);
    final wave2 = 15 * math.sin((animation * 6 * math.pi) + math.pi / 3);
    final wave3 = 10 * math.sin((animation * 8 * math.pi) + math.pi / 2);

    path.moveTo(0, size.height * 0.3 + wave1);
    
    for (double x = 0; x <= size.width; x += 2) {
      final y1 = size.height * 0.3 + wave1 * math.sin((x / size.width) * 2 * math.pi + animation * 4 * math.pi);
      final y2 = size.height * 0.6 + wave2 * math.sin((x / size.width) * 3 * math.pi + animation * 6 * math.pi);
      final y3 = size.height * 0.8 + wave3 * math.sin((x / size.width) * 4 * math.pi + animation * 8 * math.pi);
      
      path.lineTo(x, (y1 + y2 + y3) / 3);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Add glow effect
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.1 * glowIntensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawPath(path, glowPaint);

    // Add sparkle effects
    final sparkleCount = 8;
    final sparklePaint = Paint()
      ..color = Colors.white.withOpacity(0.6 * glowIntensity)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < sparkleCount; i++) {
      final x = (size.width / sparkleCount) * i + (20 * math.sin(animation * 3 * math.pi + i));
      final y = size.height * 0.2 + (30 * math.sin(animation * 4 * math.pi + i * 0.5));
      
      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        final sparkleSize = 3 + 2 * math.sin(animation * 6 * math.pi + i);
        canvas.drawCircle(Offset(x, y), sparkleSize, sparklePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}