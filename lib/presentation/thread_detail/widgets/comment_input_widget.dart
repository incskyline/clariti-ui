import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isExpanded;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const CommentInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isExpanded,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final maxLength = 500;
    final currentLength = controller.text.length;
    final canSubmit = controller.text.trim().isNotEmpty && !isSubmitting;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Character Counter (when expanded)
              if (isExpanded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add your thoughts',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '$currentLength/$maxLength',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: currentLength > maxLength * 0.9
                                ? AppTheme.warning
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],

              // Input Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 5.w,
                    backgroundColor:
                        AppTheme.primaryLight.withValues(alpha: 0.1),
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.primaryLight,
                      size: 20,
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Text Input
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 6.h,
                        maxHeight: isExpanded ? 20.h : 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: focusNode.hasFocus
                              ? AppTheme.primaryLight
                              : Theme.of(context).dividerColor,
                          width: focusNode.hasFocus ? 2 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        maxLength: maxLength,
                        maxLines: isExpanded ? 5 : 1,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Share your perspective...',
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          counterText: '',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {
                          // Trigger rebuild to update character counter and submit button state
                          (context as Element).markNeedsBuild();
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // Send Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: canSubmit
                          ? () {
                              HapticFeedback.selectionClick();
                              onSubmit();
                            }
                          : null,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: canSubmit
                              ? AppTheme.primaryLight
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: isSubmitting
                              ? SizedBox(
                                  width: 5.w,
                                  height: 5.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : CustomIconWidget(
                                  iconName: 'send',
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Guidelines (when expanded)
              if (isExpanded) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info_outline',
                        color: AppTheme.primaryLight,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Be supportive and respectful. Your comment will be posted anonymously.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryLight,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
