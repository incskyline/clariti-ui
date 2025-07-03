import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

/// A centralized widget for displaying the Clariti logo consistently across the app
class ClarityLogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool showFallback;
  final Widget? fallbackWidget;

  const ClarityLogoWidget({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.showFallback = true,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context) {
    return _buildClarityLogo();
  }

  Widget _buildClarityLogo() {
    return Container(
      width: width ?? 20.w,
      height: height ?? 20.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF7B2CBF), // Deep purple
            Color(0xFF9D4EDD), // Medium purple
            Color(0xFF6A0C83), // Dark purple
            Color(0xFFBA68C8), // Light purple
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF7B2CBF).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'C',
          style: GoogleFonts.inter(
            fontSize: (width ?? 20.w) * 0.5,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Factory constructor for small logo (e.g., app bar, navigation)
  factory ClarityLogoWidget.small({BoxFit? fit}) {
    return ClarityLogoWidget(
      width: 8.w,
      height: 8.w,
      fit: fit ?? BoxFit.contain,
    );
  }

  /// Factory constructor for medium logo (e.g., splash screen)
  factory ClarityLogoWidget.medium({BoxFit? fit}) {
    return ClarityLogoWidget(
      width: 25.w,
      height: 25.w,
      fit: fit ?? BoxFit.contain,
    );
  }

  /// Factory constructor for large logo (e.g., onboarding, auth screens)
  factory ClarityLogoWidget.large({BoxFit? fit}) {
    return ClarityLogoWidget(
      width: 40.w,
      height: 40.w,
      fit: fit ?? BoxFit.contain,
    );
  }
}
