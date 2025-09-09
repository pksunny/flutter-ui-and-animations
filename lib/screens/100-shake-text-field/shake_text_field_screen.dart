import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShakeTextFieldScreen extends StatefulWidget {
  @override
  _ShakeTextFieldScreenState createState() => _ShakeTextFieldScreenState();
}

class _ShakeTextFieldScreenState extends State<ShakeTextFieldScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _gradientController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _gradientAnimation;

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _textFocus = FocusNode();

  bool _numberError = false;
  bool _textError = false;
  String _numberErrorText = '';
  String _textErrorText = '';

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _gradientController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _gradientAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_gradientController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    _gradientController.dispose();
    _numberController.dispose();
    _textController.dispose();
    _numberFocus.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.reset();
    _shakeController.forward();
    HapticFeedback.mediumImpact();
  }

  void _validateNumber(String value) {
    if (value.isEmpty) return;

    if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
      setState(() {
        _numberError = true;
        _numberErrorText = 'Only numbers are allowed!';
      });
      _triggerShake();

      Future.delayed(Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _numberError = false;
            _numberErrorText = '';
          });
        }
      });
    } else {
      setState(() {
        _numberError = false;
        _numberErrorText = '';
      });
    }
  }

  void _validateText(String value) {
    if (value.isEmpty) return;

    if (RegExp(r'[0-9]').hasMatch(value)) {
      setState(() {
        _textError = true;
        _textErrorText = 'Only letters are allowed!';
      });
      _triggerShake();

      Future.delayed(Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _textError = false;
            _textErrorText = '';
          });
        }
      });
    } else {
      setState(() {
        _textError = false;
        _textErrorText = '';
      });
    }
  }

  Widget _buildShakeTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required Function(String) onChanged,
    required bool hasError,
    required String errorText,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        double shake = 0;
        if (hasError) {
          shake =
              _shakeAnimation.value *
              10 *
              (1 - _shakeAnimation.value) *
              (0.5 - ((_shakeAnimation.value * 4) % 1 - 0.5).abs()) *
              2;
        }

        return Transform.translate(
          offset: Offset(shake, 0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors:
                          hasError
                              ? [Colors.red.shade400, Colors.red.shade600]
                              : [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            hasError
                                ? Colors.red.withOpacity(0.3)
                                : primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Container(
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  hasError
                                      ? [
                                        Colors.red.shade400,
                                        Colors.red.shade600,
                                      ]
                                      : [primaryColor, secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: Colors.white, size: 20),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          errorText,
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    Color(0xFF764ba2),
                    Color(0xFFf093fb),
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    Color(0xFFf093fb),
                    Color(0xFF667eea),
                    _gradientAnimation.value,
                  )!,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(height: 50),

                    // Header
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '✨ Smart Input Fields',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Enter the wrong type and watch the magic happen!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 60),

                    // Number Input Field
                    _buildShakeTextField(
                      controller: _numberController,
                      focusNode: _numberFocus,
                      hintText: 'Enter numbers only (0-9)',
                      icon: Icons.numbers,
                      onChanged: _validateNumber,
                      hasError: _numberError,
                      errorText: _numberErrorText,
                      primaryColor: Color(0xFF4facfe),
                      secondaryColor: Color(0xFF00f2fe),
                    ),

                    SizedBox(height: 20),

                    // Text Input Field
                    _buildShakeTextField(
                      controller: _textController,
                      focusNode: _textFocus,
                      hintText: 'Enter letters only (A-Z)',
                      icon: Icons.text_fields,
                      onChanged: _validateText,
                      hasError: _textError,
                      errorText: _textErrorText,
                      primaryColor: Color(0xFFa8edea),
                      secondaryColor: Color(0xFFfed6e3),
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
