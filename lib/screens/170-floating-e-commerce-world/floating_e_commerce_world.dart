import 'package:flutter/material.dart';
import 'dart:math' as math;
/// Main Home Page - Universe View
class FloatingWorldHomePage extends StatefulWidget {
  const FloatingWorldHomePage({Key? key}) : super(key: key);

  @override
  State<FloatingWorldHomePage> createState() => _FloatingWorldHomePageState();
}

class _FloatingWorldHomePageState extends State<FloatingWorldHomePage>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  int? _selectedPlanetIndex;
  bool _isZooming = false;

  // Cart items count
  int _cartCount = 0;

  // Define planets (categories)
  final List<PlanetData> _planets = [
    PlanetData(
      name: 'Electronics',
      color: const Color(0xFF6B5CE7),
      icon: Icons.devices,
      angle: 0,
      radius: 120,
      products: [
        ProductData('Laptop Pro', '999', Icons.laptop_mac),
        ProductData('Smartphone X', '799', Icons.phone_android),
        ProductData('Tablet Ultra', '599', Icons.tablet),
        ProductData('Smartwatch', '299', Icons.watch),
      ],
    ),
    PlanetData(
      name: 'Fashion',
      color: const Color(0xFFFF6B9D),
      icon: Icons.checkroom,
      angle: math.pi * 2 / 6,
      radius: 120,
      products: [
        ProductData('Designer Dress', '199', Icons.woman),
        ProductData('Casual Shirt', '49', Icons.man),
        ProductData('Premium Jeans', '89', Icons.boy),
        ProductData('Winter Jacket', '149', Icons.yard),
      ],
    ),
    PlanetData(
      name: 'Shoes',
      color: const Color(0xFF4ECDC4),
      icon: Icons.shopping_bag,
      angle: math.pi * 4 / 6,
      radius: 120,
      products: [
        ProductData('Running Shoes', '129', Icons.directions_run),
        ProductData('Sneakers', '99', Icons.sports_baseball),
        ProductData('Formal Shoes', '159', Icons.business_center),
        ProductData('Sandals', '59', Icons.beach_access),
      ],
    ),
    PlanetData(
      name: 'Tech',
      color: const Color(0xFFF7B731),
      icon: Icons.computer,
      angle: math.pi * 6 / 6,
      radius: 120,
      products: [
        ProductData('Wireless Earbuds', '149', Icons.headset),
        ProductData('Gaming Mouse', '79', Icons.mouse),
        ProductData('Keyboard RGB', '119', Icons.keyboard),
        ProductData('Webcam 4K', '89', Icons.videocam),
      ],
    ),
    PlanetData(
      name: 'Games',
      color: const Color(0xFFFC5C65),
      icon: Icons.sports_esports,
      angle: math.pi * 8 / 6,
      radius: 120,
      products: [
        ProductData('Console Pro', '499', Icons.gamepad),
        ProductData('VR Headset', '399', Icons.vrpano),
        ProductData('Game Controller', '59', Icons.sports_esports),
        ProductData('Racing Wheel', '199', Icons.sports_motorsports),
      ],
    ),
    PlanetData(
      name: 'Home',
      color: const Color(0xFF26DE81),
      icon: Icons.home,
      angle: math.pi * 10 / 6,
      radius: 120,
      products: [
        ProductData('Smart Speaker', '99', Icons.speaker),
        ProductData('Robot Vacuum', '299', Icons.cleaning_services),
        ProductData('Air Purifier', '199', Icons.air),
        ProductData('LED Bulbs', '29', Icons.lightbulb),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Rotation animation for planets
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Pulse animation for center
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onPlanetTap(int index) {
    setState(() {
      _selectedPlanetIndex = index;
      _isZooming = true;
    });

    // Navigate to planet detail page with zoom animation
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context)
          .push(
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) => PlanetDetailPage(
                    planet: _planets[index],
                    onAddToCart: (product) {
                      setState(() {
                        _cartCount++;
                      });
                      _showAddToCartAnimation(product);
                    },
                  ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          )
          .then((_) {
            setState(() {
              _selectedPlanetIndex = null;
              _isZooming = false;
            });
          });
    });
  }

  void _showAddToCartAnimation(ProductData product) {
    // Show snackbar with animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('${product.name} added to cart!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Animated Background with stars
          CustomPaint(
            size: size,
            painter: StarryBackgroundPainter(animation: _rotationController),
          ),

          // Main Universe View
          Center(
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Orbit lines
                    CustomPaint(
                      size: Size(size.width, size.height),
                      painter: OrbitLinesPainter(
                        radius: 120,
                        planetCount: _planets.length,
                      ),
                    ),

                    // Center "You are here" indicator
                    _buildCenterIndicator(),

                    // Planets
                    ..._planets.asMap().entries.map((entry) {
                      final index = entry.key;
                      final planet = entry.value;
                      return _buildPlanet(planet, index);
                    }).toList(),
                  ],
                );
              },
            ),
          ),

          // Top App Bar
          _buildTopBar(),

          // Cart Button
          _buildCartButton(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Floating World',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore Your Universe',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_outline,
                color: Colors.grey[800],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: GestureDetector(
        onTap: () {
          // Navigate to cart
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cart feature coming soon!')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B5CE7), Color(0xFF8B7EF7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B5CE7).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
              if (_cartCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, color: Colors.white, size: 30),
                SizedBox(height: 2),
                Text(
                  'YOU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanet(PlanetData planet, int index) {
    final angle = planet.angle + (_rotationController.value * 2 * math.pi);
    final x = planet.radius * math.cos(angle);
    final y = planet.radius * math.sin(angle);

    final isSelected = _selectedPlanetIndex == index;

    return Transform.translate(
      offset: Offset(x, y),
      child: GestureDetector(
        onTap: () => _onPlanetTap(index),
        child: AnimatedScale(
          scale: isSelected && _isZooming ? 1.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: isSelected && _isZooming ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 500 + (index * 100)),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Planet with orbiting products
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Main planet
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    planet.color,
                                    planet.color.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: planet.color.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                planet.icon,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            // Orbiting products (moons)
                            ...List.generate(
                              math.min(planet.products.length, 3),
                              (i) => _buildOrbitingProduct(
                                planet,
                                i,
                                planet.products.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Planet name
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          planet.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrbitingProduct(PlanetData planet, int index, int total) {
    final orbitAngle =
        (index / total) * 2 * math.pi +
        (_rotationController.value * 4 * math.pi);
    final orbitRadius = 45.0;
    final productX = orbitRadius * math.cos(orbitAngle);
    final productY = orbitRadius * math.sin(orbitAngle);

    return Transform.translate(
      offset: Offset(productX, productY),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: planet.color, width: 2),
          boxShadow: [
            BoxShadow(
              color: planet.color.withOpacity(0.3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(planet.products[index].icon, color: planet.color, size: 10),
      ),
    );
  }
}

/// Planet Detail Page - Zoomed In View
class PlanetDetailPage extends StatefulWidget {
  final PlanetData planet;
  final Function(ProductData) onAddToCart;

  const PlanetDetailPage({
    Key? key,
    required this.planet,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<PlanetDetailPage> createState() => _PlanetDetailPageState();
}

class _PlanetDetailPageState extends State<PlanetDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  int? _selectedProductIndex;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.planet.color.withOpacity(0.1),
                  const Color(0xFFF8F9FA),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Planet Center with orbiting products
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return SizedBox(
                          width: size.width * 0.8,
                          height: size.width * 0.8,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Orbit circle
                              CustomPaint(
                                size: Size(size.width * 0.8, size.width * 0.8),
                                painter: ProductOrbitPainter(
                                  color: widget.planet.color.withOpacity(0.2),
                                ),
                              ),

                              // Central Planet
                              _buildCentralPlanet(),

                              // Products orbiting
                              ...widget.planet.products.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final product = entry.value;
                                return _buildOrbitingProductCard(
                                  product,
                                  index,
                                  widget.planet.products.length,
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Selected Product Detail
          if (_selectedProductIndex != null) _buildProductDetail(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.grey[800],
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.planet.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${widget.planet.products.length} Products Available',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralPlanet() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.planet.color, widget.planet.color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.planet.color.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(widget.planet.icon, color: Colors.white, size: 50),
    );
  }

  Widget _buildOrbitingProductCard(ProductData product, int index, int total) {
    final angle =
        (index / total) * 2 * math.pi +
        (_rotationController.value * 2 * math.pi);
    final radius = 140.0;
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);

    return Transform.translate(
      offset: Offset(x, y),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProductIndex = index;
          });
        },
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500 + (index * 100)),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: widget.planet.color, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: widget.planet.color.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(product.icon, color: widget.planet.color, size: 30),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.planet.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductDetail() {
    final product = widget.planet.products[_selectedProductIndex!];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProductIndex = null;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: widget.planet.color.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Icon with 3D effect
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.planet.color.withOpacity(0.2),
                              widget.planet.color.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.icon,
                          size: 60,
                          color: widget.planet.color,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Product Name
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Product Price
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: widget.planet.color,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Add to Cart Button
                      GestureDetector(
                        onTap: () {
                          widget.onAddToCart(product);
                          setState(() {
                            _selectedProductIndex = null;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.planet.color,
                                widget.planet.color.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: widget.planet.color.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Add to Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==================== DATA MODELS ====================

/// Planet Data Model
class PlanetData {
  final String name;
  final Color color;
  final IconData icon;
  final double angle;
  final double radius;
  final List<ProductData> products;

  PlanetData({
    required this.name,
    required this.color,
    required this.icon,
    required this.angle,
    required this.radius,
    required this.products,
  });
}

/// Product Data Model
class ProductData {
  final String name;
  final String price;
  final IconData icon;

  ProductData(this.name, this.price, this.icon);
}

// ==================== CUSTOM PAINTERS ====================

/// Starry Background Painter
class StarryBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  StarryBackgroundPainter({required this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.3)
          ..strokeWidth = 1;
    final random = math.Random(42);
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final twinkle = math.sin((animation.value * 2 * math.pi) + (i * 0.1));
      paint.color = Colors.grey.withOpacity(0.2 + (twinkle * 0.3));
      canvas.drawCircle(Offset(x, y), 1 + (twinkle * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(StarryBackgroundPainter oldDelegate) => true;
}

/// Orbit Lines Painter
class OrbitLinesPainter extends CustomPainter {
  final double radius;
  final int planetCount;
  OrbitLinesPainter({required this.radius, required this.planetCount});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.15)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);

    // Draw main orbit circle
    canvas.drawCircle(center, radius, paint);

    // Draw connecting lines to center
    for (int i = 0; i < planetCount; i++) {
      final angle = (i / planetCount) * 2 * math.pi;
      final x = center.dx + (radius * math.cos(angle));
      final y = center.dy + (radius * math.sin(angle));

      paint.color = Colors.grey.withOpacity(0.08);
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(OrbitLinesPainter oldDelegate) => false;
}

/// Product Orbit Painter
class ProductOrbitPainter extends CustomPainter {
  final Color color;
  ProductOrbitPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(ProductOrbitPainter oldDelegate) => false;
}
