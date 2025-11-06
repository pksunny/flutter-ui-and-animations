import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Main Onboarding Screen with Step-by-Step Illustration
class IllustrationStyleOnBoarding extends StatefulWidget {
  const IllustrationStyleOnBoarding({Key? key}) : super(key: key);

  @override
  State<IllustrationStyleOnBoarding> createState() => _IllustrationStyleOnBoardingState();
}

class _IllustrationStyleOnBoardingState extends State<IllustrationStyleOnBoarding> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Define onboarding pages with customizable content
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to\nthe Future',
      subtitle: 'Experience seamless productivity with smart automation',
      baseColor: const Color(0xFF6366F1),
      accentColor: const Color(0xFF8B5CF6),
      elements: [
        IllustrationElement(
          icon: Icons.auto_awesome,
          position: const Offset(0.5, 0.35),
          size: 80,
          delay: 300,
        ),
        IllustrationElement(
          icon: Icons.rocket_launch,
          position: const Offset(0.25, 0.5),
          size: 50,
          delay: 600,
        ),
        IllustrationElement(
          icon: Icons.emoji_events,
          position: const Offset(0.75, 0.5),
          size: 50,
          delay: 900,
        ),
        IllustrationElement(
          icon: Icons.favorite,
          position: const Offset(0.35, 0.65),
          size: 35,
          delay: 1200,
        ),
        IllustrationElement(
          icon: Icons.star,
          position: const Offset(0.65, 0.65),
          size: 35,
          delay: 1500,
        ),
      ],
    ),
    OnboardingPageData(
      title: 'Collaborate\nEffortlessly',
      subtitle: 'Work together in real-time from anywhere in the world',
      baseColor: const Color(0xFF06B6D4),
      accentColor: const Color(0xFF0EA5E9),
      elements: [
        IllustrationElement(
          icon: Icons.groups,
          position: const Offset(0.5, 0.35),
          size: 80,
          delay: 300,
        ),
        IllustrationElement(
          icon: Icons.chat_bubble,
          position: const Offset(0.3, 0.5),
          size: 45,
          delay: 600,
        ),
        IllustrationElement(
          icon: Icons.video_call,
          position: const Offset(0.7, 0.5),
          size: 45,
          delay: 900,
        ),
        IllustrationElement(
          icon: Icons.notifications_active,
          position: const Offset(0.25, 0.65),
          size: 35,
          delay: 1200,
        ),
        IllustrationElement(
          icon: Icons.cloud_done,
          position: const Offset(0.75, 0.65),
          size: 35,
          delay: 1500,
        ),
        IllustrationElement(
          icon: Icons.share,
          position: const Offset(0.5, 0.7),
          size: 30,
          delay: 1800,
        ),
      ],
    ),
    OnboardingPageData(
      title: 'Achieve Your\nGoals',
      subtitle: 'Track progress and celebrate every milestone',
      baseColor: const Color(0xFFEC4899),
      accentColor: const Color(0xFFF43F5E),
      elements: [
        IllustrationElement(
          icon: Icons.track_changes,
          position: const Offset(0.5, 0.35),
          size: 80,
          delay: 300,
        ),
        IllustrationElement(
          icon: Icons.insights,
          position: const Offset(0.25, 0.5),
          size: 50,
          delay: 600,
        ),
        IllustrationElement(
          icon: Icons.trending_up,
          position: const Offset(0.75, 0.5),
          size: 50,
          delay: 900,
        ),
        IllustrationElement(
          icon: Icons.workspace_premium,
          position: const Offset(0.3, 0.65),
          size: 40,
          delay: 1200,
        ),
        IllustrationElement(
          icon: Icons.celebration,
          position: const Offset(0.7, 0.65),
          size: 40,
          delay: 1500,
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Navigate to main app
      _showCompletionDialog();
    }
  }

  void _skipOnboarding() {
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_pages.last.baseColor, _pages.last.accentColor],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ready to Start!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your journey begins now',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pages.last.baseColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView with illustrations
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return StepByStepIllustrationPage(
                    key: ValueKey(index),
                    data: _pages[index],
                  );
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _pages[_currentPage].baseColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  return Hero(
                    tag: 'next_button',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _nextPage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _pages[_currentPage].baseColor,
                                _pages[_currentPage].accentColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _pages[_currentPage]
                                    .baseColor
                                    .withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _currentPage == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Continue',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for onboarding pages
class OnboardingPageData {
  final String title;
  final String subtitle;
  final Color baseColor;
  final Color accentColor;
  final List<IllustrationElement> elements;

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.baseColor,
    required this.accentColor,
    required this.elements,
  });
}

