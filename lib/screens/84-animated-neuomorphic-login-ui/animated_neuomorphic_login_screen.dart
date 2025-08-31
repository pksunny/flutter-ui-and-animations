import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class AnimatedNeuomorphicLoginScreen extends StatefulWidget {
  @override
  _AnimatedNeuomorphicLoginScreenState createState() => _AnimatedNeuomorphicLoginScreenState();
}

class _AnimatedNeuomorphicLoginScreenState extends State<AnimatedNeuomorphicLoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  late AnimationController _buttonController;
  late AnimationController _particleController;
  
  late Animation<double> _backgroundAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _cardController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);
    
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    );
    
    _slideAnimation = Tween<double>(
      begin: 100,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeIn,
    ));
    
    _cardController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    _buttonController.dispose();
    _particleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFe8f4fd),
                Color(0xFFf0f8ff),
                Color(0xFFfaf7ff),
              ],
            ),
          ),
          child: CustomPaint(
            painter: ParticlePainter(_backgroundAnimation.value),
            child: Container(),
          ),
        );
      },
    );
  }

  Widget _buildNeuomorphicContainer({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    bool isPressed = false,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFf0f0f3),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: Color(0xFFbabecc),
                  offset: Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2, -2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: Color(0xFFbabecc),
                  offset: Offset(8, 8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  offset: Offset(-8, -8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: child,
    );
  }

  Widget _buildNeuomorphicTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: _buildNeuomorphicContainer(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF2d3748),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color(0xFFa0aec0),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                icon,
                color: Color(0xFF667eea),
                size: 22,
              ),
            ),
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton() {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) => _buttonController.reverse(),
      onTapCancel: () => _buttonController.reverse(),
      onTap: _handleLogin,
      child: AnimatedBuilder(
        animation: _buttonController,
        builder: (context, child) {
          return _buildNeuomorphicContainer(
            width: double.infinity,
            height: 60,
            isPressed: _buttonController.value > 0.5,
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )
                  : Text(
                      _isLogin ? 'Login' : 'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Handle social login
      },
      child: _buildNeuomorphicContainer(
        width: 60,
        height: 60,
        padding: EdgeInsets.all(15),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildToggleText() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isLogin = !_isLogin;
        });
        HapticFeedback.selectionClick();
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF2d3748),
          ),
          children: [
            TextSpan(
              text: _isLogin
                  ? "Don't have an account? "
                  : "Already have an account? ",
            ),
            TextSpan(
              text: _isLogin ? 'Sign Up' : 'Login',
              style: TextStyle(
                color: Color(0xFF667eea),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    HapticFeedback.lightImpact();

    // Simulate network request
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLogin ? 'Login successful!' : 'Account created!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF667eea),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: AnimatedBuilder(
                  animation: _cardAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Scale(
                          scale: _cardAnimation.value,
                          child: _buildNeuomorphicContainer(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo/Title Section
                                Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    children: [
                                      _buildNeuomorphicContainer(
                                        width: 80,
                                        height: 80,
                                        padding: EdgeInsets.all(20),
                                        child: Icon(
                                          Icons.fingerprint,
                                          size: 40,
                                          color: Color(0xFF667eea),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        _isLogin ? 'Welcome Back' : 'Create Account',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2d3748),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        _isLogin
                                            ? 'Sign in to your account'
                                            : 'Join us today',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFa0aec0),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Input Fields
                                _buildNeuomorphicTextField(
                                  hintText: 'Email',
                                  icon: Icons.email_outlined,
                                  controller: _emailController,
                                ),

                                _buildNeuomorphicTextField(
                                  hintText: 'Password',
                                  icon: Icons.lock_outline,
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Color(0xFFa0aec0),
                                    ),
                                  ),
                                ),

                                if (_isLogin) ...[
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        // Handle forgot password
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Color(0xFF667eea),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                SizedBox(height: 30),

                                // Login Button
                                _buildAnimatedButton(),

                                SizedBox(height: 30),

                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Color(0xFFe2e8f0),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        'Or continue with',
                                        style: TextStyle(
                                          color: Color(0xFFa0aec0),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Color(0xFFe2e8f0),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Social Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildSocialButton(Icons.g_mobiledata, Color(0xFFdb4437)),
                                    _buildSocialButton(Icons.facebook, Color(0xFF3b5998)),
                                    _buildSocialButton(Icons.apple, Color(0xFF000000)),
                                  ],
                                ),

                                SizedBox(height: 30),

                                // Toggle Login/Signup
                                _buildToggleText(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Scale extends StatelessWidget {
  final double scale;
  final Widget child;

  const Scale({Key? key, required this.scale, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: child,
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF667eea).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final double x = (size.width * 0.1) + 
          (size.width * 0.8 * ((i * 0.1 + animationValue * 0.5) % 1));
      final double y = (size.height * 0.1) + 
          (size.height * 0.8 * ((i * 0.07 + animationValue * 0.3) % 1));
      
      final double radius = 2 + (3 * math.sin(animationValue * 2 * math.pi + i));
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw some floating orbs
    paint.color = Color(0xFF764ba2).withOpacity(0.05);
    for (int i = 0; i < 8; i++) {
      final double x = size.width * 0.2 + 
          (size.width * 0.6 * ((i * 0.13 + animationValue * 0.2) % 1));
      final double y = size.height * 0.2 + 
          (size.height * 0.6 * ((i * 0.17 + animationValue * 0.15) % 1));
      
      final double radius = 15 + (10 * math.sin(animationValue * math.pi + i * 0.5));
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}