import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularWhatIfsWidget extends StatelessWidget {
  final Function(String) onWhatIfTap;

  const PopularWhatIfsWidget({
    super.key,
    required this.onWhatIfTap,
  });

  final List<Map<String, dynamic>> popularWhatIfs = const [
    {
      'question': 'What if I moved out?',
      'category': 'Life Change',
      'color': Color(0xFF6B73FF),
      'icon': Icons.home_outlined,
      'popularity': 89,
    },
    {
      'question': 'What if I told her how I feel?',
      'category': 'Relationships',
      'color': Color(0xFFE91E63),
      'icon': Icons.favorite_outline,
      'popularity': 76,
    },
    {
      'question': 'What if I never text him back?',
      'category': 'Communication',
      'color': Color(0xFFED8936),
      'icon': Icons.message_outlined,
      'popularity': 68,
    },
    {
      'question': 'What if I quit my job?',
      'category': 'Career',
      'color': Color(0xFF48BB78),
      'icon': Icons.work_outline,
      'popularity': 92,
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
            'Popular What-Ifs',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 18.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularWhatIfs.length,
              itemBuilder: (context, index) {
                return _buildPopularWhatIfCard(context, popularWhatIfs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularWhatIfCard(
      BuildContext context, Map<String, dynamic> whatIf) {
    return GestureDetector(
      onTap: () => onWhatIfTap(whatIf['question'] as String),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (whatIf['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    whatIf['icon'] as IconData,
                    color: whatIf['color'] as Color,
                    size: 20,
                  ),
                ),
                Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: (whatIf['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${whatIf['popularity']}%',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: whatIf['color'] as Color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              whatIf['question'] as String,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              whatIf['category'] as String,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
