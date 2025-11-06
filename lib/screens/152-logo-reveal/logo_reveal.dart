import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

/// 🎯 Main Logo Reveal Screen
/// This is the entry point for the magical logo reveal animation
class LogoRevealScreen extends StatelessWidget {
  const LogoRevealScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MagicalLogoReveal(
        // 🎨 Customize your logo
        logo: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.purple.shade400,
                Colors.pink.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 60,
            color: Colors.white,
          ),
        ),
        
        // 📝 App name that types out
        appName: "DREAMAPP",
        
        // 🎨 Tagline (optional)
        tagline: "Beyond Imagination",
        
        // ⚙️ Customization parameters
        animationDuration: const Duration(milliseconds: 2000),
        glowColor: Colors.blue.shade300,
        textColor: Colors.black87,
        taglineColor: Colors.grey.shade600,
        
        // 🎬 Callback when animation completes
        onAnimationComplete: () {
          print("🎉 Logo reveal animation completed!");
          // Navigate to next screen or perform action
        },
        
        // 🌈 Background gradient colors (animates through these)
        backgroundGradientColors: [
          [Colors.white, Colors.blue.shade50],
          [Colors.white, Colors.purple.shade50],
          [Colors.white, Colors.pink.shade50],
          [Colors.white, Colors.orange.shade50],
        ],
      ),
    );
  }
}

/// 🎨 Magical Logo Reveal Widget
/// A fully customizable, reusable logo reveal animation component
/// with glow effects, scale transitions, and typing animations
class MagicalLogoReveal extends StatefulWidget {
  /// The logo widget to display (can be Image, Icon, or any Widget)
  final Widget logo;
  
  /// App name text that will type out
  final String appName;
  
  /// Optional tagline below app name
  final String? tagline;
  
  /// Duration of the main animation
  final Duration animationDuration;
  
  /// Glow effect color
  final Color glowColor;
  
  /// Text color for app name
  final Color textColor;
  
  /// Tagline text color
  final Color taglineColor;
  
  /// Callback when animation completes
  final VoidCallback? onAnimationComplete;
  
  /// Background gradient colors that animate
  final List<List<Color>> backgroundGradientColors;
  
  /// Font family for text
  final String? fontFamily;
  
  /// Custom text style for app name
  final TextStyle? appNameStyle;
  
  /// Custom text style for tagline
  final TextStyle? taglineStyle;

  const MagicalLogoReveal({
    Key? key,
    required this.logo,
    required this.appName,
    this.tagline,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.glowColor = Colors.blue,
    this.textColor = Colors.black87,
    this.taglineColor = Colors.grey,
    this.onAnimationComplete,
    this.backgroundGradientColors = const [
      [Colors.white, Color(0xFFE3F2FD)],
      [Colors.white, Color(0xFFF3E5F5)],
      [Colors.white, Color(0xFFFCE4EC)],
    ],
    this.fontFamily,
    this.appNameStyle,
    this.taglineStyle,
  }) : super(key: key);

  @override
  State<MagicalLogoReveal> createState() => _MagicalLogoRevealState();
}

class _MagicalLogoRevealState extends State<MagicalLogoReveal>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;
  
  int _currentGradientIndex = 0;
  Timer? _gradientTimer;
  String _displayedText = "";
  int _textIndex = 0;
  Timer? _typingTimer;
  bool _showTagline = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  /// Initialize all animation controllers
  void _initializeAnimations() {
    // Scale and fade animation for logo
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // Glow pulse animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Rotation animation for extra flair
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  /// Start the complete animation sequence
  void _startAnimationSequence() {
    // Start logo scale animation
    _scaleController.forward();

    // Start glow pulse (repeating)
    _glowController.repeat(reverse: true);

    // Start subtle rotation
    _rotateController.repeat();

    // Start background gradient animation
    _startGradientAnimation();

    // Start typing animation after logo appears
    Future.delayed(const Duration(milliseconds: 800), () {
      _startTypingAnimation();
    });

    // Show tagline after typing completes
    Future.delayed(
      Duration(milliseconds: 800 + (widget.appName.length * 100)),
      () {
        if (mounted) {
          setState(() => _showTagline = true);
        }
      },
    );

    // Call completion callback
    Future.delayed(
      widget.animationDuration + const Duration(milliseconds: 1000),
      () {
        widget.onAnimationComplete?.call();
      },
    );
  }

  /// Animate through gradient backgrounds
  void _startGradientAnimation() {
    _gradientTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (mounted) {
        setState(() {
          _currentGradientIndex = 
              (_currentGradientIndex + 1) % widget.backgroundGradientColors.length;
        });
      }
    });
  }

  /// Typing animation for app name
  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_textIndex < widget.appName.length) {
        if (mounted) {
          setState(() {
            _displayedText += widget.appName[_textIndex];
            _textIndex++;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    _rotateController.dispose();
    _gradientTimer?.cancel();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.backgroundGradientColors[_currentGradientIndex],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // ✨ Floating particles in background
          ...List.generate(20, (index) => _buildFloatingParticle(index)),
          
          // 🎯 Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎨 Animated Logo with Glow
                _buildAnimatedLogo(),
                
                const SizedBox(height: 40),
                
                // 📝 Typing Text Animation
                _buildTypingText(),
                
                const SizedBox(height: 12),
                
                // 🏷️ Tagline with fade-in
                _buildTagline(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the animated logo with glow and scale effects
  Widget _buildAnimatedLogo() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(_glowAnimation.value * 0.6),
                    blurRadius: 60 * _glowAnimation.value,
                    spreadRadius: 20 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: widget.glowColor.withOpacity(_glowAnimation.value * 0.3),
                    blurRadius: 100 * _glowAnimation.value,
                    spreadRadius: 30 * _glowAnimation.value,
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateController.value * 2 * math.pi * 0.1,
                    child: widget.logo,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build typing animation text
  Widget _buildTypingText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _displayedText,
            style: widget.appNameStyle ??
                TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                  letterSpacing: 3,
                  fontFamily: widget.fontFamily,
                  shadows: [
                    Shadow(
                      color: widget.glowColor.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
          ),
          if (_textIndex < widget.appName.length)
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Opacity(
                  opacity: _glowAnimation.value,
                  child: Container(
                    width: 3,
                    height: 42,
                    margin: const EdgeInsets.only(left: 4),
                    color: widget.textColor,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Build tagline with fade-in effect
  Widget _buildTagline() {
    if (widget.tagline == null) return const SizedBox.shrink();
    
    return AnimatedOpacity(
      opacity: _showTagline ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: AnimatedSlide(
        offset: _showTagline ? Offset.zero : const Offset(0, 0.5),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        child: Text(
          widget.tagline!,
          style: widget.taglineStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: widget.taglineColor,
                letterSpacing: 2,
                fontFamily: widget.fontFamily,
              ),
        ),
      ),
    );
  }

  /// Build floating particles for ambient animation
  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    final size = 4.0 + random.nextDouble() * 8;
    final duration = 3000 + random.nextInt(4000);
    final delay = random.nextInt(2000);
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: duration),
      builder: (context, value, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        
        return Positioned(
          left: screenWidth * random.nextDouble(),
          top: screenHeight * value,
          child: Opacity(
            opacity: (math.sin(value * math.pi) * 0.5).clamp(0.0, 0.6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.glowColor.withOpacity(0.4),
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Restart animation
        Future.delayed(Duration(milliseconds: delay), () {
          if (mounted) setState(() {});
        });
      },
    );
  }
}