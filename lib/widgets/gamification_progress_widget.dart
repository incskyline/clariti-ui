import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';

class GamificationProgressWidget extends StatefulWidget {
  final int currentLevel;
  final int currentXP;
  final int xpToNextLevel;
  final int decisionsCount;
  final int clarityPoints;
  final bool showAnimation;

  const GamificationProgressWidget({
    super.key,
    required this.currentLevel,
    required this.currentXP,
    required this.xpToNextLevel,
    required this.decisionsCount,
    required this.clarityPoints,
    this.showAnimation = true,
  });

  @override
  State<GamificationProgressWidget> createState() =>
      _GamificationProgressWidgetState();
}

class _GamificationProgressWidgetState extends State<GamificationProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _levelUpController;
  late Animation<double> _progressAnimation;
  late Animation<double> _levelUpAnimation;
  late Animation<double> _bounceAnimation;

  bool _hasLeveledUp = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _levelUpController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentXP / widget.xpToNextLevel,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _levelUpAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _levelUpController,
      curve: Curves.elasticOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _levelUpController,
      curve: Curves.elasticOut,
    ));

    if (widget.showAnimation) {
      _progressController.forward();
    }
  }

  @override
  void didUpdateWidget(GamificationProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLevel > oldWidget.currentLevel) {
      _triggerLevelUp();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _levelUpController.dispose();
    super.dispose();
  }

  void _triggerLevelUp() {
    setState(() {
      _hasLeveledUp = true;
    });
    _levelUpController.forward();
    HapticFeedback.heavyImpact();

    // Reset animation after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _hasLeveledUp = false;
        });
        _levelUpController.reset();
      }
    });
  }

  String _getLevelTitle(int level) {
    if (level < 5) return 'Clarity Seeker';
    if (level < 10) return 'Decision Maker';
    if (level < 20) return 'Wisdom Explorer';
    if (level < 35) return 'Insight Master';
    return 'Clarity Guru';
  }

  String _getNextMilestone(int level) {
    if (level < 5) return 'Next: Decision Maker';
    if (level < 10) return 'Next: Wisdom Explorer';
    if (level < 20) return 'Next: Insight Master';
    if (level < 35) return 'Next: Clarity Guru';
    return 'Max Level Reached!';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _hasLeveledUp ? _bounceAnimation.value : 1.0,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Level ${widget.currentLevel}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            if (_hasLeveledUp) ...[
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'celebration',
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _getLevelTitle(widget.currentLevel),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
              CustomIconWidget(
                iconName: 'emoji_events',
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Progress to next level',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          SizedBox(height: 1.h),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: widget.showAnimation
                          ? _progressAnimation.value
                          : widget.currentXP / widget.xpToNextLevel,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.currentXP} / ${widget.xpToNextLevel} XP',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                      Text(
                        _getNextMilestone(widget.currentLevel),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                icon: 'psychology',
                label: 'Decisions',
                value: widget.decisionsCount.toString(),
              ),
              _buildStatCard(
                icon: 'star',
                label: 'Clarity Points',
                value: widget.clarityPoints.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
