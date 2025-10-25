import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo page showcasing Smart Highlight Animation
class SmartHighlight extends StatefulWidget {
  const SmartHighlight({Key? key}) : super(key: key);

  @override
  State<SmartHighlight> createState() => _SmartHighlightState();
}

class _SmartHighlightState extends State<SmartHighlight> {
  int _streakCount = 5;
  int _scoreCount = 1250;
  int _levelCount = 12;
  int _coinsCount = 450;

  void _incrementStreak() {
    setState(() {
      _streakCount++;
    });
  }

  void _incrementScore() {
    setState(() {
      _scoreCount += math.Random().nextInt(50) + 10;
    });
  }

  void _incrementLevel() {
    setState(() {
      _levelCount++;
    });
  }

  void _incrementCoins() {
    setState(() {
      _coinsCount += math.Random().nextInt(20) + 5;
    });
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
              Colors.deepPurple.shade900,
              Colors.black,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header
                const Text(
                  'Smart Highlight\nAnimation',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Watch values glow when they change ✨',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // Streak Counter Card
                _buildStatsCard(
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                  label: 'Day Streak',
                  child: SmartHighlightValue(
                    value: _streakCount,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    highlightColor: Colors.orange,
                    glowIntensity: 1.5,
                    animationDuration: const Duration(milliseconds: 800),
                  ),
                  onTap: _incrementStreak,
                ),

                const SizedBox(height: 20),

                // Score Counter Card
                _buildStatsCard(
                  icon: Icons.stars_rounded,
                  iconColor: Colors.amber,
                  label: 'Total Score',
                  child: SmartHighlightValue(
                    value: _scoreCount,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    highlightColor: Colors.amber,
                    glowIntensity: 1.2,
                    animationDuration: const Duration(milliseconds: 600),
                    prefix: '',
                  ),
                  onTap: _incrementScore,
                ),

                const SizedBox(height: 20),

                // Level and Coins Row
                Row(
                  children: [
                    // Level Card
                    Expanded(
                      child: _buildCompactCard(
                        icon: Icons.military_tech,
                        iconColor: Colors.purple,
                        label: 'Level',
                        child: SmartHighlightValue(
                          value: _levelCount,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          highlightColor: Colors.purple,
                          glowIntensity: 1.3,
                        ),
                        onTap: _incrementLevel,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Coins Card
                    Expanded(
                      child: _buildCompactCard(
                        icon: Icons.monetization_on,
                        iconColor: Colors.yellow,
                        label: 'Coins',
                        child: SmartHighlightValue(
                          value: _coinsCount,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          highlightColor: Colors.yellow,
                          glowIntensity: 1.4,
                        ),
                        onTap: _incrementCoins,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [iconColor.withOpacity(0.15), iconColor.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withOpacity(0.4),
                        iconColor.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.touch_app,
                  color: Colors.white.withOpacity(0.3),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [iconColor.withOpacity(0.15), iconColor.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iconColor.withOpacity(0.4),
                    iconColor.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

/// ==================== Smart Highlight Value Widget ====================
/// A beautiful, reusable widget that highlights value changes with glow,
/// scale, and fade animations. Perfect for streaks, scores, and counters.
class SmartHighlightValue<T> extends StatefulWidget {
  /// The value to display and animate when changed
  final T value;

  /// Text style for the value
  final TextStyle style;

  /// Color of the highlight/glow effect
  final Color highlightColor;

  /// Intensity of the glow effect (1.0 = normal, higher = more intense)
  final double glowIntensity;

  /// Duration of the highlight animation
  final Duration animationDuration;

  /// Whether to animate on first render
  final bool animateOnInit;

  /// Scale multiplier during animation (1.2 = 20% larger)
  final double scaleMultiplier;

  /// Prefix text (e.g., "$", "#")
  final String prefix;

  /// Suffix text (e.g., "pts", "coins")
  final String suffix;

  /// Custom formatting function
  final String Function(T)? formatter;

  /// Whether to show particle effects
  final bool showParticles;

  /// Number of particles to show
  final int particleCount;

  const SmartHighlightValue({
    Key? key,
    required this.value,
    required this.style,
    this.highlightColor = const Color(0xFF00D9FF),
    this.glowIntensity = 1.0,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animateOnInit = false,
    this.scaleMultiplier = 1.15,
    this.prefix = '',
    this.suffix = '',
    this.formatter,
    this.showParticles = true,
    this.particleCount = 6,
  }) : super(key: key);

  @override
  State<SmartHighlightValue<T>> createState() => _SmartHighlightValueState<T>();
}

class _SmartHighlightValueState<T> extends State<SmartHighlightValue<T>>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _scaleController;
  late AnimationController _particleController;

  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _particleAnimation;

  T? _previousValue;
  bool _isFirstRender = true;

  @override
  void initState() {
    super.initState();

    // Glow animation controller
    _glowController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_glowController);

    // Scale animation controller
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: widget.scaleMultiplier,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.scaleMultiplier,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_scaleController);

    // Particle animation controller
    _particleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_particleController);

    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(SmartHighlightValue<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _triggerAnimation();
      _previousValue = oldWidget.value;
    }
  }

  void _triggerAnimation() {
    _glowController.forward(from: 0.0);
    _scaleController.forward(from: 0.0);
    if (widget.showParticles) {
      _particleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scaleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  String _formatValue() {
    if (widget.formatter != null) {
      return widget.formatter!(widget.value);
    }
    return widget.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _glowAnimation,
        _scaleAnimation,
        _particleAnimation,
      ]),
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Particle effects
            if (widget.showParticles && _particleAnimation.value > 0)
              ..._buildParticles(),

            // Main value with glow and scale
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: widget.highlightColor.withOpacity(
                        _glowAnimation.value * 0.6 * widget.glowIntensity,
                      ),
                      blurRadius:
                          30 * _glowAnimation.value * widget.glowIntensity,
                      spreadRadius:
                          8 * _glowAnimation.value * widget.glowIntensity,
                    ),
                    BoxShadow(
                      color: widget.highlightColor.withOpacity(
                        _glowAnimation.value * 0.4 * widget.glowIntensity,
                      ),
                      blurRadius:
                          50 * _glowAnimation.value * widget.glowIntensity,
                      spreadRadius:
                          12 * _glowAnimation.value * widget.glowIntensity,
                    ),
                  ],
                ),
                child: Text(
                  '${widget.prefix}${_formatValue()}${widget.suffix}',
                  style: widget.style.copyWith(
                    shadows: [
                      Shadow(
                        color: widget.highlightColor.withOpacity(
                          _glowAnimation.value * 0.8,
                        ),
                        blurRadius: 20 * _glowAnimation.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildParticles() {
    final particles = <Widget>[];
    final random = math.Random(widget.value.hashCode);

    for (int i = 0; i < widget.particleCount; i++) {
      final angle = (i / widget.particleCount) * 2 * math.pi;
      final distance = 40 + random.nextDouble() * 20;

      final dx = math.cos(angle) * distance * _particleAnimation.value;
      final dy = math.sin(angle) * distance * _particleAnimation.value;

      particles.add(
        Positioned(
          left: dx,
          top: dy,
          child: Opacity(
            opacity: (1 - _particleAnimation.value) * 0.8,
            child: Container(
              width: 6 + random.nextDouble() * 4,
              height: 6 + random.nextDouble() * 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.highlightColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.highlightColor.withOpacity(0.8),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return particles;
  }
}
