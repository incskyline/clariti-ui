import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/feature_comparison_widget.dart';
import './widgets/pricing_card_widget.dart';
import './widgets/upgrade_header_widget.dart';

class MembershipUpgrade extends StatefulWidget {
  const MembershipUpgrade({super.key});

  @override
  State<MembershipUpgrade> createState() => _MembershipUpgradeState();
}

class _MembershipUpgradeState extends State<MembershipUpgrade>
    with TickerProviderStateMixin {
  bool isYearly = false;
  int selectedTier = 1; // 0: Free, 1: Plus, 2: Pro
  bool isLoading = false;
  bool showFeatureComparison = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> membershipTiers = [
    {
      "id": 0,
      "name": "Free",
      "monthlyPrice": "\$0",
      "yearlyPrice": "\$0",
      "description": "Perfect for getting started",
      "features": [
        "Basic What If scenarios",
        "3 decisions per day",
        "Community access",
        "Basic emotions tracking"
      ],
      "color": Color(0xFF718096),
      "isPopular": false,
      "trialDays": 0
    },
    {
      "id": 1,
      "name": "Plus",
      "monthlyPrice": "\$9.99",
      "yearlyPrice": "\$99.99",
      "description": "Enhanced decision-making tools",
      "features": [
        "Unlimited What If scenarios",
        "Advanced emotion insights",
        "Priority community support",
        "Decision history tracking",
        "Export decisions as PDF"
      ],
      "color": Color(0xFF6B73FF),
      "isPopular": true,
      "trialDays": 7
    },
    {
      "id": 2,
      "name": "Pro",
      "monthlyPrice": "\$19.99",
      "yearlyPrice": "\$199.99",
      "description": "Complete clarity experience",
      "features": [
        "Everything in Plus",
        "Time Machine Mode",
        "Advanced Analytics Dashboard",
        "1-on-1 Decision Coaching",
        "Custom emotion categories",
        "API access for integrations"
      ],
      "color": Color(0xFF9B59B6),
      "isPopular": false,
      "trialDays": 14
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePurchase() async {
    if (selectedTier == 0) return;

    setState(() {
      isLoading = true;
    });

    // Simulate purchase process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // Show success animation
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.success,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Welcome to ${membershipTiers[selectedTier]["name"]}!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Your premium features are now unlocked',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header with close button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upgrade Membership',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upgrade benefits header
                      UpgradeHeaderWidget(),

                      SizedBox(height: 3.h),

                      // Monthly/Yearly toggle
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isYearly = false),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: !isYearly
                                        ? AppTheme.primaryLight
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Monthly',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: !isYearly
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isYearly = true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: isYearly
                                        ? AppTheme.primaryLight
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Yearly',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: isYearly
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                            ),
                                      ),
                                      if (isYearly)
                                        Text(
                                          'Save 20%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Pricing cards
                      SizedBox(
                        height: 45.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: membershipTiers.length,
                          itemBuilder: (context, index) {
                            final tier = membershipTiers[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < membershipTiers.length - 1
                                    ? 4.w
                                    : 0,
                              ),
                              child: PricingCardWidget(
                                tier: tier,
                                isSelected: selectedTier == index,
                                isYearly: isYearly,
                                onTap: () =>
                                    setState(() => selectedTier = index),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Feature comparison toggle
                      GestureDetector(
                        onTap: () => setState(() =>
                            showFeatureComparison = !showFeatureComparison),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Compare Features',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              CustomIconWidget(
                                iconName: showFeatureComparison
                                    ? 'expand_less'
                                    : 'expand_more',
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 6.w,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Feature comparison table
                      if (showFeatureComparison) ...[
                        SizedBox(height: 2.h),
                        FeatureComparisonWidget(
                            membershipTiers: membershipTiers),
                      ],

                      SizedBox(height: 4.h),

                      // Terms and privacy links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Terms of Service',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Privacy Policy',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),

              // Bottom purchase section
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Restore purchases link
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Restore Purchases',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryLight,
                            ),
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Upgrade button
                    SizedBox(
                      width: double.infinity,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: selectedTier == 0 ? null : _handlePurchase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedTier == 0
                              ? Theme.of(context).colorScheme.outline
                              : AppTheme.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                selectedTier == 0
                                    ? 'Current Plan'
                                    : membershipTiers[selectedTier]
                                                ["trialDays"] >
                                            0
                                        ? 'Start ${membershipTiers[selectedTier]["trialDays"]}-Day Free Trial'
                                        : 'Upgrade to ${membershipTiers[selectedTier]["name"]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                              ),
                      ),
                    ),

                    if (selectedTier > 0 &&
                        membershipTiers[selectedTier]["trialDays"] > 0) ...[
                      SizedBox(height: 1.h),
                      Text(
                        'Free for ${membershipTiers[selectedTier]["trialDays"]} days, then ${isYearly ? membershipTiers[selectedTier]["yearlyPrice"] : membershipTiers[selectedTier]["monthlyPrice"]}/${isYearly ? "year" : "month"}',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
