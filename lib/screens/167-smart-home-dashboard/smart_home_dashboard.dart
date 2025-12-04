import 'package:flutter/material.dart';
import 'dart:math' as math;

// ============================================================================
// MAIN DASHBOARD WIDGET
// ============================================================================
class SmartHomeDashboard extends StatefulWidget {
  const SmartHomeDashboard({Key? key}) : super(key: key);

  @override
  State<SmartHomeDashboard> createState() => _SmartHomeDashboardState();
}

class _SmartHomeDashboardState extends State<SmartHomeDashboard>
    with TickerProviderStateMixin {
  // Room States
  final Map<String, RoomDevice> _rooms = {
    'Living Room': RoomDevice(
      isOn: false,
      brightness: 0.75,
      temperature: 22,
      icon: Icons.weekend,
    ),
    'Bedroom': RoomDevice(
      isOn: true,
      brightness: 0.5,
      temperature: 20,
      icon: Icons.bed,
    ),
    'Kitchen': RoomDevice(
      isOn: false,
      brightness: 1.0,
      temperature: 24,
      icon: Icons.kitchen,
    ),
  };

  // Fan & AC States
  bool _fanOn = false;
  double _fanSpeed = 2.0;
  
  double _acTemp = 22.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F7FA), Color(0xFFE8F0FE), Color(0xFFF3E8FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildQuickStats(),
                const SizedBox(height: 30),
                _buildSectionTitle('Rooms'),
                const SizedBox(height: 16),
                _buildRoomCards(),
                const SizedBox(height: 30),
                _buildSectionTitle('Climate Control'),
                const SizedBox(height: 16),
                _buildClimateControls(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // HEADER SECTION
  // ============================================================================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                  ).createShader(bounds),
              child: const Text(
                'Smart Home',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Welcome back, control your home',
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
        Row(
          children: [
            _buildIconButton(Icons.settings_outlined, () {}),
            const SizedBox(width: 12),
            _buildGradientButton(Icons.person, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24, color: const Color(0xFF1E293B)),
      ),
    );
  }

  Widget _buildGradientButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }

  // ============================================================================
  // QUICK STATS SECTION
  // ============================================================================
  Widget _buildQuickStats() {
    final stats = [
      StatCard(
        icon: Icons.home,
        label: 'Rooms',
        value: '${_rooms.values.where((r) => r.isOn).length} Active',
        colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
      ),
      StatCard(
        icon: Icons.bolt,
        label: 'Energy',
        value: '2.4 kWh',
        colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
      ),
      StatCard(
        icon: Icons.thermostat,
        label: 'Avg Temp',
        value: '${_acTemp.round()}°C',
        colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
      ),
      StatCard(
        icon: Icons.air,
        label: 'Air',
        value: 'Good',
        colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
      ),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => _buildStatCard(stats[index]),
      ),
    );
  }

  Widget _buildStatCard(StatCard stat) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stat.colors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: stat.colors[0].withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(stat.icon, color: Colors.white, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat.label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // SECTION TITLE
  // ============================================================================
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  // ============================================================================
  // ROOM CARDS SECTION
  // ============================================================================
  Widget _buildRoomCards() {
    return Column(
      children:
          _rooms.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RoomCard(
                roomName: entry.key,
                device: entry.value,
                onToggle: () => _toggleRoom(entry.key),
                onBrightnessChanged:
                    (value) => _updateBrightness(entry.key, value),
              ),
            );
          }).toList(),
    );
  }

  void _toggleRoom(String roomName) {
    setState(() {
      _rooms[roomName]!.isOn = !_rooms[roomName]!.isOn;
    });
  }

  void _updateBrightness(String roomName, double value) {
    setState(() {
      _rooms[roomName]!.brightness = value;
    });
  }

  // ============================================================================
  // CLIMATE CONTROLS SECTION
  // ============================================================================
  Widget _buildClimateControls() {
    return Column(
      children: [
        // Fan Control
        ClimateControlCard(
          title: 'Fan',
          icon: Icons.air,
          isActive: _fanOn,
          value: _fanSpeed,
          minValue: 1,
          maxValue: 5,
          unit: 'Speed',
          gradientColors: const [Color(0xFF06B6D4), Color(0xFF3B82F6)],
          onToggle: () => setState(() => _fanOn = !_fanOn),
          onChanged: (value) => setState(() => _fanSpeed = value),
        ),
        const SizedBox(height: 16),
        // AC Control
        ClimateControlCard(
          title: 'Air Conditioning',
          icon: Icons.ac_unit,
          isActive: true,
          value: _acTemp,
          minValue: 16,
          maxValue: 30,
          unit: '°C',
          gradientColors: const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          onToggle: () {},
          onChanged: (value) => setState(() => _acTemp = value),
        ),
      ],
    );
  }
}

