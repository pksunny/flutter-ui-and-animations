import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;

class StylishImageFiltersScreen extends StatefulWidget {
  @override
  _StylishImageFiltersScreenState createState() =>
      _StylishImageFiltersScreenState();
}

class _StylishImageFiltersScreenState extends State<StylishImageFiltersScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _filterController;
  late AnimationController _buttonController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _filterAnimation;
  late Animation<double> _buttonAnimation;

  int selectedFilterIndex = 0;
  bool isProcessing = false;

  final List<FilterData> filters = [
    FilterData('Original', Icons.image, Colors.grey, FilterType.none),
    FilterData('Vintage', Icons.photo_filter, Colors.amber, FilterType.vintage),
    FilterData('Dramatic', Icons.contrast, Colors.red, FilterType.dramatic),
    FilterData('Cool', Icons.ac_unit, Colors.blue, FilterType.cool),
    FilterData('Warm', Icons.wb_sunny, Colors.orange, FilterType.warm),
    FilterData('Noir', Icons.gradient, Colors.white, FilterType.noir),
    FilterData('Neon', Icons.flash_on, Colors.purple, FilterType.neon),
    FilterData('Retro', Icons.radio, Colors.pink, FilterType.retro),
  ];

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _filterController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _filterAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _filterController, curve: Curves.elasticOut),
    );

    _buttonAnimation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _filterController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _selectFilter(int index) async {
    if (selectedFilterIndex == index) return;

    setState(() {
      isProcessing = true;
      selectedFilterIndex = index;
    });

    _filterController.reset();
    _filterController.forward();

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      isProcessing = false;
    });

    HapticFeedback.lightImpact();
  }

  void _onFilterTap(int index) {
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });
    _selectFilter(index);
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
                center: Alignment(
                  math.sin(_backgroundAnimation.value * 2 * math.pi) * 0.5,
                  math.cos(_backgroundAnimation.value * 2 * math.pi) * 0.5,
                ),
                radius: 1.5,
                colors: [
                  Color(0xFF2D1B69),
                  Color(0xFF11052C),
                  Color(0xFF0A0A0A),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(flex: 3, child: _buildImagePreview()),
                  Expanded(flex: 1, child: _buildFiltersList()),
                  _buildActionButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.3),
                  Colors.blue.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(Icons.photo_filter, color: Colors.white, size: 24),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amazing Filters',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground:
                        Paint()
                          ..shader = LinearGradient(
                            colors: [Colors.purple, Colors.blue, Colors.pink],
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                Text(
                  'Transform your photos',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return AnimatedBuilder(
      animation: _filterAnimation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: filters[selectedFilterIndex].color.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                // ...existing code...
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(
                    "https://cdn.pixabay.com/photo/2024/04/27/10/14/ai-generated-8723499_1280.jpg", // Using Pixabay for a sample image
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // ...existing code...
                // Filter overlay
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(color: _getFilterOverlay()),
                ),
                // Processing overlay
                if (isProcessing)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              filters[selectedFilterIndex].color,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Applying ${filters[selectedFilterIndex].name}...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Filter name overlay
                Positioned(
                  top: 20,
                  left: 20,
                  child: Transform.scale(
                    scale: _filterAnimation.value,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: filters[selectedFilterIndex].color.withOpacity(
                            0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        filters[selectedFilterIndex].name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFiltersList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFilterIndex == index;
          return AnimatedBuilder(
            animation: _buttonAnimation,
            builder: (context, child) {
              final scale = isSelected ? _buttonAnimation.value : 1.0;
              return Transform.scale(
                scale: scale,
                child: GestureDetector(
                  onTap: () => _onFilterTap(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(right: 15),
                    width: 80,
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  filters[index].color.withOpacity(0.8),
                                  filters[index].color.withOpacity(0.3),
                                ],
                              )
                              : LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected
                                ? filters[index].color
                                : Colors.white.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: filters[index].color.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          filters[index].icon,
                          color:
                              isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.7),
                          size: 28,
                        ),
                        SizedBox(height: 8),
                        Text(
                          filters[index].name,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Gallery',
              Icons.photo_library,
              Colors.blue,
              () => _showSnackBar('Gallery opened'),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: _buildActionButton(
              'Camera',
              Icons.camera_alt,
              Colors.green,
              () => _showSnackBar('Camera opened'),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: _buildActionButton(
              'Save',
              Icons.download,
              Colors.purple,
              () => _showSnackBar('Image saved!'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getFilterOverlay() {
    switch (filters[selectedFilterIndex].filterType) {
      case FilterType.vintage:
        return Colors.amber.withOpacity(0.2);
      case FilterType.dramatic:
        return Colors.black.withOpacity(0.3);
      case FilterType.cool:
        return Colors.blue.withOpacity(0.2);
      case FilterType.warm:
        return Colors.orange.withOpacity(0.2);
      case FilterType.noir:
        return Colors.grey.withOpacity(0.5);
      case FilterType.neon:
        return Colors.purple.withOpacity(0.3);
      case FilterType.retro:
        return Colors.pink.withOpacity(0.2);
      default:
        return null;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class FilterData {
  final String name;
  final IconData icon;
  final Color color;
  final FilterType filterType;

  FilterData(this.name, this.icon, this.color, this.filterType);
}

enum FilterType { none, vintage, dramatic, cool, warm, noir, neon, retro }
