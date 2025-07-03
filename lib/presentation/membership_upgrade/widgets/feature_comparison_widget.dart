import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeatureComparisonWidget extends StatelessWidget {
  final List<Map<String, dynamic>> membershipTiers;

  const FeatureComparisonWidget({
    super.key,
    required this.membershipTiers,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> comparisonFeatures = [
      {
        "feature": "What If scenarios per day",
        "free": "3",
        "plus": "Unlimited",
        "pro": "Unlimited"
      },
      {
        "feature": "Emotion tracking",
        "free": "Basic",
        "plus": "Advanced",
        "pro": "Advanced + Custom"
      },
      {
        "feature": "Community access",
        "free": "✓",
        "plus": "✓ Priority",
        "pro": "✓ VIP"
      },
      {
        "feature": "Decision history",
        "free": "7 days",
        "plus": "Unlimited",
        "pro": "Unlimited"
      },
      {"feature": "Time Machine Mode", "free": "✗", "plus": "✗", "pro": "✓"},
      {
        "feature": "Analytics Dashboard",
        "free": "✗",
        "plus": "Basic",
        "pro": "Advanced"
      },
      {"feature": "1-on-1 Coaching", "free": "✗", "plus": "✗", "pro": "✓"},
      {"feature": "API Access", "free": "✗", "plus": "✗", "pro": "✓"},
      {"feature": "Export to PDF", "free": "✗", "plus": "✓", "pro": "✓"},
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Features',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Free',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Plus',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryLight,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Pro',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Feature rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comparisonFeatures.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
            itemBuilder: (context, index) {
              final feature = comparisonFeatures[index];
              return Container(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        feature["feature"],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureValue(
                        context,
                        feature["free"],
                        Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureValue(
                        context,
                        feature["plus"],
                        AppTheme.primaryLight,
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureValue(
                        context,
                        feature["pro"],
                        AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureValue(BuildContext context, String value, Color color) {
    if (value == "✓") {
      return CustomIconWidget(
        iconName: 'check_circle',
        color: color,
        size: 5.w,
      );
    } else if (value == "✗") {
      return CustomIconWidget(
        iconName: 'cancel',
        color: Colors.grey,
        size: 5.w,
      );
    } else {
      return Text(
        value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: value.contains("Unlimited") ||
                      value.contains("Advanced") ||
                      value.contains("Priority") ||
                      value.contains("VIP")
                  ? color
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: value.contains("Unlimited") ||
                      value.contains("Advanced") ||
                      value.contains("Priority") ||
                      value.contains("VIP")
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
        textAlign: TextAlign.center,
      );
    }
  }
}
