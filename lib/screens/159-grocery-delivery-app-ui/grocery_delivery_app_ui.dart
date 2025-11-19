import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==================== MAIN HOME SCREEN ====================
class GroceryHomeScreen extends StatefulWidget {
  const GroceryHomeScreen({Key? key}) : super(key: key);

  @override
  State<GroceryHomeScreen> createState() => _GroceryHomeScreenState();
}

class _GroceryHomeScreenState extends State<GroceryHomeScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<CartItem> _cartItems = [];
  final List<FlyingItemAnimation> _flyingAnimations = [];
  String _selectedCategory = 'Fresh Fruits';
  double _scrollOffset = 0.0;

  // Color Palette
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF8FAF9);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var anim in _flyingAnimations) {
      anim.controller.dispose();
    }
    super.dispose();
  }

  // Add item to cart with flying animation
  void _addToCart(Product product, Offset startPosition) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (existingIndex != -1) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(product: product, quantity: 1));
      }
    });

    // Create flying animation
    final controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final animation = FlyingItemAnimation(
      controller: controller,
      startPosition: startPosition,
      endPosition: const Offset(350, 50), // Cart icon position
      icon: product.icon,
    );

    setState(() {
      _flyingAnimations.add(animation);
    });

    controller.forward().then((_) {
      setState(() {
        _flyingAnimations.remove(animation);
      });
      controller.dispose();
    });
  }

  int get _totalCartItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get _totalCartPrice {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom Wavy App Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: WavyAppBarDelegate(
                  minHeight: 120,
                  maxHeight: 200,
                  scrollOffset: _scrollOffset,
                  totalCartItems: _totalCartItems,
                  onCartTap: () => _showCartBottomSheet(context),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildSearchBar(),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: Product.categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryChip(Product.categories[index]);
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Products Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final filteredProducts =
                          Product.sampleProducts
                              .where((p) => p.category == _selectedCategory)
                              .toList();
                      if (index >= filteredProducts.length) return null;
                      return _buildProductCard(filteredProducts[index]);
                    },
                    childCount:
                        Product.sampleProducts
                            .where((p) => p.category == _selectedCategory)
                            .length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Flying animations overlay
          ...(_flyingAnimations.map(
            (anim) => AnimatedBuilder(
              animation: anim.controller,
              builder: (context, child) {
                final curve = Curves.easeInOut.transform(anim.controller.value);
                final currentX =
                    anim.startPosition.dx +
                    (anim.endPosition.dx - anim.startPosition.dx) * curve;
                final startOffsetY =
                    anim.startPosition.dy + 50; // start 50 px lower
                final endOffsetY = anim.endPosition.dy; // where it should go

                final currentY =
                    startOffsetY +
                    (endOffsetY - startOffsetY) * curve -
                    150 *
                        math.sin(
                          curve * math.pi,
                        ); // bigger amplitude if you want more "fly out"

                return Positioned(
                  left: currentX,
                  top: currentY,
                  child: Opacity(
                    opacity: 1,
                    child: Transform.scale(
                      scale: 1 - curve * 0.5,
                      child: Text(
                        anim.icon,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              },
            ),
          )),

          // Floating Cart Button
          if (_totalCartItems > 0)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: _buildFloatingCartButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search fresh groceries...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: primaryGreen),
          suffixIcon: const Icon(Icons.tune, color: primaryGreen),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = category == _selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [primaryGreen, lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? primaryGreen.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 10 : 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Get the position of the card for flying animation
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          _addToCart(product, position);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Icon with background
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          lightGreen.withOpacity(0.2),
                          primaryGreen.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'product_${product.id}',
                        child: Text(
                          product.icon,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: accentOrange, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: darkGreen,
                                ),
                              ),
                              Text(
                                'per ${product.unit}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          _buildAddButton(product),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Favorite button
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_border,
                  color: primaryGreen,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(Product product) {
    final cartItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (cartItem.quantity > 0) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [primaryGreen, lightGreen]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            _iconButton(Icons.remove, () {
              setState(() {
                if (cartItem.quantity > 1) {
                  cartItem.quantity--;
                } else {
                  _cartItems.remove(cartItem);
                }
              });
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${cartItem.quantity}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _iconButton(Icons.add, () {
              final RenderBox? box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                final position = box.localToGlobal(Offset.zero);
                _addToCart(product, position);
              }
            }),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primaryGreen, lightGreen]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final RenderBox? box = context.findRenderObject() as RenderBox?;
            if (box != null) {
              final position = box.localToGlobal(Offset.zero);
              _addToCart(product, position);
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildFloatingCartButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTap: () => _showCartBottomSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [darkGreen, primaryGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_totalCartItems items',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${_totalCartPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'View Cart',
                  style: TextStyle(
                    color: darkGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CartBottomSheet(
            cartItems: _cartItems,
            onUpdateQuantity: (product, change) {
              setState(() {
                final item = _cartItems.firstWhere(
                  (i) => i.product.id == product.id,
                );
                item.quantity += change;
                if (item.quantity <= 0) {
                  _cartItems.remove(item);
                }
              });
            },
          ),
    );
  }
}

// ==================== WAVY APP BAR DELEGATE ====================
class WavyAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final double scrollOffset;
  final int totalCartItems;
  final VoidCallback onCartTap;

  WavyAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.scrollOffset,
    required this.totalCartItems,
    required this.onCartTap,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    final waveHeight = 30 * (1 - progress);

    return Stack(
      children: [
        // Background with gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Wavy bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(double.infinity, waveHeight + 30),
            painter: WavePainter(
              waveHeight: waveHeight,
              scrollOffset: scrollOffset,
            ),
          ),
        ),

        // Content
        Positioned(
          top: 60,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fresh Groceries',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24 - (progress * 8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (progress < 0.7)
                    Text(
                      'Delivered to your doorstep 🚚',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
              GestureDetector(
                onTap: onCartTap,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 24,
                      ),
                      if (totalCartItems > 0)
                        Positioned(
                          left: -1,
                          top: -3,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF9800),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              totalCartItems > 9 ? '9+' : '$totalCartItems',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
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
      ],
    );
  }

  @override
  bool shouldRebuild(covariant WavyAppBarDelegate oldDelegate) {
    return scrollOffset != oldDelegate.scrollOffset ||
        totalCartItems != oldDelegate.totalCartItems;
  }
}

// ==================== WAVE PAINTER ====================
class WavePainter extends CustomPainter {
  final double waveHeight;
  final double scrollOffset;

  WavePainter({required this.waveHeight, required this.scrollOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFF8FAF9)
          ..style = PaintingStyle.fill;

    final path = Path();
    final waveOffset = (scrollOffset * 0.5) % (size.width / 2);

    path.moveTo(0, waveHeight);

    for (double x = 0; x <= size.width; x += 1) {
      final y =
          waveHeight +
          waveHeight *
              math.sin((x / size.width * 4 * math.pi) - (waveOffset / 50));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return waveHeight != oldDelegate.waveHeight ||
        scrollOffset != oldDelegate.scrollOffset;
  }
}

// ==================== CART BOTTOM SHEET ====================
class CartBottomSheet extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(Product, int) onUpdateQuantity;

  const CartBottomSheet({
    Key? key,
    required this.cartItems,
    required this.onUpdateQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'My Cart',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(item);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF81C784).withOpacity(0.2),
                  const Color(0xFF4CAF50).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item.product.icon,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)} / ${item.product.unit}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildQuantityButton(
                Icons.remove,
                () => onUpdateQuantity(item.product, -1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _buildQuantityButton(
                Icons.add,
                () => onUpdateQuantity(item.product, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

// ==================== DATA MODELS ====================

/// Product model representing a grocery item
class Product {
  final int id;
  final String name;
  final double price;
  final double rating;
  final String category;
  final String icon;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.icon,
    required this.unit,
  });

  // Sample product categories
  static const List<String> categories = [
    'Fresh Fruits',
    'Vegetables',
    'Dairy',
    'Bakery',
    'Snacks',
  ];

  // Sample products data
  static final List<Product> sampleProducts = [
    Product(
      id: 1,
      name: 'Fresh Apples',
      price: 4.99,
      rating: 4.8,
      category: 'Fresh Fruits',
      icon: '🍎',
      unit: 'kg',
    ),
    Product(
      id: 2,
      name: 'Bananas',
      price: 2.99,
      rating: 4.9,
      category: 'Fresh Fruits',
      icon: '🍌',
      unit: 'kg',
    ),
    Product(
      id: 3,
      name: 'Oranges',
      price: 3.49,
      rating: 4.7,
      category: 'Fresh Fruits',
      icon: '🍊',
      unit: 'kg',
    ),
    Product(
      id: 4,
      name: 'Strawberries',
      price: 5.99,
      rating: 4.9,
      category: 'Fresh Fruits',
      icon: '🍓',
      unit: 'pack',
    ),
    Product(
      id: 5,
      name: 'Carrots',
      price: 1.99,
      rating: 4.7,
      category: 'Vegetables',
      icon: '🥕',
      unit: 'kg',
    ),
    Product(
      id: 6,
      name: 'Broccoli',
      price: 3.49,
      rating: 4.6,
      category: 'Vegetables',
      icon: '🥦',
      unit: 'pc',
    ),
    Product(
      id: 7,
      name: 'Tomatoes',
      price: 2.79,
      rating: 4.8,
      category: 'Vegetables',
      icon: '🍅',
      unit: 'kg',
    ),
    Product(
      id: 8,
      name: 'Lettuce',
      price: 1.99,
      rating: 4.5,
      category: 'Vegetables',
      icon: '🥬',
      unit: 'pc',
    ),
    Product(
      id: 9,
      name: 'Fresh Milk',
      price: 3.99,
      rating: 4.9,
      category: 'Dairy',
      icon: '🥛',
      unit: 'L',
    ),
    Product(
      id: 10,
      name: 'Yogurt',
      price: 2.49,
      rating: 4.8,
      category: 'Dairy',
      icon: '🥣',
      unit: 'pc',
    ),
    Product(
      id: 11,
      name: 'Cheese',
      price: 5.99,
      rating: 4.7,
      category: 'Dairy',
      icon: '🧀',
      unit: 'pack',
    ),
    Product(
      id: 12,
      name: 'Butter',
      price: 4.49,
      rating: 4.6,
      category: 'Dairy',
      icon: '🧈',
      unit: 'pack',
    ),
    Product(
      id: 13,
      name: 'Fresh Bread',
      price: 2.99,
      rating: 4.7,
      category: 'Bakery',
      icon: '🍞',
      unit: 'pc',
    ),
    Product(
      id: 14,
      name: 'Croissant',
      price: 1.99,
      rating: 4.8,
      category: 'Bakery',
      icon: '🥐',
      unit: 'pc',
    ),
    Product(
      id: 15,
      name: 'Bagels',
      price: 3.49,
      rating: 4.6,
      category: 'Bakery',
      icon: '🥯',
      unit: 'pack',
    ),
    Product(
      id: 16,
      name: 'Donuts',
      price: 4.99,
      rating: 4.9,
      category: 'Bakery',
      icon: '🍩',
      unit: 'pack',
    ),
    Product(
      id: 17,
      name: 'Cookies',
      price: 3.99,
      rating: 4.8,
      category: 'Snacks',
      icon: '🍪',
      unit: 'pack',
    ),
    Product(
      id: 18,
      name: 'Chips',
      price: 2.99,
      rating: 4.7,
      category: 'Snacks',
      icon: '🥔',
      unit: 'pack',
    ),
    Product(
      id: 19,
      name: 'Popcorn',
      price: 2.49,
      rating: 4.6,
      category: 'Snacks',
      icon: '🍿',
      unit: 'pack',
    ),
    Product(
      id: 20,
      name: 'Chocolate',
      price: 4.99,
      rating: 4.9,
      category: 'Snacks',
      icon: '🍫',
      unit: 'pack',
    ),
  ];
}

/// Cart item model
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

/// Flying animation model for "Add to Cart" effect
class FlyingItemAnimation {
  final AnimationController controller;
  final Offset startPosition;
  final Offset endPosition;
  final String icon;

  FlyingItemAnimation({
    required this.controller,
    required this.startPosition,
    required this.endPosition,
    required this.icon,
  });
}
