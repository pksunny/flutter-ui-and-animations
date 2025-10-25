import 'package:flutter/material.dart';
import 'dart:math' as math;

// ============================================
// SMART PAGE LOADER - Showcasing Hero Transitions
// ============================================
class SmartPageLoader extends StatelessWidget {
  const SmartPageLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Header
              Text(
                'Smart Page Loader',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.blue.shade700, Colors.purple.shade700],
                    ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap any card to experience magic ✨',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 40),
              // Grid of cards with different hero animations
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildHeroCard(
                        context,
                        heroTag: 'rocket',
                        icon: Icons.rocket_launch,
                        title: 'Rocket',
                        subtitle: 'Blast off!',
                        gradient: [Colors.orange.shade400, Colors.red.shade400],
                        destination: const DetailPage(
                          heroTag: 'rocket',
                          icon: Icons.rocket_launch,
                          title: 'Rocket Launch',
                          color1: Color(0xFFFF9800),
                          color2: Color(0xFFF44336),
                        ),
                      ),
                      _buildHeroCard(
                        context,
                        heroTag: 'star',
                        icon: Icons.auto_awesome,
                        title: 'Sparkle',
                        subtitle: 'Shine bright',
                        gradient: [Colors.yellow.shade400, Colors.amber.shade600],
                        destination: const DetailPage(
                          heroTag: 'star',
                          icon: Icons.auto_awesome,
                          title: 'Sparkle Magic',
                          color1: Color(0xFFFFEB3B),
                          color2: Color(0xFFFFA726),
                        ),
                      ),
                      _buildHeroCard(
                        context,
                        heroTag: 'heart',
                        icon: Icons.favorite,
                        title: 'Love',
                        subtitle: 'Feel the vibe',
                        gradient: [Colors.pink.shade400, Colors.red.shade400],
                        destination: const DetailPage(
                          heroTag: 'heart',
                          icon: Icons.favorite,
                          title: 'Love Energy',
                          color1: Color(0xFFE91E63),
                          color2: Color(0xFFF44336),
                        ),
                      ),
                      _buildHeroCard(
                        context,
                        heroTag: 'thunder',
                        icon: Icons.bolt,
                        title: 'Thunder',
                        subtitle: 'Feel power',
                        gradient: [Colors.purple.shade400, Colors.indigo.shade400],
                        destination: const DetailPage(
                          heroTag: 'thunder',
                          icon: Icons.bolt,
                          title: 'Thunder Strike',
                          color1: Color(0xFF9C27B0),
                          color2: Color(0xFF3F51B5),
                        ),
                      ),
                      _buildHeroCard(
                        context,
                        heroTag: 'diamond',
                        icon: Icons.diamond,
                        title: 'Diamond',
                        subtitle: 'Pure luxury',
                        gradient: [Colors.cyan.shade400, Colors.blue.shade400],
                        destination: const DetailPage(
                          heroTag: 'diamond',
                          icon: Icons.diamond,
                          title: 'Diamond Shine',
                          color1: Color(0xFF00BCD4),
                          color2: Color(0xFF2196F3),
                        ),
                      ),
                      _buildHeroCard(
                        context,
                        heroTag: 'fire',
                        icon: Icons.local_fire_department,
                        title: 'Fire',
                        subtitle: 'Burn bright',
                        gradient: [Colors.deepOrange.shade400, Colors.red.shade600],
                        destination: const DetailPage(
                          heroTag: 'fire',
                          icon: Icons.local_fire_department,
                          title: 'Fire Blaze',
                          color1: Color(0xFFFF5722),
                          color2: Color(0xFFD32F2F),
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

  Widget _buildHeroCard(
    BuildContext context, {
    required String heroTag,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required Widget destination,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SmartPageRoute(
            child: destination,
            heroTag: heroTag,
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// SMART PAGE ROUTE - Custom Page Transition
// ============================================
class SmartPageRoute extends PageRouteBuilder {
  final Widget child;
  final String heroTag;
  final Duration duration;
  final Curve curve;

  SmartPageRoute({
    required this.child,
    required this.heroTag,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOutCubic,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                // Fade transition for the page
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(0.3, 1.0, curve: curve),
                    ),
                  ),
                  child: child,
                ),
                // Particle effects during transition
                ParticleTransition(
                  animation: animation,
                  heroTag: heroTag,
                ),
              ],
            );
          },
        );
}

// ============================================
// PARTICLE TRANSITION - Beautiful Effects
// ============================================
class ParticleTransition extends StatelessWidget {
  final Animation<double> animation;
  final String heroTag;

  const ParticleTransition({
    Key? key,
    required this.animation,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (animation.value < 0.2 || animation.value > 0.8) {
          return const SizedBox.shrink();
        }

        return CustomPaint(
          painter: ParticlePainter(
            progress: animation.value,
            seed: heroTag.hashCode,
          ),
          child: Container(),
        );
      },
    );
  }
}

// ============================================
// PARTICLE PAINTER - Custom Paint Magic
// ============================================
class ParticlePainter extends CustomPainter {
  final double progress;
  final int seed;

  ParticlePainter({required this.progress, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint = Paint()..style = PaintingStyle.fill;

    // Create 30 particles
    for (int i = 0; i < 30; i++) {
      final angle = (i / 30) * 2 * math.pi;
      final distance = progress * 400;
      final particleSize = (1 - progress) * (5 + random.nextDouble() * 5);

      final x = size.width / 2 + math.cos(angle) * distance;
      final y = size.height / 2 + math.sin(angle) * distance;

      final colors = [
        Colors.blue.shade400,
        Colors.purple.shade400,
        Colors.pink.shade400,
        Colors.orange.shade400,
        Colors.yellow.shade400,
      ];

      paint.color = colors[i % colors.length].withOpacity((1 - progress) * 0.6);

      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// ============================================
// DETAIL PAGE - Destination Screen
// ============================================
class DetailPage extends StatefulWidget {
  final String heroTag;
  final IconData icon;
  final String title;
  final Color color1;
  final Color color2;

  const DetailPage({
    Key? key,
    required this.heroTag,
    required this.icon,
    required this.title,
    required this.color1,
    required this.color2,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              widget.color1.withOpacity(0.3),
              widget.color2.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const Spacer(),
              // Hero Icon
              Hero(
                tag: widget.heroTag,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [widget.color1, widget.color2],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.color1.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Icon(
                              widget.icon,
                              size: 90,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              // Title
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - _controller.value)),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [widget.color1, widget.color2],
                            ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value,
                    child: Text(
                      'Experience the magic of smart transitions',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const Spacer(),
              // Feature cards
              Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controller.value,
                      child: _buildFeatureCards(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      children: [
        _buildFeatureCard(
          icon: Icons.speed,
          title: 'Lightning Fast',
          description: 'Smooth 60fps animations',
          color: widget.color1,
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          icon: Icons.palette,
          title: 'Beautiful Design',
          description: 'Crafted with attention to detail',
          color: widget.color2,
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          icon: Icons.settings,
          title: 'Fully Customizable',
          description: 'Adapt to your brand colors',
          color: Color.lerp(widget.color1, widget.color2, 0.5)!,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}