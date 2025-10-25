import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo page showcasing the SmartLoader widget
class SmartLoadingSwap extends StatefulWidget {
  const SmartLoadingSwap({Key? key}) : super(key: key);

  @override
  State<SmartLoadingSwap> createState() => _SmartLoadingSwapState();
}

class _SmartLoadingSwapState extends State<SmartLoadingSwap> {
  bool _isLoading = false;

  void _simulateTask() {
    setState(() => _isLoading = true);

    // Simulate a long-running task (15 seconds to see loader transitions)
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              const Color(0xFF0A0E21),
              const Color(0xFF1A1F3A),
              const Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title with gradient
                ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF),
                          const Color(0xFF00D4FF),
                        ],
                      ).createShader(bounds),
                  child: const Text(
                    'Smart Loader Swap',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Intelligent loading indicators that adapt',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 60),

                // Smart Loader Widget
                if (_isLoading)
                  SmartLoader(
                    // Loader switches after these durations
                    loaderStages: const [
                      LoaderStage(
                        duration: Duration(seconds: 3),
                        type: LoaderType.spinner,
                      ),
                      LoaderStage(
                        duration: Duration(seconds: 5),
                        type: LoaderType.pulse,
                      ),
                      LoaderStage(
                        duration: Duration(seconds: 7),
                        type: LoaderType.orbit,
                      ),
                    ],
                    size: 120,
                    primaryColor: const Color(0xFF6C63FF),
                    secondaryColor: const Color(0xFF00D4FF),
                    showMessage: true,
                    messages: const [
                      'Loading...',
                      'Still working on it...',
                      'Almost there...',
                    ],
                  )
                else
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF).withOpacity(0.2),
                          const Color(0xFF00D4FF).withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.touch_app_rounded,
                      size: 50,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),

                const SizedBox(height: 60),

                // Start Button
                if (!_isLoading)
                  _buildGradientButton(
                    onPressed: _simulateTask,
                    label: 'Start Loading',
                  ),

                const SizedBox(height: 40),

                // Info Card
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF6C63FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'How it works',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('3s', 'Spinner loader', Icons.refresh),
          _buildInfoRow('5s', 'Pulse loader', Icons.favorite),
          _buildInfoRow('7s+', 'Orbit loader', Icons.blur_circular),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String time, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.3),
                  const Color(0xFF00D4FF).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: Colors.white.withOpacity(0.5), size: 20),
          const SizedBox(width: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SMART LOADER WIDGET - Main Component
// ============================================================================

/// Defines a loader stage with duration and type
class LoaderStage {
  final Duration duration;
  final LoaderType type;

  const LoaderStage({required this.duration, required this.type});
}

/// Available loader animation types
enum LoaderType { spinner, pulse, orbit, dots, wave }

/// Smart Loader Widget - Automatically swaps loader types based on elapsed time
class SmartLoader extends StatefulWidget {
  /// List of loader stages with durations
  final List<LoaderStage> loaderStages;

  /// Size of the loader
  final double size;

  /// Primary color for the loader
  final Color primaryColor;

  /// Secondary color for gradient effects
  final Color secondaryColor;

  /// Whether to show loading messages
  final bool showMessage;

  /// Messages corresponding to each stage
  final List<String> messages;

  /// Animation duration for transitions
  final Duration transitionDuration;

  const SmartLoader({
    Key? key,
    required this.loaderStages,
    this.size = 80,
    this.primaryColor = const Color(0xFF6C63FF),
    this.secondaryColor = const Color(0xFF00D4FF),
    this.showMessage = true,
    this.messages = const ['Loading...', 'Please wait...', 'Almost done...'],
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<SmartLoader> createState() => _SmartLoaderState();
}

class _SmartLoaderState extends State<SmartLoader>
    with SingleTickerProviderStateMixin {
  int _currentStageIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _scheduleNextStage();
  }

  void _scheduleNextStage() {
    if (_currentStageIndex < widget.loaderStages.length - 1) {
      Future.delayed(widget.loaderStages[_currentStageIndex].duration, () {
        if (mounted) {
          _fadeController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _currentStageIndex++;
              });
              _fadeController.forward();
              _scheduleNextStage();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCurrentLoader(),
          if (widget.showMessage) ...[
            const SizedBox(height: 24),
            _buildMessage(),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentLoader() {
    final stage = widget.loaderStages[_currentStageIndex];

    switch (stage.type) {
      case LoaderType.spinner:
        return SpinnerLoader(
          size: widget.size,
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
      case LoaderType.pulse:
        return PulseLoader(
          size: widget.size,
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
      case LoaderType.orbit:
        return OrbitLoader(
          size: widget.size,
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
      case LoaderType.dots:
        return DotsLoader(
          size: widget.size,
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
      case LoaderType.wave:
        return WaveLoader(
          size: widget.size,
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
    }
  }

  Widget _buildMessage() {
    final messageIndex = _currentStageIndex.clamp(
      0,
      widget.messages.length - 1,
    );

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          widget.messages[messageIndex],
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LOADER ANIMATIONS - Individual Loader Widgets
// ============================================================================

/// Spinner Loader - Classic rotating spinner
class SpinnerLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const SpinnerLoader({
    Key? key,
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  State<SpinnerLoader> createState() => _SpinnerLoaderState();
}

class _SpinnerLoaderState extends State<SpinnerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  widget.primaryColor,
                  widget.secondaryColor,
                  widget.primaryColor.withOpacity(0.1),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Pulse Loader - Pulsating heart-like animation
class PulseLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const PulseLoader({
    Key? key,
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            Transform.scale(
              scale: _scaleAnimation.value * 1.3,
              child: Opacity(
                opacity: 1 - _opacityAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.primaryColor, width: 3),
                  ),
                ),
              ),
            ),
            // Inner pulse
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [widget.primaryColor, widget.secondaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Orbit Loader - Orbiting particles around center
class OrbitLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const OrbitLoader({
    Key? key,
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  State<OrbitLoader> createState() => _OrbitLoaderState();
}

class _OrbitLoaderState extends State<OrbitLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Center core
              Container(
                width: widget.size * 0.25,
                height: widget.size * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [widget.primaryColor, widget.secondaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
              // Orbiting particles
              ..._buildOrbitingParticles(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildOrbitingParticles() {
    return List.generate(3, (index) {
      final angle =
          (_controller.value * 2 * math.pi) + (index * 2 * math.pi / 3);
      final radius = widget.size * 0.35;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;

      return Transform.translate(
        offset: Offset(x, y),
        child: Container(
          width: widget.size * 0.15,
          height: widget.size * 0.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              widget.primaryColor,
              widget.secondaryColor,
              index / 3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(0.6),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Dots Loader - Bouncing dots animation
class DotsLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const DotsLoader({
    Key? key,
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = (_controller.value - (index * 0.2)) % 1.0;
              final bounce = math.sin(progress * math.pi);

              return Transform.translate(
                offset: Offset(0, -widget.size * 0.3 * bounce),
                child: Container(
                  width: widget.size * 0.2,
                  height: widget.size * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [widget.primaryColor, widget.secondaryColor],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Wave Loader - Wave-like animation
class WaveLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const WaveLoader({
    Key? key,
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  State<WaveLoader> createState() => _WaveLoaderState();
}

class _WaveLoaderState extends State<WaveLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = (_controller.value + (index * 0.1)) % 1.0;
              final height = (math.sin(progress * 2 * math.pi) + 1) / 2;

              return Container(
                width: widget.size * 0.12,
                height: widget.size * 0.5 * height.clamp(0.2, 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [widget.primaryColor, widget.secondaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
