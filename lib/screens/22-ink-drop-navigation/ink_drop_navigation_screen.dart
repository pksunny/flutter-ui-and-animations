import 'package:flutter/material.dart';
import 'dart:math' as math;

class InkDropNavigationScreen extends StatefulWidget {
  const InkDropNavigationScreen({Key? key}) : super(key: key);

  @override
  State<InkDropNavigationScreen> createState() => _InkDropNavigationScreenState();
}

class _InkDropNavigationScreenState extends State<InkDropNavigationScreen>
    with TickerProviderStateMixin {
  late AnimationController _inkController;
  late AnimationController _rippleController;
  late AnimationController _fadeController;
  late Animation<double> _inkAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _fadeAnimation;
  
  int _selectedIndex = 0;
  Offset _tapPosition = Offset.zero;
  bool _isAnimating = false;
  
  final List<NavigationItem> _navItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      color: const Color(0xFF6C63FF),
      content: const HomeContent(),
    ),
    NavigationItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
      color: const Color(0xFFFF6B6B),
      content: const SearchContent(),
    ),
    NavigationItem(
      icon: Icons.favorite_border,
      activeIcon: Icons.favorite,
      label: 'Favorites',
      color: const Color(0xFF4ECDC4),
      content: const FavoritesContent(),
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      color: const Color(0xFFFFB74D),
      content: const ProfileContent(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _inkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _inkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _inkController,
      curve: Curves.easeOutQuart,
    ));
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutCirc,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _inkController.dispose();
    _rippleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onNavTap(int index, Offset globalPosition) async {
    if (_isAnimating || index == _selectedIndex) return;
    
    setState(() {
      _isAnimating = true;
      _tapPosition = globalPosition;
    });
    
    // Start ink and ripple animations simultaneously
    _inkController.reset();
    _rippleController.reset();
    _fadeController.reset();
    
    _inkController.forward();
    _rippleController.forward();
    
    // Wait for ink to spread before changing content
    await Future.delayed(const Duration(milliseconds: 400));
    
    setState(() {
      _selectedIndex = index;
    });
    
    _fadeController.forward();
    
    // Reset animation state
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF0F0F0F),
                  _navItems[_selectedIndex].color.withOpacity(0.1),
                ],
              ),
            ),
          ),
          
          // Ink drop animation overlay
          if (_isAnimating)
            AnimatedBuilder(
              animation: _inkAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: InkDropPainter(
                    progress: _inkAnimation.value,
                    center: _tapPosition,
                    color: _navItems[_selectedIndex].color,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          
          // Main content
          Column(
            children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                    child: _navItems[_selectedIndex].content,
                  ),
                );
              },
            ),
          ),
              
              // Bottom Navigation
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A).withOpacity(0.95),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Ripple effect
                    if (_isAnimating)
                      AnimatedBuilder(
                        animation: _rippleAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: RipplePainter(
                              progress: _rippleAnimation.value,
                              center: _tapPosition,
                              color: _navItems[_selectedIndex].color,
                            ),
                            size: Size.infinite,
                          );
                        },
                      ),
                    
                    // Navigation items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_navItems.length, (index) {
                        return GestureDetector(
                          onTapDown: (details) {
                            final RenderBox box = context.findRenderObject() as RenderBox;
                            final Offset localPosition = box.globalToLocal(details.globalPosition);
                            _onNavTap(index, localPosition);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? _navItems[index].color.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    _selectedIndex == index
                                        ? _navItems[index].activeIcon
                                        : _navItems[index].icon,
                                    key: ValueKey(_selectedIndex == index),
                                    color: _selectedIndex == index
                                        ? _navItems[index].color
                                        : Colors.white.withOpacity(0.6),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: _selectedIndex == index
                                        ? _navItems[index].color
                                        : Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                    fontWeight: _selectedIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  child: Text(_navItems[index].label),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InkDropPainter extends CustomPainter {
  final double progress;
  final Offset center;
  final Color color;

  InkDropPainter({
    required this.progress,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    
    final paint = Paint()
      ..color = color.withOpacity(0.3 * (1 - progress * 0.7))
      ..style = PaintingStyle.fill;
    
    // Calculate maximum radius to cover entire screen
    final maxRadius = math.sqrt(
      math.pow(size.width, 2) + math.pow(size.height, 2)
    );
    
    final radius = maxRadius * progress;
    
    // Create ink drop effect with multiple circles
    for (int i = 0; i < 3; i++) {
      final currentRadius = radius * (1 - i * 0.1);
      final currentOpacity = (1 - progress * 0.7) * (1 - i * 0.3);
      
      paint.color = color.withOpacity(currentOpacity * 0.3);
      canvas.drawCircle(center, currentRadius, paint);
    }
  }

  @override
  bool shouldRepaint(InkDropPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.center != center ||
           oldDelegate.color != color;
  }
}

class RipplePainter extends CustomPainter {
  final double progress;
  final Offset center;
  final Color color;

  RipplePainter({
    required this.progress,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    
    final paint = Paint()
      ..color = color.withOpacity(0.4 * (1 - progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Create ripple rings
    for (int i = 0; i < 3; i++) {
      final rippleProgress = (progress - i * 0.1).clamp(0.0, 1.0);
      final radius = 100 * rippleProgress;
      final opacity = (1 - rippleProgress) * 0.4;
      
      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.center != center ||
           oldDelegate.color != color;
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;
  final Widget content;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
    required this.content,
  });
}

// Content Widgets
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Welcome Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Experience the ink drop navigation',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6C63FF).withOpacity(0.3),
                        const Color(0xFF9D50BB).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          [Icons.dashboard, Icons.analytics, Icons.settings, Icons.help][index],
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ['Dashboard', 'Analytics', 'Settings', 'Help'][index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchContent extends StatelessWidget {
  const SearchContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Search & Discover',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search anything...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFFFF6B6B)),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    color: const Color(0xFFFF6B6B).withOpacity(0.5),
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Start typing to search',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesContent extends StatelessWidget {
  const FavoritesContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Your Favorites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4ECDC4).withOpacity(0.2),
                        const Color(0xFF44A08D).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFF4ECDC4),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Favorite Item ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Description of favorite item',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB74D), Color(0xFFFF8A65)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB74D).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(Icons.edit, 'Edit Profile'),
                _buildProfileOption(Icons.notifications, 'Notifications'),
                _buildProfileOption(Icons.privacy_tip, 'Privacy'),
                _buildProfileOption(Icons.help, 'Help & Support'),
                _buildProfileOption(Icons.logout, 'Sign Out'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFFB74D),
            size: 24,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}