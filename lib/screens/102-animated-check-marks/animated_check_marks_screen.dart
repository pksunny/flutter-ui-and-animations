import 'package:flutter/material.dart';

class AnimatedCheckMarksScreen extends StatefulWidget {
  const AnimatedCheckMarksScreen({super.key});

  @override
  State<AnimatedCheckMarksScreen> createState() => _AnimatedCheckMarksScreenState();
}

class _AnimatedCheckMarksScreenState extends State<AnimatedCheckMarksScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _rippleController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rippleAnimation;
  
  List<bool> checkStates = [false, false, false, false];
  List<AnimationController> checkControllers = [];
  List<Animation<double>> checkAnimations = [];

  @override
  void initState() {
    super.initState();
    
    // Floating animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatingAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Ripple animation
    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Initialize check animations
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      checkControllers.add(controller);
      checkAnimations.add(Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      ));
    }
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rippleController.dispose();
    for (var controller in checkControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void toggleCheck(int index) {
    setState(() {
      checkStates[index] = !checkStates[index];
      if (checkStates[index]) {
        checkControllers[index].forward();
      } else {
        checkControllers[index].reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const SizedBox(height: 20),
                const Text(
                  'Beautiful\nCheckmarks',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to experience the magic ✨',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 60),

                // Floating Hero Checkmark
                Center(
                  child: AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: AnimatedBuilder(
                          animation: _rippleAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3 * (1 - _rippleAnimation.value)),
                                    blurRadius: 20 + (40 * _rippleAnimation.value),
                                    spreadRadius: 10 * _rippleAnimation.value,
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () => toggleCheck(0),
                                child: AnimatedCheckmark(
                                  isChecked: checkStates[0],
                                  animation: checkAnimations[0],
                                  size: 120,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00f2fe), Color(0xFF4facfe)],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 80),

                // Grid of Different Checkmark Styles
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  children: [
                    // Neon Style
                    GestureDetector(
                      onTap: () => toggleCheck(1),
                      child: AnimatedCheckmark(
                        isChecked: checkStates[1],
                        animation: checkAnimations[1],
                        size: 80,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                        ),
                        glowEffect: true,
                      ),
                    ),

                    // Minimal Style
                    GestureDetector(
                      onTap: () => toggleCheck(2),
                      child: AnimatedCheckmark(
                        isChecked: checkStates[2],
                        animation: checkAnimations[2],
                        size: 80,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                        ),
                        strokeWidth: 3,
                      ),
                    ),

                    // Elegant Style
                    GestureDetector(
                      onTap: () => toggleCheck(3),
                      child: AnimatedCheckmark(
                        isChecked: checkStates[3],
                        animation: checkAnimations[3],
                        size: 80,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFffecd2), Color(0xFFfcb69f)],
                        ),
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),
                    ),

                    // Interactive Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            for (int i = 0; i < checkStates.length; i++) {
                              setState(() {
                                checkStates[i] = !checkStates[i];
                                if (checkStates[i]) {
                                  checkControllers[i].forward();
                                } else {
                                  checkControllers[i].reverse();
                                }
                              });
                            }
                          },
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Toggle All',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Status Cards
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Completed Tasks',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${checkStates.where((state) => state).length}/4',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: checkStates.where((state) => state).length / 4,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF00f2fe),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedCheckmark extends StatelessWidget {
  final bool isChecked;
  final Animation<double> animation;
  final double size;
  final Gradient gradient;
  final bool glowEffect;
  final double strokeWidth;
  final Color? backgroundColor;

  const AnimatedCheckmark({
    super.key,
    required this.isChecked,
    required this.animation,
    this.size = 60,
    required this.gradient,
    this.glowEffect = false,
    this.strokeWidth = 4,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animation.value),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? Colors.transparent,
              gradient: isChecked ? gradient : null,
              border: !isChecked
                  ? Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    )
                  : null,
              boxShadow: glowEffect && isChecked
                  ? [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: CustomPaint(
              painter: CheckmarkPainter(
                progress: animation.value,
                strokeWidth: strokeWidth,
                isChecked: isChecked,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final bool isChecked;

  CheckmarkPainter({
    required this.progress,
    required this.strokeWidth,
    required this.isChecked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isChecked) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final checkPath = Path();

    // Define checkmark points
    final point1 = Offset(size.width * 0.28, size.height * 0.53);
    final point2 = Offset(size.width * 0.42, size.height * 0.67);
    final point3 = Offset(size.width * 0.72, size.height * 0.33);

    checkPath.moveTo(point1.dx, point1.dy);
    checkPath.lineTo(point2.dx, point2.dy);
    checkPath.lineTo(point3.dx, point3.dy);

    // Animate the checkmark drawing
    final pathMetrics = checkPath.computeMetrics();
    final pathMetric = pathMetrics.first;
    final drawPath = pathMetric.extractPath(0, pathMetric.length * progress);

    canvas.drawPath(drawPath, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isChecked != isChecked;
  }
}