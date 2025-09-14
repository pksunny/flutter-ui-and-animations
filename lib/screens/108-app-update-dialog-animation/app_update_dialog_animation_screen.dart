import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🚀 FUTURISTIC ANIMATED APP UPDATE DIALOG ///

class AppUpdateDialogAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text('My App'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🚀 SIMPLE CALL - Default Dialog
            ElevatedButton(
              onPressed: () {
                FuturisticUpdateDialog.show(context);
              },
              child: Text('Show Update Dialog'),
            ),
            
            SizedBox(height: 20),
            
            // 🎨 CUSTOM CALL - With Custom Colors & Content
            ElevatedButton(
              onPressed: () {
                FuturisticUpdateDialog.show(
                  context,
                  dialog: FuturisticUpdateDialog(
                    primaryColor: Color(0xFFFF6B6B),
                    secondaryColor: Color(0xFF4ECDC4),
                    title: "🚀 Amazing Update!",
                    subtitle: "New features await you!",
                    version: "v2.5.0",
                    onUpdatePressed: () {
                      Navigator.of(context).pop();
                    },
                    onLaterPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
              child: Text('Show Custom Dialog'),
            ),
          ],
        ),
      ),
      
      // 🎯 AUTO-SHOW ON APP START (Optional)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog automatically
          _showUpdateDialogOnStart(context);
        },
        child: Icon(Icons.system_update),
      ),
    );
  }

  // 🚀 METHOD TO SHOW DIALOG ON APP START
  void _showUpdateDialogOnStart(BuildContext context) {
    // Delay to show after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FuturisticUpdateDialog.show(
        context,
        dialog: FuturisticUpdateDialog(
          title: "Welcome Back! 🎉",
          subtitle: "A fantastic new update is ready to enhance your experience with incredible features.",
          version: "v3.1.0",
          updateButtonText: "GET UPDATE",
          laterButtonText: "NOT NOW",
          onUpdatePressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    });
  }
}


class FuturisticUpdateDialog extends StatefulWidget {
  // 🎨 VISUAL CUSTOMIZATION
  final Color primaryColor;
  final Color secondaryColor;
  final List<Color> backgroundGradient;
  final List<Color> buttonGradient;
  final Color textColor;
  final Color subtitleColor;
  
  // ⚡ ANIMATION CUSTOMIZATION
  final Duration animationDuration;
  final Duration particleAnimationDuration;
  final Curve animationCurve;
  final bool enableGlowEffect;
  final bool enableParticleEffect;
  final bool enableBackgroundAnimation;
  
  // 📱 CONTENT CUSTOMIZATION
  final String title;
  final String subtitle;
  final String version;
  final String updateButtonText;
  final String laterButtonText;
  final IconData updateIcon;
  
  // 🔧 SIZING & STYLING
  final double dialogWidth;
  final double dialogHeight;
  final double borderRadius;
  final double titleFontSize;
  final double subtitleFontSize;
  final FontWeight titleFontWeight;
  final FontWeight subtitleFontWeight;
  final String fontFamily;
  
  // 📦 CALLBACKS
  final VoidCallback? onUpdatePressed;
  final VoidCallback? onLaterPressed;

  const FuturisticUpdateDialog({
    Key? key,
    // Visual defaults
    this.primaryColor = const Color(0xFF00D4FF),
    this.secondaryColor = const Color(0xFF7B2CBF),
    this.backgroundGradient = const [
      Color(0xFF0F0F23),
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
    ],
    this.buttonGradient = const [
      Color(0xFF00D4FF),
      Color(0xFF7B2CBF),
    ],
    this.textColor = Colors.white,
    this.subtitleColor = const Color(0xFFB0B0B0),
    
    // Animation defaults
    this.animationDuration = const Duration(milliseconds: 800),
    this.particleAnimationDuration = const Duration(seconds: 3),
    this.animationCurve = Curves.elasticOut,
    this.enableGlowEffect = true,
    this.enableParticleEffect = true,
    this.enableBackgroundAnimation = true,
    
    // Content defaults
    this.title = "Update Available!",
    this.subtitle = "A new version of the app is available with amazing new features and improvements.",
    this.version = "v2.1.0",
    this.updateButtonText = "UPDATE NOW",
    this.laterButtonText = "MAYBE LATER",
    this.updateIcon = Icons.system_update_alt_rounded,
    
    // Sizing defaults
    this.dialogWidth = 340,
    this.dialogHeight = 500,
    this.borderRadius = 24,
    this.titleFontSize = 24,
    this.subtitleFontSize = 14,
    this.titleFontWeight = FontWeight.bold,
    this.subtitleFontWeight = FontWeight.w400,
    this.fontFamily = 'System',
    
    // Callbacks
    this.onUpdatePressed,
    this.onLaterPressed,
  }) : super(key: key);

