import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;

  ListItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });
}

class DargReorderListScreen extends StatefulWidget {
  @override
  _DargReorderListScreenState createState() => _DargReorderListScreenState();
}

class _DargReorderListScreenState extends State<DargReorderListScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _listController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _listAnimation;

  List<ListItem> items = [
    ListItem(
      id: '1',
      title: 'Creative Design',
      subtitle: 'Unleash your imagination',
      icon: Icons.palette_outlined,
      gradientColors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    ),
    ListItem(
      id: '2',
      title: 'Data Analytics',
      subtitle: 'Insights from numbers',
      icon: Icons.analytics_outlined,
      gradientColors: [Color(0xFF00B894), Color(0xFF55EFC4)],
    ),
    ListItem(
      id: '3',
      title: 'Development',
      subtitle: 'Code the future',
      icon: Icons.code_outlined,
      gradientColors: [Color(0xFFE17055), Color(0xFFFDAA6D)],
    ),
    ListItem(
      id: '4',
      title: 'Marketing',
      subtitle: 'Reach your audience',
      icon: Icons.campaign_outlined,
      gradientColors: [Color(0xFFD63031), Color(0xFFF97C7C)],
    ),
    ListItem(
      id: '5',
      title: 'Photography',
      subtitle: 'Capture moments',
      icon: Icons.camera_alt_outlined,
      gradientColors: [Color(0xFF74B9FF), Color(0xFF00CEC9)],
    ),
    ListItem(
      id: '6',
      title: 'Music Production',
      subtitle: 'Create soundscapes',
      icon: Icons.music_note_outlined,
      gradientColors: [Color(0xFFE84393), Color(0xFDFF7675)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _listController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _listAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.elasticOut,
    ));

    _listController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _onReorder(int oldIndex, int newIndex) {
    HapticFeedback.mediumImpact();
    
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5 + _backgroundAnimation.value * 1.0, 
                              -0.8 + _backgroundAnimation.value * 0.4),
                radius: 1.5,
                colors: [
                  Color(0xFF1A1A2E).withOpacity(0.8),
                  Color(0xFF16213E).withOpacity(0.9),
                  Color(0xFF0F0F23),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Color(0xFF6C5CE7),
                              Color(0xFFA29BFE),
                              Color(0xFF74B9FF),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Amazing Reorder',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Drag items to reorder with style',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Reorderable List
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _listAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.7 + (_listAnimation.value * 0.3),
                          child: Opacity(
                            opacity: _listAnimation.value.clamp(0.0, 1.0),
                            child: ReorderableListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: items.length,
                              onReorder: _onReorder,
                              proxyDecorator: (child, index, animation) {
                                return AnimatedBuilder(
                                  animation: animation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 1.0 + (animation.value * 0.1),
                                      child: Transform.rotate(
                                        angle: animation.value * 0.1,
                                        child: Material(
                                          elevation: 12,
                                          shadowColor: items[index].gradientColors[0]
                                              .withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(20),
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  child: child,
                                );
                              },
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return AnimatedListTile(
                                  key: ValueKey(item.id),
                                  item: item,
                                  index: index,
                                  animation: _listAnimation,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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

class AnimatedListTile extends StatefulWidget {
  final ListItem item;
  final int index;
  final Animation<double> animation;

  const AnimatedListTile({
    Key? key,
    required this.item,
    required this.index,
    required this.animation,
  }) : super(key: key);

  @override
  _AnimatedListTileState createState() => _AnimatedListTileState();
}

// Custom painter for geometric patterns
class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw geometric pattern
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
        if (x + spacing < size.width) {
          canvas.drawLine(Offset(x, y), Offset(x + spacing, y), paint);
        }
        if (y + spacing < size.height) {
          canvas.drawLine(Offset(x, y), Offset(x, y + spacing), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _AnimatedListTileState extends State<AnimatedListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _iconRotation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.animation, _hoverAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0, 
            (1 - widget.animation.value) * 100 + widget.index * 20,
          ),
          child: Transform.scale(
            scale: _hoverAnimation.value,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.item.gradientColors[0].withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() => _isHovered = true);
                    _hoverController.forward();
                    HapticFeedback.lightImpact();
                  },
                  onTapUp: (_) {
                    setState(() => _isHovered = false);
                    _hoverController.reverse();
                  },
                  onTapCancel: () {
                    setState(() => _isHovered = false);
                    _hoverController.reverse();
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.item.gradientColors[0].withOpacity(0.8),
                          widget.item.gradientColors[1].withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background geometric pattern
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.1,
                            child: CustomPaint(
                              painter: GeometricPatternPainter(),
                            ),
                          ),
                        ),
                        
                        // Glassmorphism overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                        
                        // Content
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Icon
                              AnimatedBuilder(
                                animation: _iconRotation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _iconRotation.value,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        widget.item.icon,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(width: 20),
                              
                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.item.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      widget.item.subtitle,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Drag handle
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.drag_handle_rounded,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
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
            ),
          ),
        );
      },
    );
  }
}