import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSectionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> myDecisions;
  final List<Map<String, dynamic>> savedThreads;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const ProfileSectionsWidget({
    super.key,
    required this.myDecisions,
    required this.savedThreads,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSection(
          context,
          title: 'My Decisions',
          icon: 'psychology',
          items: myDecisions,
          onViewAll: () => _navigateToMyDecisions(context),
          itemBuilder: (item) => _buildDecisionItem(context, item),
        ),
        SizedBox(height: 3.h),
        _buildSection(
          context,
          title: 'Saved Threads',
          icon: 'bookmark',
          items: savedThreads,
          onViewAll: () => _navigateToSavedThreads(context),
          itemBuilder: (item) => _buildThreadItem(context, item),
        ),
        SizedBox(height: 3.h),
        _buildSettingsSection(context),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String icon,
    required List<Map<String, dynamic>> items,
    required VoidCallback onViewAll,
    required Widget Function(Map<String, dynamic>) itemBuilder,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            _buildEmptyState(context, title)
          else
            ...items.take(3).map((item) => itemBuilder(item)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: title.contains('Decisions')
                ? 'psychology_alt'
                : 'bookmark_border',
            color: Theme.of(context).colorScheme.outline,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            title.contains('Decisions')
                ? 'No decisions created yet'
                : 'No saved threads yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            title.contains('Decisions')
                ? 'Start your clarity journey by creating your first decision'
                : 'Save interesting threads from the community',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              if (title.contains('Decisions')) {
                Navigator.pushNamed(context, '/create-decision');
              } else {
                Navigator.pushNamed(context, '/community-feed');
              }
            },
            child: Text(
              title.contains('Decisions')
                  ? 'Create Decision'
                  : 'Explore Community',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionItem(
      BuildContext context, Map<String, dynamic> decision) {
    return Dismissible(
      key: Key(decision["id"].toString()),
      background: Container(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        child: CustomIconWidget(
          iconName: 'share',
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
      secondaryBackground: Container(
        color: AppTheme.error.withValues(alpha: 0.1),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.error,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _shareDecision(context, decision);
        } else {
          _deleteDecision(context, decision);
        }
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: _getEmotionColor(decision["emotion"] as String)
                .withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: _getEmotionIcon(decision["emotion"] as String),
            color: _getEmotionColor(decision["emotion"] as String),
            size: 20,
          ),
        ),
        title: Text(
          decision["title"] as String,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: decision["status"] == "Completed"
                        ? AppTheme.success.withValues(alpha: 0.1)
                        : AppTheme.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    decision["status"] as String,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: decision["status"] == "Completed"
                              ? AppTheme.success
                              : AppTheme.warning,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  decision["createdAt"] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: Theme.of(context).colorScheme.outline,
          size: 20,
        ),
        onTap: () => Navigator.pushNamed(context, '/decision-results'),
      ),
    );
  }

  Widget _buildThreadItem(BuildContext context, Map<String, dynamic> thread) {
    return Dismissible(
      key: Key(thread["id"].toString()),
      background: Container(
        color: AppTheme.error.withValues(alpha: 0.1),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: CustomIconWidget(
          iconName: 'bookmark_remove',
          color: AppTheme.error,
          size: 24,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _removeSavedThread(context, thread),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'forum',
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
        ),
        title: Text(
          thread["title"] as String,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'arrow_upward',
                  color: AppTheme.success,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  thread["upvotes"].toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.success,
                      ),
                ),
                SizedBox(width: 3.w),
                CustomIconWidget(
                  iconName: 'comment',
                  color: Theme.of(context).colorScheme.outline,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  thread["comments"].toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  thread["savedAt"] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: Theme.of(context).colorScheme.outline,
          size: 20,
        ),
        onTap: () => Navigator.pushNamed(context, '/thread-detail'),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'settings',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
            leading: CustomIconWidget(
              iconName: 'palette',
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
            title: Text(
              'Theme',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) => onThemeToggle(),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
            leading: CustomIconWidget(
              iconName: 'workspace_premium',
              color: const Color(0xFFFFD700),
              size: 24,
            ),
            title: Text(
              'Upgrade Membership',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              'Unlock premium features',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: Theme.of(context).colorScheme.outline,
              size: 20,
            ),
            onTap: () => Navigator.pushNamed(context, '/membership-upgrade'),
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious':
        return AppTheme.warning;
      case 'hopeful':
        return AppTheme.success;
      case 'overwhelmed':
        return AppTheme.error;
      case 'curious':
        return AppTheme.primaryLight;
      case 'confident':
        return AppTheme.success;
      default:
        return AppTheme.secondary;
    }
  }

  String _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'anxious':
        return 'sentiment_stressed';
      case 'hopeful':
        return 'sentiment_very_satisfied';
      case 'overwhelmed':
        return 'sentiment_very_dissatisfied';
      case 'curious':
        return 'help_outline';
      case 'confident':
        return 'sentiment_satisfied';
      default:
        return 'sentiment_neutral';
    }
  }

  void _navigateToMyDecisions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('My Decisions page coming soon')),
    );
  }

  void _navigateToSavedThreads(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved Threads page coming soon')),
    );
  }

  void _shareDecision(BuildContext context, Map<String, dynamic> decision) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Shared: ${decision["title"]}')),
    );
  }

  void _deleteDecision(BuildContext context, Map<String, dynamic> decision) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Decision'),
        content:
            Text('Are you sure you want to delete "${decision["title"]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted: ${decision["title"]}')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _removeSavedThread(BuildContext context, Map<String, dynamic> thread) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from saved: ${thread["title"]}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thread restored')),
            );
          },
        ),
      ),
    );
  }
}
