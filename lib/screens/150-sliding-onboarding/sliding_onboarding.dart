import 'package:flutter/material.dart';
import 'dart:math' as math;
/// 🎯 Main Onboarding Screen Widget
/// A beautiful, reusable onboarding experience with parallax effects
class SlidingOnboarding extends StatefulWidget {
  const SlidingOnboarding({Key? key}) : super(key: key);

  @override
  State<SlidingOnboarding> createState() => _SlidingOnboardingState();
}

class _SlidingOnboardingState extends State<SlidingOnboarding>
    with TickerProviderStateMixin {
  late PageController _pageController;
  double _currentPage = 0.0;
  int _currentIndex = 0;

  // 🎨 Customizable onboarding data
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to Future',
      description:
          'Experience the next generation of mobile excellence with stunning design and seamless interactions',
      icon: Icons.rocket_launch_rounded,
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFF8B5CF6),
      accentColor: Color(0xFFA78BFA),
    ),
    OnboardingData(
      title: 'Powerful Features',
      description:
          'Unlock unlimited possibilities with cutting-edge tools designed to elevate your experience',
      icon: Icons.auto_awesome_rounded,
      primaryColor: Color(0xFFEC4899),
      secondaryColor: Color(0xFFF43F5E),
      accentColor: Color(0xFFFB7185),
    ),
    OnboardingData(
      title: 'Stay Connected',
      description:
          'Join millions of users worldwide and be part of something extraordinary',
      icon: Icons.people_rounded,
      primaryColor: Color(0xFF06B6D4),
      secondaryColor: Color(0xFF0EA5E9),
      accentColor: Color(0xFF38BDF8),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌈 Animated Background with Parallax
          _buildParallaxBackground(),

          // 📱 Main PageView Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(index);
            },
          ),

          // 🎯 Page Indicators
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: _buildPageIndicators(),
          ),

          // 🚀 Action Buttons
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  /// 🌈 Parallax Background with Gradient Orbs
  Widget _buildParallaxBackground() {
    return Stack(
      children: List.generate(_pages.length, (index) {
        double offset = (_currentPage - index).abs();
        double opacity = 1.0 - (offset * 0.5).clamp(0.0, 1.0);
        double scale = 1.0 - (offset * 0.1).clamp(0.0, 0.3);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(
                    -0.5 + (index * 0.5),
                    -0.3 + (index * 0.2),
                  ),
                  radius: 1.5,
                  colors: [
                    _pages[index].primaryColor.withOpacity(0.15),
                    _pages[index].secondaryColor.withOpacity(0.1),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// 📄 Individual Page Builder with Animations
  Widget _buildPage(int index) {
    double offset = (_currentPage - index).abs();
    double opacity = 1.0 - (offset * 1.2).clamp(0.0, 1.0);
    double scale = 1.0 - (offset * 0.2).clamp(0.0, 0.5);
    double translateY = offset * 100;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: Transform.scale(
        scale: scale,
        child: Transform.translate(
          offset: Offset(0, translateY),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // 🎨 Animated Icon with Floating Effect
                _buildAnimatedIcon(index, offset),

                const SizedBox(height: 80),

                // 📝 Title with Fade Animation
                _buildTitle(index, offset),

                const SizedBox(height: 24),

                // 📖 Description
                _buildDescription(index, offset),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 Animated Icon with Decorative Elements
  Widget _buildAnimatedIcon(int index, double offset) {
    double rotation = offset * 0.3;
    double iconOpacity = 1.0 - (offset * 0.8).clamp(0.0, 1.0);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.rotate(
          angle: rotation,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _pages[index].primaryColor.withOpacity(0.2),
                  _pages[index].secondaryColor.withOpacity(0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _pages[index].primaryColor.withOpacity(0.3),
                  blurRadius: 40 * value,
                  spreadRadius: 10 * value,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Ring Animation
                ...List.generate(3, (i) {
                  return Transform.scale(
                    scale: 1.0 + (i * 0.2 * value),
                    child: Container(
                      width: 160 - (i * 20),
                      height: 160 - (i * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _pages[index]
                              .accentColor
                              .withOpacity(0.3 - (i * 0.1)),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),

                // Icon
                Opacity(
                  opacity: iconOpacity,
                  child: Icon(
                    _pages[index].icon,
                    size: 80 * value,
                    color: _pages[index].primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 📝 Title Widget with Gradient
  Widget _buildTitle(int index, double offset) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          _pages[index].primaryColor,
          _pages[index].secondaryColor,
        ],
      ).createShader(bounds),
      child: Text(
        _pages[index].title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.2,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  /// 📖 Description Widget
  Widget _buildDescription(int index, double offset) {
    return Text(
      _pages[index].description,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.grey[700],
        height: 1.6,
        letterSpacing: 0.2,
      ),
    );
  }

  /// 🎯 Page Indicators with Animation
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        bool isActive = index == _currentIndex;
        double progress =
            (_currentPage - index).abs().clamp(0.0, 1.0);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      _pages[index].primaryColor,
                      _pages[index].secondaryColor,
                    ],
                  )
                : null,
            color: isActive ? null : Colors.grey[300],
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _pages[index].primaryColor.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  /// 🚀 Action Buttons (Skip & Next/Get Started)
  Widget _buildActionButtons() {
    bool isLastPage = _currentIndex == _pages.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip Button
        if (!isLastPage)
          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                _pages.length - 1,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          )
        else
          const SizedBox(width: 80),

        // Next / Get Started Button
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.9 + (0.1 * value),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      _pages[_currentIndex].primaryColor,
                      _pages[_currentIndex].secondaryColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _pages[_currentIndex]
                          .primaryColor
                          .withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (isLastPage) {
                      // Navigate to home or main app
                      _handleGetStarted();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLastPage ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 🎉 Handle Get Started Action
  void _handleGetStarted() {
    // Navigate to your main app screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}

/// 📦 Onboarding Data Model
/// Customize this class to add more properties as needed
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });
}

/// 🏠 Demo Home Screen (Replace with your actual home screen)
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.celebration_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome! 🎉',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You\'re all set to explore',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}