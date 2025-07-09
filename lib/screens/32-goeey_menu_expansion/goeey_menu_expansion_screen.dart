import 'dart:math';
import 'package:flutter/material.dart';

class GoeeyMenuExpansionScreen extends StatefulWidget {
  const GoeeyMenuExpansionScreen({super.key});

  @override
  State<GoeeyMenuExpansionScreen> createState() => _GoeeyMenuExpansionScreenState();
}

class _GoeeyMenuExpansionScreenState extends State<GoeeyMenuExpansionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnim;
  bool isOpen = false;
  final double radius = 200;
  final double buttonSize = 56;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _expandAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    super.initState();
  }

  void toggle() {
    setState(() => isOpen = !isOpen);
    isOpen ? _controller.forward() : _controller.reverse();
  }

  Widget buildButton({
    required double angle,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    final rad = angle * pi / 180;
    return AnimatedBuilder(
      animation: _expandAnim,
      builder: (context, child) {
        final offset = Offset(
          -cos(rad) * radius * _expandAnim.value,
          -sin(rad) * radius * _expandAnim.value,
        );

        final screenSize = MediaQuery.of(context).size;

        // 🧠 Keep button inside screen bounds
        double right = 20 + offset.dx;
        double bottom = 20 + offset.dy;

        right = right.clamp(0.0, screenSize.width - buttonSize);
        bottom = bottom.clamp(0.0, screenSize.height - buttonSize);

        return Positioned(
          right: right,
          bottom: bottom,
          child: Transform.scale(
            scale: _expandAnim.value,
            child: child!,
          ),
        );
      },
      child: FloatingActionButton(
        heroTag: index,
        onPressed: () {},
        backgroundColor: color,
        child: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E21),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Gooey FAB Menu',
              style: TextStyle(color: Colors.white70, fontSize: 22),
            ),
          ),

          // ✨ Buttons (safe angles only!)
          buildButton(angle: 275, icon: Icons.share, color: Colors.green, index: 1),
          buildButton(angle: 250, icon: Icons.camera_alt, color: Colors.pink, index: 2),
          buildButton(angle: 225, icon: Icons.mic, color: Colors.deepPurple, index: 3),
          buildButton(angle: 200, icon: Icons.image, color: Colors.teal, index: 4),
          buildButton(angle: 175, icon: Icons.edit, color: Colors.indigo, index: 5),

          // 🟠 Main FAB
          Positioned(
            bottom: 20,
            right: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _expandAnim,
                  builder: (_, __) {
                    return Container(
                      width: 80 + (_expandAnim.value * 120),
                      height: 80 + (_expandAnim.value * 120),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2 * _expandAnim.value),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: toggle,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _expandAnim,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
