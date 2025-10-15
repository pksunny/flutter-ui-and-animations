import 'package:flutter/material.dart';
import 'dart:math' as math;

// Main Weather Screen with Adaptive Backgrounds
class AdaptiveWeatherUIScreen extends StatefulWidget {
  const AdaptiveWeatherUIScreen({Key? key}) : super(key: key);

  @override
  State<AdaptiveWeatherUIScreen> createState() => _AdaptiveWeatherUIScreenState();
}

class _AdaptiveWeatherUIScreenState extends State<AdaptiveWeatherUIScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgAnimController;
  late AnimationController _cardAnimController;
  WeatherType _currentWeather = WeatherType.sunny;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _cardAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    _cardAnimController.dispose();
    super.dispose();
  }

  void _changeWeather(WeatherType weather) {
    _cardAnimController.forward(from: 0.0);
    setState(() {
      _currentWeather = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Adaptive Background
          AnimatedWeatherBackground(
            weatherType: _currentWeather,
            animationController: _bgAnimController,
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adaptive Weather',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 8,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Watch the magic unfold',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),

                // Weather Info Cards
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Current Weather Card
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _cardAnimController,
                              curve: Curves.elasticOut,
                            ),
                          ),
                          child: WeatherCard(
                            weatherType: _currentWeather,
                            isActive: true,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Weather Type Selector
                        Text(
                          'Switch Weather',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: WeatherType.values.map((weather) {
                            return WeatherButton(
                              weatherType: weather,
                              isSelected: _currentWeather == weather,
                              onPressed: () => _changeWeather(weather),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 48),

                        // Additional Info Cards
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            InfoCard(
                              icon: Icons.water_drop_sharp,
                              title: 'Humidity',
                              value: '${math.Random().nextInt(40) + 50}%',
                              color: Colors.blueAccent,
                            ),
                            InfoCard(
                              icon: Icons.wind_power_rounded,
                              title: 'Wind Speed',
                              value: '${math.Random().nextInt(20) + 5} km/h',
                              color: Colors.cyan,
                            ),
                            InfoCard(
                              icon: Icons.visibility_rounded,
                              title: 'Visibility',
                              value: '${math.Random().nextInt(8) + 5} km',
                              color: Colors.teal,
                            ),
                            InfoCard(
                              icon: Icons.precision_manufacturing,
                              title: 'Pressure',
                              value: '${math.Random().nextInt(30) + 1010} mb',
                              color: Colors.indigo,
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Adaptive Weather Background Component
class AnimatedWeatherBackground extends StatelessWidget {
  final WeatherType weatherType;
  final AnimationController animationController;

  const AnimatedWeatherBackground({
    Key? key,
    required this.weatherType,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Stack(
        key: ValueKey<WeatherType>(weatherType),
        children: [
          // Base Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getGradientColors(weatherType),
              ),
            ),
          ),

          // Weather-specific animations
          if (weatherType == WeatherType.sunny)
            _SunnyWeather(controller: animationController)
          else if (weatherType == WeatherType.rainy)
            _RainyWeather(controller: animationController)
          else if (weatherType == WeatherType.snowy)
            _SnowyWeather(controller: animationController)
          else if (weatherType == WeatherType.cloudy)
            _CloudyWeather(controller: animationController)
          else
            _ThunderstormWeather(controller: animationController),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return [
          const Color(0xFF1E90FF),
          const Color(0xFF87CEEB),
          const Color(0xFFFFD700),
        ];
      case WeatherType.rainy:
        return [
          const Color(0xFF2C3E50),
          const Color(0xFF34495E),
          const Color(0xFF445566),
        ];
      case WeatherType.snowy:
        return [
          const Color(0xFF87CEEB),
          const Color(0xFFE0FFFF),
          const Color(0xFFB0E0E6),
        ];
      case WeatherType.cloudy:
        return [
          const Color(0xFF708090),
          const Color(0xFF778899),
          const Color(0xFF696969),
        ];
      case WeatherType.thunderstorm:
        return [
          const Color(0xFF1A1A2E),
          const Color(0xFF16213E),
          const Color(0xFF0F3460),
        ];
    }
  }
}

// Sunny Weather Animation
class _SunnyWeather extends StatelessWidget {
  final AnimationController controller;

  const _SunnyWeather({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated Sun
        Positioned(
          top: 60,
          right: 40,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: controller.value * 2 * math.pi,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Floating clouds
        Positioned(
          top: 200,
          left: 30,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.sin(controller.value * 2 * math.pi) * 20,
                  0,
                ),
                child: FloatingCloud(opacity: 0.3),
              );
            },
          ),
        ),

        Positioned(
          top: 300,
          right: 50,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  -math.sin(controller.value * 2 * math.pi) * 25,
                  0,
                ),
                child: FloatingCloud(opacity: 0.2),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Rainy Weather Animation
class _RainyWeather extends StatelessWidget {
  final AnimationController controller;

  const _RainyWeather({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Rain drops
        ...List.generate(50, (index) {
          final random = math.Random(index);
          final delay = random.nextDouble() * 0.5;
          final horizontalOffset = random.nextDouble() * 400 - 200;

          return Positioned(
            left: 200 + horizontalOffset,
            top: -10,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final animValue =
                    (controller.value + delay) % 1.0;
                return Transform.translate(
                  offset: Offset(
                    horizontalOffset * 0.1,
                    animValue * MediaQuery.of(context).size.height + 10,
                  ),
                  child: const Raindrop(),
                );
              },
            ),
          );
        }),

        // Dark clouds
        Positioned(
          top: 100,
          left: 20,
          child: CloudShape(
            opacity: 0.7,
            size: 150,
          ),
        ),

        Positioned(
          top: 80,
          right: 30,
          child: CloudShape(
            opacity: 0.6,
            size: 130,
          ),
        ),
      ],
    );
  }
}

// Snowy Weather Animation
class _SnowyWeather extends StatelessWidget {
  final AnimationController controller;

  const _SnowyWeather({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Snowflakes
        ...List.generate(40, (index) {
          final random = math.Random(index);
          final delay = random.nextDouble() * 0.7;
          final horizontalOffset = random.nextDouble() * 400 - 200;

          return Positioned(
            left: 200 + horizontalOffset,
            top: -30,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final animValue = (controller.value + delay) % 1.0;
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(
                      horizontalOffset * 0.2 *
                          math.sin(animValue * 2 * math.pi),
                      animValue * MediaQuery.of(context).size.height + 30,
                    )
                    ..rotateZ(animValue * 4 * math.pi),
                  child: Snowflake(
                    size: 8 + random.nextDouble() * 12,
                  ),
                );
              },
            ),
          );
        }),

        // Soft clouds
        Positioned(
          top: 80,
          left: 10,
          child: CloudShape(opacity: 0.5, size: 160),
        ),
      ],
    );
  }
}

