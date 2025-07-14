import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class Product {
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

class FloatingAddtoCartScreen extends StatefulWidget {
  @override
  _FloatingAddtoCartScreenState createState() => _FloatingAddtoCartScreenState();
}

class _FloatingAddtoCartScreenState extends State<FloatingAddtoCartScreen>
    with TickerProviderStateMixin {
  late AnimationController _cartIconController;
  late Animation<double> _cartBounce;
  
  int _cartCount = 0;
  final GlobalKey _cartKey = GlobalKey();
  
  final List<Product> products = [
    Product(
      name: 'Premium Headphones',
      description: 'Crystal-clear audio with premium comfort',
      price: 299,
      originalPrice: 399,
      icon: Icons.headphones,
      color: Color(0xFF6C5CE7),
      backgroundColor: Color(0xFF6C5CE7),
    ),
    Product(
      name: 'Smart Watch',
      description: 'Track your fitness and stay connected',
      price: 249,
      originalPrice: 349,
      icon: Icons.watch,
      color: Color(0xFF74B9FF),
      backgroundColor: Color(0xFF74B9FF),
    ),
    Product(
      name: 'Wireless Speaker',
      description: 'Immersive sound experience anywhere',
      price: 199,
      originalPrice: 279,
      icon: Icons.speaker,
      color: Color(0xFF00B894),
      backgroundColor: Color(0xFF00B894),
    ),
    Product(
      name: 'Gaming Controller',
      description: 'Precision gaming with haptic feedback',
      price: 89,
      originalPrice: 129,
      icon: Icons.gamepad,
      color: Color(0xFFE17055),
      backgroundColor: Color(0xFFE17055),
    ),
    Product(
      name: 'Smartphone',
      description: 'Latest flagship with AI camera',
      price: 899,
      originalPrice: 1199,
      icon: Icons.smartphone,
      color: Color(0xFFFD79A8),
      backgroundColor: Color(0xFFFD79A8),
    ),
    Product(
      name: 'Laptop',
      description: 'High-performance for professionals',
      price: 1299,
      originalPrice: 1699,
      icon: Icons.laptop,
      color: Color(0xFF00CEC9),
      backgroundColor: Color(0xFF00CEC9),
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    
    _cartIconController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _cartBounce = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _cartIconController,
        curve: Curves.elasticOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _cartIconController.dispose();
    super.dispose();
  }
  
  void _onItemAdded() {
    setState(() {
      _cartCount++;
    });
    _cartIconController.forward().then((_) {
      _cartIconController.reset();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Premium Store',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: _cartBounce,
            builder: (context, child) {
              return Transform.scale(
                scale: _cartBounce.value,
                child: Stack(
                  children: [
                    IconButton(
                      key: _cartKey,
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {},
                    ),
                    if (_cartCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color(0xFFE17055),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$_cartCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.6,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                onAddToCart: _onItemAdded,
                cartKey: _cartKey,
              );
            },
          ),
          // Floating icons overlay
          IgnorePointer(
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final GlobalKey cartKey;

  ProductCard({
    required this.product,
    required this.onAddToCart,
    required this.cartKey,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _particleController;
  late AnimationController _successController;
  late AnimationController _floatingIconController;
  
  late Animation<double> _buttonScale;
  late Animation<double> _buttonOpacity;
  late Animation<double> _particleOpacity;
  late Animation<double> _successScale;
  late Animation<Color?> _buttonColor;
  late Animation<double> _floatingIconScale;
  late Animation<double> _floatingIconOpacity;
  late Animation<Offset> _floatingIconPosition;
  
  bool _isAnimating = false;
  bool _showParticles = false;
  bool _showSuccess = false;
  bool _showFloatingIcon = false;
  
  final GlobalKey _productKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingIconController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Interval(0.0, 0.2, curve: Curves.easeInOut),
      ),
    );
    
    _buttonOpacity = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );
    
    _particleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    
    _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successController,
        curve: Curves.elasticOut,
      ),
    );
    
    _buttonColor = ColorTween(
      begin: widget.product.color,
      end: Color(0xFF00B894),
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Interval(0.3, 0.8, curve: Curves.easeInOut),
      ),
    );
    
    _floatingIconScale = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _floatingIconController,
        curve: Curves.easeInOut,
      ),
    );
    
    _floatingIconOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _floatingIconController,
        curve: Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _floatingIconPosition = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _floatingIconController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _buttonController.dispose();
    _particleController.dispose();
    _successController.dispose();
    _floatingIconController.dispose();
    super.dispose();
  }
  
  Future<void> _addToCart() async {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
      _showParticles = true;
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Start button animation
    _buttonController.forward();
    
    // Start particle animation
    _particleController.forward();
    
    // Calculate floating icon trajectory
    await Future.delayed(Duration(milliseconds: 200));
    _startFloatingIconAnimation();
    
    // Wait for button animation to complete
    await Future.delayed(Duration(milliseconds: 600));
    
    // Show success state
    setState(() {
      _showSuccess = true;
    });
    
    _successController.forward();
    
    // Notify parent
    widget.onAddToCart();
    
    // Reset after animation
    await Future.delayed(Duration(milliseconds: 2000));
    
    setState(() {
      _isAnimating = false;
      _showParticles = false;
      _showSuccess = false;
      _showFloatingIcon = false;
    });
    
    _buttonController.reset();
    _particleController.reset();
    _successController.reset();
    _floatingIconController.reset();
  }
  
  void _startFloatingIconAnimation() {
    final RenderBox? productBox = _productKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? cartBox = widget.cartKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (productBox != null && cartBox != null) {
      final productPosition = productBox.localToGlobal(Offset.zero);
      final cartPosition = cartBox.localToGlobal(Offset.zero);
      
      final dx = cartPosition.dx - productPosition.dx;
      final dy = cartPosition.dy - productPosition.dy;
      
      setState(() {
        _floatingIconPosition = Tween<Offset>(
          begin: Offset(0, 0),
          end: Offset(dx, dy),
        ).animate(
          CurvedAnimation(
            parent: _floatingIconController,
            curve: Curves.easeInOut,
          ),
        );
        _showFloatingIcon = true;
      });
      
      _floatingIconController.forward();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      key: _productKey,
      child: Stack(
        children: [
          // Main Product Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1E2E),
                  Color(0xFF2A2A3A),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.product.color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Icon
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.product.backgroundColor.withOpacity(0.1),
                          widget.product.backgroundColor.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.product.icon,
                        size: 40,
                        color: widget.product.color,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Product Name
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 4),
                  
                  // Product Description
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toInt()}',
                        style: TextStyle(
                          color: widget.product.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '\$${widget.product.originalPrice.toInt()}',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  
                  Spacer(),
                  
                  // Add to Cart Button
                  Stack(
                    children: [
                      // Particle Effect
                      if (_showParticles)
                        AnimatedBuilder(
                          animation: _particleOpacity,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _particleOpacity.value,
                              child: MiniParticleEffect(color: widget.product.color),
                            );
                          },
                        ),
                      
                      // Button
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _buttonScale,
                          _buttonOpacity,
                          _buttonColor,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonScale.value,
                            child: Opacity(
                              opacity: _buttonOpacity.value,
                              child: Container(
                                width: double.infinity,
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: _addToCart,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _buttonColor.value,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: (_buttonColor.value ?? widget.product.color).withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _showSuccess
                                      ? AnimatedBuilder(
                                          animation: _successScale,
                                          builder: (context, child) {
                                            return Transform.scale(
                                              scale: _successScale.value,
                                              child: Icon(Icons.check, size: 18),
                                            );
                                          },
                                        )
                                      : Icon(Icons.add_shopping_cart, size: 18),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Floating Icon
          if (_showFloatingIcon)
            AnimatedBuilder(
              animation: Listenable.merge([
                _floatingIconPosition,
                _floatingIconScale,
                _floatingIconOpacity,
              ]),
              builder: (context, child) {
                return Transform.translate(
                  offset: _floatingIconPosition.value,
                  child: Transform.scale(
                    scale: _floatingIconScale.value,
                    child: Opacity(
                      opacity: _floatingIconOpacity.value,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.product.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.product.color.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.product.icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class MiniParticleEffect extends StatefulWidget {
  final Color color;
  
  MiniParticleEffect({required this.color});
  
  @override
  _MiniParticleEffectState createState() => _MiniParticleEffectState();
}

class _MiniParticleEffectState extends State<MiniParticleEffect>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<double>> _opacityAnimations;
  
  @override
  void initState() {
    super.initState();
    _controllers = [];
    _animations = [];
    _opacityAnimations = [];
    
    for (int i = 0; i < 8; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 1000 + (i * 50)),
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
      
      final opacityAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut),
      ));
      
      _controllers.add(controller);
      _animations.add(animation);
      _opacityAnimations.add(opacityAnimation);
      
      controller.forward();
    }
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: Stack(
        children: List.generate(8, (index) {
          return AnimatedBuilder(
            animation: Listenable.merge([
              _animations[index],
              _opacityAnimations[index],
            ]),
            builder: (context, child) {
              final progress = _animations[index].value;
              final opacity = _opacityAnimations[index].value;
              final angle = (index * 45) * (math.pi / 180);
              
              return Positioned(
                left: 50 + (progress * 25 * math.cos(angle)),
                top: 30 + (progress * 25 * math.sin(angle)),
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}