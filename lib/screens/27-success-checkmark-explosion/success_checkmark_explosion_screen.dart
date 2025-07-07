import 'package:flutter/material.dart';
import 'dart:math' as math;

class SuccessCheckmarkExplosionScreen extends StatefulWidget {
  @override
  _SuccessCheckmarkExplosionScreenState createState() => _SuccessCheckmarkExplosionScreenState();
}

class _SuccessCheckmarkExplosionScreenState extends State<SuccessCheckmarkExplosionScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _explosionController;
  late AnimationController _backgroundController;
  late AnimationController _slideController;
  
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _explosionAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _slideAnimation;
  
  bool _showExplosion = false;
  bool _showSuccess = false;
  List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    _checkmarkController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _explosionController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));
    
    _explosionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _explosionController,
      curve: Curves.easeOutCubic,
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    _checkmarkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 300), () {
          _startExplosion();
        });
      }
    });
    
    _explosionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showSuccess = true;
        });
        _slideController.forward();
      }
    });
    
    _generateParticles();
  }

  void _generateParticles() {
    final random = math.Random();
    _particles = List.generate(60, (index) {
      final angle = (index / 60) * 2 * math.pi;
      final velocity = random.nextDouble() * 200 + 100;
      return Particle(
        x: 0.0,
        y: 0.0,
        dx: math.cos(angle) * velocity,
        dy: math.sin(angle) * velocity,
        color: _getRandomColor(),
        size: random.nextDouble() * 12 + 6,
        rotation: random.nextDouble() * 2 * math.pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.3,
        gravity: random.nextDouble() * 50 + 20,
      );
    });
  }

  Color _getRandomColor() {
    final colors = [
      Color(0xFFFFD700), // Gold
      Color(0xFF00FF7F), // Spring Green
      Color(0xFF1E90FF), // Dodger Blue
      Color(0xFFFF69B4), // Hot Pink
      Color(0xFF9370DB), // Medium Purple
      Color(0xFFFF4500), // Orange Red
      Color(0xFF00CED1), // Dark Turquoise
      Color(0xFFFFB6C1), // Light Pink
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  void _startExplosion() {
    setState(() {
      _showExplosion = true;
    });
    _explosionController.forward();
    _backgroundController.forward();
  }

  void _startPurchase() {
    setState(() {
      _showExplosion = false;
      _showSuccess = false;
    });
    _checkmarkController.reset();
    _explosionController.reset();
    _backgroundController.reset();
    _slideController.reset();
    _generateParticles();
    
    // Simulate payment processing
    Future.delayed(Duration(milliseconds: 500), () {
      _checkmarkController.forward();
    });
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _explosionController.dispose();
    _backgroundController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _checkmarkController,
          _explosionController,
          _backgroundController,
          _slideController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color.lerp(Color(0xFF0A0A0A), Color(0xFF1B5E20), 
                      math.max(0.0, math.min(1.0, _backgroundAnimation.value * 0.6)))!,
                  Color(0xFF0A0A0A),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Explosion pulse rings
                if (_showExplosion)
                  ..._buildPulseRings(),
                
                // Particles
                if (_showExplosion)
                  ..._particles.map((particle) => _buildParticle(particle)),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product card (before purchase)
                      if (!_showExplosion && _checkmarkAnimation.value == 0)
                        _buildProductCard(),
                      
                      // Success animation
                      if (_checkmarkAnimation.value > 0 || _showExplosion)
                        _buildSuccessAnimation(),
                      
                      // Success details
                      if (_showSuccess)
                        _buildSuccessDetails(),
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

  Widget _buildProductCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF333333)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Product icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(height: 20),
          
          // Product name
          Text(
            'Premium Package',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          
          // Product description
          Text(
            'Unlock all premium features',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$29.99',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              Text(
                '/month',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          
          // Purchase button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _startPurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 8,
              ),
              child: Text(
                'Purchase Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Column(
      children: [
        // Checkmark circle
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4CAF50),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF4CAF50).withOpacity(0.6),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Transform.scale(
            scale: math.max(0.0, math.min(1.0, _checkmarkAnimation.value)),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 70,
            ),
          ),
        ),
        SizedBox(height: 30),
        
        // Success text
        AnimatedOpacity(
          opacity: math.max(0.0, math.min(1.0, _checkmarkAnimation.value)),
          duration: Duration(milliseconds: 300),
          child: Text(
            'Payment Successful!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessDetails() {
    return Transform.translate(
      offset: Offset(0, (1 - _slideAnimation.value) * 100),
      child: AnimatedOpacity(
        opacity: math.max(0.0, math.min(1.0, _slideAnimation.value)),
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            SizedBox(height: 40),
            
            // Purchase details
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF333333)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Premium Package',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$29.99',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction ID',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '#TXN123456789',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Download receipt
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF333333),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download, size: 18),
                      SizedBox(width: 8),
                      Text('Receipt'),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Continue to app
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Continue'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPulseRings() {
    return [
      for (int i = 0; i < 3; i++)
        Center(
          child: Container(
            width: (200 + i * 100) * math.max(0.0, math.min(1.0, _explosionAnimation.value)),
            height: (200 + i * 100) * math.max(0.0, math.min(1.0, _explosionAnimation.value)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF4CAF50).withOpacity(
                  math.max(0.0, math.min(1.0, (0.5 - i * 0.15) * (1 - _explosionAnimation.value)))
                ),
                width: 2,
              ),
            ),
          ),
        ),
    ];
  }

  Widget _buildParticle(Particle particle) {
    final progress = math.max(0.0, math.min(1.0, _explosionAnimation.value));
    final currentX = particle.dx * progress;
    final currentY = particle.dy * progress + (particle.gravity * progress * progress);
    final currentRotation = particle.rotation + (particle.rotationSpeed * progress);
    final opacity = math.max(0.0, math.min(1.0, 1 - progress));
    
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 + currentX,
      top: MediaQuery.of(context).size.height / 2 + currentY,
      child: Transform.rotate(
        angle: currentRotation,
        child: Container(
          width: particle.size,
          height: particle.size,
          decoration: BoxDecoration(
            color: particle.color.withOpacity(opacity),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: particle.color.withOpacity(opacity * 0.5),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double dx;
  final double dy;
  final Color color;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final double gravity;

  Particle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.gravity,
  });
}