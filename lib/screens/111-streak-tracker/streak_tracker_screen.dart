import 'package:flutter/material.dart';
import 'dart:math' as math;

class StreakTrackerScreen extends StatelessWidget {
  const StreakTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F0F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Demo with different streak values
              AmazingStreakTracker(
                streakCount: 7,
                goalTitle: "Daily Workout",
                subtitle: "Keep the fire burning!",
                primaryColor: Colors.orange,
                secondaryColor: Colors.red,
                backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.8),
              ),
              const SizedBox(height: 40),
              AmazingStreakTracker(
                streakCount: 21,
                goalTitle: "Reading Challenge",
                subtitle: "Knowledge is power!",
                primaryColor: Colors.blue,
                secondaryColor: Colors.cyan,
                backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.8),
                streakIcon: "📚",
              ),
              const SizedBox(height: 40),
              AmazingStreakTracker(
                streakCount: 100,
                goalTitle: "Meditation Journey",
                subtitle: "Inner peace achieved!",
                primaryColor: Colors.purple,
                secondaryColor: Colors.pink,
                backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.8),
                streakIcon: "🧘‍♂️",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Amazing Animated Streak Tracker Widget
/// 
/// A highly customizable, beautiful streak tracker with stunning animations
/// Perfect for showing daily goals, habits, or any milestone tracking
class AmazingStreakTracker extends StatefulWidget {
  /// The current streak count to display
  final int streakCount;
  
  /// Main title text (e.g., "Daily Workout")
  final String goalTitle;
  
  /// Subtitle text (e.g., "Keep the fire burning!")
  final String subtitle;
  
  /// Primary color for gradients and effects
  final Color primaryColor;
  
  /// Secondary color for gradients
  final Color secondaryColor;
  
  /// Background color of the card
  final Color backgroundColor;
  
  /// Custom streak icon (default: 🔥)
  final String streakIcon;
  
  /// Custom width of the widget
  final double? width;
  
  /// Custom height of the widget
  final double? height;
  
  /// Animation duration
  final Duration animationDuration;
  
  /// Callback when the widget is tapped
  final VoidCallback? onTap;

  const AmazingStreakTracker({
    Key? key,
    required this.streakCount,
    required this.goalTitle,
    this.subtitle = "Amazing progress!",
    this.primaryColor = Colors.orange,
    this.secondaryColor = Colors.red,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.streakIcon = "🔥",
    this.width,
    this.height,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.onTap,
  }) : super(key: key);

  @override
  State<AmazingStreakTracker> createState() => _AmazingStreakTrackerState();
}

class _AmazingStreakTrackerState extends State<AmazingStreakTracker>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    // Main entrance animation controller
    _mainController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Continuous pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Glow animation controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation with bounce effect
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    // Slide animation
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    // Rotation animation for streak icon
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
    ));

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Glow animation
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _mainController.forward();
    
    // Start continuous animations with delays
    Future.delayed(const Duration(milliseconds: 1000), () {
      _pulseController.repeat(reverse: true);
      _particleController.repeat();
      _glowController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainController,
        _pulseController,
        _glowController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: widget.width ?? 350,
                  height: widget.height ?? 200,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      // Background glow effect
                      _buildGlowEffect(),
                      
                      // Main card
                      _buildMainCard(),
                      
                      // Floating particles
                      _buildFloatingParticles(),
                      
                      // Content
                      _buildContent(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor.withOpacity(0.3 * _glowAnimation.value),
              blurRadius: 30 * _glowAnimation.value,
              spreadRadius: 5 * _glowAnimation.value,
            ),
            BoxShadow(
              color: widget.secondaryColor.withOpacity(0.2 * _glowAnimation.value),
              blurRadius: 50 * _glowAnimation.value,
              spreadRadius: 10 * _glowAnimation.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.backgroundColor,
            widget.backgroundColor.withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final double progress = (_particleController.value + index / 6) % 1.0;
            final double angle = 2 * math.pi * index / 6;
            final double radius = 30 + 20 * math.sin(progress * 2 * math.pi);
            
            return Positioned(
              left: 175 + radius * math.cos(angle + progress * 2 * math.pi),
              top: 100 + radius * math.sin(angle + progress * 2 * math.pi),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with streak icon and count
          Row(
            children: [
              // Animated streak icon
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 0.1,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          widget.primaryColor.withOpacity(0.2),
                          widget.secondaryColor.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.streakIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 15),
              
              // Streak count with animated counter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Streak count
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [widget.primaryColor, widget.secondaryColor],
                      ).createShader(bounds),
                      child: Text(
                        '${widget.streakCount} Days',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Goal title
                    Text(
                      widget.goalTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Progress bar
          _buildProgressBar(),
          
          const SizedBox(height: 15),
          
          // Subtitle
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white.withOpacity(0.1),
      ),
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return FractionallySizedBox(
            widthFactor: _mainController.value,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  colors: [widget.primaryColor, widget.secondaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}