// Cloudy Weather Animation
class _CloudyWeather extends StatelessWidget {
  final AnimationController controller;

  const _CloudyWeather({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Moving clouds
        Positioned(
          top: 120,
          left: 0,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  (controller.value * 600) % 600 - 300,
                  0,
                ),
                child: CloudShape(opacity: 0.6, size: 180),
              );
            },
          ),
        ),

        Positioned(
          top: 250,
          right: 0,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  -((controller.value * 500) % 500 - 250),
                  0,
                ),
                child: CloudShape(opacity: 0.5, size: 160),
              );
            },
          ),
        ),

        Positioned(
          top: 400,
          left: 50,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  (controller.value * 400) % 400 - 200,
                  0,
                ),
                child: CloudShape(opacity: 0.4, size: 140),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Thunderstorm Weather Animation
class _ThunderstormWeather extends StatelessWidget {
  final AnimationController controller;

  const _ThunderstormWeather({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lightning flashes
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final flashIntensity =
                (math.sin(controller.value * 12 * math.pi) + 1) / 2;
            return Container(
              color: Colors.white.withOpacity(flashIntensity * 0.3),
            );
          },
        ),

        // Rain drops during storm
        ...List.generate(80, (index) {
          final random = math.Random(index);
          final delay = random.nextDouble() * 0.3;
          final horizontalOffset = random.nextDouble() * 400 - 200;

          return Positioned(
            left: 200 + horizontalOffset,
            top: -10,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final animValue = (controller.value + delay) % 1.0;
                return Transform.translate(
                  offset: Offset(
                    horizontalOffset * 0.15,
                    animValue * MediaQuery.of(context).size.height + 10,
                  ),
                  child: const Raindrop(intensity: 1.5),
                );
              },
            ),
          );
        }),

        // Dark storm clouds
        Positioned(
          top: 100,
          left: -50,
          child: CloudShape(opacity: 0.85, size: 200),
        ),

        Positioned(
          top: 150,
          right: -30,
          child: CloudShape(opacity: 0.8, size: 180),
        ),
      ],
    );
  }
}

