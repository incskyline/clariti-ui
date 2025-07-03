import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class OutcomeCardWidget extends StatelessWidget {
  final Map<String, dynamic> outcome;
  final bool isActive;

  const OutcomeCardWidget({
    super.key,
    required this.outcome,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(outcome["color"] as int);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin:
          EdgeInsets.symmetric(horizontal: isActive ? 2.w : 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? Border.all(color: color, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isActive
                ? color.withValues(alpha: 0.2)
                : Theme.of(context).shadowColor,
            blurRadius: isActive ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: outcome["icon"],
                    color: color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outcome["type"],
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        outcome["title"],
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  outcome["description"],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.0),
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
