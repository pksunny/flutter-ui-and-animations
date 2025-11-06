// import 'package:flutter/material.dart';

// class TooltipScreen extends StatefulWidget {
//   @override
//   _TooltipScreenState createState() => _TooltipScreenState();
// }

// class _TooltipScreenState extends State<TooltipScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _backgroundController;
//   late Animation<double> _backgroundAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _backgroundController = AnimationController(
//       duration: Duration(seconds: 3),
//       vsync: this,
//     );
//     _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
//     );
//     _backgroundController.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _backgroundController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: _backgroundAnimation,
//         builder: (context, child) {
//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color.lerp(Color(0xFFE6E6E6), Color(0xFFF0F0F0), _backgroundAnimation.value)!,
//                   Color.lerp(Color(0xFFF0F0F0), Color(0xFFE6E6E6), _backgroundAnimation.value)!,
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Tool Tip Social',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF666666),
//                         shadows: [
//                           Shadow(
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                             color: Colors.white.withOpacity(0.8),
//                           ),
//                           Shadow(
//                             offset: Offset(-2, -2),
//                             blurRadius: 4,
//                             color: Colors.black.withOpacity(0.1),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 60),
//                     SocialMediaGrid(),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class SocialMediaGrid extends StatefulWidget {
//   @override
//   _SocialMediaGridState createState() => _SocialMediaGridState();
// }

// class _SocialMediaGridState extends State<SocialMediaGrid> {
//   int? expandedIndex;
  
//   final List<SocialMediaData> socialMediaList = [
//     SocialMediaData(
//       icon: FontAwesomeIcons.facebook,
//       name: 'Facebook',
//       color: Color(0xFF1877F2),
//       gradient: [Color(0xFF1877F2), Color(0xFF42A5F5)],
//     ),
//     SocialMediaData(
//       icon: FontAwesomeIcons.twitter,
//       name: 'Twitter',
//       color: Color(0xFF1DA1F2),
//       gradient: [Color(0xFF1DA1F2), Color(0xFF42C5F5)],
//     ),
//     SocialMediaData(
//       icon: FontAwesomeIcons.instagram,
//       name: 'Instagram',
//       color: Color(0xFFE4405F),
//       gradient: [Color(0xFFE4405F), Color(0xFFFD1D1D), Color(0xFFFFDC80)],
//     ),
//     SocialMediaData(
//       icon: FontAwesomeIcons.youtube,
//       name: 'YouTube',
//       color: Color(0xFFFF0000),
//       gradient: [Color(0xFFFF0000), Color(0xFFFF4444)],
//     ),
//     SocialMediaData(
//       icon: FontAwesomeIcons.linkedin,
//       name: 'LinkedIn',
//       color: Color(0xFF0A66C2),
//       gradient: [Color(0xFF0A66C2), Color(0xFF3D8BFF)],
//     ),
//     SocialMediaData(
//       icon: FontAwesomeIcons.tiktok,
//       name: 'TikTok',
//       color: Color(0xFF000000),
//       gradient: [Color(0xFF000000), Color(0xFF333333)],
//     ),
//   ];

//   void onIconExpanded(int index, bool isExpanded) {
//     setState(() {
//       expandedIndex = isExpanded ? index : null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 300,
//       height: 300,
//       child: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 20,
//         ),
//         itemCount: socialMediaList.length,
//         itemBuilder: (context, index) {
//           return NeuomorphicSocialButton(
//             data: socialMediaList[index],
//             index: index,
//             isExpanded: expandedIndex == index,
//             shouldShrink: expandedIndex != null && expandedIndex != index,
//             onExpansionChanged: onIconExpanded,
//           );
//         },
//       ),
//     );
//   }
// }

// class NeuomorphicSocialButton extends StatefulWidget {
//   final SocialMediaData data;
//   final int index;
//   final bool isExpanded;
//   final bool shouldShrink;
//   final Function(int, bool) onExpansionChanged;

//   const NeuomorphicSocialButton({
//     Key? key, 
//     required this.data,
//     required this.index,
//     required this.isExpanded,
//     required this.shouldShrink,
//     required this.onExpansionChanged,
//   }) : super(key: key);

//   @override
//   _NeuomorphicSocialButtonState createState() => _NeuomorphicSocialButtonState();
// }

// class _NeuomorphicSocialButtonState extends State<NeuomorphicSocialButton>
//     with TickerProviderStateMixin {
//   late AnimationController _pressController;
//   late AnimationController _expandController;
//   late AnimationController _tooltipController;
//   late AnimationController _hoverController;
//   late AnimationController _shrinkController;

//   late Animation<double> _pressAnimation;
//   late Animation<double> _expandAnimation;
//   late Animation<double> _tooltipAnimation;
//   late Animation<double> _hoverAnimation;
//   late Animation<double> _shrinkAnimation;
//   late Animation<Offset> _tooltipSlideAnimation;

//   bool _isPressed = false;
//   bool _showTooltip = false;

//   @override
//   void initState() {
//     super.initState();
    
//     _pressController = AnimationController(
//       duration: Duration(milliseconds: 150),
//       vsync: this,
//     );
    
//     _expandController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _tooltipController = AnimationController(
//       duration: Duration(milliseconds: 600),
//       vsync: this,
//     );
    
//     _hoverController = AnimationController(
//       duration: Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _shrinkController = AnimationController(
//       duration: Duration(milliseconds: 400),
//       vsync: this,
//     );

