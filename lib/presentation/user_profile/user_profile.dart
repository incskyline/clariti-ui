import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/membership_upgrade_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_sections_widget.dart';
import './widgets/stats_cards_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isDarkMode = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "username": "ClaritySeeker",
    "email": "user@clariti.app",
    "joinDate": "March 2024",
    "membershipTier": "Free", // Free, Plus, Pro
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "stats": {
      "decisionsCreated": 12,
      "communityKarma": 248,
      "favoriteThreads": 8,
      "savedThreads": 15
    }
  };

  final List<Map<String, dynamic>> myDecisions = [
    {
      "id": 1,
      "title": "Should I change my career path?",
      "emotion": "Anxious",
      "createdAt": "2 days ago",
      "status": "Completed"
    },
    {
      "id": 2,
      "title": "Moving to a new city for better opportunities",
      "emotion": "Hopeful",
      "createdAt": "1 week ago",
      "status": "In Progress"
    },
    {
      "id": 3,
      "title": "Starting my own business vs staying employed",
      "emotion": "Overwhelmed",
      "createdAt": "2 weeks ago",
      "status": "Completed"
    }
  ];

  final List<Map<String, dynamic>> savedThreads = [
    {
      "id": 1,
      "title": "How do you handle decision paralysis?",
      "author": "Anonymous",
      "upvotes": 42,
      "comments": 18,
      "savedAt": "3 days ago"
    },
    {
      "id": 2,
      "title": "Best strategies for major life transitions",
      "author": "WisdomSeeker",
      "upvotes": 67,
      "comments": 23,
      "savedAt": "1 week ago"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ProfileHeaderWidget(userData: userData),
            SizedBox(height: 2.h),
            StatsCardsWidget(stats: userData["stats"] as Map<String, dynamic>),
            SizedBox(height: 3.h),
            if (userData["membershipTier"] == "Free") ...[
              MembershipUpgradeWidget(),
              SizedBox(height: 3.h),
            ],
            ProfileSectionsWidget(
              myDecisions: myDecisions,
              savedThreads: savedThreads,
              onThemeToggle: _toggleTheme,
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Profile',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => _showSettingsBottomSheet(),
          icon: CustomIconWidget(
            iconName: 'settings',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    // In a real app, this would update the app's theme
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Theme switched to ${isDarkMode ? 'Dark' : 'Light'} mode'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            _buildSettingsItem(
              icon: 'palette',
              title: 'Theme',
              subtitle: isDarkMode ? 'Dark Mode' : 'Light Mode',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) => _toggleTheme(),
              ),
            ),
            _buildSettingsItem(
              icon: 'notifications',
              title: 'Notifications',
              subtitle: 'Manage your notification preferences',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Notifications settings coming soon')),
                );
              },
            ),
            _buildSettingsItem(
              icon: 'privacy_tip',
              title: 'Privacy',
              subtitle: 'Control your privacy settings',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings coming soon')),
                );
              },
            ),
            _buildSettingsItem(
              icon: 'help_outline',
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support coming soon')),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: trailing ??
          CustomIconWidget(
            iconName: 'chevron_right',
            color: Theme.of(context).colorScheme.outline,
            size: 20,
          ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
    );
  }
}
