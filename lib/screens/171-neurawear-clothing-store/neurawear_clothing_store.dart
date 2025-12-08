import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Main Home Page with Mood Scan Animation
class NeuraWearHomePage extends StatefulWidget {
  const NeuraWearHomePage({Key? key}) : super(key: key);

  @override
  State<NeuraWearHomePage> createState() => _NeuraWearHomePageState();
}

class _NeuraWearHomePageState extends State<NeuraWearHomePage>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _orbController;
  bool _isScanning = false;
  bool _scanComplete = false;
  String _detectedMood = '';

  final List<MoodData> _moods = [
    MoodData('Calm', Colors.blue.shade300, Icons.self_improvement, '🧘'),
    MoodData('Confident', Colors.amber.shade400, Icons.flash_on, '⚡'),
    MoodData('Mysterious', Colors.purple.shade400, Icons.nights_stay, '🌙'),
    MoodData('Dominant', Colors.red.shade400, Icons.whatshot, '🔥'),
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  void _startMoodScan() async {
    setState(() {
      _isScanning = true;
      _scanComplete = false;
    });

    await _scanController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isScanning = false;
      _scanComplete = true;
      _detectedMood = _moods[math.Random().nextInt(_moods.length)].name;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                StyleDimensionPage(mood: _detectedMood),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background with Gradient
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundGradientPainter(
                  animation: _orbController.value,
                ),
                child: Container(),
              );
            },
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Logo and Title
                _buildHeader(),

                // Mood Scan Orb
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildScanOrb(),
                        const SizedBox(height: 50),
                        if (!_isScanning && !_scanComplete) _buildScanButton(),
                        if (_scanComplete) _buildMoodResult(),
                      ],
                    ),
                  ),
                ),

                // Mood Quick Access Pills
                if (!_isScanning && !_scanComplete) _buildMoodPills(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ).createShader(bounds),
          child: const Text(
            'NEURAWEAR',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fashion That Reads Your Mind',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildScanOrb() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _scanController]),
      builder: (context, child) {
        return Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.3),
                blurRadius: 60,
                spreadRadius: _pulseController.value * 20,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow Ring
              Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF667EEA).withOpacity(0.1),
                        const Color(0xFF764BA2).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Orb with Glassmorphism
              ClipRRect(
                borderRadius: BorderRadius.circular(140),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child:
                        _isScanning
                            ? CustomPaint(
                              painter: ScanningWavePainter(
                                progress: _scanController.value,
                              ),
                            )
                            : Icon(
                              Icons.psychology_outlined,
                              size: 80,
                              color: const Color(0xFF667EEA).withOpacity(0.6),
                            ),
                  ),
                ),
              ),

              // Center Pulse Dot
              if (_isScanning)
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF667EEA),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: _startMoodScan,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.radar, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Scan My Mood',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoodResult() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Mood Detected',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ).createShader(bounds),
                    child: Text(
                      _detectedMood.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodPills() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _moods.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: MoodPillWidget(
              mood: _moods[index],
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            StyleDimensionPage(mood: _moods[index].name),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Style Dimension Page - Shows clothes based on mood
class StyleDimensionPage extends StatefulWidget {
  final String mood;

  const StyleDimensionPage({Key? key, required this.mood}) : super(key: key);

  @override
  State<StyleDimensionPage> createState() => _StyleDimensionPageState();
}

class _StyleDimensionPageState extends State<StyleDimensionPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  final List<ClothingItem> _clothingItems = [];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scrollController =
        ScrollController()..addListener(() {
          setState(() {
            _scrollOffset = _scrollController.offset;
          });
        });

    _generateClothingItems();
  }

  void _generateClothingItems() {
    final moodColors = _getMoodColors(widget.mood);
    _clothingItems.addAll([
      ClothingItem('Neural Hoodie', 'Premium', '\$189', moodColors[0]),
      ClothingItem('Quantum Jacket', 'Limited', '\$299', moodColors[1]),
      ClothingItem('Aura Pants', 'Exclusive', '\$159', moodColors[2]),
      ClothingItem('Vibe Sneakers', 'Classic', '\$249', moodColors[0]),
      ClothingItem('Pulse Shirt', 'Essential', '\$129', moodColors[1]),
      ClothingItem('Mind Cap', 'Signature', '\$89', moodColors[2]),
    ]);
  }

  List<Color> _getMoodColors(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return [
          const Color(0xFF4FC3F7),
          const Color(0xFF29B6F6),
          const Color(0xFF03A9F4),
        ];
      case 'confident':
        return [
          const Color(0xFFFFB74D),
          const Color(0xFFFFA726),
          const Color(0xFFFF9800),
        ];
      case 'mysterious':
        return [
          const Color(0xFFAB47BC),
          const Color(0xFF9C27B0),
          const Color(0xFF8E24AA),
        ];
      case 'dominant':
        return [
          const Color(0xFFEF5350),
          const Color(0xFFF44336),
          const Color(0xFFE53935),
        ];
      default:
        return [
          const Color(0xFF667EEA),
          const Color(0xFF764BA2),
          const Color(0xFF667EEA),
        ];
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF5F5FF),
                  _getMoodColors(widget.mood)[0].withOpacity(0.1),
                ],
              ),
            ),
          ),

          // Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    '${widget.mood.toUpperCase()} DIMENSION',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  background: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: MoodAuraPainter(
                              animation: _floatController.value,
                              color: _getMoodColors(widget.mood)[0],
                            ),
                            child: Container(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Clothing Grid
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ClothingCardWidget(
                      item: _clothingItems[index],
                      index: index,
                      scrollOffset: _scrollOffset,
                    );
                  }, childCount: _clothingItems.length),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: _getMoodColors(widget.mood)[0],
        icon: const Icon(Icons.shopping_bag_outlined),
        label: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Clothing Card Widget with Animations