/// Individual illustration element with position and delay
class IllustrationElement {
  final IconData icon;
  final Offset position; // Relative position (0-1, 0-1)
  final double size;
  final int delay; // Delay in milliseconds

  IllustrationElement({
    required this.icon,
    required this.position,
    required this.size,
    required this.delay,
  });
}

/// Step-by-Step Illustration Page Widget
class StepByStepIllustrationPage extends StatefulWidget {
  final OnboardingPageData data;

  const StepByStepIllustrationPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<StepByStepIllustrationPage> createState() =>
      _StepByStepIllustrationPageState();
}

class _StepByStepIllustrationPageState
    extends State<StepByStepIllustrationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<bool> _visibleElements = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize visibility states
    _visibleElements.addAll(List.filled(widget.data.elements.length, false));

    // Start the animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Delay before starting
    await Future.delayed(const Duration(milliseconds: 200));

    // Animate each element with its specific delay
    for (int i = 0; i < widget.data.elements.length; i++) {
      await Future.delayed(Duration(milliseconds: widget.data.elements[i].delay));
      if (mounted) {
        setState(() {
          _visibleElements[i] = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Illustration Area with step-by-step reveal
            SizedBox(
              height: size.height * 0.45,
              child: Stack(
                children: [
                  // Base gradient circle - appears first
                  Center(
                    child: AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 600),
                      child: AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        child: Container(
                          width: size.width * 0.7,
                          height: size.width * 0.7,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                widget.data.baseColor.withOpacity(0.15),
                                widget.data.accentColor.withOpacity(0.05),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.7, 1.0],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Animated elements appearing step-by-step
                  ...List.generate(
                    widget.data.elements.length,
                    (index) {
                      final element = widget.data.elements[index];
                      return Positioned(
                        left: size.width * element.position.dx - element.size / 0.8,
                        top: size.height * 0.45 * element.position.dy - element.size / 2,
                        child: AnimatedOpacityScale(
                          visible: _visibleElements[index],
                          child: FloatingIcon(
                            icon: element.icon,
                            size: element.size,
                            color: widget.data.baseColor,
                            delay: index * 200,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Title with fade-in animation
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 800),
              child: Text(
                widget.data.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  letterSpacing: -0.5,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        widget.data.baseColor,
                        widget.data.accentColor,
                      ],
                    ).createShader(const Rect.fromLTWH(0, 0, 300, 100)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Subtitle with fade-in animation
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 1000),
              child: Text(
                widget.data.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[700],
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Animated opacity and scale widget for smooth appearance
class AnimatedOpacityScale extends StatelessWidget {
  final bool visible;
  final Widget child;

  const AnimatedOpacityScale({
    Key? key,
    required this.visible,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: visible ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        child: child,
      ),
    );
  }
}

/// Floating icon with continuous animation
class FloatingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  final int delay;

  const FloatingIcon({
    Key? key,
    required this.icon,
    required this.size,
    required this.color,
    this.delay = 0,
  }) : super(key: key);

  @override
  State<FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<FloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000 + widget.delay),
    );

    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start floating animation
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              size: widget.size * 0.6,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}