//     _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
//       CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
//     );
    
//     _expandAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
//       CurvedAnimation(parent: _expandController, curve: Curves.elasticOut),
//     );
    
//     _tooltipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _tooltipController, curve: Curves.elasticOut),
//     );
    
//     _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
//     );

//     _shrinkAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
//       CurvedAnimation(parent: _shrinkController, curve: Curves.easeInOut),
//     );

//     _tooltipSlideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.5),
//       end: Offset(0, 0),
//     ).animate(CurvedAnimation(parent: _tooltipController, curve: Curves.elasticOut));
//   }

//   @override
//   void didUpdateWidget(NeuomorphicSocialButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
    
//     if (widget.isExpanded && !oldWidget.isExpanded) {
//       _expandController.forward();
//     } else if (!widget.isExpanded && oldWidget.isExpanded) {
//       _expandController.reverse();
//     }
    
//     if (widget.shouldShrink && !oldWidget.shouldShrink) {
//       _shrinkController.forward();
//     } else if (!widget.shouldShrink && oldWidget.shouldShrink) {
//       _shrinkController.reverse();
//     }
//   }

//   @override
//   void dispose() {
//     _pressController.dispose();
//     _expandController.dispose();
//     _tooltipController.dispose();
//     _hoverController.dispose();
//     _shrinkController.dispose();
//     super.dispose();
//   }

//   void _onLongPressStart() {
//     setState(() {
//       _showTooltip = true;
//     });
//     _tooltipController.forward();
//     _hoverController.forward();
//   }

//   void _onLongPressEnd() {
//     _tooltipController.reverse();
//     _hoverController.reverse();
//     Future.delayed(Duration(milliseconds: 300), () {
//       if (mounted) {
//         setState(() {
//           _showTooltip = false;
//         });
//       }
//     });
//   }

//   void _onTap() {
//     widget.onExpansionChanged(widget.index, !widget.isExpanded);
//   }

//   void _onTapDown(TapDownDetails details) {
//     setState(() {
//       _isPressed = true;
//     });
//     _pressController.forward();
//   }

//   void _onTapUp(TapUpDetails details) {
//     setState(() {
//       _isPressed = false;
//     });
//     _pressController.reverse();
//   }

//   void _onTapCancel() {
//     setState(() {
//       _isPressed = false;
//     });
//     _pressController.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.center,
//       children: [
//         // Tooltip
//         if (_showTooltip)
//           Positioned(
//             top: -40,
//             child: SlideTransition(
//               position: _tooltipSlideAnimation,
//               child: ScaleTransition(
//                 scale: _tooltipAnimation,
//                 child: AnimatedTooltip(
//                   text: widget.data.name,
//                   color: widget.data.color,
//                 ),
//               ),
//             ),
//           ),
        
//         // Main Button
//         GestureDetector(
//           onTap: _onTap,
//           onTapDown: _onTapDown,
//           onTapUp: _onTapUp,
//           onTapCancel: _onTapCancel,
//           onLongPressStart: (_) => _onLongPressStart(),
//           onLongPressEnd: (_) => _onLongPressEnd(),
//           child: AnimatedBuilder(
//             animation: Listenable.merge([
//               _pressAnimation,
//               _expandAnimation,
//               _hoverAnimation,
//               _shrinkAnimation,
//             ]),
//             builder: (context, child) {
//               double finalScale = _pressAnimation.value * 
//                                 _expandAnimation.value * 
//                                 _shrinkAnimation.value;
//               return Transform.scale(
//                 scale: finalScale,
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFFFFFFFF).withOpacity(0.9),
//                         Color(0xFFE0E0E0).withOpacity(0.9),
//                       ],
//                     ),
//                     boxShadow: [
//                       // Outer shadow (dark)
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.15 + (_hoverAnimation.value * 0.1)),
//                         offset: Offset(8, 8),
//                         blurRadius: 16 + (_hoverAnimation.value * 8),
//                         spreadRadius: -2,
//                       ),
//                       // Inner shadow (light)
//                       BoxShadow(
//                         color: Colors.white.withOpacity(0.9),
//                         offset: Offset(-8, -8),
//                         blurRadius: 16 + (_hoverAnimation.value * 8),
//                         spreadRadius: -2,
//                       ),
//                     ],
//                   ),
//                   child: Container(
//                     margin: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: widget.data.gradient,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: widget.data.color.withOpacity(0.3),
//                           blurRadius: 8,
//                           spreadRadius: 0,
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(40),
//                       child: Center(
//                         child: FaIcon(
//                           widget.data.icon,
//                           size: 32 + (_hoverAnimation.value * 8),
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AnimatedTooltip extends StatelessWidget {
//   final String text;
//   final Color color;

//   const AnimatedTooltip({
//     Key? key,
//     required this.text,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             color.withOpacity(0.9),
//             color.withOpacity(0.7),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//           BoxShadow(
//             color: Colors.white.withOpacity(0.1),
//             blurRadius: 1,
//             offset: Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.star,
//             size: 16,
//             color: Colors.white.withOpacity(0.9),
//           ),
//           SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               shadows: [
//                 Shadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 2,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SocialMediaData {
//   final IconData icon;
//   final String name;
//   final Color color;
//   final List<Color> gradient;

//   SocialMediaData({
//     required this.icon,
//     required this.name,
//     required this.color,
//     required this.gradient,
//   });
// }