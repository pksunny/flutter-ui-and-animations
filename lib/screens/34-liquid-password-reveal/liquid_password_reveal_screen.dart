import 'package:flutter/material.dart';

class ProgressiveTextPainter extends CustomPainter {
  final String password;
  final double revealProgress;
  final TextStyle textStyle;

  ProgressiveTextPainter({
    required this.password,
    required this.revealProgress,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    // Calculate available width for text (excluding button and padding)
    final availableWidth = size.width - 100; // More space for button
    final startX = 20.0; // Left padding
    final startY = (size.height - 20) / 2; // Center vertically

    // Calculate reveal position based on available width
    final revealWidth = availableWidth * revealProgress;

    // Draw each character individually
    double currentX = startX;
    for (int i = 0; i < password.length; i++) {
      final char = password[i];
      final charTextPainter = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      charTextPainter.layout();

      // Stop drawing if we exceed available width
      if (currentX + charTextPainter.width > startX + availableWidth) {
        break;
      }

      // Calculate character position
      final charEndX = currentX + charTextPainter.width;
      final charCenterX = currentX + (charTextPainter.width / 2);

      // Determine what to show based on liquid position
      String displayChar;
      Color charColor;
      
      // Only reveal if liquid has passed the character center AND we're not at the very beginning
      if (revealProgress > 0.05 && charCenterX <= startX + revealWidth) {
        // Fully revealed
        displayChar = char;
        charColor = Colors.white;
      } else if (revealProgress > 0.05 && currentX <= startX + revealWidth && charEndX > startX + revealWidth) {
        // Partially revealed - show actual character with reduced opacity
        displayChar = char;
        charColor = Colors.white.withOpacity(0.3);
      } else {
        // Hidden - show dot
        displayChar = '●';
        charColor = Colors.white.withOpacity(0.6);
      }

      // Create text span with appropriate color
      final charTextSpan = TextSpan(
        text: displayChar,
        style: textStyle.copyWith(color: charColor),
      );
      
      charTextPainter.text = charTextSpan;
      charTextPainter.layout();

      // Draw the character
      charTextPainter.paint(canvas, Offset(currentX, startY));
      
      currentX += charTextPainter.width;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LiquidPasswordRevealScreen extends StatefulWidget {
  @override
  _LiquidPasswordRevealScreenState createState() => _LiquidPasswordRevealScreenState();
}

class _LiquidPasswordRevealScreenState extends State<LiquidPasswordRevealScreen>
    with TickerProviderStateMixin {
  late AnimationController _liquidController;
  late AnimationController _glowController;
  late Animation<double> _liquidAnimation;
  late Animation<double> _glowAnimation;
  
  TextEditingController _passwordController = TextEditingController();
  bool _isRevealed = false;
  bool _isAnimating = false;
  String _actualPassword = "MySecurePassword123!";

  @override
  void initState() {
    super.initState();
    
    // Set initial password (dots)
    _passwordController.text = _actualPassword;
    
    // Liquid reveal animation
    _liquidController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _liquidAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _liquidController,
      curve: Curves.easeInOutCubic,
    ));

    // Glow animation
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _liquidController.dispose();
    _glowController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
    });

    if (!_isRevealed) {
      // Start revealing
      setState(() {
        _isRevealed = true;
      });
      _liquidController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    } else {
      // Start hiding
      setState(() {
        _isRevealed = false;
      });
      _liquidController.reverse().then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  // Progressive password reveal based on liquid position
  Widget _buildProgressivePasswordText() {
    return AnimatedBuilder(
      animation: _liquidAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ProgressiveTextPainter(
            password: _actualPassword,
            revealProgress: _liquidAnimation.value,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
          size: Size(double.infinity, 56),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Liquid Security',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Experience fluid password protection',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 60),
                
                // Password Field Container
                Container(
                  height: 200,
                  child: Stack(
                    children: [
                      // Animated background glow
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF4FC3F7).withOpacity(0.3 * _glowAnimation.value),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      // Main password field
                      Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A2E).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFF4FC3F7).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Password input
                            Positioned.fill(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        child: _buildProgressivePasswordText(),
                                      ),
                                    ),
                                    
                                    // Liquid reveal button
                                    GestureDetector(
                                      onTap: _toggleReveal,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF4FC3F7).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(
                                            color: Color(0xFF4FC3F7).withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: AnimatedBuilder(
                                          animation: _liquidAnimation,
                                          builder: (context, child) {
                                            return Stack(
                                              children: [
                                                // Liquid fill effect
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(25),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50 * _liquidAnimation.value,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          Color(0xFF4FC3F7).withOpacity(0.8),
                                                          Color(0xFF29B6F6).withOpacity(0.9),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                
                                                // Droplet icon
                                                Center(
                                                  child: Icon(
                                                    Icons.water_drop,
                                                    color: _liquidAnimation.value > 0.5 
                                                        ? Colors.white 
                                                        : Color(0xFF4FC3F7),
                                                    size: 24,
                                                  ),
                                                ),
                                                
                                                // Ripple effect
                                                if (_isAnimating)
                                                  Center(
                                                    child: Container(
                                                      width: 50 * (1 + _liquidAnimation.value * 0.5),
                                                      height: 50 * (1 + _liquidAnimation.value * 0.5),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFF4FC3F7).withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Liquid wiper effect
                            AnimatedBuilder(
                              animation: _liquidAnimation,
                              builder: (context, child) {
                                if (_liquidAnimation.value == 0.0) return SizedBox();
                                
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      // Liquid overlay
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        width: (MediaQuery.of(context).size.width - 140) * _liquidAnimation.value,
                                        height: 80,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                              topRight: Radius.circular(_liquidAnimation.value == 1.0 ? 16 : 0),
                                              bottomRight: Radius.circular(_liquidAnimation.value == 1.0 ? 16 : 0),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFF4FC3F7).withOpacity(0.1),
                                                Color(0xFF29B6F6).withOpacity(0.2),
                                                Color(0xFF4FC3F7).withOpacity(0.1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                              // Liquid edge with wave effect
                                      Positioned(
                                        left: ((MediaQuery.of(context).size.width - 140) * _liquidAnimation.value) - 10,
                                        top: 0,
                                        child: Container(
                                          width: 20,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFF4FC3F7).withOpacity(0.4),
                                                Color(0xFF29B6F6).withOpacity(0.6),
                                                Color(0xFF4FC3F7).withOpacity(0.8),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 40),
                
                // Status indicator
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isRevealed 
                        ? Color(0xFF4FC3F7).withOpacity(0.2)
                        : Color(0xFF666666).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isRevealed 
                          ? Color(0xFF4FC3F7).withOpacity(0.5)
                          : Color(0xFF666666).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isRevealed ? Icons.visibility : Icons.visibility_off,
                        color: _isRevealed ? Color(0xFF4FC3F7) : Colors.grey,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _isRevealed ? 'Password Revealed' : 'Password Hidden',
                        style: TextStyle(
                          color: _isRevealed ? Color(0xFF4FC3F7) : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 60),
                
                // Login button
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4FC3F7),
                        Color(0xFF29B6F6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4FC3F7).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}