class ClothingCardWidget extends StatefulWidget {
  final ClothingItem item;
  final int index;
  final double scrollOffset;

  const ClothingCardWidget({
    Key? key,
    required this.item,
    required this.index,
    required this.scrollOffset,
  }) : super(key: key);

  @override
  State<ClothingCardWidget> createState() => _ClothingCardWidgetState();
}

class _ClothingCardWidgetState extends State<ClothingCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Parallax effect based on scroll
    final parallaxOffset = (widget.scrollOffset - (widget.index * 50)) * 0.1;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
        _showItemDetail();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, parallaxOffset - (_hoverController.value * 10)),
            child: Transform.scale(
              scale: 1.0 - (_hoverController.value * 0.05),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: widget.item.color.withOpacity(0.3),
                      blurRadius: 20 + (_hoverController.value * 10),
                      spreadRadius: _hoverController.value * 5,
                      offset: Offset(0, 10 + (_hoverController.value * 5)),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.7),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          // Gradient Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    widget.item.color.withOpacity(0.1),
                                    widget.item.color.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.item.color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.item.category,
                                    style: TextStyle(
                                      color: widget.item.color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // Item Icon/Visual
                                Center(
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          widget.item.color.withOpacity(0.3),
                                          widget.item.color.withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.checkroom,
                                      size: 50,
                                      color: widget.item.color,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // Title
                                Text(
                                  widget.item.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 8),

                                // Price
                                Text(
                                  widget.item.price,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: widget.item.color,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Heart Icon
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                size: 20,
                                color: widget.item.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showItemDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemDetailSheet(item: widget.item),
    );
  }
}

/// Item Detail Bottom Sheet
class ItemDetailSheet extends StatelessWidget {
  final ClothingItem item;

