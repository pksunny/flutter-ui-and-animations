import 'package:flutter/material.dart';

class CharacterLimitProgressBarScreen extends StatefulWidget {
  @override
  _CharacterLimitProgressBarScreenState createState() => _CharacterLimitProgressBarScreenState();
}

class _CharacterLimitProgressBarScreenState extends State<CharacterLimitProgressBarScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final int maxCharacters = 50; // Max characters set to 50
  int currentCharacters = 0;

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _glowController;

  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Progress animation controller
    _progressController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Shake animation controller
    _shakeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // Glow animation controller
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Color animation based on progress
    _colorAnimation = ColorTween(
      begin: Color(0xFF00D4AA), // Greenish
      end: Color(0xFFFF6B6B),   // Reddish
    ).animate(_progressController);

    // Start glow animation
    _glowController.repeat(reverse: true);

    // Listen to text changes
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      currentCharacters = _controller.text.length;
    });

    // Calculate progress accurately
    double progress = currentCharacters / maxCharacters;
    // Ensure progress is between 0.0 and 1.0
    progress = progress.clamp(0.0, 1.0);

    // Animate to the calculated progress
    // Use animateTo to move directly to the value, or forward/reverse for dynamic animation
    _progressController.animateTo(progress); // <-- This line is key

    // Trigger pulse animation when typing
    _pulseController.forward().then((_) => _pulseController.reverse());

    // Shake when approaching or exceeding limit
    if (currentCharacters >= maxCharacters * 0.9) {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _glowController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress for UI elements, ensure it's within bounds
    double progress = (currentCharacters / maxCharacters).clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),

                // Title
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00D4AA).withOpacity(_glowAnimation.value * 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        'Character Limit Tracker',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 8),
                Text(
                  'Type your message and watch the magic happen',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 48),

                // Text Field with Animations
                AnimatedBuilder(
                  animation: Listenable.merge([_shakeAnimation, _pulseAnimation]),
                  builder: (context, child) {
                    return Transform.translate(
                      // Apply shake only when approaching or exceeding limit
                      offset: Offset(_shakeAnimation.value * (progress > 0.9 ? 1 : 0), 0),
                      child: Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF2A2A2A),
                                Color(0xFF1F1F1F),
                              ],
                            ),
                            border: Border.all(
                              // Change border color based on progress
                              color: progress > 0.9
                                  ? Color(0xFFFF6B6B).withOpacity(0.8)
                                  : Color(0xFF00D4AA).withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (progress > 0.9 ? Color(0xFFFF6B6B) : Color(0xFF00D4AA))
                                    .withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: 6,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Start typing your amazing content...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(24),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 32),

                // Progress Bar Container
                AnimatedBuilder(
                  animation: Listenable.merge([_progressAnimation, _colorAnimation, _glowAnimation]),
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _colorAnimation.value!.withOpacity(_glowAnimation.value * 0.4),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              // Background glow effect
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      _colorAnimation.value!.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              // Progress bar
                              FractionallySizedBox(
                                // Use the directly calculated progress for the width
                                widthFactor: progress,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: progress > 0.9
                                          ? [Color(0xFFFF6B6B), Color(0xFFFF8E8E)] // Red range
                                          : progress > 0.7
                                              ? [Color(0xFFFFB366), Color(0xFFFF8E66)] // Orange range
                                              : [Color(0xFF00D4AA), Color(0xFF00E4BA)], // Green range
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),

                              // Shimmer effect
                              if (progress > 0) // Only show shimmer if there's progress
                                FractionallySizedBox(
                                  widthFactor: progress, // Match progress bar width
                                  child: Container(
                                    height: 12,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                        // Rotate shimmer based on glow animation
                                        transform: GradientRotation(_glowAnimation.value * 6.28),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24),

                // Character Counter with Animations
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) {
                        return Text(
                          'Characters',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),

                    AnimatedBuilder(
                      animation: Listenable.merge([_colorAnimation, _pulseAnimation, _shakeAnimation]),
                      builder: (context, child) {
                        return Transform.scale(
                          // Pulse only when approaching limit
                          scale: progress > 0.9 ? _pulseAnimation.value : 1.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _colorAnimation.value!.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _colorAnimation.value!.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '$currentCharacters / $maxCharacters',
                              style: TextStyle(
                                fontSize: 18,
                                color: _colorAnimation.value,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Status Message
                Builder(
                  builder: (context) {
                    // Use the already calculated and clamped 'progress' for consistency
                    Color currentColor = progress > 0.9
                        ? Color(0xFFFF6B6B) // Red
                        : progress > 0.7
                            ? Color(0xFFFFB366) // Orange
                            : Color(0xFF00D4AA); // Green

                    String statusMessage = '';
                    if (progress < 0.5) {
                      statusMessage = '✨ Keep going, you\'re doing great!';
                    } else if (progress < 0.8) {
                      statusMessage = '🔥 You\'re on fire!';
                    } else if (progress < 0.95) {
                      statusMessage = '⚠️ Almost at the limit!';
                    } else if (progress >= 1.0) {
                      statusMessage = '🚫 Character limit reached!';
                    } else {
                      statusMessage = '⚡ Just a few more characters!';
                    }

                    return AnimatedOpacity(
                      opacity: currentCharacters > 0 ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: currentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: currentColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          statusMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: currentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}