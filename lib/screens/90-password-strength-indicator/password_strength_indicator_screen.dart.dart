import 'package:flutter/material.dart';

class PasswordStrengthIndicatorScreen extends StatefulWidget {
  @override
  _PasswordStrengthIndicatorScreenState createState() => _PasswordStrengthIndicatorScreenState();
}

class _PasswordStrengthIndicatorScreenState extends State<PasswordStrengthIndicatorScreen>
    with TickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;
  
  PasswordStrength _currentStrength = PasswordStrength.none;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _glowController.repeat(reverse: true);
    
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
    final newStrength = _calculatePasswordStrength(password);
    
    if (newStrength != _currentStrength) {
      setState(() {
        _currentStrength = newStrength;
      });
      
      _animationController.forward(from: 0.0);
      
      if (newStrength != PasswordStrength.none) {
        _bounceController.forward(from: 0.0).then((_) {
          _bounceController.reverse();
        });
      }
    }
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.normal;
    if (score <= 5) return PasswordStrength.medium;
    return PasswordStrength.strong;
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
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'Create Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Choose a strong password to secure your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 48),
                  
                  // Password Input Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 20,
                          spreadRadius: -5,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Password Input Field
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _currentStrength.color.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _isObscured,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D3748),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFF9CA3AF),
                                size: 22,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(0xFF9CA3AF),
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Password Strength Indicator
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _scaleAnimation,
                            _bounceAnimation,
                            _glowAnimation,
                          ]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _bounceAnimation.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Strength Label
                                  if (_currentStrength != PasswordStrength.none)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _currentStrength.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _currentStrength.color.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _currentStrength.icon,
                                            size: 16,
                                            color: _currentStrength.color,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            _currentStrength.label,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: _currentStrength.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  
                                  SizedBox(height: 16),
                                  
                                  // Progress Bars
                                  Row(
                                    children: List.generate(4, (index) {
                                      final isActive = index < _currentStrength.level;
                                      final delay = index * 0.1;
                                      
                                      return Expanded(
                                        child: Container(
                                          height: 8,
                                          margin: EdgeInsets.only(
                                            right: index < 3 ? 8 : 0,
                                          ),
                                          child: AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 600 + (delay * 1000).round(),
                                            ),
                                            curve: Curves.easeInOutCubic,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              gradient: isActive
                                                  ? LinearGradient(
                                                      colors: [
                                                        _currentStrength.color,
                                                        _currentStrength.color,
                                                      ],
                                                    )
                                                  : null,
                                              color: isActive
                                                  ? null
                                                  : Color(0xFFE5E7EB),
                                              
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                        // Password Requirements
                        if (_passwordController.text.isNotEmpty) ...[
                          SizedBox(height: 24),
                          Text(
                            'Password Requirements',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          SizedBox(height: 12),
                          ..._getPasswordRequirements().map((req) => 
                            _buildRequirement(req.text, req.isMet)
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Continue Button
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _currentStrength.level >= 2 ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentStrength.level >= 2
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        foregroundColor: _currentStrength.level >= 2
                            ? Color(0xFF667eea)
                            : Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _currentStrength.level >= 2 ? 8 : 0,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
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
      ),
    );
  }

  List<PasswordRequirement> _getPasswordRequirements() {
    final password = _passwordController.text;
    return [
      PasswordRequirement('At least 8 characters', password.length >= 8),
      PasswordRequirement('Contains uppercase letter', password.contains(RegExp(r'[A-Z]'))),
      PasswordRequirement('Contains lowercase letter', password.contains(RegExp(r'[a-z]'))),
      PasswordRequirement('Contains number', password.contains(RegExp(r'[0-9]'))),
      PasswordRequirement('Contains special character', password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))),
    ];
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isMet ? Colors.green : Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isMet ? Icons.check : Icons.close,
              size: 12,
              color: isMet ? Colors.white : Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isMet ? Color(0xFF374151) : Color(0xFF9CA3AF),
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

enum PasswordStrength {
  none(0, 'None', Colors.grey, Icons.help_outline),
  weak(1, 'Weak', Color(0xFFEF4444), Icons.warning_outlined),
  normal(2, 'Fair', Color(0xFFF97316), Icons.info_outlined),
  medium(3, 'Good', Color.fromARGB(255, 255, 191, 0), Icons.thumb_up_outlined),
  strong(4, 'Strong', Color(0xFF22C55E), Icons.verified_outlined);

  const PasswordStrength(this.level, this.label, this.color, this.icon);
  final int level;
  final String label;
  final Color color;
  final IconData icon;
}

class PasswordRequirement {
  final String text;
  final bool isMet;

  PasswordRequirement(this.text, this.isMet);
}