  const ItemDetailSheet({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Visual
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            item.color.withOpacity(0.2),
                            item.color.withOpacity(0.0),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.checkroom,
                        size: 120,
                        color: item.color,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.category,
                      style: TextStyle(
                        color: item.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Description
                  Text(
                    'This exclusive piece adapts to your emotional energy, creating a unique aura that matches your current mood state. Crafted with neural-responsive fabric technology.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Features
                  _buildFeature('Neural Fabric', 'Adapts to body temperature'),
                  _buildFeature('Mood Sync', 'Changes with emotional state'),
                  _buildFeature('Premium Quality', 'Sustainable materials'),

                  const SizedBox(height: 40),

                  // Price and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            item.price,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: item.color,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item.color,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.shopping_cart),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check_circle, color: item.color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mood Pill Widget for Quick Access
class MoodPillWidget extends StatefulWidget {
  final MoodData mood;
  final VoidCallback onTap;
  const MoodPillWidget({Key? key, required this.mood, required this.onTap})
    : super(key: key);
  @override
  State<MoodPillWidget> createState() => _MoodPillWidgetState();
}

class _MoodPillWidgetState extends State<MoodPillWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (details) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.1),
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.mood.color.withOpacity(0.8),
                    widget.mood.color,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.mood.color.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.mood.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    widget.mood.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// CUSTOM PAINTERS
// ============================================================================
/// Background Gradient Painter with Animated Orbs
class BackgroundGradientPainter extends CustomPainter {
  final double animation;
  BackgroundGradientPainter({required this.animation});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Animated gradient orbs
    for (int i = 0; i < 3; i++) {
      final offset = Offset(
        size.width * (0.2 + i * 0.3) +
            math.sin(animation * 2 * math.pi + i) * 50,
        size.height * (0.3 + i * 0.2) +
            math.cos(animation * 2 * math.pi + i) * 30,
      );

      paint.shader = RadialGradient(
        colors: [
          Color.lerp(
            const Color(0xFF667EEA),
            const Color(0xFF764BA2),
            i / 3,
          )!.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: offset, radius: 150));

      canvas.drawCircle(offset, 150, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundGradientPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

/// Scanning Wave Painter for Mood Detection
class ScanningWavePainter extends CustomPainter {
  final double progress;
  ScanningWavePainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF667EEA).withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Scanning line
    final angle = progress * 2 * math.pi;
    final endPoint = Offset(
      center.dx + radius * math.cos(angle - math.pi / 2),
      center.dy + radius * math.sin(angle - math.pi / 2),
    );

    // Gradient line
    paint.shader = ui.Gradient.linear(center, endPoint, [
      const Color(0xFF667EEA).withOpacity(0.0),
      const Color(0xFF667EEA).withOpacity(0.8),
      const Color(0xFF764BA2).withOpacity(0.8),
    ]);

    canvas.drawLine(center, endPoint, paint);

    // Circles
    for (int i = 1; i <= 3; i++) {
      paint.shader = null;
      paint.color = const Color(0xFF667EEA).withOpacity(0.3 / i);
      canvas.drawCircle(center, radius * i / 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ScanningWavePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

/// Mood Aura Painter for Style Dimension Page
class MoodAuraPainter extends CustomPainter {
  final double animation;
  final Color color;
  MoodAuraPainter({required this.animation, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      final offset = Offset(
        size.width * (0.1 + i * 0.2) +
            math.sin(animation * 2 * math.pi + i * 0.5) * 40,
        size.height * (0.2 + i * 0.15) +
            math.cos(animation * 2 * math.pi + i * 0.5) * 30,
      );

      paint.shader = RadialGradient(
        colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: offset, radius: 100));

      canvas.drawCircle(offset, 100, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodAuraPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================
class MoodData {
  final String name;
  final Color color;
  final IconData icon;
  final String emoji;
  MoodData(this.name, this.color, this.icon, this.emoji);
}

class ClothingItem {
  final String name;
  final String category;
  final String price;
  final Color color;
  ClothingItem(this.name, this.category, this.price, this.color);
}
