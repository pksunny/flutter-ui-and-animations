import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NeonPhotoGalleryScreen extends StatefulWidget {
  @override
  _NeonPhotoGalleryScreenState createState() => _NeonPhotoGalleryScreenState();
}

class _NeonPhotoGalleryScreenState extends State<NeonPhotoGalleryScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _gridController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _gridAnimation;

  int selectedIndex = -1;
  bool showGrid = true;

  // Sample photo URLs - replace with your actual images
  final List<String> photos = [
    'https://picsum.photos/400/600?random=1',
    'https://picsum.photos/400/600?random=2',
    'https://picsum.photos/400/600?random=3',
    'https://picsum.photos/400/600?random=4',
    'https://picsum.photos/400/600?random=5',
    'https://picsum.photos/400/600?random=6',
    'https://picsum.photos/400/600?random=7',
    'https://picsum.photos/400/600?random=8',
    'https://picsum.photos/400/600?random=9',
    'https://picsum.photos/400/600?random=10',
    'https://picsum.photos/400/600?random=11',
    'https://picsum.photos/400/600?random=12',
  ];

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _gridController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _gridAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gridController, curve: Curves.easeOutBack),
    );

    _gridController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  void _onPhotoTap(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      selectedIndex = index;
      showGrid = false;
    });
    _controller.forward();
  }

  void _onBackTap() {
    HapticFeedback.mediumImpact();
    _controller.reverse().then((_) {
      setState(() {
        selectedIndex = -1;
        showGrid = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Animated background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  Color(0xFF1A0033).withOpacity(0.3),
                  Color(0xFF0A0A0A),
                  Color(0xFF001133).withOpacity(0.2),
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: showGrid ? _buildPhotoGrid() : _buildPhotoDetail(),
            ),
          ),

          // Floating title
          if (showGrid)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'NEON GALLERY',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 20.0,
                              color: Color(0xFF00FFFF),
                              offset: Offset(0.0, 0.0),
                            ),
                            Shadow(
                              blurRadius: 40.0,
                              color: Color(0xFF00FFFF).withOpacity(0.5),
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
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

  Widget _buildPhotoGrid() {
    return AnimatedBuilder(
      animation: _gridAnimation,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 140, 20, 20),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.7,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Transform.scale(
                scale: _gridAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    50 * (1 - _gridAnimation.value) * (index % 2 == 0 ? 1 : -1),
                  ),
                  child: _buildPhotoCard(index),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPhotoCard(int index) {
    return GestureDetector(
      onTap: () => _onPhotoTap(index),
      child: Hero(
        tag: 'photo_$index',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00FFFF).withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Color(0xFFFF00FF).withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  photos[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1A1A2E),
                            Color(0xFF16213E),
                          ],
                        ),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF00FFFF),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Overlay gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                
                // Neon border effect
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF00FFFF).withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                ),
                
                // Photo number indicator
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF00FFFF).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF00FFFF).withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
  }

  Widget _buildPhotoDetail() {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _onBackTap,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF1A1A2E).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFF00FFFF).withOpacity(0.5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00FFFF).withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF00FFFF),
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Photo ${selectedIndex + 1}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Color(0xFF00FFFF),
                                  offset: Offset(0.0, 0.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 44), // Balance for back button
                    ],
                  ),
                ),
                
                // Photo display
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF00FFFF).withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: Color(0xFFFF00FF).withOpacity(0.3),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: 'photo_$selectedIndex',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              selectedIndex >= 0 ? photos[selectedIndex] : '',
                              fit: BoxFit.cover,
                            ),
                            
                            // Animated border
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Color(0xFF00FFFF),
                                  width: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Action buttons
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.favorite, Color(0xFFFF0080)),
                      _buildActionButton(Icons.share, Color(0xFF00FFFF)),
                      _buildActionButton(Icons.download, Color(0xFF00FF80)),
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

  Widget _buildActionButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }
}