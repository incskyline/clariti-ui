import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class PromptSuggestionsWidget extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const PromptSuggestionsWidget({
    super.key,
    required this.onSuggestionTap,
  });

  final List<Map<String, dynamic>> suggestions = const [
    {
      'text': 'Need clarity on something important?',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFF6B73FF),
    },
    {
      'text': 'You\'re not alone — someone\'s been where you are.',
      'icon': Icons.people_outline,
      'color': Color(0xFF48BB78),
    },
    {
      'text': 'Start by typing what\'s on your mind.',
      'icon': Icons.psychology_outlined,
      'color': Color(0xFFED8936),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get started',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ...suggestions.map((suggestion) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color:
                          (suggestion['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      suggestion['icon'] as IconData,
                      color: suggestion['color'] as Color,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      suggestion['text'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
