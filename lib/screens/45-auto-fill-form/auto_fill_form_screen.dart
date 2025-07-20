import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class AutoFillFormScreen extends StatefulWidget {
  @override
  _AutoFillFormScreenState createState() => _AutoFillFormScreenState();
}

class _AutoFillFormScreenState extends State<AutoFillFormScreen>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _fadeAnimations = [];
  List<Animation<double>> _scaleAnimations = [];
  List<Animation<double>> _shakeAnimations = [];
  List<Animation<Color?>> _colorAnimations = [];
  
  List<TextEditingController> _textControllers = [];
  List<bool> _fieldCompleted = [];
  List<bool> _isAnimating = [];
  
  final List<String> _fieldLabels = [
    'Full Name',
    'Email Address',
    'Phone Number',
    'Password',
  ];
  
  final List<String> _autoFillData = [
    'Alexander Johnson',
    'alex.johnson@gmail.com',
    '+1 (555) 123-4567',
    '••••••••••••',
  ];
  
  final List<IconData> _fieldIcons = [
    Icons.person_outline,
    Icons.email_outlined,
    Icons.phone_outlined,
    Icons.lock_outline,
  ];
  
  bool _autoFillStarted = false;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Background animation
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Initialize controllers and animations for each field
    for (int i = 0; i < _fieldLabels.length; i++) {
      // Main animation controller
      AnimationController controller = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      );
      _controllers.add(controller);

      // Fade animation
      Animation<double> fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ));
      _fadeAnimations.add(fadeAnimation);

      // Scale animation
      Animation<double> scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.6, curve: Curves.elasticOut),
      ));
      _scaleAnimations.add(scaleAnimation);

      // Shake animation
      Animation<double> shakeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.6, 1.0, curve: Curves.elasticOut),
      ));
      _shakeAnimations.add(shakeAnimation);

      // Color animation
      Animation<Color?> colorAnimation = ColorTween(
        begin: Colors.grey.withOpacity(0.3),
        end: Color(0xFF00D4FF),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
      _colorAnimations.add(colorAnimation);

      // Text controller
      _textControllers.add(TextEditingController());
      _fieldCompleted.add(false);
      _isAnimating.add(false);
    }

    _backgroundController.forward();
  }

  void _startAutoFill() async {
    if (_autoFillStarted) return;
    
    setState(() {
      _autoFillStarted = true;
    });

    for (int i = 0; i < _fieldLabels.length; i++) {
      setState(() {
        _isAnimating[i] = true;
      });

      // Start the animation
      _controllers[i].forward();

      // Wait for the scale/fade animation to complete
      await Future.delayed(Duration(milliseconds: 400));

      // Start typing effect
      await _typeText(i, _autoFillData[i]);

      // Mark as completed
      setState(() {
        _fieldCompleted[i] = true;
        _isAnimating[i] = false;
      });

      // Small delay before next field
      await Future.delayed(Duration(milliseconds: 300));
    }
  }

  Future<void> _typeText(int index, String text) async {
    for (int i = 0; i <= text.length; i++) {
      if (mounted) {
        setState(() {
          _textControllers[index].text = text.substring(0, i);
        });
        await Future.delayed(Duration(milliseconds: 50));
      }
    }
  }

  void _resetAnimation() {
    setState(() {
      _autoFillStarted = false;
      for (int i = 0; i < _fieldLabels.length; i++) {
        _controllers[i].reset();
        _textControllers[i].clear();
        _fieldCompleted[i] = false;
        _isAnimating[i] = false;
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var textController in _textControllers) {
      textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(Color(0xFF0A0A0F), Color(0xFF1A1A2E), 
                      _backgroundAnimation.value)!,
                  Color.lerp(Color(0xFF16213E), Color(0xFF0F3460), 
                      _backgroundAnimation.value)!,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF5A67D8)],
                      ).createShader(bounds),
                      child: Text(
                        'Auto-Fill Magic',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Watch the form fill itself',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 48),

                    // Form Fields
                    ...List.generate(_fieldLabels.length, (index) {
                      return AnimatedBuilder(
                        animation: Listenable.merge([
                          _fadeAnimations[index],
                          _scaleAnimations[index],
                          _shakeAnimations[index],
                          _colorAnimations[index],
                        ]),
                        builder: (context, child) {
                          double shakeOffset = 0;
                          if (_isAnimating[index]) {
                            shakeOffset = math.sin(_shakeAnimations[index].value * 
                                math.pi * 4) * 2;
                          }

                          return Transform.translate(
                            offset: Offset(shakeOffset, 0),
                            child: Transform.scale(
                              scale: _scaleAnimations[index].value,
                              child: Opacity(
                                opacity: _fadeAnimations[index].value,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Stack(
                                    children: [
                                      // Glow effect
                                      if (_isAnimating[index] || _fieldCompleted[index])
                                        Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _colorAnimations[index].value!
                                                    .withOpacity(0.5),
                                                blurRadius: 20,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      
                                      // Text field
                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1E1E2E).withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: _colorAnimations[index].value!,
                                            width: 2,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _textControllers[index],
                                          readOnly: true,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: _fieldLabels[index],
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                            prefixIcon: Icon(
                                              _fieldIcons[index],
                                              color: _colorAnimations[index].value,
                                            ),
                                            suffixIcon: _fieldCompleted[index]
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Color(0xFF00FF87),
                                                  )
                                                : null,
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 18,
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
                        },
                      );
                    }),

                    SizedBox(height: 40),

                    // Control Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _autoFillStarted ? null : _startAutoFill,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00D4FF),
                              foregroundColor: Color(0xFF0A0A0F),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Start Auto-Fill',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetAnimation,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFF00D4FF),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(color: Color(0xFF00D4FF)),
                            ),
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}