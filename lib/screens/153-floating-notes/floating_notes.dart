import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Main Screen with Floating Notes Animation
class FloatingNotesScreen extends StatefulWidget {
  const FloatingNotesScreen({Key? key}) : super(key: key);

  @override
  State<FloatingNotesScreen> createState() => _FloatingNotesScreenState();
}

class _FloatingNotesScreenState extends State<FloatingNotesScreen>
    with TickerProviderStateMixin {
  late List<NoteCardController> _noteControllers;
  final List<NoteData> _notes = [];

  @override
  void initState() {
    super.initState();
    _initializeNotes();
    _startFloatingAnimation();
  }

  /// Initialize sample notes with beautiful colors
  void _initializeNotes() {
    final sampleNotes = [
      NoteData(
        title: '🎨 Creative Ideas',
        content: 'Design the impossible, create the extraordinary',
        color: const Color(0xFFFFE5E5),
        accentColor: const Color(0xFFFF6B9D),
      ),
      NoteData(
        title: '💡 Innovation',
        content: 'Transform dreams into digital reality',
        color: const Color(0xFFE5F4FF),
        accentColor: const Color(0xFF4FC3F7),
      ),
      NoteData(
        title: '🚀 Launch Goals',
        content: 'Reach for the stars and beyond',
        color: const Color(0xFFFFF8E1),
        accentColor: const Color(0xFFFFB74D),
      ),
      NoteData(
        title: '🎯 Focus Points',
        content: 'Precision in every detail matters',
        color: const Color(0xFFE8F5E9),
        accentColor: const Color(0xFF66BB6A),
      ),
      NoteData(
        title: '✨ Magic Moments',
        content: 'Creating experiences that inspire wonder',
        color: const Color(0xFFF3E5F5),
        accentColor: const Color(0xFFBA68C8),
      ),
      NoteData(
        title: '🎪 Entertainment',
        content: 'Joy in every interaction and animation',
        color: const Color(0xFFFFEBEE),
        accentColor: const Color(0xFFEF5350),
      ),
    ];

    _notes.addAll(sampleNotes);
    _noteControllers = List.generate(
      _notes.length,
      (index) => NoteCardController(
        vsync: this,
        index: index,
        totalNotes: _notes.length,
      ),
    );
  }

  /// Start the continuous floating animation
  void _startFloatingAnimation() {
    for (var controller in _noteControllers) {
      controller.startAnimation();
    }
  }

  @override
  void dispose() {
    for (var controller in _noteControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF5F7FA),
              const Color(0xFFE8EEF7),
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Stack(
                  children: [
                    // Decorative background elements
                    _buildBackgroundDecoration(),
                    // Floating notes
                    ..._buildFloatingNotes(),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Beautiful header with title and subtitle
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Floating Notes',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F36),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Ideas floating in space ✨',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Background decoration with subtle animated circles
  Widget _buildBackgroundDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: BackgroundPatternPainter(),
      ),
    );
  }

  /// Generate all floating note cards
  List<Widget> _buildFloatingNotes() {
    return List.generate(_notes.length, (index) {
      return AnimatedBuilder(
        animation: _noteControllers[index].animation,
        builder: (context, child) {
          return FloatingNoteCard(
            note: _notes[index],
            controller: _noteControllers[index],
            onTap: () => _onNoteTap(index),
          );
        },
      );
    });
  }

  /// Handle note tap with haptic feedback
  void _onNoteTap(int index) {
    // Add haptic feedback or navigation here
    showDialog(
      context: context,
      builder: (context) => NoteDetailDialog(note: _notes[index]),
    );
  }

  /// Bottom action bar
  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomBarItem(Icons.grid_view_rounded, 'All', true),
          _buildBottomBarItem(Icons.star_rounded, 'Favorites', false),
          _buildBottomBarItem(Icons.schedule_rounded, 'Recent', false),
          _buildBottomBarItem(Icons.folder_rounded, 'Folders', false),
        ],
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.blue.shade600 : Colors.grey.shade400,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.blue.shade600 : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  /// Floating action button for adding new notes
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, size: 28),
        label: const Text(
          'New Note',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}

