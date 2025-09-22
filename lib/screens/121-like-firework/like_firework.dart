import 'package:flutter/material.dart';
import 'dart:math' as math;

class LikeFirework extends StatefulWidget {
  @override
  _LikeFireworkState createState() => _LikeFireworkState();
}

class _LikeFireworkState extends State<LikeFirework> {
  int likeCount = 1247;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fireworks Like Button',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tap the heart to see magic! ✨',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 60),
              FireworksLikeButton(
                onLikeChanged: (isLiked) {
                  setState(() {
                    likeCount += isLiked ? 1 : -1;
                  });
                },
                likeCount: likeCount,
                size: 80,
                fireworksCount: 12,
                fireworksColors: [
                  Colors.pink,
                  Colors.purple,
                  Colors.blue,
                  Colors.cyan,
                  Colors.yellow,
                  Colors.orange,
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Try different configurations:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  FireworksLikeButton(
                    size: 60,
                    fireworksCount: 8,
                    fireworksColors: [Colors.red, Colors.orange, Colors.yellow],
                    buttonColor: Colors.red,
                  ),
                  FireworksLikeButton(
                    size: 60,
                    fireworksCount: 15,
                    fireworksColors: [Colors.blue, Colors.cyan, Colors.teal],
                    buttonColor: Colors.blue,
                  ),
                  FireworksLikeButton(
                    size: 60,
                    fireworksCount: 10,
                    fireworksColors: [Colors.green, Colors.lime, Colors.lightGreen],
                    buttonColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🎆 Extraordinary Fireworks Like Button Widget
/// 
/// This widget creates a magical like button that shoots fireworks when tapped.
/// Features:
/// - Stunning heart animation with scale and color transitions
/// - Customizable fireworks explosion with multiple particles
/// - Beautiful gradient effects and glow
/// - Fully customizable colors, size, and particle count
/// - Production-ready with smooth 60fps animations
class FireworksLikeButton extends StatefulWidget {
  /// Callback when like state changes
  final ValueChanged<bool>? onLikeChanged;
  
  /// Current like count to display
  final int? likeCount;
  
  /// Size of the like button
  final double size;
  
  /// Number of firework particles
  final int fireworksCount;
  
  /// Colors for firework particles
  final List<Color> fireworksColors;
  
  /// Main button color when liked
  final Color buttonColor;
  
  /// Duration of fireworks animation
  final Duration fireworksDuration;
  
  /// Initial liked state
  final bool initialLiked;

  const FireworksLikeButton({
    Key? key,
    this.onLikeChanged,
    this.likeCount,
    this.size = 60.0,
    this.fireworksCount = 10,
    this.fireworksColors = const [
      Colors.pink,
      Colors.purple,
      Colors.blue,
      Colors.cyan,
      Colors.yellow,
      Colors.orange,
    ],
    this.buttonColor = Colors.pink,
    this.fireworksDuration = const Duration(milliseconds: 1200),
    this.initialLiked = false,
  }) : super(key: key);

  @override
  _FireworksLikeButtonState createState() => _FireworksLikeButtonState();
}

class _FireworksLikeButtonState extends State<FireworksLikeButton>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _fireworksController;
  late Animation<double> _heartScale;
  late Animation<double> _heartOpacity;
  late Animation<Color?> _heartColor;
  
  bool _isLiked = false;
  List<FireworkParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialLiked;
    
    // Heart animation controller
    _heartController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Fireworks animation controller
    _fireworksController = AnimationController(
      duration: widget.fireworksDuration,
      vsync: this,
    );
    
    // Heart scale animation - bouncy effect
    _heartScale = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.elasticOut,
    ));
    
    // Heart opacity animation
    _heartOpacity = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));
    
    // Heart color animation
    _heartColor = ColorTween(
      begin: Colors.grey[600],
      end: widget.buttonColor,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    _initializeParticles();
  }

  /// Initialize firework particles with random properties
  void _initializeParticles() {
    final random = math.Random();
    _particles = List.generate(widget.fireworksCount, (index) {
      final angle = (index / widget.fireworksCount) * 2 * math.pi + 
                   random.nextDouble() * 0.5;
      final velocity = 80.0 + random.nextDouble() * 60.0;
      
      return FireworkParticle(
        angle: angle,
        velocity: velocity,
        color: widget.fireworksColors[
          random.nextInt(widget.fireworksColors.length)
        ],
        size: 3.0 + random.nextDouble() * 4.0,
        life: 0.8 + random.nextDouble() * 0.4,
      );
    });
  }

  /// Handle like button tap with magical animations
  void _handleLikeTap() async {
    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      // Start heart animation
      _heartController.forward();
      
      // Start fireworks after a slight delay
      await Future.delayed(Duration(milliseconds: 100));
      _fireworksController.forward();
    } else {
      _heartController.reverse();
      _fireworksController.reset();
    }

    // Notify parent about like change
    widget.onLikeChanged?.call(_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleLikeTap,
      child: Container(
        width: widget.size * 2.5,
        height: widget.size * 2.5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fireworks layer
            AnimatedBuilder(
              animation: _fireworksController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size * 2.5, widget.size * 2.5),
                  painter: FireworksPainter(
                    particles: _particles,
                    progress: _fireworksController.value,
                  ),
                );
              },
            ),
            
            // Heart button with glow effect
            AnimatedBuilder(
              animation: Listenable.merge([_heartController, _fireworksController]),
              builder: (context, child) {
                return Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: _isLiked ? [
                      BoxShadow(
                        color: widget.buttonColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ] : null,
                  ),
                  child: Transform.scale(
                    scale: _heartScale.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _isLiked ? RadialGradient(
                          colors: [
                            widget.buttonColor.withOpacity(0.8),
                            widget.buttonColor.withOpacity(0.3),
                          ],
                        ) : null,
                        color: _isLiked ? null : Colors.grey[800],
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: widget.size * 0.5,
                        color: _heartColor.value,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // Like count display
            if (widget.likeCount != null)
              Positioned(
                bottom: 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isLiked ? widget.buttonColor : Colors.grey[700],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _formatLikeCount(widget.likeCount!),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Format like count for display (e.g., 1.2K, 1.5M)
  String _formatLikeCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  @override
  void dispose() {
    _heartController.dispose();
    _fireworksController.dispose();
    super.dispose();
  }
}

/// 🎆 Firework Particle Model
/// 
/// Represents a single firework particle with physics properties
class FireworkParticle {
  final double angle;      // Launch angle in radians
  final double velocity;   // Initial velocity
  final Color color;       // Particle color
  final double size;       // Particle size
  final double life;       // Particle lifetime (0.0 to 1.0)

  FireworkParticle({
    required this.angle,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
  });
}

/// 🎨 Custom Fireworks Painter
/// 
/// Renders beautiful firework particles with realistic physics
class FireworksPainter extends CustomPainter {
  final List<FireworkParticle> particles;
  final double progress;

  FireworksPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    for (final particle in particles) {
      // Calculate particle position based on physics
      final time = progress * particle.life;
      final distance = particle.velocity * time;
      
      // Apply gravity effect
      final gravity = 200.0 * time * time;
      
      final x = center.dx + distance * math.cos(particle.angle);
      final y = center.dy + distance * math.sin(particle.angle) + gravity;
      
      // Calculate particle opacity (fades out over time)
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      
      // Create gradient effect for particles
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            particle.color.withOpacity(opacity),
            particle.color.withOpacity(opacity * 0.3),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(x, y),
          radius: particle.size,
        ));

      // Draw particle with trail effect
      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1.0 - progress * 0.5),
        paint,
      );
      
      // Add sparkle effect for extra magic
      if (progress < 0.6 && opacity > 0.5) {
        final sparklePaint = Paint()
          ..color = Colors.white.withOpacity(opacity * 0.8)
          ..strokeWidth = 1.0;
        
        canvas.drawLine(
          Offset(x - 2, y),
          Offset(x + 2, y),
          sparklePaint,
        );
        canvas.drawLine(
          Offset(x, y - 2),
          Offset(x, y + 2),
          sparklePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}