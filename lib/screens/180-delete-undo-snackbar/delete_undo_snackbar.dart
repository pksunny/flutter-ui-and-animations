import 'package:flutter/material.dart';
import 'dart:async';

// 🎨 DEMO SCREEN - Shows the snackbar system in action
class DeleteUndoDemo extends StatefulWidget {
  const DeleteUndoDemo({Key? key}) : super(key: key);

  @override
  State<DeleteUndoDemo> createState() => _DeleteUndoDemoState();
}

class _DeleteUndoDemoState extends State<DeleteUndoDemo>
    with TickerProviderStateMixin {
  final List<TaskItem> _items = [
    TaskItem(
      id: 1,
      title: 'Morning Workout',
      subtitle: 'Complete 30 min cardio',
      icon: '🏃',
      color: Colors.blue,
    ),
    TaskItem(
      id: 2,
      title: 'Team Meeting',
      subtitle: 'Discuss Q4 goals',
      icon: '👥',
      color: Colors.purple,
    ),
    TaskItem(
      id: 3,
      title: 'Project Deadline',
      subtitle: 'Submit final report',
      icon: '📊',
      color: Colors.orange,
    ),
    TaskItem(
      id: 4,
      title: 'Lunch Break',
      subtitle: 'Meet with Sarah',
      icon: '🍽️',
      color: Colors.green,
    ),
    TaskItem(
      id: 5,
      title: 'Code Review',
      subtitle: 'Review PR #234',
      icon: '💻',
      color: Colors.teal,
    ),
    TaskItem(
      id: 6,
      title: 'Grocery Shopping',
      subtitle: 'Buy ingredients',
      icon: '🛒',
      color: Colors.pink,
    ),
  ];

  final List<TaskItem> _deletedItems = [];

  // 🎯 Delete item with undo functionality
  void _deleteItem(TaskItem item, int index) {
    setState(() {
      _items.removeAt(index);
      _deletedItems.add(item);
    });

    // 🚀 Show the ultra-stylish snackbar
    UltraStylishSnackbar.show(
      context: context,
      message: '"${item.title}" deleted',
      icon: Icons.delete_outline,
      iconColor: Colors.red,
      duration: const Duration(seconds: 4),
      onUndo: () {
        // ✨ Undo the deletion
        setState(() {
          _items.insert(index, item);
          _deletedItems.remove(item);
        });
      },
      onDismissed: () {
        // 💾 Permanently delete after timeout (if not undone)
        print('Item permanently deleted: ${item.title}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // 🎨 Beautiful App Bar
          SliverAppBar.large(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Delete & Undo Demo',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple.shade50, Colors.blue.shade50],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.swipe,
                    size: 60,
                    color: Colors.deepPurple.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),

          // 📝 Subtitle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Swipe left on any item to delete with instant undo option',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // 📋 Items List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = _items[index];
                return _TaskCard(
                  item: item,
                  onDelete: () => _deleteItem(item, index),
                );
              }, childCount: _items.length),
            ),
          ),

          // 📊 Empty State
          if (_items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'All items deleted!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 🎴 Task Card Widget with Dismissible
class _TaskCard extends StatelessWidget {
  final TaskItem item;
  final VoidCallback onDelete;

  const _TaskCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade400, Colors.red.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Icon(Icons.delete_sweep, color: Colors.white, size: 32),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    item.color.withOpacity(0.2),
                    item.color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(item.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
            trailing: Icon(Icons.chevron_left, color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}

// 🌟 ULTRA-STYLISH SNACKBAR SYSTEM
// This is the main reusable component you can use in any Flutter app
class UltraStylishSnackbar {
  /// 🎨 Show an ultra-stylish snackbar with undo functionality
  ///
  /// Parameters:
  /// - [context]: BuildContext (required)
  /// - [message]: The message to display (required)
  /// - [icon]: Icon to show (optional)
  /// - [iconColor]: Color of the icon (optional)
  /// - [duration]: How long to show the snackbar (default: 4 seconds)
  /// - [onUndo]: Callback when undo is pressed (optional)
  /// - [onDismissed]: Callback when snackbar is dismissed (optional)
  /// - [backgroundColor]: Custom background color (optional)
  /// - [textColor]: Custom text color (optional)
  /// - [undoButtonColor]: Custom undo button color (optional)
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? iconColor,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onUndo,
    VoidCallback? onDismissed,
    Color? backgroundColor,
    Color? textColor,
    Color? undoButtonColor,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => _UltraStylishSnackbarWidget(
            message: message,
            icon: icon,
            iconColor: iconColor,
            duration: duration,
            onUndo: onUndo,
            onDismissed: onDismissed,
            backgroundColor: backgroundColor,
            textColor: textColor,
            undoButtonColor: undoButtonColor,
          ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        onDismissed?.call();
      }
    });
  }
}

// 🎭 Snackbar Widget with Animations
class _UltraStylishSnackbarWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final Duration duration;
  final VoidCallback? onUndo;
  final VoidCallback? onDismissed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? undoButtonColor;

  const _UltraStylishSnackbarWidget({
    required this.message,
    this.icon,
    this.iconColor,
    required this.duration,
    this.onUndo,
    this.onDismissed,
    this.backgroundColor,
    this.textColor,
    this.undoButtonColor,
  });

  @override
  State<_UltraStylishSnackbarWidget> createState() =>
      _UltraStylishSnackbarWidgetState();
}

class _UltraStylishSnackbarWidgetState
    extends State<_UltraStylishSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _progressTimer;
  double _progress = 0.0;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    // 🎬 Setup animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // ⏱️ Progress timer
    const updateInterval = Duration(milliseconds: 50);
    final totalUpdates =
        widget.duration.inMilliseconds / updateInterval.inMilliseconds;
    final progressIncrement = 1.0 / totalUpdates;

    _progressTimer = Timer.periodic(updateInterval, (timer) {
      if (mounted && !_isDismissing) {
        setState(() {
          _progress += progressIncrement;
          if (_progress >= 1.0) {
            _progress = 1.0;
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleUndo() {
    if (_isDismissing) return;
    _isDismissing = true;

    widget.onUndo?.call();
    _dismiss();
  }

  void _dismiss() {
    _progressTimer?.cancel();
    _controller.reverse().then((_) {
      if (mounted) {
        // Remove from overlay
        final overlay = Overlay.of(context);
        overlay.setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 100 * (1 - _slideAnimation.value)),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? const Color(0xFF2D3142),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 📊 Progress indicator
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.iconColor ?? Colors.red.shade400,
                      ),
                      minHeight: 3,
                    ),
                  ),

                  // 📝 Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // 🎨 Icon
                        if (widget.icon != null)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: (widget.iconColor ?? Colors.red)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.icon,
                              color: widget.iconColor ?? Colors.red,
                              size: 24,
                            ),
                          ),

                        if (widget.icon != null) const SizedBox(width: 16),

                        // 📝 Message
                        Expanded(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: widget.textColor ?? Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // ↩️ Undo Button
                        if (widget.onUndo != null)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _handleUndo,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.undoButtonColor ??
                                          Colors.deepPurple.shade400,
                                      widget.undoButtonColor ??
                                          Colors.deepPurple.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (widget.undoButtonColor ??
                                              Colors.deepPurple)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.undo,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'UNDO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
    );
  }
}

// 📦 Task Item Model
class TaskItem {
  final int id;
  final String title;
  final String subtitle;
  final String icon;
  final Color color;

  TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
