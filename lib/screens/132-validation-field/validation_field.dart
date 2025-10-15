import 'package:flutter/material.dart';

/// Demo page showcasing multiple validation field variations
class ValidationField extends StatefulWidget {
  const ValidationField({Key? key}) : super(key: key);

  @override
  State<ValidationField> createState() => _ValidationFieldState();
}

class _ValidationFieldState extends State<ValidationField> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _customController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient header
          SliverAppBar(
            expandedHeight: 140,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFFEC4899),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '✨ Validation Field',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ultra-smooth animations with next-gen design',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverPadding(
            padding: EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Email Field
                _buildSection(
                  title: '📧 Email Validation',
                  child: AnimatedValidationField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    prefixIcon: Icons.mail_outline,
                    validator: (value) => _isValidEmail(value)
                        ? null
                        : 'Invalid email format',
                    successMessage: 'Email looks great!',
                    primaryColor: const Color(0xFF6366F1),
                    errorColor: const Color(0xFFEF4444),
                    successColor: const Color(0xFF10B981),
                  ),
                ),
                SizedBox(height: 32),

                // Password Field
                _buildSection(
                  title: '🔐 Password Validation',
                  child: AnimatedValidationField(
                    controller: _passwordController,
                    hintText: 'Enter password (min 8 chars)',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) => _isValidPassword(value)
                        ? null
                        : 'Password must be at least 8 characters',
                    successMessage: 'Strong password!',
                    primaryColor: const Color(0xFF8B5CF6),
                    errorColor: const Color(0xFFEF4444),
                    successColor: const Color(0xFF10B981),
                    shakeDistance: 8,
                  ),
                ),
                SizedBox(height: 32),

                // Custom validation field
                _buildSection(
                  title: '🎨 Custom Styled Field',
                  child: AnimatedValidationField(
                    controller: _customController,
                    hintText: 'Type "flutter" to validate',
                    prefixIcon: Icons.edit_outlined,
                    validator: (value) => value.toLowerCase() == 'flutter'
                        ? null
                        : 'Type "flutter"',
                    successMessage: '🎉 Perfect!',
                    primaryColor: const Color(0xFFEC4899),
                    errorColor: const Color(0xFFF97316),
                    successColor: const Color(0xFF06B6D4),
                    borderRadius: 12,
                    errorDuration: Duration(milliseconds: 600),
                    enableSuccessAnimation: true,
                  ),
                ),
                SizedBox(height: 48),

                
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }
}

/// 🎯 Main animated validation field widget
/// Provides shake animation, color transitions, and validation feedback
class AnimatedValidationField extends StatefulWidget {
  /// Text editing controller
  final TextEditingController controller;

  /// Hint text to display
  final String hintText;

  /// Icon to show before text
  final IconData? prefixIcon;

  /// Validation function: returns error message or null if valid
  final String? Function(String) validator;

  /// Success message to display
  final String successMessage;

  /// Primary color (default state)
  final Color primaryColor;

  /// Error color
  final Color errorColor;

  /// Success color
  final Color successColor;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Border radius
  final double borderRadius;

  /// Shake distance in pixels
  final double shakeDistance;

  /// Duration of error animation
  final Duration errorDuration;

  /// Enable success animation
  final bool enableSuccessAnimation;

  /// Text input action
  final TextInputAction textInputAction;

  /// Keyboard type
  final TextInputType keyboardType;

  const AnimatedValidationField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
    required this.successMessage,
    this.prefixIcon,
    this.primaryColor = const Color(0xFF6366F1),
    this.errorColor = const Color(0xFFEF4444),
    this.successColor = const Color(0xFF10B981),
    this.obscureText = false,
    this.borderRadius = 16,
    this.shakeDistance = 10,
    this.errorDuration = const Duration(milliseconds: 500),
    this.enableSuccessAnimation = true,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<AnimatedValidationField> createState() =>
      _AnimatedValidationFieldState();
}

class _AnimatedValidationFieldState extends State<AnimatedValidationField>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _colorController;
  late AnimationController _successController;
  late Animation<Offset> _shakeAnimation;

  String? _errorMessage;
  bool _isValid = false;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();

    // Shake animation controller
    _shakeController = AnimationController(
      duration: widget.errorDuration,
      vsync: this,
    );

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));

    // Color transition controller
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Success animation controller
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _colorController.dispose();
    _successController.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final value = widget.controller.text;
    final error = widget.validator(value);

    setState(() {
      _errorMessage = error;
      _isValid = error == null && value.isNotEmpty;
    });

    if (error != null) {
      // Trigger shake animation
      _triggerShake();
      _colorController.forward(from: 0);
      _showSuccess = false;
    } else if (_isValid && widget.enableSuccessAnimation) {
      _colorController.forward(from: 0);
      _triggerSuccess();
    }
  }

  void _triggerShake() {
    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(widget.shakeDistance / 1000, 0),
    ).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );

    _shakeController.forward(from: 0);
  }

  void _triggerSuccess() {
    setState(() => _showSuccess = true);
    _successController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() => _showSuccess = false);
        }
      });
    });
  }

  Color _getCurrentColor() {
    if (_isValid) return widget.successColor;
    if (_errorMessage != null) return widget.errorColor;
    return widget.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main input field with animations
        AnimatedBuilder(
          animation: Listenable.merge([
            _shakeController,
            _colorController,
            _successController,
          ]),
          builder: (context, child) {
            return Transform.translate(
              offset: _shakeAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: _getCurrentColor().withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: widget.prefixIcon != null
                        ? Icon(widget.prefixIcon)
                        : null,
                    suffixIcon: _buildSuffixIcon(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                    ),
                    prefixIconColor: _getCurrentColor(),
                    suffixIconColor: _getCurrentColor(),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                  cursorColor: widget.primaryColor,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 8),

        // Error or success message
        if (_errorMessage != null && !_isValid)
          _buildErrorMessage()
        else if (_showSuccess && _isValid)
          _buildSuccessMessage(),
      ],
    );
  }

  Widget _buildSuffixIcon() {
    if (_isValid) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1)
            .animate(CurvedAnimation(parent: _successController, curve: Curves.elasticOut)),
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.check_circle, color: widget.successColor),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildErrorMessage() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeOut)),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, top: 4),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 16, color: widget.errorColor),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                _errorMessage ?? '',
                style: TextStyle(
                  color: widget.errorColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _successController, curve: Curves.easeOut)),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, top: 4),
        child: Row(
          children: [
            Icon(Icons.check_circle, size: 16, color: widget.successColor),
            SizedBox(width: 6),
            Text(
              widget.successMessage,
              style: TextStyle(
                color: widget.successColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}