// ============================================================================
// ROOM CARD WIDGET
// ============================================================================
class RoomCard extends StatefulWidget {
  final String roomName;
  final RoomDevice device;
  final VoidCallback onToggle;
  final ValueChanged<double> onBrightnessChanged;

  const RoomCard({
    Key? key,
    required this.roomName,
    required this.device,
    required this.onToggle,
    required this.onBrightnessChanged,
  }) : super(key: key);

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color:
                widget.device.isOn
                    ? const Color(0xFF3B82F6).withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
            blurRadius: widget.device.isOn ? 20 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon with glow effect
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            widget.device.isOn
                                ? [Color(0xFF3B82F6), Color(0xFF9333EA)]
                                : [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow:
                          widget.device.isOn
                              ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(_glowAnimation.value),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                              : [],
                    ),
                    child: Icon(
                      widget.device.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.roomName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.device.isOn
                          ? '${(widget.device.brightness * 100).round()}% brightness • ${widget.device.temperature}°C'
                          : 'Off',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              // Toggle Switch
              GestureDetector(
                onTap: widget.onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient:
                        widget.device.isOn
                            ? const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                            )
                            : null,
                    color: widget.device.isOn ? null : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow:
                        widget.device.isOn
                            ? [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : [],
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    alignment:
                        widget.device.isOn
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      width: 26,
                      height: 26,
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Brightness Slider (shown when device is on)
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child:
                widget.device.isOn
                    ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.light_mode,
                              size: 20,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 6,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 20,
                                  ),
                                  activeTrackColor: const Color(0xFF3B82F6),
                                  inactiveTrackColor: const Color(0xFFE2E8F0),
                                  thumbColor: Colors.white,
                                  overlayColor: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(0.2),
                                ),
                                child: Slider(
                                  value: widget.device.brightness,
                                  onChanged: widget.onBrightnessChanged,
                                  min: 0.0,
                                  max: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(widget.device.brightness * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CLIMATE CONTROL CARD WIDGET
// ============================================================================
class ClimateControlCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final double value;
  final double minValue;
  final double maxValue;
  final String unit;
  final List<Color> gradientColors;
  final VoidCallback onToggle;
  final ValueChanged<double> onChanged;

  const ClimateControlCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.gradientColors,
    required this.onToggle,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ClimateControlCard> createState() => _ClimateControlCardState();
}

class _ClimateControlCardState extends State<ClimateControlCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    if (widget.isActive && widget.title == 'Fan') {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(ClimateControlCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive &&
        widget.title == 'Fan' &&
        !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (!widget.isActive && _rotationController.isAnimating) {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color:
                widget.isActive
                    ? widget.gradientColors[0].withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
            blurRadius: widget.isActive ? 20 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Animated Icon
              widget.title == 'Fan'
                  ? AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  widget.isActive
                                      ? widget.gradientColors
                                      : [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      );
                    },
                  )
                  : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            widget.isActive
                                ? widget.gradientColors
                                : [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 28),
                  ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.isActive ? 'Active' : 'Inactive',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              // Value Display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.gradientColors),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${widget.value.round()} ${widget.unit}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Control Slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: widget.gradientColors[0],
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: Colors.white,
              overlayColor: widget.gradientColors[0].withOpacity(0.2),
            ),
            child: Slider(
              value: widget.value,
              onChanged: widget.isActive ? widget.onChanged : null,
              min: widget.minValue,
              max: widget.maxValue,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================
class RoomDevice {
  bool isOn;
  double brightness;
  int temperature;
  IconData icon;

  RoomDevice({
    required this.isOn,
    required this.brightness,
    required this.temperature,
    required this.icon,
  });
}

class StatCard {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> colors;

  StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });
}
