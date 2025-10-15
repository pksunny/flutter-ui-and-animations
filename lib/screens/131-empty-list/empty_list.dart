
import 'dart:math';

import 'package:flutter/material.dart';


/// Main screen with deletable list items
class EmptyList extends StatefulWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  State<EmptyList> createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList>
    with TickerProviderStateMixin {
  late AnimationController _emptyStateController;
  late List<ItemModel> items;

  @override
  void initState() {
    super.initState();
    _emptyStateController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize with sample items
    items = [
      ItemModel(id: 1, title: 'Learn Flutter', icon: Icons.flutter_dash),
      ItemModel(id: 2, title: 'Build UI Widgets', icon: Icons.palette),
      ItemModel(id: 3, title: 'Master Animations', icon: Icons.animation),
      ItemModel(id: 4, title: 'Create Amazing Apps', icon: Icons.rocket_launch),
      ItemModel(id: 5, title: 'Deploy to Store', icon: Icons.publish),
    ];
  }

  @override
  void dispose() {
    _emptyStateController.dispose();
    super.dispose();
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });

    // If list becomes empty, play animation
    if (items.isEmpty) {
      _emptyStateController.forward();
    }
  }

  void _addItem() {
    if (items.isEmpty) {
      _emptyStateController.reset();
    }

    setState(() {
      items.add(
        ItemModel(
          id: DateTime.now().millisecond,
          title: 'New Task ${items.length + 1}',
          icon: Icons.task_alt,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${items.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildItemTile(index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds the empty state with beautiful animation
  Widget _buildEmptyState() {
    return AnimatedBuilder(
      animation: _emptyStateController,
      builder: (context, child) {
        return Stack(
          children: [
            // Animated background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1F2937).withOpacity(0.8),
                      const Color(0xFF111827).withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),

            // Animated floating particles
            Positioned.fill(
              child: Stack(
                children: [
                  _buildAnimatedParticle(0, 0.3),
                  _buildAnimatedParticle(1, 0.5),
                  _buildAnimatedParticle(2, 0.7),
                  _buildAnimatedParticle(3, 0.4),
                  _buildAnimatedParticle(4, 0.6),
                ],
              ),
            ),

            // Main empty state content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Animated emoji/icon
                      Transform.translate(
                        offset: Offset(
                          0,
                          20 * (1 - _emptyStateController.value),
                        ),
                        child: Opacity(
                          opacity: _emptyStateController.value,
                          child: Transform.scale(
                            scale: _emptyStateController.value,
                            child: _buildAnimatedEmptyIcon(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// Title with fade and slide animation
                      Transform.translate(
                        offset: Offset(
                          0,
                          30 * (1 - _emptyStateController.value),
                        ),
                        child: Opacity(
                          opacity: _emptyStateController.value,
                          child: Text(
                            'Oops! All Done 🎉',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Subtitle
                      Transform.translate(
                        offset: Offset(
                          0,
                          30 * (1 - _emptyStateController.value),
                        ),
                        child: Opacity(
                          opacity: _emptyStateController.value,
                          child: Text(
                            'You\'ve cleared all your tasks!\nTime to relax and celebrate! 🚀',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// Action buttons
                      Transform.translate(
                        offset: Offset(
                          0,
                          40 * (1 - _emptyStateController.value),
                        ),
                        child: Opacity(
                          opacity: _emptyStateController.value,
                          child: _buildActionButtons(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds animated floating particles
  Widget _buildAnimatedParticle(int index, double baseDelay) {
    return Positioned(
      left: (index * 80).toDouble(),
      top: (index * 120).toDouble(),
      child: Opacity(
        opacity: 0.1 * _emptyStateController.value,
        child: Transform.translate(
          offset: Offset(
            20 * Math.cos(index.toDouble()) * _emptyStateController.value,
            20 * Math.sin(index.toDouble()) * _emptyStateController.value,
          ),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.3),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds animated icon for empty state
  Widget _buildAnimatedEmptyIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6366F1).withOpacity(0.3),
            const Color(0xFF8B5CF6).withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating ring
          Transform.rotate(
            angle: _emptyStateController.value * 6.28,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
          ),

          // Main icon
          const Icon(
            Icons.check_circle_outline,
            size: 70,
            color: Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  

  /// Builds action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildButton(
          text: 'Add New Task',
          onPressed: _addItem,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _buildButton(
          text: 'Go Back',
          onPressed: () {
            // Add navigation if needed
          },
          isPrimary: false,
        ),
      ],
    );
  }

  /// Builds styled button
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                    ],
                  )
                : null,
            color: isPrimary ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : const Color(0xFF6366F1).withOpacity(0.3),
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : const Color(0xFF6366F1),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// Builds list item tile
  Widget _buildItemTile(int index) {
    final item = items[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: const Color(0xFF6366F1),
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteItem(index),
            ),
          ),
        ),
      ),
    );
  }

  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )..forward();
}

/// Model class for items
class ItemModel {
  final int id;
  final String title;
  final IconData icon;

  ItemModel({
    required this.id,
    required this.title,
    required this.icon,
  });
}

/// Math helper class
class Math {
  static double cos(double value) => cosFn(value * 3.14159 / 180);
  static double sin(double value) => sinFn(value * 3.14159 / 180);
}

final cosFn = cos;
final sinFn = sin;