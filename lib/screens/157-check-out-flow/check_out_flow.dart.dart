import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎯 Main Animated Checkout Flow Widget
///
/// A beautiful, ultra-stylish multi-step checkout experience with:
/// - Smooth page transitions
/// - Interactive progress indicator
/// - Payment card flip animation
/// - Celebration confetti on success
/// - Fully customizable and reusable
class AnimatedCheckoutFlow extends StatefulWidget {
  /// Customize the accent color throughout the checkout
  final Color accentColor;

  /// Customize button colors
  final Color buttonColor;

  /// Enable/disable haptic feedback
  final bool enableHaptics;

  /// Celebration confetti colors
  final List<Color> confettiColors;

  const AnimatedCheckoutFlow({
    Key? key,
    this.accentColor = const Color(0xFF6C63FF),
    this.buttonColor = const Color(0xFF6C63FF),
    this.enableHaptics = true,
    this.confettiColors = const [
      Color(0xFF6C63FF),
      Color(0xFFFF6584),
      Color(0xFF4ECDC4),
      Color(0xFFFFA726),
      Color(0xFF7C4DFF),
    ],
  }) : super(key: key);

  @override
  State<AnimatedCheckoutFlow> createState() => _AnimatedCheckoutFlowState();
}

class _AnimatedCheckoutFlowState extends State<AnimatedCheckoutFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _cardFlipController;
  late AnimationController _successController;

  int _currentStep = 0;
  bool _isCardFlipped = false;
  bool _showConfetti = false;

  // Form data
  final _addressController = TextEditingController(text: '123 Flutter Street');
  final _cityController = TextEditingController(text: 'San Francisco');
  final _zipController = TextEditingController(text: '94105');

  final _cardNumberController = TextEditingController(
    text: '4532 1234 5678 9010',
  );
  final _cardNameController = TextEditingController(text: 'John Doe');
  final _expiryController = TextEditingController(text: '12/25');
  final _cvvController = TextEditingController(text: '123');

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardFlipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _cardFlipController.dispose();
    _successController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _progressController.animateTo(
        _currentStep / 2,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Show success
      setState(() {
        _showConfetti = true;
      });
      _successController.forward();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _progressController.animateTo(
        _currentStep / 2,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _flipCard() {
    setState(() {
      _isCardFlipped = !_isCardFlipped;
    });
    if (_isCardFlipped) {
      _cardFlipController.forward();
    } else {
      _cardFlipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header with back button and progress
                _buildHeader(),

                // Step indicator
                _buildStepIndicator(),

                // Page view with checkout steps
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildAddressStep(),
                      _buildPaymentStep(),
                      _buildConfirmationStep(),
                    ],
                  ),
                ),

                // Bottom action buttons
                _buildBottomActions(),
              ],
            ),
          ),

          // Confetti overlay
          if (_showConfetti)
            ConfettiOverlay(
              colors: widget.confettiColors,
              controller: _successController,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          if (_currentStep > 0)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: GestureDetector(
                    onTap: _previousStep,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStepTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Step ${_currentStep + 1} of 3',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Delivery Address';
      case 1:
        return 'Payment Method';
      case 2:
        return 'Review Order';
      default:
        return '';
    }
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      double progress = 0.0;
                      if (index < _currentStep) {
                        progress = 1.0;
                      } else if (index == _currentStep) {
                        progress = 0.0;
                      }

                      return Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color:
                              progress > 0.5
                                  ? widget.accentColor
                                  : Colors.grey[300],
                        ),
                      );
                    },
                  ),
                ),
                if (index < 2) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedTextField(
            controller: _addressController,
            label: 'Street Address',
            icon: Icons.home_outlined,
            delay: 100,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildAnimatedTextField(
                  controller: _cityController,
                  label: 'City',
                  icon: Icons.location_city_outlined,
                  delay: 200,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _zipController,
                  label: 'ZIP',
                  icon: Icons.pin_outlined,
                  delay: 300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            icon: Icons.info_outline,
            title: 'Free Delivery',
            subtitle: 'Estimated delivery: 2-3 business days',
            delay: 400,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Animated Credit Card
          GestureDetector(
            onTap: _flipCard,
            child: AnimatedBuilder(
              animation: _cardFlipController,
              builder: (context, child) {
                final angle = _cardFlipController.value * math.pi;
                final transform =
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle);

                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child:
                      angle < math.pi / 2
                          ? _buildCreditCardFront()
                          : Transform(
                            transform: Matrix4.identity()..rotateY(math.pi),
                            alignment: Alignment.center,
                            child: _buildCreditCardBack(),
                          ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          _buildAnimatedTextField(
            controller: _cardNumberController,
            label: 'Card Number',
            icon: Icons.credit_card,
            delay: 100,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildAnimatedTextField(
            controller: _cardNameController,
            label: 'Cardholder Name',
            icon: Icons.person_outline,
            delay: 200,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _expiryController,
                  label: 'Expiry',
                  icon: Icons.calendar_today,
                  delay: 300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!_isCardFlipped) _flipCard();
                  },
                  child: _buildAnimatedTextField(
                    controller: _cvvController,
                    label: 'CVV',
                    icon: Icons.lock_outline,
                    delay: 400,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardFront() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [widget.accentColor, widget.accentColor.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Icon(Icons.contactless, color: Colors.white, size: 32),
            ],
          ),
          const Spacer(),
          Text(
            _cardNumberController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _cardNameController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _expiryController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardBack() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [widget.accentColor.withOpacity(0.7), widget.accentColor],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(height: 45, color: Colors.black.withOpacity(0.6)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      _cvvController.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildSummaryCard(
            title: 'Delivery Address',
            icon: Icons.location_on,
            content:
                '${_addressController.text}\n${_cityController.text}, ${_zipController.text}',
            delay: 100,
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            title: 'Payment Method',
            icon: Icons.credit_card,
            content:
                '•••• •••• •••• ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}',
            delay: 200,
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            title: 'Order Summary',
            icon: Icons.shopping_bag,
            content: 'Total Amount: \$299.99',
            delay: 300,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int delay,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3142),
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(icon, color: widget.accentColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.accentColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: widget.accentColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required String content,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: widget.accentColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showConfetti ? _buildSuccessButton() : _buildContinueButton(),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: _nextStep,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.buttonColor, widget.buttonColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.buttonColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _currentStep == 2 ? 'Place Order' : 'Continue',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessButton() {
    return AnimatedBuilder(
      animation: _successController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_successController.value * 0.05),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 28 + (_successController.value * 4),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Order Successful!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 🎉 Confetti Overlay Widget
///
/// Creates a beautiful celebration animation with colorful confetti particles
class ConfettiOverlay extends StatelessWidget {
  final List<Color> colors;
  final AnimationController controller;

  const ConfettiOverlay({
    Key? key,
    required this.colors,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ConfettiPainter(
              progress: controller.value,
              colors: colors,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

/// 🎨 Custom Painter for Confetti Animation
class ConfettiPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final List<ConfettiParticle> particles;

  ConfettiPainter({required this.progress, required this.colors})
    : particles = List.generate(
        60,
        (index) => ConfettiParticle(
          color: colors[index % colors.length],
          index: index,
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.paint(canvas, size, progress);
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

/// 🎊 Individual Confetti Particle
class ConfettiParticle {
  final Color color;
  final int index;
  late final double startX;
  late final double velocityX;
  late final double velocityY;
  late final double rotation;
  late final double size;

  ConfettiParticle({required this.color, required this.index}) {
    final random = math.Random(index);
    startX = random.nextDouble();
    velocityX = (random.nextDouble() - 0.5) * 2;
    velocityY = random.nextDouble() * 2 + 1;
    rotation = random.nextDouble() * math.pi * 2;
    size = random.nextDouble() * 8 + 4;
  }

  void paint(Canvas canvas, Size size, double progress) {
    final x = size.width * startX + (velocityX * 100 * progress);
    final y = -20 + (velocityY * size.height * progress);

    final paint =
        Paint()
          ..color = color.withOpacity(1.0 - progress)
          ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation + (progress * math.pi * 4));

    // Draw confetti shape (rectangle or circle)
    if (index % 3 == 0) {
      canvas.drawCircle(Offset.zero, this.size / 2, paint);
    } else {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: this.size,
          height: this.size * 1.5,
        ),
        paint,
      );
    }

    canvas.restore();
  }
}
