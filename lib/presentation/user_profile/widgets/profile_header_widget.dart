import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile picture with fallback to Clariti logo
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: userData["avatar"],
                width: 25.w,
                height: 25.w,
                fit: BoxFit.cover,
                errorWidget: ClarityLogoWidget(
                  width: 25.w,
                  height: 25.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Username
          Text(
            userData["username"] ?? "Clariti User",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          SizedBox(height: 1.h),

          // Member since
          Text(
            'Member since ${userData["joinDate"] ?? "Unknown"}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),

          SizedBox(height: 2.h),

          // Membership tier badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getMembershipColors(userData["membershipTier"]),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${userData["membershipTier"]} Member',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getMembershipColors(String? tier) {
    switch (tier?.toLowerCase()) {
      case 'pro':
        return [Color(0xFFFFD700), Color(0xFFFFA500)]; // Gold gradient
      case 'plus':
        return [Color(0xFF9C27B0), Color(0xFF673AB7)]; // Purple gradient
      default:
        return [Color(0xFF4CAF50), Color(0xFF8BC34A)]; // Green gradient
    }
  }
}
