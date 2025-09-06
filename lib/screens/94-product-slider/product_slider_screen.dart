import 'package:flutter/material.dart';
import 'dart:math' as math;

class Product {
  final String name;
  final String price;
  final String image;
  final Color color;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.color,
    required this.description,
  });
}

class ProductSliderScreen extends StatefulWidget {
  const ProductSliderScreen({super.key});

  @override
  State<ProductSliderScreen> createState() => _ProductSliderScreenState();
}

class _ProductSliderScreenState extends State<ProductSliderScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _rotationAnimation;
  
  int _currentIndex = 0;
  
  final List<Product> products = [
    Product(
      name: "AirPods Pro",
      price: "\$249",
      image: "🎧",
      color: const Color(0xFF6C5CE7),
      description: "Premium wireless earbuds with noise cancellation",
    ),
    Product(
      name: "iPhone 15 Pro",
      price: "\$999",
      image: "📱",
      color: const Color(0xFFE17055),
      description: "The most advanced iPhone ever created",
    ),
    Product(
      name: "MacBook Air",
      price: "\$1,199",
      image: "💻",
      color: const Color(0xFF00B894),
      description: "Supercharged by M2 chip for incredible performance",
    ),
    Product(
      name: "Apple Watch",
      price: "\$399",
      image: "⌚",
      color: const Color(0xFFFD79A8),
      description: "Your health and fitness companion on your wrist",
    ),
    Product(
      name: "iPad Pro",
      price: "\$799",
      image: "📱",
      color: const Color(0xFF74B9FF),
      description: "The ultimate creative canvas with M2 chip",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: 0);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 15000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_rotationController);
    
    _animationController.forward();
    _backgroundController.repeat();
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A1A1A),
                  const Color(0xFF0D0D0D),
                  Colors.black,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 3,
                    child: _buildProductSlider(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildProductInfo(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildActionButtons(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(Icons.menu),
          const Text(
            "Premium Store",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          _buildGlassButton(Icons.shopping_bag_outlined),
        ],
      ),
    );
  }

  Widget _buildGlassButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildProductSlider() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: products.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = index.toDouble() - (_pageController.page ?? 0);
                  }
                  
                  // Better 3D transformation calculations for side visibility
                  double distortionValue = Curves.easeOut.transform(
                    (1 - (value.abs() * 0.4)).clamp(0.0, 1.0)
                  );
                  
                  double rotationY = value * 0.3; // Less rotation for better visibility
                  double translateX = value * 80; // Less translation
                  double scaleValue = 0.85 + (distortionValue * 0.15);
                  
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY(rotationY)
                      ..translate(translateX, 0.0, 0.0)
                      ..scale(scaleValue),
                    child: Opacity(
                      opacity: 0.7 + (distortionValue * 0.3), // Better opacity for side items
                      child: _buildProductCard(products[index], index == _currentIndex),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(Product product, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          _pageController.animateToPage(
            products.indexOf(product),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(isActive ? 0.25 : 0.15),
              Colors.white.withOpacity(isActive ? 0.15 : 0.08),
              Colors.white.withOpacity(0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(isActive ? 0.4 : 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: product.color.withOpacity(isActive ? 0.4 : 0.2),
              blurRadius: isActive ? 30 : 15,
              spreadRadius: 0,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            children: [
              // Animated background pattern
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: Simple3DPatternPainter(
                        animation: _rotationAnimation.value,
                        color: product.color,
                      ),
                    );
                  },
                ),
              ),
              
              // Floating orbs effect
              if (isActive) ...[
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _backgroundAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: Simple3DPatternPainter(
                          animation: _backgroundAnimation.value,
                          color: product.color,
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              // Main content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 3D Product icon container
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: isActive ? _rotationAnimation.value * 0.1 : 0,
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    product.color.withOpacity(0.4),
                                    product.color.withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.3, 0.7, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: product.color.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Text(
                                product.image,
                                style: TextStyle(
                                  fontSize: isActive ? 90 : 70,
                                  shadows: [
                                    Shadow(
                                      color: product.color.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Product name with glow effect
                      Text(
                        product.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isActive ? 20 : 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: product.color.withOpacity(0.8),
                              blurRadius: isActive ? 15 : 8,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Price with special effects
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              product.color.withOpacity(0.3),
                              product.color.withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: product.color.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          product.price,
                          style: TextStyle(
                            color: product.color,
                            fontSize: isActive ? 24 : 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  products[_currentIndex].description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Enhanced page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    products.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: index == _currentIndex ? 32 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: index == _currentIndex
                            ? LinearGradient(
                                colors: [
                                  products[_currentIndex].color,
                                  products[_currentIndex].color.withOpacity(0.6),
                                ],
                              )
                            : null,
                        color: index == _currentIndex
                            ? null
                            : Colors.white.withOpacity(0.3),
                        boxShadow: index == _currentIndex
                            ? [
                                BoxShadow(
                                  color: products[_currentIndex].color.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    products[_currentIndex].color,
                    products[_currentIndex].color.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: products[_currentIndex].color.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.08),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Simple3DPatternPainter extends CustomPainter {
  final double animation;
  final Color color;

  Simple3DPatternPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    // Simple clean pattern
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        final x = (size.width / 6) * i;
        final y = (size.height / 6) * j;
        
        final offset = math.sin(animation * 0.5 + i * 0.3 + j * 0.3) * 1;
        
        canvas.drawCircle(
          Offset(x + offset, y + offset),
          1.5,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}