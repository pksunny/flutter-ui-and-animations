import 'package:flutter/material.dart';
import 'dart:math' as math;

class AchievementUiScreen extends StatefulWidget {
  @override
  _AchievementUiScreenState createState() => _AchievementUiScreenState();
}

class _AchievementUiScreenState extends State<AchievementUiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1117),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Demo Button to trigger achievement
            ElevatedButton(
              onPressed: () {
                _showAchievement();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6366F1),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Complete Task & See Magic ✨',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Tap to experience the ultimate\nachievement celebration!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievement() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) => AchievementMilestoneUI(
        title: "Congratulations! 🎉",
        subtitle: "You've completed your daily goal!",
        achievementType: AchievementType.dailyGoal,
        badgeIcon: Icons.star,
        onComplete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

/// 🏆 Achievement Types - Fully Customizable
enum AchievementType {
  dailyGoal,
  streak,
  milestone,
  levelUp,
  perfect,
  firstTime,
}

/// 🎨 Main Achievement Milestone UI Widget
class AchievementMilestoneUI extends StatefulWidget {
  final String title;
  final String subtitle;
  final AchievementType achievementType;
  final IconData badgeIcon;
  final Color? primaryColor;
  final Color? secondaryColor;
  final VoidCallback? onComplete;
  final Duration animationDuration;
  final bool showConfetti;
  final bool showParticles;
  final bool showPulseEffect;

  const AchievementMilestoneUI({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.achievementType,
    required this.badgeIcon,
    this.primaryColor,
    this.secondaryColor,
    this.onComplete,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.showConfetti = true,
    this.showParticles = true,
    this.showPulseEffect = true,
  }) : super(key: key);

  @override
  _AchievementMilestoneUIState createState() => _AchievementMilestoneUIState();
}

class _AchievementMilestoneUIState extends State<AchievementMilestoneUI>
    with TickerProviderStateMixin {
  
  // 🎭 Animation Controllers
  late AnimationController _mainController;
  late AnimationController _badgeController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;

  // 🎨 Animations
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _badgeRotateAnimation;
  late Animation<double> _badgeScaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Main container animations
    _mainController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Badge animations
    _badgeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text animations
    _textController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    // Particle effects
    _particleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Confetti effects
    _confettiController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Pulse effect
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Define animations
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeIn),
    );

    _badgeRotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.elasticOut),
    );

    _badgeScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.bounceOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    // Start main container animation
    await _mainController.forward();
    
    // Start badge animation with slight delay
    await Future.delayed(Duration(milliseconds: 200));
    _badgeController.forward();
    
    // Start particles and confetti
    if (widget.showParticles) _particleController.repeat();
    if (widget.showConfetti) _confettiController.forward();
    
    // Start text animation
    await Future.delayed(Duration(milliseconds: 400));
    await _textController.forward();
    
    // Start pulse effect
    if (widget.showPulseEffect) _pulseController.repeat(reverse: true);
    
    // Auto-dismiss after animation duration
    await Future.delayed(widget.animationDuration);
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _badgeController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _primaryColor =>
      widget.primaryColor ?? _getThemeColor(widget.achievementType);

  Color get _secondaryColor =>
      widget.secondaryColor ?? _getSecondaryColor(widget.achievementType);

  Color _getThemeColor(AchievementType type) {
    switch (type) {
      case AchievementType.dailyGoal:
        return Color(0xFF6366F1);
      case AchievementType.streak:
        return Color(0xFFEF4444);
      case AchievementType.milestone:
        return Color(0xFF10B981);
      case AchievementType.levelUp:
        return Color(0xFFF59E0B);
      case AchievementType.perfect:
        return Color(0xFF8B5CF6);
      case AchievementType.firstTime:
        return Color(0xFF06B6D4);
    }
  }

  Color _getSecondaryColor(AchievementType type) {
    switch (type) {
      case AchievementType.dailyGoal:
        return Color(0xFF818CF8);
      case AchievementType.streak:
        return Color(0xFFF87171);
      case AchievementType.milestone:
        return Color(0xFF34D399);
      case AchievementType.levelUp:
        return Color(0xFFFBBF24);
      case AchievementType.perfect:
        return Color(0xFFA78BFA);
      case AchievementType.firstTime:
        return Color(0xFF67E8F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Particle effects background
          if (widget.showParticles) ..._buildParticleEffects(),
          
          // Confetti effects
          if (widget.showConfetti) ..._buildConfettiEffects(),
          
          // Main achievement card
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildAchievementCard(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 30,
            offset: Offset(0, 15),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.grey.shade100,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge with animation
            _buildAnimatedBadge(),
            SizedBox(height: 24),
            
            // Title and subtitle with animations
            _buildAnimatedText(),
            SizedBox(height: 32),
            
            // Action button
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBadge() {
    return AnimatedBuilder(
      animation: Listenable.merge([_badgeController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _badgeScaleAnimation.value * 
                 (widget.showPulseEffect ? _pulseAnimation.value : 1.0),
          child: Transform.rotate(
            angle: _badgeRotateAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _primaryColor,
                    _secondaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.badgeIcon,
                  size: 48,
                  color: _primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Column(
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: ElevatedButton(
            onPressed: widget.onComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: _primaryColor.withOpacity(0.3),
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildParticleEffects() {
    return List.generate(20, (index) {
      return AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          final progress = _particleController.value;
          final angle = (index / 20) * 2 * math.pi;
          final radius = 100 + (progress * 200);
          final x = math.cos(angle) * radius;
          final y = math.sin(angle) * radius;
          
          return Positioned(
            left: MediaQuery.of(context).size.width / 2 + x,
            top: MediaQuery.of(context).size.height / 2 + y,
            child: Opacity(
              opacity: (1 - progress) * 0.7,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryColor,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  List<Widget> _buildConfettiEffects() {
    return List.generate(30, (index) {
      return AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          final progress = _confettiController.value;
          final random = math.Random(index);
          final startX = random.nextDouble() * MediaQuery.of(context).size.width;
          final endY = MediaQuery.of(context).size.height + 50;
          final y = -50 + (progress * (endY + 50));
          final rotation = progress * 4 * math.pi;
          
          final colors = [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
          ];
          
          return Positioned(
            left: startX,
            top: y,
            child: Transform.rotate(
              angle: rotation,
              child: Opacity(
                opacity: 1 - progress,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}