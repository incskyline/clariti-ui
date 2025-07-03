import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import './custom_icon_widget.dart';

class StreakCounterWidget extends StatefulWidget {
  final int currentStreak;
  final int bestStreak;
  final bool isToday;
  final List<bool> weeklyActivity;
  final VoidCallback? onStreakTap;

  const StreakCounterWidget({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
    required this.isToday,
    required this.weeklyActivity,
    this.onStreakTap,
  });

  @override
  State<StreakCounterWidget> createState() => _StreakCounterWidgetState();
}

class _StreakCounterWidgetState extends State<StreakCounterWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _countController;
  late Animation<double> _pulseAnimation;
  late Animation<int> _countAnimation;

  int _displayedStreak = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _countController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _countAnimation = IntTween(
      begin: 0,
      end: widget.currentStreak,
    ).animate(CurvedAnimation(
      parent: _countController,
      curve: Curves.easeOut,
    ));

    _countController.addListener(() {
      setState(() {
        _displayedStreak = _countAnimation.value;
      });
    });

    _startAnimations();
  }

  @override
  void didUpdateWidget(StreakCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStreak > oldWidget.currentStreak) {
      _triggerStreakIncrease();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _startAnimations() {
    _countController.forward();
    if (widget.isToday && widget.currentStreak > 0) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _triggerStreakIncrease() {
    HapticFeedback.heavyImpact();
    _countController.reset();
    _countController.forward();
    _pulseController.reset();
    _pulseController.repeat(reverse: true);
  }

  Color _getStreakColor() {
    if (widget.currentStreak >= 30) return const Color(0xFFFF6B35);
    if (widget.currentStreak >= 14) return const Color(0xFF6B73FF);
    if (widget.currentStreak >= 7) return const Color(0xFF48BB78);
    if (widget.currentStreak >= 3) return const Color(0xFFFECA57);
    return Theme.of(context).colorScheme.outline;
  }

  String _getStreakMessage() {
    if (widget.currentStreak == 0) return 'Start your journey';
    if (widget.currentStreak == 1) return 'Great start!';
    if (widget.currentStreak < 7) return 'Building momentum';
    if (widget.currentStreak < 14) return 'On fire! 🔥';
    if (widget.currentStreak < 30) return 'Unstoppable! ⚡';
    return 'Legend! 🏆';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onStreakTap?.call();
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getStreakColor().withValues(alpha: 0.1),
              _getStreakColor().withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getStreakColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: widget.isToday ? _pulseAnimation.value : 1.0,
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: _getStreakColor(),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'local_fire_department',
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Streak',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _getStreakColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        _getStreakMessage(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _displayedStreak.toString(),
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: _getStreakColor(),
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    Text(
                      'days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStreakColor(),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This Week',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  'Best: ${widget.bestStreak} days',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final isActive = index < widget.weeklyActivity.length
                    ? widget.weeklyActivity[index]
                    : false;
                final isToday = index == DateTime.now().weekday - 1;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _getStreakColor()
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: isToday
                        ? Border.all(
                            color: _getStreakColor(),
                            width: 2,
                          )
                        : null,
                  ),
                  child: isActive
                      ? Center(
                          child: CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : null,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
