import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodOfDayWidget extends StatelessWidget {
  final String currentMood;
  final int percentage;

  const MoodOfDayWidget({
    super.key,
    this.currentMood = 'Curious',
    this.percentage = 68,
  });

  Color get moodColor {
    switch (currentMood.toLowerCase()) {
      case 'calm':
        return const Color(0xFF48BB78);
      case 'anxious':
        return const Color(0xFF805AD5);
      case 'curious':
        return const Color(0xFFECC94B);
      case 'hopeful':
        return const Color(0xFFED8936);
      case 'confused':
        return const Color(0xFF6B73FF);
      case 'excited':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF6B73FF);
    }
  }

  IconData get moodIcon {
    switch (currentMood.toLowerCase()) {
      case 'calm':
        return Icons.spa_outlined;
      case 'anxious':
        return Icons.psychology_outlined;
      case 'curious':
        return Icons.search_outlined;
      case 'hopeful':
        return Icons.trending_up_outlined;
      case 'confused':
        return Icons.help_outline;
      case 'excited':
        return Icons.star_outline;
      default:
        return Icons.psychology_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: moodColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: moodColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            moodIcon,
            color: moodColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Most users today feel: $currentMood',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: moodColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$percentage%',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: moodColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
