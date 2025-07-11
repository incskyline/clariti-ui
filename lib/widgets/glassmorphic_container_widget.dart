import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ??
                    Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
