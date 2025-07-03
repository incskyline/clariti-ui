import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentDecisionCardWidget extends StatefulWidget {
  final Map<String, dynamic> decision;
  final Function(int, String) onSwipe;
  final VoidCallback onTap;

  const RecentDecisionCardWidget({
    super.key,
    required this.decision,
    required this.onSwipe,
    required this.onTap,
  });

  @override
  State<RecentDecisionCardWidget> createState() =>
      _RecentDecisionCardWidgetState();
}

class _RecentDecisionCardWidgetState extends State<RecentDecisionCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSwipeActionsVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-0.3, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSwipeActions() {
    if (_isSwipeActionsVisible) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isSwipeActionsVisible = !_isSwipeActionsVisible;
    });
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  Color _getEmotionColor() {
    final colorString = widget.decision["emotionColor"] as String;
    return Color(int.parse(colorString));
  }

  @override
  Widget build(BuildContext context) {
    final decision = widget.decision;
    final isCompleted = decision["isCompleted"] as bool;
    final clarity = decision["clarity"] as int;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Stack(
        children: [
          // Swipe actions background
          if (_isSwipeActionsVisible)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildSwipeAction(
                      icon: 'share',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      onTap: () => widget.onSwipe(decision["id"], 'share'),
                    ),
                    _buildSwipeAction(
                      icon: 'favorite',
                      color: AppTheme.warning,
                      onTap: () => widget.onSwipe(decision["id"], 'favorite'),
                    ),
                    _buildSwipeAction(
                      icon: 'delete',
                      color: AppTheme.error,
                      onTap: () => widget.onSwipe(decision["id"], 'delete'),
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              ),
            ),
          // Main card
          SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onTap: widget.onTap,
              onLongPress: _toggleSwipeActions,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < -500) {
                  _toggleSwipeActions();
                }
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _getEmotionColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: decision["emotionIcon"],
                                color: _getEmotionColor(),
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                decision["emotion"],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: _getEmotionColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Text(
                          _getTimeAgo(decision["createdAt"]),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      decision["question"],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.success.withValues(alpha: 0.1)
                                : AppTheme.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName:
                                    isCompleted ? 'check_circle' : 'schedule',
                                color: isCompleted
                                    ? AppTheme.success
                                    : AppTheme.warning,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                isCompleted ? "Completed" : "In Progress",
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: isCompleted
                                      ? AppTheme.success
                                      : AppTheme.warning,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isCompleted) ...[
                          Spacer(),
                          Text(
                            "Clarity: $clarity%",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeAction({
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 12.w,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}
