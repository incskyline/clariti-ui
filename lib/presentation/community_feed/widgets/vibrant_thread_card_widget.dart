import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/engagement_animation_widget.dart';

class VibrantThreadCardWidget extends StatefulWidget {
  final Map<String, dynamic> thread;
  final VoidCallback onTap;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const VibrantThreadCardWidget({
    super.key,
    required this.thread,
    required this.onTap,
    required this.onUpvote,
    required this.onDownvote,
    required this.onSave,
    required this.onShare,
  });

  @override
  State<VibrantThreadCardWidget> createState() =>
      _VibrantThreadCardWidgetState();
}

class _VibrantThreadCardWidgetState extends State<VibrantThreadCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
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

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious':
        return const Color(0xFFED8936);
      case 'curious':
        return const Color(0xFF6B73FF);
      case 'hopeful':
        return const Color(0xFF48BB78);
      case 'overwhelmed':
        return const Color(0xFFE53E3E);
      case 'confident':
        return const Color(0xFF9B59B6);
      default:
        return AppTheme.primaryLight;
    }
  }

  List<Color> _getEmotionGradient(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious':
        return [const Color(0xFFED8936), const Color(0xFFFF6B35)];
      case 'curious':
        return [const Color(0xFF6B73FF), const Color(0xFF553C9A)];
      case 'hopeful':
        return [const Color(0xFF48BB78), const Color(0xFF38A169)];
      case 'overwhelmed':
        return [const Color(0xFFE53E3E), const Color(0xFFC53030)];
      case 'confident':
        return [const Color(0xFF9B59B6), const Color(0xFF8E44AD)];
      default:
        return [AppTheme.primaryLight, AppTheme.secondary];
    }
  }

  int _calculateClarityScore() {
    final upvotes = widget.thread['upvotes'] as int? ?? 0;
    final downvotes = widget.thread['downvotes'] as int? ?? 0;
    final total = upvotes + downvotes;
    if (total == 0) return 0;
    return ((upvotes / total) * 100).round();
  }

  bool _isHotThread() {
    final upvotes = widget.thread['upvotes'] as int? ?? 0;
    final comments = widget.thread['comments'] as int? ?? 0;
    final timeAgo = widget.thread['timeAgo'] as String? ?? '';

    // Consider hot if high engagement and recent
    return upvotes > 50 && comments > 20 && timeAgo.contains('h');
  }

  @override
  Widget build(BuildContext context) {
    final emotion = widget.thread['emotion'] as String? ?? 'curious';
    final emotionColor = _getEmotionColor(emotion);
    final emotionGradient = _getEmotionGradient(emotion);
    final isHot = _isHotThread();
    final clarityScore = _calculateClarityScore();
    final isAnonymous = (widget.thread['author'] as String?) == 'Anonymous';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: EngagementAnimationWidget(
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: emotionColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        emotionGradient[0].withValues(alpha: 0.1),
                        emotionGradient[1].withValues(alpha: 0.05),
                        Theme.of(context).colorScheme.surface,
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: emotionColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with emotion tag and hot indicator
                        Container(
                          padding: EdgeInsets.all(4.w),
                          child: Row(
                            children: [
                              // Emotion tag
                              AnimatedBuilder(
                                animation: _glowAnimation,
                                builder: (context, child) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 1.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: emotionGradient,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: emotionColor.withValues(
                                              alpha: _glowAnimation.value),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          emotion,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              // HOT tag
                              if (isHot)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF6B35),
                                        Color(0xFFE53E3E)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        'HOT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Profile and user info
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            children: [
                              // Profile circle with emotion glow
                              Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isAnonymous
                                      ? LinearGradient(colors: emotionGradient)
                                      : null,
                                  color:
                                      isAnonymous ? null : Colors.grey.shade300,
                                  boxShadow: isAnonymous
                                      ? [
                                          BoxShadow(
                                            color: emotionColor.withValues(
                                                alpha: 0.4),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: isAnonymous
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : CustomImageWidget(
                                          imageUrl:
                                              widget.thread['avatar'] ?? '',
                                          width: 12.w,
                                          height: 12.w,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.thread['author'] ?? 'Anonymous',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      widget.thread['timeAgo'] ?? '1h ago',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Question content
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            widget.thread['question'] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (widget.thread['preview'] != null) ...[
                          SizedBox(height: 2.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              widget.thread['preview'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    height: 1.4,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],

                        SizedBox(height: 3.h),

                        // Stats row
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Helpful count
                              _buildStatItem(
                                Icons.thumb_up_outlined,
                                '${widget.thread['upvotes'] ?? 0}',
                                'Helpful',
                                emotionColor,
                              ),
                              // Comments count
                              _buildStatItem(
                                Icons.chat_bubble_outline,
                                '${widget.thread['comments'] ?? 0}',
                                'Comments',
                                emotionColor,
                              ),
                              // Clarity score
                              _buildStatItem(
                                Icons.insights_outlined,
                                '$clarityScore%',
                                'Clarity',
                                emotionColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10.sp,
              ),
        ),
      ],
    );
  }
}
