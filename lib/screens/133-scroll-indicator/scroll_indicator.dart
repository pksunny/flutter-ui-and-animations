import 'package:flutter/material.dart';

/// Main page showcasing the Vertical Smart Scroll Progress Indicator
class ScrollIndicator extends StatefulWidget {
  const ScrollIndicator({Key? key}) : super(key: key);

  @override
  State<ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator> {
  late ScrollController _scrollController;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollProgress);
  }

  void _updateScrollProgress() {
    if (_scrollController.position.maxScrollExtent > 0) {
      setState(() {
        _scrollProgress =
            _scrollController.offset /
            _scrollController.position.maxScrollExtent;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Smart Scroll Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 120),
                // Beautiful gradient header card
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.deepPurple.shade400,
                            Colors.purpleAccent.shade700,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scroll Progress Indicator',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Look at the RIGHT SIDE - See the BIG BLUE indicator move down!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Progress: ${(_scrollProgress * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 50 Content Items
                ..._buildContentItems(),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // LARGE Vertical Smart Scroll Progress Indicator (Right Side)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: VerticalSmartScrollProgressIndicator(
              progress: _scrollProgress,
              width: 20, // MUCH LARGER
              backgroundColor: Colors.grey.shade900,
              foregroundColor: Colors.cyanAccent,
              animationDuration: const Duration(milliseconds: 200),
              borderRadius: 10,
              glowEffect: true,
              glowColor: Colors.cyanAccent,
              glowBlurRadius: 24,
              position: IndicatorPosition.right,
            ),
          ),

          // Progress percentage at top
          Positioned(
            right: 20,
            top: 100,
            child: AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '${(_scrollProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Generate 50 beautiful content items
  List<Widget> _buildContentItems() {
    final colors = [
      Colors.cyan,
      Colors.amber,
      Colors.pink,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.lime,
    ];

    return List.generate(50, (index) {
      final color = colors[index % colors.length];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
              ),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.4), color.withOpacity(0.2)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(_getIconForIndex(index), color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item ${index + 1} - ${_getTitleForIndex(index)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDescriptionForIndex(index),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.spa_sharp,
      Icons.tune,
      Icons.widgets,
      Icons.favorite,
      Icons.landscape,
      Icons.build,
      Icons.palette,
      Icons.star,
      Icons.rocket,
      Icons.cloud,
    ];
    return icons[index % icons.length];
  }

  String _getTitleForIndex(int index) {
    final titles = [
      'Feature',
      'Component',
      'Widget',
      'Animation',
      'Design',
      'Interface',
      'Element',
      'Pattern',
      'Module',
      'System',
    ];
    return titles[index % titles.length];
  }

  String _getDescriptionForIndex(int index) {
    final descriptions = [
      'Seamless animations and transitions',
      'Fully customizable components',
      'Production ready widgets',
      'Smooth micro-interactions',
      'Beautiful modern UI',
      'Clean code architecture',
      'Reusable across projects',
      'Enhanced user experience',
      'Performance optimized',
      'Material Design 3',
    ];
    return descriptions[index % descriptions.length];
  }
}

/// ==================== Vertical Smart Scroll Progress Indicator ====================
/// A stunning vertical scroll progress indicator widget with smooth animations,
/// glow effects, and beautiful micro-interactions.
class VerticalSmartScrollProgressIndicator extends StatefulWidget {
  /// Current scroll progress (0.0 to 1.0)
  final double progress;

  /// Width of the progress bar
  final double width;

  /// Background color of the indicator
  final Color backgroundColor;

  /// Foreground/progress color
  final Color foregroundColor;

  /// Animation duration for smooth transitions
  final Duration animationDuration;

  /// Border radius of the progress bar
  final double borderRadius;

  /// Whether to show glow effect
  final bool glowEffect;

  /// Glow color (used when glowEffect is true)
  final Color? glowColor;

  /// Glow blur radius
  final double glowBlurRadius;

  /// Position of the indicator (left or right)
  final IndicatorPosition position;

  /// Whether to show pulse animation
  final bool pulseAnimation;

  /// Edge insets for the indicator
  final EdgeInsets padding;

  /// Custom shader for gradient effect
  final bool enableGradient;

  const VerticalSmartScrollProgressIndicator({
    Key? key,
    required this.progress,
    this.width = 20,
    this.backgroundColor = const Color(0xFF1A1A1A),
    this.foregroundColor = const Color(0xFF00D9FF),
    this.animationDuration = const Duration(milliseconds: 200),
    this.borderRadius = 10,
    this.glowEffect = true,
    this.glowColor,
    this.glowBlurRadius = 24,
    this.position = IndicatorPosition.right,
    this.pulseAnimation = true,
    this.padding = EdgeInsets.zero,
    this.enableGradient = true,
  }) : super(key: key);

  @override
  State<VerticalSmartScrollProgressIndicator> createState() =>
      _VerticalSmartScrollProgressIndicatorState();
}

class _VerticalSmartScrollProgressIndicatorState
    extends State<VerticalSmartScrollProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return _buildProgressIndicator();
      },
    );
  }

  Widget _buildProgressIndicator() {
    final screenHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: widget.width,
        height: screenHeight,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Stack(
          children: [
            // Background track
            Container(
              width: widget.width,
              height: screenHeight,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),

            // Main progress bar - HIGHLY VISIBLE
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: (screenHeight * widget.progress).clamp(
                  0.0,
                  screenHeight,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.foregroundColor,
                      widget.foregroundColor.withOpacity(0.8),
                      widget.foregroundColor.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: widget.foregroundColor.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Animated glow effect at progress edge
            if (widget.glowEffect)
              Positioned(
                top: (screenHeight * widget.progress).clamp(0.0, screenHeight),
                left: -10,
                right: -10,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        widget.glowColor?.withOpacity(0.6) ??
                            widget.foregroundColor.withOpacity(0.6),
                        widget.glowColor?.withOpacity(0.3) ??
                            widget.foregroundColor.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            widget.glowColor ??
                            widget.foregroundColor.withOpacity(0.7),
                        blurRadius: widget.glowBlurRadius,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),

            // Percentage text at current position
            Positioned(
              top:
                  (screenHeight * widget.progress).clamp(0.0, screenHeight) -
                  30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: widget.foregroundColor, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Enum for indicator position
enum IndicatorPosition { left, right }
