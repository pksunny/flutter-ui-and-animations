import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class LiquidDragDeleteBin extends StatefulWidget {
  const LiquidDragDeleteBin({Key? key}) : super(key: key);

  @override
  State<LiquidDragDeleteBin> createState() => _LiquidDragDeleteBinState();
}

class _LiquidDragDeleteBinState extends State<LiquidDragDeleteBin>
    with TickerProviderStateMixin {
  final List<DraggableItem> _items = [
    DraggableItem(id: '1', title: 'Photo Album', icon: Icons.photo_library, color: Colors.purple),
    DraggableItem(id: '2', title: 'Music Playlist', icon: Icons.music_note, color: Colors.cyan),
    DraggableItem(id: '3', title: 'Video Collection', icon: Icons.videocam, color: Colors.orange),
    DraggableItem(id: '4', title: 'Documents', icon: Icons.description, color: Colors.green),
    DraggableItem(id: '5', title: 'Downloads', icon: Icons.download, color: Colors.red),
    DraggableItem(id: '6', title: 'Settings', icon: Icons.settings, color: Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0F),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Liquid Drag Delete',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.cyan.withOpacity(0.5),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Items Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return DraggableItemWidget(
                      item: _items[index],
                      onDelete: () {
                        setState(() {
                          _items.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),
              
              // Liquid Delete Bin
              LiquidDeleteBin(
                onItemDeleted: (itemId) {
                  setState(() {
                    _items.removeWhere((item) => item.id == itemId);
                  });
                },
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data model for draggable items
class DraggableItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  DraggableItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

/// Individual draggable item widget with stunning animations
class DraggableItemWidget extends StatefulWidget {
  final DraggableItem item;
  final VoidCallback onDelete;

  const DraggableItemWidget({
    Key? key,
    required this.item,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<DraggableItemWidget> createState() => _DraggableItemWidgetState();
}

class _DraggableItemWidgetState extends State<DraggableItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Draggable<DraggableItem>(
              data: widget.item,
              feedback: _buildFeedback(),
              childWhenDragging: _buildPlaceholder(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.item.color.withOpacity(0.8),
                      widget.item.color.withOpacity(0.4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.item.color.withOpacity(0.3 * _glowAnimation.value),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 5 * _glowAnimation.value,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Animated background pattern
                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _isHovering
                                  ? [
                                      widget.item.color.withOpacity(0.9),
                                      widget.item.color.withOpacity(0.6),
                                    ]
                                  : [
                                      widget.item.color.withOpacity(0.8),
                                      widget.item.color.withOpacity(0.4),
                                    ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.item.icon,
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      // Shimmer effect
                      if (_isHovering)
                        Positioned.fill(
                          child: ShimmerEffect(color: Colors.white.withOpacity(0.1)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedback() {
    return Transform.scale(
      scale: 1.1,
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.item.color.withOpacity(0.9),
              widget.item.color.withOpacity(0.6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.item.color.withOpacity(0.5),
              blurRadius: 25,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.item.icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: widget.item.color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.drag_indicator,
          color: Colors.white.withOpacity(0.3),
          size: 30,
        ),
      ),
    );
  }
}

/// Ultra-stylish liquid delete bin with amazing animations
class LiquidDeleteBin extends StatefulWidget {
  final Function(String) onItemDeleted;
  final Color binColor;
  final double binSize;
  final Duration animationDuration;

  const LiquidDeleteBin({
    Key? key,
    required this.onItemDeleted,
    this.binColor = Colors.red,
    this.binSize = 80,
    this.animationDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<LiquidDeleteBin> createState() => _LiquidDeleteBinState();
}

class _LiquidDeleteBinState extends State<LiquidDeleteBin>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _absorptionController;
  late AnimationController _particleController;
  
  late Animation<double> _idleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _liquidAnimation;
  late Animation<double> _particleAnimation;
  
  bool _isDragOver = false;
  bool _isAbsorbing = false;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    _idleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _absorptionController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _idleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _absorptionController, curve: Curves.elasticOut),
    );
    
    _liquidAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _absorptionController, curve: Curves.easeInOut),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    _absorptionController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _startAbsorption() async {
    if (_isAbsorbing) return;
    
    setState(() {
      _isAbsorbing = true;
      _particles.clear();
      for (int i = 0; i < 15; i++) {
        _particles.add(Particle.random());
      }
    });
    
    _particleController.forward();
    await _absorptionController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    
    _absorptionController.reverse();
    _particleController.reset();
    
    setState(() {
      _isAbsorbing = false;
      _particles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<DraggableItem>(
      onWillAccept: (data) {
        setState(() => _isDragOver = true);
        return data != null;
      },
      onLeave: (data) {
        setState(() => _isDragOver = false);
      },
      onAccept: (data) {
        setState(() => _isDragOver = false);
        _startAbsorption();
        widget.onItemDeleted(data.id);
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            _idleAnimation,
            _scaleAnimation,
            _liquidAnimation,
            _particleAnimation,
          ]),
          builder: (context, child) {
            return Container(
              width: widget.binSize * 2,
              height: widget.binSize * 1.5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Particle effects
                  if (_isAbsorbing)
                    ..._particles.map((particle) => Positioned(
                      left: particle.x * widget.binSize * 2,
                      top: particle.y * widget.binSize * 1.5,
                      child: Transform.scale(
                        scale: (1.0 - _particleAnimation.value) * particle.scale,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: particle.color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: particle.color.withOpacity(0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  
                  // Main liquid bin
                  Transform.scale(
                    scale: _isDragOver ? 1.2 : 1.0,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: CustomPaint(
                        size: Size(widget.binSize, widget.binSize),
                        painter: LiquidBinPainter(
                          color: widget.binColor,
                          isDragOver: _isDragOver,
                          isAbsorbing: _isAbsorbing,
                          idleProgress: _idleAnimation.value,
                          liquidProgress: _liquidAnimation.value,
                        ),
                      ),
                    ),
                  ),
                  
                  // Glow effect
                  if (_isDragOver || _isAbsorbing)
                    Container(
                      width: widget.binSize * 2,
                      height: widget.binSize * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.binColor.withOpacity(0.0),
                            widget.binColor.withOpacity(0.1),
                            widget.binColor.withOpacity(0.3),
                            widget.binColor.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Custom painter for the liquid bin with amazing visual effects
class LiquidBinPainter extends CustomPainter {
  final Color color;
  final bool isDragOver;
  final bool isAbsorbing;
  final double idleProgress;
  final double liquidProgress;

  LiquidBinPainter({
    required this.color,
    required this.isDragOver,
    required this.isAbsorbing,
    required this.idleProgress,
    required this.liquidProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.8),
          color.withOpacity(0.6),
          color.withOpacity(0.4),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw shadow
    canvas.drawCircle(center + const Offset(0, 5), radius, shadowPaint);

    if (isAbsorbing) {
      // Liquid absorption effect
      _drawLiquidEffect(canvas, size, paint);
    } else {
      // Normal bin with idle animation
      _drawNormalBin(canvas, size, paint, center, radius);
    }

    // Draw bin icon
    _drawBinIcon(canvas, size, center);
  }

  void _drawLiquidEffect(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 3;
    
    // Create liquid deformation based on progress
    final deformationAmount = liquidProgress * 20;
    
    for (double angle = 0; angle < math.pi * 2; angle += 0.1) {
      final noise = math.sin(angle * 6 + liquidProgress * math.pi * 4) * deformationAmount;
      final adjustedRadius = baseRadius + noise;
      
      final x = center.dx + math.cos(angle) * adjustedRadius;
      final y = center.dy + math.sin(angle) * adjustedRadius;
      
      if (angle == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawNormalBin(Canvas canvas, Size size, Paint paint, Offset center, double radius) {
    // Idle pulsing effect
    final pulseRadius = radius + math.sin(idleProgress * math.pi * 2) * 3;
    final adjustedRadius = isDragOver ? pulseRadius * 1.1 : pulseRadius;
    
    // Draw main bin body
    canvas.drawCircle(center, adjustedRadius, paint);
    
    // Draw bin rim
    final rimPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, adjustedRadius, rimPaint);
  }

  void _drawBinIcon(Canvas canvas, Size size, Offset center) {
    final iconPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final iconSize = size.width * 0.3;
    
    // Draw trash bin body
    final binRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center + const Offset(0, 5),
        width: iconSize,
        height: iconSize * 0.8,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(binRect, iconPaint);
    
    // Draw lid
    canvas.drawLine(
      Offset(center.dx - iconSize / 2 - 3, center.dy - iconSize / 2 + 3),
      Offset(center.dx + iconSize / 2 + 3, center.dy - iconSize / 2 + 3),
      iconPaint,
    );
    
    // Draw handle
    canvas.drawLine(
      Offset(center.dx - 4, center.dy - iconSize / 2 + 3),
      Offset(center.dx - 4, center.dy - iconSize / 2 - 3),
      iconPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 4, center.dy - iconSize / 2 + 3),
      Offset(center.dx + 4, center.dy - iconSize / 2 - 3),
      iconPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Particle class for explosion effects
class Particle {
  final double x;
  final double y;
  final double scale;
  final Color color;

  Particle({
    required this.x,
    required this.y,
    required this.scale,
    required this.color,
  });

  factory Particle.random() {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.cyan,
      Colors.purple,
    ];
    
    return Particle(
      x: math.Random().nextDouble(),
      y: math.Random().nextDouble(),
      scale: 0.5 + math.Random().nextDouble() * 1.5,
      color: colors[math.Random().nextInt(colors.length)],
    );
  }
}

/// Shimmer effect widget for hover animations
class ShimmerEffect extends StatefulWidget {
  final Color color;

  const ShimmerEffect({Key? key, required this.color}) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_animation.value * math.pi),
              colors: [
                Colors.transparent,
                widget.color,
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}