  @override
  _FuturisticUpdateDialogState createState() => _FuturisticUpdateDialogState();

  /// 🌟 STATIC METHOD TO SHOW DIALOG
  static Future<void> show(
    BuildContext context, {
    FuturisticUpdateDialog? dialog,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) => dialog ?? const FuturisticUpdateDialog(),
    );
  }
}

class _FuturisticUpdateDialogState extends State<FuturisticUpdateDialog>
    with TickerProviderStateMixin {
  
  // 🎬 ANIMATION CONTROLLERS
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  late AnimationController _backgroundController;
  
  // 📊 ANIMATIONS
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  /// 🔧 INITIALIZE ALL ANIMATIONS
  void _initializeAnimations() {
    // Main dialog animation controller
    _mainController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    // Particle effects controller
    _particleController = AnimationController(
      duration: widget.particleAnimationDuration,
      vsync: this,
    );
    
    // Glow effect controller
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Scale animation with elastic effect
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: widget.animationCurve,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    ));

    // Slide animation
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    ));

    // Rotation animation for icon
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    // Glow pulsing animation
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));
  }

  /// 🚀 START ALL ANIMATIONS
  void _startAnimations() {
    _mainController.forward();
    
    if (widget.enableParticleEffect) {
      _particleController.repeat();
    }
    
    if (widget.enableGlowEffect) {
      _glowController.repeat(reverse: true);
    }
    
    if (widget.enableBackgroundAnimation) {
      _backgroundController.repeat();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _glowController,
          _backgroundController,
        ]),
        builder: (context, child) {
          return Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: _buildDialogContainer(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🏗️ BUILD MAIN DIALOG CONTAINER
  Widget _buildDialogContainer() {
    return Container(
      width: widget.dialogWidth,
      height: widget.dialogHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.backgroundGradient,
          transform: widget.enableBackgroundAnimation
              ? GradientRotation(_backgroundAnimation.value * 2 * math.pi)
              : null,
        ),
        boxShadow: [
          // Outer glow shadow
          if (widget.enableGlowEffect)
            BoxShadow(
              color: widget.primaryColor.withOpacity(_glowAnimation.value * 0.3),
              blurRadius: 30 * _glowAnimation.value,
              spreadRadius: 5 * _glowAnimation.value,
            ),
          // Main shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background particle effects
          if (widget.enableParticleEffect) _buildParticleEffect(),
          
          // Main content
          _buildMainContent(),
          
          // Glassmorphism overlay
          _buildGlassmorphismOverlay(),
        ],
      ),
    );
  }

  /// ✨ BUILD PARTICLE EFFECT BACKGROUND
  Widget _buildParticleEffect() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticleEffectPainter(
            animation: _particleController,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
          ),
          size: Size(widget.dialogWidth, widget.dialogHeight),
        );
      },
    );
  }

  /// 🌟 BUILD GLASSMORPHISM OVERLAY
  Widget _buildGlassmorphismOverlay() {
    return Container(
      width: widget.dialogWidth,
      height: widget.dialogHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// 📝 BUILD MAIN CONTENT
  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated update icon
          _buildAnimatedIcon(),
          
          const SizedBox(height: 24),
          
          // Title
          _buildTitle(),
          
          const SizedBox(height: 8),
          
          // Version badge
          _buildVersionBadge(),
          
          const SizedBox(height: 20),
          
          // Subtitle
          _buildSubtitle(),
          
          const SizedBox(height: 32),
          
          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 🎯 BUILD ANIMATED ICON
  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * math.pi * 0.1,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: widget.buttonGradient,
              ),
              boxShadow: [
                if (widget.enableGlowEffect)
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(_glowAnimation.value * 0.6),
                    blurRadius: 20 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
              ],
            ),
            child: Icon(
              widget.updateIcon,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  /// 📌 BUILD TITLE
  Widget _buildTitle() {
    return Text(
      widget.title,
      style: TextStyle(
        color: widget.textColor,
        fontSize: widget.titleFontSize,
        fontWeight: widget.titleFontWeight,
        fontFamily: widget.fontFamily,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// 🏷️ BUILD VERSION BADGE
  Widget _buildVersionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.primaryColor.withOpacity(0.2),
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        widget.version,
        style: TextStyle(
          color: widget.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: widget.fontFamily,
        ),
      ),
    );
  }

  /// 📄 BUILD SUBTITLE
  Widget _buildSubtitle() {
    return Text(
      widget.subtitle,
      style: TextStyle(
        color: widget.subtitleColor,
        fontSize: widget.subtitleFontSize,
        fontWeight: widget.subtitleFontWeight,
        fontFamily: widget.fontFamily,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// 🎮 BUILD ACTION BUTTONS
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Update button
        _buildGradientButton(
          text: widget.updateButtonText,
          onPressed: () {
            if (widget.onUpdatePressed != null) {
              widget.onUpdatePressed!();
            }
            Navigator.of(context).pop();
          },
          isMainAction: true,
        ),
        
        const SizedBox(height: 12),
        
        // Later button
        _buildGradientButton(
          text: widget.laterButtonText,
          onPressed: () {
            if (widget.onLaterPressed != null) {
              widget.onLaterPressed!();
            }
            Navigator.of(context).pop();
          },
          isMainAction: false,
        ),
      ],
    );
  }

  /// 🔘 BUILD GRADIENT BUTTON
  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required bool isMainAction,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: onPressed,
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: isMainAction
                    ? LinearGradient(colors: widget.buttonGradient)
                    : null,
                color: !isMainAction ? Colors.transparent : null,
                border: !isMainAction
                    ? Border.all(
                        color: widget.primaryColor.withOpacity(0.5),
                        width: 1,
                      )
                    : null,
                boxShadow: isMainAction && widget.enableGlowEffect
                    ? [
                        BoxShadow(
                          color: widget.primaryColor.withOpacity(
                            _glowAnimation.value * 0.4,
                          ),
                          blurRadius: 15 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMainAction ? Colors.white : widget.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: widget.fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 🎨 CUSTOM PARTICLE EFFECT PAINTER
class ParticleEffectPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;
  
  ParticleEffectPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Generate animated particles
    for (int i = 0; i < 15; i++) {
      final progress = (animation.value + i * 0.1) % 1.0;
      final x = (size.width * 0.2) + 
          (size.width * 0.6) * math.sin(progress * 2 * math.pi + i);
      final y = size.height * progress;
      final opacity = (1 - progress) * 0.6;
      final radius = 2 + 3 * (1 - progress);
      
      paint.color = (i % 2 == 0 ? primaryColor : secondaryColor)
          .withOpacity(opacity);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 🚀 DEMO USAGE EXAMPLE
class FuturisticUpdateDialogDemo extends StatelessWidget {
  const FuturisticUpdateDialogDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Futuristic Update Dialog Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showDefaultDialog(context),
              child: const Text('Show Default Dialog'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showCustomDialog(context),
              child: const Text('Show Custom Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDefaultDialog(BuildContext context) {
    FuturisticUpdateDialog.show(context);
  }

  void _showCustomDialog(BuildContext context) {
    FuturisticUpdateDialog.show(
      context,
      dialog: FuturisticUpdateDialog(
        primaryColor: const Color(0xFFFF6B6B),
        secondaryColor: const Color(0xFF4ECDC4),
        backgroundGradient: const [
          Color(0xFF2C1810),
          Color(0xFF3D2914),
          Color(0xFF8B4513),
        ],
        title: "🎉 Major Update!",
        subtitle: "Experience revolutionary features with enhanced performance and stunning new interface designs.",
        version: "v3.0.0",
        enableParticleEffect: true,
        enableGlowEffect: true,
        animationDuration: const Duration(milliseconds: 1200),
        onUpdatePressed: () {
          Navigator.of(context).pop();
        },
        onLaterPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}