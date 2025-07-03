import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoteSectionWidget extends StatelessWidget {
  final int upvotes;
  final int downvotes;
  final int userVoteState;
  final Function(int) onVote;

  const VoteSectionWidget({
    super.key,
    required this.upvotes,
    required this.downvotes,
    required this.userVoteState,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final totalVotes = upvotes + downvotes;
    final upvotePercentage = totalVotes > 0 ? (upvotes / totalVotes) : 0.5;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Vote Progress Bar
          Container(
            height: 1.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).dividerColor,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: (upvotePercentage * 100).round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Expanded(
                  flex: ((1 - upvotePercentage) * 100).round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Vote Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onVote(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: userVoteState == 1
                          ? AppTheme.success.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: userVoteState == 1
                          ? Border.all(color: AppTheme.success, width: 1)
                          : null,
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'thumb_up',
                          color: userVoteState == 1
                              ? AppTheme.success
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          upvotes.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: userVoteState == 1
                                    ? AppTheme.success
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Helpful',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: userVoteState == 1
                                        ? AppTheme.success
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onVote(-1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: userVoteState == -1
                          ? AppTheme.error.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: userVoteState == -1
                          ? Border.all(color: AppTheme.error, width: 1)
                          : null,
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'thumb_down',
                          color: userVoteState == -1
                              ? AppTheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          downvotes.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: userVoteState == -1
                                    ? AppTheme.error
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Not Helpful',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: userVoteState == -1
                                        ? AppTheme.error
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Vote Summary
          Text(
            '${(upvotePercentage * 100).round()}% found this helpful',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
