import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎨 Main Wallet App - Ultra-Stylish FinTech UI
///
/// Features:
/// - Animated balance reveal with shimmer effect
/// - Flip animation for transaction cards
/// - Progress ring for spending limit
/// - Smooth micro-interactions
/// - Fully customizable and reusable
class MinimalWalletApp extends StatefulWidget {
  const MinimalWalletApp({Key? key}) : super(key: key);

  @override
  State<MinimalWalletApp> createState() => _MinimalWalletAppState();
}

class _MinimalWalletAppState extends State<MinimalWalletApp>
    with TickerProviderStateMixin {
  late AnimationController _balanceController;
  late AnimationController _shimmerController;
  late Animation<double> _balanceAnimation;
  bool _isBalanceVisible = false;

  @override
  void initState() {
    super.initState();

    // Balance reveal animation controller
    _balanceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _balanceAnimation = CurvedAnimation(
      parent: _balanceController,
      curve: Curves.easeOutCubic,
    );

    // Shimmer effect controller
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Auto-reveal balance on startup
    Future.delayed(const Duration(milliseconds: 500), () {
      _toggleBalance();
    });
  }

  void _toggleBalance() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
      if (_isBalanceVisible) {
        _balanceController.forward();
      } else {
        _balanceController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(child: _buildAppBar()),

            // Balance Card with Reveal Animation
            SliverToBoxAdapter(child: _buildBalanceCard()),

            // Spending Progress Ring
            SliverToBoxAdapter(child: _buildSpendingProgress()),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3436),
                        letterSpacing: -0.5,
                      ),
                    ),
                    _buildFilterChip(),
                  ],
                ),
              ),
            ),

            // Transaction Cards with Flip Animation
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return AnimatedTransactionCard(
                    transaction: _transactions[index],
                    delay: Duration(milliseconds: 100 * index),
                  );
                }, childCount: _transactions.length),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// App Bar with profile and notification icons
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Section
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF2D3436).withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3436),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Notification Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF2D3436),
                    size: 24,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B6B),
                      shape: BoxShape.circle,
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

  /// Balance Card with Animated Reveal
  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedBuilder(
        animation: _balanceAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D3436), Color(0xFF000000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleBalance,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Animated Balance Amount
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child:
                      _isBalanceVisible
                          ? ShaderMask(
                            key: const ValueKey('visible'),
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: const [Colors.white, Color(0xFFDFE6E9)],
                                stops: [
                                  _shimmerController.value - 0.3,
                                  _shimmerController.value,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                tileMode: TileMode.mirror,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              '\$24,582.50',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -2,
                                height: 1,
                              ),
                            ),
                          )
                          : Text(
                            '••••••',
                            key: const ValueKey('hidden'),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withOpacity(0.3),
                              letterSpacing: 8,
                              height: 1,
                            ),
                          ),
                ),

                const SizedBox(height: 24),

                // Stats Row
                Row(
                  children: [
                    _buildStatItem(
                      'Income',
                      '\$12,450',
                      Icons.arrow_downward,
                      const Color(0xFF00B894),
                    ),
                    const SizedBox(width: 32),
                    _buildStatItem(
                      'Expenses',
                      '\$8,320',
                      Icons.arrow_upward,
                      const Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Spending Progress Ring
  Widget _buildSpendingProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Progress Ring
            SizedBox(
              width: 80,
              height: 80,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 0.68),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return CustomPaint(
                    painter: ProgressRingPainter(
                      progress: value,
                      backgroundColor: const Color(0xFFF0F0F0),
                      progressColor: const Color(0xFF6C5CE7),
                      strokeWidth: 8,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(value * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3436),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Used',
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFF2D3436).withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 20),

            // Spending Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Spending',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2D3436).withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '\$6,800 / \$10,000',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3436),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5E5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '\$3,200 remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF6B6B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3436),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Text(
            'All',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sample transaction data
  final List<TransactionModel> _transactions = [
    TransactionModel(
      title: 'Starbucks Coffee',
      category: 'Food & Dining',
      amount: -12.50,
      date: 'Today, 2:30 PM',
      icon: Icons.coffee,
      color: const Color(0xFFFF6B6B),
    ),
    TransactionModel(
      title: 'Salary Deposit',
      category: 'Income',
      amount: 5420.00,
      date: 'Yesterday, 9:00 AM',
      icon: Icons.attach_money,
      color: const Color(0xFF00B894),
    ),
    TransactionModel(
      title: 'Netflix Subscription',
      category: 'Entertainment',
      amount: -15.99,
      date: 'Nov 15, 6:45 PM',
      icon: Icons.movie,
      color: const Color(0xFFE17055),
    ),
    TransactionModel(
      title: 'Uber Ride',
      category: 'Transportation',
      amount: -24.30,
      date: 'Nov 14, 8:20 PM',
      icon: Icons.local_taxi,
      color: const Color(0xFF6C5CE7),
    ),
    TransactionModel(
      title: 'Amazon Purchase',
      category: 'Shopping',
      amount: -89.99,
      date: 'Nov 13, 3:15 PM',
      icon: Icons.shopping_bag,
      color: const Color(0xFFFDCB6E),
    ),
  ];
}

/// 💳 Animated Transaction Card with Flip Effect
class AnimatedTransactionCard extends StatefulWidget {
  final TransactionModel transaction;
  final Duration delay;

  const AnimatedTransactionCard({
    Key? key,
    required this.transaction,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<AnimatedTransactionCard> createState() =>
      _AnimatedTransactionCardState();
}

class _AnimatedTransactionCardState extends State<AnimatedTransactionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    // Entrance animation
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _flipCard() {
    if (_showFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            final angle = _flipAnimation.value * math.pi;
            final transform =
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle);

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child:
                  angle >= math.pi / 2
                      ? Transform(
                        transform: Matrix4.identity()..rotateY(math.pi),
                        alignment: Alignment.center,
                        child: _buildCardBack(),
                      )
                      : _buildCardFront(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return GestureDetector(
      onTap: _flipCard,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.transaction.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                widget.transaction.icon,
                color: widget.transaction.color,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // Transaction Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3436),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.transaction.category,
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF2D3436).withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${widget.transaction.amount >= 0 ? '+' : ''}\$${widget.transaction.amount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color:
                        widget.transaction.amount >= 0
                            ? const Color(0xFF00B894)
                            : const Color(0xFF2D3436),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.transaction.date,
                  style: TextStyle(
                    fontSize: 11,
                    color: const Color(0xFF2D3436).withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return GestureDetector(
      onTap: _flipCard,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.transaction.color,
              widget.transaction.color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.transaction.color.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction ID',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '#TXN${widget.transaction.title.hashCode.abs().toString().substring(0, 8)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tap to flip back',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🎨 Custom Progress Ring Painter
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  ProgressRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [progressColor, progressColor.withOpacity(0.6)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 📊 Transaction Data Model
class TransactionModel {
  final String title;
  final String category;
  final double amount;
  final String date;
  final IconData icon;
  final Color color;

  TransactionModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });
}
