import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🚀 SMART PLANNER UI - Ultra-Stylish Flutter Widget
/// Beautiful animated timeline view of daily tasks
/// Light theme, production-ready, fully customizable

// 📱 MAIN HOME SCREEN
class SmartPlannerHome extends StatefulWidget {
  const SmartPlannerHome({Key? key}) : super(key: key);

  @override
  State<SmartPlannerHome> createState() => _SmartPlannerHomeState();
}

class _SmartPlannerHomeState extends State<SmartPlannerHome>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _statsController;
  late List<AnimationController> _taskControllers;
  late List<AnimationController> _progressControllers;

  final List<TaskModel> _tasks = [
    TaskModel(
      title: 'Morning Workout',
      time: '06:00 AM',
      duration: '45 min',
      progress: 1.0,
      isCompleted: true,
      category: 'Health',
      categoryColor: const Color(0xFF10B981),
      icon: Icons.fitness_center,
    ),
    TaskModel(
      title: 'Design Review Meeting',
      time: '10:00 AM',
      duration: '1 hr',
      progress: 0.75,
      isCompleted: false,
      category: 'Work',
      categoryColor: const Color(0xFF6366F1),
      icon: Icons.design_services,
    ),
    TaskModel(
      title: 'Lunch with Team',
      time: '01:00 PM',
      duration: '30 min',
      progress: 0.5,
      isCompleted: false,
      category: 'Social',
      categoryColor: const Color(0xFFF59E0B),
      icon: Icons.restaurant,
    ),
    TaskModel(
      title: 'Code Review Session',
      time: '03:00 PM',
      duration: '2 hrs',
      progress: 0.3,
      isCompleted: false,
      category: 'Work',
      categoryColor: const Color(0xFF8B5CF6),
      icon: Icons.code,
    ),
    TaskModel(
      title: 'Evening Meditation',
      time: '07:00 PM',
      duration: '20 min',
      progress: 0.0,
      isCompleted: false,
      category: 'Wellness',
      categoryColor: const Color(0xFF06B6D4),
      icon: Icons.self_improvement,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize all animation controllers
  void _initializeAnimations() {
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _taskControllers = List.generate(
      _tasks.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      ),
    );

    _progressControllers = List.generate(
      _tasks.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      ),
    );

    _startAnimations();
  }

  /// Start sequential animations with delays
  Future<void> _startAnimations() async {
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _statsController.forward();

    for (int i = 0; i < _taskControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      _taskControllers[i].forward();
      await Future.delayed(const Duration(milliseconds: 200));
      _progressControllers[i].animateTo(
        _tasks[i].progress,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _statsController.dispose();
    for (var controller in _taskControllers) {
      controller.dispose();
    }
    for (var controller in _progressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Animated Header
            SliverToBoxAdapter(
              child: AnimatedHeader(
                controller: _headerController,
              ),
            ),

            // Stats Cards
            SliverToBoxAdapter(
              child: AnimatedStats(
                controller: _statsController,
                totalTasks: _tasks.length,
                completedTasks: _tasks.where((t) => t.isCompleted).length,
              ),
            ),

            // Timeline Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Today\'s Timeline',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                ),
              ),
            ),

            // Task Timeline List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return AnimatedTaskCard(
                      task: _tasks[index],
                      cardController: _taskControllers[index],
                      progressController: _progressControllers[index],
                      isLast: index == _tasks.length - 1,
                      onTap: () => _onTaskTap(index),
                    );
                  },
                  childCount: _tasks.length,
                ),
              ),
            ),

            // Bottom Padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF6366F1),
        elevation: 8,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _onTaskTap(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _tasks[index].progress = _tasks[index].isCompleted ? 1.0 : 0.5;
      _progressControllers[index].animateTo(
        _tasks[index].progress,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    });
  }
}

// 🎨 ANIMATED HEADER WIDGET
class AnimatedHeader extends StatelessWidget {
  final AnimationController controller;

  const AnimatedHeader({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      )),
      child: FadeTransition(
        opacity: controller,
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '5 Tasks',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Good Morning,',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Let\'s plan your day! 🚀',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tuesday, November 18, 2025',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 📊 ANIMATED STATS WIDGET
class AnimatedStats extends StatelessWidget {
  final AnimationController controller;
  final int totalTasks;
  final int completedTasks;

  const AnimatedStats({
    Key? key,
    required this.controller,
    required this.totalTasks,
    required this.completedTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: controller,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF10B981),
                  title: 'Completed',
                  value: '$completedTasks',
                  delay: 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.pending_actions_rounded,
                  color: const Color(0xFFF59E0B),
                  title: 'Pending',
                  value: '${totalTasks - completedTasks}',
                  delay: 100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFF6366F1),
                  title: 'Progress',
                  value: '${((completedTasks / totalTasks) * 100).toInt()}%',
                  delay: 200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 📈 INDIVIDUAL STAT CARD
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final int delay;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ✨ ANIMATED TASK CARD
class AnimatedTaskCard extends StatelessWidget {
  final TaskModel task;
  final AnimationController cardController;
  final AnimationController progressController;
  final bool isLast;
  final VoidCallback onTap;

  const AnimatedTaskCard({
    Key? key,
    required this.task,
    required this.cardController,
    required this.progressController,
    required this.isLast,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: cardController,
        curve: Curves.elasticOut,
      )),
      child: FadeTransition(
        opacity: cardController,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Indicator
              Column(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted
                            ? task.categoryColor
                            : Colors.white,
                        border: Border.all(
                          color: task.categoryColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: task.categoryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 100,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            task.categoryColor.withOpacity(0.5),
                            task.categoryColor.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Task Card
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: task.categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                task.icon,
                                color: task.categoryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: const Color(0xFF64748B),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.time,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: task.categoryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          task.category,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: task.categoryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Progress Bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progress',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: progressController,
                                  builder: (context, child) {
                                    return Text(
                                      '${(progressController.value * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: task.categoryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AnimatedBuilder(
                                animation: progressController,
                                builder: (context, child) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: task.categoryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: progressController.value,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                task.categoryColor,
                                                task.categoryColor
                                                    .withOpacity(0.7),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: task.categoryColor
                                                    .withOpacity(0.4),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Duration Badge
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              task.duration,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 📝 TASK MODEL
class TaskModel {
  String title;
  String time;
  String duration;
  double progress;
  bool isCompleted;
  String category;
  Color categoryColor;
  IconData icon;

  TaskModel({
    required this.title,
    required this.time,
    required this.duration,
    required this.progress,
    required this.isCompleted,
    required this.category,
    required this.categoryColor,
    required this.icon,
  });
}