// Weather Card Component
class WeatherCard extends StatelessWidget {
  final WeatherType weatherType;
  final bool isActive;

  const WeatherCard({
    Key? key,
    required this.weatherType,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weatherType.label,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherType.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              _getWeatherIcon(weatherType),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TemperatureDisplay(temp: '24°C'),
              _TemperatureDisplay(
                temp: 'Feels\n22°C',
                isSmall: true,
              ),
              _TemperatureDisplay(
                temp: 'Max\n28°C',
                isSmall: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getWeatherIcon(WeatherType type) {
    const iconSize = 80.0;
    const iconColor = Colors.white;

    switch (type) {
      case WeatherType.sunny:
        return const Icon(Icons.wb_sunny_rounded,
            size: iconSize, color: iconColor);
      case WeatherType.rainy:
        return const Icon(Icons.cloud_queue_rounded,
            size: iconSize, color: iconColor);
      case WeatherType.snowy:
        return const Icon(Icons.cloud_outlined,
            size: iconSize, color: iconColor);
      case WeatherType.cloudy:
        return const Icon(Icons.wb_cloudy_rounded,
            size: iconSize, color: iconColor);
      case WeatherType.thunderstorm:
        return const Icon(Icons.flash_on_rounded,
            size: iconSize, color: iconColor);
    }
  }
}

// Temperature Display Widget
class _TemperatureDisplay extends StatelessWidget {
  final String temp;
  final bool isSmall;

  const _TemperatureDisplay({
    Key? key,
    required this.temp,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Text(
            temp,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 12 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Weather Type Button
class WeatherButton extends StatefulWidget {
  final WeatherType weatherType;
  final bool isSelected;
  final VoidCallback onPressed;

  const WeatherButton({
    Key? key,
    required this.weatherType,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<WeatherButton> createState() => _WeatherButtonState();
}

class _WeatherButtonState extends State<WeatherButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(WeatherButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.1),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isSelected
                      ? [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)]
                      : [Colors.white.withOpacity(0.1), Colors.transparent],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(
                    widget.isSelected ? 0.6 : 0.2,
                  ),
                  width: 2,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.weatherType.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.weatherType.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.5,
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
}

// Info Card Component
class InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.color.withOpacity(0.3),
              widget.color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Weather Elements
class FloatingCloud extends StatelessWidget {
  final double opacity;

  const FloatingCloud({Key? key, this.opacity = 0.3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(opacity * 0.5),
            blurRadius: 15,
          ),
        ],
      ),
    );
  }
}

class CloudShape extends StatelessWidget {
  final double opacity;
  final double size;

  const CloudShape({
    Key? key,
    this.opacity = 0.5,
    this.size = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(opacity * 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
    );
  }
}

class Raindrop extends StatelessWidget {
  final double intensity;

  const Raindrop({Key? key, this.intensity = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3 * intensity,
      height: 15 * intensity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 3,
          ),
        ],
      ),
    );
  }
}

class Snowflake extends StatelessWidget {
  final double size;

  const Snowflake({Key? key, this.size = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

// Weather Type Enum with Extensions
enum WeatherType {
  sunny,
  rainy,
  snowy,
  cloudy,
  thunderstorm,
}

/// Extension on WeatherType to provide labels, descriptions, and icons
extension WeatherTypeExtension on WeatherType {
  /// Display label for the weather type
  String get label {
    switch (this) {
      case WeatherType.sunny:
        return 'Sunny';
      case WeatherType.rainy:
        return 'Rainy';
      case WeatherType.snowy:
        return 'Snowy';
      case WeatherType.cloudy:
        return 'Cloudy';
      case WeatherType.thunderstorm:
        return 'Thunderstorm';
    }
  }

  /// Description for the weather type
  String get description {
    switch (this) {
      case WeatherType.sunny:
        return 'Beautiful clear skies';
      case WeatherType.rainy:
        return 'Rain is falling';
      case WeatherType.snowy:
        return 'Snowflakes are dancing';
      case WeatherType.cloudy:
        return 'Overcast with clouds';
      case WeatherType.thunderstorm:
        return 'Intense storm incoming';
    }
  }

  /// Emoji icon for the weather type
  String get icon {
    switch (this) {
      case WeatherType.sunny:
        return '☀️';
      case WeatherType.rainy:
        return '🌧️';
      case WeatherType.snowy:
        return '❄️';
      case WeatherType.cloudy:
        return '☁️';
      case WeatherType.thunderstorm:
        return '⚡';
    }
  }
}