import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrendingThreadCardWidget extends StatelessWidget {
  final Map<String, dynamic> thread;
  final VoidCallback onTap;

  const TrendingThreadCardWidget({
    super.key,
    required this.thread,
    required this.onTap,
  });

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious':
        return AppTheme.warning;
      case 'curious':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'confident':
        return AppTheme.success;
      case 'overwhelmed':
        return AppTheme.error;
      case 'hopeful':
        return AppTheme.success;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious':
        return 'psychology';
      case 'curious':
        return 'help';
      case 'confident':
        return 'thumb_up';
      case 'overwhelmed':
        return 'sentiment_stressed';
      case 'hopeful':
        return 'favorite';
      default:
        return 'psychology';
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotion = thread["emotion"] as String;
    final emotionColor = _getEmotionColor(emotion);
    final emotionIcon = _getEmotionIcon(emotion);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 4.w),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: emotionColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: emotionIcon,
                        color: emotionColor,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        emotion,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: emotionColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  thread["timeAgo"],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              thread["title"],
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: Text(
                thread["preview"],
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'thumb_up',
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      thread["upvotes"].toString(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 4.w),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'comment',
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      thread["comments"].toString(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
