import 'package:flutter/material.dart';

class EmotionalEmojiScreen extends StatefulWidget {
  @override
  _EmotionalEmojiScreenState createState() => _EmotionalEmojiScreenState();
}

class _EmotionalEmojiScreenState extends State<EmotionalEmojiScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late AnimationController _rotateController;
  late AnimationController _colorController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Color?> _colorAnimation;
  
  String currentEmoji = '😐';
  EmotionState emotionState = EmotionState.neutral;
  
  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _colorController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );
    
    _colorAnimation = ColorTween(
      begin: Color(0xFF4A4A4A),
      end: Color(0xFF6C63FF),
    ).animate(_colorController);
    
    _pulseController.repeat(reverse: true);
    
    // Listen to form changes
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    _rotateController.dispose();
    _colorController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  void _validateForm() {
    bool isNameValid = _nameController.text.isNotEmpty && _nameController.text.length > 2;
    bool isEmailValid = _emailController.text.isNotEmpty && 
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text);
    bool isPhoneValid = _phoneController.text.isNotEmpty && 
        RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(_phoneController.text);
    
    int validFields = 0;
    if (isNameValid) validFields++;
    if (isEmailValid) validFields++;
    if (isPhoneValid) validFields++;
    
    EmotionState newState;
    String newEmoji;
    
    if (validFields == 0) {
      newState = EmotionState.neutral;
      newEmoji = '😐';
    } else if (validFields == 1) {
      newState = EmotionState.slightly_happy;
      newEmoji = '🙂';
    } else if (validFields == 2) {
      newState = EmotionState.happy;
      newEmoji = '😊';
    } else {
      newState = EmotionState.very_happy;
      newEmoji = '🤩';
    }
    
    if (newState != emotionState) {
      setState(() {
        emotionState = newState;
        currentEmoji = newEmoji;
      });
      _triggerEmotionAnimation();
    }
  }
  
  void _triggerEmotionAnimation() {
    _bounceController.reset();
    _bounceController.forward();
    
    if (emotionState == EmotionState.very_happy) {
      _rotateController.reset();
      _rotateController.forward();
      _colorController.forward();
    } else {
      _colorController.reverse();
    }
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
              Color(0xFF0A0A0F),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                
                // Title
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF3F3FFF)],
                  ).createShader(bounds),
                  child: Text(
                    'Emoji Emotion Indicator',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                SizedBox(height: 60),
                
                // Emoji Container
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _pulseAnimation,
                    _bounceAnimation,
                    _rotateAnimation,
                    _colorAnimation,
                  ]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value * _bounceAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 0.1,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                _colorAnimation.value ?? Color(0xFF4A4A4A),
                                (_colorAnimation.value ?? Color(0xFF4A4A4A)).withOpacity(0.3),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_colorAnimation.value ?? Color(0xFF4A4A4A)).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              currentEmoji,
                              style: TextStyle(fontSize: 80),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 20),
                
                // Emotion Status
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    _getEmotionText(),
                    key: ValueKey(emotionState),
                    style: TextStyle(
                      fontSize: 18,
                      color: _getEmotionColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                SizedBox(height: 60),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildAnimatedTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 24),
                      
                      _buildAnimatedTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 24),
                      
                      _buildAnimatedTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Submit Button
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: emotionState == EmotionState.very_happy
                                ? [Color(0xFF6C63FF), Color(0xFF3F3FFF)]
                                : [Color(0xFF4A4A4A), Color(0xFF2A2A2A)],
                          ),
                          boxShadow: emotionState == EmotionState.very_happy
                              ? [
                                  BoxShadow(
                                    color: Color(0xFF6C63FF).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ]
                              : [],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: emotionState == EmotionState.very_happy
                                ? () {
                                    // Handle form submission
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Form submitted successfully! 🎉'),
                                        backgroundColor: Color(0xFF6C63FF),
                                      ),
                                    );
                                  }
                                : null,
                            child: Center(
                              child: Text(
                                'Submit Form',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E2E).withOpacity(0.8),
            Color(0xFF2A2A3E).withOpacity(0.6),
          ],
        ),
        border: Border.all(
          color: Color(0xFF6C63FF).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
          prefixIcon: Icon(icon, color: Color(0xFF6C63FF)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
  
  String _getEmotionText() {
    switch (emotionState) {
      case EmotionState.neutral:
        return 'Fill the form to make me happy!';
      case EmotionState.slightly_happy:
        return 'Getting better...';
      case EmotionState.happy:
        return 'Almost there!';
      case EmotionState.very_happy:
        return 'Perfect! Ready to submit!';
    }
  }
  
  Color _getEmotionColor() {
    switch (emotionState) {
      case EmotionState.neutral:
        return Color(0xFF9E9E9E);
      case EmotionState.slightly_happy:
        return Color(0xFFFFEB3B);
      case EmotionState.happy:
        return Color(0xFFFF9800);
      case EmotionState.very_happy:
        return Color(0xFF4CAF50);
    }
  }
}

enum EmotionState {
  neutral,
  slightly_happy,
  happy,
  very_happy,
}