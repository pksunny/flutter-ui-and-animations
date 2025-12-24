import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedListScreen extends StatefulWidget {
  const AnimatedListScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedListScreen> createState() => _AnimatedListScreenState();
}

class _AnimatedListScreenState extends State<AnimatedListScreen>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ListItemData> _items = [];
  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'Todo';

  @override
  void initState() {
    super.initState();
    // Add initial items with staggered animation
    Future.delayed(const Duration(milliseconds: 300), () {
      _addInitialItems();
    });
  }

  void _addInitialItems() {
    final initialItems = [
      ListItemData(
        id: '1',
        title: 'Design new landing page',
        category: 'Todo',
        icon: Icons.design_services,
        color: const Color(0xFF6366F1),
      ),
      ListItemData(
        id: '2',
        title: 'Review pull requests',
        category: 'Todo',
        icon: Icons.code,
        color: const Color(0xFF8B5CF6),
        isCompleted: true,
      ),
      ListItemData(
        id: '3',
        title: 'Q1 Planning meeting notes',
        category: 'Notes',
        icon: Icons.note_alt,
        color: const Color(0xFF10B981),
      ),
    ];

    for (int i = 0; i < initialItems.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        _addItem(initialItems[i]);
      });
    }
  }

  void _addItem(ListItemData item) {
    final index = _items.length;
    _items.insert(index, item);
    _listKey.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedItem(removedItem, animation, index),
      duration: const Duration(milliseconds: 400),
    );
  }

  void _addNewItem() {
    if (_textController.text.trim().isEmpty) return;

    final newItem = ListItemData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _textController.text,
      category: _selectedCategory,
      icon: _getIconForCategory(_selectedCategory),
      color: _getColorForCategory(_selectedCategory),
    );

    _addItem(newItem);
    _textController.clear();

    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Todo':
        return Icons.check_circle_outline;
      case 'Notes':
        return Icons.note_alt;
      case 'Cart':
        return Icons.shopping_cart;
      default:
        return Icons.circle;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Todo':
        return const Color(0xFF6366F1);
      case 'Notes':
        return const Color(0xFF10B981);
      case 'Cart':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  Widget _buildAnimatedItem(
    ListItemData item,
    Animation<double> animation,
    int index,
  ) {
    return AnimatedListItem(
      animation: animation,
      item: item,
      onDelete: () => _removeItem(index),
      onToggle: () {
        setState(() {
          _items[index].isCompleted = !_items[index].isCompleted;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Category Selector
            _buildCategorySelector(),

            // List
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _items.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index, animation) {
                  return _buildAnimatedItem(_items[index], animation, index);
                },
              ),
            ),

            // Input Section
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.layers, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Lists',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                '${_items.length} items',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = ['Todo', 'Notes', 'Cart'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children:
            categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? LinearGradient(
                                colors: [
                                  _getColorForCategory(category),
                                  _getColorForCategory(
                                    category,
                                  ).withOpacity(0.8),
                                ],
                              )
                              : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconForCategory(category),
                          size: 18,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Add new ${_selectedCategory.toLowerCase()}...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onSubmitted: (_) => _addNewItem(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _addNewItem,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getColorForCategory(_selectedCategory),
                    _getColorForCategory(_selectedCategory).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getColorForCategory(
                      _selectedCategory,
                    ).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Animated List Item Widget with scale + fade animation from top
class AnimatedListItem extends StatefulWidget {
  final Animation<double> animation;
  final ListItemData item;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const AnimatedListItem({
    Key? key,
    required this.animation,
    required this.item,
    required this.onDelete,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scale animation: starts from 0.8 and goes to 1.0
    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: widget.animation, curve: Curves.easeOutBack),
    );

    // Fade animation: starts from 0.0 and goes to 1.0
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Slide animation: starts from top (-50 pixels)
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: widget.animation, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _isHovered = true);
                _hoverController.forward();
              },
              onExit: (_) {
                setState(() => _isHovered = false);
                _hoverController.reverse();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform:
                    Matrix4.identity()..translate(0.0, _isHovered ? -2.0 : 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: widget.item.color.withOpacity(
                          _isHovered ? 0.2 : 0.1,
                        ),
                        blurRadius: _isHovered ? 20 : 10,
                        offset: Offset(0, _isHovered ? 8 : 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onToggle,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icon Container
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.item.color,
                                    widget.item.color.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.item.color.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.item.isCompleted
                                    ? Icons.check_circle
                                    : widget.item.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.item.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0F172A),
                                      decoration:
                                          widget.item.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: widget.item.color.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          widget.item.category,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: widget.item.color,
                                          ),
                                        ),
                                      ),
                                      if (widget.item.isCompleted) ...[
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: widget.item.color,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Delete Button
                            AnimatedOpacity(
                              opacity: _isHovered ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: IconButton(
                                onPressed: widget.onDelete,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFEF4444),
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFFEF4444,
                                  ).withOpacity(0.1),
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
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
}

/// Data model for list items
class ListItemData {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final Color color;
  bool isCompleted;

  ListItemData({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
    this.isCompleted = false,
  });
}
