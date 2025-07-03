import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final int decisionsMade;
  final int clarityGained;
  final int communityInteractions;

  const QuickStatsWidget({
    super.key,
    required this.decisionsMade,
    required this.clarityGained,
    required this.communityInteractions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: 'psychology',
              value: decisionsMade.toString(),
              label: 'Decisions',
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color: AppTheme.dividerLight,
          ),
          Expanded(
            child: _buildStatItem(
              icon: 'lightbulb',
              value: "$clarityGained%",
              label: 'Clarity',
              color: AppTheme.success,
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color: AppTheme.dividerLight,
          ),
          Expanded(
            child: _buildStatItem(
              icon: 'people',
              value: communityInteractions.toString(),
              label: 'Community',
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
