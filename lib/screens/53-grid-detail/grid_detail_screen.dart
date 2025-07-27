import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GridItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final IconData icon;

  GridItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.icon,
  });
}

class GridDetailScreen extends StatefulWidget {
  @override
  _GridDetailScreenState createState() => _GridDetailScreenState();
}

class _GridDetailScreenState extends State<GridDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _searchController;
  
  final List<GridItem> items = [
    GridItem(
      id: '1',
      title: 'Ocean Waves',
      subtitle: 'Peaceful Waters',
      description: 'Dive into the serene beauty of ocean waves. Experience the rhythmic dance of water as it meets the shore, creating a mesmerizing symphony of nature. The endless blue expanse offers tranquility and wonder, perfect for meditation and reflection.',
      color: const Color(0xFF2196F3),
      icon: Icons.waves,
    ),
    GridItem(
      id: '2',
      title: 'Mountain Peak',
      subtitle: 'Alpine Adventure',
      description: 'Reach new heights with breathtaking mountain vistas. Feel the crisp mountain air and witness panoramic views that stretch beyond the horizon. Every peak tells a story of perseverance and natural majesty.',
      color: const Color(0xFF4CAF50),
      icon: Icons.landscape,
    ),
    GridItem(
      id: '3',
      title: 'City Lights',
      subtitle: 'Urban Energy',
      description: 'Experience the vibrant pulse of city life. Watch as millions of lights create a constellation on earth, each one representing dreams, ambitions, and the endless possibilities of urban living.',
      color: const Color(0xFFFF9800),
      icon: Icons.location_city,
    ),
    GridItem(
      id: '4',
      title: 'Forest Path',
      subtitle: 'Nature\'s Trail',
      description: 'Walk through ancient pathways surrounded by towering trees. Discover the secrets of the forest as sunlight filters through the canopy, creating magical patterns on the forest floor.',
      color: const Color(0xFF8BC34A),
      icon: Icons.park,
    ),
    GridItem(
      id: '5',
      title: 'Desert Dunes',
      subtitle: 'Golden Sands',
      description: 'Explore the vast expanse of golden sand dunes. Experience the silence and beauty of the desert, where time seems to stand still and every grain of sand tells an ancient story.',
      color: const Color(0xFFFFB74D),
      icon: Icons.terrain,
    ),
    GridItem(
      id: '6',
      title: 'Northern Lights',
      subtitle: 'Aurora Magic',
      description: 'Witness the ethereal dance of the Northern Lights. Marvel at nature\'s most spectacular light show as vibrant colors paint the night sky in an unforgettable display of cosmic beauty.',
      color: const Color(0xFF9C27B0),
      icon: Icons.auto_awesome,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildAnimatedGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Beautiful destinations await',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 24),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedBuilder(
      animation: _searchController,
      builder: (context, child) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search destinations...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedGrid() {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final delay = index * 0.1;
            final animation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: _staggerController,
                curve: Interval(
                  delay,
                  delay + 0.5,
                  curve: Curves.easeOutCubic,
                ),
              ),
            );

            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - animation.value)),
                  child: Opacity(
                    opacity: animation.value,
                    child: _buildGridItem(items[index], index),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGridItem(GridItem item, int index) {
    return Hero(
      tag: 'item_${item.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(item),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.color.withOpacity(0.8),
                  item.color.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: item.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item.icon,
                        size: 40,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
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

  void _navigateToDetail(GridItem item) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => DetailScreen(item: item),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final GridItem item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _contentController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _controller.forward();
    _contentController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background
          Hero(
            tag: 'item_${widget.item.id}',
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.item.color.withOpacity(0.9),
                        widget.item.color.withOpacity(0.7),
                        const Color(0xFF0A0A0A),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Decorative elements
          Positioned(
            top: 100,
            right: -50,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      widget.item.icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    widget.item.subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Description
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.item.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: widget.item.color,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Explore Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                          },
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
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
    );
  }
}