import 'package:flutter/material.dart';
import 'dart:math' as math;

class PinDropAnimationScreen extends StatefulWidget {
  const PinDropAnimationScreen({Key? key}) : super(key: key);

  @override
  State<PinDropAnimationScreen> createState() => _PinDropAnimationScreenState();
}

class _PinDropAnimationScreenState extends State<PinDropAnimationScreen>
    with TickerProviderStateMixin {
  List<MapPin> pins = [];
  late AnimationController _controller;
  int? selectedPinIndex;

  final List<MapPinData> pinData = [
    MapPinData(
      position: const Offset(150, 200),
      title: "Coffee Shop",
      color: const Color(0xFF6C63FF),
      icon: Icons.local_cafe,
    ),
    MapPinData(
      position: const Offset(300, 150),
      title: "Restaurant",
      color: const Color(0xFFFF6B9D),
      icon: Icons.restaurant,
    ),
    MapPinData(
      position: const Offset(200, 350),
      title: "Shopping Mall",
      color: const Color(0xFF4ECDC4),
      icon: Icons.shopping_bag,
    ),
    MapPinData(
      position: const Offset(80, 300),
      title: "Park",
      color: const Color(0xFF45B7D1),
      icon: Icons.park,
    ),
    MapPinData(
      position: const Offset(320, 280),
      title: "Hospital",
      color: const Color(0xFFFF8A65),
      icon: Icons.local_hospital,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _initializePins();
  }

  void _initializePins() {
    pins = pinData.asMap().entries.map((entry) {
      int index = entry.key;
      MapPinData data = entry.value;
      
      return MapPin(
        data: data,
        dropController: AnimationController(
          duration: Duration(milliseconds: 600 + (index * 100)),
          vsync: this,
        ),
        pulseController: AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: this,
        ),
        rippleController: AnimationController(
          duration: const Duration(milliseconds: 800),
          vsync: this,
        ),
      );
    }).toList();

    // Start pin drop animations with staggered delays
    for (int i = 0; i < pins.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          pins[i].dropController.forward();
          pins[i].pulseController.repeat();
        }
      });
    }
  }

  void _onPinTapped(int index) {
    if (selectedPinIndex == index) return;
    
    setState(() {
      selectedPinIndex = index;
    });
    
    pins[index].rippleController.reset();
    pins[index].rippleController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var pin in pins) {
      pin.dropController.dispose();
      pin.pulseController.dispose();
      pin.rippleController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A3A),
              Color(0xFF2D2D5F),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern
            ...List.generate(20, (index) => Positioned(
              left: (index % 5) * 100.0 + 20,
              top: (index ~/ 5) * 150.0 + 50,
              child: Container(
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            )),
            
            // Map pins
            ...pins.asMap().entries.map((entry) {
              int index = entry.key;
              MapPin pin = entry.value;
              bool isSelected = selectedPinIndex == index;
              
              return AnimatedMapPinWidget(
                pin: pin,
                isSelected: isSelected,
                onTap: () => _onPinTapped(index),
              );
            }).toList(),
            
            // Selected pin info card
            if (selectedPinIndex != null)
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: AnimatedOpacity(
                  opacity: selectedPinIndex != null ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: pins[selectedPinIndex!].data.color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            pins[selectedPinIndex!].data.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                pins[selectedPinIndex!].data.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D2D5F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Tap to view details",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
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
          ],
        ),
      ),
    );
  }
}

class AnimatedMapPinWidget extends StatelessWidget {
  final MapPin pin;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedMapPinWidget({
    Key? key,
    required this.pin,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: pin.data.position.dx - 25,
      top: pin.data.position.dy - 50,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect
            AnimatedBuilder(
              animation: pin.rippleController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (pin.rippleController.value * 2),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: pin.data.color.withOpacity(
                          0.6 * (1 - pin.rippleController.value)
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // Pulse effect
            AnimatedBuilder(
              animation: pin.pulseController,
              builder: (context, child) {
                double pulseScale = 1.0 + (math.sin(pin.pulseController.value * 2 * math.pi) * 0.1);
                return Transform.scale(
                  scale: pulseScale,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pin.data.color.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
            
            // Pin drop animation
            AnimatedBuilder(
              animation: pin.dropController,
              builder: (context, child) {
                double bounceValue = Curves.bounceOut.transform(pin.dropController.value);
                double slideValue = Curves.easeOutCubic.transform(pin.dropController.value);
                
                return Transform.translate(
                  offset: Offset(0, -200 * (1 - slideValue)),
                  child: Transform.scale(
                    scale: 0.5 + (bounceValue * 0.5),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            pin.data.color,
                            pin.data.color.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: pin.data.color.withOpacity(0.4),
                            blurRadius: isSelected ? 20 : 10,
                            spreadRadius: isSelected ? 2 : 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        pin.data.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MapPin {
  final MapPinData data;
  final AnimationController dropController;
  final AnimationController pulseController;
  final AnimationController rippleController;

  MapPin({
    required this.data,
    required this.dropController,
    required this.pulseController,
    required this.rippleController,
  });
}

class MapPinData {
  final Offset position;
  final String title;
  final Color color;
  final IconData icon;

  MapPinData({
    required this.position,
    required this.title,
    required this.color,
    required this.icon,
  });
}