/// Data model for a note
class NoteData {
  final String title;
  final String content;
  final Color color;
  final Color accentColor;

  NoteData({
    required this.title,
    required this.content,
    required this.color,
    required this.accentColor,
  });
}

/// Controller for managing individual note animations
class NoteCardController {
  final TickerProvider vsync;
  final int index;
  final int totalNotes;
  late AnimationController _controller;
  late Animation<double> animation;
  final math.Random _random = math.Random();

  // Randomized properties for each note
  late double startX;
  late double startY;
  late double rotationAngle;
  late double floatSpeed;
  late double horizontalDrift;

  NoteCardController({
    required this.vsync,
    required this.index,
    required this.totalNotes,
  }) {
    _initializeRandomProperties();
    _setupAnimation();
  }

  void _initializeRandomProperties() {
    // Random horizontal position (10% to 85% of screen width)
    startX = 0.1 + (_random.nextDouble() * 0.75);
    
    // Stagger vertical start positions
    startY = 0.15 + (index * 0.12) + (_random.nextDouble() * 0.05);
    
    // Random rotation (-15° to 15°)
    rotationAngle = -0.26 + (_random.nextDouble() * 0.52);
    
    // Random float speed (8-15 seconds per cycle)
    floatSpeed = 8 + (_random.nextDouble() * 7);
    
    // Random horizontal drift
    horizontalDrift = -0.05 + (_random.nextDouble() * 0.1);
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: Duration(milliseconds: (floatSpeed * 1000).toInt()),
      vsync: vsync,
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void startAnimation() {
    _controller.repeat();
  }

  void dispose() {
    _controller.dispose();
  }

  /// Calculate current position based on animation progress
  Alignment getCurrentAlignment() {
    final progress = animation.value;
    final x = startX + (horizontalDrift * progress);
    final y = startY - (progress * 1.2); // Float upward
    return Alignment(x * 2 - 1, y * 2 - 1);
  }

  /// Calculate current opacity (fade out at top)
  double getCurrentOpacity() {
    final progress = animation.value;
    if (progress < 0.1) {
      return progress * 10; // Fade in
    } else if (progress > 0.85) {
      return (1.0 - progress) * 6.67; // Fade out
    }
    return 1.0;
  }

  /// Calculate current rotation
  double getCurrentRotation() {
    final progress = animation.value;
    return rotationAngle + (progress * 0.3); // Subtle rotation change
  }

  /// Calculate current scale (subtle breathing effect)
  double getCurrentScale() {
    final progress = animation.value;
    return 0.95 + (math.sin(progress * math.pi * 2) * 0.05);
  }
}

/// Individual floating note card widget
class FloatingNoteCard extends StatelessWidget {
  final NoteData note;
  final NoteCardController controller;
  final VoidCallback onTap;

  const FloatingNoteCard({
    Key? key,
    required this.note,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alignment = controller.getCurrentAlignment();
    final opacity = controller.getCurrentOpacity();
    final rotation = controller.getCurrentRotation();
    final scale = controller.getCurrentScale();

    return AnimatedAlign(
      duration: const Duration(milliseconds: 100),
      alignment: alignment,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: rotation,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: size.width * 0.42,
                height: size.height * 0.2,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: note.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: note.accentColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: note.accentColor.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 10,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.3),
                                note.accentColor.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: note.accentColor.withOpacity(0.9),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note.content,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            // Accent dot indicator
                            Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: note.accentColor,
                                borderRadius: BorderRadius.circular(2),
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
      ),
    );
  }
}

/// Background pattern painter for subtle decoration
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw subtle circles
    for (int i = 0; i < 3; i++) {
      paint.color = Colors.blue.withOpacity(0.03);
      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.3), size.height * (0.3 + i * 0.2)),
        100 + (i * 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Note detail dialog with beautiful presentation
class NoteDetailDialog extends StatelessWidget {
  final NoteData note;

  const NoteDetailDialog({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: note.color,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: note.accentColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: note.accentColor.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: note.accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_rounded,
                color: note.accentColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              note.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: note.accentColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              note.content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: note.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}